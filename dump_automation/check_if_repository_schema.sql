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
select 'YES' from dba_views 
WHERE owner=upper('^1')
and VIEW_NAME = 'IS_DUMP_REPOSITORY_SCHEMA';
exit