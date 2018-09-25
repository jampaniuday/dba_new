begin
  alter_constraints('disable');
end;
/  
delete from arch_address where id = 1;
delete from arch_batch_data where ADDRESS_ID=1;
delete from arch_con_dir where ADDRESS_ID=1;
delete from arch_dl_detail where ADDRESS_ID=1;
delete from arch_dl where id in (3,4,6);
delete from arch_event_2_dl where id in (3,4,6);
begin
  alter_constraints('enable');
end;
/

Insert into arch_version (TIMESTAMP, VERSION, DESCRIPTION, LOGFILE, SOLUTION_VERSION)
 Values  (sysdate, '1.7.14.1A', 'Ver 1.7 STF 14.1A Biuld 1', '/Arch2.0/installationLog/databaseInstall.log', '2.8.14.1');

commit;
