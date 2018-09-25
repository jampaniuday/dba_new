--WHENEVER SQLERROR EXIT SQL.SQLCODE

@defines.sql
--@pre_migration.sql


define region_file=01_Region.csv 
define zone_file=02_Zones.csv
define ccy_file=03_CCY.csv
define ccypair_file=04_CCYPairs.csv
define PB_file=05_PB.csv
define Client_file=06_Client_file.csv
define EB_as_Client_file=06b_EB_as_Client_file.csv
define EB_file=07_EB_file.csv
define ECN_file=08_ECN_file.csv
define Fund_file=09_Fund_file.csv
define TR_file=10_TR_File.csv
define Traders_file=11_traders.csv
define portfolio_file=12_portfolio.csv
define credit_file=17_credit.csv
define Nameing_file=19_Create_Back_Office_Naming
define ccy_auth_file=17b_Create_Client_CCY_Pair_Auth

-- Get propety Keys: 
variable region_key             number
variable recon_stale_key        number
variable alocation_stale_key    number
variable account_key number
variable external_name_key number

BEGIN
-- Get propety Keys: 

    select key into :region_key             
    from ^DB_SCHEMA..sd_dm_data where value='Region'                        and group_id = (select id from ^DB_SCHEMA..sd_Dm_group where class_id=408048);  

    select key into :recon_stale_key        
    from ^DB_SCHEMA..sd_dm_data where value='Reconciliation Stale Timeout'  and group_id = (select id from ^DB_SCHEMA..sd_Dm_group where class_id=408048);  

    select key into :alocation_stale_key    
    from ^DB_SCHEMA..sd_dm_data where value='Allocation Stale Timeout'      and group_id = (select id from ^DB_SCHEMA..sd_Dm_group where class_id=408048);  

    -- Get account key 
    SELECT ID into :account_key 
    FROM ^DB_SCHEMA..SD_DM_GROUP WHERE CLASS_ID = ^CLASS_ACCOUNT   AND NAMER_ID = ^PRIME_ORG;

    -- Get organization external name data mapping  key 
    SELECT ID into :external_name_key  FROM ^DB_SCHEMA..SD_DM_GROUP WHERE CLASS_ID = ^CLASS_ORG   AND NAMER_ID = ^PRIME_ORG;
END;
/


prompt **************************
prompt Regions
prompt **************************
spool ^region_file

select 
    '^string'||     data    /*REGION*/
    ||'^string'  
from 
    ^DB_SCHEMA..arch_code_member
where group_id = (SELECT ID fROM ^DB_SCHEMA..ARCH_CODE_GROUP WHERE NAME = 'OrgRegion')
  and data<>'NYK'
;
 

spool off

prompt **************************
prompt Cutoff timeZones
prompt **************************
spool ^zone_file

SELECT 
    '^string'||         ZONE        /*zone*/  
    ||'^delimiter'||    min(time)   /*TIME*/
    ||'^string'
from ^DB_SCHEMA..FXPB_CUT_OFF_TIMES
group by zone;

spool off 



prompt **************************
prompt PB
prompt **************************
spool ^PB_file

select
    '^string'||         org.name            		/*Full Name*/ 
    ||'^delimiter'||    ext_name.external_value		/*external name*/    
    ||'^delimiter'||    account_dm.external_value	/*Account*/ 
    ||'^delimiter'||    r.value             		/*region*/
    ||'^string'  
from 
    ^DB_SCHEMA..a_organization org, 
    ^DB_SCHEMA..v_arch_data_mapping ext_name,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT o2o,
    ^DB_SCHEMA..A_ACCOUNT A,
    ^DB_SCHEMA..v_arch_data_mapping ACCOUNT_DM,
    ^DB_SCHEMA..A_STATE_DETAIL s,
    ^DB_SCHEMA..arch_object_props r
where org.role= ^ROLE_PB
  -- Get External name
  and ORG.ID = EXT_NAME.internal_value 
  and EXT_NAME.map_type = ^MAP_PB
  and EXT_NAME.namer_id = ^PRIME_ORG 
  -- get master account
  and o2o.from_object_id=org.id 
  and  o2o.FROM_OBJECT_TYPE = ^TYPE_ORG
  AND o2o.TO_OBJECT_TYPE = ^TYPE_ACCOUNT
  AND o2o.TO_OBJECT_ID = A.ID 
  and o2o.relation = 1
  and ACCOUNT_DM.internal_value = A.ID
  and ACCOUNT_DM.map_type = ^MAP_ACCOUNT
  and ACCOUNT_DM.namer_id = ^PRIME_ORG 
  -- Enabled
  and A.STATE_ID = s.STATE_ID 
  and s.status_value = 1
  -- get region
  and org.id=r.object_id (+)
  and r.object_type(+)=^TYPE_ORG
  and r.code_id(+)= :region_key
order by org.name  
; 
  
     
spool off


prompt **************************
prompt Clients
prompt **************************
spool ^Client_file

select
    '^string'  ||       org.name||conf.txt     		/*Full Name*/ 
    ||'^delimiter'||    ext_name.external_value	    /*external name*/    
    ||'^delimiter'||    account_dm.external_value   /*Account*/ 
    ||'^delimiter'||    r.value             /*region*/ 
    ||'^delimiter'||    decode(booking.value, 
                                'true', 1, 
                                'false', 0, 
                                null)       /*suppress booking*/ 
    ||'^delimiter'||    recon.value         /*recon stale timeout*/ 
    ||'^delimiter'||    stale.value         /*aloc stale timeout*/
    ||'^string'  
from 
    ^DB_SCHEMA..a_organization org, 
    ^DB_SCHEMA..v_arch_data_mapping ext_name,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT o2o,
    ^DB_SCHEMA..A_ACCOUNT A,
    ^DB_SCHEMA..v_arch_data_mapping ACCOUNT_DM,
    ^DB_SCHEMA..A_STATE_DETAIL s,
    ^DB_SCHEMA..arch_object_props r,
    ^DB_SCHEMA..arch_object_props stale,
    ^DB_SCHEMA..arch_object_props recon,
    ^DB_SCHEMA..arch_object_props booking, 
	fund_clients_conflict conf
where org.role= ^ROLE_CLIENT
  -- Get External name
  and ORG.ID = EXT_NAME.internal_value 
  and EXT_NAME.map_type = ^MAP_CLIENT
  and EXT_NAME.namer_id = ^PRIME_ORG 
  and EXT_NAME.type = 0
  -- get master account
  and o2o.from_object_id=org.id 
  and  o2o.FROM_OBJECT_TYPE = ^TYPE_ORG
  AND o2o.TO_OBJECT_TYPE = ^TYPE_ACCOUNT
  AND o2o.TO_OBJECT_ID = A.ID 
  and o2o.relation = 1 
  and ACCOUNT_DM.internal_value = A.ID
  and ACCOUNT_DM.map_type = ^MAP_ACCOUNT
  and ACCOUNT_DM.namer_id = ^PRIME_ORG 
  -- Enabled
  and A.STATE_ID = s.STATE_ID 
  and s.status_value = 1
  -- get region
  and org.id=r.object_id (+)
  and r.object_type(+) = ^TYPE_ORG
  and r.code_id(+) = :region_key 
  -- get recon stale timeout
  and org.id=recon.object_id (+)
  and recon.object_type(+)= ^TYPE_ORG
  and recon.code_id(+) = :recon_stale_key 
  -- get  alloc stale timeout
  and org.id=stale.object_id (+)
  and stale.object_type(+) = ^TYPE_ORG
  and stale.code_id(+) = :alocation_stale_key 
  -- get suppress booking messages
  and org.id=booking.object_id (+)
  and booking.object_type(+) = ^TYPE_ORG
  and booking.code_id(+)=1100024
  -- connect to external_name conflict resolution 
  and org.id = conf.client_id(+)
order by org.name  
; 
  
     
spool off


prompt **************************
prompt EB as clients
prompt **************************

spool ^EB_as_Client_file

select
    '^string'  ||       org.name            		/*Full Name*/ 
    ||'^delimiter'||    ext_name.external_value     /*external name*/    
    ||'^delimiter'||    account_dm.external_value   /*Account*/ 
    ||'^delimiter'||    r.value             /*region*/ 
    ||'^delimiter'||    decode(booking.value, 
                                'true', 1, 
                                'false', 0, 
                                null)       /*suppress booking*/ 
    ||'^delimiter'||    recon.value         /*recon stale timeout*/ 
    ||'^delimiter'||    NULL                /*aloc stale timeout*/
    ||'^string'  
from 
    ^DB_SCHEMA..a_organization org, 
    ^DB_SCHEMA..v_arch_data_mapping ext_name,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT o2o,
    ^DB_SCHEMA..A_ACCOUNT A,
    ^DB_SCHEMA..v_arch_data_mapping ACCOUNT_DM,
    ^DB_SCHEMA..A_STATE_DETAIL s,
    ^DB_SCHEMA..arch_object_props r,
    ^DB_SCHEMA..arch_object_props stale,
    ^DB_SCHEMA..arch_object_props recon,
    ^DB_SCHEMA..arch_object_props booking
where org.role= ^ROLE_BANK
  -- Get External name
  and ORG.ID = EXT_NAME.internal_value 
  and EXT_NAME.map_type = ^MAP_EB
  and EXT_NAME.namer_id = ^PRIME_ORG 
  and EXT_NAME.type = 0  
  and ext_name.external_value in (select EB_AS_CLIENT_NAME from EB_AS_CLIENTS)
  -- get master account
  and o2o.from_object_id=org.id 
  and o2o.FROM_OBJECT_TYPE = ^TYPE_ORG
  AND o2o.TO_OBJECT_TYPE = ^TYPE_ACCOUNT
  AND o2o.TO_OBJECT_ID = A.ID 
  and o2o.relation = 1
  and ACCOUNT_DM.internal_value = A.ID
  and ACCOUNT_DM.map_type = ^MAP_ACCOUNT
  and ACCOUNT_DM.namer_id = ^PRIME_ORG 
  -- Enabled
  and A.STATE_ID = s.STATE_ID 
  and s.status_value = 1
  -- get region
  and org.id=r.object_id (+)
  and r.object_type(+) = ^TYPE_ORG
  and r.code_id(+) = :region_key 
  -- get recon stale timeout
  and org.id=recon.object_id (+)
  and recon.object_type(+)= ^TYPE_ORG
  and recon.code_id(+) = :recon_stale_key 
  -- get  alloc stale timeout
  and org.id=stale.object_id (+)
  and stale.object_type(+) = ^TYPE_ORG
  and stale.code_id(+) = :alocation_stale_key 
  -- get suppress booking messages
  and org.id=booking.object_id (+)
  and booking.object_type(+) = ^TYPE_ORG
  and booking.code_id(+)=1100024
; 
  
     
spool off


prompt **************************
prompt EB
prompt **************************
spool ^EB_file

select
    '^string'  ||       org.name            		/*Full Name*/ 
    ||'^delimiter'||    ext_name.external_value     /*external name*/    
    ||'^delimiter'||    account_dm.external_value   /*Account*/ 
    ||'^delimiter'|| r.value            /*region*/ 
    ||'^delimiter'|| decode(booking.value, 
                            'true', 1, 
                            'false', 0, 
                            null)       /*suppress booking*/ 
    ||'^delimiter'|| recon.value        /*recon stale timeout*/
    ||'^delimiter'|| stale.value        /*aloc stale timeout*/
    ||'^string'  
from 
    ^DB_SCHEMA..a_organization org, 
    ^DB_SCHEMA..v_arch_data_mapping ext_name,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT o2o,
    ^DB_SCHEMA..A_ACCOUNT A,
    ^DB_SCHEMA..v_arch_data_mapping ACCOUNT_DM,
    ^DB_SCHEMA..A_STATE_DETAIL s,
    ^DB_SCHEMA..arch_object_props r,
    ^DB_SCHEMA..arch_object_props stale,
    ^DB_SCHEMA..arch_object_props recon,
    ^DB_SCHEMA..arch_object_props booking
where org.role= ^ROLE_BANK
  -- Get External name
  and ORG.ID = EXT_NAME.internal_value 
  and EXT_NAME.map_type = ^MAP_EB
  and EXT_NAME.namer_id = ^PRIME_ORG 
  and EXT_NAME.type = 0  
  and ext_name.external_value not in (select EB_AS_CLIENT_NAME from EB_AS_CLIENTS)
  -- get master account
  and o2o.from_object_id=org.id 
  and  o2o.FROM_OBJECT_TYPE = ^TYPE_ORG
  AND o2o.TO_OBJECT_TYPE = ^TYPE_ACCOUNT
  AND o2o.TO_OBJECT_ID = A.ID 
  and o2o.relation = 1
  and ACCOUNT_DM.internal_value = A.ID
  and ACCOUNT_DM.map_type = ^MAP_ACCOUNT
  and ACCOUNT_DM.namer_id = ^PRIME_ORG 
  -- Enabled
  and A.STATE_ID = s.STATE_ID 
  and s.status_value = 1
  -- get region
  and org.id=r.object_id (+)
  and r.object_type(+) = ^TYPE_ORG
  and r.code_id(+) = :region_key 
  -- get recon stale timeout
  and org.id=recon.object_id (+)
  and recon.object_type(+)= ^TYPE_ORG
  and recon.code_id(+) = :recon_stale_key 
  -- get  alloc stale timeout
  and org.id=stale.object_id (+)
  and stale.object_type(+) = ^TYPE_ORG
  and stale.code_id(+) = :alocation_stale_key 
  -- get suppress booking messages
  and org.id=booking.object_id (+)
  and booking.object_type(+) = ^TYPE_ORG
  and booking.code_id(+)=1100024
order by org.name
; 
     
spool off


prompt **************************
prompt ECN
prompt **************************

spool ^ECN_file

select
    '^string'  ||       org.name /*Full Name*/ 
    ||'^delimiter'||    ext_name.external_value /*external name*/    
    ||'^delimiter'||    ACCOUNT_DM.external_value /*Account*/ 
    ||'^delimiter'||    'NYK' /*region*/
    ||'^string'  
from 
    ^DB_SCHEMA..a_organization org, 
    ^DB_SCHEMA..v_arch_data_mapping ext_name,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT o2o,
    ^DB_SCHEMA..A_ACCOUNT A,
    ^DB_SCHEMA..v_arch_data_mapping ACCOUNT_DM,
    ^DB_SCHEMA..A_STATE_DETAIL s
where org.role = ^ROLE_ECN
  -- Get External name
  and ORG.ID = EXT_NAME.internal_value
  and EXT_NAME.map_type = ^MAP_ECN
  and EXT_NAME.namer_id = ^PRIME_ORG
  and EXT_NAME.type = 0  
  -- get master account
  and o2o.from_object_id=org.id 
  and  o2o.FROM_OBJECT_TYPE = ^TYPE_ORG
  AND o2o.TO_OBJECT_TYPE = ^TYPE_ACCOUNT
  AND o2o.TO_OBJECT_ID = A.ID 
  and o2o.relation = 1
  and ACCOUNT_DM.internal_value = A.ID
  and ACCOUNT_DM.map_type = ^MAP_ACCOUNT
  AND ACCOUNT_DM.NAMER_ID = ^PRIME_ORG
  -- Enabled
  and A.STATE_ID = s.STATE_ID 
  and s.status_value = 1 
;
     
spool off


prompt **************************
prompt FUNDS
prompt **************************
spool ^Fund_file

select
    '^string'  ||       ec.external_value            /* parent client (External)*/ 
    ||'^delimiter'||    ext_name.external_value      /*fund external name*/    
    ||'^delimiter'||    account_dm.external_value    /*Account*/ 
    ||'^delimiter'||    r.value             /*region*/
    ||'^delimiter'||    decode(booking.value, 
                                'true', 1, 
                                'false', 0, 
                                null)       /*suppress booking*/ 
    ||'^string'  
from 
    ^DB_SCHEMA..a_organization FUND, 
    ^DB_SCHEMA..v_arch_data_mapping ext_name,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT o2o,
    ^DB_SCHEMA..A_ACCOUNT A,
    ^DB_SCHEMA..v_arch_data_mapping ACCOUNT_DM,
    ^DB_SCHEMA..A_STATE_DETAIL s,
    ^DB_SCHEMA..A_STATE_DETAIL client_status,
    ^DB_SCHEMA..arch_object_props r,
    ^DB_SCHEMA..a_organization client,
    ^DB_SCHEMA..v_arch_data_mapping ec,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c,
    ^DB_SCHEMA..arch_object_props booking
where FUND.role = ^ROLE_FUND
  -- Get Fund External name
  and FUND.ID = EXT_NAME.internal_value 
  and EXT_NAME.map_type = ^MAP_FUND
  and EXT_NAME.namer_id = ^PRIME_ORG
  and EXT_NAME.type = 0  
  -- Get Client External name
  and client.ID = ec.internal_value 
  and ec.map_type = ^MAP_CLIENT
  and ec.namer_id = ^PRIME_ORG
  and ec.type = 0    
  -- get master account
  and o2o.from_object_id=FUND.id 
  and o2o.FROM_OBJECT_TYPE = ^TYPE_ORG
  AND o2o.TO_OBJECT_TYPE = ^TYPE_ACCOUNT
  AND o2o.TO_OBJECT_ID = A.ID 
  and o2o.relation = 1
  and ACCOUNT_DM.internal_value = A.ID
  and ACCOUNT_DM.map_type = ^MAP_ACCOUNT
  AND ACCOUNT_DM.NAMER_ID = ^PRIME_ORG
  -- Enabled
  and A.STATE_ID = s.STATE_ID 
  and s.status_value = 1
  -- get region
  and FUND.id=r.object_id (+)
  and r.object_type(+) = ^TYPE_ORG
  and r.code_id(+) = 1100011 -- fund reagion key  
  -- Get parent org
  and FUND.id = F2C.TO_OBJECT_ID
  and f2c.to_object_type = ^TYPE_ORG
  and F2C.FROM_OBJECT_ID = client.id
  and F2C.FROM_OBJECT_type = ^TYPE_ORG
  and client.role = ^ROLE_CLIENT
  and client.name not in (SELECT EB_AS_CLIENT_NAME FROM EB_AS_CLIENTS) --ignore eb as client
  -- client is enable 
  and client_status.state_id = client.state_id 
  and client_status.status_value = 1
  -- get suppress booking messages
  and client.id=booking.object_id (+)
  and booking.object_type(+) = ^TYPE_ORG
  and booking.code_id(+)=1100024
order by
  ec.external_value, 
  ext_name.external_value 
;  

spool off

prompt **************************
prompt Trading Relationship : 
prompt **************************
spool ^TR_File

select /*+ ALL_ROWS */
         '^string'||    client_name.external_value     /*client external name*/    
    ||'^delimiter'||    pb_name.external_value         /*PB external name*/            
    ||'^delimiter'||    eb_name.external_value         /*EB external name*/            
    ||'^delimiter'||    case when EaC.EB_AS_CLIENT_NAME is not null Then 'CLIENT' --EB as Client 
							 WHEN AC.ID<>6250672 THEN  agreement.external_value  
							 ELSE 'PB'  --> Due to an account definnition issue this acount is "hard coded"
                        end             /*AGRTYPE*/
    ||'^string'  
from 
    ^DB_SCHEMA..a_organization pb,
    ^DB_SCHEMA..a_organization eb,
    ^DB_SCHEMA..a_organization client,
    ^DB_SCHEMA..a_state_detail pb_s,
    ^DB_SCHEMA..a_state_detail eb_s,
    ^DB_SCHEMA..a_state_detail client_s,
    ^DB_SCHEMA..v_arch_data_mapping pb_name,
    ^DB_SCHEMA..v_arch_data_mapping eb_name,
    ^DB_SCHEMA..v_arch_data_mapping client_name,
    ^DB_SCHEMA..a_triple_account ac3,
    ^DB_SCHEMA..a_account ac, 
    ^DB_SCHEMA..v_arch_data_mapping agreement, 
    EB_AS_CLIENTS EaC
	--(select null EB_AS_CLIENT_NAME from dual ) EaC
where AC3.ACCOUNT_ID = ac.id
  -- connect tripled acount to enabled clients
  and AC3.COUPLED_OWNER_ROLE = ^ROLE_CLIENT
  and AC3.COUPLED_OWNER_ORG_ID = CLIENT.ID
  and client.role = ^ROLE_CLIENT
  and client.state_id = client_s.state_id 
  and client_s.status_value = 1
  and client.id = client_name.internal_value  
  and client_name.map_type = ^MAP_CLIENT
  and client_name.namer_id = ^PRIME_ORG
  and client_name.type = 0
  -- Bank 
  and AC3.COUPLED_ORG_ID = eb.id
  and eb.role = ^ROLE_BANK
  and eb.state_id = eb_s.state_id 
  and eb_s.status_value = 1
  and eb.id = eb_name.internal_value  
  and eb_name.map_type = ^MAP_EB
  and eb_name.namer_id = ^PRIME_ORG
  and eb_name.type = 0  
  -- PB 
  and AC3.PB_ORG_ID = pb.id 
  and pb.role = ^ROLE_PB
  and pb.state_id = pb_s.state_id 
  and pb_s.status_value = 1
  and pb.id = pb_name.internal_value  
  and pb_name.map_type = ^MAP_PB
  and pb_name.namer_id = ^PRIME_ORG
  and pb_name.type = 0  
  -- Agreement 
  and AC.AGREEMENT_TYPE = AGREEMENT.internal_value
  and AGREEMENT.map_type = ^MAP_AGGREMENT
  and AGREEMENT.namer_id  = ^PRIME_ORG
  -- EB as Client 
  and client.name =  EaC.EB_AS_CLIENT_NAME (+)
order by 
	client_name.external_value, 
	pb_name.external_value,
	eb_name.external_value 
;

spool off

prompt **************************
prompt Traders
prompt **************************
spool ^Traders_file

select
          '^string'  || ext_name.external_value	/*Clien Name*/
       ||'^delimiter'|| dm.external_value		/* Trader external value */
       ||'^delimiter'|| emails.MAIL_TO			/* Trader email*/
       ||'^delimiter'|| phone.value				/* Trader phone no. */
--       ||'^delimiter'|| rgn.value				/* Trader region*/
       ||'^string' 
from
     ^DB_SCHEMA..a_organization org,
     ^DB_SCHEMA..v_arch_data_mapping ext_name,
     ^DB_SCHEMA..sd_security_user prsn,
     ^DB_SCHEMA..a_state_detail stt,
     ^DB_SCHEMA..v_arch_data_mapping dm,
     (select distinct
             prsn2adrs.from_object_id,
             mail.mail_to
     from
             ^DB_SCHEMA..a_object_2_object prsn2adrs,
             ^DB_SCHEMA..sd_address adrs,
             ^DB_SCHEMA..sd_address_out_mail mail
     where
              prsn2adrs.to_object_id=adrs.id  and
              prsn2adrs.to_object_type = ^TYPE_EMAIL and prsn2adrs.from_object_type = ^TYPE_PERSON and
              adrs.id=mail.address_id
     )  emails,
     ^DB_SCHEMA..arch_object_props phone,
     ^DB_SCHEMA..arch_object_props rgn
where org.role= ^ROLE_CLIENT    
  -- Get External name
  and ORG.ID = EXT_NAME.internal_value 
  and ext_name.map_type = ^MAP_CLIENT
  and ext_name.namer_id = ^PRIME_ORG
  and ext_name.type = 0
  and prsn.parent_org_id = org.id
  -- match email to person
  and prsn.id=emails.from_object_id (+) 
  -- Trader external value
  and prsn.id=dm.internal_value 
  and dm.NAMER_ID = ^PRIME_ORG 
  and dm.map_type = ^MAP_TRADER 
  and dm.type = 0
  -- enabled traders 
  and prsn.state_id = stt.state_id 
  and stt.status_value = 1
  -- phone number
  and prsn.id=phone.object_id(+) 
  and phone.object_type(+) = ^TYPE_PERSON 
  and phone.code_id(+) = 1100012 
  -- get region
  and prsn.id = rgn.object_id(+) 
  and rgn.object_type(+) = ^TYPE_PERSON 
  and rgn.code_id(+) = :region_key 
  -- traders only
  and prsn.TYPE = 2 
 order by ext_name.external_value
;

  
spool off



prompt **************************
prompt Portfolio
prompt **************************
spool ^portfolio_file

select
    '^string'     ||    ext_name.external_value 
    ||'^delimiter'||    n.external_value    /* portfolio name */ 
    ||'^delimiter'||    p.description       /* portfolio description */
    ||'^string'  
from 
    ^DB_SCHEMA..a_organization org,
    ^DB_SCHEMA..v_arch_data_mapping ext_name, 
    ^DB_SCHEMA..A_STATE_DETAIL s,
    ^DB_SCHEMA..FXPB_PORTFOLIO p, 
    ^DB_SCHEMA..v_arch_data_mapping n
where org.role = ^ROLE_CLIENT
  -- Get External name
  and org.ID = EXT_NAME.internal_value 
  and ext_name.map_type = ^MAP_CLIENT
  and ext_name.namer_id = ^PRIME_ORG
  and ext_name.type = 0
  -- Enabled client
  and org.STATE_ID = s.STATE_ID 
  and s.status_value = 1
  -- link to enabled portfolio
  and org.id = P.ORGANIZATION_ID
  and P.STATUS = 1 -- enabled
  -- get portfolio name
  and p.id = n.internal_value
  and n.map_type = ^MAP_POTFOLIO
  and n.namer_id = ^PRIME_ORG
order by ext_name.internal_value  
;  

spool off


prompt **************************
prompt Client Credit
prompt **************************
spool ^credit_file


WITH 
	spot as (
		select internal_value 
		from ^DB_SCHEMA..v_arch_data_mapping 
		where map_type = ^MAP_FINANCIAL_PROPERTIES 
		  AND namer_id= ^PRIME_ORG 
		  AND EXTERNAL_VALUE = 'Spot/Forward FX'
	),
	Vanilla as (
		select internal_value 
		from ^DB_SCHEMA..v_arch_data_mapping 
		where map_type = ^MAP_FINANCIAL_PROPERTIES 
		  AND namer_id= ^PRIME_ORG 
		  AND EXTERNAL_VALUE = 'Vanilla Enabled'
	),
	barrier as (
		select internal_value 
		from ^DB_SCHEMA..v_arch_data_mapping 
		where map_type = ^MAP_FINANCIAL_PROPERTIES 
		  AND namer_id= ^PRIME_ORG 
		  AND EXTERNAL_VALUE = 'Barrier Enabled'
	),
	double_barrier as (
		select internal_value 
		from ^DB_SCHEMA..v_arch_data_mapping 
		where map_type = ^MAP_FINANCIAL_PROPERTIES 
		  AND namer_id= ^PRIME_ORG 
		  AND EXTERNAL_VALUE = 'Double Barrier Enabled'
	),
	digital  as (
		select internal_value 
		from ^DB_SCHEMA..v_arch_data_mapping 
		where map_type = ^MAP_FINANCIAL_PROPERTIES 
		  AND namer_id= ^PRIME_ORG 
		  AND EXTERNAL_VALUE = 'Digital Enabled'
	)	
select 
    '^string'     ||    EXT_NAME.EXTERNAL_VALUE  /*external name*/ 
	||'^delimiter'||    ACCOUNT_DM.EXTERNAL_VALUE/*IRFE master account */ 
    ||'^delimiter'||    SP.VALUE        /* spot */ 
    ||'^delimiter'||    v.value         /* vanilla */
    ||'^delimiter'||    b.value         /* barrier */ 
    ||'^delimiter'||    db.value        /* double barrier*/ 
    ||'^delimiter'||    d.value         /* digital */ 
    ||'^string'  
from 
    ^DB_SCHEMA..a_organization org,
    ^DB_SCHEMA..A_STATE_DETAIL s,
    ^DB_SCHEMA..v_arch_data_mapping ext_name, 
    ^DB_SCHEMA..ARCH_OBJECT_PROPS sp, 
    ^DB_SCHEMA..ARCH_OBJECT_PROPS v, 
    ^DB_SCHEMA..ARCH_OBJECT_PROPS b,
    ^DB_SCHEMA..ARCH_OBJECT_PROPS db, 
    ^DB_SCHEMA..ARCH_OBJECT_PROPS d,
	^DB_SCHEMA..A_OBJECT_2_OBJECT o2o,
    ^DB_SCHEMA..A_ACCOUNT Acc,
    ^DB_SCHEMA..v_arch_data_mapping ACCOUNT_DM, 
	spot,
	Vanilla,
	barrier,
	double_barrier,
	digital
where org.role = ^ROLE_CLIENT
  -- Get External name
  and org.ID = EXT_NAME.internal_value 
  and ext_name.map_type = ^MAP_CLIENT
  and ext_name.namer_id = ^PRIME_ORG
  and ext_name.type = 0 
  -- Enabled client
  and org.STATE_ID = s.STATE_ID 
  and s.status_value = 1
     -- get master account
  and o2o.from_object_id=org.id 
  and o2o.FROM_OBJECT_TYPE = ^TYPE_ORG
  AND o2o.TO_OBJECT_TYPE = ^TYPE_ACCOUNT
  AND o2o.TO_OBJECT_ID = Acc.ID 
  and o2o.relation = 1
  and ACCOUNT_DM.internal_value = Acc.ID
  AND ACCOUNT_DM.NAMER_ID = ^PRIME_ORG
  AND ACCOUNT_DM.map_type = ^MAP_ACCOUNT
  -- spot
  and org.id = sp.object_id
  and sp.object_type = ^TYPE_ORG
  and SP.CODE_ID = spot.internal_value
  -- vanilla
  and org.id = v.object_id
  and v.object_type = ^TYPE_ORG
  and v.CODE_ID = Vanilla.internal_value
  -- barrier
  and org.id = b.object_id
  and b.object_type = ^TYPE_ORG
  and b.CODE_ID = barrier.internal_value
  -- double barrier
  and org.id = db.object_id
  and db.object_type = ^TYPE_ORG
  and db.CODE_ID = double_barrier.internal_Value
  -- Digital 
  and org.id = d.object_id
  and d.object_type = ^TYPE_ORG
  and d.CODE_ID = digital.internal_Value
order by ext_name.external_value       
;  

spool off




