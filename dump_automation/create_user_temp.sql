set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 
set serveroutput on
spool create_user_temp.log
define TEMP_SCHEMA=^1
CREATE USER ^TEMP_SCHEMA IDENTIFIED BY ^TEMP_SCHEMA;
GRANT CONNECT,RESOURCE TO ^TEMP_SCHEMA;

spool off
exit;