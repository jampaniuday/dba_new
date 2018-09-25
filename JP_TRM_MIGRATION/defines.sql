set echo on
set define "^"
set pagesize 0
set linesize 3000


/************************/
define DB_SCHEMA=JP_PROD
DEFINE PAST_VALUE_DATE = 7
/************************/

define delimiter='","'
define string='"'
define DATE_TIME="yyyy-mm-dd hh24:mi"
define DATE_NOTE="MM/DD/YYYY hh24:mi:ss"
define DATE_ONLY="MMDDYYYY"
define MIG_NOTE = ':TRM4MIG:'

DEFINE PRIME_ORG    = 1000000
DEFINE NAMER_GAPP   = 1003000
DEFINE NAMER_ATHENA = 1002001
DEFINE NAMER_HARMONY= 1005000
DEFINE NAMER_IRFE_NY= 1001000
DEFINE NAMER_IRFE_LD= 1001001

DEFINE PRIME_ORG    = 1000000

-- Class 401130:
define ROLE_PB      = 1000001
define ROLE_BANK    = 1000002
define ROLE_CLIENT  = 1000003
define ROLE_FUND    = 1000004
define ROLE_ECN     = 1000009

-- Class 400020:
DEFINE TYPE_ORG     = 1000
DEFINE TYPE_ACCOUNT = 2000
DEFINE TYPE_PERSON  = 3000
DEFINE TYPE_EMAIL   = 10000

DEFINE CLASS_ACCOUNT = 1002
DEFINE CLASS_ORG     = 1003
DEFINE CLASS_TRADER  = 1004
DEFINE CLASS_FUND    = 1007
DEFINE CLASS_ECN     = 1012
DEFINE CLASS_ROLES   = 401130

-- TA roles maping
DEFINE TA_ROLE_CLIENT	= 2
DEFINE TA_ROLE_BANK 	= 3
DEFINE TA_ROLE_SPLIT 	= 4
DEFINE TA_ROLE_FUND 	= 5

-- Data mapping types:
DEFINE MAP_ACCOUNT 		= 2
DEFINE MAP_PB			= 3
DEFINE MAP_CLIENT 		= 3
DEFINE MAP_EB 			= 3
DEFINE MAP_ORG 			= 3
DEFINE MAP_TRADER	    = 4
DEFINE MAP_FUND 		= 7
DEFINE MAP_POTFOLIO		= 10
DEFINE MAP_CPLD_ACCOUNT = 11
DEFINE MAP_ECN 			= 12
DEFINE MAP_FINANCIAL_PROPERTIES	= 48
DEFINE MAP_REPORTING_SYSTEM 	= 130
define MAP_AGGREMENT 	= 162

-- User security roles
define USER_TRADE_VIEWER = 9
define USER_TRADE_REPORTER = 5



-- Get propety Keys: 
variable region_key             number
variable recon_stale_key        number
variable alocation_stale_key    number
variable account_key number
variable external_name_key number
variable po_name VARCHAR2(255)

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
	
	    -- Get organization external name data mapping  key 
    SELECT name into :po_name  FROM ^DB_SCHEMA..a_organization WHERE ID = ^PRIME_ORG;

END;
/


set echo off
set trimspool on
set feedback off
set verify off
set heading off


