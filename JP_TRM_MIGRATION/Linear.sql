set echo on

set define "^"
set pagesize 0
set linesize 5000

@defines.sql
--@pre_migration.sql


define Linear_file=linear.csv
define Linear_oa_file=linear_oa.csv

prompt *********************************
prompt *   Linear Trades Migration     *
prompt *********************************
spool ^Linear_file

WITH 
	CCY_PAIR as 
		(
		select 
			FIRST_CCY_ID 	ccy_1_id, 
			SECOND_CCY_ID	ccy_2_id,
			RATE_DIRECTION  Direction,
			case 
				when (nvl(ccy1.ndf,0)>0 or nvl(ccy2.ndf,0)>0 ) then 1
				else 0
			end 			is_ndf
		from 
			^DB_SCHEMA..arch_billing_ccy_pair  p, 
			^DB_SCHEMA..a_instrument		ccy1,
			^DB_SCHEMA..a_instrument		ccy2
		where p.FIRST_CCY_ID = ccy1.id
		  and p.SECOND_CCY_ID = ccy2.id
		union
		select 
			SECOND_CCY_ID 	ccy_1_id, 
			FIRST_CCY_ID	ccy_2_id,
			1-RATE_DIRECTION  Direction,
			case 
				when (nvl(ccy1.ndf,0)>0 or nvl(ccy2.ndf,0)>0 ) then 1
				else 0
			end 			is_ndf
		from 
			^DB_SCHEMA..arch_billing_ccy_pair  p, 
			^DB_SCHEMA..a_instrument		ccy1,
			^DB_SCHEMA..a_instrument		ccy2
		where p.FIRST_CCY_ID = ccy1.id
		  and p.SECOND_CCY_ID = ccy2.id
		)
SELECT 
         '^string'|| CASE
						WHEN (pair1.IS_NDF=0 ) THEN product_group.string		
						WHEN (NOE.NEAR_NDF_FIXING_DATE is not null) THEN 'NDF'
						WHEN (NOE.FAR_NDF_FIXING_DATE is not null) THEN 'NDF'
						ELSE product_group.string		
					END 						-- D01	Product Group    
    ||'^delimiter'|| 'REPORT'					-- D02	Action
    ||'^delimiter'|| trade_type.string			-- D03	Message Type
    ||'^delimiter'|| 'NEW'						-- D04	Process
    ||'^delimiter'|| CASE 
						when trade_type.string not in ('EXERCISE','FIX') THEN EXTERNAL_REF
						ELSE ''
					END 						-- D05	Trade Ref
    ||'^delimiter'|| '' 						-- D06	Direct	
    ||'^delimiter'|| CASE WHEN NOE.TA_ROLE = ^TA_ROLE_BANK
						THEN 'BANK'
						ELSE 'CLIENT'
					 END 						-- D07	Entity	
    ||'^delimiter'|| portfolio.external_value	-- D08	Portfolio
    ||'^delimiter'||''							-- D09	Region
    ||'^delimiter'||''							-- D10	Reporting System
    ||'^delimiter'|| EXTERNAL_REF 				-- D11	Reporter Ticket Number
    ||'^delimiter'|| tp.external_value			-- D12	Trade Reporter
    ||'^delimiter'|| trader.external_value		-- D13	Trader Name
    ||'^delimiter'|| cp.external_value			-- D14	Counterparty
    ||'^delimiter'||''							-- D15	Counterparty Ticket Number
    ||'^delimiter'||pb.external_value			-- D16	Prime Broker
    ||'^delimiter'||to_char(NOE.TRADE_DATE,'^DATE_ONLY')
												-- D17	Trade Date
    ||'^delimiter'||CASE
						WHEN (pair1.IS_NDF=0 ) THEN product_type.string		
						WHEN (NOE.NEAR_NDF_FIXING_DATE is not null) THEN 'NDF'
						WHEN (NOE.FAR_NDF_FIXING_DATE is not null) THEN 'NDF'
						ELSE product_type.string		
					END 						-- D18	Product Type
    ||'^delimiter'||decode(NOE.near_direction,1,'BUY','SELL')||
					decode(NOE.far_direction,1,'BUY',2,'SELL','')
												-- D19	Direction
    ||'^delimiter'||ccy1.name					-- D20	Traded Currency
    ||'^delimiter'||ccy2.name					-- D21	Counter Currency
    ||'^delimiter'||NEAR_QTY_1 					-- D22	Traded Amount
    ||'^delimiter'||FAR_QTY_1					-- D23	Far Traded Amount
    ||'^delimiter'||NEAR_RATE					-- D24	Dealt Rate
    ||'^delimiter'||CASE WHEN pair1.direction = 1
						then ccy1.name || '-' ||ccy2.name 
						else ccy2.name || '-' ||ccy1.name
					END							-- D25	Quote Terms
    ||'^delimiter'||TO_CHAR(NOE.near_value_date, '^DATE_ONLY')
												-- D26	Value Date
    ||'^delimiter'||NOE.far_rate				-- D27	Far Dealt Rate 
    ||'^delimiter'||CASE 
					/* Far quat term is always opposite to then near */
						WHEN far_direction is null then ''
						else 'RATE'
					END							-- D28	Far Quote Terms
    ||'^delimiter'||TO_CHAR(NOE.far_value_date,'^DATE_ONLY')
												-- D29	Far Value Date
    ||'^delimiter'||''							-- D30	Calc Agent
    ||'^delimiter'||TO_CHAR(NOE.NEAR_NDF_FIXING_DATE,'^DATE_ONLY')
												-- D31	Fixing Date
    ||'^delimiter'||''							-- D32	Fixing Index
    ||'^delimiter'||'Orig Giveup Id:'|| NOE.id||
					'|Orig Creation Time:'||to_char(NOE.CREATION_DATE,'^DATE_NOTE')||
					CASE WHEN (NOE.ME_PARENT_TA_ID = 0)
						THEN ''
						ELSE '|Market event applied on:'||NOE.ME_PARENT_TA_ID
					END ||
					CASE WHEN (NOE.is_trade = 1)
						THEN '|Orig Match Time:' ||TO_CHAR(noe.RECONCILIATION_TIME,'^DATE_NOTE')
						ELSE ''
					END							-- D33	Notes
    ||'^delimiter'||NOE.NEAR_QTY_2				-- D34	Counter Amount
    ||'^delimiter'||NOE.FAR_QTY_2				-- D35	Far Counter Amount
    ||'^delimiter'||ECN.external_value			-- D36	ECN 
    ||'^delimiter'||''							-- D37	All In Rate
    ||'^delimiter'||''							-- D38	Spot Rate (Empty, OKed by Tali)
    ||'^delimiter'||''							-- D39	Forward Points
    ||'^delimiter'||''							-- D40	Far All In Rate
    ||'^delimiter'||''							-- D41	Far Forward Points
    ||'^delimiter'||'2'							-- D42	CSV Version
    ||'^delimiter'||nvl2(noe.ecn_id,'false','') -- D43	Is Anonymous
    ||'^delimiter'||TO_CHAR(NOE.FAR_NDF_FIXING_DATE,'^DATE_ONLY')
												-- D44	Far Fixing Date
	||'^delimiter'||reporting.string			-- D45	Origin System
    ||'^delimiter'||NOE.request_id||'^MIG_NOTE'||NOE.id
												-- D46	Harmony Id
    ||'^delimiter'||case when noe.recon_status=1
						then to_char(noe.id)
						else ''
					end							-- Additional1	Migrated Trade Id
    ||'^delimiter'||noe.bo_id					-- Additional2	Back Office Id
    ||'^delimiter'||CASE when external_ref = 'TRAIANA_'||NOE.ID 
						then '' -- manually entered
						else partner.external_value
					end							-- Additional3	Original Partner
    ||'^string'  
FROM 
    ^DB_SCHEMA..v_fd_fxpb_linear_Ta NOE,
	mig_translations 				product_group,
    mig_translations 				trade_type,
    ^DB_SCHEMA..v_arch_data_mapping portfolio, 
	MIG_TRANSLATIONS 				reporting, 
	^DB_SCHEMA..v_arch_data_mapping	tp,
	^DB_SCHEMA..v_arch_data_mapping	cp,
	^DB_SCHEMA..v_arch_data_mapping	pb,
	^DB_SCHEMA..v_arch_data_mapping	ECN,
	^DB_SCHEMA..v_arch_data_mapping	trader,
	^DB_SCHEMA..v_arch_data_mapping	partner,
	mig_translations 				product_type,
	^DB_SCHEMA..a_instrument		ccy1,
	^DB_SCHEMA..a_instrument		ccy2,
	CCY_PAIR 						pair1, 
	^DB_SCHEMA..a_organization		TP_org,
	^DB_SCHEMA..a_organization		CP_org,
	^DB_SCHEMA..a_organization		PB_org,
	^DB_SCHEMA..A_STATE_DETAIL		s_TP_org,
	^DB_SCHEMA..A_STATE_DETAIL		s_CP_org,
	^DB_SCHEMA..A_STATE_DETAIL		s_PB_org
WHERE  
   -- Cut by date 
      (
	  noe.near_value_date >=trunc(sysdate-^PAST_VALUE_DATE) OR
	  noe.far_value_Date   >= trunc(sysdate-^PAST_VALUE_DATE)	
	  )
   -- Client/Bank NOEs only
   AND TA_ROLE IN (^TA_ROLE_BANK, ^TA_ROLE_CLIENT)
   -- active,done
   AND noe.NOE_life_Status   in (2,4) 
   -- Translate trade type:
   AND NOE.TRADE_TYPE = trade_type.code
   AND trade_type.key = 'TradeType'
   -- Translate Product Group
   AND NOE.CONTRACT_TYPE = product_group.code
   AND product_group.key = 'ProductGroup'
  -- get portfolio name
  and noe.portfolio_id = portfolio.internal_value (+)
  and portfolio.map_type (+)= ^MAP_POTFOLIO
  and portfolio.namer_id (+)= ^PRIME_ORG
  -- get reporting system name
  and noe.origin = reporting.code (+)
  and reporting.key (+)= 'OriginType'
  -- TP Name
  and NOE.tp_id = tp.internal_value
  and tp.map_type = ^MAP_CLIENT
  AND tp.namer_id = ^PRIME_ORG
  and tp.type = 0
  -- CP Name
  and NOE.cp_id = cp.internal_value
  and cp.map_type = ^MAP_CLIENT
  AND cp.namer_id = ^PRIME_ORG
  and cp.type = 0
  -- PB Name
  and NOE.pb_id = pb.internal_value
  and pb.map_type = ^MAP_CLIENT
  AND pb.namer_id = ^PRIME_ORG
  and pb.type = 0
   -- Translate Product type
   AND NOE.CONTRACT_TYPE = product_type.code
   AND product_type.key = 'ProductType'
   -- CCY Translation
   AND NOE.near_ccy_1 = ccy1.id
   AND NOE.near_ccy_2 = ccy2.id
   -- Near Quote Terms
   AND NOE.near_ccy_1 = pair1.ccy_1_id
   and NOE.near_ccy_2 = pair1.ccy_2_id
   -- Get ECN Name
   And NOE.ECN_ID = ECN.internal_value(+)
   and ECN.map_type(+) = ^MAP_ECN
   AND ECN.namer_id(+) = ^PRIME_ORG
   and ECN.type(+) = 0
   -- Get Entring party  Name
   And NOE.partner_id = partner.internal_value(+)
   and partner.map_type(+) = ^MAP_CLIENT
   AND partner.namer_id(+) = ^PRIME_ORG  
   and partner.type(+) = 0
  -- Trader external value
  and NOE.trader_id=trader.internal_value(+)
  and trader.NAMER_ID(+) = ^PRIME_ORG 
  and trader.map_type(+) = ^MAP_TRADER 
  and trader.type(+) = 0 
--  and NOE.group_id > (select max(id)-500 from ^DB_SCHEMA..v_fd_fxpb_linear_Ta)
  -- Enabled participants only 
  and noe.tp_id = tp_org.id
  and tp_org.state_id = s_tp_org.state_id
  and s_tp_org.status_value = 1
  and noe.cp_id = cp_org.id
  and cp_org.state_id = s_cp_org.state_id
  and s_cp_org.status_value = 1
  and noe.pb_id = pb_org.id
  and pb_org.state_id = s_pb_org.state_id
  and s_pb_org.status_value = 1
;

spool off;
 



prompt *********************************
prompt *   Linear Allocations          *
prompt *********************************
spool ^Linear_oa_file 

select 
         '^string'||'FX'						-- D01	Product Group    
    ||'^delimiter'||'ALLOCATE'					-- D02	Action
    ||'^delimiter'||'REGULAR'					-- D03	Message Type	Constant
    ||'^delimiter'||'NEW'						-- D04	Process
    ||'^delimiter'||CLient_NOE.request_id||'^MIG_NOTE'||CLient_NOE.ID
												-- D05	Trade Ref
    ||'^delimiter'||fund.external_Value			-- D06	Fund
    ||'^delimiter'||TO_CHAR(NOE.trade_date, '^DATE_ONLY')
												-- D07	Trade Date
    ||'^delimiter'||NOE.external_ref			-- D08	Reporter Ticket Number
    ||'^delimiter'||NOE.NEAR_QTY_1				-- D09	Traded Amount
    ||'^delimiter'||reporting.string			-- D10	Origin System
    ||'^delimiter'||client.external_value		-- D11	Trade Reporter
    ||'^delimiter'||NOE.BO_ID					-- Additional1	Back Office Id
	||'^delimiter'||partner.external_value		-- Additional2	Original Partner
    ||'^string'  	
from 
    ^DB_SCHEMA..v_fd_fxpb_linear_Ta 	NOE,
	^DB_SCHEMA..fd_fxpb_linear_Ta 		CLient_NOE,
	^DB_SCHEMA..fd_fxpb_linear_Ta 		Split,
    ^DB_SCHEMA..v_arch_data_mapping 	fund, 
	MIG_TRANSLATIONS					reporting,
	^DB_SCHEMA..v_arch_data_mapping 	client,
	^DB_SCHEMA..v_arch_data_mapping 	partner, 
	^DB_SCHEMA..a_organization		TP_org,
	^DB_SCHEMA..a_organization		CP_org,
	^DB_SCHEMA..a_organization		PB_org,
	^DB_SCHEMA..A_STATE_DETAIL		s_TP_org,
	^DB_SCHEMA..A_STATE_DETAIL		s_CP_org,
	^DB_SCHEMA..A_STATE_DETAIL		s_PB_org
where    -- Cut by date 
      (
	  noe.near_value_date >=trunc(sysdate-^PAST_VALUE_DATE) OR
	  noe.far_value_Date   >= trunc(sysdate-^PAST_VALUE_DATE)	
	  )
   -- OA only
   AND NOE.TA_ROLE = ^TA_ROLE_FUND
   -- connect to split 
   and NOE.owner_id = split.id
   and split.ta_role = ^TA_ROLE_SPLIT
   -- Get active/done only 
   AND split.life_Status  in (2,4) 
   and CLient_NOE.noe_life_status in (2,4)
 -- Fund Name
  and NOE.tp_id = fund.internal_value
  and fund.map_type = ^MAP_FUND
  AND fund.namer_id = ^PRIME_ORG
  -- get reporting system name
  and noe.origin = reporting.code (+)
  and reporting.key (+)= 'OriginTypeOA'
 -- get client name
  and noe.tp_owner_id = client.internal_value 
  and client.map_type = ^MAP_CLIENT
  and client.namer_id = ^PRIME_ORG
  -- get Original Partner entring party name
  and noe.partner_ID = partner.internal_value(+)
  and partner.map_type(+) = ^MAP_CLIENT
  and partner.namer_id(+) = ^PRIME_ORG
  -- Get related client NOE
  and NOE.GROUP_ID = CLient_NOE.GROUP_ID
  and CLient_NOE.ta_role = ^TA_ROLE_CLIENT
  -- ignore OAs from single funds clients. 
  and NOE.tp_id  not in (select fund_id from single_fund_clients)
--  and NOE.group_id > (select max(id)-500 from ^DB_SCHEMA..v_fd_fxpb_linear_Ta)
  -- Enabled participants only 
  and noe.tp_id = tp_org.id
  and tp_org.state_id = s_tp_org.state_id
  and s_tp_org.status_value = 1
  and noe.cp_id = cp_org.id
  and cp_org.state_id = s_cp_org.state_id
  and s_cp_org.status_value = 1
  and noe.pb_id = pb_org.id
  and pb_org.state_id = s_pb_org.state_id
  and s_pb_org.status_value = 1
order by CLient_NOE.request_id||'^MIG_NOTE'||CLient_NOE.ID
;

spool off
