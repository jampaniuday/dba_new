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
        'Time'          ||'^delimiter'||
        'Trading_Party'          ||'^delimiter'||
        'Maximum_IN_TO_IC'         ||'^delimiter'||
        'Average_IN_TO_IC'        ||'^delimiter'||
        'Median_IN_TO_IC'	||'^delimiter'||
        'Maximum_IC_TO_OUT'         ||'^delimiter'||
        'Average_IC_TO_OUT'        ||'^delimiter'||
        'Median_IC_TO_OUT'
FROM DUAL
UNION ALL
select * from (
SELECT to_char(Q_IN.CAPTURE_TIME,'MM/DD/YYYY HH24:mi')
        ||'^delimiter'||ORG.NAME
        ||'^delimiter'||MAX(EXTRACT (SECOND FROM (Q_IN.CAPTURE_TIME - Q_IN.CREATION_TIME)))
        ||'^delimiter'||AVG(EXTRACT (SECOND FROM (Q_IN.CAPTURE_TIME - Q_IN.CREATION_TIME)))
        ||'^delimiter'||Median(EXTRACT (SECOND FROM (Q_IN.CAPTURE_TIME - Q_IN.CREATION_TIME)))
        ||'^delimiter'||MAX(EXTRACT (SECOND FROM (Q_OUT.COMPLETION_TIME - Q_IN.CAPTURE_TIME)))
        ||'^delimiter'||AVG(EXTRACT (SECOND FROM (Q_OUT.COMPLETION_TIME - Q_IN.CAPTURE_TIME)))
        ||'^delimiter'||Median(EXTRACT (SECOND FROM (Q_OUT.COMPLETION_TIME - Q_IN.CAPTURE_TIME)))
FROM cas_prod.MSG_QUEUE_IN Q_IN
JOIN cas_prod.MSG_QUEUE_OUT Q_OUT ON (Q_IN.TXN_ID=Q_OUT.TXN_ID)
JOIN cas_prod.FD_FXPB_LINEAR_TA TA ON (Q_IN.TXN_ID=TA.TXN_ID)
JOIN cas_prod.A_ORGANIZATION ORG ON (TA.TP_ID=ORG.ID)
where Q_IN.CAPTURE_TIME >= DECODE(to_number(to_char(sysdate,'d')),2,NEXT_DAY(trunc(SYSDATE), 'THU')-6-2/24,trunc(sysdate-1)-2/24)
AND Q_IN.CAPTURE_TIME < trunc(sysdate)-2/24
AND TA.TRADE_TYPE in (1,2)
AND Q_OUT.EVENT_ID IN (1200020,1200021)
GROUP BY to_char(Q_IN.CAPTURE_TIME,'MM/DD/YYYY HH24:mi'), ORG.NAME
ORDER BY to_char(Q_IN.CAPTURE_TIME,'MM/DD/YYYY HH24:mi'));
spool off
exit
