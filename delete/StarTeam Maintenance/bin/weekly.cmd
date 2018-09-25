@echo ********* WEEKLY SCRIPTS FOR %1  STARTED
call sqlscript.cmd "%1/%1@ORCL" "%ST_SQL_HOME%\starteam_oracle_rebuild_indexes.sql" %LOG_DIR%\%1_starteam_oracle_rebuild_indexes.LOG
call sqlscript.cmd "%1/%1@ORCL" "%ST_SQL_HOME%\starteam_oracle_compute_stats.sql"   %LOG_DIR%\%1_starteam_oracle_compute_stats.LOG
@echo ********* WEEKLY SCRIPTS FOR %1 ARE DONE!

