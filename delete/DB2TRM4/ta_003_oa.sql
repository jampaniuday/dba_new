------------------------------------
-- 6	Trading Activities Model:
------------------------------------
set feedback off 

------------------------------------
--  6.2.3	OAs
------------------------------------
BEGIN
	dbms_output.put_line('******* OA Import START ********');
	^trm.print_start_time();
END; -- Printout
/

-- Start Converting OAs
DECLARE
	-- Vars:
	id_idx 			NUMBER(30);
	rel_oa_id		NUMBER(30);
	user_id 	NUMBER(30);
	entering_party_id 	NUMBER(30);
	tparty_id 		NUMBER(30);

	-- Debugging
	oa_counter 			NUMBER(30);

	-- Cursors:
	-- Fech all relevant OAs from DB Schema.
    cursor oas is 
		SELECT 
			ta.ID, 
			ta.TYPE, 
			ta.DOMAIN_ID, 
			ta.TRADE_DATE, 
			ta.EXTERNAL_REF, 
			ta.LIFE_CYCLE_STATUS, 
			ta.LIFE_STATUS_REASON, 
			ta.APPROVE_STATUS, 
			ta.APPROVE_STATUS_REASON, 
			ta.CREATION_DATE, 
			ta.DESCRIPTION, 
			oa.A_NOE_ID, 
			noe_id_map.TRM_ID as A_NOE_ID_TRM, 
			oa.TRADING_PARTY_LE_ID, 
			oa.TOTAL, 
			oa.ENTERING_PARTY_LE_ID,
			oa.SUBMITTER_PERSON_ID,
			ta.A_TRADING_ACTIVITY_ID2
		FROM
			^eswitch.A_TRADING_ACTIVITY ta, 
			^eswitch.A_OA oa, 
			^trm.MIG_TA_ID_MAPPING_NOE noe_id_map 
		WHERE	
			ta.TYPE in (4)								-- TYPE: Trade/Master Trade
			and ta.DOMAIN_ID in (^domain)				-- Domain: VOID/DB App
			and oa.ID = ta.ID
			and noe_id_map.ESWITCH_ID = oa.A_NOE_ID
			;

BEGIN

	dbms_output.put_line('OA List Fetched from Source Schema (^eswitch), Inserting data to Target Schema (^trm)');
	^trm.print_time();

	-- Initializations:
	id_idx 			:= 0;
	rel_oa_id	:= 0;
	user_id 	:= 0;
	entering_party_id 	:= 0;
	tparty_id 		:= 0;
	
	oa_counter := 0;

	-- LOOP START
	FOR oa IN oas LOOP
	
^DEBUG		dbms_output.put_line('>>> converting OA ID: ' || oa.ID);

		oa_counter := oa_counter+1;

		------------------------------------
		-- Add ID Mapping
		------------------------------------
		select ^trm.A_TA_SEQ.nextval into id_idx from DUAL;

		INSERT INTO ^trm.MIG_TA_ID_MAPPING_OA (ESWITCH_ID, TRM_ID) 
			VALUES(oa.ID, id_idx);

		------------------------------------
		-- Insert  OA Data
		------------------------------------
		IF (oa.A_TRADING_ACTIVITY_ID2 > 0) THEN
^DEBUG		   dbms_output.put_line('>>> oa.A_TRADING_ACTIVITY_ID2:  ' || oa.A_TRADING_ACTIVITY_ID2);
		    rel_oa_id := oa.A_TRADING_ACTIVITY_ID2;
		ELSE
			rel_oa_id := -1;
		END IF;
		
		INSERT INTO ^trm.A_OA(
			   ID, BASIC_STATUS, BASIC_STATUS_REASON, 
			   NOE_ID, RELATED_OA_ID, 
			   ORG_ACCOUNT_ID, INSTRUMENT_ID, 
			   TOTAL)
		VALUES(
			   id_idx, 1, ^mReason, 
			   oa.A_NOE_ID_TRM, rel_oa_id, -- RELATED_OA_ID will be updated later with the correlating TRM OA ID
			   -1, -1,				-- ORG_ACCOUNT_ID, INSTRUMENT_ID will be updated later 
			   oa.TOTAL	);
		
		------------------------------------
		-- Insert FX OA Data
		------------------------------------
		user_id 	:= oa.SUBMITTER_PERSON_ID + ^incID;
		entering_party_id 	:= oa.ENTERING_PARTY_LE_ID + ^incID;
		tparty_id 		:= oa.TRADING_PARTY_LE_ID + ^incID;

		INSERT INTO ^trm.M_FX_OA(
			   ID, 
			   ACTIVITY_STATUS, ACTIVITY_STATUS_REASON, 
			   APPROVAL_STATUS, APPROVAL_STATUS_REASON, 
			   USER_ID, USER_PARTY, 
			   CLIENT_REF, DESCRIPTION, 
			   CREATION_TIME, TRADE_DATE, 
			   MANUALLY_APPROVED, PRESET_ALLOCATION, 
			   TRADING_PARTY, TOTAL_PREMIUM)
		VALUES(
			   id_idx, 
			   DECODE(oa.LIFE_CYCLE_STATUS, 1, 5, 2, 4, 4, 6, 8, 3, 16, 2, 32, 1, 64, 1, -9), ^mReason,
			   DECODE(oa.APPROVE_STATUS, 1, 1, 2, 2, 4, 3, -9),  ^mReason,
			   user_id, entering_party_id, 
			   oa.EXTERNAL_REF, oa.DESCRIPTION, 
			   oa.CREATION_DATE, oa.TRADE_DATE, 
			   0, 0, 
			   tparty_id, 0	);

	END LOOP;	-- LOOP END
	
	dbms_output.put_line('Converted ' || oa_counter || ' OAs' );
	^trm.print_end_time();
	dbms_output.put_line('******* OA Import END ********');

END;
/

----------------------------------------
-- Update Related OA IDs
----------------------------------------
BEGIN
	dbms_output.put_line('******* OA Rel IDs Update START ********');
	^trm.print_start_time();
END; -- Printout
/

DECLARE

	-- Debugging
	rel_oa_id_counter 			NUMBER(30);

	-- Cursors:
	-- Fech all relevant OAs from DB Schema.
    cursor oa_rels is 
		SELECT 
			oa.ID, 
			oa.RELATED_OA_ID,
			oa_id_map.TRM_ID as OA_ID_TRM
		FROM
			^trm.A_OA oa, 
			^trm.MIG_TA_ID_MAPPING_OA oa_id_map 
		WHERE	
			oa.RELATED_OA_ID = oa_id_map.ESWITCH_ID
			;

BEGIN

	dbms_output.put_line('OA REL List Fetched from Source Schema (^trm), Inserting data to Target Schema (^trm)');
	^trm.print_time();

	rel_oa_id_counter := 0;

	-- LOOP START
	FOR oa_rel IN oa_rels LOOP

		rel_oa_id_counter := rel_oa_id_counter+1;
		
		UPDATE ^trm.A_OA set  RELATED_OA_ID = oa_rel.OA_ID_TRM where ID = oa_rel.ID;

	END LOOP;	-- LOOP END

	dbms_output.put_line('Updated ' || rel_oa_id_counter || ' OA Rel  IDs' );
	^trm.print_end_time();
	dbms_output.put_line('******* OA Rel IDs Update END ********');

END;
/

------------------------------------
-- Insert OA Allocation Data
------------------------------------
BEGIN
	dbms_output.put_line('******* Allocation Import START ********');
	^trm.print_start_time();
END; -- Printout
/

-- Start Converting Allocations
DECLARE
	-- Vars:
	alloc_id_idx 			 NUMBER(30);
	from_acc_id		   NUMBER(30);
	inst_id					   NUMBER(30);
	
	fund_acc_id 	NUMBER(30);
	fund_owner_id NUMBER(30);
	
	-- Debugging
	alloc_counter 			NUMBER(30);

	-- Cursors:
	-- Fech all relevant OAs from DB Schema.
    cursor allocs is 
		SELECT 
			t0.TRADING_ACTIVITY_ID,
			oa_id_map.TRM_ID as OA_ID_TRM,
			t0.QUANTITY, 
			t0.FROM_ACCOUNT_ID, 
			t0.TO_ACCOUNT_ID, 
			t0.INSTRUMENT_ID, 
			t0.EXTERNAL_REF,
			   -- Fund Account's Owner Org ID 
--			ale.LEGAL_ENTITY_ID as FUND_LE_OWNER_ORG_ID
		   (select ale.LEGAL_ENTITY_ID from ^eswitch.A_ACCOUNT_LEGAL_ENTITY ale where ale.ACCOUNT_ID= t0.TO_ACCOUNT_ID
		   and ale.RELATION_TYPE = 1) as FUND_LE_OWNER_ORG_ID
		FROM
			^eswitch.A_TRANSFER t0, 
--			^eswitch.A_ACCOUNT_LEGAL_ENTITY ale,
			^trm.MIG_TA_ID_MAPPING_OA oa_id_map 
		WHERE
			t0.ORDER_SEQ = 0
			and oa_id_map.ESWITCH_ID =  t0.TRADING_ACTIVITY_ID
--			and ale.ACCOUNT_ID= t0.TO_ACCOUNT_ID
--			and ale.RELATION_TYPE = 1
			; 

BEGIN

	dbms_output.put_line('OA ALLOC List Fetched from Source Schema (^eswitch), Inserting data to Target Schema (^trm)');
	^trm.print_time();

	-- Initializations:
	 alloc_id_idx 		:= 0;
	 from_acc_id 		:=0;
	 inst_id 				:=0;
	 
	 fund_acc_id :=0;
	 fund_owner_id :=0;
	 
	 alloc_counter := 0;
	 
	dbms_output.put_line('>>> Importing Allocations');

	-- LOOP START
	FOR alloc IN allocs LOOP
	
		alloc_counter := alloc_counter+1;

		 from_acc_id := alloc.FROM_ACCOUNT_ID + ^incID;
		 inst_id := alloc.INSTRUMENT_ID + ^incID;

		------------------------------------------------------------------------
		-- Update  OAs with Account  and Instrument IDs 
		------------------------------------------------------------------------
		UPDATE 
			^trm.A_OA oa
		SET 
			ORG_ACCOUNT_ID = from_acc_id, 
			INSTRUMENT_ID = inst_id 
		WHERE  
			oa.ID = alloc.OA_ID_TRM
			and ORG_ACCOUNT_ID = -1;
			   
		-----------------------------------------
		-- Insert OA Allocation Data
		-----------------------------------------
		select ^trm.A_TA_SEQ.nextval into alloc_id_idx from DUAL;
		fund_acc_id := alloc.TO_ACCOUNT_ID + ^incID;
	   
		INSERT INTO ^trm.A_OA_ALLOCATION(
			   ID, BASIC_STATUS, BASIC_STATUS_REASON, 
			   OA_ID, FUND_ACCOUNT_ID, 
			   QUANTITY)
		VALUES(
			   alloc_id_idx, 1, ^mReason, 
			   alloc.OA_ID_TRM, fund_acc_id, 
			   alloc.QUANTITY);
			   			   			   
		-----------------------------------------
		-- Insert FX OA Allocation Data
		-----------------------------------------
		fund_owner_id := alloc.FUND_LE_OWNER_ORG_ID + ^incID;
		INSERT INTO ^trm.M_FX_OA_ALLOCATION(
			   ID, FX_OA_ID, FUND, 
			   CLIENT_REF, PREMIUM_QUANTITY)
		VALUES(
			   alloc_id_idx, alloc.OA_ID_TRM, fund_owner_id, 
			   alloc.EXTERNAL_REF, 0);
			   			   			   
	END LOOP;	-- LOOP END

	dbms_output.put_line('Converted ' || alloc_counter || ' Allocations' );
	^trm.print_end_time();
	dbms_output.put_line('******* Allocation Import END ********');

END;
/

