set define "^"
set pagesize 0
set linesize 3000
set echo off
set termout off
set trimspool on
set feedback off
set verify off
set heading off
define ccy_auth_file = 17b_Create_Client_CCY_Pair_Authorization.csv


spool TRM3_CCY_PAIR_AUTH_DATA.sql

select 'CREATE TABLE TRM3_CCY_PAIR_AUTH_DATA (
		Org_name		varchar2(255), 
		Account_name	varchar2(255), 
		ccy_pair		varchar2(255)
	    );'
from dual;
		
select 
	'INSERT INTO TRM3_CCY_PAIR_AUTH_DATA (Org_name, Account_name, ccy_pair) values ('||
    q'!'!'     ||    org.EXTERNAL_VALUE  /*external name*/ 
	||q'!','!'||    acc_name.EXTERNAL_VALUE/*IRFE master account */ 
    ||q'!','!'||    ccy_pair.CCY_PAIR
    ||q'!');!'
from 
	^DB_SCHEMA..SD_ORG_ALLOWED_CURRENCIES auth_ccy,
	v_external_org_name  org,
	^DB_SCHEMA..A_OBJECT_2_OBJECT o2o,
	^DB_SCHEMA..v_arch_data_mapping acc_name, 
	^DB_SCHEMA..a_account acc,
	^DB_SCHEMA..A_STATE_DETAIL s_acc,
	^DB_SCHEMA..ARCH_BILLING_CCY_PAIR  ccy_pair
where auth_ccy.ccy_pair_id = ccy_pair.id
  -- client orgs
  and auth_ccy.org_id = org.internal_value
  and org.role = ^role_client
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
order by 1
;

select 'COMMIT;' from dual;

spool off



prompt **************************
prompt Client CCY Authorization 
prompt **************************
spool ^ccy_auth_file

	
select 
	'^string'     ||org.EXTERNAL_VALUE  /*external name*/ 
	||'^delimiter'||acc_name.EXTERNAL_VALUE/*IRFE master account */ 
    ||'^delimiter'||ccy_pair.CCY_PAIR
	||'^string'
from 
	^DB_SCHEMA..SD_ORG_ALLOWED_CURRENCIES auth_ccy,
	v_external_org_name  org,
	^DB_SCHEMA..A_OBJECT_2_OBJECT o2o,
	^DB_SCHEMA..v_arch_data_mapping acc_name, 
	^DB_SCHEMA..a_account acc,
	^DB_SCHEMA..A_STATE_DETAIL s_acc,
	^DB_SCHEMA..ARCH_BILLING_CCY_PAIR  ccy_pair
where auth_ccy.ccy_pair_id = ccy_pair.id
  -- client orgs
  and auth_ccy.org_id = org.internal_value
  and org.role = ^role_client
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
order by 1
;

spool off

