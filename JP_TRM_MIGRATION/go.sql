spool start.log
spool off
@defines.sql
@pre_migration.sql
@static.sql
@naming.sql
@create_ccy_auth.sql
@vanilla.sql
@digital.sql
@sbarrier.sql
@dbarrier.sql
@linear.sql
spool end.log
spool off
exit
