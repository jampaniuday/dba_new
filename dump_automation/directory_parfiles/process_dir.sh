#!/bin/bash

check_for_oracle_errors_exit()
{
#    echo "parameter: -"${1}"-"
    SHOULD_BE_EMPTY=$(echo "${1}" | grep -i '\(ora-\|sp2-\|Usage 1:sqlplus -H\)' | grep -vi 'ORA-31684' | grep -vi 'ORA-39082')
#	echo "Should be empty: -${SHOULD_BE_EMPTY}-"
	if [[ "${SHOULD_BE_EMPTY}" ]]
	then
	  echo
	  echo
	  echo "Got oracle error:"
	  echo 
	  echo
	  echo ${1}	  
	  exit 1
	fi
}


check_for_oracle_errors_continue()
{
#    echo "parameter: -"${1}"-"
    SHOULD_BE_EMPTY=$(echo "${1}" | grep -i '\(ora-\|sp2-\|Usage 1:sqlplus -H\)' | grep -vi 'ORA-31684' | grep -vi 'ORA-39082')
#	echo "Should be empty: -${SHOULD_BE_EMPTY}-"
	if [[ "${SHOULD_BE_EMPTY}" ]]
	then
	  echo
	  echo
	  echo "Got oracle error:"
	  echo
	  echo
	  echo ${1}
	  echo
	  echo
	  echo "Removing ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql..."
	  echo
	  echo
	  rm -f rm -f ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql
	  continue
	fi
}

check_for_oracle_errors_drop_continue()
{
#    echo "parameter: -"${1}"-"
    SHOULD_BE_EMPTY=$(echo "${1}" | grep -i '\(ora-\|sp2-\|Usage 1:sqlplus -H \| -V\)')
#	echo "Should be empty: -${SHOULD_BE_EMPTY}-"
	if [[ "${SHOULD_BE_EMPTY}" ]]
	then
	  echo
	  echo
	  echo "Got oracle error:"
	  echo ${1}
	  echo
	  echo
	  echo
	  echo "Dropping schema ${2}..."
	  echo
	  echo
	  sqlplus system/manager @drop_user.sql ${2}
	  
	  echo
	  echo
	  echo "Removing ${DIR_TO_PROCESS_PATH}/${2}.schemasql..."
	  echo
	  echo
	  rm -f rm -f ${DIR_TO_PROCESS_PATH}/${2}.schemasql
	  continue
	fi
}

PID=$$

DIR_TO_PROCESS=$1
DIR_FOR_OUTPUT=$2

if [[ $# -ne 2 ]]     # check number of input arguments
then
    echo "Wrong number of arguments"
	echo "Usage: ./process_dir.sh dir_to_process dir_for_output"
	echo "       Use Oracle direcory name, not paths";
	exit 1
fi 

# Get path to dir from database
DIR_TO_PROCESS_PATH=$(sqlplus -s system/manager<<EOF
		set heading off feedback off echo off
        select directory_path || '/' from dba_directories where directory_name = upper('${DIR_TO_PROCESS}');
        exit;
EOF)

check_for_oracle_errors_exit "${DIR_TO_PROCESS_PATH}"

# Trim newlines
DIR_TO_PROCESS_PATH=`echo ${DIR_TO_PROCESS_PATH} | tr -d '\n'`



if [[ -z "${DIR_TO_PROCESS_PATH}" ]]    
then
    echo "1 directory ${DIR_TO_PROCESS} was not found in database"
	exit 1
fi 


DIR_FOR_OUTPUT_PATH=$(sqlplus -s system/manager<<EOF
		set heading off feedback off echo off
        select directory_path  || '/' from dba_directories where directory_name = upper('${DIR_FOR_OUTPUT}');
        exit;
EOF)


check_for_oracle_errors_exit "${DIR_FOR_OUTPUT_PATH}"

# Trim newlines
DIR_FOR_OUTPUT_PATH=`echo ${DIR_FOR_OUTPUT_PATH} | tr -d '\n'`

if [[ -z "${DIR_FOR_OUTPUT_PATH}" ]]    
then
    echo "2 directory ${DIR_FOR_OUTPUT} was not found in database"
	exit 1
fi 

echo "*******************************************************"
echo "*                                                     *"
echo "*  processing direcory ${DIR_TO_PROCESS_PATH}                    *"
echo "*                                                     *"
echo "*******************************************************"


for i in `ls ${DIR_TO_PROCESS_PATH}*.dmp | xargs -n1 basename` 
do 

	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  processing file ${i}                               *"
	echo "*                                                     *"
	echo "*******************************************************"
	TEMP_SCHEMA=TMP_$(date +%Y_%m_%d_%H_%M_%S)
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 1: import only ddl from dump into             *"
	echo "*          ${DIR_TO_PROCESS_PATH}${TEMP_SCHEMA}.schemasql       *"
	echo "*                                                     *"	
	echo "*******************************************************"
    impdp system/manager dumpfile=${i} logfile=${i}.implog directory=${DIR_TO_PROCESS} sqlfile=${TEMP_SCHEMA}.schemasql content=metadata_only parallel=2

	check_for_oracle_errors_continue "`cat ${DIR_TO_PROCESS_PATH}${i}.implog`"
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 2: search sql file ${DIR_TO_PROCESS_PATH}${TEMP_SCHEMA}.schemasql             *"
	echo "*          for pattern \"CREATE USER\" and taking     *"
    echo "*          schema name from there                     *"	
    echo "*                                                     *"	
	echo "*******************************************************"
	SCHEMA_NAME=$(grep "CREATE USER"  ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql | cut -d\" -f2)
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Schema name from sql file is:                      *"
	echo "*  ${SCHEMA_NAME}            *"    
    echo "*                                                     *"	
	echo "*******************************************************"
	
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 3: creating temporary schema named ${TEMP_SCHEMA} *"	
    echo "*                                                     *"	
	echo "*******************************************************"
	sqlplus system/manager @create_user_temp.sql ${TEMP_SCHEMA}
	
	check_for_oracle_errors_drop_continue "`cat create_user_temp.log`" ${TEMP_SCHEMA}
	# grep only MY grants. !!!!!!!!
	GRANT=$(grep -oi '^grant[ ]*[A-Z]*[ ]*on.*to[ ]*\"[A-Z_]*\"' ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql | grep -oi 'TO[ ]*".*' | cut -d\" -f2 | grep -v "^${SCHEMA_NAME}$" | head -1)	
	
	# if there are grants in sql file
	if [ -n "${GRANT}" ]
	then
	   EXCLUDE_GRANTS="include=GRANT:\"=\'\'\""
	else
	   EXCLUDE_GRANTS=""
	fi
	
	cat imp_cnfg_instance.par_template > parameters_for_${i}.par
	cat remaps.par_template >> parameters_for_${i}.par
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 4: importing dump file ${i} into schema ${TEMP_SCHEMA} *"
    echo "*          (only IC_CNFG_INSTANCE and V_CURRENT_PRODUCT_VERSION)*"	
	echo "*******************************************************"
	impdp system/manager dumpfile=${i} logfile=${i}.implog directory=${DIR_TO_PROCESS} parfile=parameters_for_${i}.par schemas=${SCHEMA_NAME} remap_schema=${SCHEMA_NAME}:${TEMP_SCHEMA} ${EXCLUDE_GRANTS} transform=oid:n parallel=2
	
	check_for_oracle_errors_drop_continue "`cat ${DIR_TO_PROCESS_PATH}${i}.implog`" ${TEMP_SCHEMA}
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 5: registring dump ${i} in repository *"
    echo "*                                                     *"	
	echo "*******************************************************"
	DUMP_ID=$(sqlplus -s system/manager @register_dump.sql ${TEMP_SCHEMA} ${i} ${SCHEMA_NAME} ${PID})

	check_for_oracle_errors_drop_continue "${DUMP_ID}" ${TEMP_SCHEMA}
	
	# Trim newlines
    DUMP_ID=`echo ${DUMP_ID} | tr -d '\n'`
	
	echo "Dump file ${i} registered in repository. Repository ID for dump is ${DUMP_ID}"		
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 5: removing temporary sql file ${DIR_TO_PROCESS_PATH}${TEMP_SCHEMA}.schemasql  *"
    echo "*                                                     *"	
	echo "*******************************************************"
	rm -f ${DIR_TO_PROCESS_PATH}/${TEMP_SCHEMA}.schemasql
	
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 6: dropping temporary schema ${TEMP_SCHEMA}  *"
    echo "*                                                     *"	
	echo "*******************************************************"
	sqlplus system/manager @drop_user.sql ${TEMP_SCHEMA}
	
	check_for_oracle_errors_continue "`cat drop_user.log`"
	

	DUMP_SCHEMA=DMP_${DUMP_ID}
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 7: re-creating temporary schema ${TEMP_SCHEMA}  *"
    echo "*                                                     *"	
	echo "*******************************************************"
	sqlplus system/manager @create_user_transportable.sql ${DUMP_ID} ${DIR_FOR_OUTPUT_PATH}
    
	check_for_oracle_errors_drop_continue "`cat create_user_transportable.log`" ${DUMP_SCHEMA}	
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 8: importing dump file ${i} into schema ${TEMP_SCHEMA} *"
    echo "*          only MSG_QUEUE_IN      *"	
    echo "*                                                     *"	
	echo "*******************************************************"					
	
	cat imp_msg_queue_in.par_template > parameters_for_dump_${DUMP_ID}_qin.par
	cat remaps.par_template | sed "s/USERS/TBS_QIN_${DUMP_ID}/g" >> parameters_for_dump_${DUMP_ID}_qin.par
	echo "remap_tablespace=USERS:TBS_QIN_${DUMP_ID}" >> parameters_for_dump_${DUMP_ID}_qin.par
	
	impdp system/manager dumpfile=${i} logfile=${i}.implog directory=${DIR_TO_PROCESS} parfile=parameters_for_dump_${DUMP_ID}_qin.par schemas=${SCHEMA_NAME} remap_schema=${SCHEMA_NAME}:${DUMP_SCHEMA} ${EXCLUDE_GRANTS} transform=oid:n parallel=2

    check_for_oracle_errors_continue "`cat ${DIR_TO_PROCESS_PATH}${i}.implog`"
	
#	sqlplus system/manager @create_trigger.sql ${DUMP_SCHEMA}
	
#	check_for_oracle_errors_continue "`cat create_trigger.log`" 
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 9: importing dump file ${i} into schema ${TEMP_SCHEMA} *"
    echo "*  excluding big tables and MSG_QUEUE_IN     *"	
    echo "*                                                     *"	
	echo "*******************************************************"	
	
	if [ -e ./directory_parfiles/${DIR_TO_PROCESS}.static.par_template ]
	then
	    echo "Using parfile ../directory_parfiles/${DIR_TO_PROCESS}.static.par_template for import..."
	    cat ./directory_parfiles/${DIR_TO_PROCESS}.static.par_template > parameters_for_dump_${DUMP_ID}_static.par
	else
		cat imp_excluded.par_template > parameters_for_dump_${DUMP_ID}_static.par
	fi
	
	
	cat remaps.par_template | sed "s/USERS/TBS_STATIC_${DUMP_ID}/g" >> parameters_for_dump_${DUMP_ID}_static.par
	echo "remap_tablespace=USERS:TBS_STATIC_${DUMP_ID}" >> parameters_for_dump_${DUMP_ID}_static.par
    impdp system/manager dumpfile=${i} logfile=${i}.implog directory=${DIR_TO_PROCESS} parfile=parameters_for_dump_${DUMP_ID}_static.par schemas=${SCHEMA_NAME} remap_schema=${SCHEMA_NAME}:${DUMP_SCHEMA} ${EXCLUDE_GRANTS} TABLE_EXISTS_ACTION=SKIP transform=oid:n parallel=2
    
#	check_for_oracle_errors_continue "`cat ${DIR_TO_PROCESS_PATH}${i}.implog`"
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 10: marking tablespaces as read only          *"	
    echo "*                                                     *"	
	echo "*******************************************************"	
	sqlplus sys/manager as sysdba @mark_tablespaces_as_read_only ${DUMP_ID}
	
	check_for_oracle_errors_continue "`cat mark_tablespaces_as_read_only.log`" 
	
	echo "*******************************************************"
	echo "*                                                     *"
	echo "*  Step 10: exporting with transportable tablespace          *"	
    echo "*                                                     *"	
	echo "*******************************************************"	
	expdp system/manager dumpfile=exp_qin_${DUMP_ID}.dmp logfile=exp_qin_${DUMP_ID}.log directory=${DIR_FOR_OUTPUT} transport_tablespaces=tbs_qin_${DUMP_ID}
	
	check_for_oracle_errors_continue "`cat ${DIR_FOR_OUTPUT_PATH}${i}.implog`"
	
	expdp system/manager dumpfile=exp_static_${DUMP_ID}.dmp logfile=exp_static_${DUMP_ID}.log directory=${DIR_FOR_OUTPUT} transport_tablespaces=tbs_static_${DUMP_ID}
	
	check_for_oracle_errors_continue "`cat ${DIR_FOR_OUTPUT_PATH}${i}.implog`"
	
	sqlplus system/manager @set_finished.sql ${DUMP_ID}		
	
	check_for_oracle_errors_continue "`cat set_finished.log`" 
	
done

echo "*******************************************************"
echo "*                                                     *"
echo "*  finished processing directory ${DIR_TO_PROCESS_PATH}                    *"
echo "*                                                     *"
echo "*******************************************************"