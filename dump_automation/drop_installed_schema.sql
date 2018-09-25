set verify off
set define "^"
set echo off
set heading off
set feedback off
set sqlblank off
set sqlprefix off
set timing off
set time off
set serveroutput ON

DEFINE SCHEMA_NAME=^1
spool drop_installed_schema.log
BEGIN
    

    dbms_application_info.set_client_info('REPOSITORY SCRIPT');



    dbms_output.put_line('Dropping user ^SCHEMA_NAME....');

    BEGIN
       EXECUTE IMMEDIATE 'DROP USER ^SCHEMA_NAME CASCADE';
       DBMS_OUTPUT.PUT_LINE( 'OK.');
    EXCEPTION WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE( 'Failed.' || CHR(10) || SQLERRM);
    END;
    

    dbms_output.put_line('Dropping tablespace TBS_QIN_^SCHEMA_NAME....');

    BEGIN
       EXECUTE IMMEDIATE 'DROP TABLESPACE TBS_QIN_^SCHEMA_NAME INCLUDING CONTENTS AND DATAFILES';
       DBMS_OUTPUT.PUT_LINE( 'OK.');
    EXCEPTION WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE( 'Failed.' || CHR(10) || SQLERRM);
    END;
    

    dbms_output.put_line('Dropping tablespace TBS_STATIC_^SCHEMA_NAME....');

    BEGIN
       EXECUTE IMMEDIATE 'DROP TABLESPACE TBS_STATIC_^SCHEMA_NAME INCLUDING CONTENTS AND DATAFILES';
       DBMS_OUTPUT.PUT_LINE( 'OK.');
    EXCEPTION WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE( 'Failed.' || CHR(10) || SQLERRM);
    END;    
END;
/

spool off
exit;