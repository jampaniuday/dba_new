#!/bin/bash
export ORACLE_BASE=/oracle
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db
export ORACLE_SID=monp
export PATH=.:${PATH}:$HOME/bin:$ORACLE_HOME/bin
export PATH=${PATH}:/usr/bin:/bin:/usr/bin/X11:/usr/local/bin
export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1
export REPORT_DATE=`date -d yesterday +"%Y-%m-%d"`
export TOTAL_UNIQUE_TICKETS_NOTIONAL=/monpsrc/scripts/harmony_ticker/TOTAL_UNIQUE_TICKETS_NOTIONAL.lst
export BILLION_USD=/monpsrc/scripts/harmony_ticker/BILLION_USD.lst
cd /monpsrc/scripts/harmony_ticker
$ORACLE_HOME/bin/sqlplus trdba/trdba @total_unique_tickets_notional.sql > /dev/null
$ORACLE_HOME/bin/sqlplus -s trdba/trdba <<%SQL%
set echo off feed off trims on head off pages 0
spool $TOTAL_UNIQUE_TICKETS_NOTIONAL
select ltrim(to_char(sum(trades),'9,999,999')) from (select sum(trades) trades from table6 union select sum(trades) tickets from table7);
spool off
%SQL%
$ORACLE_HOME/bin/sqlplus -s trdba/trdba <<%SQL%
set echo off feed off trims on head off pages 0
spool $BILLION_USD
select ltrim(to_char(sum(usd_bb),'999,999.99')) from (select sum(usd_bb) usd_bb from table6 union select sum(usd_bb) usd_bb from table7);
spool off
%SQL%
export TOTAL_UNIQUE_TICKETS_NOTIONAL_OUTPUT=`cat $TOTAL_UNIQUE_TICKETS_NOTIONAL`
export BILLION_USD_OUTPUT=`cat $BILLION_USD`
\echo -e "Subject:$REPORT_DATE Harmony Ticker | $TOTAL_UNIQUE_TICKETS_NOTIONAL_OUTPUT Total Unique Tickets | \$$BILLION_USD_OUTPUT Billion\nFrom:Traiana Reports System <ms-dba@traiana.com>\n" | /usr/sbin/sendmail "gilm@traiana.com NickS@traiana.com mlaven@traiana.com roys@traiana.com jeffreyg@traiana.com brianr@traiana.com Mark.Yallop@icap.com elirang@traiana.com JennieY@traiana.com jills@traiana.com illitg@traiana.com MaureenD@traiana.com galc@traiana.com"
rm $TOTAL_UNIQUE_TICKETS_NOTIONAL
rm $BILLION_USD
exit;
