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
WITH msg_data AS
(
select to_char(Q_IN.CAPTURE_TIME,'MM/DD/YYYY HH24:mi') Time, TA.TP_ID Trading_Party, count(*) msg_q_in,0 tas
    from cas_uat.FD_FXPB_LINEAR_TA TA 
    JOIN cas_uat.MSG_QUEUE_IN Q_IN ON (Q_IN.TXN_ID=TA.TXN_ID)
    where Q_IN.CAPTURE_TIME >=DECODE(to_number(to_char(sysdate,'d')),2,NEXT_DAY(trunc(SYSDATE), 'THU')-6-2/24,trunc(sysdate-1)-2/24)
     and Q_IN.CAPTURE_TIME < trunc(sysdate)-2/24
     and TA.TRADE_TYPE in (1,2)
     group by to_char(CAPTURE_TIME,'MM/DD/YYYY HH24:mi'), TA.TP_ID 
    union
    select to_char(trunc(CREATION_DATE, 'MI'),'MM/DD/YYYY HH24:mi') Time, TP_ID Trading_Party,0 msg_q_in , count(*) tas
    from cas_uat.FD_FXPB_LINEAR_TA 
    where CREATION_DATE >= trunc(sysdate-1)-2/24
     and CREATION_DATE < trunc(sysdate)-2/24
     and TRADE_TYPE IN (1,2)
    group by trunc(CREATION_DATE, 'MI'), TP_ID
)
SELECT
        'Time'          ||'^delimiter'||
        'Trading_Party'         	||'^delimiter'||
        'Sides_Received'        ||'^delimiter'||
        'Sides_Processed'      ||'^delimiter'||
        'Delta'
FROM DUAL
UNION ALL
select * from (
select msg_data.Time
	||'^delimiter'||org.name
	||'^delimiter'||sum(msg_data.msg_q_in)
	||'^delimiter'||sum(msg_data.tas)
	||'^delimiter'||(sum(msg_data.msg_q_in)-sum(msg_data.tas))
FROM cas_uat.a_organization org
JOIN msg_data ON (msg_data.Trading_Party=org.id) 
group by Time, org.name
order by Time);
spool off
exit
