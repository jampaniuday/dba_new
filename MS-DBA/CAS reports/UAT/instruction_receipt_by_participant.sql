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
WITH ldata AS (
SELECT ADDR.OWNER_ID, EXTRACT(SECOND FROM(QOUT.COMPLETION_TIME - QIN.CAPTURE_TIME)) LATENCY
FROM   cas_uat.MSG_QUEUE_OUT QOUT
JOIN   cas_uat.MSG_QUEUE_IN QIN ON (QOUT.TXN_ID = QIN.TXN_ID)
JOIN   cas_uat.SD_ADDRESS ADDR ON (ADDR.ID = QIN.ADDRESS_ID)
WHERE  QOUT.CREATION_TIME >= DECODE(TO_NUMBER(TO_CHAR(SYSDATE,'d')),2,NEXT_DAY(TRUNC(SYSDATE),'THU') - 6 - 2 / 24,TRUNC(SYSDATE - 1) - 2 / 24)
AND    QOUT.CREATION_TIME < TRUNC(SYSDATE) - 2 / 24
AND    QOUT.TXN_ID IS NOT NULL
AND    QOUT.EVENT_ID IN (1200020,
                         1200021) -- No index for the main filter!!! Index on QOUT.EVENT_ID
)
SELECT
        'Trading_Party'          ||'^delimiter'||
        'total'         ||'^delimiter'||
        'less30'        ||'^delimiter'||
        'val30_60'      ||'^delimiter'||
        'more60'        ||'^delimiter'||
        'Average'       ||'^delimiter'||
        'Median'
FROM DUAL
UNION ALL
select
    org.name
    ||'^delimiter'||count(*)
    ||'^delimiter'||sum(case when ldata.latency<30 then 1 else 0 end)
    ||'^delimiter'||sum(case when ldata.latency>=30 and ldata.latency<=60 then 1 else 0 end)
    ||'^delimiter'||sum(case when ldata.latency>60 then 1 else 0 end)
    ||'^delimiter'||avg(ldata.latency)
    ||'^delimiter'||median(ldata.latency)
FROM  ldata
JOIN  cas_uat.a_organization org ON (ldata.owner_id=org.id)
group by org.name;
spool off
exit
