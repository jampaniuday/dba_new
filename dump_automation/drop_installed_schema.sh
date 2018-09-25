#!/bin/bash

if [[ $# -lt 2 ]]     # check number of input arguments
then
    echo "Wrong number of arguments"
	echo "Usage: ./drop_installed_schema.sh schema_name db_name"	
	exit 1
fi 

SCHEMA_NAME=$1
DB_NAME=$2

echo "Dropping schema ${SCHEMA_NAME} on db server ${DB_NAME}... "
sqlplus -s system/manager@${DB_NAME} @drop_installed_schema.sql ${SCHEMA_NAME} 