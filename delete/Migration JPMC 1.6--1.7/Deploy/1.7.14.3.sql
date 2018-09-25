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
-- spool 1.7.14.2.log
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
-- build 1.7.14.3:1
update FXPB_OPTION_TRADE set
	OPTION_BO_TRADE_ID='0'
where OPTION_BO_TRADE_ID='Manual Reconcile';

--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++
-- build 1.7.14.3:2
delete ARCH_REPORT_COLUMN where ID=1102202;
INSERT INTO ARCH_REPORT_COLUMN ( ID, REPORT_ID, LOGICAL_NAME, VISIBLE_NAME, FILTER_NAME, TYPE,VALIDATOR, CONVERTER, HELPER, VISIBILITY, SETTER, ORDER_SEQ, TABLE_NAME, FOOTER_SETTER,HEADER_SETTER ) 
	VALUES (1102202, 1102200, 'STATUS', 'Status', 'Status', 'String', 'string', NULL, 'EngineOperationStatus', NULL, NULL, 30, 'STATUS', NULL, NULL);
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

---- Mark current version 
INSERT INTO ARCH_VERSION ( TIMESTAMP, VERSION, DESCRIPTION, LOGFILE, SOLUTION_VERSION )
  	VALUES (sysdate , '1.7.14.3', 'JPMC 1.7 STF 14.3 ', '/Arch2.0/installationLog/databaseInstall.log', '2.8.14.3');

commit;

-- spool off
