------------------------------------
-- 6	Trading Activities Model:
------------------------------------
set feedback off 

------------------------------------
--  6.2.2	Trades 
------------------------------------
BEGIN
	dbms_output.put_line('******* Trade Import START ********');
	^trm.print_start_time();
END; -- Printout
/


-- Start Converting Trades
DECLARE
	-- Vars:
	is_tg 			NUMBER(1);
	id_idx 			NUMBER(30);
	txn_type 		NUMBER(30);
	issuer_acc_id 	NUMBER(30);
	base_inst_id 	NUMBER(30);
	sec_inst_id 	NUMBER(30);
	tparty_id 		NUMBER(30);
	cparty_id 		NUMBER(30);

	life_status 		NUMBER(30);
	bsr_status 		NUMBER(30);
	
	-- Debugging
	trade_counter 			NUMBER(30);
	commit_counter		NUMBER(30);

	-- Cursors:
	-- Fech all relevant Trades from DB Schema.
    cursor trades is 
		   SELECT 
			   ta.ID, 
			   ta.TYPE, 
			   ta.DOMAIN_ID,
			   ta.A_ROOT_ACTIVITY, 
			   ta.TRADE_DATE, 
			   ta.LIFE_CYCLE_STATUS, 
			   ta.LIFE_STATUS_REASON, 
			   ta.ALLOC_STATUS, 
			   ta.RECON_STATUS, 
			   ta.CREATION_DATE, 
			   ta.DESCRIPTION, 
			   trade.TRADING_ACTIVITY_SIDE_A_ID, 
			   noe_id_map_a.TRM_ID as TA_SIDE_A_ID_TRM,
			   trade.TRADING_ACTIVITY_SIDE_B_ID,
			   noe_id_map_b.TRM_ID as TA_SIDE_B_ID_TRM,
			   noe_a.TRADING_PARTY_LE_ID,  
			   noe_a.COUNTER_PARTY_LE_ID, 
			   noe_a.CONTRACT_TYPE, 
			   t1.QUANTITY as T1_QTY, 
	  		   acc_id_map_s.TRM_ID as SELLER_ACC_ID_TRM, 
			   t1.FROM_ACCOUNT_ID as T1_FROM_ACC_ID, 
			   t1.INSTRUMENT_ID as T1_INST_ID, 
			   t1.SETTLEMENT_DATE as T1_SETT_DATE, 
			   t1.PRICE as T1_PRICE, 
			   t2.QUANTITY as T2_QTY, 
	  		   acc_id_map_b.TRM_ID as BUYER_ACC_ID_TRM, 
			   t2.FROM_ACCOUNT_ID as T2_FROM_ACC_ID, 
			   t2.INSTRUMENT_ID as T2_INST_ID,
			   -- Entering Party's Owned Account ID
			   (select MIN(ale.ACCOUNT_ID) from ^eswitch.A_ACCOUNT_LEGAL_ENTITY ale where ale.LEGAL_ENTITY_ID = noe_a.ENTERING_PARTY_LE_ID
			   and ale.RELATION_TYPE = 1) as ENTER_LE_OWNED_ACC_ID
			FROM 
				 ^eswitch.A_TRADING_ACTIVITY ta, 
				 ^eswitch.A_TRADE trade, 
				 ^eswitch.FXPB_NOE noe_a, 
				 ^eswitch.A_TRANSFER  t1, 
			     ^trm.MIG_OWNED_ACC_ID_MAPPING acc_id_map_s,  
				 ^eswitch.A_TRANSFER  t2, 
			    ^trm.MIG_OWNED_ACC_ID_MAPPING acc_id_map_b,  
				 ^trm.MIG_TA_ID_MAPPING_NOE noe_id_map_a, 
				 ^trm.MIG_TA_ID_MAPPING_NOE noe_id_map_b
			WHERE	   
				ta.TYPE in (1, 6)								-- TYPE: Trade/Master Trade
				and ta.DOMAIN_ID in (^domain)				-- Domain: VOID/DB App
			 	and trade.ID = ta.ID
				and noe_a.ID = trade.TRADING_ACTIVITY_SIDE_A_ID
				and t1.TRADING_ACTIVITY_ID = ta.ID		-- Transfer 1 - always exists
				and t1.ORDER_SEQ = 1
				and acc_id_map_s.ESWITCH_ID = t1.FROM_ACCOUNT_ID
				and t2.TRADING_ACTIVITY_ID = ta.ID		-- Transfer 2 - always exists
				and t2.ORDER_SEQ = 2
				and acc_id_map_b.ESWITCH_ID = t2.FROM_ACCOUNT_ID
				and noe_id_map_a.ESWITCH_ID = trade.TRADING_ACTIVITY_SIDE_A_ID
				and noe_id_map_b.ESWITCH_ID = trade.TRADING_ACTIVITY_SIDE_B_ID
				order by ta.ID asc
				;

BEGIN

	dbms_output.put_line('TRADE List Fetched from Source Schema (^eswitch), Inserting data to Target Schema (^trm)');
	^trm.print_time();

	 -- Initializations:
	is_tg				:= 0; -- false  
	id_idx 			:= 0;
	txn_type		:= 0;
	issuer_acc_id 	:= 0;
	base_inst_id 	:= 0;
	sec_inst_id 	:= 0;
	tparty_id 		:= 0;
	cparty_id 		:= 0;
	
	life_status := 0;
	bsr_status := 0;
	
	trade_counter := 0;
	commit_counter :=1;

	-- LOOP START
	FOR trade IN trades LOOP
	
^DEBUG		dbms_output.put_line('>>> converting Trade ID: ' || trade.ID);
^DEBUG		dbms_output.put_line('>>> trade.A_ROOT_ACTIVITY: ' || trade.A_ROOT_ACTIVITY);
^DEBUG		dbms_output.put_line('>>> is_tg: ' || is_tg);

		trade_counter := trade_counter+1;
		
		if(trade.A_ROOT_ACTIVITY = 0) then 
			is_tg := 1;
		else
			is_tg := 0;
		end if;
		 
		------------------------------------
		-- Add ID Mapping
		------------------------------------
		select ^trm.A_TA_SEQ.nextval into id_idx from DUAL;

		INSERT INTO ^trm.MIG_TA_ID_MAPPING_TRADE (ESWITCH_ID, TRM_ID) 
			VALUES(trade.ID, id_idx);

		------------------------------------
		-- Insert Trading Activity Data
		------------------------------------
		if(is_tg = 1) then 
			txn_type := 2;		 --TG
		else 
			txn_type := 3;		 -- Trade
		end if;
		
^DEBUG		dbms_output.put_line('>>> txn_type: ' || txn_type);

		issuer_acc_id := trade.ENTER_LE_OWNED_ACC_ID + ^incID;
		base_inst_id 	:= 	trade.T1_INST_ID + ^incID;
		sec_inst_id 	:= trade.T2_INST_ID + ^incID;
		tparty_id 		:= trade.TRADING_PARTY_LE_ID + ^incID;
		cparty_id 		:= trade.COUNTER_PARTY_LE_ID + ^incID;

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
			issuer_acc_id, txn_type, 
			trade.SELLER_ACC_ID_TRM, trade.BUYER_ACC_ID_TRM,  
			base_inst_id, sec_inst_id, 
			trade.T1_QTY, trade.T2_QTY, 
			trade.TA_SIDE_B_ID_TRM, trade.TA_SIDE_A_ID_TRM, trade.T1_PRICE, NULL, 
			trade.T1_SETT_DATE, trade.TRADE_DATE, DECODE(trade.CREATION_DATE, NULL, SYSDATE, trade.CREATION_DATE), 
			DECODE(trade.CONTRACT_TYPE, 1, 2, 2, 1, 4, 1, 8, 2, ^nTodo), 
			-1, trade.A_ROOT_ACTIVITY, -1, trade.DESCRIPTION, 
			tparty_id, cparty_id, 
			trade.TA_SIDE_A_ID_TRM, trade.TA_SIDE_B_ID_TRM);

		------------------------------------
		-- Insert FX Trade Data
		------------------------------------
		if(is_tg = 1) then  -- TG
			select DECODE(trade.ALLOC_STATUS, 16, 1, 32, 4, 64, 3, 128, 2, -9) into life_status from DUAL; 	  
		else
			if (trade.TYPE = 6) then -- Master Trade 				   
			   life_status := 3; 	
			else 	-- Trade
				select DECODE(trade.LIFE_CYCLE_STATUS, 1, 1, 2, 2, 4, 3, 8, 5, -9) into life_status from DUAL;
			end if; 
		end if;
		
		if(is_tg = 1) then  -- TG
			bsr_status := 9; 
		else
			if (trade.TYPE = 6) then -- Master Trade 				   
			    bsr_status := 3; 	  
			else 	-- Trade
				select DECODE(trade.RECON_STATUS, 0, 3, 256, 5, 512, 1, -9) into bsr_status from DUAL; 	  
			end if; 
		end if;

		INSERT INTO ^trm.M_FX_TRADE(
			   ID, 
			   LIFECYCLE_STATUS, LIFECYCLE_STATUS_REASON, 
			   BSR_STATUS, BSR_STATUS_REASON, 
			   PROCESSING_STATUS, 
			   PROCESSING_STATUS_REASON)
		VALUES (
			   id_idx, 
			   life_status, ^mReason,
			   bsr_status, ^mReason,
			   14, ^mReason);

		IF (mod(commit_counter, ^CommitLoopMod) = 0) THEN 
				COMMIT;
		END IF;
		commit_counter := commit_counter+1;
		
^DEBUG		dbms_output.put_line('commit_counter: ' + commit_counter);

	END LOOP;	-- LOOP END
	
	dbms_output.put_line('Converted ' || trade_counter || ' Trades' );
	^trm.print_end_time();
	dbms_output.put_line('******* Trade Import END ********');

END;
/

----------------------------------------
--  Update  Root Activity ID 
----------------------------------------
BEGIN
	dbms_output.put_line('******* TG IDs Update START ********');
	^trm.print_start_time();
END; -- Printout
/

UPDATE ^trm.A_TA ta 
	   SET ta.TRADE_GROUP_ID = 
	   	   (select  TRM_ID from ^trm.MIG_TA_ID_MAPPING_TRADE map where map.ESWITCH_ID = ta.TRADE_GROUP_ID) 
		WHERE ta.TXN_TYPE = 3;

BEGIN
	^trm.print_end_time();
	dbms_output.put_line('******* TG IDs Update END ********');
END; -- Printout
/
