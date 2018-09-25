-----------------------------------------------------
--- Creation Date: 20-Apl-2004
--- Last Update : 20-Apl-2004
--- Aouthor : Roni Yudkovich
--- Company : Traiana Inc
--- Script Target:
---	Update Database schema 1.7 STF 12.1 Build 7 to 1.7 STF 12.1 Build 16 on JPMC project
---	** Schema 1.7 STF 12.1 Build 16 is identical to schema 1.7 STF 12.1 Build 15
------------------------------------------------------

begin
alter_constraints('disable');
end;
/

INSERT INTO ARCH_DATA_MAPPING ( ID, NAMER_ID, MAP_TYPE, EXTERNAL_VALUE, INTERNAL_VALUE, TYPE, STATUS ) 
	VALUES (1200045, 1000000, 1, 'Error while processing Murex EOD File: {0}', 1003026, 0, 1); 


INSERT INTO ARCH_LOG_MESSAGES ( MSG_ID, MESSAGE, LOG_MSG_DEVISION, LANG ) 
	VALUES ( 1003026, 'Error while processing Murex EOD File: {0}', 1000004, NULL); 

INSERT INTO ARCH_LOG_MESSAGES ( MSG_ID, MESSAGE, LOG_MSG_DEVISION,LANG )
    VALUES (1003031, 'Client {0} has no enabled credit line.', 1000004, NULL);
INSERT INTO ARCH_LOG_MESSAGES ( MSG_ID, MESSAGE, LOG_MSG_DEVISION, LANG )
	VALUES (1003035, 'Trade Date must be earlier or equal to Settlement Date', 1000004, NULL);

INSERT INTO ARCH_LOG_MESSAGES ( MSG_ID, MESSAGE, LOG_MSG_DEVISION, LANG )
	VALUES (1003036, 'Expiry Date must be earlier or equal to Settlement Date', 1000004, NULL);


INSERT INTO ARCH_VERSION ( TIMESTAMP, VERSION, DESCRIPTION, LOGFILE, SOLUTION_VERSION )
	VALUES (sysdate , '1.7.12.1::16', 'jpmc 1.7 stf 12', '/Arch2.0/installationLog/databaseInstall.log', '1.7.12.1::16');


begin
alter_constraints('enable');
end;
/
