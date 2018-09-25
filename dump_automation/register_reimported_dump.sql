set define "^"
set heading off feedback off echo off verify off serveroutput on

define DUMP_ID=^1
define SCHEMA_NAME=^2

spool register_reimported_dump.log
INSERT INTO AUTOMATION_REPO.DUMP_REPOSITORY
    (ID, ORIGINAL_FILE_PATH, LAST_ALIVE_TIME, IC_VERSION, APP_VERSION, ORIGINAL_SCHEMA, PID)
    WITH SUB AS
     (SELECT 're-import from dump repository schema' ORIGINAL_FILE_PATH,
             LAST_ALIVE_TIME,
             VERSION IC_VERSION,
             HOST_APP_VERSION APP_VERSION,
             '^SCHEMA_NAME' ORIGINAL_SCHEMA,
             NULL PID
      FROM   DMP_^DUMP_ID..IC_CNFG_INSTANCE T
      WHERE  STATUS = 1
      AND    TYPE = 1
      ORDER  BY LAST_ALIVE_TIME DESC),
    SUB2 AS
     (SELECT ^DUMP_ID ID, SUB.* FROM SUB WHERE ROWNUM < 2)
    SELECT * FROM SUB2;
    
DECLARE
  DUMMY NUMBER;   
  l_application_name VARCHAR2(100); 
  l_generic_version VARCHAR2(100);
BEGIN
 EXECUTE IMMEDIATE 'select count(*) from dba_views where owner = ''DMP_^DUMP_ID'' and view_name = ''V_CURRENT_PRODUCT_VERSION'''
      INTO DUMMY;

    IF DUMMY = 1 THEN

       EXECUTE IMMEDIATE 'select application, full_version from DMP_^DUMP_ID..V_CURRENT_PRODUCT_VERSION' INTO l_application_name, l_generic_version;
       UPDATE automation_repo.DUMP_REPOSITORY t SET APP_NAME = l_application_name, generic_version = l_generic_version WHERE ID = ^DUMP_ID;
    END IF;
END;
/

commit;
spool off
exit
