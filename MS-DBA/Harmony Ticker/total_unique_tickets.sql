drop table table4;
create table table4 as
SELECT   noes.trade_date, COUNT (*) trades
    FROM v_fd_fxpb_linear_ta@hr4_link noes,
         v_a_report_organization@hr4_link tp_org,
         v_a_report_organization@hr4_link cp_org,
         v_a_report_organization@hr4_link ep_org
   WHERE noes.tp_id = tp_org.ID(+)
     AND noes.cp_id = cp_org.ID(+)
     AND noes.entering_org_id = ep_org.ID(+)
     AND noes.trade_date =
                   TO_DATE (TO_CHAR (SYSDATE - 1, 'MM/DD/YYYY'), 'MM/DD/YYYY')
     -- Exclude trades which Harmony 4 created including Automatch and NETTING trades
     AND noes.request_id <> 'Automatch'
     AND noes.trade_type <> 11
     -- Include All CLIENT trades and Only Unmatched Trades from others
     AND (   tp_org.role_name = 'CLIENT'
          OR (    (tp_org.role_name <> 'CLIENT')
              AND noes.confirmation_status <> 1
              AND noes.recon_status <> 1
             )
         )
GROUP BY noes.trade_date;

drop table table5;
create table table5 as
SELECT   noes.trade_date, COUNT (*) trades
    FROM v_hr_fx_noe_report@hr_link noes
   WHERE
         -- Exclude lifecycle events
         noes.lifecycle_status NOT IN (
            SELECT code_key
              FROM a_code_member@hr_link
             WHERE GROUP_ID = '3000001'
               AND DATA IN
                          ('Invalid', 'Error', 'Request_Replace', 'Replaced'))
     AND
         -- Limit Date Range
         noes.trade_date =
                   TO_DATE (TO_CHAR (SYSDATE - 1, 'MM/DD/YYYY'), 'mm/dd/yyyy')
--     AND noes.trade_date <=
--                       TO_DATE (TO_CHAR (SYSDATE, 'MM/DD/YYYY'), 'mm/dd/yyyy')
     -- Exclude Dummy Organizations
     AND noes.trading_party NOT IN (
            SELECT ID
              FROM a_organization@hr_link
             WHERE NAME IN
                        ('Traiana EB', 'Traiana Client', 'Traiana PB', 'N/A'))
     -- Also exclude FXCM Japan Inc 2 as these would normally match but we forced them not to
     AND noes.counter_party NOT IN (
            SELECT ID
              FROM a_organization@hr_link
             WHERE NAME IN
                      ('Traiana EB',
                       'Traiana Client',
                       'Traiana PB',
                       'N/A',
                       'FXCM Japan Inc 2'
                      ))
     AND noes.prime_broker NOT IN (
            SELECT ID
              FROM a_organization@hr_link
             WHERE NAME IN
                        ('Traiana EB', 'Traiana Client', 'Traiana PB', 'N/A'))
     -- Exclude FXTrades PB Giveups
     AND noes.trading_party NOT IN (SELECT ID
                                      FROM a_organization@hr_link
                                     WHERE NAME IN ('CX FX Trades EB'))
     -- Exclude FXCMPRO PB Giveups
     AND NOT (    noes.entered_org_name = 'FXCM Pro'
              AND (noes.counter_party NOT IN (
                                         SELECT ID
                                           FROM a_organization@hr_link
                                          WHERE NAME IN
                                                      ('FXCM Pro Hub Client'))
                  )
              AND (noes.trading_party NOT IN (
                                           SELECT ID
                                             FROM a_organization@hr_link
                                            WHERE NAME IN ('FXCM Pro Hub'))
                  )
             )
     -- Exclude Matched CLIENT Trades
     AND NOT (    noes.entered_org_type = '2'
              AND noes.match_status =
                            (SELECT code_key
                               FROM a_code_member@hr_link
                              WHERE GROUP_ID = '3000009' AND DATA = 'Matched')
             )
     -- Exclude AVERAGE Trades
     AND NOT (noes.trade_type =
                            (SELECT code_key
                               FROM a_code_member@hr_link
                              WHERE GROUP_ID = '3000010' AND DATA = 'Average')
             )
GROUP BY noes.trade_date;

exit;
