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
echo $TARGETDB
export RMANCAT=$2
echo $RMANCAT
export DBNAME=$3
export BACKUP_DIR=$4
export ORACLE_HOME=$5
export PARALELL=$6

# Run backup
export TIMESTAMP=$(date +\%y\%m\%d\%H\%M)
echo "start RMAN ..." 
export TSTAMP=${DBNAME}_backup

echo "$ORACLE_HOME/bin/rman target $TARGETDB catalog $RMANCAT"

$ORACLE_HOME/bin/rman target "$TARGETDB" catalog $RMANCAT <<eof

set echo on;

run {
show all; # show last configuration

CROSSCHECK BACKUP;
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 1 DAYS;
CONFIGURE BACKUP OPTIMIZATION ON;
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '$BACKUP_DIR/${DBNAME}_%F';
CONFIGURE DEVICE TYPE DISK BACKUP TYPE TO COMPRESSED BACKUPSET PARALLELISM ${PARALELL};
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT   '$BACKUP_DIR/%d_%s_%t_%I-${TIMESTAMP}';
CONFIGURE MAXSETSIZE TO 40g;
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO NONE; # default
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '$BACKUP_DIR/${DBNAME}_controlfile';

BACKUP CURRENT CONTROLFILE FOR STANDBY;

SQL 'alter system archive log current';

change archivelog all validate;
host 'echo "** before BACKUP CHECK LOGICAL DATABASE FILESPERSET 1 TAG $TSTAMP *****"';
BACKUP CHECK LOGICAL DATABASE FILESPERSET 1 TAG $TSTAMP PLUS ARCHIVELOG;

host 'echo "** before DELETE FORCE NOPROMPT BACKUP *****"';
DELETE FORCE NOPROMPT OBSOLETE;
host 'echo "** before DELETE FORCE NOPROMPT EXPIRED BACKUP *****"';
DELETE FORCE NOPROMPT EXPIRED BACKUP;

host 'echo "** end RMAN run commands *****"';
}
eof

echo "end   script $SCRIPT_NAME   $(date '+%d %b %Y  %H:%M:%S')"

#host 'echo "** before RECOVER COPY OF DATABASE WITH TAG $TSTAMP UNTIL TIME SYSDATE - 1 *****"';
#RECOVER COPY OF DATABASE WITH TAG $TSTAMP UNTIL TIME 'SYSDATE - 1';
