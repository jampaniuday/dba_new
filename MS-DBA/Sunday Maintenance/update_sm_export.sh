#! /bin/ksh
##################################################
# Author: Oded Raz
# Purpuse: Check Capacity Archive Destination & $ORACLE_HOME.
# Compny : Traiana
# Wrote  : 30-May-2006
####################################################
export SCRIPT_HOME=/oracle/sumdaymaint
export DAY=`date "+%d%m%Y"`
export LOG_DIR=/oracle/sumdaymaint/log
export LOG_FILE=$LOG_DIR/Check_export_$DAY.log
export SQLPATH=/oracle
export BASEDIR=/oracle/sumdaymaint
export EXP_PARM_FILE=$BASEDIR/export.prm

export DFLTWRPCT=80
export DFLTERPCT=90
export TS_PARM_FILE=$BASEDIR/TS_ALERTS.prm
export RC=0
export ERRSTK=""
export WRNSTK=""

if [ -s /etc/oratab ];
  then
  export ORATAB=/etc/oratab
 elif [ -s /var/opt/oracle/oratab ] ;then

   export ORATAB=/var/opt/oracle/oratab
 else
  echo "\nCritical - {ORATAB} not exists \n"
  exit 2
fi


#check if parameter file exists, create it if not

if [ ! -d "$BASEDIR" ]; then
    mkdir -p $BASEDIR
fi

if [ ! -d "$LOG_DIR" ]; then
    mkdir -p $LOG_DIR
fi

if [ ! -f $TS_PARM_FILE ]; then
touch ${TS_PARM_FILE}
fi



#Get Database credentials
for LINE in `cat $ORATAB |grep :Y$ |egrep '^[A-Z]|^[a-z]'`
do
         ORACLE_SID=`echo $LINE |  egrep '^[A-Z]|^[a-z]'|awk -F: '{print $1}' -`
         export ORACLE_SID
         export ORACLE_HOME=`echo $LINE | awk -F: '{if ( substr($1,0,1) != "#"  && substr($1,0,1) != "*")print $2}'`
         export PATH=$ORACLE_HOME/bin:/bin:/usr/bin:/etc:/usr/local/bin ;
         export LASTALERT=$BASEDIR/last_alerttime_$ORACLE_SID.txt


echo "First Param => $1"
echo "Second Param => $2"
echo "Third Param => $3"
 
# Get database staus from v$instnace
INSERT_EXPORT_RC=`sqlplus -s -L "/ as sysdba" <<!EOF
INSERT INTO SM.SM_EXPORT_STATUS(HOST_NAME,LOG_FILE,ERRORS,CHECK_DATE) VALUES('$1','$2','$3',SYSDATE);
COMMIT;
!EOF
`
if [ "$INSERT_EXPORT_RC" != "" ]; then
	echo $INSERT_EXPORT_RC
fi

done
