#!/bin/bash

# Parameter check
if [[ $# -ne 2 ]]     # is number of input arguments is different then 2
then
    echo "Wrong number of arguments"
	echo "Usage: ./process_dir.sh dir_to_process dir_for_output"
	echo "       Use Oracle direcory name, not paths";
	exit 1
fi 

# Environment variables

PID=$$ # Linux process id

DIR_TO_PROCESS=$1 # Oracle directory on local DB server pointing to a linux directory containing the dumps to process
DIR_FOR_OUTPUT=$2 # Oracle directory on local DB server pointing to a linux directory where the processed dumps should be stored

SYSTEM_PASSWORD=manager # Oracle SYSTEM user password

################################################################################
#
# Check for oracle errors, and if failed - exit process_dir script alltogether
#
################################################################################
check_for_oracle_errors_exit()
{
    
	# Find rows containing "ora-", "sp2-" and SQL*PLUS failed login (should be empty)
    SHOULD_BE_EMPTY=$(grep -i '\(ora-\|sp2-\|Usage 1:sqlplus -H\)' ${1} | grep -vi 'ORA-31684' | grep -vi 'ORA-39082')
	
	# If errors were found
	if [[ "${SHOULD_BE_EMPTY}" ]]
	then
	 
	  echo "Got oracle error:"	 
	  echo ${SHOULD_BE_EMPTY}	      
	  echo "Full log can be found in ${1}"
	  exit 1
	fi
}

################################################################################
#
# Check for oracle errors, and if failed - stop processing current dump and continue to next loop cycle
#
################################################################################
check_for_oracle_errors_continue()
{

	# Find rows containing "ora-", "sp2-" and SQL*PLUS failed login (should be empty)
    SHOULD_BE_EMPTY=$(grep -i '\(ora-\|sp2-\|Usage 1:sqlplus -H\)' ${1} | grep -vi 'ORA-31684' | grep -vi 'ORA-39082')

	# If errors were found
	if [[ "${SHOULD_BE_EMPTY}" ]]
	then
	  
	  echo "Got oracle error:"	  
	  echo ${SHOULD_BE_EMPTY}	  
	  echo "Full log can be found in ${1}"	  
	  echo "Removing ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql..."
	  	  
	  # Delete schemasql file (just a small cleanup)
	  rm -f ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql
	  continue
	fi
}

################################################################################
#
# Check for oracle errors, and if failed - stop processing current dump, drop the created schema and continue to next loop cycle
#
################################################################################
check_for_oracle_errors_drop_continue()
{
	# Find rows containing "ora-", "sp2-" and SQL*PLUS failed login (should be empty)
    SHOULD_BE_EMPTY=$(grep -i '\(ora-\|sp2-\|Usage 1:sqlplus -H \| -V\)' ${1})
	
	# If errors were found
	if [[ "${SHOULD_BE_EMPTY}" ]]
	then

	  echo "Got oracle error:"
	  echo ${SHOULD_BE_EMPTY}	  
	  echo "Full log can be found in ${1}"	  
	  echo "Dropping schema ${2}..."
	  # Drop schema
	  sqlplus system/${SYSTEM_PASSWORD} @drop_user.sql ${2} > /dev/null
	  
	  
	  echo "Removing ${DIR_TO_PROCESS_PATH}/${2}.schemasql..."
	  
	  # Delete schemasql file (just a small cleanup)
	  rm -f ${DIR_TO_PROCESS_PATH}/${2}.schemasql
	  continue
	fi
}




# Get linux path to dir from database
DIR_TO_PROCESS_PATH=$(sqlplus -s system/${SYSTEM_PASSWORD}<<EOF
		set heading off feedback off echo off
		spool dir_to_process.log
        select directory_path || '/' from dba_directories where directory_name = upper('${DIR_TO_PROCESS}');
		spool off
        exit;
EOF)

# Check for errors
check_for_oracle_errors_exit "dir_to_process.log"

# Trim newlines
DIR_TO_PROCESS_PATH=`cat dir_to_process.log | tr -d ' ' | tr -d '\n'`

# if directory was not found, exit script
if [[ -z "${DIR_TO_PROCESS_PATH}" ]]    
then
    echo "1 directory ${DIR_TO_PROCESS} was not found in database"
	exit 1
fi 

# Get linux path to dir from database
DIR_FOR_OUTPUT_PATH=$(sqlplus -s system/${SYSTEM_PASSWORD}<<EOF
		set heading off feedback off echo off
		spool dir_for_output.log
        select directory_path  || '/' from dba_directories where directory_name = upper('${DIR_FOR_OUTPUT}');
		spool off
        exit;
EOF)

# Check for errors
check_for_oracle_errors_exit "dir_for_output.log"

# Trim newlines
DIR_FOR_OUTPUT_PATH=`cat dir_for_output.log | tr -d ' ' | tr -d '\n'`

# if directory was not found, exit script
if [[ -z "${DIR_FOR_OUTPUT_PATH}" ]]    
then
    echo "2 directory ${DIR_FOR_OUTPUT} was not found in database"
	exit 1
fi


echo "*  unzipping *.gz files in direcory ${DIR_TO_PROCESS_PATH}..."
gunzip ${DIR_TO_PROCESS_PATH}*.gz
echo "Ended OK"

echo "*  processing direcory ${DIR_TO_PROCESS_PATH}..."

# for each file in the DIR_TO_PROCESS directory matching the pattern *.dmp or *.expdp
for i in `ls ${DIR_TO_PROCESS_PATH} | egrep '.*\.expdp$|.*\.dmp$' | xargs -n1 basename` 
do 
    
	echo "*  processing file ${i}..."
	
	# Generate a temporary schema name
	TEMP_SCHEMA=TMP_$(date +%Y_%m_%d_%H_%M_%S)
	
	echo "Step 1 of 14: importing only ddl from dump into ${DIR_TO_PROCESS_PATH}${TEMP_SCHEMA}.schemasql..."
	
	# Create a a file named {temp schema name}.schemasql containing DDL for creating the schema
    impdp system/${SYSTEM_PASSWORD} dumpfile=${i} logfile=${i}.implog directory=${DIR_TO_PROCESS} sqlfile=${TEMP_SCHEMA}.schemasql content=metadata_only parallel=2 1>/dev/null 2> /dev/null
	
	# Check for errors
	check_for_oracle_errors_continue "${DIR_TO_PROCESS_PATH}${i}.implog"
	echo "Ended OK"
	
	
	echo "Step 2 of 14: search sql file ${DIR_TO_PROCESS_PATH}${TEMP_SCHEMA}.schemasql for pattern \"CREATE USER\" and taking schema name from there..."	
	
    # Get schema name from the schemasql file (search for "create user" pattern) to find out the original schema name (where the dump came from)
	SCHEMA_NAME=$(grep "CREATE USER"  ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql | cut -d\" -f2)
	
	# Echo the original schema name
	echo "Ended OK. Schema name from sql file is: ${SCHEMA_NAME}" 
	
	echo "Step 3 of 14: creating temporary schema named ${TEMP_SCHEMA}..."
	
	# Create a temporary user for schema
	sqlplus system/${SYSTEM_PASSWORD} @create_user_temp.sql ${TEMP_SCHEMA} > /dev/null
	
	# Check for errors and in case of failure drop the temporary schema
	check_for_oracle_errors_drop_continue "create_user_temp.log" ${TEMP_SCHEMA}
	
	echo "Ended OK"
	
			
	# grep only MY grants. 
	GRANT=$(grep -oi '^grant[ ]*[A-Z]*[ ]*on.*to[ ]*\"[A-Z_]*\"' ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql | grep -oi 'TO[ ]*".*' | cut -d\" -f2 | grep -v "^${SCHEMA_NAME}$" | head -1)	
	
	# if there are grants in sql file exclude them
	if [ -n "${GRANT}" ]
	then
	   
	   # Exclude grants in a "White list" situation
	   EXCLUDE_GRANTS="include=GRANT:\"=\'\'\""
	   
	   # Exclude grants in a "Black list" situation
	   EXCLUDE_GRANTS_STATIC="exclude=GRANT"
	else
	
	   # Do not exclude grants
	   EXCLUDE_GRANTS=""
	fi
	
	# Create a paramater file for temporary schema combining 2 par_template files	
	
	# 1. Containing include for IC_CNFG_INSTANCE and V_CURRENT_PRODUCT_VERSION
	cat imp_cnfg_instance.par_template > parameters_for_${i}.par
	# 2. Containing (or at least should contain) remaps from every tablespace name known to man (including PROD and UAT) to USERS
	cat remaps.par_template >> parameters_for_${i}.par
	
	echo "Step 4 of 14: importing dump file ${i} into schema ${TEMP_SCHEMA} (only IC_CNFG_INSTANCE and V_CURRENT_PRODUCT_VERSION)..."
	
	# Import using created parameter file (IC_CNFG_INSTANCE and V_CURRENT_PRODUCT_VERSION only)
	impdp system/${SYSTEM_PASSWORD} dumpfile=${i} logfile=${i}.implog directory=${DIR_TO_PROCESS} parfile=parameters_for_${i}.par schemas=${SCHEMA_NAME} remap_schema=${SCHEMA_NAME}:${TEMP_SCHEMA} ${EXCLUDE_GRANTS} transform=oid:n parallel=2 1>/dev/null 2> /dev/null
	
	# Check for errors and in case of failure drop the temporary schema 
	check_for_oracle_errors_drop_continue "${DIR_TO_PROCESS_PATH}${i}.implog" ${TEMP_SCHEMA}
	
	# Clear parameter file and log for temporary schema
	rm -f parameters_for_${i}.par
	rm -f ${i}.implog
	
	echo "Ended OK"
	
	
	echo "Step 5 of 14: registring dump ${i} in repository..."
	
    # Register dump in repository (using the data imported in to temporary schema (IC_CNFG_INSTANCE and V_CURRENT_PRODUCT_VERSION) 
	sqlplus system/${SYSTEM_PASSWORD} @register_dump.sql ${TEMP_SCHEMA} ${i} ${SCHEMA_NAME} ${PID} > /dev/null
	
	# Check for errors and in case of failure drop the temporary schema 
	check_for_oracle_errors_drop_continue "register_dump.log" ${TEMP_SCHEMA}
	
	# Get the ID assigned to the new dump from log
	DUMP_ID=$(cat register_dump.log | tr -d ' ' | tr -d '\n')	
	
	echo "Dump file ${i} registered in repository. Repository ID for dump is ${DUMP_ID}..."		
	echo "Ended OK"
	
	echo "Step 6 of 14: removing temporary sql file ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql..."
	# Cleanup
	rm -f ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql
	rm -f register_dump.sql
	echo "Ended OK"
	
	echo "Step 7 of 14: dropping temporary schema ${TEMP_SCHEMA}..."

	# Drop temporary schema
	sqlplus system/${SYSTEM_PASSWORD} @drop_user.sql ${TEMP_SCHEMA} > /dev/null
	
	# Check for errors
	check_for_oracle_errors_continue "drop_user.log"
	
	# Generate constant schema name for dump (DMP_{DUMP_ID})
	DUMP_SCHEMA=DMP_${DUMP_ID}
	
	echo "Ended OK"
	
	echo "Step 8 of 14: creating contant schema ${DUMP_SCHEMA}..."
	# Create the constant schema. Tablsepaces datafiles are placed in DIR_FOR_OUTPUT
	sqlplus system/${SYSTEM_PASSWORD} @create_user_transportable.sql ${DUMP_ID} ${DIR_FOR_OUTPUT_PATH} > /dev/null
    
	# Check for errors and in case of failure drop the constant schema 
	check_for_oracle_errors_drop_continue "create_user_transportable.log" ${DUMP_SCHEMA}	
	
	echo "Ended OK"
	
	echo "Step 9 of 14: importing dump file ${i} into schema ${DUMP_SCHEMA} (only MSG_QUEUE_IN)..."	
    
	# Create a paramater file for QIN tablespace combining 2 par_template files	
	
	# 1. Containing include for MSG_QUEUE_IN and MSG_QUEUE_IN_DATA
	cat imp_msg_queue_in.par_template > parameters_for_dump_${DUMP_ID}_qin.par
	
	# 2. Eemaps from every tablespace name known to man (including PROD and UAT) to schema's QIN tablespace
	cat remaps.par_template | sed "s/USERS/TBS_QIN_${DUMP_ID}/g" >> parameters_for_dump_${DUMP_ID}_qin.par
	echo "remap_tablespace=USERS:TBS_QIN_${DUMP_ID}" >> parameters_for_dump_${DUMP_ID}_qin.par
	
	# Import MSG_QUEUE_IN and MSG_QUEUE_IN_DATA to schema's QIN tablespace
	impdp system/${SYSTEM_PASSWORD} dumpfile=${i} logfile=${i}.implog directory=${DIR_TO_PROCESS} parfile=parameters_for_dump_${DUMP_ID}_qin.par schemas=${SCHEMA_NAME} remap_schema=${SCHEMA_NAME}:${DUMP_SCHEMA} ${EXCLUDE_GRANTS} transform=oid:n parallel=2 1>/dev/null 2> /dev/null

	# Check for errors
    check_for_oracle_errors_continue "${DIR_TO_PROCESS_PATH}${i}.implog"
	
	echo "Ended OK"
	
	echo "Step 10 of 14: importing dump file ${i} into schema ${DUMP_SCHEMA}, excluding big tables and MSG_QUEUE_IN..."	
    
	# Create a paramater file for STATIC tablespace combining 2 par_template files	
	
	#  if there is a file named ${DIR_TO_PROCESS}.static.par_template in ./directory_parfiles/ then 
	if [ -e ./directory_parfiles/${DIR_TO_PROCESS}.static.par_template ]
	then
	    echo "Using parfile ../directory_parfiles/${DIR_TO_PROCESS}.static.par_template for import..."
		# 1. Use directory's par_template
	    cat ./directory_parfiles/${DIR_TO_PROCESS}.static.par_template > parameters_for_dump_${DUMP_ID}_static.par
	else
	    
		# 1. Use default (exclude QIN) par_template
		cat imp_excluded.par_template > parameters_for_dump_${DUMP_ID}_static.par
	fi
	
	# 2. Eemaps from every tablespace name known to man (including PROD and UAT) to schema's STATIC tablespace
    cat remaps.par_template | sed "s/USERS/TBS_STATIC_${DUMP_ID}/g" >> parameters_for_dump_${DUMP_ID}_static.par
	echo "remap_tablespace=USERS:TBS_STATIC_${DUMP_ID}" >> parameters_for_dump_${DUMP_ID}_static.par
    impdp system/${SYSTEM_PASSWORD} dumpfile=${i} logfile=${i}.implog directory=${DIR_TO_PROCESS} parfile=parameters_for_dump_${DUMP_ID}_static.par schemas=${SCHEMA_NAME} remap_schema=${SCHEMA_NAME}:${DUMP_SCHEMA} ${EXCLUDE_GRANTS_STATIC} TABLE_EXISTS_ACTION=SKIP transform=oid:n parallel=2  1>/dev/null 2> /dev/null
    
	# Check for errors
	check_for_oracle_errors_continue "${DIR_TO_PROCESS_PATH}${i}.implog"
	echo "Ended OK"
	
    echo "Step 11 of 14: marking tablespaces as read only..."	
    
	# Mark schema's tablespaces as read only (for transportable tablespace export)
	sqlplus sys/${SYSTEM_PASSWORD} as sysdba @mark_tablespaces_as_read_only ${DUMP_ID} > /dev/null
	
	#  Check for errors
	check_for_oracle_errors_continue "mark_tablespaces_as_read_only.log" 
	
	echo "Ended OK"
	
	echo "Step 12 of 14: exporting with transportable tablespace..."	
    
	# Export QIN tablespace using transportable tablespace. Dump file is saved in DIR_FOR_OUTPUT
	expdp system/${SYSTEM_PASSWORD} dumpfile=exp_qin_${DUMP_ID}.dmp logfile=exp_qin_${DUMP_ID}.log directory=${DIR_FOR_OUTPUT} transport_tablespaces=tbs_qin_${DUMP_ID}  1>/dev/null 2> /dev/null
	
	#  Check for errors
	check_for_oracle_errors_continue "${DIR_FOR_OUTPUT_PATH}exp_qin_${DUMP_ID}.log"
	
	# Export STATIC tablespace using transportable tablespace. Dump file is saved in DIR_FOR_OUTPUT
	expdp system/${SYSTEM_PASSWORD} dumpfile=exp_static_${DUMP_ID}.dmp logfile=exp_static_${DUMP_ID}.log directory=${DIR_FOR_OUTPUT} transport_tablespaces=tbs_static_${DUMP_ID} 1>/dev/null 2> /dev/null
	
	#  Check for errors
	check_for_oracle_errors_continue "${DIR_FOR_OUTPUT_PATH}exp_static_${DUMP_ID}.log"
	
	# export metadata only using regular expdp
	expdp system/${SYSTEM_PASSWORD} directory=${DIR_FOR_OUTPUT} dumpfile=exp_plsql_${DUMP_ID}.dmp logfile=exp_plsql_${DUMP_ID}.log schemas=DMP_${DUMP_ID} content=metadata_only 1>/dev/null 2> /dev/null
	
	#  Check for errors
	check_for_oracle_errors_continue "${DIR_FOR_OUTPUT_PATH}exp_plsql_${DUMP_ID}.log"
	echo "Ended OK"
	
	
	echo "Step 13 of 14: marking dump record in repository as \"Ready\"..."	
	# Mark dump as finished in repository table 
	sqlplus system/${SYSTEM_PASSWORD} @set_finished.sql ${DUMP_ID}	> /dev/null	
	
	#  Check for errors
	check_for_oracle_errors_continue "set_finished.log" 
	echo "Ended OK"

	echo "Step 14 of 14: moving dump file ${i} from ${DIR_TO_PROCESS_PATH} to ${DIR_TO_PROCESS_PATH}done/..."	
    
	mv ${DIR_TO_PROCESS_PATH}${i} ${DIR_TO_PROCESS_PATH}done/${i}
done

echo "Cleaning up..."
# Run cleanup
sqlplus system/${SYSTEM_PASSWORD} @cleanup.sql > /dev/null
echo "*  finished processing directory ${DIR_TO_PROCESS_PATH}"

	