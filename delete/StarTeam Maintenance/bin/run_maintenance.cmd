@echo START TIME 
time /t

call setEnv.cmd
call st_maintenance.cmd > %LOG_FILE%

@echo END TIME 
time /t