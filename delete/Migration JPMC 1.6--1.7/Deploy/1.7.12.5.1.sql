-----------------------------------------------------
--- Creation Date: 12-May-2004
--- Aouthor : Isaac Raz
--- Company : Traiana Inc
--- Script Target:
---	Update Database schema 1.7.12.4 to  1.7.12.5 on JPMC project. 
---	This schema update fixes CR 6654 
--- Updates Tracking :
--- Last Update :   
------------------------------------------------------
set echo on
-- spool  DBScript1-7-12-5.log

begin
 alter_constraints('disable');
end;
/

INSERT INTO ARCH_VERSION ( TIMESTAMP, VERSION, DESCRIPTION, LOGFILE, SOLUTION_VERSION )
	VALUES (sysdate , '1.7.12.5', '1.7.12.5 - Fix CR 6654', '/Arch2.0/installationLog/databaseInstall.log', '1.7.12.5');

--------------------------------
-------platform updates---------
--------------------------------


--------------------------------
-------solutions updates---------
--------------------------------

--- \TABLES\ARCH_MSG_LOGIC_INFO\data.sql
delete ARCH_MSG_LOGIC_INFO where ID in (1000026,1000027);
INSERT INTO ARCH_MSG_LOGIC_INFO ( ID,ATTR,DESCRIPTION,PRE_FLOW_ID,FLOW_ID )
	VALUES (1000026,3,'Check 4 option reconciliation stale',NULL,1000051 ) ;
INSERT INTO ARCH_MSG_LOGIC_INFO ( ID,ATTR,DESCRIPTION,PRE_FLOW_ID,FLOW_ID )
	VALUES (1000027,3,'Check 4 option allocation stale',NULL,1000055 ) ;


---- \TABLES\ARCH_MSG_PROTOCOL_INFO\data.sql
delete ARCH_MSG_PROTOCOL_INFO where ID in (1000060,1000061,1000099);
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID,LOGIC_MSG_ID,IN_TRANSFORMER,OUT_TRANSFORMER,DESCRIPTION,NAME )
	VALUES (1000060,1000026,NULL,NULL,'Check 4 option reconciliation stale','Check4StaleOptionRecon' ) ;
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID,LOGIC_MSG_ID,IN_TRANSFORMER,OUT_TRANSFORMER,DESCRIPTION,NAME )
	VALUES (1000061,1000027,NULL,NULL,'Check 4 option alocation stale','Check4StaleOptionAllocation' ) ;
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
	VALUES ( 1000099, 1000098, 'irfeEODInMsg-DelimiterString', 'irfeEODInMsg-DelimiterString', 'Irfe EOD Settling Trades', 'Irfe EOD Settling Trades');

delete ARCH_MSG_PROTOCOL_INFO where ID>=1000104 and ID<=1000109;
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION,NAME )
	VALUES ( 1000104, 1000104, 'FlatJPMC-Xml', 'JPMC_Flat2_CSV', 'Modify Split -Protocol', 'ModifySplit_Protocol');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION,NAME )
	VALUES ( 1000105, 1000105, 'FlatJPMC-Xml', 'JPMC_Flat2_CSV', 'New Split -Protocol', 'NewSplit_Protocol');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION,NAME )
	VALUES ( 1000106, 1000014, 'FlatJPMC-Xml', 'JPMC_Flat2_CSV', 'Delete Noe- Protocol', 'DeleteNoe_Protocol');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION,NAME )
	VALUES ( 1000107, 1000101, 'FlatJPMC-Xml', 'JPMC_Flat2_CSV', 'Modify Noe - Protocol', 'ModifyNoe_Protocol');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION,NAME )
	VALUES ( 1000108, 1000100, 'FlatJPMC-Xml', 'JPMC_Flat2_CSV', 'New Noe - Protocol', 'NewNoe_Protocol');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION,NAME )
	VALUES ( 1000109, 1000102, 'FlatJPMC-Xml', 'JPMC_Flat2_CSV', 'New Noe Split- Protocol', 'NewNoeSplit_Protocol');

delete ARCH_MSG_PROTOCOL_INFO where ID in (1100050,1100113,1100100,1100101,1100114,1100115,1100116,1100117,1100102,1100103);
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
	VALUES ( 1100050, 1100050, NULL, NULL, 'Bony Integration Excel File', 'BonyIntegration');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
        VALUES ( 1100113, 1100115, 'FlatOptionNoeJPMC-Xml', 'JPMC_OptionFlat2_CSV', 'New Option Noe (Xml)', 'NewOptionNoeXml');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
        VALUES ( 1100100, 2000000, 'JPMC_OptionFlat2_CSV', 'JPMC_OptionFlat2_CSV', 'Option Noe Flat Protocol', 'Option Noe Flat Protocol');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
        VALUES ( 1100101, 2000000, 'JPMC_OptionFlat2_CSV', 'JPMC_OptionFlat2_CSV', 'Option Noe Flat Protocol 2', 'Option Noe Flat Protocol 2');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
        VALUES ( 1100114, 1100116, 'FlatOptionSplitJPMC-Xml', 'JPMC_OptionFlat2_CSV', 'New Option Split (Xml)', 'NewOptionSplitXml');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
        VALUES ( 1100115, 1100117, 'FlatOptionNoeJPMC-Xml', 'JPMC_OptionFlat2_CSV', 'Modify Option Noe (Xml)', 'ModifyOptionNoeXml');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
        VALUES ( 1100116, 1100014, 'FlatOptionNoeJPMC-Xml', 'JPMC_OptionFlat2_CSV', 'Delete Option Noe (Xml)', 'DeleteOptionNoeXml');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
        VALUES ( 1100117, 1100118, 'FlatOptionSplitJPMC-Xml', 'JPMC_OptionFlat2_CSV', 'Modify Option Split (Xml)', 'ModifyOptionSplitXml');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
        VALUES ( 1100102, 2000000, 'JPMC_Flat2_CSV', 'JPMC_Flat2_CSV', 'Linear Noe Flat Protocol', 'Linear Noe Flat Protocol');
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION, NAME )
        VALUES ( 1100103, 2000000, 'JPMC_Flat2_CSV', 'JPMC_Flat2_CSV', 'Linear Noe Flat Protocol 2', 'Linear Noe Flat Protocol 2');


COMMIT;
      
begin
 alter_constraints('enable');
end;
/

-- spool  off
------ END OF SCRIPT ---------