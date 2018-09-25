#!/bin/bash

# 05.09.2009 - Oded Raz - Main RMAN backup and Restore system script

# This script calls the 2 scripts,
# that perform the RMAN full database backup and the RMAN incremental backup,
# and sends e-mail after each backup.

SCRIPT_NAME=$(dirname $0)/$(basename $0)
#DBNAME=$2

if [ -f ~/.bash_profile ] ; then
   . ~/.bash_profile
else
   echo "~/.bash_profile does not exist"
   exit 1
fi

TODAY=`date '+%a'`
ENV_FILE=~/scripts/rman.env

if [ -f "${ENV_FILE}" ] ; then
   # read the enviromental file
   . $ENV_FILE
else
   echo "Environment file $ENV_FILE does not exist"
   exit 1
fi

export START_TIME=`date +%y%m%d-%H%M%S`

####################################################################################################
# Parsing command line parameters
####################################################################################################

USAGE="Usage: `basename $0` [-c command] [-s SID] [-p PARALLEL (1-9)]"
USAGE1="       Command: BACKUP,RESTORE,ALL,ADD,DEL"

# we want at least one parameter (it may be a flag or an argument)
if [ $# -eq 0 ]; then
        echo $USAGE >&2
	echo $USAGE1 >&2
        exit 1
fi

# parse command line arguments
while getopts c:s:p: OPT; do
    case "$OPT" in
        c)      CMD=$OPTARG
                case "$CMD" in
                   'BACKUP')
                   echo "Command Selected - ${CMD}"
                   ;;
                   'RESTORE')
                   echo "Command Selected - ${CMD}"
                   ;;
                   'ALL')
                   echo "Command Selected - ${CMD}"
                   ;;
                   'ADD')
                   echo "Command Selected - ${CMD}"
                   ;;
                   'DEL')
                   echo "${CMD} Will be implemented later"
                   ;;
                   *)
		   echo "Invalid command - ${CMD}"
	           echo $USAGE
                   echo "Command: BACKUP,RESTORE,ALL,ADD,DEL"
                   #echo "BACKUP - Backup specified database"
                   #echo "RESOTRE - Restore specified database"
                   #echo "ALL - Backup and then Restore specified datbase"
                   #echo "ADD - Add database to backup and restore system"
                   #echo "DEL - Remove database to backup and restore system"
                   ;;
                esac
                ;;
        v)      echo "`basename $0` version 0.1"
                exit 0
                ;;
	p)      PARALELL=$OPTARG
		if [[ $PARALELL = *[^0-9]* ]]; then
  			echo "Parallel values should be 1 to 9, PARALLEL 1 will be used"
			PARALELL=1
		fi
		export PARALELL
                ;;
        s)      DBNAME=$OPTARG
                export DB_EXISTS=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
                set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
                SELECT  COUNT(1) FROM tr_backup_parameters WHERE UPPER(DB_NAME)=UPPER('${DBNAME}');
                exit;
		%SQL%`
	
		if [ $CMD != 'ADD' ]; then
			if [ $DB_EXISTS -eq 0 ]; then
		        	echo "Database ${DBNAME} is not registered, Please specifiy registered database"
        			exit 1
			fi
		fi
                ;;
        \?)     # getopts issues an error message
                echo $USAGE >&2
                exit 1
                ;;
    esac
done

####################################################################################################
# BACKUP Database
####################################################################################################

if [ "${CMD}" = "BACKUP" ] ; then
   
   echo "RMAN begin full backup"   
   echo "${SCRIPT_HOME}/RMAN_Backup_By_SID.sh ${DBNAME} > ${LOG_DIR}/RMAN_${DBNAME}_Full.$START_TIME.log"

   $SCRIPT_HOME/RMAN_Backup_By_SID.sh ${DBNAME} ${PARALELL} > $LOG_DIR/RMAN_${DBNAME}_Backup.$START_TIME.log

   exit 0
fi

####################################################################################################
# Restore Database
####################################################################################################

if [ "${CMD}" = "RESTORE" ] ; then

   echo "RMAN begin restoring ${DBNAME} "
   echo "$SCRIPT_HOME/RMAN_Restore_By_SID.sh ${DBNAME} > ${LOG_DIR}/RMAN_${DBNAME}_Full.$START_TIME.log"

   $SCRIPT_HOME/RMAN_Restore_By_SID.sh ${DBNAME} > $LOG_DIR/RMAN_${DBNAME}_Restore.$START_TIME.log

   exit 0

fi

####################################################################################################
# Backup & Restore Database
####################################################################################################

if [ "${CMD}" = "ALL" ] ; then

   echo "RMAN begin full backup"
   echo "$SCRIPT_HOME/RMAN_Backup_By_SID.sh ${DBNAME} > ${LOG_DIR}/RMAN_${DBNAME}_Full.$START_TIME.log"
  
   $SCRIPT_HOME/RMAN_Backup_By_SID.sh ${DBNAME} ${PARALELL} > $LOG_DIR/RMAN_${DBNAME}_Backup.$START_TIME.log

   echo "RMAN begin restoring ${DBNAME} "
   echo "$SCRIPT_HOME/RMAN_Restore_By_SID.sh ${DBNAME} > ${LOG_DIR}/RMAN_${DBNAME}_Full.$START_TIME.log"

   $SCRIPT_HOME/RMAN_Restore_By_SID.sh ${DBNAME} > ${LOG_DIR}/RMAN_${DBNAME}_Restore.$START_TIME.log

   exit 0

fi

####################################################################################################
# Add Another database to backup
####################################################################################################

if [ "${CMD}" = "ADD" ] ; then

   $SCRIPT_HOME/ADD_Database_To_Backup.sh
   
   exit 0

fi

###################################################################################################
# Remove database from backup
####################################################################################################

if [ "${CMD}" = "DEL" ] ; then

   echo "Not Implemented Yet"

   exit 0

fi

exit 0
