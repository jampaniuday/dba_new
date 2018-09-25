set echo on

set define "^"
set pagesize 0
set linesize 5000

/************************/
/************************/
@defines.sql
--@pre_migration.sql

define trades_file=Digital.csv
define oas_file=Digital_oa.csv

set echo off
set trimspool on
set feedback off
set verify off
set heading off



/**** FOR TESTING ONLY *****/
/**** FOR TESTING ONLY *****/
/**** FOR TESTING ONLY *****/
/**** FOR TESTING ONLY *****/
--set timing on 
--	set time on 
/**** FOR TESTING ONLY *****/
/**** FOR TESTING ONLY *****/
/**** FOR TESTING ONLY *****/



prompt *********************************
prompt *   Digital Trades Migration     *
prompt *********************************
spool ^trades_file

WITH 
	CCY_PAIR as 
		(
		select 
			FIRST_CCY_ID 	ccy_1_id, 
			SECOND_CCY_ID	ccy_2_id,
			RATE_DIRECTION  Direction
		from ^DB_SCHEMA..arch_billing_ccy_pair
		union
		select 
			SECOND_CCY_ID 	ccy_1_id, 
			FIRST_CCY_ID	ccy_2_id,
			1-RATE_DIRECTION  Direction
		from ^DB_SCHEMA..arch_billing_ccy_pair
		)
SELECT 
         '^string'|| 'FXOPT' 					-- D01	Product Group    
    ||'^delimiter'|| 'REPORT'					-- D02	Action
    ||'^delimiter'|| 'REGULAR'					-- D03	Message Type
    ||'^delimiter'|| 'NEW'						-- D04	Process
    ||'^delimiter'|| EXTERNAL_REF				-- D05	Trade Ref
    ||'^delimiter'|| '' 						-- D06	Direct	
    ||'^delimiter'|| CASE WHEN NOE.TA_ROLE = ^TA_ROLE_BANK
						THEN 'BANK'
						ELSE 'CLIENT'
					 END 						-- D07	Entity	
    ||'^delimiter'|| portfolio.external_value	-- D08	Portfolio
    ||'^delimiter'|| ''							-- D09	Region
    ||'^delimiter'|| ''							-- D10	Reporting System
    ||'^delimiter'|| EXTERNAL_REF 				-- D11	Reporter Ticket Number
    ||'^delimiter'|| tp.external_value			-- D12	Trade Reporter
    ||'^delimiter'|| trader.external_value		-- D13	Trader Name
    ||'^delimiter'|| cp.external_value			-- D14	Counterparty
    ||'^delimiter'|| ''							-- D15	Counterparty Ticket Number
    ||'^delimiter'|| pb.external_value			-- D16	Prime Broker
    ||'^delimiter'|| to_char(NOE.TRADE_DATE,'^DATE_ONLY')
												-- D17	Trade Date
    ||'^delimiter'|| 'Digital'					-- D18	Product Type
    ||'^delimiter'|| decode(NOE.direction,1,'BUY','SELL')
												-- D19	Direction
	||'^delimiter'|| decode(noe.contract_type,1,'C','P')
												-- D20	Contract Type
	||'^delimiter'|| decode(noe.option_style,1,'E','A')
												-- D21	Option Style
	||'^delimiter'|| 'Cash'						-- D22	Delivery (group id 408038)
	||'^delimiter'||''							-- D23	N/A
	||'^delimiter'||ccy1.name					-- D24	Traded Currency
    ||'^delimiter'||ccy2.name					-- D25	Counter Currency
	||'^delimiter'||''							-- D26	N/A
    ||'^delimiter'||noe.QTY_1 					-- D27	Traded Amount
    ||'^delimiter'||TO_CHAR(NOE.value_date, '^DATE_ONLY')
												-- D28	Settlement Date
    ||'^delimiter'||noe.RATE					-- D29	Strike
    ||'^delimiter'||CASE WHEN pair1.direction = 1
						then ccy1.name || '-' ||ccy2.name 
						else ccy2.name || '-' ||ccy1.name
					END							-- D30	Quote Terms
	||'^delimiter'||''							-- D31	N/A
	||'^delimiter'||''							-- D32	N/A
	||'^delimiter'||''							-- D33	N/A
	||'^delimiter'||to_char(NOE.EXPIRY_DATE,'^DATE_ONLY')	
												-- D34	Expiry Date	
	||'^delimiter'||replace(NOE.expiry_time,':')-- D35	Expiry Time	
	||'^delimiter'||NOE.cut_off_zone			-- D36	Expiry Zone	
	||'^delimiter'||Premium_type.string			-- D37	Premium Type	
	||'^delimiter'||premium_ccy.name			-- D38	Premium Currency
	||'^delimiter'||CASE 
							when premium_type in (1,2) then price_paid    -- Premium Type is in percentage
							else premium_amount            				  -- Premium Type is flat
					end 						--D39	Premium Amount/ Percentage
	||'^delimiter'||case 
						WHEN Premium_type.string = 'FLAT' then  ''
						else '%'||premium_ccy.name
					end 						-- D40	Premium Quote Terms
	||'^delimiter'||to_char(NOE.PREMIUM_DATE,'^DATE_ONLY')	
												-- D41	Premium Payment Date
	||'^delimiter'||'1'							-- D42	Number Of Touches
	||'^delimiter'||'INSTANT'						-- D43	Timing --> only INSTANT supported at JP 
	||'^delimiter'||''							-- D44	Calc Agent
	||'^delimiter'||NOE.PAYOUT_AMOUNT			-- D45	Payout Amount
	||'^delimiter'||payout_ccy.name				-- D46	Payout CCY
	||'^delimiter'||'Orig Giveup Id:' || NOE.ID ||'|Orig Creation Time' || 
					to_char(NOE.CREATION_DATE,'^DATE_NOTE')||
					CASE WHEN (NOE.is_trade = 1)
						THEN '|Orig Match Time:' ||TO_CHAR(noe.RECONCILIATION_TIME,'^DATE_NOTE')
						ELSE ''
					END 						-- D47	Notes
	||'^delimiter'||''							-- D48	ECN 
	||'^delimiter'||'2'							-- D49	CSV Version
	||'^delimiter'||''							-- D50	Is Anonymous
	||'^delimiter'||reporting.string			-- D51	Origin System
    ||'^delimiter'||NOE.request_id||'^MIG_NOTE'||NOE.id
												-- D52	Harmony Id
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
    ^DB_SCHEMA..FD_FXPB_OPTION_TA	NOE,
    ^DB_SCHEMA..v_arch_data_mapping portfolio, 
	MIG_TRANSLATIONS 				reporting, 
	^DB_SCHEMA..v_arch_data_mapping	tp,
	^DB_SCHEMA..v_arch_data_mapping	cp,
	^DB_SCHEMA..v_arch_data_mapping	pb,
	^DB_SCHEMA..v_arch_data_mapping	trader,
	^DB_SCHEMA..v_arch_data_mapping	partner,
	^DB_SCHEMA..a_instrument		ccy1,
	^DB_SCHEMA..a_instrument		ccy2,
	^DB_SCHEMA..a_instrument		premium_ccy,
	^DB_SCHEMA..a_instrument		payout_ccy,
	MIG_TRANSLATIONS				Premium_type,
	CCY_PAIR 						pair1, 
	^DB_SCHEMA..a_organization		TP_org,
	^DB_SCHEMA..a_organization		CP_org,
	^DB_SCHEMA..a_organization		PB_org,
	^DB_SCHEMA..A_STATE_DETAIL		s_TP_org,
	^DB_SCHEMA..A_STATE_DETAIL		s_CP_org,
	^DB_SCHEMA..A_STATE_DETAIL		s_PB_org
WHERE NOE.option_type = 4 -- Digital 
   -- Cut by date 
   AND noe.value_date >=trunc(sysdate-^PAST_VALUE_DATE) 
   -- Client/Bank NOEs only
   AND TA_ROLE IN (^TA_ROLE_BANK, ^TA_ROLE_CLIENT)
   -- Get active,done NOEs
   AND noe.NOE_life_Status  in (2,4)
    -- Translate Premium_type type:
   AND NOE.Premium_TYPE = Premium_type.code
   AND Premium_type.key = 'optPremiumType'
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
   -- CCY Translation
   AND NOE.ccy_1 = ccy1.id
   AND NOE.ccy_2 = ccy2.id
   AND NOE.premium_ccy = premium_ccy.id
   and noe.payout_currency = payout_ccy.id(+)
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
  -- Near Quote Terms
  AND NOE.ccy_1 = pair1.ccy_1_id
  and NOE.ccy_2 = pair1.ccy_2_id
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
--and NOE.group_id > (select max(id)-500 from ^DB_SCHEMA..FD_FXPB_OPTION_TA)
;

spool off;
 

 

 

prompt **********************************
prompt *   Digital Allocations          *
prompt **********************************
spool ^oas_file 

select 
         '^string'||'FXOPT'						-- D01	Product Group    
    ||'^delimiter'||'ALLOCATE'					-- D02	Action
    ||'^delimiter'||'REGULAR'					-- D03	Message Type	Constant
    ||'^delimiter'||'NEW'						-- D04	Process
    ||'^delimiter'||CLient_NOE.request_id||'^MIG_NOTE'||CLient_NOE.ID
												-- D05	Trade Ref
    ||'^delimiter'||fund.external_Value			-- D06	Fund
    ||'^delimiter'||TO_CHAR(NOE.trade_date, '^DATE_ONLY')
												-- D07	Trade Date
    ||'^delimiter'||NOE.external_ref			-- D08	Reporter Ticket Number
    ||'^delimiter'||NOE.QTY_1				-- D09	Traded Amount
    ||'^delimiter'||reporting.string			-- D10	Origin System
    ||'^delimiter'||client.external_value		-- D11	Trade Reporter
    ||'^delimiter'||NOE.BO_ID					-- Additional1	Back Office Id
	||'^delimiter'||partner.external_value		-- Additional2	Original Partner
    ||'^string'  	
from 
    ^DB_SCHEMA..FD_FXPB_OPTION_TA 		NOE,
	^DB_SCHEMA..FD_FXPB_OPTION_TA 		CLient_NOE,
	^DB_SCHEMA..FD_FXPB_OPTION_TA 		Split,
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
	  noe.value_date >=trunc(sysdate-^PAST_VALUE_DATE)
   -- Digital
   AND NOE.option_type = 4 
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
order by NOE.external_ref
;

spool off
 