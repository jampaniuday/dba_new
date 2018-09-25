drop table report_pb;
create table report_pb(pb varchar2(255));

declare
   i number(5);
   last_name  varchar2(30);
   next_name  varchar2(30);
   next_start date;
   next_end   date;
   next_col   varchar2(30);
   sql_string varchar2(4000);
   TYPE cur_type is ref cursor;
   v_cursor cur_type;
   v_name varchar2(255);
   v_cnt number(30);
   v_column_name varchar2(255);
begin
--create columns
   next_start:=to_date('23/10/2005','DD/MM/YYYY');
   next_end:=to_date('30/10/2005','DD/MM/YYYY');
   next_name:='W_'||to_char(next_start,'DD_MM_YYYY')||'_to_'||to_char(next_end,'DD_MM_YYYY');
   dbms_output.enable;
   while sysdate>next_end loop
      sql_string:= 'alter table report_pb add '||next_name||' number(30)';
      execute immediate sql_string; 
      next_start:=next_end;
      next_end:=next_end+7;
      next_name:='W_'||to_char(next_start,'DD_MM_YYYY')||'_to_'||to_char(next_end,'DD_MM_YYYY');
   end loop ;
--insert/update data   
   next_start:=to_date('23/10/2005','DD/MM/YYYY');
   next_end:=to_date('30/10/2005','DD/MM/YYYY');
   next_name:='W_'||to_char(next_start,'DD_MM_YYYY')||'_to_'||to_char(next_end,'DD_MM_YYYY');
   while sysdate>next_end loop
   sql_string:=
   '
   select name,sum(cnt) from
   (
   (select org.name,count(*) cnt
   from m_fx_noe fx, 
   a_organization org,
   a_ta ta
   where fx.prime_broker=org.id 
   and org.basic_status=1
   and ta.id=fx.id
   and ta.created_date between :1 and :2
   group by org.name
   )
   union
   (select org.name,count(*) cnt
   from m_fx_option_noe fx, 
   a_organization org,
   a_ta ta
   where fx.prime_broker=org.id 
   and org.basic_status=1
   and ta.id=fx.id
   and ta.created_date between :3 and :4
   group by org.name
   )
   )
group by name   ';
   open v_cursor for sql_string using next_start,next_end,next_start,next_end;
   loop
      fetch v_cursor into v_name,v_cnt;
      exit when v_cursor%NOTFOUND;
      select count(*) into i from report_pb where pb=v_name;
      if i=1 then
         sql_string:='update report_pb set '||next_name||'=:1 where pb=:2';
         execute immediate sql_string using v_cnt,v_name;
      else
         sql_string:='insert into report_pb(pb,'||next_name||') values(:1,:2)';
         execute immediate sql_string using v_name,v_cnt;
      end if;
   end loop;
   next_start:=next_end;
   next_end:=next_end+7;
   next_name:='W_'||to_char(next_start,'DD_MM_YYYY')||'_to_'||to_char(next_end,'DD_MM_YYYY');
   end loop;
   commit;
--rename columns
   i:=44;
   sql_string:='select column_name from user_tab_columns where table_name=''REPORT_PB'' 
   and column_id>1 order by column_id';
   open v_cursor for sql_string;
   loop
      fetch v_cursor into v_column_name;
      exit when v_cursor%NOTFOUND;
      if i>=44 then
         execute immediate 'alter table report_pb rename column '||v_column_name||' to Y2005_W'||to_char(i);
      else
         execute immediate 'alter table report_pb rename column '||v_column_name||' to Y2006_W'||to_char(i);
      end if;
      if i<53 then
         i:=i+1;
      else
         i:=1;
      end if;
   end loop;
end;
/
--get list of fields :
--select 'sum('||column_name||') '||column_name||',' from user_tab_columns where table_name='REPORT_PB' and column_id>1;

drop table report_pb_temp;
create table report_pb_temp as select * from report_pb where pb like 'ABN AMRO%' 
or pb like 'Deutsche Bank%'
or pb like 'Citigroup%' or pb like 'Citi RGUP PB%';

delete report_pb where pb like 'ABN AMRO%' or pb like 'Deutsche Bank%'
or pb like 'Citigroup PB%' or pb like 'Citi RGUP PB%';

update report_pb_temp set pb='ABN AMRO PB' where pb like 'ABN AMRO%';
update report_pb_temp set pb='Deutsche Bank' where pb like 'Deutsche Bank%';
update report_pb_temp set pb='Citigroup PB' where pb like 'Citigroup%' or pb like 'Citi RGUP PB%';

insert into report_pb(pb,Y2005_w44,Y2005_w45,Y2005_w46,Y2005_w47,Y2005_w48,Y2005_w49,Y2005_w50,Y2005_w51,Y2005_w52,Y2005_w53,Y2006_w1,Y2006_w2,Y2006_w3,Y2006_w4,Y2006_w5,Y2006_w6)
select pb,sum(Y2005_w44),sum(Y2005_w45),sum(Y2005_w46),sum(Y2005_w47),sum(Y2005_w48),sum(Y2005_w49),sum(Y2005_w50),
sum(Y2005_w51),sum(Y2005_w52),sum(Y2005_w53),sum(Y2006_w1),sum(Y2006_w2),sum(Y2006_w3),sum(Y2006_w4),sum(Y2006_w5),sum(Y2006_w6)
from report_pb_temp
where pb like 'ABN AMRO PB%'
group by PB;

insert into report_pb(pb,Y2005_w44,Y2005_w45,Y2005_w46,Y2005_w47,Y2005_w48,Y2005_w49,Y2005_w50,Y2005_w51,Y2005_w52,Y2005_w53,Y2006_w1,Y2006_w2,Y2006_w3,Y2006_w4,Y2006_w5,Y2006_w6)
select pb,sum(Y2005_w44),sum(Y2005_w45),sum(Y2005_w46),sum(Y2005_w47),sum(Y2005_w48),sum(Y2005_w49),sum(Y2005_w50),
sum(Y2005_w51),sum(Y2005_w52),sum(Y2005_w53),sum(Y2006_w1),sum(Y2006_w2),sum(Y2006_w3),sum(Y2006_w4),sum(Y2006_w5),sum(Y2006_w6)
from report_pb_temp
where pb like 'Deutsche Bank%'
group by PB;

insert into report_pb(pb,Y2005_w44,Y2005_w45,Y2005_w46,Y2005_w47,Y2005_w48,Y2005_w49,Y2005_w50,Y2005_w51,Y2005_w52,Y2005_w53,Y2006_w1,Y2006_w2,Y2006_w3,Y2006_w4,Y2006_w5,Y2006_w6)
select pb,sum(Y2005_w44),sum(Y2005_w45),sum(Y2005_w46),sum(Y2005_w47),sum(Y2005_w48),sum(Y2005_w49),sum(Y2005_w50),
sum(Y2005_w51),sum(Y2005_w52),sum(Y2005_w53),sum(Y2006_w1),sum(Y2006_w2),sum(Y2006_w3),sum(Y2006_w4),sum(Y2006_w5),sum(Y2006_w6)
from report_pb_temp
where pb like 'Citigroup PB%'
group by PB;

commit;

--select * from report_pb order by pb






