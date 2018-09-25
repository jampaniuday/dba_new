#!/bin/bash


check_for_oracle_errors_exit()
{

    SHOULD_BE_EMPTY=$(grep -i '\(ora-\|sp2-\|Usage 1:sqlplus -H\)' ${1} | grep -vi 'ORA-31684' | grep -vi 'ORA-39082')

	if [[ "${SHOULD_BE_EMPTY}" ]]
	then
	 
	  echo "Got oracle error:"
	 
	  echo ${SHOULD_BE_EMPTY}	 
     
	  echo "Full log can be found in ${1}"
	  exit 1
	fi
}




if [[ $# -lt 3 ]]     # check number of input arguments
then
    echo "Wrong number of arguments"
	echo "Usage: ./install_schema.sh dump_id schema_name db_name generic_version(optional) source_dir(optional) dest_dir(optional)"
	echo "       Use Oracle direcory name, not paths";
	exit 1
fi 

DUMP_ID=$1
SCHEMA_NAME=$2

if [ ${#SCHEMA_NAME} -gt 20 ]
then
	echo "Schema name is too long."
	echo "Use name up to 20 characters long"
	exit 1
fi

DB_NAME=$3

# if parameter 4 is empty use default
if [[ -z $4 ]]
then
	GENERIC_VERSION=""
else
	GENERIC_VERSION=$4
fi

# if parameter 5 is empty use default
if [[ -z $5 ]]
then
	ORACLE_SOURCE_DIR_NAME=PROCESSED_DUMPS_DIR
else
	ORACLE_SOURCE_DIR_NAME=$5
fi

# if parameter 5 is empty use default
if [[ -z $6 ]]
then
	ORACLE_DEST_DIR_NAME=DATA_FILES_LOCATION
else
	ORACLE_DEST_DIR_NAME=$6
fi



echo "Getting source directory path..."

# Get path to dir from source database
SOURCE_DIR_PATH=$(sqlplus -s system/manager<<EOF
		set heading off feedback off echo off
		spool source_dir.log
        select directory_path from dba_directories where directory_name = upper('${ORACLE_SOURCE_DIR_NAME}');
		spool off
        exit;
EOF)

#echo "source dir path: ${SOURCE_DIR_PATH}"

check_for_oracle_errors_exit "source_dir.log"

# Trim newlines
SOURCE_DIR_PATH=`echo ${SOURCE_DIR_PATH} | tr -d '\n'`

if [[ -z "${SOURCE_DIR_PATH}" ]]    
then
    echo "directory ${ORACLE_SOURCE_DIR_NAME} was not found in source database"
	exit 1
fi 

echo "Source directory path is: ${SOURCE_DIR_PATH}"


echo "Getting destination directory path..."
# Get path to dir from destination database
DEST_DIR_PATH=$(sqlplus -s system/manager@${DB_NAME}<<EOF
		set heading off feedback off echo off
		spool dest_dir.log
        select directory_path  from dba_directories where directory_name = upper('${ORACLE_DEST_DIR_NAME}');
		spool off
        exit;
EOF)

check_for_oracle_errors_exit "dest_dir.log"

# Trim newlines
DEST_DIR_PATH=`echo ${DEST_DIR_PATH} | tr -d '\n'`

if [[ -z "${DEST_DIR_PATH}" ]]    
then
    echo "directory ${ORACLE_DEST_DIR_NAME} was not found in destination database"
	exit 1
fi 

echo "Destination directory path is: ${DEST_DIR_PATH}"


echo "Getting destination host name..."
# Get path to dir from destination database
DEST_HOST_NAME=$(sqlplus -s system/manager@${DB_NAME}<<EOF
		set heading off feedback off echo off
		spool dest_host.log
        select host_name from v\$instance where rownum < 2;
		spool off
        exit;
EOF)

check_for_oracle_errors_exit "dest_host.log"

# Trim newlines
DEST_HOST_NAME=`echo ${DEST_HOST_NAME} | tr -d '\n'`

if [[ -z "${DEST_HOST_NAME}" ]]    
then
    echo "host name was not found in destination database"
	exit 1
fi 

echo "Destination host name is: ${DEST_HOST_NAME}"

TOTAL_SIZE=0
for i in `ls -l ${SOURCE_DIR_PATH}/*_${DUMP_ID}.dbf | awk '/.*/ {print $5}'` 
do 
	TOTAL_SIZE=$(($TOTAL_SIZE + $i)) 
done

TOTAL_SIZE=$(($TOTAL_SIZE / 1024)) 

echo "Total data file size: ${TOTAL_SIZE}k"

FREE_SPACE=$(ssh oracle@${DEST_HOST_NAME} "df -P ${DEST_DIR_PATH}" | tail -1 | awk '/.*/ {print $4}')

echo "Free space in ${DEST_DIR_PATH}: ${FREE_SPACE}k"

if [[ ${TOTAL_SIZE} -gt ${FREE_SPACE} ]]
then
	echo "Not enough space to copy dumps."
	echo "Space needed: ${TOTAL_SIZE}k."
	echo "Space available: ${FREE_SPACE}k."
	exit 1
fi

echo "Started: "`date`

echo "Copying data file ${SOURCE_DIR_PATH}/static_${DUMP_ID}.dbf to ${DEST_DIR_PATH}/static_${DUMP_ID}_${SCHEMA_NAME}.dbf..."
scp ${SOURCE_DIR_PATH}/static_${DUMP_ID}.dbf oracle@${DEST_HOST_NAME}:${DEST_DIR_PATH}/${SCHEMA_NAME}_static_from_dump_${DUMP_ID}.dbf

echo "Copying dump file ${SOURCE_DIR_PATH}/exp_static_${DUMP_ID}.dmp to ${DEST_DIR_PATH}/exp_static_${DUMP_ID}_${SCHEMA_NAME}.dmp..."
scp ${SOURCE_DIR_PATH}/exp_static_${DUMP_ID}.dmp oracle@${DEST_HOST_NAME}:${DEST_DIR_PATH}/${SCHEMA_NAME}_exp_static_${DUMP_ID}.dmp

echo "Copying data file ${SOURCE_DIR_PATH}/qin_${DUMP_ID}.dbf to ${DEST_DIR_PATH}/qin_${DUMP_ID}_${SCHEMA_NAME}.dbf..."
scp ${SOURCE_DIR_PATH}/qin_${DUMP_ID}.dbf oracle@${DEST_HOST_NAME}:${DEST_DIR_PATH}/${SCHEMA_NAME}_qin_from_dump_${DUMP_ID}.dbf

echo "Copying dump file ${SOURCE_DIR_PATH}/exp_qin_${DUMP_ID}.dmp to ${DEST_DIR_PATH}/exp_qin_${DUMP_ID}_${SCHEMA_NAME}.dmp..."
scp ${SOURCE_DIR_PATH}/exp_qin_${DUMP_ID}.dmp oracle@${DEST_HOST_NAME}:${DEST_DIR_PATH}/${SCHEMA_NAME}_exp_qin_${DUMP_ID}.dmp

scp ${SOURCE_DIR_PATH}/exp_plsql_${DUMP_ID}.dmp oracle@${DEST_HOST_NAME}:${DEST_DIR_PATH}/${SCHEMA_NAME}_exp_plsql_${DUMP_ID}.dmp

echo "Creating schema ${SCHEMA_NAME} on database ${DB_NAME}..."
sqlplus system/manager@${DB_NAME} @create_destination_schema.sql ${SCHEMA_NAME} > /dev/null

check_for_oracle_errors_exit "create_destination_schema.log" 

echo "Importing MSG_QUEUE_IN..."
impdp system/manager@${DB_NAME} directory=${ORACLE_DEST_DIR_NAME} dumpfile=${SCHEMA_NAME}_exp_qin_${DUMP_ID}.dmp logfile=${SCHEMA_NAME}_exp_qin_${DUMP_ID}.implog transport_datafiles="${DEST_DIR_PATH}/${SCHEMA_NAME}_qin_from_dump_${DUMP_ID}.dbf" remap_schema=DMP_${DUMP_ID}:${SCHEMA_NAME} 1>/dev/null 2>/dev/null

echo "Checking log..."
scp oracle@${DEST_HOST_NAME}:${DEST_DIR_PATH}/${SCHEMA_NAME}_exp_qin_${DUMP_ID}.implog ${SCHEMA_NAME}_exp_qin_${DUMP_ID}.implog
check_for_oracle_errors_exit "${SCHEMA_NAME}_exp_qin_${DUMP_ID}.implog" 

echo "Importing static data..."
impdp system/manager@${DB_NAME} directory=${ORACLE_DEST_DIR_NAME} dumpfile=${SCHEMA_NAME}_exp_static_${DUMP_ID}.dmp logfile=${SCHEMA_NAME}_exp_static_${DUMP_ID}.implog transport_datafiles="${DEST_DIR_PATH}/${SCHEMA_NAME}_static_from_dump_${DUMP_ID}.dbf" remap_schema=DMP_${DUMP_ID}:${SCHEMA_NAME}  1>/dev/null 2>/dev/null

echo "Checking log..."
scp oracle@${DEST_HOST_NAME}:${DEST_DIR_PATH}/${SCHEMA_NAME}_exp_static_${DUMP_ID}.implog ${SCHEMA_NAME}_exp_static_${DUMP_ID}.implog
check_for_oracle_errors_exit "${SCHEMA_NAME}_exp_static_${DUMP_ID}.implog" 

echo "Importing static data..."
sqlplus system/manager@${DB_NAME} @rename_and_open_tablespaces.sql ${DUMP_ID} ${SCHEMA_NAME} > /dev/null
check_for_oracle_errors_exit "rename_and_open_tablespaces.log"

impdp system/manager@${DB_NAME} directory=${ORACLE_DEST_DIR_NAME} dumpfile=${SCHEMA_NAME}_exp_plsql_${DUMP_ID}.dmp logfile=${SCHEMA_NAME}_exp_plsql_${DUMP_ID}.implog remap_schema=DMP_${DUMP_ID}:${SCHEMA_NAME} TABLE_EXISTS_ACTION=SKIP  1>/dev/null 2>/dev/null

if [[ -n ${GENERIC_VERSION} ]]
then
   ./refresh_generic.sh
   HOME_DIR=$(pwd)
   LOG_FILE=${HOME_DIR}/upgrade_$(date +%Y_%m_%d_%H_%M_%S).log
   echo "starting upgrade, logging into : ${LOG_FILE}..."
   cd /home/oracle/upgrade/db/inc/generic/upgrade
   ./upgrade_script.sh ${SCHEMA_NAME} ${SCHEMA_NAME} ${DB_NAME} ${GENERIC_VERSION} > ${LOG_FILE}
   cd -
fi

echo "ended: "`date`
