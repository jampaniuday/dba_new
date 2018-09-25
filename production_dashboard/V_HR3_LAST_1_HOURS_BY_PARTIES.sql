CREATE OR REPLACE FORCE VIEW V_HR3_LAST_1_HOURS_BY_PARTIES AS
SELECT   TO_CHAR (TRUNC (created_date, 'HH24'), 'HH24:MI') TIME,
         (SELECT NAME
            FROM hr3_prod.a_organization@hr3prod
           WHERE ID = trading_party) trading_party,
         (SELECT NAME
            FROM hr3_prod.a_organization@hr3prod
           WHERE ID = counter_party) counter_party,
         (SELECT NAME
            FROM hr3_prod.a_organization@hr3prod
           WHERE ID = prime_broker) prime_broker, COUNT (*) noes
    FROM v_hr3_trades
   WHERE created_date >= TRUNC (SYSDATE, 'hh24')
GROUP BY TRUNC (created_date, 'HH24'),
         trading_party,
         counter_party,
         prime_broker
ORDER BY TRUNC (created_date, 'HH24')
;


