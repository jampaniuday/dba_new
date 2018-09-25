----------------------------------------------------------------------------------
-- Create delete rows scripts:
set echo off
set heading off
set feedback off
spool &delete_old_pure.sql

select 'delete '||tablename||';' from migration where type='PURE'
union all
select 'delete '||tablename||' where '||idfield||'<='||seqval||';' from migration where type='STATIC'

spool off
exit
----------------------------------------------------------------------------------
