#!/bin/bash
export ORACLE_BASE=/oracle
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db
export ORACLE_SID=monp
export PATH=.:${PATH}:$HOME/bin:$ORACLE_HOME/bin
export PATH=${PATH}:/usr/bin:/bin:/usr/bin/X11:/usr/local/bin
export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1
export OUTPUT_FILE_NAME_TICKETS=`date +"/monpsrc/scripts/harmony_ticker/TICKETS_%m-%d-%Y_%H-%M.txt"`
export REPORT_DATE=`date -d yesterday +"%Y-%m-%d"`
export TOTAL_TICKETS=/monpsrc/scripts/harmony_ticker/TOTAL_TICKETS.lst
export TOTAL_CHILD_TRADES=/monpsrc/scripts/harmony_ticker/TOTAL_CHILD_TRADES.lst
cd /monpsrc/scripts/harmony_ticker
sqlplus trdba/trdba @harmony_ticker.sql $OUTPUT_FILE_NAME_TICKETS > /dev/null
$ORACLE_HOME/bin/sqlplus -s trdba/trdba <<%SQL%
set echo off feed off trims on head off pages 0
spool $TOTAL_TICKETS
select ltrim(to_char(sum(tickets),'9,999,999')) from (select sum(hr3_tickets) tickets from table1 union select sum(hr4_tickets) tickets from table2);
spool off
%SQL%
export TOTAL_TICKETS_OUTPUT=`cat $TOTAL_TICKETS`
$ORACLE_HOME/bin/sqlplus -s trdba/trdba <<%SQL%
set echo off feed off trims on head off pages 0
spool $TOTAL_CHILD_TRADES
select ltrim(to_char(sum(child_trades),'9,999,999')) from table3;
spool off
%SQL%
export TOTAL_CHILD_TRADES_OUTPUT=`cat $TOTAL_CHILD_TRADES`
\echo -e "Subject:$REPORT_DATE Harmony Ticker - Inputs | $TOTAL_TICKETS_OUTPUT Total Blocks | $TOTAL_CHILD_TRADES_OUTPUT Total Child Trades\nFrom:Traiana Reports System <ms-dba@traiana.com>\n`\cat $OUTPUT_FILE_NAME_TICKETS`" | /usr/sbin/sendmail "jeffreyg@traiana.com scottf@traiana.com brianr@traiana.com rafiv@traiana.com roys@traiana.com dannyf@traiana.com elirang@traiana.com mlaven@traiana.com NickS@traiana.com JohnL@traiana.com JennieY@traiana.com MoiraS@traiana.com illitg@traiana.com pavelk@traiana.com MaureenD@traiana.com galc@traiana.com"
rm $OUTPUT_FILE_NAME_TICKETS
rm $TOTAL_TICKETS
rm $TOTAL_CHILD_TRADES
exit;
