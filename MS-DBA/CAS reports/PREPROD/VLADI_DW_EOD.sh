#!/bin/tcsh 

setenv ORACLE_BASE /oracle
setenv ORACLE_HOME $ORACLE_BASE/product/10.2.0/db
setenv ORACLE_SID casuat
setenv PATH .:${PATH}:$HOME/bin:$ORACLE_HOME/bin
setenv PATH ${PATH}:/usr/bin:/bin:/usr/bin/X11:/usr/local/bin
setenv NLS_LANG AMERICAN_AMERICA.WE8ISO8859P1
setenv OUTPUT_PATH  /usr/local/traiana/CASFiles/PREPROD/DW_EOD/
setenv OUTPUT_FILE_NAME `date +" VLADI_CAS_EOD_DW_Report_%m-%d-%Y_%H-%M.csv"`
rm -f $OUTPUT_PATH/$OUTPUT_FILE_NAME
cd /cassrc/reports/preprod
sqlplus read_only/limited @VLADI_DW_EOD.sql $OUTPUT_PATH/$OUTPUT_FILE_NAME > /dev/null

#
#setenv SFTP_HOME /ftp_home/Test/sFTP_Users/CAS.Tst.CLS/TAMI
setenv SFTP_HOME /ftp_home/Test/sFTP_Users/CAS.Tst.CLS/TAMI_PREPROD
setenv PGP_HOME /usr/local/ebs
setenv LD_LIBRARY_PATH ${ORACLE_HOME}/lib:$PGP_HOME/lib
$PGP_HOME/ebs --encrypt --user "CLS Services Test Key <pgptest@cls-services.com>" --output $SFTP_HOME/$OUTPUT_FILE_NAME.pgp $OUTPUT_PATH/$OUTPUT_FILE_NAME
