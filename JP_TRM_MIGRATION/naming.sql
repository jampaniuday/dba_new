

define Gapp_Nameing_file		= 19_Create_Back_Office_Naming.csv
define IRFE_NY_Nameing_file		= 23_Create_IRFE_NY_Naming.csv
define IRFE_London_Nameing_file		= 24_Create_IRFE_London_Naming.csv
define Athena_Nameing_file		= 20_Create_Athena_Naming.csv
define gapp_smart_Nameing_file 	= 19b_Create_Back_Office_Smart_Naming.csv
define Athena_smart_Nameing_file = 20b_Create_Athena_Smart_Naming.csv
define Harmony_Nameing_file = 18_Create_Harmony_Naming.csv
define EB_persons_file = 15_Create_EB_User.csv
define Client_persons_file = 16_Create_Client_User.csv
define client_naming_file = 21_Create_Clients_Naming.csv
define EB_naming_file = 22_Create_EBs_Naming.csv
define Manager_Clients_file = 16b_Create_Client_Manager_User.csv
define Manager_EBs_file = 15b_Create_EB_Manager_User.csv


set echo off

prompt *****************************************
prompt Back Office Naming (Gapp) - Organizations
prompt *****************************************
spool ^Gapp_Nameing_file

-- 19_Create_Back_Office_Naming - Organization 
SELECT
	'^string'     ||ext_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when ext_name.role = ^ROLE_FUND then
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and Gapp.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else null
					end									--PARENT_ORGNAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then 'Fund'
						else 'Organization'
					end									--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value				 	--NAME
    ||'^string'  
FROM    
    v_external_org_name ext_name,
	v_external_org_name Gapp
where gapp.map_type = ext_name.map_type 
  and gapp.internal_value = ext_name.internal_value
  and gapp.namer_id = ^NAMER_GAPP
  and gapp.TYPE = 0
  -- Get External name
  and ext_name.map_type IN  (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and ext_name.namer_id = ^PRIME_ORG
  and ext_name.type = 0 
-- Gapp name deffers from default 
  and Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from v_external_org_name n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		  and n.type = 0)	
order by ext_name.external_value ;


-- 19_Create_Back_Office_Naming - accounts
SELECT  
	'^string'     ||acc_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when org_name.role = ^ROLE_FUND then -- for funds: find the parent client name
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and org_name.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else org_name.external_value
					end									--PARENT_ORGNAME
	||'^delimiter'||CASE 
						WHEN org_name.ROLE = ^ROLE_FUND THEN 'Fund Account'
						ELSE 'Account'
					END 								--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value					--NAME
    ||'^string'  
FROM    
	^DB_SCHEMA..v_arch_data_mapping Gapp,
    ^DB_SCHEMA..v_arch_data_mapping acc_name,
	^DB_SCHEMA..a_object_2_object 	acc2org,
	^DB_SCHEMA..a_account 			acc,
	^DB_SCHEMA..A_STATE_DETAIL 		s_acc,
	v_external_org_name				org_name
where gapp.internal_value = acc_name.internal_value
  and gapp.namer_id = ^NAMER_GAPP
  and gapp.map_type = ^MAP_ACCOUNT 
  and gapp.type = 0
   -- Account default namer external value
  and acc_name.map_type = gapp.map_type
  and acc_name.namer_id = ^PRIME_ORG
  and acc_name.type = 0
  -- Get to org by account
  and acc2org.from_object_type = ^TYPE_ORG
  and acc2org.to_object_type = ^TYPE_ACCOUNT
  and acc2org.relation = 1 -- master account 
  and acc2org.to_object_id = acc.id
  and acc2org.from_object_id = org_name.internal_value
  -- Org default namer name
  and org_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and org_name.namer_id = ^PRIME_ORG
  and org_name.type = 0
  -- Enabled accounts
  and acc.id = acc_name.internal_value 
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
 -- Gapp name deffers from default 
  and Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from ^DB_SCHEMA..v_arch_data_mapping n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		)	
order by acc_name.external_value 
;

spool off




prompt *****************************************
prompt Back Office Naming (Athena) 
prompt *****************************************
spool ^Athena_Nameing_file

-- 20_Create_Athena_Naming - Organization
SELECT 
	'^string'     ||ext_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and Gapp.internal_value = f2c.to_object_id
							   and f2c.to_object_type = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type = ^TYPE_ORG							 
							 )
						else null
					end									--PARENT_ORGNAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then 'Fund'
						else 'Organization '
					end									--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value				 	--NAME
    ||'^string'  
FROM    
     v_external_org_name ext_name,
	 v_external_org_name Gapp
where -- Gapp name deffers from default 
      Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from v_external_org_name n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		  and n.type = 0 
		)	
  and gapp.type = 0 
  and gapp.namer_id = ^NAMER_ATHENA
  and gapp.map_type = ext_name.map_type 
  and gapp.internal_value = ext_name.internal_value
  and ext_name.type = 0
  and ext_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN) 
  and ext_name.namer_id = ^PRIME_ORG
order by ext_name.external_value 
;

--prompt *****************************************
--prompt Back Office Naming (Athena) - accounts
--prompt *****************************************
-- 20_Create_Athena_Naming - accounts
SELECT 
	'^string'     ||acc_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when org_name.role = ^ROLE_FUND then
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and org_name.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else org_name.external_value
					end									--PARENT_ORGNAME
	||'^delimiter'||CASE 
						WHEN org_name.ROLE = ^ROLE_FUND THEN 'Fund Account'
						ELSE 'Account'
					END 								--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value					--NAME
    ||'^string'  
FROM    
	^DB_SCHEMA..v_arch_data_mapping Gapp,
    ^DB_SCHEMA..v_arch_data_mapping acc_name,
	^DB_SCHEMA..a_object_2_object 	acc2org,
	^DB_SCHEMA..a_account 			acc,
	^DB_SCHEMA..A_STATE_DETAIL 		s_acc,
	v_external_org_name 			org_name
where -- Gapp name deffers from default 
      Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from v_external_org_name n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		)	
  and gapp.namer_id = ^NAMER_ATHENA
  and gapp.map_type = acc_name.map_type 
  and gapp.type = 0
  and gapp.internal_value = acc_name.internal_value
   -- Account default namer external value
  and acc_name.map_type = ^MAP_ACCOUNT
  and acc_name.namer_id = ^PRIME_ORG
  and acc_name.type = 0 
  -- Get to org by account
  and acc2org.from_object_type = ^TYPE_ORG
  and acc2org.to_object_type = ^TYPE_ACCOUNT
  and acc2org.relation = 1 -- master account 
  and acc2org.to_object_id = acc_name.internal_value
  and org_name.internal_value = acc2org.from_object_id 
  -- Org default namer name
  and org_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and org_name.namer_id = ^PRIME_ORG
  and org_name.type = 0
  -- Enabled accounts
  and acc.id = acc_name.internal_value 
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
 order by acc_name.external_value
;

spool off


prompt *****************************************
prompt Back Office Smart Naming (Gapp) 
prompt *****************************************
spool ^gapp_smart_Nameing_file

--19b_Create_Back_Office_Smart_Na   
select /*+ ALL_ROWS */ distinct 
    '^string'     ||org_bank.full_name||'_'||org_client.full_name||conf.txt||'_'||:po_name
    ||'^delimiter'||org_bank.external_value
    ||'^delimiter'||'All'
    ||'^delimiter'||smart_name(gn.external_value)
    ||'^string'  
from 
    ^DB_SCHEMA..v_arch_data_mapping 	dn, -- default namer
    ^DB_SCHEMA..v_arch_data_mapping 	gn,  -- Gapp namer
    ^DB_SCHEMA..A_OBJECT_2_OBJECT 		bank,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT 		client,
	^DB_SCHEMA..a_Account				acc,
    ^DB_SCHEMA..A_STATE_DETAIL 			s_acc,
	v_external_org_name 				org_bank,
	v_external_org_name 				org_client,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT 		org2ma,
	^DB_SCHEMA..a_Account				ma,
	^DB_SCHEMA..A_STATE_DETAIL 			s_ma,
	^DB_SCHEMA..v_arch_data_mapping 	ma_name,
	fund_clients_conflict conf
where
  -- Get data where default namer outgoing <> gapp namer outgoing  
	smart_name(gn.external_value) not in 
		(select n.external_value -- Avoid existing names 
		from ^DB_SCHEMA..v_arch_data_mapping n
		where n.internal_value = dn.internal_value 
		  and n.map_type = dn.map_type 
		  and n.namer_id = ^prime_org
		  and n.type = 0 
		)	
  and gn.map_type =^MAP_CPLD_ACCOUNT
  and gn.type=0        
  and gn.namer_id = ^NAMER_GAPP
  and dn.internal_value = gn.internal_value -- internal value is the coupled account id  
  and dn.map_type = gn.map_type 
  and dn.namer_id = ^prime_org
  and dn.type = 0 
  -- Link account to orgs via object 2 object   
  and bank.from_object_type = ^TYPE_ORG
  and bank.to_object_type = ^TYPE_ACCOUNT
  and bank.relation = 3 --bank
  and bank.TO_OBJECT_ID = DN.INTERNAL_VALUE
  --  Default namer bank external value 
  and org_bank.INTERNAL_VALUE = bank.from_object_id
  and org_bank.map_type = ^MAP_ORG
  and org_bank.type = 0 
  and org_bank.namer_id = ^PRIME_ORG
  and org_bank.role = ^ROLE_BANK
--  -- Link account to client via object 2 object (to get client region)   
  and client.from_object_type = ^TYPE_ORG
  and client.to_object_type = ^TYPE_ACCOUNT
  and client.TO_OBJECT_ID = DN.INTERNAL_VALUE
  and client.relation = 5 --client
  -- Get enabled account 
  and acc.id = dn.internal_value 
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
  -- Get enabled clients
  and org_client.internal_value = client.from_object_id
  and org_client.role = ^ROLE_CLIENT
  -- client/fund naming conflict resolusion
  and org_client.internal_value = conf.client_id (+) 
  -- Find master account by bank
  and org_bank.internal_value = org2ma.from_object_id
  and org2ma.from_object_type = ^TYPE_ORG 
  and org2ma.to_object_type = ^TYPE_ACCOUNT
  and org2ma.relation = 1
  and org2ma.to_object_id = ma.id
  -- enabled master ccount
  and ma.state_id = s_ma.state_id
  and s_ma.status_value = 1
  -- master account external name 
  and ma.id = ma_name.internal_value 
  and ma_name.map_type = ^MAP_ACCOUNT
  and ma_name.namer_id = ^prime_org
  and ma_name.type = 0
ORDER BY 1
;
spool off


prompt *****************************************
prompt Back Office Smart Naming (Athena) 
prompt *****************************************
spool ^Athena_smart_Nameing_file

--20b_Create_Back_Office_Smart_Na   

--19b_Create_Back_Office_Smart_Na   
select /*+ ALL_ROWS */ distinct   
    '^string'     ||org_bank.full_name||'_'||org_client.full_name||conf.txt||'_'||:po_name
    ||'^delimiter'||org_bank.external_value
    ||'^delimiter'||'All'
    ||'^delimiter'||smart_name(gn.external_value)
    ||'^string'  
from 
    ^DB_SCHEMA..v_arch_data_mapping 	dn, -- default namer
    ^DB_SCHEMA..v_arch_data_mapping 	gn,  -- Gapp namer
    ^DB_SCHEMA..A_OBJECT_2_OBJECT 		bank,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT 		client,
	^DB_SCHEMA..a_Account				acc,
    ^DB_SCHEMA..A_STATE_DETAIL 			s_acc,
	v_external_org_name 				org_bank,
	v_external_org_name 				org_client,
    ^DB_SCHEMA..A_OBJECT_2_OBJECT 		org2ma,
	^DB_SCHEMA..a_Account				ma,
	^DB_SCHEMA..A_STATE_DETAIL 			s_ma,
	^DB_SCHEMA..v_arch_data_mapping 	ma_name,
	fund_clients_conflict conf
where
  -- Get data where default namer outgoing <> gapp namer outgoing  
	smart_name(gn.external_value) not in 
		(select n.external_value -- Avoid existing names 
		from ^DB_SCHEMA..v_arch_data_mapping n
		where n.internal_value = dn.internal_value 
		  and n.map_type = dn.map_type 
		  and n.namer_id = ^prime_org
		  and n.type = 0 
		)	
  and gn.map_type =^MAP_CPLD_ACCOUNT
  and gn.type=0        
  and gn.namer_id = ^NAMER_ATHENA
  and dn.internal_value = gn.internal_value -- internal value is the coupled account id  
  and dn.map_type = gn.map_type 
  and dn.namer_id = ^prime_org
  and dn.type = 0 
  -- Link account to orgs via object 2 object   
  and bank.from_object_type = ^TYPE_ORG
  and bank.to_object_type = ^TYPE_ACCOUNT
  and bank.relation = 3 --bank
  and bank.TO_OBJECT_ID = DN.INTERNAL_VALUE
  --  Default namer bank external value 
  and org_bank.INTERNAL_VALUE = bank.from_object_id
  and org_bank.map_type = ^MAP_ORG
  and org_bank.type = 0 
  and org_bank.namer_id = ^PRIME_ORG
  and org_bank.role = ^ROLE_BANK
--  -- Link account to client via object 2 object (to get client region)   
  and client.from_object_type = ^TYPE_ORG
  and client.to_object_type = ^TYPE_ACCOUNT
  and client.TO_OBJECT_ID = DN.INTERNAL_VALUE
  and client.relation = 5 --client
  -- Get enabled account 
  and acc.id = dn.internal_value 
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
  -- Get enabled clients
  and org_client.internal_value = client.from_object_id
  and org_client.role = ^ROLE_CLIENT
   -- client/fund naming conflict resolusion
  and org_client.internal_value = conf.client_id (+) 
  -- Find master account by bank
  and org_bank.internal_value = org2ma.from_object_id
  and org2ma.from_object_type = ^TYPE_ORG 
  and org2ma.to_object_type = ^TYPE_ACCOUNT
  and org2ma.relation = 1
  and org2ma.to_object_id = ma.id
  -- enabled master ccount
  and ma.state_id = s_ma.state_id
  and s_ma.status_value = 1
  -- master account external name 
  and ma.id = ma_name.internal_value 
  and ma_name.map_type = ^MAP_ACCOUNT
  and ma_name.namer_id = ^prime_org
  and ma_name.type = 0
ORDER BY 1
;

spool off


prompt *****************************************
prompt Harmony Naming 
prompt *****************************************
spool ^Harmony_Nameing_file

--18_Create_Harmony_Naming - Organizations  
begin
	execute immediate 'drop table gn';
exception
	when others then null;
end;
/
begin
	execute immediate 'drop table dn';
exception
	when others then null;
end;
/

create table dn as
	select *
	 from v_external_org_name 	
	 where namer_id = ^PRIME_ORG
	  and type = 0
	  and map_type  in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
;

create table gn as
	select * 
	from v_external_org_name t
	where map_type  in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
	  and namer_id = ^NAMER_HARMONY
      and external_value not in (
		select external_value
		from v_external_org_name n 
		where n.internal_value = t.internal_value 
		  and n.map_type = t.map_type
		  and n.namer_id = ^PRIME_ORG
		  and n.type = 0	  
	  )	  
;

select 
    '^string'     ||dn.EXTERNAL_VALUE
    ||'^delimiter'||mapp.string
    ||'^delimiter'||'Incoming'
    ||'^delimiter'||gn.external_value
    ||'^string'  
from 
	dn, -- default namer
    gn,  -- Harmony namer
	MIG_TRANSLATIONS		mapp
where
  -- Get data where default namer outgoing <> gapp namer outgoing  
      dn.internal_value = gn.internal_value -- internal value is the coupled account id  
  and dn.map_type = gn.map_type 
  -- Map map_types
  and dn.map_type = mapp.code
  and mapp.key = 'HarmonyMap'
;

drop table dn;
drop table gn;

--18_Create_Harmony_Naming - Persons
select 
    '^string'     ||dn.EXTERNAL_VALUE
    ||'^delimiter'||mapp.string
    ||'^delimiter'||'Incoming'
    ||'^delimiter'||gn.external_value
    ||'^string'  
from 
    ^DB_SCHEMA..v_arch_data_mapping 	dn, -- default namer
    ^DB_SCHEMA..v_arch_data_mapping 	gn,  -- Harmony namer
    ^DB_SCHEMA..A_STATE_DETAIL 			s_user,
	^DB_SCHEMA..sd_security_user		trm_user,
	MIG_TRANSLATIONS					mapp
where
  -- Get data where default namer outgoing <> gapp namer outgoing  
     gn.external_value not in (
		select external_value
		from ^DB_SCHEMA..v_arch_data_mapping n 
		where n.internal_value = gn.internal_value 
		  and n.map_type = gn.map_type
		  and n.namer_id = ^PRIME_ORG
		  and n.type = 0
	  )
  and dn.internal_value = gn.internal_value -- internal value is the coupled account id  
  and dn.map_type = gn.map_type 
  and gn.map_type  in (^MAP_TRADER)
  and dn.namer_id = ^PRIME_ORG
  and dn.type = 0
  and gn.namer_id = ^NAMER_HARMONY
  -- Link to user
  and trm_user.ID = DN.INTERNAL_VALUE
  and trm_user.type = 1 --user
  and trm_user.state_id = s_user.state_id
  and s_user.status_value = 1
  -- Map map_types
  and dn.map_type = mapp.code
  and mapp.key = 'HarmonyMap'
;

spool off


prompt *****************************************
prompt EB Persons 
prompt *****************************************
spool ^EB_persons_file

select
       '^string'     || org_name.external_value
       ||'^delimiter'|| prsn.user_name
       ||'^delimiter'|| TRIM(prsn.first_name)
	   ||'^delimiter'|| TRIM(prsn.last_name)
       ||'^delimiter'|| emails.MAIL_TO
       ||'^delimiter'|| TRIM(prsn.title)
       ||'^delimiter'|| phone.value
       ||'^delimiter'|| 'Traiana1'
       ||'^delimiter'|| DECODE(rgn.value,' ','HKG',rgn.value) --Match UI behaviour. If region not selected then HKG is the default. 
       ||'^delimiter'|| prsn.user_name
       ||'^delimiter'|| NVL2(viewer.object_id,1,0)
       ||'^delimiter'|| NVL2(reporter.object_id,1,0)
	   ||'^string' 
from
     ^DB_SCHEMA..a_organization org,
	 ^DB_SCHEMA..v_arch_data_mapping org_name,
     ^DB_SCHEMA..sd_security_user prsn,
     ^DB_SCHEMA..a_state_detail stt,
	 ^DB_SCHEMA..a_state_detail s_org,
     (select distinct
             prsn2adrs.from_object_id,
             mail.mail_to
     from
             ^DB_SCHEMA..a_object_2_object prsn2adrs,
             ^DB_SCHEMA..sd_address adrs,
             ^DB_SCHEMA..sd_address_out_mail mail
     where   prsn2adrs.to_object_id = adrs.id  
	   and   prsn2adrs.to_object_type = ^TYPE_EMAIL 
	   and   prsn2adrs.from_object_type = ^TYPE_PERSON 
	   and   adrs.id = mail.address_id
     )  emails,
     ^DB_SCHEMA..arch_object_props phone,
     ^DB_SCHEMA..arch_object_props rgn,
     ^DB_SCHEMA..v_sd_security_object viewer,
	 ^DB_SCHEMA..v_sd_security_object reporter
where -- Org external_value
	  org_name.internal_value = org.id
  and org_name.namer_id = ^PRIME_ORG 
  and org_name.map_type = ^MAP_ORG
  and org_name.type = 0 
  --persons only
  and   prsn.TYPE=1 
  -- EB persons only 
  and org.role = ^ROLE_BANK
  and prsn.parent_org_id=org.id
  -- match email to person
  and   prsn.id=emails.from_object_id (+) 
  -- Enabled orgs only
  and s_org.state_id = org.state_id and s_org.status_value = 1
  --Enabled persons only 
  and   prsn.state_id=stt.state_id and stt.status_value = 1  
  --get phone number
  and   prsn.id=phone.object_id(+) and phone.object_type(+)= ^TYPE_PERSON  and phone.code_id(+)=1100012 
  -- get region
  and   prsn.id=rgn.object_id(+) and rgn.object_type(+)= ^TYPE_PERSON and rgn.code_id(+)= :region_key
  -- Link person to its viewer role
  and   prsn.id = viewer.root_id (+)
  and   viewer.root_type(+) = 8 --  users
  and   viewer.object_id (+) = ^USER_TRADE_VIEWER
  -- Link person to its viewer role
  and   prsn.id = reporter.root_id (+)
  and   reporter.root_type(+) = 8 --  users
  and   reporter.object_id (+) = ^USER_TRADE_REPORTER
 order by org.id, prsn.first_name, prsn.last_name, prsn.id
;

spool off



prompt *****************************************
prompt Client Persons 
prompt *****************************************
spool ^Client_persons_file

select 
       '^string'     || org_name.external_value
       ||'^delimiter'|| prsn.user_name
       ||'^delimiter'|| TRIM(prsn.first_name)
	   ||'^delimiter'|| TRIM(prsn.last_name)
       ||'^delimiter'|| emails.MAIL_TO
       ||'^delimiter'|| TRIM(prsn.title)
       ||'^delimiter'|| phone.value
       ||'^delimiter'|| 'Traiana1'
       ||'^delimiter'|| rgn.value
       ||'^delimiter'|| prsn.user_name
       ||'^delimiter'|| NVL2(viewer.object_id,1,0)
       ||'^delimiter'|| NVL2(reporter.object_id,1,0)
	   ||'^string' 
from
     ^DB_SCHEMA..a_organization org,
	 ^DB_SCHEMA..v_arch_data_mapping org_name,
     ^DB_SCHEMA..sd_security_user prsn,
     ^DB_SCHEMA..a_state_detail stt,
	 ^DB_SCHEMA..a_state_detail s_org,
     (select distinct
             prsn2adrs.from_object_id,
             mail.mail_to
     from
             ^DB_SCHEMA..a_object_2_object prsn2adrs,
             ^DB_SCHEMA..sd_address adrs,
             ^DB_SCHEMA..sd_address_out_mail mail
     where   prsn2adrs.to_object_id = adrs.id  
	   and   prsn2adrs.to_object_type = ^TYPE_EMAIL 
	   and   prsn2adrs.from_object_type = ^TYPE_PERSON 
	   and   adrs.id = mail.address_id
     )  emails,
     ^DB_SCHEMA..arch_object_props phone,
     ^DB_SCHEMA..arch_object_props rgn,
     ^DB_SCHEMA..v_sd_security_object viewer,
	 ^DB_SCHEMA..v_sd_security_object reporter
where -- Org external_value
	  org_name.internal_value = org.id
  and org_name.namer_id = ^PRIME_ORG 
  and org_name.map_type = ^MAP_ORG
  and org_name.type = 0 
  --persons only
  and   prsn.TYPE=1 
  -- EB persons only 
  and org.role = ^ROLE_CLIENT
  and prsn.parent_org_id=org.id
  -- match email to person
  and   prsn.id=emails.from_object_id (+) 
  -- Enabled orgs only
  and s_org.state_id = org.state_id and s_org.status_value = 1
  --Enabled persons only 
  and   prsn.state_id=stt.state_id and stt.status_value = 1  
  --get phone number
  and   prsn.id=phone.object_id(+) and phone.object_type(+)= ^TYPE_PERSON  and phone.code_id(+)=1100012 
  -- get region
  and   prsn.id=rgn.object_id(+) and rgn.object_type(+)= ^TYPE_PERSON and rgn.code_id(+)= :region_key
  -- Link person to its viewer role
  and   prsn.id = viewer.root_id (+)
  and   viewer.root_type(+) = 8 --  users
  and   viewer.object_id (+) = ^USER_TRADE_VIEWER
  -- Link person to its viewer role
  and   prsn.id = reporter.root_id (+)
  and   reporter.root_type(+) = 8 --  users
  and   reporter.object_id (+) = ^USER_TRADE_REPORTER
 order by org.id, prsn.first_name, prsn.last_name, prsn.id
;

spool off


prompt *****************************************
prompt Client Naming  
prompt *****************************************
spool ^Client_naming_file

-- 21_Create_Clients_Naming -Organizations (out)
SELECT 
	'^string'     ||client.external_value 
	||'^delimiter'||ext_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and Gapp.internal_value = f2c.to_object_id
							   and f2c.to_object_type = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type = ^TYPE_ORG							 
							 )
						else null
					end									--PARENT_ORGNAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then 'Fund'
						else 'Organization '
					end									--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value				 	--NAME
    ||'^string'  
FROM    
     v_external_org_name 		ext_name,
	 v_external_org_name 		Gapp, 
	 v_external_org_name 		client, 
	 ^DB_SCHEMA..sd_dm_namer 	namer,
	 ^DB_SCHEMA..a_organization org
where -- Gapp name deffers from default 
      Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from v_external_org_name n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		  and n.type = 0 
		)	
  and gapp.type = 0 
  and gapp.map_type = ext_name.map_type 
  and gapp.internal_value = ext_name.internal_value
  and ext_name.type = 0
  and ext_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN) 
  and ext_name.namer_id = ^PRIME_ORG
   -- Ignore naming for EBs if exist
  and ext_name.internal_value = org. id 
  and (org.role <> ^ROLE_CLIENT or org.id=client.internal_value)
  -- namer to client 
  and gapp.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_CLIENT
  -- get client by externaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
order by 1 
;


-- 21_Create_Clients_Naming -Organizations (IN)
SELECT /*+ rule */
	'^string'     ||client.external_value 
	||'^delimiter'||ext_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and Gapp.internal_value = f2c.to_object_id
							   and f2c.to_object_type = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type = ^TYPE_ORG							 
							 )
						else null
					end									--PARENT_ORGNAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then 'Fund'
						else 'Organization '
					end									--MAP_TYPE
	||'^delimiter'||'Incoming'    						--DIRECTION
	||'^delimiter'||Gapp.external_value				 	--NAME
    ||'^string'  
FROM    
     v_external_org_name 		ext_name,
	 v_external_org_name 		Gapp, 
	 v_external_org_name 		client, 
	 ^DB_SCHEMA..sd_dm_namer 	namer, 
	 ^DB_SCHEMA..a_organization org
where -- Gapp name deffers from default 
      Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from v_external_org_name n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		  and n.type = 0 
		)	
  and gapp.map_type = ext_name.map_type 
  and gapp.internal_value = ext_name.internal_value
  and ext_name.type = 0
  and ext_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN) 
  and ext_name.namer_id = ^PRIME_ORG
   -- Ignore naming for clients if exist
  and ext_name.internal_value = org. id 
  and (org.role <> ^ROLE_CLIENT or org.id=client.internal_value) -- namer to client 
  and gapp.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_CLIENT
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
order by 1 
;


-- 21_Create_Clients_Naming - accounts (out)
SELECT  /*+ rule */
	'^string'     ||client.external_value 
	||'^delimiter'||acc_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when org_name.role = ^ROLE_FUND then -- for funds: find the parent client name
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and org_name.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else org_name.external_value
					end									--PARENT_ORGNAME
	||'^delimiter'||'Account'							--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value					--NAME
    ||'^string'  
FROM    
	^DB_SCHEMA..v_arch_data_mapping Gapp,
    ^DB_SCHEMA..v_arch_data_mapping acc_name,
	^DB_SCHEMA..a_object_2_object 	acc2org,
	^DB_SCHEMA..a_account 			acc,
	^DB_SCHEMA..A_STATE_DETAIL 		s_acc,
	v_external_org_name				org_name, 
	v_external_org_name 			client, 
	^DB_SCHEMA..sd_dm_namer 		namer
where gapp.internal_value = acc_name.internal_value
  and gapp.map_type = ^MAP_ACCOUNT 
  and gapp.type = 0
   -- Account default namer external value
  and acc_name.map_type = gapp.map_type
  and acc_name.namer_id = ^PRIME_ORG
  and acc_name.type = 0
  -- Get to org by account
  and acc2org.from_object_type = ^TYPE_ORG
  and acc2org.to_object_type = ^TYPE_ACCOUNT
  and acc2org.relation = 1 -- master account 
  and acc2org.to_object_id = acc.id
  and acc2org.from_object_id = org_name.internal_value
  -- Org default namer name
  and org_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and org_name.namer_id = ^PRIME_ORG
  and org_name.type = 0
  -- Enabled accounts
  and acc.id = acc_name.internal_value 
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
 -- Gapp name deffers from default 
  and Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from ^DB_SCHEMA..v_arch_data_mapping n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		)	
 -- namer to client 
  and gapp.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_CLIENT
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
  -- Avoid fund accounts: 
  and org_name.ROLE <> ^ROLE_FUND
order by 1 
;


-- 21_Create_Clients_Naming - accounts (in )
SELECT  /*+ rule */
	'^string'     ||client.external_value 
	||'^delimiter'||acc_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when org_name.role = ^ROLE_FUND then -- for funds: find the parent client name
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and org_name.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else org_name.external_value
					end									--PARENT_ORGNAME
	||'^delimiter'||'Account'							--MAP_TYPE
	||'^delimiter'||'Incoming'    						--DIRECTION
	||'^delimiter'||Gapp.external_value					--NAME
    ||'^string'  
FROM    
	^DB_SCHEMA..v_arch_data_mapping Gapp,
    ^DB_SCHEMA..v_arch_data_mapping acc_name,
	^DB_SCHEMA..a_object_2_object 	acc2org,
	^DB_SCHEMA..a_account 			acc,
	^DB_SCHEMA..A_STATE_DETAIL 		s_acc,
	v_external_org_name				org_name, 
	v_external_org_name 			client, 
	^DB_SCHEMA..sd_dm_namer 		namer
where gapp.internal_value = acc_name.internal_value
  and gapp.map_type = ^MAP_ACCOUNT 
   -- Account default namer external value
  and acc_name.map_type = gapp.map_type
  and acc_name.namer_id = ^PRIME_ORG
  and acc_name.type = 0
  -- Get to org by account
  and acc2org.from_object_type = ^TYPE_ORG
  and acc2org.to_object_type = ^TYPE_ACCOUNT
  and acc2org.relation = 1 -- master account 
  and acc2org.to_object_id = acc.id
  and acc2org.from_object_id = org_name.internal_value
  -- Org default namer name
  and org_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and org_name.namer_id = ^PRIME_ORG
  and org_name.type = 0
  -- Enabled accounts
  and acc.id = acc_name.internal_value 
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
 -- Gapp name deffers from default 
  and Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from ^DB_SCHEMA..v_arch_data_mapping n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		)	
-- namer to client 
  and gapp.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_CLIENT
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
  -- Avoid fund accounts 
  and org_name.ROLE <> ^ROLE_FUND 
order by 1 
;


-- 21_Create_Clients_Naming - users (outgoing)
select /*+ rule */
    '^string'     ||client.external_value 
	||'^delimiter'||dn.EXTERNAL_VALUE
	||'^delimiter'||''
    ||'^delimiter'||mapp.string
    ||'^delimiter'||'Outgoing'
    ||'^delimiter'||gn.external_value
    ||'^string'  
from 
    ^DB_SCHEMA..v_arch_data_mapping 	dn, -- default namer
    ^DB_SCHEMA..v_arch_data_mapping 	gn,  -- Harmony namer
    ^DB_SCHEMA..A_STATE_DETAIL 			s_user,
	^DB_SCHEMA..sd_security_user		trm_user,
	MIG_TRANSLATIONS					mapp,
	v_external_org_name 			client, 
	^DB_SCHEMA..sd_dm_namer 		namer
where
  -- Get data where default namer outgoing <> gapp namer outgoing  
     gn.external_value not in (
		select external_value
		from ^DB_SCHEMA..v_arch_data_mapping n 
		where n.internal_value = gn.internal_value 
		  and n.map_type = gn.map_type
		  and n.namer_id = ^PRIME_ORG
		  and n.type = 0
	  )
  and dn.internal_value = gn.internal_value -- internal value is the coupled account id  
  and dn.map_type = gn.map_type 
  and gn.map_type  in (^MAP_TRADER)
  and gn.type=0 
  and dn.type=0        
  -- Link to user
  and trm_user.ID = DN.INTERNAL_VALUE
  and trm_user.type = 1 --user
  and trm_user.state_id = s_user.state_id
  and s_user.status_value = 1
  -- Map map_types
  and dn.map_type = mapp.code
  and mapp.key = 'HarmonyMap'
-- namer to client 
  and gn.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_CLIENT
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
order by 1 
;


-- 21_Create_Clients_Naming - users (Ingoing)
select /*+ rule */
    '^string'     ||client.external_value 
	||'^delimiter'||dn.EXTERNAL_VALUE
	||'^delimiter'||''
    ||'^delimiter'||mapp.string
    ||'^delimiter'||'Incoming'
    ||'^delimiter'||gn.external_value
    ||'^string'  
from 
    ^DB_SCHEMA..v_arch_data_mapping 	dn, -- default namer
    ^DB_SCHEMA..v_arch_data_mapping 	gn,  -- Harmony namer
    ^DB_SCHEMA..A_STATE_DETAIL 			s_user,
	^DB_SCHEMA..sd_security_user		trm_user,
	MIG_TRANSLATIONS					mapp,
	v_external_org_name 			client, 
	^DB_SCHEMA..sd_dm_namer 		namer
where
  -- Get data where default namer outgoing <> gapp namer outgoing  
     gn.external_value not in (
		select external_value
		from ^DB_SCHEMA..v_arch_data_mapping n 
		where n.internal_value = gn.internal_value 
		  and n.map_type = gn.map_type
		  and n.namer_id = ^PRIME_ORG
		  and n.type = 0
	  )
  and dn.internal_value = gn.internal_value -- internal value is the coupled account id  
  and dn.map_type = gn.map_type 
  and gn.map_type  in (^MAP_TRADER)
  and dn.type=0        
  -- Link to user
  and trm_user.ID = DN.INTERNAL_VALUE
  and trm_user.type = 1 --user
  and trm_user.state_id = s_user.state_id
  and s_user.status_value = 1
  -- Map map_types
  and dn.map_type = mapp.code
  and mapp.key = 'HarmonyMap'
-- namer to client 
  and gn.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_CLIENT
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
order by 1 
;

spool off



prompt *****************************************
prompt EB Naming
prompt *****************************************
spool ^EB_naming_file


-- 21_Create_Clients_Naming -Organizations (out)
SELECT /*+ rule */
	'^string'     ||client.external_value 
	||'^delimiter'||ext_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and Gapp.internal_value = f2c.to_object_id
							   and f2c.to_object_type = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type = ^TYPE_ORG							 
							 )
						else null
					end									--PARENT_ORGNAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then 'Fund'
						else 'Organization '
					end									--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value				 	--NAME
    ||'^string'  
FROM    
     v_external_org_name 		ext_name,
	 ^DB_SCHEMA..A_ORGANIZATION	org,
	 v_external_org_name 		Gapp, 
	 v_external_org_name 		client, 
	 ^DB_SCHEMA..sd_dm_namer 	namer
where -- Gapp name deffers from default 
      Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from v_external_org_name n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		  and n.type = 0 
		)	
  and gapp.type = 0 
  and gapp.map_type = ext_name.map_type 
  and gapp.internal_value = ext_name.internal_value
  and ext_name.type = 0
  and ext_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN) 
  and ext_name.namer_id = ^PRIME_ORG
  -- Ignore naming for EBs if exist
  and ext_name.internal_value = org. id 
  and (org.role <> ^ROLE_BANK or org.id=client.internal_value)
  -- namer to client 
  and gapp.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_BANK
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
order by 1 
;



-- 21_Create_Clients_Naming -Organizations (IN)
SELECT /*+ rule */
	'^string'     ||client.external_value 
	||'^delimiter'||ext_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and Gapp.internal_value = f2c.to_object_id
							   and f2c.to_object_type = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type = ^TYPE_ORG							 
							 )
						else null
					end									--PARENT_ORGNAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then 'Fund'
						else 'Organization '
					end									--MAP_TYPE
	||'^delimiter'||'Incoming'    						--DIRECTION
	||'^delimiter'||Gapp.external_value				 	--NAME
    ||'^string'  
FROM    
     v_external_org_name 		ext_name,
	 ^DB_SCHEMA..A_ORGANIZATION	org,	 
	 v_external_org_name 		Gapp, 
	 v_external_org_name 		client, 
	 ^DB_SCHEMA..sd_dm_namer 	namer
where -- Gapp name deffers from default 
      Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from v_external_org_name n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		  and n.type = 0 
		)	
  and gapp.map_type = ext_name.map_type 
  and gapp.internal_value = ext_name.internal_value
  and ext_name.type = 0
  and ext_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN) 
  and ext_name.namer_id = ^PRIME_ORG
 -- Ignore naming for EBs if exist
  and ext_name.internal_value = org. id 
  and (org.role <> ^ROLE_BANK or org.id=client.internal_value)
   -- namer to client 
  and gapp.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_BANK
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
order by 1 
;


-- 21_Create_Clients_Naming - accounts (out)
SELECT  /*+ rule */
	'^string'     ||client.external_value 
	||'^delimiter'||acc_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when org_name.role = ^ROLE_FUND then -- for funds: find the parent client name
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and org_name.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else org_name.external_value
					end									--PARENT_ORGNAME
	||'^delimiter'||CASE 
						WHEN org_name.ROLE = ^ROLE_FUND THEN 'Fund Account'
						ELSE 'Account'
					END 								--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value					--NAME
    ||'^string'  
FROM    
	^DB_SCHEMA..v_arch_data_mapping Gapp,
    ^DB_SCHEMA..v_arch_data_mapping acc_name,
	^DB_SCHEMA..a_object_2_object 	acc2org,
	^DB_SCHEMA..a_account 			acc,
	^DB_SCHEMA..A_STATE_DETAIL 		s_acc,
	v_external_org_name				org_name, 
	v_external_org_name 			client, 
	^DB_SCHEMA..sd_dm_namer 		namer
where gapp.internal_value = acc_name.internal_value
  and gapp.map_type = ^MAP_ACCOUNT 
  and gapp.type = 0
   -- Account default namer external value
  and acc_name.map_type = gapp.map_type
  and acc_name.namer_id = ^PRIME_ORG
  and acc_name.type = 0
  -- Get to org by account
  and acc2org.from_object_type = ^TYPE_ORG
  and acc2org.to_object_type = ^TYPE_ACCOUNT
  and acc2org.relation = 1 -- master account 
  and acc2org.to_object_id = acc.id
  and acc2org.from_object_id = org_name.internal_value
  -- Org default namer name
  and org_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and org_name.namer_id = ^PRIME_ORG
  and org_name.type = 0
  -- Enabled accounts
  and acc.id = acc_name.internal_value 
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
 -- Gapp name deffers from default 
  and Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from ^DB_SCHEMA..v_arch_data_mapping n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		)	
 -- namer to client 
  and gapp.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_BANK
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
order by 1 
;


-- 21_Create_Clients_Naming - accounts (in )
SELECT  /*+ rule */
	'^string'     ||client.external_value 
	||'^delimiter'||acc_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when org_name.role = ^ROLE_FUND then -- for funds: find the parent client name
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and org_name.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else org_name.external_value
					end									--PARENT_ORGNAME
	||'^delimiter'||CASE 
						WHEN org_name.ROLE = ^ROLE_FUND THEN 'Fund Account'
						ELSE 'Account'
					END 								--MAP_TYPE
	||'^delimiter'||'Incoming'    						--DIRECTION
	||'^delimiter'||Gapp.external_value					--NAME
    ||'^string'  
FROM    
	^DB_SCHEMA..v_arch_data_mapping Gapp,
    ^DB_SCHEMA..v_arch_data_mapping acc_name,
	^DB_SCHEMA..a_object_2_object 	acc2org,
	^DB_SCHEMA..a_account 			acc,
	^DB_SCHEMA..A_STATE_DETAIL 		s_acc,
	v_external_org_name				org_name, 
	v_external_org_name 			client, 
	^DB_SCHEMA..sd_dm_namer 		namer
where gapp.internal_value = acc_name.internal_value
  and gapp.map_type = ^MAP_ACCOUNT 
   -- Account default namer external value
  and acc_name.map_type = gapp.map_type
  and acc_name.namer_id = ^PRIME_ORG
  and acc_name.type = 0
  -- Get to org by account
  and acc2org.from_object_type = ^TYPE_ORG
  and acc2org.to_object_type = ^TYPE_ACCOUNT
  and acc2org.relation = 1 -- master account 
  and acc2org.to_object_id = acc.id
  and acc2org.from_object_id = org_name.internal_value
  -- Org default namer name
  and org_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and org_name.namer_id = ^PRIME_ORG
  and org_name.type = 0
  -- Enabled accounts
  and acc.id = acc_name.internal_value 
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
 -- Gapp name deffers from default 
  and Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from ^DB_SCHEMA..v_arch_data_mapping n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		)	
-- namer to client 
  and gapp.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_BANK
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
order by 1 
;


-- 21_Create_Clients_Naming - users (outgoing)
select /*+ rule */
    '^string'     ||client.external_value 
	||'^delimiter'||dn.EXTERNAL_VALUE
	||'^delimiter'||''
    ||'^delimiter'||mapp.string
    ||'^delimiter'||'Outgoing'
    ||'^delimiter'||gn.external_value
    ||'^string'  
from 
    ^DB_SCHEMA..v_arch_data_mapping 	dn, -- default namer
    ^DB_SCHEMA..v_arch_data_mapping 	gn,  -- Harmony namer
    ^DB_SCHEMA..A_STATE_DETAIL 			s_user,
	^DB_SCHEMA..sd_security_user		trm_user,
	MIG_TRANSLATIONS					mapp,
	v_external_org_name 			client, 
	^DB_SCHEMA..sd_dm_namer 		namer
where
  -- Get data where default namer outgoing <> gapp namer outgoing  
     gn.external_value not in (
		select external_value
		from ^DB_SCHEMA..v_arch_data_mapping n 
		where n.internal_value = gn.internal_value 
		  and n.map_type = gn.map_type
		  and n.namer_id = ^PRIME_ORG
		  and n.type = 0
	  )
  and dn.internal_value = gn.internal_value -- internal value is the coupled account id  
  and dn.map_type = gn.map_type 
  and gn.map_type  in (^MAP_TRADER)
  and gn.type=0 
  and dn.type=0        
  -- Link to user
  and trm_user.ID = DN.INTERNAL_VALUE
  and trm_user.type = 1 --user
  and trm_user.state_id = s_user.state_id
  and s_user.status_value = 1
  -- Map map_types
  and dn.map_type = mapp.code
  and mapp.key = 'HarmonyMap'
-- namer to client 
  and gn.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_BANK
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
order by 1 
;


-- 21_Create_Clients_Naming - users (Ingoing)
select /*+ rule */
    '^string'     ||client.external_value 
	||'^delimiter'||dn.EXTERNAL_VALUE
	||'^delimiter'||''
    ||'^delimiter'||mapp.string
    ||'^delimiter'||'Incoming'
    ||'^delimiter'||gn.external_value
    ||'^string'  
from 
    ^DB_SCHEMA..v_arch_data_mapping 	dn, -- default namer
    ^DB_SCHEMA..v_arch_data_mapping 	gn,  -- Harmony namer
    ^DB_SCHEMA..A_STATE_DETAIL 			s_user,
	^DB_SCHEMA..sd_security_user		trm_user,
	MIG_TRANSLATIONS					mapp,
	v_external_org_name 			client, 
	^DB_SCHEMA..sd_dm_namer 		namer
where
  -- Get data where default namer outgoing <> gapp namer outgoing  
     gn.external_value not in (
		select external_value
		from ^DB_SCHEMA..v_arch_data_mapping n 
		where n.internal_value = gn.internal_value 
		  and n.map_type = gn.map_type
		  and n.namer_id = ^PRIME_ORG
		  and n.type = 0
	  )
  and dn.internal_value = gn.internal_value -- internal value is the coupled account id  
  and dn.map_type = gn.map_type 
  and gn.map_type  in (^MAP_TRADER)
  and dn.type=0        
  -- Link to user
  and trm_user.ID = DN.INTERNAL_VALUE
  and trm_user.type = 1 --user
  and trm_user.state_id = s_user.state_id
  and s_user.status_value = 1
  -- Map map_types
  and dn.map_type = mapp.code
  and mapp.key = 'HarmonyMap'
-- namer to client 
  and gn.namer_id = namer.id
  and namer.owner_id = client.internal_value 
  and client.role = ^ROLE_BANK
  -- get client byexternaL VALUE
  and client.namer_id = ^prime_org
  and client.map_type = ^MAP_ORG
  and client.type = 0 
order by 1 
;

spool off


prompt **************************
prompt Manager Clients
prompt **************************
spool ^Manager_Clients_file

select /*+ rule */
    '^string'     ||  manager_name.EXTERNAL_VALUE  /*external name*/ 
    ||'^delimiter'||  usr.user_name
	||'^delimiter'||  get_list_from_sql(
					  'select managed_name.external_value  '||
					  'from v_external_org_name managed_name '||
					  'WHERE managed_name.internal_value IN  (SELECT RESOURCE_ID from ^DB_SCHEMA..V_SD_SECURITY_OBJECT_DET  WHERE USER_ID = '||usr.id  || ') '||
					  'and managed_name.namer_id = ^PRIME_ORG '||
					  'and managed_name.MAP_TYPE = ^MAP_ORG ' ||
					  'and managed_name.role = ^ROLE_CLIENT ' ||
					  'and managed_name.internal_value <>  ' || manager_name.internal_value /* AVOID SELF MANAGERS*/||
					  ' and managed_name.type = 0', ';', NULL)					
	||'^delimiter'||  get_list_from_sql(
					  'select managed_name.external_value  '||
					  'from v_external_org_name managed_name '||
					  'WHERE managed_name.internal_value IN  (SELECT RESOURCE_ID from ^DB_SCHEMA..V_SD_SECURITY_OBJECT_DET  WHERE USER_ID = '||usr.id  || ') '||
					  'and managed_name.namer_id = ^PRIME_ORG '||
					  'and managed_name.MAP_TYPE = ^MAP_ORG ' ||
					  'and managed_name.role = ^ROLE_BANK ' ||
					  'and managed_name.internal_value <>  ' || manager_name.internal_value /* AVOID SELF MANAGERS*/||
					  ' and managed_name.type = 0', ';', NULL)					
	||'^delimiter'||	usr.first_name
	||'^delimiter'||	usr.last_name
    ||'^string'  
from 
	^DB_SCHEMA..sd_security_user usr,
	 v_external_org_name manager_name
where  usr.id IN (SELECT USER_ID FROM ^DB_SCHEMA..V_SD_SECURITY_OBJECT_DET )
  -- Manager external value
  and usr.parent_org_id = manager_name.internal_value
  and manager_name.namer_id = ^PRIME_ORG
  and manager_name.MAP_TYPE = ^MAP_ORG
  and manager_name.type = 0
  and manager_name.role = ^ROLE_CLIENT
  -- Manager external value
order by 1
;

spool off


prompt **************************
prompt Manager EBs
prompt **************************
spool ^Manager_EBs_file

select /*+ rule */
    '^string'     ||  manager_name.EXTERNAL_VALUE  /*external name*/ 
    ||'^delimiter'||  usr.user_name
	||'^delimiter'||  get_list_from_sql(
					  'select managed_name.external_value  '||
					  'from v_external_org_name managed_name '||
					  'WHERE managed_name.internal_value IN  (SELECT RESOURCE_ID from ^DB_SCHEMA..V_SD_SECURITY_OBJECT_DET  WHERE USER_ID = '||usr.id  || ') '||
					  'and managed_name.namer_id = ^PRIME_ORG '||
					  'and managed_name.MAP_TYPE = ^MAP_ORG ' ||
					  'and managed_name.role = ^ROLE_CLIENT ' ||
					  'and managed_name.internal_value <>  ' || manager_name.internal_value /* AVOID SELF MANAGERS*/||
					  ' and managed_name.type = 0', ';', NULL)					
	||'^delimiter'||  get_list_from_sql(
					  'select managed_name.external_value  '||
					  'from v_external_org_name managed_name '||
					  'WHERE managed_name.internal_value IN  (SELECT RESOURCE_ID from ^DB_SCHEMA..V_SD_SECURITY_OBJECT_DET  WHERE USER_ID = '||usr.id  || ') '||
					  'and managed_name.namer_id = ^PRIME_ORG '||
					  'and managed_name.MAP_TYPE = ^MAP_ORG ' ||
					  'and managed_name.role = ^ROLE_BANK ' ||
					  'and managed_name.internal_value <>  ' || manager_name.internal_value /* AVOID SELF MANAGERS*/||
					  ' and managed_name.type = 0', ';', NULL)					
	||'^delimiter'||	usr.first_name
	||'^delimiter'||	usr.last_name
    ||'^string'  
from 
	^DB_SCHEMA..sd_security_user usr,
	 v_external_org_name manager_name
where  usr.id IN (SELECT USER_ID FROM ^DB_SCHEMA..V_SD_SECURITY_OBJECT_DET )
  -- Manager external value
  and usr.parent_org_id = manager_name.internal_value
  and manager_name.namer_id = ^PRIME_ORG
  and manager_name.MAP_TYPE = ^MAP_ORG
  and manager_name.type = 0
  and manager_name.role = ^ROLE_BANK
  -- Manager external value
order by 1
;

spool off

prompt *****************************************
prompt Naming IRFE NY - Organizations
prompt *****************************************
spool ^IRFE_NY_Nameing_file

-- Create IRFE NY naming - Organization 
SELECT
	'^string'     ||ext_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when ext_name.role = ^ROLE_FUND then
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and Gapp.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else null
					end									--PARENT_ORGNAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then 'Fund'
						else 'Organization'
					end									--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value				 	--NAME
    ||'^string'  
FROM    
    v_external_org_name ext_name,
	v_external_org_name Gapp
where gapp.map_type = ext_name.map_type 
  and gapp.internal_value = ext_name.internal_value
  and gapp.namer_id = ^NAMER_IRFE_NY
  and gapp.TYPE = 0
  -- Get External name
  and ext_name.map_type IN  (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and ext_name.namer_id = ^PRIME_ORG
  and ext_name.type = 0 
-- Gapp name deffers from default 
  and Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from v_external_org_name n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		  and n.type = 0)	
order by ext_name.external_value ;


-- Create IRFE NY naming - accounts
SELECT  
	'^string'     ||acc_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when org_name.role = ^ROLE_FUND then -- for funds: find the parent client name
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and org_name.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else org_name.external_value
					end									--PARENT_ORGNAME
	||'^delimiter'||CASE 
						WHEN org_name.ROLE = ^ROLE_FUND THEN 'Fund Account'
						ELSE 'Account'
					END 								--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value					--NAME
    ||'^string'  
FROM    
	^DB_SCHEMA..v_arch_data_mapping Gapp,
    ^DB_SCHEMA..v_arch_data_mapping acc_name,
	^DB_SCHEMA..a_object_2_object 	acc2org,
	^DB_SCHEMA..a_account 			acc,
	^DB_SCHEMA..A_STATE_DETAIL 		s_acc,
	v_external_org_name				org_name
where gapp.internal_value = acc_name.internal_value
  and gapp.namer_id = ^NAMER_IRFE_NY
  and gapp.map_type = ^MAP_ACCOUNT 
  and gapp.type = 0
   -- Account default namer external value
  and acc_name.map_type = gapp.map_type
  and acc_name.namer_id = ^PRIME_ORG
  and acc_name.type = 0
  -- Get to org by account
  and acc2org.from_object_type = ^TYPE_ORG
  and acc2org.to_object_type = ^TYPE_ACCOUNT
  and acc2org.relation = 1 -- master account 
  and acc2org.to_object_id = acc.id
  and acc2org.from_object_id = org_name.internal_value
  -- Org default namer name
  and org_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and org_name.namer_id = ^PRIME_ORG
  and org_name.type = 0
  -- Enabled accounts
  and acc.id = acc_name.internal_value 
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
 -- Gapp name deffers from default 
  and Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from ^DB_SCHEMA..v_arch_data_mapping n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		)	
order by acc_name.external_value 
;


-- Create IRFE NY naming - Persons
select 
    '^string'     ||dn.EXTERNAL_VALUE
    ||'^delimiter'||mapp.string
    ||'^delimiter'||'Outgoing'
    ||'^delimiter'||gn.external_value
    ||'^string'  
from 
    ^DB_SCHEMA..v_arch_data_mapping 	dn, -- default namer
    ^DB_SCHEMA..v_arch_data_mapping 	gn,  -- Harmony namer
    ^DB_SCHEMA..A_STATE_DETAIL 			s_user,
	^DB_SCHEMA..sd_security_user		trm_user,
	MIG_TRANSLATIONS					mapp
where
  -- Get data where default namer outgoing <> irfe namer outgoing  
     gn.external_value not in (
		select external_value
		from ^DB_SCHEMA..v_arch_data_mapping n 
		where n.internal_value = gn.internal_value 
		  and n.map_type = gn.map_type
		  and n.namer_id = ^PRIME_ORG
		  and n.type = 0
	  )
  and dn.internal_value = gn.internal_value -- internal value is the coupled account id  
  and dn.map_type = gn.map_type 
  and gn.map_type  in (^MAP_TRADER)
  and dn.namer_id = ^PRIME_ORG
  and dn.type = 0
  and gn.namer_id = ^NAMER_IRFE_NY
  and gn.type = 0 -- only outgoing 
  -- Link to user
  and trm_user.ID = DN.INTERNAL_VALUE
  and trm_user.type = 1 --user
  and trm_user.state_id = s_user.state_id
  and s_user.status_value = 1
  -- Map map_types
  and dn.map_type = mapp.code
  and mapp.key = 'HarmonyMap'
;

spool off


prompt *****************************************
prompt Naming IRFE London - Organizations
prompt *****************************************
spool ^IRFE_London_Nameing_file

-- Create IRFE London naming - Organization 
SELECT
	'^string'     ||ext_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when ext_name.role = ^ROLE_FUND then
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and Gapp.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else null
					end									--PARENT_ORGNAME
	||'^delimiter'||case 
						when Gapp.role = ^ROLE_FUND then 'Fund'
						else 'Organization'
					end									--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value				 	--NAME
    ||'^string'  
FROM    
    v_external_org_name ext_name,
	v_external_org_name Gapp
where gapp.map_type = ext_name.map_type 
  and gapp.internal_value = ext_name.internal_value
  and gapp.namer_id = ^NAMER_IRFE_LD
  and gapp.TYPE = 0
  -- Get External name
  and ext_name.map_type IN  (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and ext_name.namer_id = ^PRIME_ORG
  and ext_name.type = 0 
-- Gapp name deffers from default 
  and Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from v_external_org_name n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		  and n.type = 0)	
order by ext_name.external_value ;


-- Create IRFE London naming - accounts
SELECT  
	'^string'     ||acc_name.external_value    			--INTERNAL_NAME
	||'^delimiter'||case 
						when org_name.role = ^ROLE_FUND then -- for funds: find the parent client name
							(select p_org.external_value 
							 from ^DB_SCHEMA..v_arch_data_mapping p_org, 
							      ^DB_SCHEMA..A_OBJECT_2_OBJECT f2c
							 where p_org.map_type =  ^MAP_ORG
							   and p_org.namer_id = ^PRIME_ORG
							   and p_org.type = 0
							   and p_org.internal_value = f2c.from_object_id
							   and org_name.internal_value = f2c.to_object_id(+)
							   and f2c.to_object_type(+) = ^TYPE_ORG
							   and F2C.FROM_OBJECT_type(+) = ^TYPE_ORG							 
							 )
						else org_name.external_value
					end									--PARENT_ORGNAME
	||'^delimiter'||CASE 
						WHEN org_name.ROLE = ^ROLE_FUND THEN 'Fund Account'
						ELSE 'Account'
					END 								--MAP_TYPE
	||'^delimiter'||'Outgoing'    						--DIRECTION
	||'^delimiter'||Gapp.external_value					--NAME
    ||'^string'  
FROM    
	^DB_SCHEMA..v_arch_data_mapping Gapp,
    ^DB_SCHEMA..v_arch_data_mapping acc_name,
	^DB_SCHEMA..a_object_2_object 	acc2org,
	^DB_SCHEMA..a_account 			acc,
	^DB_SCHEMA..A_STATE_DETAIL 		s_acc,
	v_external_org_name				org_name
where gapp.internal_value = acc_name.internal_value
  and gapp.namer_id = ^NAMER_IRFE_LD
  and gapp.map_type = ^MAP_ACCOUNT 
  and gapp.type = 0
   -- Account default namer external value
  and acc_name.map_type = gapp.map_type
  and acc_name.namer_id = ^PRIME_ORG
  and acc_name.type = 0
  -- Get to org by account
  and acc2org.from_object_type = ^TYPE_ORG
  and acc2org.to_object_type = ^TYPE_ACCOUNT
  and acc2org.relation = 1 -- master account 
  and acc2org.to_object_id = acc.id
  and acc2org.from_object_id = org_name.internal_value
  -- Org default namer name
  and org_name.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and org_name.namer_id = ^PRIME_ORG
  and org_name.type = 0
  -- Enabled accounts
  and acc.id = acc_name.internal_value 
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
 -- Gapp name deffers from default 
  and Gapp.external_value not in 
		(select n.external_value -- Avoid existing names 
		from ^DB_SCHEMA..v_arch_data_mapping n
		where n.internal_value = gapp.internal_value 
		  and n.map_type = gapp.map_type 
		  and n.namer_id = ^prime_org
		)	
order by acc_name.external_value 
;


-- Create IRFE London naming - Persons
select 
    '^string'     ||dn.EXTERNAL_VALUE
    ||'^delimiter'||mapp.string
    ||'^delimiter'||'Outgoing'
    ||'^delimiter'||gn.external_value
    ||'^string'  
from 
    ^DB_SCHEMA..v_arch_data_mapping 	dn, -- default namer
    ^DB_SCHEMA..v_arch_data_mapping 	gn,  -- Harmony namer
    ^DB_SCHEMA..A_STATE_DETAIL 			s_user,
	^DB_SCHEMA..sd_security_user		trm_user,
	MIG_TRANSLATIONS					mapp
where
  -- Get data where default namer outgoing <> irfe namer outgoing  
     gn.external_value not in (
		select external_value
		from ^DB_SCHEMA..v_arch_data_mapping n 
		where n.internal_value = gn.internal_value 
		  and n.map_type = gn.map_type
		  and n.namer_id = ^PRIME_ORG
		  and n.type = 0
	  )
  and dn.internal_value = gn.internal_value -- internal value is the coupled account id  
  and dn.map_type = gn.map_type 
  and gn.map_type  in (^MAP_TRADER)
  and dn.namer_id = ^PRIME_ORG
  and dn.type = 0
  and gn.namer_id = ^NAMER_IRFE_LD
  and gn.type = 0 -- only outgoing 
  -- Link to user
  and trm_user.ID = DN.INTERNAL_VALUE
  and trm_user.type = 1 --user
  and trm_user.state_id = s_user.state_id
  and s_user.status_value = 1
  -- Map map_types
  and dn.map_type = mapp.code
  and mapp.key = 'HarmonyMap'
;

spool off



prompt **************************
prompt Client CCY Authorization 
prompt **************************
spool ^ccy_auth_file

select 
    '^string'     ||    org.EXTERNAL_VALUE  /*external name*/ 
	||'^delimiter'||    acc_name.EXTERNAL_VALUE/*IRFE master account */ 
    ||'^delimiter'||    get_list_from_sql(
							  ' select ccy_pair.CCY_PAIR '
							||' from '
							||'	^DB_SCHEMA..SD_ORG_ALLOWED_CURRENCIES auth_ccy, '
							||' 	^DB_SCHEMA..V_FXCM_CCY_PAIR ccy_pair '
							||' where auth_ccy.ccy_pair_id = ccy_pair.id '
							||' and auth_ccy.org_id = '||org.internal_value, ';', null)
    ||'^string'  
from 
	v_external_org_name  org,
	^DB_SCHEMA..A_OBJECT_2_OBJECT o2o,
	^DB_SCHEMA..v_arch_data_mapping acc_name, 
	^DB_SCHEMA..a_account acc,
	^DB_SCHEMA..A_STATE_DETAIL s_acc
where 
  -- client orgs
      org.role = ^role_client
  and org.namer_id = ^PRIME_ORG
  and org.map_type = ^MAP_CLIENT
  and org.type = 0
  -- link org 2 account
  and o2o.from_object_id = org.internal_value
  and o2o.from_object_type = ^TYPE_ORG
  and o2o.to_object_type = ^TYPE_ACCOUNT
  and o2o.to_object_id = acc.id
  and o2o.relation = 1 -- master account
  -- Enabled account
  and acc.state_id = s_acc.state_id
  and s_acc.status_value = 1
  -- IRFE Name
  and acc_name.internal_value = acc.id
  and acc_name.namer_id = ^PRIME_ORG
  and acc_name.map_type = ^MAP_ACCOUNT
  and acc_name.type = 0
  -- ccy autorization exists for the organization:
  and exists (
		select ccy_pair.CCY_PAIR 
		from 
			^DB_SCHEMA..SD_ORG_ALLOWED_CURRENCIES auth_ccy, 
			^DB_SCHEMA..V_FXCM_CCY_PAIR ccy_pair 
		where auth_ccy.ccy_pair_id = ccy_pair.id 
		and auth_ccy.org_id = org.internal_value
		)
order by 1
;


spool off

