
CREATE OR REPLACE PROCEDURE GATHER_ARCHIVE_DEFINITIONS
AS

l_sql_stmt VARCHAR2(1000);
v_sqlcode VARCHAR2(30);

BEGIN

DELETE MAIN_ARCHIVE_DEFINITIONS;
COMMIT;

    For i in (SELECT db_link FROM USER_DB_LINKS WHERE db_link LIKE 'GS_%') LOOP

        BEGIN

        l_sql_stmt := 'INSERT INTO MAIN_ARCHIVE_DEFINITIONS (DB_LINK,owner,table_name, dest_table_name, RETENTION, archive_column, order_in_process, partitioned, time_limit, logging_interval, additional_condition, sleep, chunk_size, HINT, status)
  (SELECT '''||i.db_link||''',owner,table_name, dest_table_name, retention, archive_column, order_in_process, partitioned, time_limit, logging_interval, additional_condition, sleep, chunk_size, hint, status FROM dba_apps.ALL_ARCHIVE_DEFINITIONS@'||i.db_link||')';

    EXECUTE IMMEDIATE l_sql_stmt;
 -- DBMS_OUTPUT.PUT_LINE( l_sql_stmt);
        COMMIT;

            EXCEPTION
                      WHEN OTHERS THEN
                      v_sqlcode := SQLCODE;
					  IF v_sqlcode = -942 THEN
					  INSERT INTO MAIN_ARCHIVE_DEFINITIONS (DB_LINK,owner) VALUES (i.db_link,'main archive not deployed');
					  ELSE
                      INSERT INTO MAIN_ARCHIVE_DEFINITIONS (DB_LINK,owner) VALUES (i.db_link,v_sqlcode);
					  END IF;
                      COMMIT;
        END;
    END LOOP;

END;
/





CREATE TABLE MAIN_ARCHIVE_DEFINITIONS
(
  DB_LINK               VARCHAR2(30 BYTE)       ,
  OWNER                 VARCHAR2(30 BYTE)       ,
  TABLE_NAME            VARCHAR2(30 BYTE)       ,
  DEST_TABLE_NAME       VARCHAR2(30 BYTE),
  RETENTION             NUMBER(30)              ,
  ARCHIVE_COLUMN        VARCHAR2(30 BYTE)       ,
  ORDER_IN_PROCESS      NUMBER(10)              ,
  PARTITIONED           NUMBER(1)               DEFAULT 0,
  TIME_LIMIT            NUMBER(10)              DEFAULT 180,
  LOGGING_INTERVAL      NUMBER(10)              DEFAULT 60,
  ADDITIONAL_CONDITION  VARCHAR2(1000 BYTE)     DEFAULT '1=1',
  SLEEP                 NUMBER(10)              DEFAULT 0,
  CHUNK_SIZE            NUMBER(10)              DEFAULT 50000,
  HINT                  VARCHAR2(1000 BYTE),
  STATUS                NUMBER(1)               DEFAULT 0 
);

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.TABLE_NAME IS 'source table name';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.DEST_TABLE_NAME IS 'destination table name. use "NEPTUNE" if destination is new pluto. Use "DROP/DELETE" if records should be deleted.';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.RETENTION IS 'Days to keep in table';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.ARCHIVE_COLUMN IS 'Archive column (relevent only for non-partitioned tables)';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.ORDER_IN_PROCESS IS 'table order in archive processes per owner';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.PARTITIONED IS '0 - no, 1 - yes';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.TIME_LIMIT IS 'Time limit (relevent only for non-partitioned tables)';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.LOGGING_INTERVAL IS 'Logging interval (relevent only for non-partitioned tables)';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.ADDITIONAL_CONDITION IS 'Additional conditions (relevent only for non-partitioned tables)';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.SLEEP IS 'sleep in seconds (relevent only for non-partitioned tables)';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.CHUNK_SIZE IS 'chunk size (relevent only for non-partitioned tables)';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.HINT IS 'optional hint (relevent only for non-partitioned tables)';

COMMENT ON COLUMN MAIN_ARCHIVE_DEFINITIONS.STATUS IS '1 - active, 0 - inactive';



CREATE UNIQUE INDEX UAD_OWNER_ORDER_UK ON MAIN_ARCHIVE_DEFINITIONS
(ORDER_IN_PROCESS);

CREATE UNIQUE INDEX UAD_OWNER_TABLE_UK ON MAIN_ARCHIVE_DEFINITIONS
(TABLE_NAME,OWNER,DB_LINK);




BEGIN
  SYS.DBMS_SCHEDULER.CREATE_PROGRAM
    (
      program_name         => 'REFRESH_ARC_DEFINITIONS_PROG'
     ,program_type         => 'PLSQL_BLOCK'
     ,program_action       => 'BEGIN GATHER_ARCHIVE_DEFINITIONS; END;'
     ,number_of_arguments  => 0
     ,enabled              => FALSE
     ,comments             => NULL
    );

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'REFRESH_ARC_DEFINITIONS_PROG');
END;
/



BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'REFRESH_ARC_DEFINITIONS_JOB'
      ,start_date      => TO_TIMESTAMP_TZ('2013/08/25 07:03:05.000000 +03:00','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'Freq=DAILY;Interval=1'
      ,end_date        => NULL
      ,program_name    => 'REFRESH_ARC_DEFINITIONS_PROG'
      ,comments        => NULL
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'REFRESH_ARC_DEFINITIONS_JOB'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'REFRESH_ARC_DEFINITIONS_JOB'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'REFRESH_ARC_DEFINITIONS_JOB'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'REFRESH_ARC_DEFINITIONS_JOB'
     ,attribute => 'MAX_RUNS');
  BEGIN
    SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
      ( name      => 'REFRESH_ARC_DEFINITIONS_JOB'
       ,attribute => 'STOP_ON_WINDOW_CLOSE'
       ,value     => FALSE);
  EXCEPTION
    -- could fail if program is of type EXECUTABLE...
    WHEN OTHERS THEN
      NULL;
  END;
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'REFRESH_ARC_DEFINITIONS_JOB'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'REFRESH_ARC_DEFINITIONS_JOB'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'REFRESH_ARC_DEFINITIONS_JOB'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'REFRESH_ARC_DEFINITIONS_JOB');
END;
/

