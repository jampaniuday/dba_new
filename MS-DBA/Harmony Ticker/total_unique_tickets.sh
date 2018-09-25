#!/bin/bash
export ORACLE_BASE=/oracle
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db
export ORACLE_SID=monp
export PATH=.:${PATH}:$HOME/bin:$ORACLE_HOME/bin
export PATH=${PATH}:/usr/bin:/bin:/usr/bin/X11:/usr/local/bin
export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1
export REPORT_DATE=`date -d yesterday +"%Y-%m-%d"`
export TOTAL_UNIQUE_TICKETS=/monpsrc/scripts/harmony_ticker/TOTAL_UNIQUE_TICKETS.lst
cd /monpsrc/scripts/harmony_ticker
$ORACLE_HOME/bin/sqlplus trdba/trdba @total_unique_tickets.sql > /dev/null
$ORACLE_HOME/bin/sqlplus -s trdba/trdba <<%SQL%
set echo off feed off trims on head off pages 0
spool $TOTAL_UNIQUE_TICKETS
select ltrim(to_char(sum(trades),'9,999,999')) from (select sum(trades) trades from table4 union select sum(trades) tickets from table5);
spool off
%SQL%
export TOTAL_UNIQUE_TICKETS_OUTPUT=`cat $TOTAL_UNIQUE_TICKETS`
\echo -e "Subject:$REPORT_DATE Harmony Ticker | $TOTAL_UNIQUE_TICKETS_OUTPUT Total Unique Tickets\nFrom:Traiana Reports System <ms-dba@traiana.com>\n" | \sendmail "jeffreyg@traiana.com galc@traiana.com"
rm $TOTAL_UNIQUE_TICKETS
exit;
