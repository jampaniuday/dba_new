@ECHO OFF
@Echo Auto script start. 
@ECHO ---------------------------------------------

REM ***Stop database
sqlplus "internal/starteam@orcl as sysdba" @%SQL_HOME%\stop.sql

REM ***Backup to local and network 
call ColdBackup.cmd "%LOCAL_BACKUP_PATH%"
call ColdBackup.cmd %REMOTE_BACKUP_PATH%

REM ***Restart database
sqlplus "internal/starteam@orcl as sysdba" @%SQL_HOME%\start.sql


REM ***Starteam mainteneace scripts
call sqlscript.cmd system/starteam@orcl %SQL_HOME%\ValidateStructure.sql %LOG_DIR%\SYSTEM_ValidateStructure.log
Call weekly.cmd PRODUCT
Call weekly.cmd SOLUTIONS

@ECHO ---------------------------------------------
@Echo Auto script ended