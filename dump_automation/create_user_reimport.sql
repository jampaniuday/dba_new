set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 
set serveroutput on

spool create_user_reimport.log

define DUMP_ID=^1

define DUMP_SCHEMA=DMP_^DUMP_ID

CREATE USER ^DUMP_SCHEMA IDENTIFIED BY ^DUMP_SCHEMA;
GRANT CONNECT,RESOURCE TO ^DUMP_SCHEMA;
GRANT CREATE MATERIALIZED VIEW to ^DUMP_SCHEMA;
GRANT CREATE ANY SEQUENCE TO ^DUMP_SCHEMA;
GRANT UNLIMITED TABLESPACE TO ^DUMP_SCHEMA;
GRANT DBA TO ^DUMP_SCHEMA;
grant execute on DBMS_LOCK to ^DUMP_SCHEMA;
grant execute on DBMS_SCHEDULER to ^DUMP_SCHEMA;
grant CREATE JOB to ^DUMP_SCHEMA;
grant select any dictionary to ^DUMP_SCHEMA;



spool off
exit;