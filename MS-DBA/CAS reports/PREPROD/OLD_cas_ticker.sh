#!/bin/bash
export ORACLE_BASE=/oracle
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db
export ORACLE_SID=casuat
export PATH=.:${PATH}:$HOME/bin:$ORACLE_HOME/bin
export PATH=${PATH}:/usr/bin:/bin:/usr/bin/X11:/usr/local/bin
export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1
export OUTPUT_FILE_NAME_TICKETS=`date +"/cassrc/reports/preprod/TICKETS_%m-%d-%Y_%H-%M.txt"`
export REPORT_DATE=`date -d yesterday +"%Y-%m-%d"`
export TOTAL_TICKETS=/cassrc/reports/preprod/TOTAL_TICKETS.lst
cd /cassrc/reports/preprod
sqlplus read_only/limited @cas_ticker.sql $OUTPUT_FILE_NAME_TICKETS > /dev/null
$ORACLE_HOME/bin/sqlplus -s read_only/limited <<%SQL%
set echo off feed off trims on head off pages 0
spool $TOTAL_TICKETS
select ltrim(to_char(sum(Total),'9,999,999')) from cas_preprod_tickets;
spool off
%SQL%
export TOTAL_TICKETS_OUTPUT=`cat $TOTAL_TICKETS`
\echo -e "Subject:$REPORT_DATE CAS PREPROD Daily Ticker Report | $TOTAL_TICKETS_OUTPUT Total Blocks\nFrom:Traiana Reports System <ms-dba@traiana.com>\n`\cat $OUTPUT_FILE_NAME_TICKETS`" | /usr/sbin/sendmail "CAS-Service-Management@traiana.com arielal@traiana.com pavelk@traiana.com rafiv@traiana.com clsservicemanagement@cls-services.com CLSASCompliance@cls-bank.com rhardy@cls-services.com vladimirb@traiana.com MaureenD@traiana.com MoiraS@traiana.com mlaven@traiana.com JohnL@traiana.com MikeR@traiana.com galc@traiana.com"
rm $OUTPUT_FILE_NAME_TICKETS
rm $TOTAL_TICKETS
