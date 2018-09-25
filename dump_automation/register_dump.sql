set define "^"
set heading off feedback off echo off verify off serveroutput on
define TEMP_SCHEMA=^1
define FILE_PATH=^2
define ORIGINAL_SCHEMA=^3
define PID=^4
spool register_dump.log
BEGIN
    AUTOMATION_REPO.REGISTER_DUMP('^FILE_PATH','^TEMP_SCHEMA','^ORIGINAL_SCHEMA','^PID');
END;
/
spool off
exit;