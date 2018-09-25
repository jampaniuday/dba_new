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

if [[ $# -lt 1 ]]     # check number of input arguments
then
    echo "Wrong number of arguments"
	echo "Usage: ./shrink_dump.sh dump_id"	
	exit 1
fi 

# Get path to dir from database
PROCESSED_DUMPS_PATH=$(sqlplus -s system/manager<<EOF
		set heading off feedback off echo off
		spool processed_dumps.log
        select directory_path || '/' from dba_directories where directory_name = upper('PROCESSED_DUMPS_DIR');
		spool off
        exit;
EOF)

check_for_oracle_errors_exit "processed_dumps.log"

# Trim newlines
PROCESSED_DUMPS_PATH=`cat processed_dumps.log | tr -d ' ' | tr -d '\n'`

DUMP_ID=$1

echo "Shrinking dump No.${DUMP_ID}..."
echo "Step 1: truncating log and  tables..."
sqlplus system/manager @shrink_truncate.sql ${DUMP_ID} > /dev/null
echo "Done."
echo "Step 2: exporting schema data..."
expdp system/manager dumpfile=shrink_${DUMP_ID}.dmp directory=SHRINK_DUMPS_DIR schemas=DMP_${DUMP_ID} 1>/dev/null 2> /dev/null
echo "Done."

echo "Step 3: dropping and re-creating tablespaces..."
sqlplus system/manager @drop_and_create_tablespaces.sql ${DUMP_ID} ${PROCESSED_DUMPS_PATH}
echo "Done."

echo "Step 4: importing back into repository..."
impdp system/manager dumpfile=shrink_${DUMP_ID}.dmp directory=SHRINK_DUMPS_DIR schemas=DMP_${DUMP_ID} 1>/dev/null 2> /dev/null
echo "Done."

echo "Step 5: locking tablespaces..."
sqlplus sys/manager as sysdba @mark_tablespaces_as_read_only ${DUMP_ID} > /dev/null
	
check_for_oracle_errors_exit "mark_tablespaces_as_read_only.log" 
echo "Done."

echo "Step 6: exporting with transportable tablespace..."
rm -f  ${PROCESSED_DUMPS_PATH}exp_qin_${DUMP_ID}.dmp
rm -f  ${PROCESSED_DUMPS_PATH}exp_static_${DUMP_ID}.dmp
rm -f  ${PROCESSED_DUMPS_PATH}exp_plsql_${DUMP_ID}.dmp

expdp system/manager dumpfile=exp_qin_${DUMP_ID}.dmp logfile=exp_qin_${DUMP_ID}.log directory=PROCESSED_DUMPS_DIR transport_tablespaces=tbs_qin_${DUMP_ID}  1>/dev/null 2>/dev/null
	
check_for_oracle_errors_exit "${PROCESSED_DUMPS_PATH}exp_qin_${DUMP_ID}.log"
	
expdp system/manager dumpfile=exp_static_${DUMP_ID}.dmp logfile=exp_static_${DUMP_ID}.log directory=PROCESSED_DUMPS_DIR transport_tablespaces=tbs_static_${DUMP_ID} 1>/dev/null 2>/dev/null	
check_for_oracle_errors_exit "${PROCESSED_DUMPS_PATH}exp_static_${DUMP_ID}.log"	
expdp system/manager directory=PROCESSED_DUMPS_DIR dumpfile=exp_plsql_${DUMP_ID}.dmp logfile=exp_plsql_${DUMP_ID}.log schemas=DMP_${DUMP_ID} content=metadata_only 1>/dev/null 2>/dev/null	
check_for_oracle_errors_exit "${PROCESSED_DUMPS_PATH}exp_plsql_${DUMP_ID}.log"
echo "Done."



