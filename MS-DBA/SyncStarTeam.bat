@echo off
set SYNC_DIR=%1
set OPRATION=%2
IF EXIST C:\MS-DBA\NUL set LOCAL_DIR="C:\MS-DBA"
IF EXIST D:\MS-DBA\NUL set LOCAL_DIR="D:\MS-DBA"


if "%SYNC_DIR%"=="RBS" goto :RBS
if "%SYNC_DIR%"=="SUNDAY" goto :SUNDAY
if "%SYNC_DIR%"=="TICKER" goto :TICKER
if "%SYNC_DIR%"=="CITI" goto :CITI

echo Invalid Application %SYNC_DIR%, Specify - RBS,SUNDAY,TICKER,CITI
goto :END

:RBS

if "%OPRATION%"=="put" "c:\Program Files\WinSCP\winscp.com" /console /command "option batch on" "option confirm off" "open -hostkey="ssh-rsa 1024 f9:49:e1:dd:43:37:53:db:c7:4d:24:0f:f4:d8:d1:ac" oracle:rose4u@NY1P-BCK-ORA" "put %LOCAL_DIR%\RBS\*.* /home/oracle/scripts/*.*" "exit"
if "%OPRATION%"=="get" "c:\Program Files\WinSCP\winscp.com" /console /command "option batch on" "option exclude "*.log*;*log*"" "option confirm off" "open -hostkey="ssh-rsa 1024 f9:49:e1:dd:43:37:53:db:c7:4d:24:0f:f4:d8:d1:ac" oracle:rose4u@NY1P-BCK-ORA" "get /home/oracle/scripts/* %LOCAL_DIR%\RBS\*.*" "exit"

goto :END

:SUNDAY

if "%OPRATION%"=="put" "c:\Program Files\WinSCP\winscp.com" /console /command "option batch on" "option confirm off" "open oracle:rose4u@APTRGRID -hostkey="ssh-rsa 1024 f9:49:e1:dd:43:37:53:db:c7:4d:24:0f:f4:d8:d1:ac" " "put "%LOCAL_DIR%\Sunday Maintenance\*.*" /oracle/sundaymaint/*.*" "exit"
if "%OPRATION%"=="get" "c:\Program Files\WinSCP\winscp.com" /console /command "option batch on" "option exclude "*.log*;*log*;reports;*.html"" "option confirm off" "open oracle:rose4u@APTRGRID -hostkey="ssh-rsa 1024 f9:49:e1:dd:43:37:53:db:c7:4d:24:0f:f4:d8:d1:ac"" "get /oracle/sundaymaint/* "%LOCAL_DIR%\Sunday Maintenance\*.*"" "exit"

goto :END

:TICKER

if "%OPRATION%"=="put" "c:\Program Files\WinSCP\winscp.com" /console /command "option batch on" "option confirm off" "open oracle:rose4u@APTRGRID -hostkey="ssh-rsa 1024 f9:49:e1:dd:43:37:53:db:c7:4d:24:0f:f4:d8:d1:ac" " "put "%LOCAL_DIR%\Harmony Ticker\*.*" /monpsrc/scripts/harmony_ticker/*.*" "exit"
if "%OPRATION%"=="get" "c:\Program Files\WinSCP\winscp.com" /console /command "option batch on" "option confirm off" "open oracle:rose4u@APTRGRID -hostkey="ssh-rsa 1024 f9:49:e1:dd:43:37:53:db:c7:4d:24:0f:f4:d8:d1:ac" " "get /monpsrc/scripts/harmony_ticker/* "%LOCAL_DIR%\Harmony Ticker\*.*"" "exit"

goto :END

:CITI

if "%OPRATION%"=="put" "c:\Program Files\WinSCP\winscp.com" /console /command "option batch on" "option confirm off" "open oracle:rose4u@APTRGRID -hostkey="ssh-rsa 1024 f9:49:e1:dd:43:37:53:db:c7:4d:24:0f:f4:d8:d1:ac" " "put "%LOCAL_DIR%\citi exports\*.*" /monpsrc/scripts/citi_exports/*.*" "exit"
if "%OPRATION%"=="get" "c:\Program Files\WinSCP\winscp.com" /console /command "option batch on" "option confirm off" "open oracle:rose4u@APTRGRID -hostkey="ssh-rsa 1024 f9:49:e1:dd:43:37:53:db:c7:4d:24:0f:f4:d8:d1:ac" " "get /monpsrc/scripts/citi_exports/* "%LOCAL_DIR%\citi exports\*.*"" "exit"

goto :END

:END
