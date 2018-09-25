
BEGIN
  SYS.DBMS_SCHEDULER.CREATE_PROGRAM
    (
      program_name         => 'SPM_MANAGER_PROG'
     ,program_type         => 'PLSQL_BLOCK'
     ,program_action       => 'BEGIN
				spm_manager.load_sqls;
				spm_manager.evolve_plans;
				END;'
     ,number_of_arguments  => 0
     ,enabled              => FALSE
     ,comments             => NULL
    );

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'SPM_MANAGER_PROG');
END;
/



BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'SPM_MANAGER_JOB'
      ,start_date      => TO_TIMESTAMP_TZ('2011/08/01 08:00:00.000000 America/New_York','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'FREQ=HOURLY; INTERVAL=1; BYDAY=MON,TUE,WED,THU,FRI'
      ,end_date        => NULL
      ,program_name    => 'SPM_MANAGER_PROG'
      ,comments        => NULL
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'SPM_MANAGER_JOB'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'SPM_MANAGER_JOB'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_RUNS);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'SPM_MANAGER_JOB'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'SPM_MANAGER_JOB'
     ,attribute => 'MAX_RUNS');
  BEGIN
    SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
      ( name      => 'SPM_MANAGER_JOB'
       ,attribute => 'STOP_ON_WINDOW_CLOSE'
       ,value     => FALSE);
  EXCEPTION
    -- could fail if program is of type EXECUTABLE...
    WHEN OTHERS THEN
      NULL;
  END;
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'SPM_MANAGER_JOB'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'SPM_MANAGER_JOB'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'SPM_MANAGER_JOB'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'SPM_MANAGER_JOB');
END;
/
