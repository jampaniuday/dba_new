select group#,status from v$log;


alter database add logfile '/home/oracle/OraHome_1/oradata/orcl/redo04.log' size 300m;
alter database add logfile '/home/oracle/OraHome_1/oradata/orcl/redo05.log' size 300m;
alter database add logfile '/home/oracle/OraHome_1/oradata/orcl/redo06.log' size 300m;
alter database add logfile '/home/oracle/OraHome_1/oradata/orcl/redo07.log' size 300m;
alter database add logfile '/home/oracle/OraHome_1/oradata/orcl/redo08.log' size 300m;

alter database drop logfile '/home/oracle/OraHome_1/oradata/orcl/redo01.log';
alter database drop logfile '/home/oracle/OraHome_1/oradata/orcl/redo02.log';
alter database drop logfile '/home/oracle/OraHome_1/oradata/orcl/redo03.log';

