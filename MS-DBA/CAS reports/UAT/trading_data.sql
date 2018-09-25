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
        'TRADE_TYPE'      ||'^delimiter'||
        'TRADE_STATUS'        ||'^delimiter'||
        'REJECT_REASON'       ||'^delimiter'||
        'DIRECTION'       ||'^delimiter'||
	'TP_NAME'       ||'^delimiter'||
	'CCY1'       ||'^delimiter'||
	'QTY_1'       ||'^delimiter'||
	'CP_NAME'       ||'^delimiter'||
	'CCY2'       ||'^delimiter'||
	'QTY_2'       ||'^delimiter'||
	'TRADE_DATE'       ||'^delimiter'||
	'VALUE_DATE'       ||'^delimiter'||
	'RATE'       ||'^delimiter'||
	'REQUEST_ID'       ||'^delimiter'||
	'RECON_STATUS'       ||'^delimiter'||
        'NETTING_STATUS'       ||'^delimiter'||
        'NETTING_GROUP_ID'       ||'^delimiter'||
        'NETTING_SERVICE_REF'
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
              11,
              'Aggregated',
              10,
              'Offset',
              'Other')
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
       ||'^delimiter'||DECODE(LIFE_STATUS_REASON_ID,
              25015,
              'Unmatched trade for period longer than pre-defined time out',
              25014,
              'Trade failed cut off criteria',
              25001,
              'Duplicate failure - ID of the received trade already found in the system',
              25013,
              'Trade failed validation check - Not a Spot trade',
              0,
              'N/A',
              'Other')
       ||'^delimiter'||DECODE(DIRECTION,
              1,
              'BUY',
              2,
              'SELL',
              'OTHER')
       ||'^delimiter'||cas_uat.HELPER_PKG.GETORGANIZATIONNAME(TP_ID)
       ||'^delimiter'||cas_uat.HELPER_PKG.GETMAPPEDCCYNAME(CCY_1)
       ||'^delimiter'||QTY_1
       ||'^delimiter'||cas_uat.HELPER_PKG.GETORGANIZATIONNAME(CP_ID)
       ||'^delimiter'||cas_uat.HELPER_PKG.GETMAPPEDCCYNAME(CCY_2)
       ||'^delimiter'||QTY_2
       ||'^delimiter'||TRADE_DATE
       ||'^delimiter'||VALUE_DATE
       ||'^delimiter'||TRIM(TO_CHAR(RATE,
                    '9999999990.99999999'))
       ||'^delimiter'||REQUEST_ID
       ||'^delimiter'||RECON_STATUS
       ||'^delimiter'||NETTING_STATUS
       ||'^delimiter'||NETTING_GROUP_ID
       ||'^delimiter'||NETTING_SERVICE_REF
FROM   cas_uat.FD_FXPB_LINEAR_TA TA
JOIN   cas_uat.FD_LINEAR_LEG_DATA LEG ON (TA.ID = LEG.PARENT_ID)
WHERE  ((TA.CREATION_DATE > DECODE(TO_NUMBER(TO_CHAR(SYSDATE,'d')),2,NEXT_DAY(TRUNC(SYSDATE),'THU') - 6 - 2 / 24,TRUNC(SYSDATE - 1) - 2 / 24) AND
       TA.CREATION_DATE <= TRUNC(SYSDATE) - 2 / 24 AND
       TA.TRADE_TYPE IN (1,2)) OR
       (TA.TRADE_TYPE IN (11,10) AND
       LEG.NETTING_SERVICE_REF IN
       (SELECT LEG1.NETTING_SERVICE_REF
          FROM   cas_uat.FD_FXPB_LINEAR_TA TA1, cas_uat.FD_LINEAR_LEG_DATA LEG1
          WHERE  TA1.TRADE_TYPE = 1
          AND    TA1.NOE_LIFE_STATUS = 4
          AND    TA1.CREATION_DATE > DECODE(TO_NUMBER(TO_CHAR(SYSDATE,'d')),2,NEXT_DAY(TRUNC(SYSDATE),'THU') - 6 - 2 / 24,TRUNC(SYSDATE - 1) - 2 / 24)
          AND    TA1.CREATION_DATE <= TRUNC(SYSDATE) - 2 / 24
          AND    TA1.ID = LEG1.PARENT_ID)));
spool off
exit
