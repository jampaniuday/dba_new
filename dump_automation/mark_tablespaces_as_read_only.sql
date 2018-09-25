set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 
set serveroutput on
spool mark_tablespaces_as_read_only.log
define DUMP_ID=^1
ALTER TABLESPACE TBS_STATIC_^DUMP_ID READ ONLY;
ALTER TABLESPACE TBS_QIN_^DUMP_ID READ ONLY;
spool off
exit;