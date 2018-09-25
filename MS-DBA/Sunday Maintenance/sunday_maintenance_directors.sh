#! /bin/ksh
##################################################
# Author: Oded Raz
# Purpuse: Check Capacity Archive Destination & $ORACLE_HOME.
# Compny : Traiana
# Wrote  : 30-May-2006
####################################################
export SCRIPT_HOME=/oracle/sundaymaint
export DAY=`date "+%d%m%Y"`
export LOG_DIR=/oracle/sundaymaint/log
export LAST_RUN_FILE=$SCRIPT_HOME/last_run.prm
export LOG_FILE=$LOG_DIR/Check_export_$DAY.log
export SQLPATH=/oracle
export BASEDIR=/oracle/sundaymaint
export EXP_PARM_FILE=$BASEDIR/export.prm
export SEND_TO=oded.raz@gmail.com
export RC=0

if [ -s /etc/oratab ];
  then
  export ORATAB=/etc/oratab
 elif [ -s /var/opt/oracle/oratab ] ;then

   export ORATAB=/var/opt/oracle/oratab
 else
  echo "\nCritical - {ORATAB} not exists \n"
  exit 2
fi


#check if parameter file exists, create it if not

if [ ! -d "$BASEDIR" ]; then
    mkdir -p $BASEDIR
fi

if [ ! -d "$LOG_DIR" ]; then
    mkdir -p $LOG_DIR
fi

if [ ! -f $TS_PARM_FILE ]; then
touch ${TS_PARM_FILE}
fi



#Get Database credentials
for LINE in `cat $ORATAB |grep :Y$ |egrep '^[A-Z]|^[a-z]'`
do
         ORACLE_SID=`echo $LINE |  egrep '^[A-Z]|^[a-z]'|awk -F: '{print $1}' -`
         export ORACLE_SID
         export ORACLE_HOME=`echo $LINE | awk -F: '{if ( substr($1,0,1) != "#"  && substr($1,0,1) != "*")print $2}'`
         export PATH=$ORACLE_HOME/bin:/bin:/usr/bin:/etc:/usr/local/bin ;
         export LASTALERT=$BASEDIR/last_alerttime_$ORACLE_SID.txt


 
# Get last report name
REPORT_NAME=`cat $LAST_RUN_FILE`
echo $REPORT_NAME
export ATTACH_NAME=$REPORT_NAME.html
export ATTACH_FILE=/oracle/sundaymaint/`echo $ATTACH_NAME`
export DB_LIST="'JPPRD','HR4UAT'"
echo $DB_LIST
sqlplus system/manager11 @dumphtml_per_db.sql $REPORT_NAME "$DB_LIST"

mv $REPORT_NAME.lst $REPORT_NAME.html

$SCRIPT_HOME/sendattachment.sh $ATTACH_FILE $SEND_TO

rm $REPORT_NAME.html

done
