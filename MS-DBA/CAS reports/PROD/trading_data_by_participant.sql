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
        'TP_NAME'         ||'^delimiter'||
        'CP_NAME'        ||'^delimiter'||
        'NAME'      ||'^delimiter'||
        'TRADE_TYPE'        ||'^delimiter'||
        'AGGREGATION_STATUS'    ||'^delimiter'||
        'TRADE_STATUS'        ||'^delimiter'||
        'MATCHING_STATUS'        ||'^delimiter'||
        'REJECT_REASON'        ||'^delimiter'||
	'CCY_PAIR'	||'^delimiter'||
        'Trades'
FROM DUAL
UNION ALL
SELECT
       to_char(TA.CREATION_DATE,'DD/MM/YYYY')
      ||'^delimiter'||cas_prod.HELPER_PKG.GETORGANIZATIONNAME(TP_ID)
      ||'^delimiter'||cas_prod.HELPER_PKG.GETORGANIZATIONNAME(CP_ID)
      ||'^delimiter'||AGGR.NAME
      ||'^delimiter'||DECODE(TA.TRADE_TYPE,
              1,
              'Regular',
              2,
              'Position',
              11,
              'Aggregated',
              10,
              'Offset',
              'Other')
      ||'^delimiter'||DECODE(LEG.NETTING_STATUS,3,'Sent', 4, 'N/A', 6, 'Aggregated', 'Other')
      ||'^delimiter'||DECODE(TA.NOE_LIFE_STATUS,
              2,
              'Active',
              3,
              'Rejected',
              4,
              'Done',
              6,
              'Replaced',
              7,
              'Deleted',
              'Other')
       ||'^delimiter'||DECODE(TA.RECON_STATUS,1, 'Matched',2, 'Unmatched',5,'N/A','Other')
       ||'^delimiter'||DECODE(TA.LIFE_STATUS_REASON_ID,
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
	||'^delimiter'||(CCYS1.NAME||CCYS2.NAME)
       ||'^delimiter'||COUNT(TA.TP_ID)
FROM   cas_prod.FD_FXPB_LINEAR_TA TA
LEFT JOIN   cas_prod.FD_LINEAR_LEG_DATA LEG ON (TA.ID = LEG.PARENT_ID)
LEFT JOIN   cas_prod.SD_NETTING_GROUPS AGGR ON (LEG.NETTING_GROUP_ID = AGGR.ID)
LEFT JOIN   cas_prod.MD_INSTRUMENT_CCY_DATA CCYS1 ON (LEG.CCY_1 = CCYS1.ID) 
LEFT JOIN   cas_prod.MD_INSTRUMENT_CCY_DATA CCYS2 ON (LEG.CCY_2 = CCYS2.ID)
WHERE  ((TA.CREATION_DATE > DECODE(TO_NUMBER(TO_CHAR(SYSDATE,'d')),2,NEXT_DAY(TRUNC(SYSDATE),'THU') - 6 - 2 / 24,TRUNC(SYSDATE - 1) - 2 / 24) AND
       TA.CREATION_DATE <= TRUNC(SYSDATE) - 2 / 24 AND
       TA.TRADE_TYPE IN (1,2)) OR
       (TA.TRADE_TYPE IN (11,10) AND
       LEG.NETTING_SERVICE_REF IN
       (SELECT LEG1.NETTING_SERVICE_REF
          FROM   cas_prod.FD_FXPB_LINEAR_TA TA1, cas_prod.FD_LINEAR_LEG_DATA LEG1
          WHERE  TA1.TRADE_TYPE = 1
          AND    TA1.NOE_LIFE_STATUS = 4
          AND    TA1.CREATION_DATE > DECODE(TO_NUMBER(TO_CHAR(SYSDATE,'d')),2,NEXT_DAY(TRUNC(SYSDATE),'THU') - 6 - 2 / 24,TRUNC(SYSDATE - 1) - 2 / 24)
          AND    TA1.CREATION_DATE <= TRUNC(SYSDATE) - 2 / 24
          AND    TA1.ID = LEG1.PARENT_ID)))
GROUP BY
to_char(TA.CREATION_DATE,'DD/MM/YYYY')
      ,TA.TP_ID
      ,TA.CP_ID
      ,AGGR.NAME
      ,TA.TRADE_TYPE
      ,LEG.NETTING_STATUS
      ,TA.NOE_LIFE_STATUS
      ,TA.RECON_STATUS
      ,TA.LIFE_STATUS_REASON_ID
      ,(CCYS1.NAME || CCYS2.NAME);
spool off
exit

