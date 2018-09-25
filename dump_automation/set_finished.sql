set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 
set serveroutput on
spool set_finished.log

update automation_repo.dump_repository set pid = NULL where id = ^1;
commit;
spool off
exit;