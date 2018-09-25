
-----------------------------------------------------
--- Creation Date: 20-Apl-2004
--- Last Update : 20-Apl-2004
--- Aouthor : Roni Yudkovich
--- Company : Traiana Inc
--- Script Target:
---	Update Database schema 1.7 STF 12.1 Build 7 to 1.7 STF 12.1 Build 8 on JPMC project
------------------------------------------------------

INSERT INTO ARCH_VERSION ( TIMESTAMP, VERSION, DESCRIPTION, LOGFILE, SOLUTION_VERSION )
	VALUES (sysdate , '1.7.12.1::8', 'jpmc 1.7 stf 12', '/Arch2.0/installationLog/databaseInstall.log', '1.7.12.1::8');
	

begin
alter_constraints('disable');
end;
/
--platform

alter table ARCH_OBJ_PROP_DEF add (  ORDER_SEQ          NUMBER (10));
alter table ARCH_OBJ_PROP_DEF modify id not null;

--solutions
delete from ARCH_DATA_MAPPING where id=1002158;
INSERT INTO "ARCH_DATA_MAPPING" ( "ID","NAMER_ID","MAP_TYPE","EXTERNAL_VALUE","INTERNAL_VALUE","TYPE","STATUS" )
	VALUES ( 1002158, 1000000, '1', 'External-Value data is already in use. Please set other value in External-Value field.', 50214, 0, 1);

INSERT INTO ARCH_DATA_MAPPING ( ID, NAMER_ID, MAP_TYPE, EXTERNAL_VALUE, INTERNAL_VALUE, TYPE,STATUS ) 
	VALUES ( 1200043, 1000000, 1, 'failed to find ccy pair for secondery ccy: {0} and base ccy: {1}', 60503, 0, 1); 

INSERT INTO ARCH_DATA_MAPPING ( ID, NAMER_ID, MAP_TYPE, EXTERNAL_VALUE, INTERNAL_VALUE, TYPE,STATUS )
    VALUES (1200044, 1000000, 1, 'Client has no enabled credit line.', 1003031, 0, 1);
INSERT INTO ARCH_DATA_MAPPING ( ID, NAMER_ID, MAP_TYPE, EXTERNAL_VALUE, INTERNAL_VALUE, TYPE,STATUS )
    VALUES (1200050, 1000000, 1, 'Trade Date must be earlier or equal to Settlement Date.', 1003035, 0, 1);
INSERT INTO ARCH_DATA_MAPPING ( ID, NAMER_ID, MAP_TYPE, EXTERNAL_VALUE, INTERNAL_VALUE, TYPE,STATUS )
    VALUES (1200051, 1000000, 1, 'Expiry Date must be earlier or equal to Settlement Date.', 1003036, 0, 1);

delete from ARCH_OBJ_PROP_DEF where id=1000004;
delete from ARCH_OBJ_PROP_DEF where id=1000005;
INSERT INTO ARCH_OBJ_PROP_DEF ( ID, NAME, VALIDATOR, REQUIRED, GROUP_ID, VALUE_TYPE, VALUES_CODE_GROUP, DEFAULT_VALUE, VISIBILITY_MODE, ORDER_SEQ) 
	VALUES ( 1000004, 'Direct Confirmation FX', NULL, 1, 1000004, 'java.lang.String', 'ClientConfirmationProperty', 'No auto-match', NULL, 50); 
INSERT INTO ARCH_OBJ_PROP_DEF ( ID, NAME, VALIDATOR, REQUIRED, GROUP_ID, VALUE_TYPE, VALUES_CODE_GROUP, DEFAULT_VALUE, VISIBILITY_MODE, ORDER_SEQ ) 
	VALUES ( 1000005, 'Direct Confirmation FX Option', NULL, 1, 1000005, 'java.lang.String', 'ClientConfirmationProperty', 'No auto-match', NULL, 60);


begin
alter_constraints('enable');
end;
/
