set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 
set serveroutput on
spool create_destination_schema.log

define SCHEMA_NAME=^1

CREATE USER ^SCHEMA_NAME IDENTIFIED BY ^SCHEMA_NAME;
GRANT CONNECT,RESOURCE,DBA TO ^SCHEMA_NAME;
GRANT CREATE MATERIALIZED VIEW to ^SCHEMA_NAME;
GRANT CREATE ANY SEQUENCE TO ^SCHEMA_NAME;
GRANT UNLIMITED TABLESPACE TO ^SCHEMA_NAME;
GRANT DBA TO ^SCHEMA_NAME;
--grant execute on DBMS_LOCK to ^SCHEMA_NAME;
--grant execute on DBMS_SCHEDULER to ^SCHEMA_NAME;
grant CREATE JOB to ^SCHEMA_NAME;
grant select any dictionary to ^SCHEMA_NAME;

spool off
exit;