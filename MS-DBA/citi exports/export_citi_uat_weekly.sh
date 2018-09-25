#!/bin/bash

echo `date +"Start exp %Y%m%d%H%M "`

export ORACLE_SID=monp
export ORACLE_HOME=/oracle/product/10.2.0/db

$ORACLE_HOME/bin/sqlplus -s citi_uat_weekly/citi_uat_weekly@monp @/monpsrc/scripts/citi_exports/prepare_citi_uat_weekly_tables.sql 

cd /monpdbf/export/

CMD1=`date +"file=exp_citi_uat_weekly_%Y%m%d%H%M.dmp"`
CMD2=`date +"exp_citi_uat_weekly_%Y%m%d%H%M.dmp.gz"`
CMD3=`date +"log=exp_citi_uat_weekly_%Y%m%d%H%M.log"`
$ORACLE_HOME/bin/exp citi_uat_weekly/citi_uat_weekly $CMD1 $CMD3 owner=CITI_UAT_WEEKLY

gzip /monpdbf/export/exp_citi_uat_weekly_*.dmp
chmod 775 exp_citi_*.gz

smbclient -c "cd Production\sFTP_Users\ArchPrdCiti_DB\citi_export;put $CMD2" -U siteop \\\\192.168.141.212\\home 0206BaBa

echo `date +"End exp %Y%m%d%H%M "`
