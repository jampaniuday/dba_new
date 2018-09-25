#!/bin/bash
# 14.06.2009 - Oded Raz - Main RMAN backup script
# This script calls the 2 scripts,
# that perform the RMAN full database backup and the RMAN incremental backup,
# and sends e-mail after each backup.

BACK_SID=$1
DBNAME=$BACK_SID
export SCRIPT_HOME=~/scripts
export SEND_TO=oded.raz@gmail.com

SCRIPT_NAME=$(dirname $0)/$(basename $0)
echo "start script $SCRIPT_NAME   $(date '+%d %b %Y  %H:%M:%S')"

if [ -f ~/.bash_profile ] ; then
   . ~/.bash_profile
else
   echo "~/.bash_profile does not exist"
   exit 1
fi

ENV_FILE=/home/oracle/scripts/rman.env
echo " \$ENV_FILE = $ENV_FILE"
echo " "

#set -x
# Check for environment file

if [ -f "${ENV_FILE}" ] ; then
. $ENV_FILE
else
$ALERT_FILE "$HOSTNAME $ORACLE_SID backup - E - $ENV_FILE file not found. Backup Terminated"
exit 1
fi


TODAY=`date '+%a'`

########################################################################
# Get Proper Oracle Home
########################################################################

export ORACLE_EDITION=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
SELECT EDITION FROM tr_backup_parameters WHERE UPPER(DB_NAME)=UPPER('${BACK_SID}');
%SQL%`

if [ "${ORACLE_EDITION}" = "EE" ] ; then

   export ORACLE_HOME=/oracle/ee/product/10.2.0/db

else
   export ORACLE_HOME=/oracle/se/product/10.2.0/db
fi

########################################################################
# Get Backup Directory and check if he exsits
########################################################################

export BACKUP_DIR=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
SELECT BACKUP_DIR FROM tr_backup_parameters WHERE UPPER(DB_NAME)=UPPER('${BACK_SID}');
%SQL%`

# check if the backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
   echo "Backup directory  $BACKUP_DIR does not exist"
   $ALERT_FILE "$HOSTNAME $ORACLE_SID backup - E - $BACKUP_DIR file not found. Backup Terminated" "see $SCRIPT_NAME"
   exit 1
else
   echo " \$BACKUP_DIR = $BACKUP_DIR"
fi

########################################################################
# Get RMAN log location and check if he exsits
########################################################################

export LOG_DIR=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
SELECT LOG_DIR FROM tr_backup_parameters WHERE UPPER(DB_NAME)=UPPER('${BACK_SID}');
%SQL%`

# check if the log directory exists
if [ ! -d "$LOG_DIR" ]; then
   echo "Backup log directory  $LOG_DIR does not exist"
   $ALERT_FILE "$HOSTNAME $ORACLE_SID backup - E - $LOG_DIR file not found. Backup Terminated" "see $SCRIPT_NAME"
   exit 1
else
   echo " \$LOG_DIR    = $LOG_DIR"
fi

#######################################################################
# Get SYS Password and Check if Database is open, ready for backup
#######################################################################

export SYS_PASS=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
SELECT SYS_PASS FROM tr_backup_parameters WHERE UPPER(DB_NAME)=UPPER('${BACK_SID}');
%SQL%`

export CENTRAL_LOG_DIR=$LOG_DIR

#######################################################################
# Get Last Full Backup End Date and Time
#######################################################################

export UNTIL_RECOVERY=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
SELECT * 
FROM 
       (
        SELECT TO_CHAR(START_TIME,'DD-MM-YYYY HH24:MI:SS')
          FROM rc_rman_status
         WHERE start_time > SYSDATE - 1
           AND OPERATION = 'BACKUP'
           AND ROW_TYPE = 'COMMAND'
           AND OBJECT_TYPE = 'ARCHIVELOG'
           AND DB_NAME = UPPER('${BACK_SID}')
           AND STATUS = 'COMPLETED'   
         order by 1 desc
         ) 
WHERE  ROWNUM < 2;
%SQL%`
echo $UNTIL_RECOVERY

export START_TIME=`date +%y%m%d-%H%M%S`

#######################################################################
# Start Recovered Instance In No-Mount State
#######################################################################
export ORACLE_SID=${BACK_SID}

export MOUNT_STATUS=`$ORACLE_HOME/bin/sqlplus -x -s / as sysdba <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
shutdown abort;
startup nomount;
%SQL%`

echo $MOUNT_STATUS

#######################################################################
# Restore The  Database On the Backup Server
#######################################################################
export UPDATE_LOG=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
INSERT INTO TR_BACKUP_LOG VALUES(sysdate,'0','RESTORE','Restore Started','${BACK_SID}',NULL,NULL);
commit;
exit;
%SQL%`

echo "RMAN begin ${BACK_SID} Recovery"  

export ORACLE_SID=$BACK_SID

#echo  "sys/$SYS_PASS@$BACK_SID" "$CATALOG_USER/$CATALOG_PASS@$CATALOG" "sys/manager11" $ORACLE_HOME "'$UNTIL_RECOVERY'"

/home/oracle/scripts/rman_restore_read_only.sh "sys/$SYS_PASS@$BACK_SID" "$CATALOG_USER/$CATALOG_PASS@$CATALOG" "sys/manager11" $ORACLE_HOME "'$UNTIL_RECOVERY'" #> ${CENTRAL_LOG_DIR}/RMAN_${DBNAME}_Full.$START_TIME.log

#######################################################################
# check  Restore status
#######################################################################

CURRENT_LOG_FILE=`ls -ltr ~/scripts/logs/RMAN_${BACK_SID}_Restore* |tail -1 | awk '{print $9}'`

  echo "Current Log File=>$CURRENT_LOG_FILE"

  RESTORE_ERRORS=`cat $CURRENT_LOG_FILE | grep ORA-`

  echo "Errors Found => $RESTORE_ERRORS"

if [ -n "$RESTORE_ERRORS" ]; then

       	RESTORE_ERR=`echo "Failed to restore database $RESTORE_ERRORS"`
       	RESTORE_STATUS=-1

  else
	RESTORE_ERR=`echo "Successfully"`
       	RESTORE_STATUS=0
	RESTORE_ERRORS=''
  fi

export UPDATE_RECOVERY_STATUS=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
INSERT INTO TR_BACKUP_LOG VALUES(sysdate,'${RESTORE_STATUS}','RESTORE','${RESTORE_ERR}','${BACK_SID}',NULL,NULL);
commit;
exit;
%SQL%`



#######################################################################
# check if the database is open
#######################################################################

if [ $RESTORE_STATUS -eq 0 ]; then

	echo "Opening Database In Read Only"
	export ORACLE_SID=${BACK_SID}

	export DB_OPEN=`$ORACLE_HOME/bin/sqlplus -x -s / as sysdba <<%SQL%
	set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
	SHUTDOWN ABORT;
	STARTUP MOUNT;
	ALTER DATABASE OPEN READ ONLY;
	exit;
%SQL%`

echo "Open Database=> ${DB_OPEN}"

 export DB_STATUS=`$ORACLE_HOME/bin/sqlplus -x -s / as sysdba <<%SQL%
        set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
	select open_mode from v\\$database;
	exit;
%SQL%`

echo "DB STATUS => ${DB_STATUS}"

export UPDATE_DB_STATUS=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
INSERT INTO TR_BACKUP_LOG VALUES(sysdate,'${RESTORE_STATUS}','DB STATUS','Successfull','${BACK_SID}','${DB_STATUS}',sysdate);
commit;
exit;
%SQL%`

fi
#######################################################################
