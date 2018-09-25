#!/bin/bash
# Created : Oded 05/09/2009
#
# This script calls the 2 scripts,
# that perform the RMAN full database backup and the RMAN incremental backup,
# and sends e-mail after each backup.


####################################################################################################
# Parsing command line parameters
####################################################################################################

USAGE="Usage: `basename $0` [-c command] [-s SID]"

# we want at least one parameter (it may be a flag or an argument)
if [ $# -eq 0 ]; then
	echo $USAGE >&2
	exit 1
fi

# parse command line arguments
while getopts c:s: OPT; do
    case "$OPT" in
	c)	CMD=$OPTARG
		case "$CMD" in
		   'BACKUP')
		   echo "${CMD}"
                   ;;
		   'RESTORE')
                   echo "${CMD}"
                   ;;
		   'ALL')
                   echo "${CMD}"
	    	   ;;
		   'ADD')
                   echo "${CMD}"
                   ;;
                   'DEL')
                   echo "${CMD} Will be implemented later"
                   ;;
		   *)
	           echo "Please use the following commands : BACKUP,RESTORE,ALL,ADD,DEL"
		   ;;
		esac	
		;;
	v)	echo "`basename $0` version 0.1"
		exit 0
		;;
	s)	DBNAME=$OPTARG
		export SYS_PASS=`$ORACLE_HOME/bin/sqlplus -x -s $CATALOG_USER/$CATALOG_PASS@$CATALOG <<%SQL%
		set SQLPROMPT "" verify off head off feedback off sqlnumber off feed off pages 0
		SELECT SYS_PASS FROM tr_backup_parameters WHERE UPPER(DB_NAME)=UPPER('${BACK_SID}');
		%SQL%`
		echo "${DBNAME}"
		;;
	\?)	# getopts issues an error message
		echo $USAGE >&2
		exit 1
		;;
    esac
done
