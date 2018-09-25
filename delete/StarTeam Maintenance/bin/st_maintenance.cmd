
call stop_st.cmd
IF %errorlevel%==1 goto error


call run_ColdBackup.cmd


call start_st.cmd
IF %errorlevel%==1 goto error

goto OK

:error
echo FATAL ERROR VIEW LOG AT: %LOG_FILE%
goto exit_script

:ok
echo Script completed successfully

:exit_script
echo Done...