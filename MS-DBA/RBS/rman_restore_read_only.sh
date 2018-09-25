#!/bin/bash
################################################################################
# 14.06.2009 - Oded - Full RMAN backup
#
# Description : This script takes a full backup of the Database
#
# This script is called from RMAN_Main_Backup_Script.sh
#
# Usage : rman_full_backup.sh <TARGETDB_STRING> <RMANCATALOG_STRING> <DBNAME> <BACKUP_DIR>
#
# Assumptions: Retention Policy is 7 days & 1st day 0 Level backup, subsequent
# days 1 level backup on 8th day 1st incremental backup will get merged with 0
# level backup and so on so recovery windows will be 7 days

# alter database enable block change tracking using file '/oradata/dbtrm/dbf/rman_change_tracking';
# alter system set db_block_checking = true         scope=both;    -- 1% - 10% overhead  ? MAXCORRUPT / NOCHECKSUM
# alter system set control_file_record_keep_time=14 scope=both;
################################################################################

SCRIPT_NAME=$(dirname $0)/$(basename $0)
echo "start script $SCRIPT_NAME   $(date '+%d %b %Y  %H:%M:%S')"

export TARGETDB=$1
#echo $TARGETDB
export RMANCAT=$2
#echo $RMANCAT
export AUX_DB=$3
export ORACLE_HOME=$4
export UNTIL_DATE=$5
# Run backup
export TIMESTAMP=$(date +\%y\%m\%d\%H\%M)
echo "start RMAN ..." 
export TSTAMP=${DBNAME}_backup

################################################################################
# Login to RMAN using catalog - using auxiliry for new database
################################################################################
echo $ORACLE_HOME/bin/rman target "$TARGETDB" catalog $RMANCAT  auxiliary "$AUX_DB" 
echo $UNTIL_DATE

$ORACLE_HOME/bin/rman target "$TARGETDB" catalog $RMANCAT  auxiliary "$AUX_DB" <<eof

set echo on;

run {
allocate auxiliary channel d1 type disk;
SET UNTIL TIME "TO_DATE($UNTIL_DATE,' DD-MM-YYYY HH24:MI:SS ')";
duplicate target database for standby DORECOVER NOFILENAMECHECK;
}
eof

echo "end   script $SCRIPT_NAME   $(date '+%d %b %Y  %H:%M:%S')"

