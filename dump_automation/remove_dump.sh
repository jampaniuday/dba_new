#!/bin/bash
if [[ $# -lt 1 ]]     # check number of input arguments
then
    echo "Wrong number of arguments"
	echo "Usage: ./remove_dump.sh dump_id"	
	exit 1
fi 

sqlplus system/manager @remove_dump.sql $1