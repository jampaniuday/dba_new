WHENEVER OSERROR  EXIT SQL.SQLCODE
--SET HEADING off
--SET FEEDBACK off
SET VERIFY off
SET LINESIZE 1000
SET PAGESIZE 0
SET TRIMSPOOL on
SET DEFINE "^"
DEFINE delimiter=","
DEFINE dateFormat=DD-MM-YYYY


-- Refresh tables
DROP TABLE jpprodtrm3;
DROP TABLE jpprodtrm4;

CREATE TABLE jpprodtrm3 AS
SELECT t.*
FROM dba_apps.jpprodtrm3@jpprod t  ;

update jpprodtrm3 set partner_id='JPMC' where partner_id = 'Athena';
commit;

CREATE TABLE jpprodtrm4 AS
SELECT t.*
FROM jpmc_trm_pp.jpprodtrm4@jpuat t  ;

SET heading OFF
SET echo OFF
SET heading OFF
SET FEEDBACK OFF 
SPOOL ^1
SELECT  '"REQUEST_ID","PARTNER_ID","TP_ID","CP_ID","LIFE_STATUS","RECON_STATUS","APPROVE_STATUS","ALLOC_STATUS","PROCESSING_STATUS","TRADE_DATE","DIRECTION","CONTRACT_TYPE","NEAR_CCY_1","NEAR_QTY_1","NEAR_CCY_2","NEAR_QTY_2","NEAR_RATE","NEAR_VALUE_DATE","FAR_RATE","FAR_VALUE_DATE","FAR_QTY_1","FAR_QTY_2","PORTFOLIO_ID","TRADE_TYPE","AGREEMENT","NEAR_NDF_FIXING_DATE","ALLOCATION"'
FROM dual;
WITH a AS
(
SELECT request_id, partner_id--, tp_id, cp_id, life_status, recon_status, approve_status, alloc_status, processing_status, trade_date, direction, contract_type, near_ccy_1, near_qty_1, near_ccy_2, near_qty_2, near_rate, near_value_date, far_rate, far_value_date, far_qty_1, far_qty_2, portfolio_id, trade_type, agreement, ndf_fixing_date, fund_name, allocation_qty
FROM JPPRODTRM4
MINUS
SELECT request_id, partner_id--, tp_id, cp_id, life_status, recon_status, approve_status, alloc_status, processing_status, trade_date, direction, contract_type, near_ccy_1, near_qty_1, near_ccy_2, near_qty_2, near_rate, near_value_date, far_rate, far_value_date, far_qty_1, far_qty_2, portfolio_id, trade_type, agreement, near_ndf_fixing_date, fund_name, allocation_qty
FROM JPPRODTRM3 t
),
b AS
(
SELECT request_id, partner_id, tp_id, cp_id, life_status, recon_status, approve_status, alloc_status, processing_status, trade_date, direction, contract_type, near_ccy_1, near_qty_1, near_ccy_2, near_qty_2, near_rate, near_value_date, far_rate, far_value_date, far_qty_1, far_qty_2, portfolio_id, trade_type, agreement, ndf_fixing_date, allocation
FROM JPPRODTRM4
WHERE (request_id, partner_id) IN (SELECT request_id, partner_id FROM a)
)
SELECT '"' || b.request_id || '","' ||  b.partner_id || '","' ||  b.tp_id || '","' ||  b.cp_id || '","' ||  b.life_status || '","' ||  b.recon_status || '","' ||  b.approve_status || '","' ||  b.alloc_status || '","' ||  b.processing_status || '","' ||  b.trade_date || '","' ||  b.direction || '","' ||  b.contract_type || '","' ||  b.near_ccy_1 || '","' ||  b.near_qty_1 || '","' ||  b.near_ccy_2 || '","' ||  b.near_qty_2 || '","' ||  b.near_rate || '","' ||  b.near_value_date || '","' ||  b.far_rate || '","' ||  b.far_value_date || '","' ||  b.far_qty_1 || '","' ||  b.far_qty_2 || '","' ||  b.portfolio_id || '","' ||  b.trade_type || '","' ||  b.agreement || '","' ||  b.ndf_fixing_date || '","' || b.allocation|| '"'
FROM b
ORDER BY request_id;
SPOOL OFF;


SPOOL ^2
SELECT  '"REQUEST_ID","PARTNER_ID","TP_ID","CP_ID","LIFE_STATUS","RECON_STATUS","APPROVE_STATUS","ALLOC_STATUS","PROCESSING_STATUS","TRADE_DATE","DIRECTION","CONTRACT_TYPE","NEAR_CCY_1","NEAR_QTY_1","NEAR_CCY_2","NEAR_QTY_2","NEAR_RATE","NEAR_VALUE_DATE","FAR_RATE","FAR_VALUE_DATE","FAR_QTY_1","FAR_QTY_2","PORTFOLIO_ID","TRADE_TYPE","AGREEMENT","NEAR_NDF_FIXING_DATE","ALLOCATION"'
FROM dual;
WITH a AS
(
SELECT request_id, partner_id--, tp_id, cp_id, life_status, recon_status, approve_status, alloc_status, processing_status, trade_date, direction, contract_type, near_ccy_1, near_qty_1, near_ccy_2, near_qty_2, near_rate, near_value_date, far_rate, far_value_date, far_qty_1, far_qty_2, portfolio_id, trade_type, agreement, near_ndf_fixing_date, fund_name, allocation_qty
FROM JPPRODTRM3 t
MINUS 
SELECT request_id, partner_id--, tp_id, cp_id, life_status, recon_status, approve_status, alloc_status, processing_status, trade_date, direction, contract_type, near_ccy_1, near_qty_1, near_ccy_2, near_qty_2, near_rate, near_value_date, far_rate, far_value_date, far_qty_1, far_qty_2, portfolio_id, trade_type, agreement, ndf_fixing_date, fund_name, allocation_qty
FROM JPPRODTRM4
),
b AS 
(
SELECT request_id, partner_id, tp_id, cp_id, life_status, recon_status, approve_status, alloc_status, processing_status, trade_date, direction, contract_type, near_ccy_1, near_qty_1, near_ccy_2, near_qty_2, near_rate, near_value_date, far_rate, far_value_date, far_qty_1, far_qty_2, portfolio_id, trade_type, agreement, near_ndf_fixing_date, allocation
FROM JPPRODTRM3 t
WHERE (request_id, partner_id) IN (SELECT request_id, partner_id FROM a)
)
SELECT '"' || b.request_id || '","' ||  b.partner_id || '","' ||  b.tp_id || '","' ||  b.cp_id || '","' ||  b.life_status || '","' ||  b.recon_status || '","' ||  b.approve_status || '","' ||  b.alloc_status || '","' ||  b.processing_status || '","' ||  b.trade_date || '","' ||  b.direction || '","' ||  b.contract_type || '","' ||  b.near_ccy_1 || '","' ||  b.near_qty_1 || '","' ||  b.near_ccy_2 || '","' ||  b.near_qty_2 || '","' ||  b.near_rate || '","' ||  b.near_value_date || '","' ||  b.far_rate || '","' ||  b.far_value_date || '","' ||  b.far_qty_1 || '","' ||  b.far_qty_2 || '","' ||  b.portfolio_id || '","' ||  b.trade_type || '","' ||  b.agreement || '","' ||  b.near_ndf_fixing_date || '","' ||  b.allocation|| '"'
FROM b
ORDER BY request_id;
SPOOL OFF;

SPOOL ^3
SELECT  '"REQUEST_ID","PARTNER_ID","TP_ID","CP_ID","LIFE_STATUS","RECON_STATUS","APPROVE_STATUS","ALLOC_STATUS","PROCESSING_STATUS","TRADE_DATE","DIRECTION","CONTRACT_TYPE","NEAR_CCY_1","NEAR_QTY_1","NEAR_CCY_2","NEAR_QTY_2","NEAR_RATE","NEAR_VALUE_DATE","FAR_RATE","FAR_VALUE_DATE","FAR_QTY_1","FAR_QTY_2","PORTFOLIO_ID","TRADE_TYPE","AGREEMENT","ALLOCATION"'
FROM dual;
WITH a AS
(SELECT t4.*
FROM JPPRODTRM4 t4
JOIN JPPRODTRM3 t3 ON (nvl(t3.request_id,-1) = nvl(t4.request_id,-1)
                              AND nvl(t3.tp_id,-1) = nvl(t4.tp_id,-1)
                                                                                          AND nvl(t3.cp_id,-1) = nvl(t4.cp_id,-1)
                                                                                          AND nvl(t3.life_status,-1) = nvl(t4.life_status,-1)
                                                                                          AND nvl(t3.recon_status,-1) = nvl(t4.recon_status,-1)
                                                                                          AND nvl(t3.alloc_status,-1) = nvl(t4.alloc_status,-1)
                                                                                          AND nvl(t3.processing_status,-1) = nvl(t4.processing_status,-1)
                                                                                          AND nvl(t3.trade_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss')) = nvl(t4.trade_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss'))
                                                                                          AND nvl(t3.direction,-1) = nvl(t4.direction,-1)
                                                                                          AND nvl(t3.contract_type,-1) = nvl(t4.contract_type,-1)
                                                                                          AND nvl(t3.near_ccy_1,-1) = nvl(t4.near_ccy_1,-1)
                                                                                          AND nvl(t3.near_qty_1,-1) = nvl(t4.near_qty_1,-1)
                                                                                          AND nvl(t3.near_ccy_2,-1) = nvl(t4.near_ccy_2,-1)
                                                                                          AND nvl(t3.near_qty_2,-1) = nvl(t4.near_qty_2,-1)
                                                                                          AND nvl(t3.near_rate,-1) = nvl(t4.near_rate,-1)
                                                                                          AND nvl(t3.near_value_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss') ) = nvl(t4.near_value_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss'))
                                                                                          AND nvl(t3.far_rate,-1) = nvl(t4.far_rate,-1)
                                                                                          AND nvl(t3.far_value_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss')) = nvl(t4.far_value_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss'))
                                                                                          AND nvl(t3.far_qty_1,-1) = nvl(t4.far_qty_1,-1)
                                                                                          AND nvl(t3.far_qty_2,-1) = nvl(t4.far_qty_2,-1)
                                                                                          AND nvl(t3.portfolio_id,-1) = nvl(t4.portfolio_id,-1)
                                                                                          AND nvl(t3.trade_type,-1) = nvl(t4.trade_type,-1)
                                                                                          AND nvl(t3.agreement,-1) = nvl(t4.agreement,-1)
                                                                                          AND nvl(t3.allocation,-1) = nvl(t4.allocation,-1)
                                                                                          AND nvl(t3.near_ndf_fixing_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss')) = nvl(t4.ndf_fixing_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss'))))
SELECT '"' || a.request_id || '","' ||  a.partner_id || '","' ||  a.tp_id || '","' ||  a.cp_id || '","' ||  a.life_status || '","' ||  a.recon_status || '","' ||  a.approve_status || '","' ||  a.alloc_status || '","' ||  a.processing_status || '","' ||  a.trade_date || '","' ||  a.direction || '","' ||  a.contract_type || '","' ||  a.near_ccy_1 || '","' ||  a.near_qty_1 || '","' ||  a.near_ccy_2 || '","' ||  a.near_qty_2 || '","' ||  a.near_rate || '","' ||  a.near_value_date || '","' ||  a.far_rate || '","' ||  a.far_value_date || '","' ||  a.far_qty_1 || '","' ||  a.far_qty_2 || '","' ||  a.portfolio_id || '","' ||  a.trade_type || '","' ||  a.agreement || '","' ||  a.ndf_fixing_date || '","' ||  a.allocation|| '"'
FROM a
ORDER BY request_id;
SPOOL OFF;



SPOOL ^4
SELECT  '"TRM","REQUEST_ID","PARTNER_ID","TP_ID","CP_ID","LIFE_STATUS","RECON_STATUS","APPROVE_STATUS","ALLOC_STATUS","PROCESSING_STATUS","TRADE_DATE","DIRECTION","CONTRACT_TYPE","NEAR_CCY_1","NEAR_QTY_1","NEAR_CCY_2","NEAR_QTY_2","NEAR_RATE","NEAR_VALUE_DATE","FAR_RATE","FAR_VALUE_DATE","FAR_QTY_1","FAR_QTY_2","PORTFOLIO_ID","TRADE_TYPE","AGREEMENT","NEAR_NDF_FIXING_DATE","ALLOCATION"'
FROM dual;
WITH a AS
(SELECT t4.request_id, t4.partner_id
FROM JPPRODTRM4 t4
JOIN JPPRODTRM3 t3 ON (nvl(t3.request_id,-1) = nvl(t4.request_id,-1)
                              AND nvl(t3.partner_id,-1) = nvl(t4.partner_id,-1)
                              AND (nvl(t3.tp_id,-1) <> nvl(t4.tp_id,-1)
                                                                                          OR nvl(t3.cp_id,-1) <> nvl(t4.cp_id,-1)
                                                                                          OR nvl(t3.life_status,-1) <> nvl(t4.life_status,-1)
                                                                                          OR nvl(t3.recon_status,-1) <> nvl(t4.recon_status,-1)
                                                                                          OR nvl(t3.alloc_status,-1) <> nvl(t4.alloc_status,-1)
                                                                                          OR nvl(t3.processing_status,-1) <> nvl(t4.processing_status,-1)
                                                                                          OR nvl(t3.trade_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss')) <> nvl(t4.trade_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss'))
                                                                                          OR nvl(t3.direction,-1) <> nvl(t4.direction,-1)
                                                                                          OR nvl(t3.contract_type,-1) <> nvl(t4.contract_type,-1)
                                                                                          OR nvl(t3.near_ccy_1,-1) <> nvl(t4.near_ccy_1,-1)
                                                                                          OR nvl(t3.near_qty_1,-1) <> nvl(t4.near_qty_1,-1)
                                                                                          OR nvl(t3.near_ccy_2,-1) <> nvl(t4.near_ccy_2,-1)
                                                                                          OR nvl(t3.near_qty_2,-1) <> nvl(t4.near_qty_2,-1)
                                                                                          OR nvl(t3.near_rate,-1) <> nvl(t4.near_rate,-1)
                                                                                          OR nvl(t3.near_value_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss') ) <> nvl(t4.near_value_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss'))
                                                                                          OR nvl(t3.far_rate,-1) <> nvl(t4.far_rate,-1)
                                                                                          OR nvl(t3.far_value_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss')) <> nvl(t4.far_value_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss'))
                                                                                          OR nvl(t3.far_qty_1,-1) <> nvl(t4.far_qty_1,-1)
                                                                                          OR nvl(t3.far_qty_2,-1) <> nvl(t4.far_qty_2,-1)
                                                                                          OR nvl(t3.portfolio_id,-1) <> nvl(t4.portfolio_id,-1)
                                                                                          OR nvl(t3.trade_type,-1) <> nvl(t4.trade_type,-1)
                                                                                          OR nvl(t3.agreement,-1) <> nvl(t4.agreement,-1)
                                                                                          OR nvl(t3.allocation,-1) <> nvl(t4.allocation,-1)
                                                                                          OR nvl(t3.near_ndf_fixing_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss')) <> nvl(t4.ndf_fixing_date,to_date('1/1/1970','dd/mm/yyyy hh24:mi:ss'))))),
b AS ( 
SELECT 'TRM3' TRM, request_id, partner_id, tp_id, cp_id, life_status, recon_status, approve_status, alloc_status, processing_status, trade_date, direction, contract_type, near_ccy_1, near_qty_1, near_ccy_2, near_qty_2, near_rate, near_value_date, far_rate, far_value_date, far_qty_1, far_qty_2, portfolio_id, trade_type, agreement, near_ndf_fixing_date, allocation
FROM JPPRODTRM3 t
WHERE (request_id, partner_id) IN (SELECT * FROM a)
UNION ALL 
SELECT 'TRM4' TRM, request_id, partner_id, tp_id, cp_id, life_status, recon_status, approve_status, alloc_status, processing_status, trade_date, direction, contract_type, near_ccy_1, near_qty_1, near_ccy_2, near_qty_2, near_rate, near_value_date, far_rate, far_value_date, far_qty_1, far_qty_2, portfolio_id, trade_type, agreement, ndf_fixing_date, allocation
FROM JPPRODTRM4
WHERE (request_id, partner_id) IN (SELECT * FROM a)
)                                                                                         
SELECT '"' || b.trm || '","' || b.request_id || '","' ||  b.partner_id || '","' ||  b.tp_id || '","' ||  b.cp_id || '","' ||  b.life_status || '","' ||  b.recon_status || '","' ||  b.approve_status || '","' ||  b.alloc_status || '","' ||  b.processing_status || '","' ||  b.trade_date || '","' ||  b.direction || '","' ||  b.contract_type || '","' ||  b.near_ccy_1 || '","' ||  b.near_qty_1 || '","' ||  b.near_ccy_2 || '","' ||  b.near_qty_2 || '","' ||  b.near_rate || '","' ||  b.near_value_date || '","' ||  b.far_rate || '","' ||  b.far_value_date || '","' ||  b.far_qty_1 || '","' ||  b.far_qty_2 || '","' ||  b.portfolio_id || '","' ||  b.trade_type || '","' ||  b.agreement || '","' ||  b.near_ndf_fixing_date || '","' ||  b.allocation|| '"'
FROM b
ORDER BY request_id;
SPOOL OFF;

drop table jpprodtrm3option;
drop table jpprodtrm4option;

create table jpprodtrm3option as
SELECT * 
FROM dba_apps.jpprodtrm3option@jpprod;

update jpprodtrm3option set partner_id='JPMC' where partner_id = 'Athena';
commit;

create table jpprodtrm4option as
SELECT * 
FROM jpmc_trm_pp.jpprodtrm4option@jpuat;

SET heading OFF
SET echo OFF
SET heading OFF
SET FEEDBACK OFF 
SPOOL ^5
SELECT  '"REQUEST_ID"," PARTNER_ID"," TP_ID"," CP_ID"," LIFE_STATUS"," RECON_STATUS"," APPROVE_STATUS"," ALLOC_STATUS"," PROCESSING_STATUS"," BARRIER_TYPE"," TRADE_DATE"," DIRECTION"," OPTION_TYPE"," CONTRACT_TYPE"," CCY_1"," QTY_1"," CCY_2"," QTY_2"," RATE"," STRIKE_QUOTE_MODE"," VALUE_DATE"," TRADER_ID"," EXPIRY_DATE"," PREMIUM_DATE"," PREMIUM_CCY"," PREMIUM_AMOUNT"," LOWER_BARRIER_LEVEL"," UPPER_BARRIER_LEVEL"," PAYOUT_CURRENCY"," PAYOUT_AMOUNT"," PORTFOLIO_ID"," TRADE_TYPE"," AGREEMENT"," EXPIRY_TIME"," CUT_OFF_ZONE"'
FROM dual;
WITH a AS
(
SELECT request_id, partner_id--, tp_id, cp_id, life_status, recon_status, approve_status, alloc_status, processing_status, trade_date, direction, contract_type, near_ccy_1, near_qty_1, near_ccy_2, near_qty_2, near_rate, near_value_date, far_rate, far_value_date, far_qty_1, far_qty_2, portfolio_id, trade_type, agreement, ndf_fixing_date, fund_name, allocation_qty
FROM JPPRODTRM4option
MINUS
SELECT request_id, partner_id--, tp_id, cp_id, life_status, recon_status, approve_status, alloc_status, processing_status, trade_date, direction, contract_type, near_ccy_1, near_qty_1, near_ccy_2, near_qty_2, near_rate, near_value_date, far_rate, far_value_date, far_qty_1, far_qty_2, portfolio_id, trade_type, agreement, near_ndf_fixing_date, fund_name, allocation_qty
FROM JPPRODTRM3option t
),
b AS
(
SELECT REQUEST_ID, PARTNER_ID, TP_ID, CP_ID, LIFE_STATUS, RECON_STATUS, APPROVE_STATUS, ALLOC_STATUS, PROCESSING_STATUS, BARRIER_TYPE, TRADE_DATE, DIRECTION, OPTION_TYPE, CONTRACT_TYPE, CCY_1, QTY_1, CCY_2, QTY_2, RATE, STRIKE_QUOTE_MODE, VALUE_DATE, TRADER_ID, EXPIRY_DATE, PREMIUM_DATE, PREMIUM_CCY, PREMIUM_AMOUNT, LOWER_BARRIER_LEVEL, UPPER_BARRIER_LEVEL, PAYOUT_CURRENCY, PAYOUT_AMOUNT, PORTFOLIO_ID, TRADE_TYPE, AGREEMENT, EXPIRY_TIME, CUT_OFF_ZONE
FROM JPPRODTRM4option
WHERE (request_id, partner_id) IN (SELECT request_id, partner_id FROM a)
)
SELECT '"' || REQUEST_ID || '","' || PARTNER_ID || '","' || TP_ID || '","' || CP_ID || '","' || LIFE_STATUS || '","' || RECON_STATUS || '","' || APPROVE_STATUS || '","' || ALLOC_STATUS || '","' || PROCESSING_STATUS || '","' || BARRIER_TYPE || '","' || TRADE_DATE || '","' || DIRECTION || '","' || OPTION_TYPE || '","' || CONTRACT_TYPE || '","' || CCY_1 || '","' || QTY_1 || '","' || CCY_2 || '","' || QTY_2 || '","' || RATE || '","' || STRIKE_QUOTE_MODE || '","' || VALUE_DATE || '","' || TRADER_ID || '","' || EXPIRY_DATE || '","' || PREMIUM_DATE || '","' || PREMIUM_CCY || '","' || PREMIUM_AMOUNT || '","' || LOWER_BARRIER_LEVEL || '","' || UPPER_BARRIER_LEVEL || '","' || PAYOUT_CURRENCY || '","' || PAYOUT_AMOUNT || '","' || PORTFOLIO_ID || '","' || TRADE_TYPE || '","' || AGREEMENT || '","' || EXPIRY_TIME || '","' || CUT_OFF_ZONE|| '"'
FROM b
ORDER BY request_id;
SPOOL OFF;


SPOOL ^6
SELECT  '"REQUEST_ID"," PARTNER_ID"," TP_ID"," CP_ID"," LIFE_STATUS"," RECON_STATUS"," APPROVE_STATUS"," ALLOC_STATUS"," PROCESSING_STATUS"," BARRIER_TYPE"," TRADE_DATE"," DIRECTION"," OPTION_TYPE"," CONTRACT_TYPE"," CCY_1"," QTY_1"," CCY_2"," QTY_2"," RATE"," STRIKE_QUOTE_MODE"," VALUE_DATE"," TRADER_ID"," EXPIRY_DATE"," PREMIUM_DATE"," PREMIUM_CCY"," PREMIUM_AMOUNT"," LOWER_BARRIER_LEVEL"," UPPER_BARRIER_LEVEL"," PAYOUT_CURRENCY"," PAYOUT_AMOUNT"," PORTFOLIO_ID"," TRADE_TYPE"," AGREEMENT"," EXPIRY_TIME"," CUT_OFF_ZONE"'
FROM dual;
WITH a AS
(
SELECT request_id, partner_id
FROM JPPRODTRM3option t
MINUS 
SELECT request_id, partner_id
FROM JPPRODTRM4option
),
b AS 
(
SELECT REQUEST_ID, PARTNER_ID, TP_ID, CP_ID, LIFE_STATUS, RECON_STATUS, APPROVE_STATUS, ALLOC_STATUS, PROCESSING_STATUS, BARRIER_TYPE, TRADE_DATE, DIRECTION, OPTION_TYPE, CONTRACT_TYPE, CCY_1, QTY_1, CCY_2, QTY_2, RATE, STRIKE_QUOTE_MODE, VALUE_DATE, TRADER_ID, EXPIRY_DATE, PREMIUM_DATE, PREMIUM_CCY, PREMIUM_AMOUNT, LOWER_BARRIER_LEVEL, UPPER_BARRIER_LEVEL, PAYOUT_CURRENCY, PAYOUT_AMOUNT, PORTFOLIO_ID, TRADE_TYPE, AGREEMENT, EXPIRY_TIME, CUT_OFF_ZONE
FROM JPPRODTRM3option t
WHERE (request_id, partner_id) IN (SELECT request_id, partner_id FROM a)
)
SELECT '"' || REQUEST_ID || '","' || PARTNER_ID || '","' || TP_ID || '","' || CP_ID || '","' || LIFE_STATUS || '","' || RECON_STATUS || '","' || APPROVE_STATUS || '","' || ALLOC_STATUS || '","' || PROCESSING_STATUS || '","' || BARRIER_TYPE || '","' || TRADE_DATE || '","' || DIRECTION || '","' || OPTION_TYPE || '","' || CONTRACT_TYPE || '","' || CCY_1 || '","' || QTY_1 || '","' || CCY_2 || '","' || QTY_2 || '","' || RATE || '","' || STRIKE_QUOTE_MODE || '","' || VALUE_DATE || '","' || TRADER_ID || '","' || EXPIRY_DATE || '","' || PREMIUM_DATE || '","' || PREMIUM_CCY || '","' || PREMIUM_AMOUNT || '","' || LOWER_BARRIER_LEVEL || '","' || UPPER_BARRIER_LEVEL || '","' || PAYOUT_CURRENCY || '","' || PAYOUT_AMOUNT || '","' || PORTFOLIO_ID || '","' || TRADE_TYPE || '","' || AGREEMENT || '","' || EXPIRY_TIME || '","' || CUT_OFF_ZONE|| '"'
FROM b
ORDER BY request_id;
SPOOL OFF;

SPOOL ^7
SELECT  '"REQUEST_ID"," PARTNER_ID"," TP_ID"," CP_ID"," LIFE_STATUS"," RECON_STATUS"," APPROVE_STATUS"," ALLOC_STATUS"," PROCESSING_STATUS"," BARRIER_TYPE"," TRADE_DATE"," DIRECTION"," OPTION_TYPE"," CONTRACT_TYPE"," CCY_1"," QTY_1"," CCY_2"," QTY_2"," RATE"," STRIKE_QUOTE_MODE"," VALUE_DATE"," TRADER_ID"," EXPIRY_DATE"," PREMIUM_DATE"," PREMIUM_CCY"," PREMIUM_AMOUNT"," LOWER_BARRIER_LEVEL"," UPPER_BARRIER_LEVEL"," PAYOUT_CURRENCY"," PAYOUT_AMOUNT"," PORTFOLIO_ID"," TRADE_TYPE"," AGREEMENT"," EXPIRY_TIME"," CUT_OFF_ZONE"'
FROM dual;
WITH a AS
(SELECT t4.*
FROM JPPRODTRM4option t4
JOIN JPPRODTRM3option t3 ON (NVL(t4.REQUEST_ID ,-1) = NVL(t3.REQUEST_ID ,-1) AND
NVL(t4.PARTNER_ID ,-1) = NVL(t3.PARTNER_ID ,-1) AND
NVL(t4.TP_ID ,-1) = NVL(t3.TP_ID ,-1) AND
NVL(t4.CP_ID ,-1) = NVL(t3.CP_ID ,-1) AND
NVL(t4.LIFE_STATUS ,-1) = NVL(t3.LIFE_STATUS ,-1) AND
NVL(t4.RECON_STATUS ,-1) = NVL(t3.RECON_STATUS ,-1) AND
NVL(t4.APPROVE_STATUS ,-1) = NVL(t3.APPROVE_STATUS ,-1) AND
NVL(t4.ALLOC_STATUS ,-1) = NVL(t3.ALLOC_STATUS ,-1) AND
NVL(t4.PROCESSING_STATUS ,-1) = NVL(t3.PROCESSING_STATUS ,-1) AND
NVL(t4.BARRIER_TYPE ,-1) = NVL(t3.BARRIER_TYPE ,-1) AND
NVL(t4.TRADE_DATE ,to_date('1/1/1970','dd/mm/yyyy')) = NVL(t3.TRADE_DATE ,to_date('1/1/1970','dd/mm/yyyy')) AND
NVL(t4.DIRECTION ,-1) = NVL(t3.DIRECTION ,-1) AND
NVL(t4.OPTION_TYPE ,-1) = NVL(t3.OPTION_TYPE ,-1) AND
NVL(t4.CONTRACT_TYPE ,-1) = NVL(t3.CONTRACT_TYPE ,-1) AND
NVL(t4.CCY_1 ,-1) = NVL(t3.CCY_1 ,-1) AND
NVL(t4.QTY_1 ,-1) = NVL(t3.QTY_1 ,-1) AND
NVL(t4.CCY_2 ,-1) = NVL(t3.CCY_2 ,-1) AND
NVL(t4.QTY_2 ,-1) = NVL(t3.QTY_2 ,-1) AND
NVL(t4.RATE ,-1) = NVL(t3.RATE ,-1) AND
NVL(t4.STRIKE_QUOTE_MODE ,-1) = NVL(t3.STRIKE_QUOTE_MODE ,-1) AND
NVL(t4.VALUE_DATE ,to_date('1/1/1970','dd/mm/yyyy')) = NVL(t3.VALUE_DATE ,to_date('1/1/1970','dd/mm/yyyy')) AND
NVL(t4.TRADER_ID ,-1) = NVL(t3.TRADER_ID ,-1) AND
NVL(t4.EXPIRY_DATE ,to_date('1/1/1970','dd/mm/yyyy')) = NVL(t3.EXPIRY_DATE ,to_date('1/1/1970','dd/mm/yyyy')) AND
NVL(t4.PREMIUM_DATE ,to_date('1/1/1970','dd/mm/yyyy')) = NVL(t3.PREMIUM_DATE ,to_date('1/1/1970','dd/mm/yyyy')) AND
NVL(t4.PREMIUM_CCY ,-1) = NVL(t3.PREMIUM_CCY ,-1) AND
NVL(t4.PREMIUM_AMOUNT ,-1) = NVL(t3.PREMIUM_AMOUNT ,-1) AND
NVL(t4.LOWER_BARRIER_LEVEL ,-1) = NVL(t3.LOWER_BARRIER_LEVEL ,-1) AND
NVL(t4.UPPER_BARRIER_LEVEL ,-1) = NVL(t3.UPPER_BARRIER_LEVEL ,-1) AND
NVL(t4.PAYOUT_CURRENCY ,-1) = NVL(t3.PAYOUT_CURRENCY ,-1) AND
NVL(t4.PAYOUT_AMOUNT ,-1) = NVL(t3.PAYOUT_AMOUNT ,-1) AND
NVL(t4.PORTFOLIO_ID ,-1) = NVL(t3.PORTFOLIO_ID ,-1) AND
NVL(t4.TRADE_TYPE ,-1) = NVL(t3.TRADE_TYPE ,-1) AND
NVL(t4.AGREEMENT ,-1) = NVL(t3.AGREEMENT ,-1) AND
NVL(t4.EXPIRY_TIME ,-1) = NVL(t3.EXPIRY_TIME ,-1) AND
NVL(t4.CUT_OFF_ZONE,-1) = NVL(t3.CUT_OFF_ZONE,-1)
))
SELECT '"' || REQUEST_ID || '","' || PARTNER_ID || '","' || TP_ID || '","' || CP_ID || '","' || LIFE_STATUS || '","' || RECON_STATUS || '","' || APPROVE_STATUS || '","' || ALLOC_STATUS || '","' || PROCESSING_STATUS || '","' || BARRIER_TYPE || '","' || TRADE_DATE || '","' || DIRECTION || '","' || OPTION_TYPE || '","' || CONTRACT_TYPE || '","' || CCY_1 || '","' || QTY_1 || '","' || CCY_2 || '","' || QTY_2 || '","' || RATE || '","' || STRIKE_QUOTE_MODE || '","' || VALUE_DATE || '","' || TRADER_ID || '","' || EXPIRY_DATE || '","' || PREMIUM_DATE || '","' || PREMIUM_CCY || '","' || PREMIUM_AMOUNT || '","' || LOWER_BARRIER_LEVEL || '","' || UPPER_BARRIER_LEVEL || '","' || PAYOUT_CURRENCY || '","' || PAYOUT_AMOUNT || '","' || PORTFOLIO_ID || '","' || TRADE_TYPE || '","' || AGREEMENT || '","' || EXPIRY_TIME || '","' || CUT_OFF_ZONE|| '"'
FROM a
ORDER BY request_id;
SPOOL OFF;



SPOOL ^8

SELECT  '"TRM","REQUEST_ID"," PARTNER_ID"," TP_ID"," CP_ID"," LIFE_STATUS"," RECON_STATUS"," APPROVE_STATUS"," ALLOC_STATUS"," PROCESSING_STATUS"," BARRIER_TYPE"," TRADE_DATE"," DIRECTION"," OPTION_TYPE"," CONTRACT_TYPE"," CCY_1"," QTY_1"," CCY_2"," QTY_2"," RATE"," STRIKE_QUOTE_MODE"," VALUE_DATE"," TRADER_ID"," EXPIRY_DATE"," PREMIUM_DATE"," PREMIUM_CCY"," PREMIUM_AMOUNT"," LOWER_BARRIER_LEVEL"," UPPER_BARRIER_LEVEL"," PAYOUT_CURRENCY"," PAYOUT_AMOUNT"," PORTFOLIO_ID"," TRADE_TYPE"," AGREEMENT"," EXPIRY_TIME"," CUT_OFF_ZONE","ALLOCATION"'
FROM dual;
WITH a AS
(SELECT t4.request_id, t4.partner_id
FROM JPPRODTRM4option t4
JOIN JPPRODTRM3option t3 ON (NVL(t4.REQUEST_ID ,-1) = NVL(t3.REQUEST_ID ,-1) AND
NVL(t4.PARTNER_ID ,-1) = NVL(t3.PARTNER_ID ,-1) AND
(NVL(t4.TP_ID ,-1) <> NVL(t3.TP_ID ,-1) OR
NVL(t4.CP_ID ,-1) <> NVL(t3.CP_ID ,-1) OR
NVL(t4.LIFE_STATUS ,-1) <> NVL(t3.LIFE_STATUS ,-1) OR
NVL(t4.RECON_STATUS ,-1) <> NVL(t3.RECON_STATUS ,-1) OR
NVL(t4.APPROVE_STATUS ,-1) <> NVL(t3.APPROVE_STATUS ,-1) OR
NVL(t4.ALLOC_STATUS ,-1) <> NVL(t3.ALLOC_STATUS ,-1) OR
NVL(t4.PROCESSING_STATUS ,-1) <> NVL(t3.PROCESSING_STATUS ,-1) OR
NVL(t4.BARRIER_TYPE ,-1) <> NVL(t3.BARRIER_TYPE ,-1) OR
NVL(t4.TRADE_DATE ,to_date('1/1/1970','dd/mm/yyyy')) <> NVL(t3.TRADE_DATE ,to_date('1/1/1970','dd/mm/yyyy')) OR
NVL(t4.DIRECTION ,-1) <> NVL(t3.DIRECTION ,-1) OR
NVL(t4.OPTION_TYPE ,-1) <> NVL(t3.OPTION_TYPE ,-1) OR
NVL(t4.CONTRACT_TYPE ,-1) <> NVL(t3.CONTRACT_TYPE ,-1) OR
NVL(t4.CCY_1 ,-1) <> NVL(t3.CCY_1 ,-1) OR
NVL(t4.QTY_1 ,-1) <> NVL(t3.QTY_1 ,-1) OR
NVL(t4.CCY_2 ,-1) <> NVL(t3.CCY_2 ,-1) OR
NVL(t4.QTY_2 ,-1) <> NVL(t3.QTY_2 ,-1) OR
NVL(t4.RATE ,-1) <> NVL(t3.RATE ,-1) OR
NVL(t4.STRIKE_QUOTE_MODE ,-1) <> NVL(t3.STRIKE_QUOTE_MODE ,-1) OR
NVL(t4.VALUE_DATE ,to_date('1/1/1970','dd/mm/yyyy')) <> NVL(t3.VALUE_DATE ,to_date('1/1/1970','dd/mm/yyyy')) OR
NVL(t4.TRADER_ID ,-1) <> NVL(t3.TRADER_ID ,-1) OR
NVL(t4.EXPIRY_DATE ,to_date('1/1/1970','dd/mm/yyyy')) <> NVL(t3.EXPIRY_DATE ,to_date('1/1/1970','dd/mm/yyyy')) OR
NVL(t4.PREMIUM_DATE ,to_date('1/1/1970','dd/mm/yyyy')) <> NVL(t3.PREMIUM_DATE ,to_date('1/1/1970','dd/mm/yyyy')) OR
NVL(t4.PREMIUM_CCY ,-1) <> NVL(t3.PREMIUM_CCY ,-1) OR
NVL(t4.PREMIUM_AMOUNT ,-1) <> NVL(t3.PREMIUM_AMOUNT ,-1) OR
NVL(t4.LOWER_BARRIER_LEVEL ,-1) <> NVL(t3.LOWER_BARRIER_LEVEL ,-1) OR
NVL(t4.UPPER_BARRIER_LEVEL ,-1) <> NVL(t3.UPPER_BARRIER_LEVEL ,-1) OR
NVL(t4.PAYOUT_CURRENCY ,-1) <> NVL(t3.PAYOUT_CURRENCY ,-1) OR
NVL(t4.PAYOUT_AMOUNT ,-1) <> NVL(t3.PAYOUT_AMOUNT ,-1) OR
NVL(t4.PORTFOLIO_ID ,-1) <> NVL(t3.PORTFOLIO_ID ,-1) OR
NVL(t4.TRADE_TYPE ,-1) <> NVL(t3.TRADE_TYPE ,-1) OR
NVL(t4.AGREEMENT ,-1) <> NVL(t3.AGREEMENT ,-1) OR
NVL(t4.EXPIRY_TIME ,-1) <> NVL(t3.EXPIRY_TIME ,-1) OR
NVL(t4.CUT_OFF_ZONE,-1) <> NVL(t3.CUT_OFF_ZONE,-1)))),
b AS ( 
SELECT 'TRM3' TRM, REQUEST_ID, PARTNER_ID, TP_ID, CP_ID, LIFE_STATUS, RECON_STATUS, APPROVE_STATUS, ALLOC_STATUS, PROCESSING_STATUS, BARRIER_TYPE, TRADE_DATE, DIRECTION, OPTION_TYPE, CONTRACT_TYPE, CCY_1, QTY_1, CCY_2, QTY_2, RATE, STRIKE_QUOTE_MODE, VALUE_DATE, TRADER_ID, EXPIRY_DATE, PREMIUM_DATE, PREMIUM_CCY, PREMIUM_AMOUNT, LOWER_BARRIER_LEVEL, UPPER_BARRIER_LEVEL, PAYOUT_CURRENCY, PAYOUT_AMOUNT, PORTFOLIO_ID, TRADE_TYPE, AGREEMENT, EXPIRY_TIME, CUT_OFF_ZONE, ALLOCATION
FROM JPPRODTRM3option t
WHERE (request_id, partner_id) IN (SELECT * FROM a)
UNION ALL 
SELECT 'TRM4' TRM, REQUEST_ID, PARTNER_ID, TP_ID, CP_ID, LIFE_STATUS, RECON_STATUS, APPROVE_STATUS, ALLOC_STATUS, PROCESSING_STATUS, BARRIER_TYPE, TRADE_DATE, DIRECTION, OPTION_TYPE, CONTRACT_TYPE, CCY_1, QTY_1, CCY_2, QTY_2, RATE, STRIKE_QUOTE_MODE, VALUE_DATE, TRADER_ID, EXPIRY_DATE, PREMIUM_DATE, PREMIUM_CCY, PREMIUM_AMOUNT, LOWER_BARRIER_LEVEL, UPPER_BARRIER_LEVEL, PAYOUT_CURRENCY, PAYOUT_AMOUNT, PORTFOLIO_ID, TRADE_TYPE, AGREEMENT, EXPIRY_TIME, CUT_OFF_ZONE, ALLOCATION
FROM JPPRODTRM4option
WHERE (request_id, partner_id) IN (SELECT * FROM a)
)                                                                                         
SELECT '"' || b.trm || '","' || REQUEST_ID || '","' || PARTNER_ID || '","' || TP_ID || '","' || CP_ID || '","' || LIFE_STATUS || '","' || RECON_STATUS || '","' || APPROVE_STATUS || '","' || ALLOC_STATUS || '","' || PROCESSING_STATUS || '","' || BARRIER_TYPE || '","' || TRADE_DATE || '","' || DIRECTION || '","' || OPTION_TYPE || '","' || CONTRACT_TYPE || '","' || CCY_1 || '","' || QTY_1 || '","' || CCY_2 || '","' || QTY_2 || '","' || RATE || '","' || STRIKE_QUOTE_MODE || '","' || VALUE_DATE || '","' || TRADER_ID || '","' || EXPIRY_DATE || '","' ||PREMIUM_DATE || '","' || PREMIUM_CCY || '","' || PREMIUM_AMOUNT || '","' || LOWER_BARRIER_LEVEL || '","' || UPPER_BARRIER_LEVEL || '","' || PAYOUT_CURRENCY || '","' || PAYOUT_AMOUNT || '","' || PORTFOLIO_ID || '","' || TRADE_TYPE || '","' || AGREEMENT || '","' || EXPIRY_TIME || '","' || CUT_OFF_ZONE||'","' || ALLOCATION || '"'
FROM b
ORDER BY request_id;
SPOOL OFF;


-- Refresh tables
DROP TABLE jpprodtrm3ui;
DROP TABLE jpprodtrm4ui;

CREATE TABLE jpprodtrm3ui AS
SELECT t.*
FROM dba_apps.jpprodtrm3ui@jpprod t  ;

CREATE TABLE jpprodtrm4ui AS
SELECT t.*
FROM jpmc_trm_pp.jpprodtrm4ui@jpuat t  ;


SPOOL ^9
SELECT  '"REQUEST_ID","PARTNER_ID","TP_ID","CP_ID","LIFE_STATUS","RECON_STATUS","APPROVE_STATUS","ALLOC_STATUS","PROCESSING_STATUS","TRADE_DATE","DIRECTION","CONTRACT_TYPE","NEAR_CCY_1","NEAR_QTY_1","NEAR_CCY_2","NEAR_QTY_2","NEAR_RATE","NEAR_VALUE_DATE","FAR_RATE","FAR_VALUE_DATE","FAR_QTY_1","FAR_QTY_2","PORTFOLIO_ID","TRADE_TYPE","AGREEMENT","NEAR_NDF_FIXING_DATE","FUND_NAME","ALLOCATION_QTY"'
FROM dual;

SELECT '"' || b.request_id || '","' ||  b.partner_id || '","' ||  b.tp_id || '","' ||  b.cp_id || '","' ||  b.life_status || '","' ||  b.recon_status || '","' ||  b.approve_status || '","' ||  b.alloc_status || '","' ||  b.processing_status || '","' ||  b.trade_date || '","' ||  b.direction || '","' ||  b.contract_type || '","' ||  b.near_ccy_1 || '","' ||  b.near_qty_1 || '","' ||  b.near_ccy_2 || '","' ||  b.near_qty_2 || '","' ||  b.near_rate || '","' ||  b.near_value_date || '","' ||  b.far_rate || '","' ||  b.far_value_date || '","' ||  b.far_qty_1 || '","' ||  b.far_qty_2 || '","' ||  b.portfolio_id || '","' ||  b.trade_type || '","' ||  b.agreement || '","' ||  b.near_ndf_fixing_date || '","' || b.allocation|| '"'
FROM jpprodtrm3ui b
ORDER BY request_id;
SPOOL OFF;

SPOOL ^10
SELECT  '"REQUEST_ID","PARTNER_ID","TP_ID","CP_ID","LIFE_STATUS","RECON_STATUS","APPROVE_STATUS","ALLOC_STATUS","PROCESSING_STATUS","TRADE_DATE","DIRECTION","CONTRACT_TYPE","NEAR_CCY_1","NEAR_QTY_1","NEAR_CCY_2","NEAR_QTY_2","NEAR_RATE","NEAR_VALUE_DATE","FAR_RATE","FAR_VALUE_DATE","FAR_QTY_1","FAR_QTY_2","PORTFOLIO_ID","TRADE_TYPE","AGREEMENT","NEAR_NDF_FIXING_DATE","FUND_NAME","ALLOCATION_QTY"'
FROM dual;

SELECT '"' || b.request_id || '","' ||  b.partner_id || '","' ||  b.tp_id || '","' ||  b.cp_id || '","' ||  b.life_status || '","' ||  b.recon_status || '","' ||  b.approve_status || '","' ||  b.alloc_status || '","' ||  b.processing_status || '","' ||  b.trade_date || '","' ||  b.direction || '","' ||  b.contract_type || '","' ||  b.near_ccy_1 || '","' ||  b.near_qty_1 || '","' ||  b.near_ccy_2 || '","' ||  b.near_qty_2 || '","' ||  b.near_rate || '","' ||  b.near_value_date || '","' ||  b.far_rate || '","' ||  b.far_value_date || '","' ||  b.far_qty_1 || '","' ||  b.far_qty_2 || '","' ||  b.portfolio_id || '","' ||  b.trade_type || '","' ||  b.agreement || '","' ||  b.ndf_fixing_date || '","' || b.allocation|| '"'
FROM jpprodtrm4ui b
ORDER BY request_id;
SPOOL OFF;
-- Refresh tables
DROP TABLE jpprodtrm3optionui;
DROP TABLE jpprodtrm4optionui;

CREATE TABLE jpprodtrm3optionui AS
SELECT t.*
FROM dba_apps.jpprodtrm3optionui@jpprod t  ;

CREATE TABLE jpprodtrm4optionui AS
SELECT t.*
FROM jpmc_trm_pp.jpprodtrm4optionui@jpuat t  ;

SPOOL ^11
SELECT  '"REQUEST_ID"," PARTNER_ID"," TP_ID"," CP_ID"," LIFE_STATUS"," RECON_STATUS"," APPROVE_STATUS"," ALLOC_STATUS"," PROCESSING_STATUS"," BARRIER_TYPE"," TRADE_DATE"," DIRECTION"," OPTION_TYPE"," CONTRACT_TYPE"," CCY_1"," QTY_1"," CCY_2"," QTY_2"," RATE"," STRIKE_QUOTE_MODE"," VALUE_DATE"," TRADER_ID"," EXPIRY_DATE"," PREMIUM_DATE"," PREMIUM_CCY"," PREMIUM_AMOUNT"," LOWER_BARRIER_LEVEL"," UPPER_BARRIER_LEVEL"," PAYOUT_CURRENCY"," PAYOUT_AMOUNT"," PORTFOLIO_ID"," TRADE_TYPE"," AGREEMENT"," EXPIRY_TIME"," CUT_OFF_ZONE"'
FROM dual;

SELECT '"' || REQUEST_ID || '","' || PARTNER_ID || '","' || TP_ID || '","' || CP_ID || '","' || LIFE_STATUS || '","' || RECON_STATUS || '","' || APPROVE_STATUS || '","' || ALLOC_STATUS || '","' || PROCESSING_STATUS || '","' || BARRIER_TYPE || '","' || TRADE_DATE || '","' || DIRECTION || '","' || OPTION_TYPE || '","' || CONTRACT_TYPE || '","' || CCY_1 || '","' || QTY_1 || '","' || CCY_2 || '","' || QTY_2 || '","' || RATE || '","' || STRIKE_QUOTE_MODE || '","' || VALUE_DATE || '","' || TRADER_ID || '","' || EXPIRY_DATE || '","' || PREMIUM_DATE || '","' || PREMIUM_CCY || '","' || PREMIUM_AMOUNT || '","' || LOWER_BARRIER_LEVEL || '","' || UPPER_BARRIER_LEVEL || '","' || PAYOUT_CURRENCY || '","' || PAYOUT_AMOUNT || '","' || PORTFOLIO_ID || '","' || TRADE_TYPE || '","' || AGREEMENT || '","' || EXPIRY_TIME || '","' || CUT_OFF_ZONE|| '"'
FROM jpprodtrm4optionui b
ORDER BY request_id;
SPOOL OFF;

SPOOL ^12
SELECT  '"REQUEST_ID"," PARTNER_ID"," TP_ID"," CP_ID"," LIFE_STATUS"," RECON_STATUS"," APPROVE_STATUS"," ALLOC_STATUS"," PROCESSING_STATUS"," BARRIER_TYPE"," TRADE_DATE"," DIRECTION"," OPTION_TYPE"," CONTRACT_TYPE"," CCY_1"," QTY_1"," CCY_2"," QTY_2"," RATE"," STRIKE_QUOTE_MODE"," VALUE_DATE"," TRADER_ID"," EXPIRY_DATE"," PREMIUM_DATE"," PREMIUM_CCY"," PREMIUM_AMOUNT"," LOWER_BARRIER_LEVEL"," UPPER_BARRIER_LEVEL"," PAYOUT_CURRENCY"," PAYOUT_AMOUNT"," PORTFOLIO_ID"," TRADE_TYPE"," AGREEMENT"," EXPIRY_TIME"," CUT_OFF_ZONE"'
FROM dual;

SELECT '"' || REQUEST_ID || '","' || PARTNER_ID || '","' || TP_ID || '","' || CP_ID || '","' || LIFE_STATUS || '","' || RECON_STATUS || '","' || APPROVE_STATUS || '","' || ALLOC_STATUS || '","' || PROCESSING_STATUS || '","' || BARRIER_TYPE || '","' || TRADE_DATE || '","' || DIRECTION || '","' || OPTION_TYPE || '","' || CONTRACT_TYPE || '","' || CCY_1 || '","' || QTY_1 || '","' || CCY_2 || '","' || QTY_2 || '","' || RATE || '","' || STRIKE_QUOTE_MODE || '","' || VALUE_DATE || '","' || TRADER_ID || '","' || EXPIRY_DATE || '","' || PREMIUM_DATE || '","' || PREMIUM_CCY || '","' || PREMIUM_AMOUNT || '","' || LOWER_BARRIER_LEVEL || '","' || UPPER_BARRIER_LEVEL || '","' || PAYOUT_CURRENCY || '","' || PAYOUT_AMOUNT || '","' || PORTFOLIO_ID || '","' || TRADE_TYPE || '","' || AGREEMENT || '","' || EXPIRY_TIME || '","' || CUT_OFF_ZONE|| '"'
FROM jpprodtrm3optionui b
ORDER BY request_id;
SPOOL OFF;


exit;
