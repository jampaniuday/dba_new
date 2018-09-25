set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 
set serveroutput on
spool reopen_tablespaces.log
define SCHEMA_NAME=^1

ALTER TABLESPACE TBS_STATIC_^SCHEMA_NAME READ WRITE;
ALTER TABLESPACE TBS_QIN_^SCHEMA_NAME READ WRITE;
spool off
exit;