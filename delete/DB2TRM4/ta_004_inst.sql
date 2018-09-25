------------------------------------
-- 5	Instrument Model
------------------------------------
set feedback off 

------------------------------------
--  5.2.1	CCYs 
------------------------------------
BEGIN
	dbms_output.put_line('');
	dbms_output.put_line('******* CCY Import START ********');
	^trm.print_start_time();
	dbms_output.put_line('-- cleaning pre-defined CCYs and CCY Pairs');
	^trm.clean_insts();
END; -- Printout
/

-- Start inport instrument
DECLARE
	-- Vars:
	ccy_id		NUMBER(30);
	
	-- Debugging
	ccy_counter 			NUMBER(30);

	-- Cursors:
	-- Fech all relevant currencies from DB Schema.
    cursor currencies is 
		SELECT
			inst.ID, 
			inst.TYPE, 
			inst.NAME,
			inst.DESCR, 
			inst.CURRENCY, 
			inst.STATUS as CCY_STATUS, 
			inst.AMT_PLACES, 
			dm.PARTNER_ID,
			dm.MAP_TYPE, 
			dm.EXTERNAL_VALUE,
			dm.INTERNAL_VALUE, 
			dm.STATUS as DM_STATUS
		FROM
			^eswitch.A_INSTRUMENT inst, 
			^eswitch.A_DATA_MAPPING dm, 
			^eswitch.A_LEGAL_ENTITY le
		WHERE 
			inst.TYPE = ^E_InstType_CCY
			and dm.INTERNAL_VALUE = inst.ID
			and dm.MAP_TYPE = ^E_DMType_CCY
			and dm.PARTNER_ID = LE.PARTNER_ID
			and le.DOMAIN_ID in (^domain)
			and dm.STATUS=1;
				
BEGIN

	dbms_output.put_line('CCY List Fetched from Source Schema (^eswitch), Inserting data to Target Schema (^trm)');
	^trm.print_time();
	
	 -- Initializations:
	 ccy_id :=0;
	
	ccy_counter :=0;
	

	-- LOOP START
	FOR currency IN currencies LOOP

^DEBUG		dbms_output.put_line('>>> converting CCY ID: ' || currency.ID);
		ccy_counter := ccy_counter+1;

		------------------------
		-- Add CCY
		------------------------
		ccy_id := currency.ID + ^incID;
		
		INSERT INTO ^trm.A_INSTRUMENT_BASE (
			   ID, NAME, TYPE, 
			   TIME_ZONE, FINANCIAL_CENTER_LIST, 
			   PAYMENT_DATE_ROLL, 
			   DESCRIPTION, 
			   BASIC_STATUS, BASIC_STATUS_REASON, 
			   IS_CASHFLOW)
		VALUES(
			   ccy_id, currency.CURRENCY, ^InstType_CCY, 
			   NULL, NULL, 
			   NULL, 
			   currency.NAME, 
			   1, ^mReason, 
			   0);
		
	
		INSERT INTO ^trm.A_INSTRUMENT_CURRENCY (
			   ID, IS_NDF, 
			   AMT_PLACES, 
			   ROUNDING_METHOD)
		VALUES (
			   ccy_id, 0, 
			   currency.AMT_PLACES, 
			   NULL);

	------------------------------------
	--  5.2.2	CCYs Data Mapping  
	------------------------------------
	   	INSERT INTO ^trm.A_DATA_MAPPING (
	   		  ID, NAMER_ID, MAP_TYPE, 
			  EXTERNAL_VALUE, INTERNAL_VALUE, 
			  TYPE_IN, TYPE_OUT, 
			  BASIC_STATUS, BASIC_STATUS_REASON)
		VALUES (
			   ^trm.A_DATA_MAPPING_SEQ.nextval, ^PBnamerID, ^DMType_CCY,  
			   currency.EXTERNAL_VALUE, ccy_id, 
			   0, 0, 
			   1, ^mReason);

	END LOOP;	-- LOOP END
	
	dbms_output.put_line('Converted ' || ccy_counter || ' CCYs' );
	^trm.print_end_time();
	dbms_output.put_line('******* CCY Import END ********');

END;
/

------------------------------------
--  5.2.3	CCY Pairs  
------------------------------------

BEGIN
	dbms_output.put_line('');
	dbms_output.put_line('******* CCY Pair Import START ********');
	^trm.print_start_time();
END; -- Printout
/

-- Start import ccy pairs
DECLARE
	-- Vars:
	ccyp_id		NUMBER(30);
	fccy_id		 NUMBER(30);
	sccy_id		NUMBER(30);

	-- Debugging
	ccyp_counter 			NUMBER(30);

	-- Cursors:
	-- Fech all relevant CCY Pairs from DB Schema.
    cursor ccyps is 
		SELECT
			  ccy_pair.ID, 
			  ccy_pair.FIRST_CCY_ID as FIRST_CCY_NAME, 
			  ccy1.ID as FIRST_CCY_ID,
			  ccy_pair.SECOND_CCY_ID as SECOND_CCY_NAME, 
			  ccy2.ID as SECOND_CCY_ID,
			  ccy_pair.RATE_DIRECTION,
			  ccy_pair.RATE_FACTOR, 
			  inst.AMT_PLACES, 
			  inst.NAME
		FROM 
			 ^eswitch.A_INSTRUMENT inst, 
			 ^eswitch.FXPB_CCY_PAIR_CONTRACT ccy_pair, 
			 ^eswitch.A_INSTRUMENT ccy1, 
			 ^eswitch.A_INSTRUMENT ccy2
		WHERE
			 inst.TYPE = ^E_InstType_CCYPair
			 and inst.ID = ccy_pair.ID
			 and ccy1.CURRENCY = ccy_pair.FIRST_CCY_ID
			 and ccy1.TYPE = ^E_InstType_CCY
			 and ccy2.CURRENCY = ccy_pair.SECOND_CCY_ID
			 and ccy2.TYPE = ^E_InstType_CCY;
				
BEGIN
	dbms_output.put_line('CCY Pair List Fetched from Source Schema (^eswitch), Inserting data to Target Schema (^trm)');
	^trm.print_time();
	
	 -- Initializations:
	 ccyp_id :=0;
	 fccy_id :=0;
	 sccy_id :=0;
	
	ccyp_counter :=0;

	-- LOOP START
	FOR ccyp IN ccyps LOOP

^DEBUG		dbms_output.put_line('>>> converting CCY Pair ID: ' || ccyp.ID);

		ccyp_counter := ccyp_counter+1;

		------------------------
		-- Add CCY Pair
		------------------------
		ccyp_id := ccyp.ID + ^incID;
		fccy_id := ccyp.FIRST_CCY_ID + ^incID;
		sccy_id := ccyp.SECOND_CCY_ID + ^incID;
		
		INSERT INTO ^trm.A_BILLING_CCY_PAIR (
			   ID, RATE_FACTOR, 
			   FIRST_CCY_ID, SECOND_CCY_ID, 
			   RATE_DIRECTION, AMT_PLACES, 
			   CCY_PAIR, INVERSE_AMT_PLACES, 
			   SPOT_LAG, 
			   BASIC_STATUS, BASIC_STATUS_REASON)
		VALUES(
			   ccyp_id, ccyp.RATE_FACTOR, 
			   fccy_id, sccy_id, 
			   ccyp.RATE_DIRECTION, ccyp.AMT_PLACES, 
			   ccyp.NAME, ccyp.AMT_PLACES, 
			   5, 
			   1, ^mReason);
			   

		INSERT INTO ^trm.A_BILLING_CCY_PAIR_2_FIN_CNTR(
			   ID, 
			   CCY_PAIR_ID, 
			   FINANCIAL_CENTER_ID)
		VALUES(
			   ^trm.A_BLNG_CCYPAIR_2_FINCNTR_SEQ.nextval, 
			   ccyp_id, 
			   ^FinCenterID_NY);
		
	END LOOP;	-- LOOP END
	
	dbms_output.put_line('Converted ' || ccyp_counter || ' CCY Pairs' );
	^trm.print_end_time();
	dbms_output.put_line('******* CCY Pair Import END ********');

END;
/
	
