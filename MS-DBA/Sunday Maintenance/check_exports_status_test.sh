#! /bin/ksh
##################################################
# Author: Oded Raz
# Purpuse: Check Capacity Archive Destination & $ORACLE_HOME.
# Compny : Traiana
# Wrote  : 30-May-2006
####################################################
export SCRIPT_HOME=/oracle/sundaymaint
export DAY=`date "+%d%m%Y"`
export LOG_DIR=/oracle/sundaymaint/log
export LOG_FILE=$LOG_DIR/Check_export_$DAY.log
export SQLPATH=/oracle
export BASEDIR=/oracle/sundaymaint
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


while read PARM_LINE
do
  
  HOST_ADDR=`echo $PARM_LINE|cut -d: -f1`
  COMMAND=`echo $PARM_LINE|cut -d: -f2`
  
  echo HOST ADDR: $HOST_ADDR
  echo COMMAND: $COMMAND
  echo SCRIPT_HOME: $SCRIPT_HOME

  CURRENT_LOG_FILE=`ssh -n -i $SCRIPT_HOME/grid.key $HOST_ADDR $COMMAND | awk '{print $9}'`

  echo "Current Log File=>$CURRENT_LOG_FILE"

  EXPORT_ERRORS=`ssh -n -i $SCRIPT_HOME/grid.key $HOST_ADDR cat $CURRENT_LOG_FILE | grep ORA-`

  echo "Errors Found => $EXPORT_ERROR"

  if [ -n "$EXPORT_ERRORS" ]; then

       echo "File Has Errors $HOST_ADDR $CURRENT_LOG_FILE $EXPORT_ERRORS"
       su - oracle -c "/oracle/sundaymaint/update_sm_export.sh $HOST_ADDR $CURRENT_LOG_FILE $EXPORT_ERRORS"  

  else
       echo "File Dont have errors $HOST_ADDR $CURRENT_LOG_FILE"
       su - oracle -c "/oracle/sundaymaint/update_sm_export.sh $HOST_ADDR $CURRENT_LOG_FILE NONE"

  fi
  
done < $EXP_PARM_FILE




