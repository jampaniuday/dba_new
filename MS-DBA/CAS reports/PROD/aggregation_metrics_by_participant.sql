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
        'total'          ||'^delimiter'||
        'less30'          ||'^delimiter'||
        'val30_60'         ||'^delimiter'||
        'more60'        ||'^delimiter'||
        'avg1'       ||'^delimiter'||
        'Median1'
FROM DUAL
UNION ALL
SELECT count(*)
        ||'^delimiter'||sum(case when execution_time<=30 then 1 else 0 end)
        ||'^delimiter'||sum(case when execution_time>30 and execution_time<=60 then 1 else 0 end)
        ||'^delimiter'||sum(case when execution_time>60 then 1 else 0 end)
        ||'^delimiter'||avg(execution_time)
        ||'^delimiter'||median(execution_time)
FROM
(
select TA.ID,((cast(QOUT.COMPLETION_TIME as date) - Aggs.execution_time)*86400) execution_time
from cas_prod.fsd_netting_executions Aggs
LEFT JOIN cas_prod.fsd_netting_fx_results Aggs_R ON (Aggs.net_execution_id = Aggs_R.net_id)
LEFT JOIN cas_prod.FD_LINEAR_LEG_DATA LEG ON (Aggs_R.id = LEG.netting_service_ref)
LEFT JOIN cas_prod.FD_FXPB_LINEAR_TA TA ON (LEG.PARENT_ID = TA.ID)
LEFT JOIN cas_prod.MSG_QUEUE_OUT QOUT ON (to_char(TA.id) = QOUT.msg_ref)
where
(TA.TRADE_TYPE = 11 AND
       LEG.NETTING_SERVICE_REF IN
       (SELECT LEG1.NETTING_SERVICE_REF
          FROM   cas_prod.FD_FXPB_LINEAR_TA TA1, cas_prod.FD_LINEAR_LEG_DATA LEG1
          WHERE  TA1.TRADE_TYPE = 1
          AND    TA1.NOE_LIFE_STATUS = 4
          AND    TA1.CREATION_DATE >= DECODE(TO_NUMBER(TO_CHAR(SYSDATE,'d')),2,NEXT_DAY(TRUNC(SYSDATE),'THU') - 6 - 2 / 24,TRUNC(SYSDATE - 1) - 2 / 24)
          AND    TA1.CREATION_DATE < TRUNC(SYSDATE) - 2 / 24
          AND    TA1.ID = LEG1.PARENT_ID))
and QOUT.event_id=1500000);
spool off
exit
