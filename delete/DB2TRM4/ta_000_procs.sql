------------------------------------------
-- NOE Cleaning Procedure
------------------------------------------
CREATE OR REPLACE PROCEDURE ^trm.clean_noes AS
BEGIN
	 DELETE FROM ^trm.A_TA_TA_REL  where PARENT_TA_ID in (select TRM_ID from MIG_TA_ID_MAPPING_NOE);
	 DELETE FROM ^trm.M_FX_NOE;
	 DELETE FROM ^trm.A_TA where TXN_TYPE = 1;
	 DELETE FROM ^trm.MIG_TA_ID_MAPPING_NOE;
END;
/

------------------------------------------
-- Trades Cleaning Procedure
------------------------------------------
CREATE OR REPLACE PROCEDURE ^trm.clean_trades AS
BEGIN
	 DELETE FROM ^trm.M_FX_TRADE;
	 DELETE FROM ^trm.A_TA where TXN_TYPE in (2, 3);
	 DELETE FROM ^trm.MIG_TA_ID_MAPPING_TRADE;
END;
/

------------------------------------------
-- OAs Cleaning Procedure
------------------------------------------
CREATE OR REPLACE PROCEDURE ^trm.clean_oas AS
BEGIN
	 DELETE FROM ^trm.A_OA;
	 DELETE FROM ^trm.M_FX_OA;
	 DELETE FROM ^trm.A_OA_ALLOCATION;
	 DELETE FROM ^trm.M_FX_OA_ALLOCATION;
	 DELETE FROM ^trm.MIG_TA_ID_MAPPING_OA;
END;
/

------------------------------------------
-- TAs Cleaning Procedure
------------------------------------------
CREATE OR REPLACE PROCEDURE ^trm.clean_tas AS
BEGIN
	 clean_oas();
	 clean_trades();
	 clean_noes();
END;
/

------------------------------------------
-- Debug Procs
------------------------------------------
CREATE OR REPLACE PROCEDURE ^trm.print_start_time AS
	cur_time VARCHAR2(255);
BEGIN
	select to_char(sysdate,'mm/dd/yy hh:mi:ss') into cur_time from dual;
	dbms_output.put_line('START_TIME: ' || cur_time);
END;
/

CREATE OR REPLACE PROCEDURE ^trm.print_end_time AS
	cur_time VARCHAR2(255);
BEGIN
	select to_char(sysdate,'mm/dd/yy hh:mi:ss') into cur_time from dual;
	dbms_output.put_line('END_TIME: ' || cur_time);
END;
/

CREATE OR REPLACE PROCEDURE ^trm.print_time AS
	cur_time VARCHAR2(255);
BEGIN
	select to_char(sysdate,'mm/dd/yy hh:mi:ss') into cur_time from dual;
	dbms_output.put_line('TIME: ' || cur_time);
END;
/

------------------------------------------
-- CCY Cleaning Procedure
------------------------------------------
CREATE OR REPLACE PROCEDURE ^trm.clean_ccys AS
BEGIN
	 DELETE FROM ^trm.A_INSTRUMENT_BASE where TYPE=8;
	 DELETE FROM ^trm.A_INSTRUMENT_CURRENCY;
	 DELETE FROM ^trm.A_DATA_MAPPING WHERE MAP_TYPE=2000002;
END;
/

-------------------------------------------------
-- CCY Pairs Cleaning Procedure
-------------------------------------------------
CREATE OR REPLACE PROCEDURE ^trm.clean_ccy_pairs AS
BEGIN
	 DELETE FROM ^trm.A_BILLING_CCY_PAIR ;
	 DELETE FROM ^trm.A_BILLING_CCY_PAIR_2_FIN_CNTR;
END;
/

-------------------------------------------------
-- All Instruments Cleaning Procedure
-------------------------------------------------
CREATE OR REPLACE PROCEDURE ^trm.clean_insts AS
BEGIN
	 clean_ccys ();
	 clean_ccy_pairs();
END;
/


