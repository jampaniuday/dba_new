WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR  EXIT SQL.SQLCODE
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET TIMING OFF
SET ECHO OFF
set pagesize 0
set linesize 10000
SET TRIMSPOOL on
SET DEFINE "^"
DEFINE delimiter=,
DEFINE quoteDelimiter='"'
DEFINE dateFormat="yyyymmdd"

spool ^1
SELECT
        'CREATION_DATE'          ||'^delimiter'||
        'ID'         ||'^delimiter'||
        'TXN_ID'        ||'^delimiter'||
        'TRADE_TYPE'        ||'^delimiter'||
        'REJECT_REASON'      ||'^delimiter'||
        'TP_NAME'        ||'^delimiter'||
        'CP_NAME'
FROM DUAL
UNION ALL
SELECT TA.CREATION_DATE
       ||'^delimiter'||TA.ID
       ||'^delimiter'||TA.TXN_ID
       ||'^delimiter'||DECODE(TA.TRADE_TYPE,
              1,
              'Regular',
              2,
              'Position',
              'Other')
       ||'^delimiter'||DECODE(LIFE_STATUS_REASON_ID,
              25001, 'Duplicate failure - ID of the received trade already found in the system',
              25002, 'OFAC Failure. For EB users the text is: Regulatory Filter!',
              25003, 'Trade failed validation check - Trade Date is greater than Today + 1',
              25005, 'Trade failed validation check - Underlying Ticket Num is not defined - Used for amendments. Not relevant in phase 1',
              25006, 'Trade failed validation check - Entering party is not the Trading Party',
              25007, 'Trade failed validation check - Status of one of the parties on the deal is "Disabled"',
              25008, 'Trade failed validation check - CCY Pair is not defined',
              25010, 'Trade failed validation check - Base currency''s Notional Amount exceeds the maximum amount',
              25011, 'Trade failed validation check - Parties do not have an Aggregation Group defined',
              25012, 'Trade failed validation check - Currency pair [ZAR-UAH] not supported for aggregation',
              25013, 'Trade failed validation check - Not a Spot trade',
              25014, 'Trade failed cut off criteria',
              25015, 'Unmatched trade for period longer than pre-defined time out',
              25016, 'Rescinding attempt for a trade in final status',
              25017, 'Underlying trade could not be found',
              0,     'N/A',
              'Other')
       ||'^delimiter'||cas_prod.HELPER_PKG.GETORGANIZATIONNAME(TP_ID)
       ||'^delimiter'||cas_prod.HELPER_PKG.GETORGANIZATIONNAME(CP_ID)
FROM   cas_prod.FD_FXPB_LINEAR_TA TA
WHERE  TA.CREATION_DATE > DECODE(TO_NUMBER(TO_CHAR(SYSDATE,'d')),2,NEXT_DAY(TRUNC(SYSDATE),'THU') - 6 - 2 / 24,TRUNC(SYSDATE - 1) - 2 / 24)
       AND TA.CREATION_DATE <= TRUNC(SYSDATE) - 2 / 24
       AND TA.TRADE_TYPE IN (1,2)
       AND TA.NOE_LIFE_STATUS=3;
spool off
exit
