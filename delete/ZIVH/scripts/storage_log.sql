create table storage_log(
check_time date,
owner varchar2(50),
megasize number(30)
);
create or replace procedure p_storage_log is
begin
   insert into storage_log 
    select sysdate,owner,megasize from
     (select owner,sum(bytes)/1024/1024 megasize from dba_segments group by owner);
end p_storage_log;
/
