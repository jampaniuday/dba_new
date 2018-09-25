BEGIN
  SYS.DBMS_SCHEDULER.CREATE_PROGRAM
    (
      program_name         => 'GATHER_DICT_STATS_PROG'
     ,program_type         => 'PLSQL_BLOCK'
     ,program_action       => 'Gather_Statistics.Dictionary;'
     ,number_of_arguments  => 0
     ,enabled              => FALSE
     ,comments             => NULL
    );

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'GATHER_DICT_STATS_PROG');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'GATHER_DICT_STATS'
      ,start_date      => TO_TIMESTAMP_TZ('2008/01/17 08:00:00.000000 +02:00','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'FREQ=WEEKLY; BYDAY=SAT; BYHOUR=08; BYMINUTE=0;BYSECOND=0'
      ,end_date        => NULL
      ,program_name    => 'GATHER_DICT_STATS_PROG'
      ,comments        => NULL
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'GATHER_DICT_STATS'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'GATHER_DICT_STATS'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_RUNS);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'GATHER_DICT_STATS'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'GATHER_DICT_STATS'
     ,attribute => 'MAX_RUNS');
  BEGIN
    SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
      ( name      => 'GATHER_DICT_STATS'
       ,attribute => 'STOP_ON_WINDOW_CLOSE'
       ,value     => FALSE);
  EXCEPTION
    -- could fail if program is of type EXECUTABLE...
    WHEN OTHERS THEN
      NULL;
  END;
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'GATHER_DICT_STATS'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'GATHER_DICT_STATS'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'GATHER_DICT_STATS'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'GATHER_DICT_STATS');
END;
/

