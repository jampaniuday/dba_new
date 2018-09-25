set termout off
set pagesize 1000
set feedback off
SET VERIFY OFF
SET ECHO OFF

set markup HTML ON HEAD " -
<style type='text/css'> - 
  body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
  p {   font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
        table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; -
        padding:0px 0px 0px 0px; margin:0px 0px 0px 0px; white-space:nowrap;} -
  th {  font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99; -
        padding:0px 0px 0px 0px;} -
  h1 {  font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; -
        border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;} -
  h2 {  font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; -
        margin-top:4pt; margin-bottom:0pt;} a {font:9pt Arial,Helvetica,sans-serif; color:#663300; -
        background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
</style> -
<title>&1</title>" -
BODY "" -
TABLE "border='1' align='center' summary='Script output'" -
SPOOL ON ENTMAP OFF PREFORMAT OFF

spool &3

clear buffer

SET HEADING OFF
select '<h1>Sunday Maintanence - '||to_char(sysdate,'DD-MM-YYYY')||'</h1>' from dual;
SET HEADING ON

COLUMN INVALIC_O_CHECK_DESC HEADING 'INVALID OBJECTS' ENTMAP OFF
COLUMN FREE_SPACE FORMAT 99
BREAK ON ENVIRONMENT;

SELECT 	DB.ENVIRONMENT "ENVIRONMENT",
	RS.DB_NAME "DATABASE NAME",
	DECODE(JOB_CHECK_DESC,'OK','OK','<A HREF="#JOBS">'||JOB_CHECK_DESC||'</A>') "JOBS STATUS",
	DECODE(INVALIC_C_CHECK_DESC,'OK','OK','<A HREF="#CONST">'||INVALIC_C_CHECK_DESC||'</A>') "INVALID CONSTRAINTS",
	DECODE(INVALIC_I_CHECK_DESC,'OK','OK','<A HREF="#INDEX">'||INVALIC_I_CHECK_DESC||'</A>') "INVALID INDXES",
	DECODE(INVALIC_O_CHECK_DESC,'OK','OK','<A HREF="#OBJECTS">'||INVALIC_O_CHECK_DESC||'</A>') "INVALID OBJECTS"
FROM   SM_REPORTS_SUMMERY RS,
       SM_DATABASES DB
WHERE REPORT_NAME='&1' AND
      RS.DB_NAME=DB.DB_NAME AND
      RS.DB_NAME IN (SELECT DB_NAME from sm_report_recipient rrcp, sm_recipients rcp where rcp.RECIPIENT=rrcp.RECIPIENT and rcp.RECIPIENT_NAME='&2')
ORDER BY DB.REP_ORDER,RS.DB_NAME;

SET HEADING OFF
SELECT '<A NAME=''JOBS''></A> BROKEN JOBS REPORT ' "BROKEN JOBS REPORT"
FROM   DUAL;
SET HEADING ON

SELECT DB_NAME,OWNER,JOB_NAME,STATUS,ACTUAL_START_DATE "START DATE",LOG_ID,LOG_DATE,ERROR
FROM SM_SCHEDULER_JOBS
WHERE REPORT_NAME='&1' AND
      DB_NAME IN (SELECT DB_NAME from sm_report_recipient rrcp, sm_recipients rcp where rcp.RECIPIENT=rrcp.RECIPIENT and rcp.RECIPIENT_NAME='&2')
ORDER BY 1,2
/

SET HEADING OFF
SELECT '<A NAME=''CONST''></A> INVALID CONSTRAINTS REPORT ' "INVALID CONSTRAINTS REPORT"
FROM   DUAL;
SET HEADING ON

SELECT DB_NAME "DATABASE NAME",OWNER,OBJECT_NAME "OWNER NAME",TABLE_NAME "TABLE NAME"
FROM SM_INVALID_OBJECTS
WHERE OBJECT_TYPE='CONSTRAINT' AND REPORT_NAME='&1' AND DB_NAME IN (SELECT DB_NAME from sm_report_recipient rrcp, sm_recipients rcp where rcp.RECIPIENT=rrcp.RECIPIENT and rcp.RECIPIENT_NAME='&2')
ORDER BY 1,2
/

SET HEADING OFF
SELECT '<A NAME=''INDEX''></A> INVALID INDEXES REPORT ' "INVALID INDEXES REPORT"
FROM   DUAL;
SET HEADING ON

SELECT DB_NAME "DATABASE NAME",OWNER,OBJECT_NAME "OWNER NAME",TABLE_NAME "TABLE NAME"
FROM SM_INVALID_OBJECTS
WHERE OBJECT_TYPE='INDEX' AND REPORT_NAME='&1' AND DB_NAME IN (SELECT DB_NAME from sm_report_recipient rrcp, sm_recipients rcp where rcp.RECIPIENT=rrcp.RECIPIENT and rcp.RECIPIENT_NAME='&2')
ORDER BY 1,2
/

SET HEADING OFF
SELECT '<A NAME=''OBJECTS''></A> INVALID OBJECTS REPORT ' "INVALID OBJECTS REPORT"
FROM   DUAL;
SET HEADING ON

SELECT DB_NAME "DATABASE NAME",OWNER,OBJECT_NAME "OWNER NAME",OBJECT_TYPE "OBJECT TYPE"
FROM SM_INVALID_OBJECTS
WHERE OBJECT_TYPE NOT IN ('CONSTRAINT','INDEX') AND REPORT_NAME='&1' AND DB_NAME IN (SELECT DB_NAME from sm_report_recipient rrcp, sm_recipients rcp where rcp.RECIPIENT=rrcp.RECIPIENT and rcp.RECIPIENT_NAME='&2')
ORDER BY 1,2
/

SET HEADING OFF
SELECT '<A NAME=''OBJECTS''></A> VALIDATE COMMANDS REPORT ' "VALIDATE COMMANDS REPORT"
FROM   DUAL;
SET HEADING ON

SELECT DB_NAME "DATABASE NAME",COMMAND_TYPE "COMMAND TYPE",COMMAND 
FROM SM_REPORT_COMMANDS
WHERE REPORT_NAME='&1' AND DB_NAME IN (SELECT DB_NAME from sm_report_recipient rrcp, sm_recipients rcp where rcp.RECIPIENT=rrcp.RECIPIENT and rcp.RECIPIENT_NAME='&2')
ORDER BY 1,2
/

exit
