set serveroutput on
set time on
create table temp_ttl(ttl number(30,5));
declare
   cursor batch_crs is
   select  distinct uid_insert from a_batch_data 
   where address_id=3300000;
   v_uid_out     varchar2(4000);
   v_insert_time date;
   v_out_time    date;
   i             number(30):=0;
   j             number(30):=0;
   v_avg         number(30,5):=0;
   cursor temp_ttl_crs is
   select ttl from temp_ttl order by ttl;
   v_quarter     number(30);
begin
   execute immediate 'truncate table temp_ttl';
   dbms_output.enable(99999999);
   for rec in batch_Crs loop
   begin
      select max(uid_out) into v_uid_out
      from a_batch_data
      where uid_insert=rec.uid_insert;
      select audit_time 
      into v_insert_time
      from a_audit
      where uuid=rec.uid_insert
      and direction=1;
      select audit_time 
      into v_out_time
      from a_audit
      where uuid=v_uid_out
      and direction=2;
      i:=i+1;
      v_avg:=v_avg+((v_out_time-v_insert_time)*24*60*60);
      insert into temp_ttl values(((v_out_time-v_insert_time)*24*60*60));
   exception when no_data_found then
      j:=j+1;
   end;
   end loop;
   v_avg:=v_avg/i;
   dbms_output.put_line('average is:'||to_char(v_avg));
   dbms_output.put_line('number of NOEs checked is:'||to_char(i));
   v_quarter:=trunc(i/4);
   j:=0;
   for rec in temp_ttl_crs loop
      j:=j+1;
      if j=v_quarter then 
         dbms_output.put_line('1st quarter NOE TTL is :'||to_char(rec.ttl));
      elsif j=2*v_quarter then 
         dbms_output.put_line('2nd quarter NOE TTL is :'||to_char(rec.ttl));
      elsif j=3*v_quarter then 
         dbms_output.put_line('3rd quarter NOE TTL is :'||to_char(rec.ttl));
      elsif j=i then 
         dbms_output.put_line('4th quarter NOE TTL is :'||to_char(rec.ttl));
      end if;
   end loop;
end;
/
