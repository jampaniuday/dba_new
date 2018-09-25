#!/bin/bash

process=`ps -ef|grep pmon|grep ora_ |gawk '{print $8}'`
export ORACLE_SID=${process:9:9}
export ORAENV_ASK=NO
. /usr/local/bin/oraenv
export PATH=.:${PATH}:$HOME/bin:$ORACLE_HOME/bin
export PATH=${PATH}:/usr/bin:/bin:/usr/bin/X11:/usr/local/bin
export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1

export ORIG_OUTPUT_PATH=`date +"/cassrc/reports/trading_data_PROD_%d-%m-%Y_%H-%M.csv"`
export ORIG_OUTPUT_FILE_NAME=`date +"trading_data_PROD_%d-%m-%Y_%H-%M.csv"`
export SPLIT_FILE_NAME=`date +"trading_data_PROD_%d-%m-%Y_%H-%M"`
export SPLIT_FILE_LOOP=`date +"trading_data_PROD_%d-%m-%Y_%H-%M0*"`

cd /cassrc/reports
sqlplus read_only/limited @trading_data.sql $ORIG_OUTPUT_PATH > /dev/null
split -l 15000 -d -a 4 $ORIG_OUTPUT_FILE_NAME $SPLIT_FILE_NAME
for f in $SPLIT_FILE_LOOP
do mv "$f" "${f%}.csv"
export OUTPUT_PATH="/cassrc/reports/${f%}.csv"
export OUTPUT_FILE_NAME="${f%}.csv"
echo -e "Subject:CAS Service Management Reports (PROD) - Daily Trading Data\nFrom:Traiana Reports System <ms-dba@traiana.com>\n`uuencode $OUTPUT_PATH $OUTPUT_FILE_NAME`"| /usr/sbin/sendmail "vladimirb@traiana.com"
done
rm -f trading_data*.csv
