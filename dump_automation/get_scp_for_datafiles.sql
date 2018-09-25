CLEAR
set verify off
SET LINESIZE 1000
set define "^"
set echo OFF
set heading OFF
set feedback OFF
set sqlblank OFF
set timing OFF
set time OFF
set serveroutput ON
define HOST_NAME=^1
define PROCESSED_DUMPS_DIR=^2
define TMP_SUFFIX=^3
define SCHEMA_NAME=^4

WITH tablespaces AS
(
SELECT DISTINCT tablespace_name FROM dba_segments t WHERE t.OWNER = '^SCHEMA_NAME'
)
SELECT 'oracle@^HOST_NAME:' || t2.FILE_NAME || ' ^PROCESSED_DUMPS_DIR.tmp_' || lower(SUBSTR(t.tablespace_name,5,3)) ||'_^TMP_SUFFIX..dbf'
FROM tablespaces t 
JOIN DBA_DATA_FILES t2
ON (t.tablespace_name = t2.TABLESPACE_NAME);
exit