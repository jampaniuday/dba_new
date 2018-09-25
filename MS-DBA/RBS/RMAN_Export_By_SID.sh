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

########################################################################
# Get Storeage IP and Volume name
########################################################################

export STORAGE_IP=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
SELECT STORAGE_IP FROM tr_backup_parameters WHERE UPPER(DB_NAME)=UPPER('${BACK_SID}');
%SQL%`

export VOLUME_NAME=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
SELECT VOLUME_NAME FROM tr_backup_parameters WHERE UPPER(DB_NAME)=UPPER('${BACK_SID}');
%SQL%`

#######################################################################
# Get SYS Password and Check if Database is open, ready for backup
#######################################################################

export SYS_PASS=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
SELECT SYS_PASS FROM tr_backup_parameters WHERE UPPER(DB_NAME)=UPPER('${BACK_SID}');
%SQL%`

export CENTRAL_LOG_DIR=$LOG_DIR

#######################################################################
# Stop Instance
#######################################################################
export ORACLE_SID=${BACK_SID}

export MOUNT_STATUS=`$ORACLE_HOME/bin/sqlplus -x -s / as sysdba <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
shutdown immediate;
%SQL%`

#######################################################################
# Take Snapshot
#######################################################################

export SNAP_TO_DELETE=`ls /dbdbf/.snapshot |grep dbdbf_n_snap | head -1`
export NEW_SNAP=`date +"${BACK_SID}_n_snap_%Y_%m_%d_%H_%M"`
#echo SNAP_TO_DELETE $SNAP_TO_DELETE
#echo NEW_SNAP $NEW_SNAP
echo "rsh -n ${STORAGE_IP} snap delete ${VOLUME_NAME} ${SNAP_TO_DELETE}"
echo "rsh -n ${STORAGE_IP} snap create ${VOLUME_NAME} ${NEW_SNAP}"
#echo `date +"create $VOLUME_NAME ended %Y%m%d %H:%M:%S"`
exit 0
#######################################################################
# Start Instance READ WRITE
#######################################################################
export ORACLE_SID=${BACK_SID}

export MOUNT_STATUS=`$ORACLE_HOME/bin/sqlplus -x -s / as sysdba <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
STARTUP NOMOUNT;
ALTER DATABASE MOUNT STANDBY DATABASE;
RECOVER MANAGED STANDBY DATABASE CANCEL;
ALTER DATABASE ACTIVATE STANDBY DATABASE;
ALTER DATABASE OPEN;
%SQL%`

#######################################################################
# check if the database is open
#######################################################################

echo "Open Database=> ${DB_OPEN}"

 export DB_STATUS=`$ORACLE_HOME/bin/sqlplus -x -s / as sysdba <<%SQL%
        set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
	select open_mode from v\\$database;
	exit;
%SQL%`

echo "DB STATUS => ${DB_STATUS}"

#export UPDATE_DB_STATUS=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
#set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
#INSERT INTO TR_BACKUP_LOG VALUES(sysdate,'${RESTORE_STATUS}','DB STATUS','Successfull','${BACK_SID}','${DB_STATUS}',sysdate);
#commit;
#exit;
#%SQL%`

fi
#######################################################################
