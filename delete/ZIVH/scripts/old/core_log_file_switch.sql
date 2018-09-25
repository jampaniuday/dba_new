create or replace procedure core_log_file_switch is
   v_last_switch_time date;
   v_curr_time        date;
begin
   select max(COMPLETION_TIME),sysdate
   into v_last_switch_time,v_curr_time
   from v$archived_log;
   if v_curr_time > (v_last_switch_time+1/48) then
      execute immediate 'alter system switch logfile' ;
   end if;
end;
/

declare
   i number;
begin
   dbms_job.submit(i,'core_log_file_switch;',sysdate,'sysdate+1/24/3');
end;
/
commit;

