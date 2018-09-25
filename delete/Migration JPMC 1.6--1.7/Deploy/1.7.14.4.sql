----------------------------------------------------------------------------------------------------------
--													--
-- Date : 09-Jun-2004											--
-- Company: Traiana Inc. 										--
-- Author : Isaac Raz 											--
--													--
-- Patch format:											--
-- 	Fixed header actions:										--
--		-Spool file										--
--		-Set options										--
--		-Alter constraints enable (Target: validate all FKs before updates)			--
--		-Alter constraints disable								--
--	patch updates:											--
--		-Sequential append of scripts from all the builds at the delivery			--
--	Fixed footer actions:										--
-- 		-Update properties									--
--		-Run others.sql 									--
--		-Mark version to DB									--
--		-Enable constraints									--
--		-Commit changes										--
--	Notes:												--
--		1. Do not use commit within the patches updates						--
--													--
-- Updates Tacking:											--
-- 13-Jun-2004: 											--
--	** Propertiese update (at the footer) added functionality: Obsolete properties removal.		--	
-- 28-Jun-2004												--
--	
----------------------------------------------------------------------------------------------------------
--WHENEVER SQLERROR EXIT -1
--WHENEVER OSERROR EXIT  -2
-- spool 1.7.14.4.1.log
set echo on
set heading on
set feedback on
set scan off
set sqlblank on


exec alter_constraints('enable');
exec alter_constraints('disable');

--********************************************************************************************************--
--**			F I X E D   H E A D E R	 ends here 	 					**--
--********************************************************************************************************--

--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++
-- build 1.7.14.4.1

delete arch_report_column where ID=1101709;
INSERT INTO ARCH_REPORT_COLUMN ( ID, REPORT_ID, LOGICAL_NAME, VISIBLE_NAME, FILTER_NAME, TYPE,VALIDATOR, CONVERTER, HELPER, VISIBILITY, SETTER, ORDER_SEQ, TABLE_NAME, FOOTER_SETTER,HEADER_SETTER ) 
	VALUES (1101709, 1101700, 'TRADE_REF_ID', 'Trade Ref', 'Trade Ref', 'Long', 'long', NULL, NULL, NULL, 'LINK:optionctrep.lwp?g0_fCond==&g0_fName=TRADE_ID&g0_fOp=NONE&g0_fValue=$TRADE_REF_ID&g0_fltr=0&g0_fId=0&g0_fParentId=-1&g0_fVisibility=0&ExecuteFromLink=ExecuteFromLink', 100, 'TRADE_REF_ID', NULL, NULL);

delete arch_data_mapping where ID=1200043;
INSERT INTO ARCH_DATA_MAPPING ( ID, NAMER_ID, MAP_TYPE, EXTERNAL_VALUE, INTERNAL_VALUE, TYPE,STATUS )
	VALUES ( 1200043, 1000000, 1, 'Failed to find ccy pair for secondary ccy: {0} and base ccy: {1}', 60503, 0, 1);

delete arch_flow_def where ID=1100060;
INSERT INTO ARCH_FLOW_DEF ( ID, NAME, FLOW_CLASS, FLOW_MODE ) 
	VALUES ( 1100060, 'Credit Recalculation Flow', 'com.traiana.sol.fxpb.flow.credit.CreditRecalculationCallerFlow', NULL);

delete arch_report_column where ID=1100603;
INSERT INTO ARCH_REPORT_COLUMN ( ID, REPORT_ID, LOGICAL_NAME, VISIBLE_NAME, FILTER_NAME, TYPE,VALIDATOR, CONVERTER, HELPER, VISIBILITY, SETTER, ORDER_SEQ, TABLE_NAME, FOOTER_SETTER,HEADER_SETTER ) 
	   VALUES ( 1100603, 1004000, 'TIME', 'Time', 'Time', 'String', 'string', NULL, NULL, NULL, NULL, 50, 'TIME', NULL, NULL);

delete arch_report_column where ID=1100604;
INSERT INTO ARCH_REPORT_COLUMN ( ID, REPORT_ID, LOGICAL_NAME, VISIBLE_NAME, FILTER_NAME, TYPE, VALIDATOR, CONVERTER, HELPER, VISIBILITY, SETTER, ORDER_SEQ, TABLE_NAME, FOOTER_SETTER,HEADER_SETTER ) 
	VALUES ( 1100604, 1004000, 'ZONE', 'Zone', 'Zone', 'String', 'string', NULL, NULL, NULL, NULL, 40, 'ZONE', NULL, NULL); 


--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++

--********************************************************************************************************--
--**			F I X E D   F O O T E R	 starts here 						**--
--********************************************************************************************************--

---- others.sql (start)
-- Override Origin System Defs for Linear/Option Back-Office Systems
DELETE FROM ARCH_CODE_MEMBER WHERE group_id = 1001000 AND code_key IN ('2', '3');
INSERT INTO ARCH_CODE_MEMBER ( GROUP_ID, CODE_KEY, DATA, NAME, CODE_COMMENT, STATUS ) 
	VALUES ( 1001000, '2', 'IRFE', 'IRFE', 'Origin System IRFE', 1); 
INSERT INTO ARCH_CODE_MEMBER ( GROUP_ID, CODE_KEY, DATA, NAME, CODE_COMMENT, STATUS ) 
	VALUES ( 1001000, '3', 'Murex', 'Murex', 'Origin System Murex', 1);

-- Override MAIL connector def for JP
delete ARCH_CONN_CHECKER_DATA where PROTOCOL_NAME='MAIL';
INSERT INTO ARCH_CONN_CHECKER_DATA ( PROTOCOL_NAME, IMPLEMENTATION_CLASS,TO_CHECK ) 
	VALUES ( 'MAIL', 'com.traiana.sol.jpmc.core.engine.connector.mail.WEduMailData', 1); 
----others.sql (end)

exec PROP_UPDATE_PROPERTIES; 
exec ALTER_CONSTRAINTS('enable');
exec ANALYZE_ALL_TABLES;

---- Mark current version 
INSERT INTO ARCH_VERSION ( TIMESTAMP, VERSION, DESCRIPTION, LOGFILE, SOLUTION_VERSION )
  	VALUES (sysdate , '2.8.14.4', 'JPMC 1.7 STF 14.4 ', '/Arch2.0/installationLog/databaseInstall.log', '1.7.14.4');

commit;

-- spool off
