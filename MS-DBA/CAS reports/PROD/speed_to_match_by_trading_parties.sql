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
        'Creation_Time'          ||'^delimiter'||
        'FIRST_TP'          ||'^delimiter'||
        'LAST_TP'         ||'^delimiter'||
        'COUNT_STM'        ||'^delimiter'||
        'MAX_STM'       ||'^delimiter'||
        'Average_STM'   ||'^delimiter'||
        'Median_STM'
FROM DUAL
UNION ALL
SELECT to_char(TA.CREATION_DATE,'DD/MM/YYYY HH24')
        ||'^delimiter'||ORG1.NAME
        ||'^delimiter'||ORG2.NAME
        ||'^delimiter'||COUNT(TA.ID)
        ||'^delimiter'||MAX((TA.RECONCILIATION_TIME - TA.CREATION_DATE)*86400)
        ||'^delimiter'||AVG((TA.RECONCILIATION_TIME - TA.CREATION_DATE)*86400)
        ||'^delimiter'||Median((TA.RECONCILIATION_TIME - TA.CREATION_DATE)*86400)
FROM cas_prod.FD_FXPB_LINEAR_TA TA
JOIN cas_prod.A_ORGANIZATION ORG1 ON (TA.TP_ID=ORG1.ID)
JOIN cas_prod.A_ORGANIZATION ORG2 ON (TA.CP_ID=ORG2.ID)
WHERE (TA.CREATION_DATE >= DECODE(TO_NUMBER(TO_CHAR(SYSDATE,'d')),2,NEXT_DAY(TRUNC(SYSDATE),'THU') - 6 - 2 / 24,TRUNC(SYSDATE - 1) - 2 / 24) AND
       TA.CREATION_DATE < TRUNC(SYSDATE) - 2 / 24 AND
       TA.TRADE_TYPE IN (1,2))
       AND TA.NOE_LIFE_STATUS = 4
       AND (TA.RECONCILIATION_TIME - TA.CREATION_DATE)>=0
GROUP BY
         to_char(TA.CREATION_DATE,'DD/MM/YYYY HH24')
        ,ORG1.NAME
        ,ORG2.NAME;
spool off
exit
