set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 
set serveroutput on
spool rename_and_open_tablespaces.log
define DUMP_ID=^1
define SCHEMA_NAME=^2


ALTER TABLESPACE TBS_STATIC_^DUMP_ID READ WRITE;
ALTER TABLESPACE TBS_QIN_^DUMP_ID READ WRITE;
ALTER TABLESPACE TBS_STATIC_^DUMP_ID RENAME TO TBS_STATIC_^SCHEMA_NAME;
ALTER TABLESPACE TBS_QIN_^DUMP_ID RENAME TO TBS_QIN_^SCHEMA_NAME;
alter user ^SCHEMA_NAME
  default tablespace TBS_STATIC_^SCHEMA_NAME;

create or replace view ^SCHEMA_NAME..is_dump_repository_schema as
select 'YES' is_from_repository from dual;
spool off
exit;