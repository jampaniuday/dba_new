@echo off
if exist DBA_APPS.sql del DBA_APPS.sql
echo. >DBA_APPS.sql

for /r %%a in (header.sql) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			   )

for /r %%a in (*.sequence) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			   )

for /r %%a in (*.table) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			   )

for /r %%a in (*.fk) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			)

for /r %%a in (*.data) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			  )

for /r %%a in (*.function) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			  )

for /r %%a in (*.view) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			  )

for /r %%a in (Log_Manager.package) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			     )
for /r %%a in (*.procedure) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			     )

for /r %%a in (*.package) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			     )

for /r %%a in (footer.sql) do (
				copy/b DBA_APPS.sql+"%%a" DBA_APPS.sql
                                echo. >> DBA_APPS.sql
			   )