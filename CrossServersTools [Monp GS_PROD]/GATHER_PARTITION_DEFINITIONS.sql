
CREATE OR REPLACE PROCEDURE GATHER_PARTITION_DEFINITIONS
AS

l_sql_stmt VARCHAR2(1000);
v_sqlcode VARCHAR2(30);

BEGIN

DELETE MAIN_PARTITION_DEFINITIONS;
COMMIT;

    For i in (SELECT db_link FROM USER_DB_LINKS WHERE db_link LIKE 'GS_%') LOOP

        BEGIN

        l_sql_stmt := 'INSERT INTO MAIN_PARTITION_DEFINITIONS(DB_LINK,owner, table_name, RETENTION, days_ahead, order_in_process, partition_tablespace_name, status, VALIDATION, period_size, date_format, cron_expr, growth_factor, part_prefix)
  (SELECT '''||i.db_link||''',owner, table_name, retention, days_ahead, order_in_process, partition_tablespace_name, status, validation, period_size, date_format, cron_expr, growth_factor, part_prefix FROM dba_apps.PARTITION_DEFINITIONS@'||i.db_link||')';

  --  EXECUTE IMMEDIATE l_sql_stmt;
  DBMS_OUTPUT.PUT_LINE( l_sql_stmt);
        COMMIT;

            EXCEPTION
                      WHEN OTHERS THEN
                      v_sqlcode := SQLCODE;
                      IF v_sqlcode = -942 THEN
                      NULL;
                      ELSE
                      INSERT INTO MAIN_PARTITION_DEFINITIONS (DB_LINK,owner) VALUES (i.db_link,v_sqlcode);
                      END IF;
                      COMMIT;
        END;
    END LOOP;

END;
/



CREATE TABLE MAIN_PARTITION_DEFINITIONS
(
  DB_LINK                    VARCHAR2(30 BYTE)  ,
  OWNER                      VARCHAR2(30 BYTE)  ,
  TABLE_NAME                 VARCHAR2(30 BYTE)  ,
  RETENTION                  NUMBER(30)         ,
  DAYS_AHEAD                 NUMBER(30)         ,
  ORDER_IN_PROCESS           NUMBER(10)         ,
  PARTITION_TABLESPACE_NAME  VARCHAR2(30 BYTE)  DEFAULT 'USERS'               ,
  STATUS                     NUMBER(1)          DEFAULT 0                     ,
  VALIDATION                 VARCHAR2(4000 BYTE),
  PERIOD_SIZE                NUMBER(10),
  DATE_FORMAT                VARCHAR2(40 BYTE),
  CRON_EXPR                  VARCHAR2(40 BYTE),
  GROWTH_FACTOR              NUMBER             DEFAULT 0.95                  ,
  PART_PREFIX                VARCHAR2(10 BYTE)
);

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.TABLE_NAME IS 'source table name';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.RETENTION IS 'Days to keep in table';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.DAYS_AHEAD IS 'Days to prepare ahead (relevent only for partitioned tables)';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.ORDER_IN_PROCESS IS 'table order in archive processes per owner';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.PARTITION_TABLESPACE_NAME IS 'Tablespace for newly created partitions (relevent only for partitioned tables)';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.STATUS IS '1 - active, 0 - inactive';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.VALIDATION IS 'condition for drop partitions';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.PERIOD_SIZE IS 'partition period size';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.DATE_FORMAT IS 'partition name date format';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.CRON_EXPR IS 'crontab';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.GROWTH_FACTOR IS 'next partition size';

COMMENT ON COLUMN MAIN_PARTITION_DEFINITIONS.PART_PREFIX IS 'partition prefix';



CREATE UNIQUE INDEX PD_OWNER_ORDER_UK ON MAIN_PARTITION_DEFINITIONS(DB_LINK,OWNER, ORDER_IN_PROCESS);

CREATE UNIQUE INDEX PD_OWNER_TABLE_UK ON MAIN_PARTITION_DEFINITIONS(DB_LINK,OWNER, TABLE_NAME);






BEGIN
  SYS.DBMS_SCHEDULER.CREATE_PROGRAM
    (
      program_name         => 'REFRESH_PART_DEFINITIONS_PROG'
     ,program_type         => 'PLSQL_BLOCK'
     ,program_action       => 'BEGIN GATHER_PARTITION_DEFINITIONS; END;'
     ,number_of_arguments  => 0
     ,enabled              => FALSE
     ,comments             => NULL
    );

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'REFRESH_PART_DEFINITIONS_PROG');
END;
/



BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'REFRESH_PART_DEFINITIONS_JOB'
      ,start_date      => TO_TIMESTAMP_TZ('2013/08/25 07:03:05.000000 +03:00','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'Freq=DAILY;Interval=1'
      ,end_date        => NULL
      ,program_name    => 'REFRESH_PART_DEFINITIONS_PROG'
      ,comments        => NULL
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'REFRESH_PART_DEFINITIONS_JOB'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'REFRESH_PART_DEFINITIONS_JOB'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'REFRESH_PART_DEFINITIONS_JOB'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'REFRESH_PART_DEFINITIONS_JOB'
     ,attribute => 'MAX_RUNS');
  BEGIN
    SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
      ( name      => 'REFRESH_PART_DEFINITIONS_JOB'
       ,attribute => 'STOP_ON_WINDOW_CLOSE'
       ,value     => FALSE);
  EXCEPTION
    -- could fail if program is of type EXECUTABLE...
    WHEN OTHERS THEN
      NULL;
  END;
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'REFRESH_PART_DEFINITIONS_JOB'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'REFRESH_PART_DEFINITIONS_JOB'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'REFRESH_PART_DEFINITIONS_JOB'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'REFRESH_PART_DEFINITIONS_JOB');
END;
/

