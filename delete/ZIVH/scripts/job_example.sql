
declare
   i number;
begin
   dbms_job.submit(i,'statspack.snap;',sysdate,'next_day(trunc(sysdate),''SATURDAY'')+8/14');
end;
/
commit;




declare
   i number;
begin
   dbms_job.submit(i,'p_storage_log;',trunc(sysdate)+18/24,'trunc(sysdate+1)+18/24');
end;
/
commit;



declare
   i number;
begin
   dbms_job.submit(i,'core_delete_logs_pkg.delete_all_tables;',trunc(sysdate)+22/24,'trunc(sysdate+1)+22/24');
end;
/
commit;


