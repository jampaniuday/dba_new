drop table table1;
create table table1 as
SELECT   'H3' env, noes.trade_date, 'BLOCK' trade_type,
         DECODE (noes.entered_org_type,
                 2, 'CLIENT',
                 3, 'BANK',
                 4, 'PB',
                 5, 'ECN',
                 9, 'FUND',
                 'ERROR'
                ) entering_party,
         COUNT (*) hr3_tickets
    FROM v_hr_fx_noe_report@hr_link noes
   WHERE noes.lifecycle_status NOT IN (
            SELECT code_key
              FROM a_code_member@hr_link
             WHERE GROUP_ID = '3000001'
               AND DATA IN
                          ('Invalid', 'Error', 'Request_Replace', 'Replaced'))
     AND noes.trade_date =
                   TO_DATE (TO_CHAR (SYSDATE - 1, 'MM/DD/YYYY'), 'mm/dd/yyyy')
     AND noes.trading_party NOT IN (
            SELECT ID
              FROM a_organization@hr_link
             WHERE NAME IN
                        ('Traiana EB', 'Traiana Client', 'Traiana PB', 'N/A'))
     AND noes.counter_party NOT IN (
            SELECT ID
              FROM a_organization@hr_link
             WHERE NAME IN
                        ('Traiana EB', 'Traiana Client', 'Traiana PB', 'N/A'))
     AND noes.prime_broker NOT IN (
            SELECT ID
              FROM a_organization@hr_link
             WHERE NAME IN
                        ('Traiana EB', 'Traiana Client', 'Traiana PB', 'N/A'))
GROUP BY 'H3', noes.trade_date, 'BLOCK', noes.entered_org_type
ORDER BY 1, 2, 3, 4;

drop table table2;
create table table2 as
SELECT   'H4' env, noes.trade_date,
         DECODE (noes.trade_type,
                 0, 'NETTING',
                 1, 'BLOCK',
                 2, 'BLOCK',
                 11, 'NETTING',
                 'ERROR'
                ) trade_type,
         side_a_org.role_name entering_party, COUNT (*) hr4_tickets
    FROM v_fxpb_report_noe@hr4_link noes,
         v_a_report_organization@hr4_link side_a_org,
         v_a_report_organization@hr4_link side_b_org,
         v_a_report_organization@hr4_link entering_org
   WHERE noes.side_a = side_a_org.ID
     AND noes.side_b = side_b_org.ID
     AND noes.entering_org = entering_org.ID
     AND noes.trade_date =
                   TO_DATE (TO_CHAR (SYSDATE - 1, 'MM/DD/YYYY'), 'mm/dd/yyyy')
     AND noes.request_id <> 'Automatch'
     AND noes.trade_type <> 0
     AND noes.trade_type <> 11
GROUP BY noes.trade_date,
         DECODE (noes.trade_type,
                 0, 'NETTING',
                 1, 'BLOCK',
                 2, 'BLOCK',
                 11, 'NETTING',
                 'ERROR'
                ),
         side_a_org.role_name
ORDER BY 1, 2, 3, 4;

drop table table3;
create table table3 as
SELECT   'H3' env, ct.trade_date, 'CHILD' trade_type,
         DECODE (tp_org.TYPE,
                 2, 'CLIENT',
                 3, 'BANK',
                 4, 'PB',
                 5, 'ECN',
                 9, 'FUND',
                 'ERROR'
                ) entering_party,
         COUNT (*) child_trades
    FROM v_hr_fx_ct_report@hr_link ct,
         a_organization@hr_link tp_org
   WHERE ct.trade_date =
                   TO_DATE (TO_CHAR (SYSDATE - 1, 'MM/DD/YYYY'), 'mm/dd/yyyy')
     AND ct.giveup_trading_party = tp_org.ID
     AND ct.lifecycle_status NOT IN (
            SELECT code_key
              FROM a_code_member@hr_link
             WHERE GROUP_ID = '3000001'
               AND DATA IN
                          ('Invalid', 'Error', 'Request_Replace', 'Replaced'))
GROUP BY 'H3', ct.trade_date, 'CHILD', tp_org.TYPE
ORDER BY 1, 2, 3, 4;

SET DEFINE "^"
set pau off
col "Harmony 3 Child Trades" format 9,999,999
col "Harmony 3 Blocks" format 9,999,999
col "Harmony 4 Blocks" format 9,999,999
col sum(tickets) heading 'Total Blocks' format 9,999,999
col "Entering Party" format a30
compute sum LABEL 'Total Harmony 3 Blocks:' of "Harmony 3 Blocks" on report
compute sum LABEL 'Total Harmony 4 Blocks:' of "Harmony 4 Blocks" on report
compute sum LABEL 'Total Harmony 3 Child Trades:' of "Harmony 3 Child Trades" on report
break on report
spool ^1
select entering_party "Entering Party",hr3_tickets "Harmony 3 Blocks" from table1;
select entering_party "Entering Party",hr4_tickets "Harmony 4 Blocks" from table2;
select sum(tickets) from (select sum(hr3_tickets) tickets from table1 union select sum(hr4_tickets) tickets from table2);
select entering_party "Entering Party",child_trades "Harmony 3 Child Trades" from table3;
spool off
exit;
