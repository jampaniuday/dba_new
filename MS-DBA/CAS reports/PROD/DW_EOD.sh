#!/bin/tcsh 

setenv ORACLE_BASE /oracle
setenv ORACLE_HOME $ORACLE_BASE/product/10.2.0/db
setenv ORACLE_SID casprod
setenv PATH .:${PATH}:$HOME/bin:$ORACLE_HOME/bin
setenv PATH ${PATH}:/usr/bin:/bin:/usr/bin/X11:/usr/local/bin
setenv NLS_LANG AMERICAN_AMERICA.WE8ISO8859P1
setenv OUTPUT_PATH  /usr/local/traiana/CASFiles/PROD/DW_EOD/
setenv OUTPUT_FILE_NAME `date +" CAS_EOD_DW_Report_%m-%d-%Y_%H-%M.csv"`
rm -f $OUTPUT_PATH/$OUTPUT_FILE_NAME
cd /cassrc/reports
sqlplus read_only/limited @DW_EOD.sql $OUTPUT_PATH/$OUTPUT_FILE_NAME > /dev/null

#
setenv SFTP_HOME /ftp_home/Production/sFTP_Users/CAS.Prd.CLS/TAMI
setenv PGP_HOME /usr/local/ebs
setenv LD_LIBRARY_PATH ${ORACLE_HOME}/lib:$PGP_HOME/lib
$PGP_HOME/ebs --encrypt --user "CLSS Production Key Issue 4 <pgpadmin@cls-services.com>" --output $SFTP_HOME/$OUTPUT_FILE_NAME.pgp $OUTPUT_PATH/$OUTPUT_FILE_NAME


#example for Gnu gpg
#/usr/local/gnupg/bin/gpg --import /PGP_Keys/pubring.pkr
#/usr/local/gnupg/bin/gpg --batch  --passphrase-fd 0 < gpg_pass.txt --keyring  /home/oracle/.gnupg/pubring.gpg -r "CLS Services Test Key <pgptest@cls-services.com>" -o test.pgp -encrypt $OUTPUT_FILE_NAME

#
#/usr/local/ebs/ebs --decrypt /ftp_home/Production/sFTP_Users/CAS.Prd.CLS/TAMI/CAS_EOD_DW_Report_11-17-2009_07-47.csv.pgp --output test.csv
