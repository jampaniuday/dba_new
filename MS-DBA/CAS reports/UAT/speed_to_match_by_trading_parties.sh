#!/bin/bash

process=`ps -ef|grep pmon|grep ora_ |gawk '{print $8}'`
export ORACLE_SID=${process:9:9}
export ORAENV_ASK=NO
. /usr/local/bin/oraenv
export PATH=.:${PATH}:$HOME/bin:$ORACLE_HOME/bin
export PATH=${PATH}:/usr/bin:/bin:/usr/bin/X11:/usr/local/bin
export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1

export OUTPUT_PATH=`date +"/cassrc/reports/uat/%d-%m-%Y_UAT_speed_to_match_by_trading_parties.csv"`
export OUTPUT_FILE_NAME=`date +"%d-%m-%Y_UAT_speed_to_match_by_trading_parties.csv"`
cd /cassrc/reports/uat
sqlplus read_only/limited @speed_to_match_by_trading_parties.sql $OUTPUT_PATH > /dev/null
echo -e "Subject:CAS Service Management Reports (UAT) - Daily Speed to Match by Trading Parties\nFrom:Traiana Reports System <ms-dba@traiana.com>\n`uuencode $OUTPUT_PATH $OUTPUT_FILE_NAME`"| /usr/sbin/sendmail "vladimirb@traiana.com"
#echo -e "Subject:CAS Service Management Reports (UAT) - Daily Speed to Match by Trading Parties\nFrom:Traiana Reports System <ms-dba@traiana.com>\n`uuencode $OUTPUT_PATH $OUTPUT_FILE_NAME`"| /usr/sbin/sendmail "galc@traiana.com"
rm -f *speed_to_match_by_trading_parties.csv
