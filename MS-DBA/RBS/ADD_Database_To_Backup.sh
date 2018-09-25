#!/bin/bash
# 30.06.2009 - Oded Raz - Add new database to backup system
# This script adds a new database to our automated backup system, the following tasks are followd when adding new database to the backup :
# - Add that perform the RMAN full database backup and the RMAN incremental backup,
# and sends e-mail after each backup.


######################################################################################
# Setup script parameters
######################################################################################

ENV_FILE=./rman.env
echo " \$ENV_FILE = $ENV_FILE"
echo " "

#set -x
# Check for environment file

if [ -f "${ENV_FILE}" ] ; then
. $ENV_FILE
else
echo "Env file not found, add database script terminated"
exit 1
fi

#======================================= Script Starts Here =========================#

######################################################################################
# Get Database version and set ORACLE_HOME properly
######################################################################################

read -p "Please enter the database version of the database you want to backup [EE/SE] => " BACK_VERSION

while [ "$BACK_VERSION" != "EE" -a "$BACK_VERSION" != "SE" ]
do
   read -p "Please enter valid database version [EE/SE] => " BACK_VERSION
done

if  [ "$BACK_VERSION" = "EE" ]  ; then
	export ORACLE_HOME=$ORACLE_HOME_EE
else
	export ORACLE_HOME=$ORACLE_HOME_SE
fi

######################################################################################
# Get Database version and set ORACLE_HOME properly
######################################################################################

read -p "Please enter the SID of the database you want to backup => " BACK_SID 


SID_CHECK=`$ORACLE_HOME/bin/tnsping $BACK_SID |grep OK | awk '{print $1}'`

    if [ "$SID_CHECK" = "OK" ] ; then

	echo " $BACK_SID already exsits, please retry ... "

    else


	read -p "Please Enter machine name / IP of the Database you want to backup => " BACKUP_HOSTNAME

        read -p "Please Enter Database listening port => " BACKUP_PORT

	cat >> $ORACLE_HOME/network/admin/tnsnames.ora <<EOF

${BACK_SID} =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = $BACKUP_HOSTNAME)(PORT = $BACKUP_PORT))
    )
    (CONNECT_DATA =
      (SID = ${BACK_SID})
    )
  )

${BACK_SID}_SBY =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = $RESTORE_HOSTNAME)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SID = ${BACK_SID})
    )
  )

EOF


    fi

SID_CHECK=`$ORACLE_HOME/bin/tnsping $BACK_SID |grep OK | awk '{print $1}'`

while [ "$SID_CHECK" != "OK" ]
do

   read -p " TNS enrty is invalid, please reEnter TNS credentials !"

   read -p "Please Enter machine name / IP of the Database you want to backup => " BACKUP_HOSTNAME

   read -p "Please Enter Database listening port => " BACKUP_PORT

   cat >> $ORACLE_HOME/network/admin/tnsnames.ora <<EOF

${BACK_SID} =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = $BACKUP_HOSTNAME)(PORT = $BACKUP_PORT))
    )
    (CONNECT_DATA =
      (SID = ${BACK_SID})
    )
  )

${BACK_SID}_SBY =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = $RESTORE_HOSTNAME)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SID = ${BACK_SID})
    )
  )


EOF


   SID_CHECK=`$ORACLE_HOME/bin/tnsping $BACK_SID |grep OK | awk '{print $1}'`

done

$ORACLE_HOME/bin/tnsping $BACK_SID
echo " "
echo " TNS was updated succesfully"

######################################################################
# Get Backup directory
#######################################################################

read -p "Please enter the backups directory, where the backup files will reside => " BACKUP_DIR

while [ ! -d "$BACKUP_DIR" ]
do
   read -p "Backup directory doesn't exists, Please enter valid backup directory => " BACKUP_DIR
done


#######################################################################
# Get Log Directory
#######################################################################

read -p "Please enter the backups log directory, where the log files will be placed => " LOG_DIR

while [ ! -d "$LOG_DIR" ]
do
   read -p "Log directory doesn't exists, Please enter valid log directory => " LOG_DIR
done

#######################################################################
# Get Backuped database password
#######################################################################

read -p "Please enter a valid sys password for ${BACK_SID} database => " SYS_PSWD

export PASSWD_RC=`$ORACLE_HOME/bin/sqlplus sys/$SYS_PSWD@$BACK_SID as sysdba <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
exit;
%SQL%`

export PASSWD_RC=`echo ${PASSWD_RC} |grep Connected | awk '{print $1}'`

while [ x${PASSWD_RC} = x ]
do

   read -p "SYS password is incorrect, Please enter a valid sys password for ${BACK_SID} database  => " SYS_PSWD

   export PASSWD_RC=`$ORACLE_HOME/bin/sqlplus sys/$SYS_PSWD@$BACK_SID as sysdba <<%SQL%
   set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
   exit;
   %SQL%`

   export PASSWD_RC= `echo ${PASSWD_RC} |grep Connected | awk '{print $1}'`

done

#######################################################################
# Get Export Needed Paramters
#######################################################################

read -p "Please backup storage IP, where the snapshots resides => " STORAGE_IP
read -p "Please EXPORT backup volume => " BACKUP_VOLUME

#######################################################################
# Update table 
#######################################################################

export INSERT_RC=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
DELETE FROM TR_BACKUP_PARAMETERS WHERE DB_NAME='${BACK_SID}';
INSERT INTO TR_BACKUP_PARAMETERS(DB_NAME,FULL_BCKUP_SCHED,DAILY_BACKUP_SCHED,BACKUP_DIR,LOG_DIR,SYS_PASS,EDITION,STORAGE_IP,VOLUME_NAME) VALUES('${BACK_SID}',1,1,'${BACKUP_DIR}','${LOG_DIR}','${SYS_PSWD}','${BACK_VERSION}','${STORAGE_IP}','${BACKUP_VOLUME}');
%SQL%`

echo $INSERT_RC

#######################################################################
# Create new auxeliry database passowrd file
#######################################################################

if [ -f "$ORACLE_HOME/dbs/orapwr$BACK_SID" ] ; then
   rm $ORACLE_HOME/dbs/orapwr$BACK_SID   
fi

orapwd file=$ORACLE_HOME/dbs/orapwr$BACK_SID password=oracle entries=10
echo "Password file created ..."
echo " "

#######################################################################
# Get Archive location 
#######################################################################

export ARCH_DEST=`$ORACLE_HOME/bin/sqlplus -x -s sys/$SYS_PSWD@$BACK_SID as sysdba <<%SQL%
set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
select VALUE from v\\$parameter where NAME='log_archive_dest_1';
exit;
%SQL%`

export ARCH_DEST=${ARCH_DEST//\//\\/}

echo "Archive Dest Retrived =>${ARCH_DEST}"

#######################################################################
# Create new oracle pfile
#######################################################################

sed -e "s/REPLACE_SID/$BACK_SID/g" $SCRIPT_HOME/init_template.ora > $ORACLE_HOME/dbs/init$BACK_SID.ora
sed -e "s/REPLACE_ARCH/$ARCH_DEST/g" $ORACLE_HOME/dbs/init$BACK_SID.ora

#######################################################################
# Create dump direcotries
#######################################################################

if [ ! -d "$DUMP_DIRECTORY/$BACK_SID" ]; then
    mkdir -p $DUMP_DIRECTORY/$BACK_SID
fi

if [ ! -d "$DUMP_DIRECTORY/$BACK_SID/adump" ]; then
    mkdir -p $DUMP_DIRECTORY/$BACK_SID/adump
fi

if [ ! -d "$DUMP_DIRECTORY/$BACK_SID/bdump" ]; then
    mkdir -p $DUMP_DIRECTORY/$BACK_SID/bdump
fi

if [ ! -d "$DUMP_DIRECTORY/$BACK_SID/cdump" ]; then
    mkdir -p $DUMP_DIRECTORY/$BACK_SID/cdump
fi

if [ ! -d "$DUMP_DIRECTORY/$BACK_SID/udump" ]; then
    mkdir -p $DUMP_DIRECTORY/$BACK_SID/udump
fi

#######################################################################
# Create standby control file
#######################################################################

