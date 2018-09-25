
set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 
set serveroutput on

spool drop_user.log

define TEMP_SCHEMA=^1
DROP USER ^TEMP_SCHEMA CASCADE;	    

spool off
exit;