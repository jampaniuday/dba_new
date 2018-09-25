set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 
set serveroutput on

define ORIGINAL_SCHEMA=^1
define DUMP_ID=^2
define DBF_PATH=^3
define TEMP_ID=^4
spool prepare_reimported_tablespaces.log

ALTER TABLESPACE tbs_qin_^ORIGINAL_SCHEMA RENAME TO tbs_qin_^DUMP_ID;
ALTER TABLESPACE tbs_static_^ORIGINAL_SCHEMA RENAME TO tbs_static_^DUMP_ID;

ALTER TABLESPACE tbs_qin_^DUMP_ID OFFLINE NORMAL;
ALTER TABLESPACE tbs_static_^DUMP_ID OFFLINE NORMAL;

host mv ^DBF_PATH.tmp_qin_^TEMP_ID..dbf ^DBF_PATH.qin_^DUMP_ID..dbf
host mv ^DBF_PATH.tmp_sta_^TEMP_ID..dbf ^DBF_PATH.static_^DUMP_ID..dbf
-- use mv before

ALTER TABLESPACE tbs_qin_^DUMP_ID RENAME DATAFILE '^DBF_PATH.tmp_qin_^TEMP_ID..dbf' TO '^DBF_PATH.qin_^DUMP_ID..dbf';
ALTER TABLESPACE tbs_static_^DUMP_ID RENAME DATAFILE '^DBF_PATH.tmp_sta_^TEMP_ID..dbf' TO '^DBF_PATH.static_^DUMP_ID..dbf';

ALTER TABLESPACE tbs_qin_^DUMP_ID ONLINE;
ALTER TABLESPACE tbs_static_^DUMP_ID ONLINE;

spool off
exit;