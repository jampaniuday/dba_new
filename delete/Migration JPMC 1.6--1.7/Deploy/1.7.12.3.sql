-----------------------------------------------------
--- Creation Date: 25-Apl-2004
--- Last Update : 25-Apl-2004
--- Aouthor : Isaac Raz
--- Company : Traiana Inc
--- Script Target:
---	Update Database schema 1.7 STF 12.2 to  1.7 STF 12.3::1 on JPMC project
------------------------------------------------------
-- merged with :
-----------------------------------------------------
--- Creation Date: 26-04-2004
--- Last Update :  26-04-2004
--- Aouthor : Isaac Raz
--- Company : Traiana Inc
--- Script Target:
---	Update Database schema 1.7.12.3::2 to  1.7.12.3::3 on JPMC project
------------------------------------------------------

set echo on
-- spool  DBScript1-7-12-3.log

begin
 alter_constraints('disable');
end;
/

INSERT INTO ARCH_VERSION ( TIMESTAMP, VERSION, DESCRIPTION, LOGFILE, SOLUTION_VERSION )
	VALUES (sysdate , '1.7.12.3::1', 'jpmc 1.7 stf 12', '/Arch2.0/installationLog/databaseInstall.log', '1.7.12.3::1');

--------------------------------
-------platform updates---------
--------------------------------


--------------------------------
-------platform updates---------
--------------------------------
-------------------------------------------------------
---- ARCH_FLOW_DEF\data.sql
DELETE ARCH_FLOW_DEF WHERE ID IN (1000051, 1000052,1000055,1000056,1000057);
INSERT INTO ARCH_FLOW_DEF ( ID, NAME, FLOW_CLASS, FLOW_MODE )
    VALUES (1000051, 'Check option NOE for recon stale invoker', 'com.traiana.sol.fxpb.flow.noe.CheckForReconStaleOptionNOEsFlow', 1);
INSERT INTO ARCH_FLOW_DEF ( ID, NAME, FLOW_CLASS, FLOW_MODE )
    VALUES (1000055, 'Check option 4 allocation stale', 'com.traiana.sol.fxpb.flow.noe.CheckForAllocStaleOptionNOEsFlow', 1);
INSERT INTO ARCH_FLOW_DEF ( ID, NAME, FLOW_CLASS, FLOW_MODE )
    VALUES (1000056, 'Make Option NOE allocation stale invoker', 'com.traiana.sol.fxpb.flow.noe.MakeOptionNOEAllocStaleInvokerFlow', 1);
INSERT INTO ARCH_FLOW_DEF ( ID, NAME, FLOW_CLASS, FLOW_MODE )
    VALUES (1000052, 'Make Option NOE recon stale invoker', 'com.traiana.sol.fxpb.flow.noe.MakeOptionNOEReconStaleInvokerFlow', 1);
INSERT INTO ARCH_FLOW_DEF ( ID, NAME, FLOW_CLASS, FLOW_MODE )
    VALUES (1000057, 'Make Option NOE Allocation Stale', 'com.traiana.sol.fxpb.flow.noe.MakeOptionNOEAllocationStaleFlow', 1);


-------------------------------------------------------
---- ARCH_MSG_LOGIC_INFO\data.sql
INSERT INTO ARCH_MSG_LOGIC_INFO ( ID,ATTR,DESCRIPTION,PRE_FLOW_ID,FLOW_ID )
	VALUES (1000026,3,'Check 4 option reconciliation stale',NULL,1000051 ) ;
INSERT INTO ARCH_MSG_LOGIC_INFO ( ID,ATTR,DESCRIPTION,PRE_FLOW_ID,FLOW_ID )
	VALUES (1000027,3,'Check 4 option allocation stale',NULL,1000055 ) ;


-------------------------------------------------------
---- ..\VIEWS\V_FXPB_ALLOC_STALE_OPTION_NOE\view.sql
CREATE OR REPLACE VIEW V_FXPB_ALLOC_STALE_OPTION_NOE ( ID,
CREATION_DATE, ENTERING_ORG_ID, SETTLEMENT_DATE, SUBMITTER_PERSON_ID,
TRADE_DATE, RATE, SIDE_A_ORG_ID, SIDE_B_ORG_ID,
TRADER_ID, BASE_INSTRUMENT_ID, SECONDARY_INSTRUMENT_ID, CONTRACT_TYPE,
DIRECTION, QUANTITY, QUANTITY2, VALUE_DATE,
REPORTER, TRADE_TYPE, LIFE_STATUS, ALLOC_STATUS,
TIME_OUT ) AS SELECT
 A.ID,
 A.CREATION_DATE,
 A.ENTERING_ORG_ID,
 A.SETTLEMENT_DATE,
 A.SUBMITTER_PERSON_ID,
 A.TRADE_DATE,
 A.RATE,
 A.SIDE_A_ORG_ID,
 A.SIDE_B_ORG_ID,
 A.TRADER_ID,
 A.BASE_INSTRUMENT_ID,
 A.SECONDARY_INSTRUMENT_ID,
 A.CONTRACT_TYPE,
 A.DIRECTION,
 A.QUANTITY,
 A.QUANTITY2,
 A.VALUE_DATE,
 A.REPORTER,
 A.TRADE_TYPE,
 A.LIFE_STATUS,
 A.ALLOC_STATUS,
 O.VALUE
FROM
	FXPB_OPTION_NOE A,
	ARCH_OBJECT_PROPS O
WHERE
	 A.ALLOC_STATUS = 1 -- unallocated
	 AND A.LIFE_STATUS In (2,4) -- noe active or done
	 AND A.SIDE_A_ORG_ID = O.OBJECT_ID(+)
	 AND (
            O.OBJECT_ID is null
			OR ( O.CODE_ID = 1000002 -- alloc timeout
				 AND A.CREATION_DATE < SYSDATE - (to_number(O.VALUE)) / 1440 -- convert to days
				)
         );



-------------------------------------------------------
---- ..\VIEWS\V_FXPB_RECON_OPTION_NOE\view.sql
CREATE OR REPLACE VIEW V_FXPB_RECON_OPTION_NOE ( ID,
CREATION_DATE, ENTERING_ORG_ID, SUBMITTER_PERSON_ID, TRADER_ID,
REPORTER, TRADE_TYPE, RECON_STATUS, LIFE_STATUS,
TRADE_DATE, SIDE_A_ORG_ID, SIDE_B_ORG_ID, BASE_INSTRUMENT_ID,
SECONDARY_INSTRUMENT_ID, QUANTITY, QUANTITY2, DIRECTION,
VALUE_DATE, EXPIRY_DATE, STRIKE, STRIKE_QUOTE_MODE,
BARRIER_LEVEL, BARRIER_TYPE, LOWER_BARRIER_LEVEL, UPPER_BARRIER_LEVEL,
REBATE_QUOTE_MODE, REBATE_PERCENT_1, REBATE_PERCENT_2, REBATE_TYPE,
PAYOUT_CURRENCY, PAYOUT_AMOUNT, PREMIUM_AMOUNT, PREMIUM_DATE,
PREMIUM_CCY, PREMIUM_TYPE, OPTION_STYLE, CONTRACT_TYPE,
OPTION_TYPE, EXPIRY_TIME, CUT_OFF_ZONE, PB_ID,
DELIVERY_METHOD ) AS SELECT
 A.ID,
 A.CREATION_DATE,
 A.ENTERING_ORG_ID,
 A.SUBMITTER_PERSON_ID,
 A.TRADER_ID,
 A.REPORTER,
 A.TRADE_TYPE,
 A.RECON_STATUS,
 A.LIFE_STATUS,
 A.TRADE_DATE,
 A.SIDE_A_ORG_ID,
 A.SIDE_B_ORG_ID,
 A.BASE_INSTRUMENT_ID,
 A.SECONDARY_INSTRUMENT_ID,
 A.QUANTITY,
 A.QUANTITY2,
 A.DIRECTION,
 A.VALUE_DATE,
 A.EXPIRY_DATE,
 A.RATE,
 A.STRIKE_QUOTE_MODE,
 A.BARRIER_LEVEL,
 A.BARRIER_TYPE,
 A.LOWER_BARRIER_LEVEL,
 A.UPPER_BARRIER_LEVEL,
 A.REBATE_QUOTE_MODE,
 A.REBATE_PERCENT_1,
 A.REBATE_PERCENT_2,
 A.REBATE_TYPE,
 A.PAYOUT_CURRENCY,
 A.PAYOUT_AMOUNT,
 A.PREMIUM_AMOUNT,
 A.PREMIUM_DATE,
 A.PREMIUM_CCY,
 A.PREMIUM_TYPE,
 A.OPTION_STYLE,
 A.CONTRACT_TYPE,
 A.OPTION_TYPE,
 A.EXPIRY_TIME,
 A.CUT_OFF_ZONE,
 A.PB_ID,
 A.DELIVERY_METHOD
FROM
	 FXPB_OPTION_NOE A
WHERE
	  A.RECON_STATUS <> 1 -- recon matched
	  AND A.LIFE_STATUS IN (2,1) -- noe active or draft
;


-------------------------------------------------------
---- ..\VIEWS\V_FXPB_RECON_STALE_OPTION_NOE\view.sql
CREATE OR REPLACE VIEW V_FXPB_RECON_STALE_OPTION_NOE ( ID,
CREATION_DATE, ENTERING_ORG_ID, TIME_OUT) AS
SELECT
 A.ID,
 A.CREATION_DATE,
 A.ENTERING_ORG_ID,
 O.VALUE
 FROM
	FXPB_OPTION_NOE A,
	ARCH_OBJECT_PROPS O
WHERE
	 A.RECON_STATUS = 2 -- unmatched
	 AND A.LIFE_STATUS = 2 -- noe active
	 AND A.SIDE_A_ORG_ID = O.OBJECT_ID(+)
	 AND O.CODE_ID(+) = 1000001 -- recon timeout
	 AND (
            O.OBJECT_ID is null
			OR (A.CREATION_DATE < SYSDATE - (to_number(O.VALUE)) / 1440 -- convert to days
				)
         );
         

declare
 /*********************************
  *                               *
  * This lovely PL/SQL block is   *
  * here only to perform a manual *
  * wait of at least one second.  *
  * The reason for this is to     *
  * enable the use of SYSDATE in  *
  * in ARCH_VERSION and avoid     *
  * duplicate keys.               *
  *                               *
  *********************************/
 result number;
begin
for i in 1..100000 loop
  select 1 into result from dual;
end loop;
end;
/

INSERT INTO ARCH_VERSION ( TIMESTAMP, VERSION, DESCRIPTION, LOGFILE, SOLUTION_VERSION )
	VALUES (sysdate , '1.7.12.3::3', 'JPMC 1.7.12.3 build 3', '/Arch2.0/installationLog/databaseInstall.log', '1.7.12.3::3');

--------------------------------
-------platform updates---------
--------------------------------


--------------------------------
-------solution updates---------
--------------------------------
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID,LOGIC_MSG_ID,IN_TRANSFORMER,OUT_TRANSFORMER,DESCRIPTION,NAME )
 VALUES (1000060,1000026,NULL,NULL,'Check 4 option reconciliation stale','Check4StaleOptionRecon' ) ;
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID,LOGIC_MSG_ID,IN_TRANSFORMER,OUT_TRANSFORMER,DESCRIPTION,NAME )
 VALUES (1000061,1000027,NULL,NULL,'Check 4 option alocation stale','Check4StaleOptionAllocation' ) ;

delete from ARCH_MSG_PROTOCOL_INFO where id=1000104;
INSERT INTO ARCH_MSG_PROTOCOL_INFO ( ID, LOGIC_MSG_ID, IN_TRANSFORMER, OUT_TRANSFORMER, DESCRIPTION,NAME )
 VALUES ( 1000104, 1000104, 'FlatJPMC-Xml', 'JPMC_Flat2_CSV', 'Modify Split -Protocol', 'ModifySplit_Protocol');

begin
 alter_constraints('enable');
end;
/

COMMIT;

-- spool  off
------ END OF SCRIPT ---------


