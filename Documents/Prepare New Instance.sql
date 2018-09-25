-- Check init params:
--    1. OPTIMIZER_MODE
--    2. OPTIMIZER_FEATURES_ENABLED

exec dbms_scheduler.disable('AUTO_SPACE_ADVISOR_JOB');
exec dbms_scheduler.disable('GATHER_STATS_JOB');


exec DBMS_STATS.SET_PARAM('method_opt', 'FOR ALL COLUMNS SIZE REPEAT');

exec DBMS_STATS.SET_PARAM('degree', 'DBMS_STATS.DEFAULT_DEGREE');

exec DBMS_STATS.SET_PARAM('estimate_percent', 'NULL');

exec DBMS_STATS.SET_PARAM('cascade', 'TRUE');

exec DBMS_STATS.SET_PARAM('no_invalidate', 'FALSE');



exec DBMS_STATS.GATHER_SYSTEM_STATS('NOWORKLOAD');


EXECUTE DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(interval  =>  30,retention =>  20160);


-- Create schedulers for gathering statistics.


-- DBA_APPS user + Log_Manager
