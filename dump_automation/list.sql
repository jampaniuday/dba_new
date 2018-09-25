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

SELECT RPAD('ID',8) || RPAD('APPLICATION', 13) || RPAD('ORIGINAL_SCHEMA', 20) || RPAD('APP_VERSION',20) || RPAD('IC_VERSION',15) || RPAD('LAST_ALIVE_TIME',16) || RPAD('DUMP_SIZE(GB)',13) LIST FROM dual
UNION ALL
SELECT rpad(t.ID,8) || RPAD(APP_NAME, 13) || RPAD(t.ORIGINAL_SCHEMA,20) || RPAD(t.APP_VERSION,20) || RPAD(t.IC_VERSION,15) || RPAD(t.LAST_ALIVE_TIME,15)|| RPAD((select to_char(SUM(t2.bytes)/1024/1024/1024,'0.00') from dba_data_files t2 WHERE t2.TABLESPACE_NAME LIKE 'TBS_%_'||t.ID),13)  LIST
FROM DUMP_REPOSITORY t 
where pid is null
and upper(app_name) like upper('^1')
order by LIST desc
;
EXIT
