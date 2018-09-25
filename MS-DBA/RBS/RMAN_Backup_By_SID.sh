#!/bin/bash
# 14.06.2009 - Oded Raz - Main RMAN backup script
# This script calls the 2 scripts,
# that perform the RMAN full database backup and the RMAN incremental backup,
# and sends e-mail after each backup.

BACK_SID=$1
PARALELL=$2

DBNAME=$BACK_SID

SCRIPT_NAME=$(dirname $0)/$(basename $0)
echo "start script $SCRIPT_NAME   $(date '+%d %b %Y  %H:%M:%S')"


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
   $ALERT_FILE "\n $HOSTNAME $ORACLE_SID backup - E - $BACKUP_DIR file not found. Backup Terminated" "see $SCRIPT_NAME"
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

echo $BACKUP_DIR
echo $LOG_DIR
echo $SYS_PASS
export CENTRAL_LOG_DIR=$LOG_DIR

# Check if the RMAN target Database is OPEN
echo " Check if Instance $ORACLE_SID is OPEN"
echo " "

echo "system/$SYS_PASS@$BACK_SID"
export DBCHECK=`$ORACLE_HOME/bin/sqlplus -x -s system/$SYS_PASS@$BACK_SID <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
select status from v\\$instance;
%SQL%`
echo $DBCHECK

if [ "${DBCHECK}" != "OPEN" ]; then
   $ALERT_FILE "$HOSTNAME $ORACLE_SID backup - E - RMAN target instance not OPEN" "RMAN cannot run backup when target instance is not OPEN ,Status is $DBCHECK"
   exit 1;
fi

export START_TIME=`date +%y%m%d-%H%M%S`

#######################################################################
# Backup Database 
#######################################################################
export UPDATE_LOG=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
INSERT INTO TR_BACKUP_LOG VALUES(sysdate,'0','BACKUP','Started ','${BACK_SID}',NULL,NULL);
commit;
exit;
%SQL%`

echo "RMAN begin full database backup"   

/home/oracle/scripts/rman_full_backup.sh "sys/$SYS_PASS@$BACK_SID" "$CATALOG_USER/$CATALOG_PASS@$CATALOG" $BACK_SID $BACKUP_DIR $ORACLE_HOME $PARALELL > ${CENTRAL_LOG_DIR}/RMAN_${DBNAME}_Full.$START_TIME.log 

#######################################################################
# check Backup status
#######################################################################

CURRENT_LOG_FILE=`ls -ltr ${CENTRAL_LOG_DIR}/RMAN_${DBNAME}_Full* |tail -1 | awk '{print $9}'`

  echo "Current Log File=>$CURRENT_LOG_FILE"

  RESTORE_ERRORS=`cat $CURRENT_LOG_FILE | grep ORA-`

  echo "Errors Found => $BACKUP_ERRORS"

if [ -n "$BACKUP_ERRORS" ]; then

        BACKUP_ERR=`echo "Failed to backup database $BACKUP_ERRORS"`
        BACKUP_STATUS=-1

  else
        BACKUP_ERR=`echo "Backup was Successfull"`
        BACKUP_STATUS=0
  fi

export UPDATE_RECOVERY_STATUS=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
INSERT INTO TR_BACKUP_LOG VALUES(sysdate,'${BACKUP_STATUS}','BACKUP','${BACKUP_ERR}','${BACK_SID}',NULL,NULL);
commit;
exit;
%SQL%`

#######################################################################
# Delete Old Log Files
#######################################################################

find "$CENTRAL_LOG_DIR" -follow -name "RMAN_*" -mtime +${LOG_DAYS_TO_KEEP} |xargs rm -f

echo "end   script $SCRIPT_NAME   $(date '+%d %b %Y  %H:%M:%S')"
exit $BACKUP_STATUS
