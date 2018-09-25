#!/bin/bash
clean_up()
{
    echo "Cleaning up..."
	ssh oracle@${DEST_HOST_NAME} "rm -f ${DATA_FILES_DIR_PATH}/exp_qin_${SCHEMA_NAME}_for_reimport.dmp"
	ssh oracle@${DEST_HOST_NAME} "rm -f ${DATA_FILES_DIR_PATH}/exp_qin_${SCHEMA_NAME}_for_reimport.log"
	ssh oracle@${DEST_HOST_NAME} "rm -f ${DATA_FILES_DIR_PATH}/exp_static_${SCHEMA_NAME}_for_reimport.dmp"
	ssh oracle@${DEST_HOST_NAME} "rm -f ${DATA_FILES_DIR_PATH}/exp_static_${SCHEMA_NAME}_for_reimport.log"
	ssh oracle@${DEST_HOST_NAME} "rm -f ${DATA_FILES_DIR_PATH}/exp_plsql_${SCHEMA_NAME}_for_reimport.dmp"
	ssh oracle@${DEST_HOST_NAME} "rm -f ${DATA_FILES_DIR_PATH}/exp_plsql_${SCHEMA_NAME}_for_reimport.log"
	
	rm -f ${PROCESSED_DUMPS_PATH}exp_qin_${SCHEMA_NAME}_for_reimport.dmp
	rm -f ${PROCESSED_DUMPS_PATH}exp_qin_${SCHEMA_NAME}_for_reimport.log
	rm -f ${PROCESSED_DUMPS_PATH}exp_static_${SCHEMA_NAME}_for_reimport.dmp
#	rm -f ${PROCESSED_DUMPS_PATH}exp_static_${SCHEMA_NAME}_for_reimport.log
	rm -f ${PROCESSED_DUMPS_PATH}exp_plsql_${SCHEMA_NAME}_for_reimport.dmp
	rm -f ${PROCESSED_DUMPS_PATH}exp_plsql_${SCHEMA_NAME}_for_reimport.log
	
}

check_for_oracle_errors_exit()
{

    SHOULD_BE_EMPTY=$(grep -i '\(ora-\|sp2-\|Usage 1:sqlplus -H\)' ${1} | grep -vi 'ORA-31684' | grep -vi 'ORA-39082' | grep -vi 'ORA-39151')

	if [[ "${SHOULD_BE_EMPTY}" ]]
	then
	 
	  echo "Got oracle error:"
	 
	  echo ${SHOULD_BE_EMPTY}	 
     
	  echo "Full log can be found in ${1}"
	  clean_up
	  exit 1
	fi
}

if [[ $# -lt 2 ]]     # check number of input arguments
then
    echo "Wrong number of arguments"
	echo "Usage: ./reimport_schema.sh schema_name db_name"	
	exit 1
fi 

SCHEMA_NAME=$1
DB_NAME=$2

ORACLE_FILES_DIR_NAME=DATA_FILES_LOCATION
echo "Starting sanity check..."
echo
echo "Getting source directory path..."
# Get path to dir from source database
DATA_FILES_DIR_PATH=$(sqlplus -s system/manager@${DB_NAME}<<EOF
		set heading off feedback off echo off
		spool dest_dir.log
        select directory_path  from dba_directories where directory_name = upper('${ORACLE_FILES_DIR_NAME}');
		spool off
        exit;
EOF)

check_for_oracle_errors_exit "dest_dir.log"

# Trim newlines
DATA_FILES_DIR_PATH=`echo ${DATA_FILES_DIR_PATH} | tr -d '\n'`

if [[ -z "${DATA_FILES_DIR_PATH}" ]]    
then
    echo "directory ${ORACLE_FILES_DIR_NAME} was not found in source database"
	exit 1
fi 

echo "Source directory path is: ${DATA_FILES_DIR_PATH}"


echo "Getting source host name..."
# Get path to dir from source database
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


echo "Checking if schema is a dump repository schema..."
IS_REPOSITORY_SCHEMA=`sqlplus  -s system/manager@${DB_NAME} @check_if_repository_schema.sql ${SCHEMA_NAME} | tr -d ' ' | tr -d '\n'`

if [ ${IS_REPOSITORY_SCHEMA} == "YES" ]
then
   echo "The schema is dump repository schema"
else
   echo "Schema is not a dump repository_schema"
   exit 1
fi

PROCESSED_DUMPS_PATH=$(sqlplus -s system/manager<<EOF
		set heading off feedback off echo off
		spool dir_for_output.log
        select directory_path  || '/' from dba_directories where directory_name = upper('PROCESSED_DUMPS_DIR');
		spool off
        exit;
EOF)


check_for_oracle_errors_exit "dir_for_output.log"

# Trim newlines
PROCESSED_DUMPS_PATH=`cat dir_for_output.log | tr -d ' ' | tr -d '\n'`

if [[ -z "${PROCESSED_DUMPS_PATH}" ]]    
then
    echo "directory PROCESSED_DUMPS_DIR was not found in database"
	exit 1
fi

echo
echo "Sanity check ended OK."
echo
echo "Locking tablespaces for export..."
sqlplus system/manager@${DB_NAME} @lock_tablespaces_for_export.sql ${SCHEMA_NAME} > /dev/null
check_for_oracle_errors_exit "lock_tablespaces_for_export.log"

echo "Ended OK."




echo "Exporting MSG_QUEUE_IN..."
expdp system/manager@${DB_NAME} dumpfile=exp_qin_${SCHEMA_NAME}_for_reimport.dmp logfile=exp_qin_${SCHEMA_NAME}_for_reimport.log directory=DATA_FILES_LOCATION transport_tablespaces=tbs_qin_${SCHEMA_NAME}  1>/dev/null 2> /dev/null
echo "Checking log..."
scp oracle@${DEST_HOST_NAME}:${DATA_FILES_DIR_PATH}/exp_qin_${SCHEMA_NAME}_for_reimport.log exp_qin_${SCHEMA_NAME}_for_reimport.log
check_for_oracle_errors_exit "exp_qin_${SCHEMA_NAME}_for_reimport.log"
	
echo "Exporting static data..."	
expdp system/manager@${DB_NAME} dumpfile=exp_static_${SCHEMA_NAME}_for_reimport.dmp logfile=exp_static_${SCHEMA_NAME}_for_reimport.log directory=DATA_FILES_LOCATION transport_tablespaces=tbs_static_${SCHEMA_NAME} 1>/dev/null 2> /dev/null
echo "Checking log..."
scp oracle@${DEST_HOST_NAME}:${DATA_FILES_DIR_PATH}/exp_static_${SCHEMA_NAME}_for_reimport.log exp_static_${SCHEMA_NAME}_for_reimport.log	
check_for_oracle_errors_exit "exp_static_${SCHEMA_NAME}_for_reimport.log"
echo "Ended OK."

echo "Exporting metadata..."	
expdp system/manager@${DB_NAME} directory=DATA_FILES_LOCATION dumpfile=exp_plsql_${SCHEMA_NAME}_for_reimport.dmp logfile=exp_plsql_${SCHEMA_NAME}_for_reimport.log schemas=${SCHEMA_NAME} content=metadata_only 1>/dev/null 2> /dev/null
echo "Checking log..."
scp oracle@${DEST_HOST_NAME}:${DATA_FILES_DIR_PATH}/exp_plsql_${SCHEMA_NAME}_for_reimport.log exp_plsql_${SCHEMA_NAME}_for_reimport.log	
check_for_oracle_errors_exit "exp_plsql_${SCHEMA_NAME}_for_reimport.log"
echo "Ended OK."

TEMP_ID=$(date +%Y_%m_%d_%H_%M_%S)


echo "Getting data files..."
sqlplus -s system/manager@${DB_NAME} @get_scp_for_datafiles.sql ${DEST_HOST_NAME} ${PROCESSED_DUMPS_PATH} ${TEMP_ID} ${SCHEMA_NAME} | while read inputline; 
do
        if [[ $inputline ]]
		then
			echo $inputline | xargs scp;
		fi
	
done 
echo "Ended OK."

echo "Getting dump files..."
scp oracle@${DEST_HOST_NAME}:${DATA_FILES_DIR_PATH}/exp_qin_${SCHEMA_NAME}_for_reimport.dmp ${PROCESSED_DUMPS_PATH}exp_qin_${SCHEMA_NAME}_for_reimport.dmp
scp oracle@${DEST_HOST_NAME}:${DATA_FILES_DIR_PATH}/exp_static_${SCHEMA_NAME}_for_reimport.dmp ${PROCESSED_DUMPS_PATH}exp_static_${SCHEMA_NAME}_for_reimport.dmp
scp oracle@${DEST_HOST_NAME}:${DATA_FILES_DIR_PATH}/exp_plsql_${SCHEMA_NAME}_for_reimport.dmp ${PROCESSED_DUMPS_PATH}exp_plsql_${SCHEMA_NAME}_for_reimport.dmp
echo "Ended OK."

echo "Assining new DUMP_ID for the current import..."
# Get path to dir from destination database
DUMP_ID=$(sqlplus -s AUTOMATION_REPO/AUTOMATION_REPO <<EOF
		set heading off feedback off echo off
		spool next_dump_id.log
        select dump_repo_seq.nextval from dual;
		spool off
        exit;
EOF)

check_for_oracle_errors_exit "next_dump_id.log"

# Trim newlines
DUMP_ID=`echo ${DUMP_ID} | tr -d '\n'`

echo "Dump id: ${DUMP_ID}"

sqlplus sys/manager as sysdba @create_user_reimport.sql ${DUMP_ID} > /dev/null

check_for_oracle_errors_exit "create_user_reimport.log" 

echo "Importing MSG_QUEUE_IN using Transportable tablespace..."
impdp system/manager directory=PROCESSED_DUMPS_DIR dumpfile=exp_qin_${SCHEMA_NAME}_for_reimport.dmp logfile=exp_qin_${SCHEMA_NAME}_for_reimport.log transport_datafiles="${PROCESSED_DUMPS_PATH}tmp_qin_${TEMP_ID}.dbf" remap_schema=${SCHEMA_NAME}:dmp_${DUMP_ID}  1>/dev/null 2>/dev/null
check_for_oracle_errors_exit "${PROCESSED_DUMPS_PATH}exp_qin_${SCHEMA_NAME}_for_reimport.log"
echo "Ended OK."
echo "Importing static data using Transportable tablespace..."
impdp system/manager directory=PROCESSED_DUMPS_DIR dumpfile=exp_static_${SCHEMA_NAME}_for_reimport.dmp logfile=exp_static_${SCHEMA_NAME}_for_reimport.log transport_datafiles="${PROCESSED_DUMPS_PATH}tmp_sta_${TEMP_ID}.dbf" remap_schema=${SCHEMA_NAME}:dmp_${DUMP_ID}  1>/dev/null 2>/dev/null
check_for_oracle_errors_exit "${PROCESSED_DUMPS_PATH}exp_static_${SCHEMA_NAME}_for_reimport.log"
echo "Ended OK."
echo "Importing metadata..."
impdp system/manager directory=PROCESSED_DUMPS_DIR dumpfile=exp_plsql_${SCHEMA_NAME}_for_reimport.dmp logfile=exp_plsql_${SCHEMA_NAME}_for_reimport.log transform=oid:n remap_schema=${SCHEMA_NAME}:dmp_${DUMP_ID} parallel=2 1>/dev/null 2>/dev/null
check_for_oracle_errors_exit "${PROCESSED_DUMPS_PATH}exp_plsql_${SCHEMA_NAME}_for_reimport.log"
echo "Ended OK."

echo "Preparing tablespaces for use..."
sqlplus system/manager @prepare_reimported_tablespaces.sql ${SCHEMA_NAME} ${DUMP_ID} ${PROCESSED_DUMPS_PATH} ${TEMP_ID} > /dev/null
check_for_oracle_errors_exit "prepare_reimported_tablespaces.log"
echo "Ended OK."


echo "Exporting with transportable tablespace..."	
    
expdp system/manager dumpfile=exp_qin_${DUMP_ID}.dmp logfile=exp_qin_${DUMP_ID}.log directory=PROCESSED_DUMPS_DIR transport_tablespaces=tbs_qin_${DUMP_ID}  1>/dev/null 2> /dev/null
check_for_oracle_errors_exit "${PROCESSED_DUMPS_PATH}exp_qin_${DUMP_ID}.log"
expdp system/manager dumpfile=exp_static_${DUMP_ID}.dmp logfile=exp_static_${DUMP_ID}.log directory=PROCESSED_DUMPS_DIR transport_tablespaces=tbs_static_${DUMP_ID} 1>/dev/null 2> /dev/null
check_for_oracle_errors_exit "${PROCESSED_DUMPS_PATH}exp_static_${DUMP_ID}.log"
expdp system/manager directory=PROCESSED_DUMPS_DIR dumpfile=exp_plsql_${DUMP_ID}.dmp logfile=exp_plsql_${DUMP_ID}.log schemas=DMP_${DUMP_ID} content=metadata_only 1>/dev/null 2> /dev/null
check_for_oracle_errors_exit "${PROCESSED_DUMPS_PATH}exp_plsql_${DUMP_ID}.log"
echo "Ended OK"

echo "Registering schema..."
sqlplus system/manager @register_reimported_dump.sql ${DUMP_ID} ${SCHEMA_NAME}
check_for_oracle_errors_exit "register_reimported_dump.log"
echo "Ended OK."

echo "Re-opening source schema for read/write..."
sqlplus system/manager@${DB_NAME} @reopen_tablespaces.sql ${SCHEMA_NAME}
check_for_oracle_errors_exit "reopen_tablespaces.log"
echo "Ended OK."

clean_up

echo "Ended succesfully."
