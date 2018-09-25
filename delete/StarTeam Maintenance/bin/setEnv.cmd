for /f "tokens=2" %%i in ('date/t') do set date1=%%i
set cur_date=%date1:/=-%

pushd ..
set HOME=%CD%
popd

set REMOTE_BACKUP_PATH="""\\Filer\R&D\PS-IL\CM\starteam-backup\ColdBackup"""
set LOCAL_BACKUP_PATH=%HOME%\Backup
set SQL_HOME=%HOME%\sql
set ST_SQL_HOME=D:\Program Files\Borland\StarTeam Server 6.0\DBScripts\Oracle_Scripts\
set LOG_DIR=%HOME%\log
set LOG_FILE=%LOG_DIR%\%CUR_DATE%-maintenance.log

