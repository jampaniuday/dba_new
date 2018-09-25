CLEAR
set define "^"
set echo OFF
set heading OFF
set feedback OFF
set sqlblank OFF
set sqlprefix off
set timing OFF
set time OFF
set serveroutput on


spool cleanup.log

DECLARE
	DUMP_ID NUMBER;

	DUMP_SCHEMA        VARCHAR2(100);
	DEFAULT_TABLESPACE VARCHAR2(100);
	DATAFILE_STATIC    VARCHAR2(100);
	QIN_TABLESPACE     VARCHAR2(100);
	DATAFILE_QIN       VARCHAR2(100);
	DATAFILES_DIR      VARCHAR2(100);

BEGIN

	SELECT T.DIRECTORY_PATH || '/'
	INTO   DATAFILES_DIR
	FROM   DBA_DIRECTORIES T
	WHERE  T.DIRECTORY_NAME = 'PROCESSED_DUMPS_DIR';

	FOR A IN (SELECT T.ID FROM AUTOMATION_REPO.DUMP_REPOSITORY T WHERE T.PID IS NOT NULL) LOOP
	
		DUMP_ID := A.ID;
	
		DUMP_SCHEMA        := 'DMP_' || DUMP_ID;
		DEFAULT_TABLESPACE := 'TBS_STATIC_' || DUMP_ID;
		DATAFILE_STATIC    := DATAFILES_DIR || 'static_' || DUMP_ID || '.dbf';
		QIN_TABLESPACE := 'TBS_QIN_' || DUMP_ID;
		DATAFILE_STATIC    := DATAFILES_DIR || 'qin_' || DUMP_ID || '.dbf';
	
		FOR MVIEW IN (SELECT T.MVIEW_NAME FROM DBA_MVIEWS T WHERE T.OWNER = DUMP_SCHEMA) LOOP
			BEGIN
				DBMS_OUTPUT.PUT_LINE('dropping materialized view ' || DUMP_SCHEMA || '.' ||
														 MVIEW.MVIEW_NAME || '...');
				EXECUTE IMMEDIATE 'drop materialized view ' || DUMP_SCHEMA || '.' || MVIEW.MVIEW_NAME;
			EXCEPTION
				WHEN OTHERS THEN
					DBMS_OUTPUT.PUT_LINE(SQLERRM);
			END;
		END LOOP;
	
		BEGIN
			DBMS_OUTPUT.PUT_LINE('dropping tablespace ' || QIN_TABLESPACE ||
													 ' including contents and datafiles');
			EXECUTE IMMEDIATE 'drop tablespace ' || QIN_TABLESPACE || ' including contents and datafiles';
		EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
		END;
	
		BEGIN
			DBMS_OUTPUT.PUT_LINE('dropping tablespace ' || DEFAULT_TABLESPACE ||
													 ' including contents and datafiles...');
			EXECUTE IMMEDIATE 'drop tablespace ' || DEFAULT_TABLESPACE ||
												' including contents and datafiles';
		EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
		END;
    
    BEGIN
			DBMS_OUTPUT.PUT_LINE('dropping user ' || dump_schema || ' cascade...');
			EXECUTE IMMEDIATE 'drop user ' || dump_schema || ' cascade';
		EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
		END;
	
		DELETE FROM AUTOMATION_REPO.DUMP_REPOSITORY WHERE ID = a.id;
    COMMIT;
	END LOOP;
END;
/

spool off
EXIT
