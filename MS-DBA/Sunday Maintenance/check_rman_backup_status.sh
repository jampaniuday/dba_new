#! /bin/ksh
##################################################
# Author: Oded Raz
# Purpuse: Check for running backups befor business day
# Compny : Traiana
# Wrote  : 01-JUN-2009
####################################################
export SCRIPT_HOME=/usr/local/nagios_plugins
export DAY=`date "+%d%m%Y"`
export LOG_DIR=~/monitor/log
export LOG_FILE=$LOG_DIR/Check_RMAN_$DAY.log
export SQLPATH=/oracle
export BASEDIR=~/monitor/params
export START_TIME='03:00:00'
export END_TIME='22:00:00'

export DFLTWRPCT=80
export DFLTERPCT=90
export TS_PARM_FILE=$BASEDIR/TS_ALERTS.prm
export RC=0
export ERRSTK=""
export WRNSTK=""

echo "<<< `date` RMAN Backup check started >>>" >> $LOG_FILE

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



DB_UP ()
{
ps -ef |grep ora_pmon_$ORACLE_SID |grep -v grep
}
for LINE in `cat $ORATAB |grep :Y$ |egrep '^[A-Z]|^[a-z]'`
do
         ORACLE_SID=`echo $LINE |  egrep '^[A-Z]|^[a-z]'|awk -F: '{print $1}' -`
         export ORACLE_SID
         export ORACLE_HOME=`echo $LINE | awk -F: '{if ( substr($1,0,1) != "#"  && substr($1,0,1) != "*")print $2}'`
         export PATH=$ORACLE_HOME/bin:/bin:/usr/bin:/etc:/usr/local/bin ;
         export LASTALERT=$BASEDIR/last_alerttime_$ORACLE_SID.txt

# Get database staus from v$instnace
BACK_STATUS=`sqlplus -s -L rman/rman123@monp <<!EOF
set verify off
set feedback off
set heading off
SELECT ','||db_name||' '||to_char(start_time,'DD/MM/YYYY HH24:MI:SS')||' '||operation
FROM   rman.rc_rman_status
WHERE STATUS = 'RUNNING'
AND start_time > SYSDATE - 7 AND ROW_TYPE='COMMAND' AND TO_CHAR(SYSDATE,'HH24:MI:SS') > '$START_TIME' AND TO_CHAR(SYSDATE,'HH24:MI:SS') <  '$END_TIME';
!EOF
`

if [ "$BACK_STATUS" != "" ]; then

   IFS=,

   for FILESYS in $BACK_STATUS
      do
        
	DB_NAME=`echo $FILESYS|awk '{print $1}'`
        BACKUP_DATE=`echo $FILESYS|awk '{print $2}'`
        BACKUP_TIME=`echo $FILESYS|awk '{print $3}'`	
	BACKUP_CMD=`echo $FILESYS|awk '{print $4}'`


	if [ -n "$DB_NAME" ]; then

		ERRSTK="Critical - RMAN Backup on $DB_NAME is running, $BACKUP_CMD in progress":$ERRSTK

	fi

      done
fi

done

if [ -n "$ERRSTK" ]; then

echo "$ERRSTK"|gawk 'BEGIN {FS=":"}{for (i=1;NF>=i;i++) {print $i}}' >> $LOG_FILE
echo "$ERRSTK"|gawk 'BEGIN {FS=":"}{for (i=1;NF>=i;i++) {print $i}}'
exit 2
fi

echo "RMAN Backup is not running " >> $LOG_FILE
echo "RMAN Backup is not running "
echo "<<< `date` RMAN Backup check ended >>>" >> $LOG_FILE
exit 0
