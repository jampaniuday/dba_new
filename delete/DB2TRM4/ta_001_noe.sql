------------------------------------
-- 6	Trading Activities Model:
------------------------------------
set feedback off 

------------------------------------
--  6.2.1	NOEs : 
------------------------------------
BEGIN
	dbms_output.put_line('');
	dbms_output.put_line('******* NOE Import START ********');
	^trm.print_start_time();
END; -- Printout
/

-- Start Converting NOEs
DECLARE
	-- Vars:
	id_idx 			NUMBER(30);
	pb_org_acc_id 	NUMBER(30);
	issuer_acc_id 	NUMBER(30);
	base_inst_id 	NUMBER(30);
	sec_inst_id 	NUMBER(30);
	tparty_id 		NUMBER(30);
	cparty_id 		NUMBER(30);

	user_id 	NUMBER(30);
	entering_party_id 	NUMBER(30);
	trader_person_id 	NUMBER(30);

	-- Debugging
	noe_counter 			NUMBER(30);

	
	-- Cursors:
	-- Fech all relevant NOEs from DB Schema.
    cursor noes is 
		SELECT
			ta.ID, 
			ta.TYPE, 
		    ta.TRADE_DATE, 
			ta.EXTERNAL_REF, 
			ta.LIFE_CYCLE_STATUS,
	  		ta.LIFE_STATUS_REASON, 
	  		ta.APPROVE_STATUS, 
	  		ta.APPROVE_STATUS_REASON, 
	  		ta.ALLOC_STATUS, 
	  		ta.RECON_STATUS, 
	  		ta.CREATION_DATE, 
	  		ta.DESCRIPTION,
	  		ta.A_ROOT_ACTIVITY,  
	  		ta.A_TRADING_ACTIVITY_ID, 
	  		ta.A_TRADING_ACTIVITY_ID2, 
	  		a_noe.COUNTER_NOE_ID, 
	  		a_noe.RECONCILIATION_TIME, 
	  		fx_noe.CONTRACT_TYPE, 
	  		fx_noe.COUNTER_PARTY_LE_ID, 
	  		fx_noe.DIRECTION, 
	  		fx_noe.ENTERING_PARTY_LE_ID, 
	  		fx_noe.FIXING_DATE, 
	  		fx_noe.REPORTER_NAME, 
	  		fx_noe.TRADER_PERSON_ID, 
			fx_noe.SUBMITTER_PERSON_ID,
	  		fx_noe.TRADE_TYPE, 
	  		fx_noe.TRADING_PARTY_LE_ID,
	  		t1.QUANTITY as T1_QTY, 
	  		acc_id_map_s.TRM_ID as SELLER_ACC_ID_TRM, 
	  		t1.FROM_ACCOUNT_ID as T1_FROM_ACC_ID_MAP, 
	  		t1.INSTRUMENT_ID as T1_INST_ID, 
	  		t1.SETTLEMENT_DATE as T1_SETT_DATE, 
	  		t1.PRICE as T1_PRICE, 
	  		t2.QUANTITY as T2_QTY, 
	  		acc_id_map_b.TRM_ID as BUYER_ACC_ID_TRM, 
	  		t2.FROM_ACCOUNT_ID as T2_FROM_ACC_ID, 
	  		t2.INSTRUMENT_ID as T2_INST_ID, 
	  		t3.QUANTITY as T3_QTY, 
	  		t3.SETTLEMENT_DATE as T3_SETT_DATE, 
	  		t3.PRICE as T3_PRICE, 
			t4.QUANTITY as T4_QTY,
			-- DIRECT agreement type
			(select count(*) from ^eswitch.A_LE_2_LE_ROLE ler where
				ler.FROM_LE = 710 
				and (ler.TO_LE = fx_noe.TRADING_PARTY_LE_ID OR ler.TO_LE = fx_noe.COUNTER_PARTY_LE_ID)
			 	and ROLE = 4) as DIRECT_REL_COUNT,
			-- Entering Party's Owned Account ID
			(select MIN(ale.ACCOUNT_ID) from ^eswitch.A_ACCOUNT_LEGAL_ENTITY ale where ale.LEGAL_ENTITY_ID = fx_noe.ENTERING_PARTY_LE_ID
			and ale.RELATION_TYPE = 1) as ENTER_LE_OWNED_ACC_ID
		FROM
	  		^eswitch.A_TRADING_ACTIVITY ta, 
			^eswitch.A_NOE a_noe, 
			^eswitch.FXPB_NOE fx_noe,
			^eswitch.A_TRANSFER t1, 
			^trm.MIG_OWNED_ACC_ID_MAPPING acc_id_map_s,  
			^eswitch.A_TRANSFER t2, 
			^trm.MIG_OWNED_ACC_ID_MAPPING acc_id_map_b,  
			^eswitch.A_TRANSFER t3, 
			^eswitch.A_TRANSFER t4
		WHERE 
			ta.ID >= ^noe_id_start and
			t1.SETTLEMENT_DATE >= to_date ('^noe_value_date_start', 'mm/dd/yyyy') and -- cut by Value date
			ta.TYPE = 2								-- TYPE: NOE
			and ta.DOMAIN_ID in (^domain)				-- Domain: VOID/DB App
			and fx_noe.ID = a_noe.ID 
			and a_noe.ID = ta.ID 
			and t1.TRADING_ACTIVITY_ID = fx_noe.ID		-- Transfer 1 - always exists
			and t1.ORDER_SEQ = 1
			and acc_id_map_s.ESWITCH_ID = t1.FROM_ACCOUNT_ID
			and t2.TRADING_ACTIVITY_ID = fx_noe.ID		-- Transfer 2 - always exists
			and t2.ORDER_SEQ = 2
			and acc_id_map_b.ESWITCH_ID = t2.FROM_ACCOUNT_ID
			and t3.TRADING_ACTIVITY_ID(+) = fx_noe.ID	-- Transfer 3 - Swaps only
			and t3.ORDER_SEQ(+) = 3
			and t4.TRADING_ACTIVITY_ID(+) = fx_noe.ID	-- Transfer 4 - Swaps only
			and t4.ORDER_SEQ(+) = 4
			;

BEGIN
	dbms_output.put_line('NOE List Fetched from Source Schema (^eswitch), Inserting data to Target Schema (^trm)');
	^trm.print_time();
	
	 -- Initializations:
	id_idx 			:= 0;
	pb_org_acc_id 	:= 0;
	issuer_acc_id 	:= 0;
	base_inst_id 	:= 0;
	sec_inst_id 	:= 0;
	tparty_id 		:= 0;
	cparty_id 		:= 0;

	user_id 	:= 0;
	entering_party_id 	:= 0;
	trader_person_id 	:= 0;
	
	noe_counter :=0;

	-- LOOP START
	FOR noe IN noes LOOP

^DEBUG		dbms_output.put_line('>>> converting NOE ID: ' || noe.ID);

		noe_counter := noe_counter+1;

		------------------------------------
		-- Add ID Mapping
		------------------------------------
		select ^trm.A_TA_SEQ.nextval into id_idx from DUAL;

		INSERT INTO ^trm.MIG_TA_ID_MAPPING_NOE (ESWITCH_ID, TRM_ID) 
			VALUES(noe.ID, id_idx);

		------------------------------------
		-- Insert Trading Activity Data
		------------------------------------
		pb_org_acc_id 	:= ^PBOrgAccID;
		issuer_acc_id := noe.ENTER_LE_OWNED_ACC_ID + ^incID;
		base_inst_id 	:= noe.T1_INST_ID + ^incID;
		sec_inst_id 	:= noe.T2_INST_ID + ^incID;
		tparty_id 		:= noe.TRADING_PARTY_LE_ID + ^incID;
		cparty_id 		:= noe.COUNTER_PARTY_LE_ID + ^incID;
		
		INSERT INTO ^trm.A_TA (
			ID, BASIC_STATUS, BASIC_STATUS_REASON, 
			ISSUER_ACCOUNT_ID, TXN_TYPE, 
			SELLER_ACCOUNT_ID, BUYER_ACCOUNT_ID, 
			BASE_INSTRUMENT_ID, SECONDERY_INSTRUMENT_ID, 
			BASE_INSTRUMENT_QTY, SECONDERY_INSTRUMENT_QTY, 
			SELLER_NOE_ID, BUYER_NOE_ID, RATE, FAR_RATE, 
			VALUE_DATE, TRADE_DATE, CREATED_DATE, 
			TXN_CONTRACT_DIRECTION, 
			RELATED_TXN_ID, TRADE_GROUP_ID, PARENT_TRADE_ID, DESCRIPTION, 
			TRADING_PARTY, COUNTER_PARTY, 
			TRADING_PARTY_NOE_ID, COUNTER_PARTY_NOE_ID)
		VALUES (
			id_idx, 1, ^mReason, 
			issuer_acc_id, 1, 
			noe.SELLER_ACC_ID_TRM, noe.BUYER_ACC_ID_TRM,  
			base_inst_id, sec_inst_id, 
			noe.T2_QTY, noe.T1_QTY, 
			-1, -1, noe.T1_PRICE, 0, 
			noe.T1_SETT_DATE, noe.TRADE_DATE, noe.CREATION_DATE, 
			DECODE(noe.CONTRACT_TYPE, 1, 2, 2, 1, 4, 1, 8, 2, ^nTodo), 
			-1, -1, -1, noe.DESCRIPTION, 
			tparty_id, cparty_id, 
			-1, -1);

		------------------------------------
		-- Insert FX NOE Data
		------------------------------------
		user_id 	:= noe.SUBMITTER_PERSON_ID + ^incID;
		entering_party_id 	:= noe.ENTERING_PARTY_LE_ID + ^incID;

		IF (noe.TRADER_PERSON_ID = -1) THEN
		    trader_person_id 	:= -1;
		ELSE
			trader_person_id 	:= noe.TRADER_PERSON_ID + ^incID;
		END IF;

		INSERT INTO ^trm.M_FX_NOE(
			ID, USER_ID, ENTERED_BY, 
			LIFECYCLE_STATUS, 
			LIFECYCLE_STATUS_REASON, 
			ALLOCATION_STATUS, ALLOCATION_STATUS_REASON, 
			MATCHING_STATUS, MATCHING_STATUS_REASON, 
			APPROVAL_STATUS, 
			APPROVAL_STATUS_REASON, 
			PROCESSING_STATUS, PROCESSING_STATUS_REASON, 
			TRADER, PORTFOLIO, CLIENT_REF, ORIGIN_SYSTEM, MATCHING_TIME, 
			AGREEMENT_TYPE, REPORTER, TRADE_TYPE, 
			PRODUCT_TYPE, 
			PRIME_BROKER, HARMONY_LIFECYCLE_STATUS, HARMONY_ID, 
			FAR_QUANTITY, FAR_VALUE_DATE, 
			FAR_RATE, FAR_QUANTITY2, 
			NDF_INDICATOR, NDF_FIXING_DATE, 
			NDF_FIXING_REFERENCE, EXECUTING_PLATFORM, 
			UNDERLYING_CLIENT_REF, CALC_AGENT)
		VALUES (
			id_idx, user_id, entering_party_id, 
			DECODE(noe.LIFE_CYCLE_STATUS, 1, 8, 4, 2, 8, 5, 16, 4, 32, 3, 64, 7, 128, 1, 256, 4, -9), 
			DECODE(noe.LIFE_STATUS_REASON, 1, 'AUTHORIZATION_FAILURE', 2, 'ACCOUNT_NOT_ACTIVE', 3, 'CHANGE_BY_XML_REQUEST', 4, 'FAILED_UNIFY_NOE_BECAUSE_OA_FAILURE', ^mReason), 
			DECODE(noe.ALLOC_STATUS, 0, 1, 1, 2, -9), ^mReason, 
			DECODE(noe.RECON_STATUS, 0, 2, 1, 1, 2, 3, 4, 4, -9), ^mReason, 
			DECODE(noe.APPROVE_STATUS, 1, 1, 2, 2, 4, 4, -9), 
			DECODE(noe.APPROVE_STATUS_REASON, 1, 'AUTHORIZATION_FAILURE', 2, 'ACCOUNT_NOT_ACTIVE', 3, 'CHANGE_BY_XML_REQUEST', 4, 'FAILED_UNIFY_NOE_BECAUSE_OA_FAILURE', ^mReason), 
			15, ^mReason, 
			trader_person_id, -1, noe.EXTERNAL_REF, 1, noe.RECONCILIATION_TIME, 
			DECODE(noe.DIRECT_REL_COUNT, 1, 4, 3), noe.REPORTER_NAME, noe.TRADE_TYPE, 
			DECODE(noe.CONTRACT_TYPE, 1, 1, 2, 1, 4, 3, 8, 3, ^nTodo), 
			^PBOrgID, NULL, 0, 
			noe.T3_QTY, noe.T3_SETT_DATE, 
			noe.T3_PRICE, noe.T4_QTY, 
			CASE WHEN noe.FIXING_DATE IS NOT NULL THEN 1 ELSE 0 END, noe.FIXING_DATE, 
			NULL, -1, 
			NULL, 0);

	END LOOP;	-- LOOP END
	
	dbms_output.put_line('Converted ' || noe_counter || ' NOEs' );
	^trm.print_end_time();
	dbms_output.put_line('******* NOE Import END ********');

END;
/

------------------------------------
--  6.2.1.2	TA-TA Relations (NOEs) 
------------------------------------
BEGIN
	dbms_output.put_line('');
	dbms_output.put_line('******* NOE Relations Import START ********');
	^trm.print_start_time();
END;  -- Printout
/

-- Start Converting NOE Relations
DECLARE	

	ta_rel_idx 		NUMBER(30);

	-- Debugging
	rel_counter 			NUMBER(30);

	-- Fech all relevant NOE relations
    cursor noe_rels is 
		SELECT
			ta.ID,
			noe_id_map.TRM_ID as ID_TRM,
			ta.LIFE_CYCLE_STATUS,
	  		ta.A_ROOT_ACTIVITY,  
			noe_id_map_root.TRM_ID as A_TA_ROOT_TRM,
	  		ta.A_TRADING_ACTIVITY_ID,
			noe_id_map_ta1.TRM_ID as A_TA_ID_TRM,
	  		ta.A_TRADING_ACTIVITY_ID2, 
			noe_id_map_ta2.TRM_ID as A_TA_ID2_TRM,
	  		a_noe.COUNTER_NOE_ID, 
			noe_id_map_counter.TRM_ID as COUNTER_NOE_ID_TRM
		FROM
	  		^eswitch.A_TRADING_ACTIVITY ta, 
			^trm.MIG_TA_ID_MAPPING_NOE noe_id_map,
			^trm.MIG_TA_ID_MAPPING_NOE noe_id_map_ta1,
			^trm.MIG_TA_ID_MAPPING_NOE noe_id_map_ta2,
			^trm.MIG_TA_ID_MAPPING_NOE noe_id_map_root,  
			^eswitch.A_NOE a_noe, 
			^trm.MIG_TA_ID_MAPPING_NOE noe_id_map_counter  
		WHERE 
			ta.TYPE = 2								-- TYPE: NOE
			and ta.DOMAIN_ID in (^domain)				-- Domain: VOID/DB App
			and noe_id_map.ESWITCH_ID(+) = ta.ID
			and noe_id_map_ta1.ESWITCH_ID(+) = ta.A_TRADING_ACTIVITY_ID
			and noe_id_map_ta2.ESWITCH_ID(+) = ta.A_TRADING_ACTIVITY_ID2
			and noe_id_map_root.ESWITCH_ID(+) = ta.A_ROOT_ACTIVITY
			and a_noe.ID = ta.ID 
			and noe_id_map_counter.ESWITCH_ID(+) = a_noe.COUNTER_NOE_ID
			;

BEGIN

	dbms_output.put_line('NOE List Fetched from Source Schema (^eswitch), Inserting data to Target Schema (^trm)');
	^trm.print_time();

	ta_rel_idx 		:= 0;
	
	rel_counter   := 0;
	
	-- LOOP START
	FOR noe_rel IN noe_rels LOOP
	
^DEBUG			dbms_output.put_line('>>> ----------------------------------------');
^DEBUG			dbms_output.put_line('>>> NOE ID: ' || noe_rel.ID);
^DEBUG			dbms_output.put_line('>>> Life Status: ' || noe_rel.LIFE_CYCLE_STATUS);
^DEBUG			dbms_output.put_line('>>> Root Activity: ' || noe_rel.A_ROOT_ACTIVITY);
^DEBUG			dbms_output.put_line('>>> TA 1: ' || noe_rel.A_TRADING_ACTIVITY_ID);
^DEBUG			dbms_output.put_line('>>> TA 2: ' || noe_rel.A_TRADING_ACTIVITY_ID2);
^DEBUG			dbms_output.put_line('>>> ----------------------------------------');

	rel_counter := rel_counter+1;

		------------------------------------
		-- NOE-NOE Relations:
		------------------------------------
		------------------------------------
		-- Insert NOE-NOE "REVERSED" Relation
		------------------------------------
		IF (noe_rel.LIFE_CYCLE_STATUS = 256 AND noe_rel.A_TRADING_ACTIVITY_ID > 0 and noe_rel.A_TA_ID_TRM <> NULL) THEN

^DEBUG			dbms_output.put_line('>>> adding REVERSED relation (Parent: ' || noe_rel.A_TA_ID_TRM || ', Child: ' || noe_rel.ID_TRM || ')');

			select ^trm.A_TA_TA_REL_SEQ.nextval into ta_rel_idx from DUAL;

			INSERT INTO ^trm.A_TA_TA_REL (ID, BASIC_STATUS, BASIC_STATUS_REASON, PARENT_TA_ID, CHILD_TA_ID, RELATION) --1
			VALUES(ta_rel_idx, 1, NULL, noe_rel.A_TA_ID_TRM, noe_rel.ID_TRM, 8);

		------------------------------------
		-- Insert NOE-NOE "UNIFIED" Relation
		------------------------------------
		ELSIF (noe_rel.LIFE_CYCLE_STATUS = 64 AND noe_rel.A_ROOT_ACTIVITY > 0 and noe_rel.A_TA_ROOT_TRM<> NULL) THEN

^DEBUG			dbms_output.put_line('>>> adding UNIFIED relation (Parent: ' || noe_rel.A_TA_ROOT_TRM || ', Child: ' || noe_rel.ID_TRM || ')');

			select ^trm.A_TA_TA_REL_SEQ.nextval into ta_rel_idx from DUAL;

			INSERT INTO ^trm.A_TA_TA_REL(ID, BASIC_STATUS, BASIC_STATUS_REASON, PARENT_TA_ID, CHILD_TA_ID, RELATION) --2
			VALUES(ta_rel_idx, 1, NULL, noe_rel.A_TA_ROOT_TRM, noe_rel.ID_TRM, 6);

		------------------------------------
		-- Insert NOE-NOE "REPLACED - REPLACING" Relation
		------------------------------------
		ELSIF (noe_rel.LIFE_CYCLE_STATUS = 16 AND noe_rel.A_TRADING_ACTIVITY_ID2 > 0 and noe_rel.A_TA_ID2_TRM <> NULL) THEN

^DEBUG			dbms_output.put_line('>>> adding MODIFY(REPLACE) relation (Parent: ' || noe_rel.A_TA_ID2_TRM || ', Child: ' || noe_rel.ID_TRM || ')');

			select ^trm.A_TA_TA_REL_SEQ.nextval into ta_rel_idx from DUAL;

			INSERT INTO ^trm.A_TA_TA_REL(ID, BASIC_STATUS, BASIC_STATUS_REASON, PARENT_TA_ID, CHILD_TA_ID, RELATION) --3
			VALUES(ta_rel_idx, 1, NULL, noe_rel.A_TA_ID2_TRM, noe_rel.ID_TRM, 7);

		------------------------------------
		-- Insert NOE-NOE "MATCH" Relation
		------------------------------------
		ELSIF (noe_rel.COUNTER_NOE_ID > 0 AND noe_rel.COUNTER_NOE_ID > noe_rel.ID and noe_rel.COUNTER_NOE_ID_TRM <> NULL) THEN

^DEBUG			dbms_output.put_line('>>> adding MATCH(COUNTER_NOE) relation (Parent: ' || noe_rel.COUNTER_NOE_ID_TRM || ', Child: ' || noe_rel.ID_TRM || ')');

			select ^trm.A_TA_TA_REL_SEQ.nextval into ta_rel_idx from DUAL;

			INSERT INTO ^trm.A_TA_TA_REL(ID, BASIC_STATUS, BASIC_STATUS_REASON, PARENT_TA_ID, CHILD_TA_ID, RELATION) --4
			VALUES(ta_rel_idx, 1, NULL, noe_rel.COUNTER_NOE_ID_TRM, noe_rel.ID_TRM, 9);

		END IF;

	END LOOP;	-- LOOP END

	dbms_output.put_line('Converted ' || rel_counter || ' NOE Relations' );
	^trm.print_end_time();
	dbms_output.put_line('******* NOE Relations Import END ********');

END;
/
	
