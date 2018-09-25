--per week, group by EB
drop table report_eb;
create table report_eb(pb varchar2(255),eb varchar2(255));

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
   v_pb varchar2(255);
   v_eb varchar2(255);
   v_cnt number(30);
   v_column_name varchar2(255);
begin
--create columns
   next_start:=to_date('23/10/2005','DD/MM/YYYY');
   next_end:=to_date('30/10/2005','DD/MM/YYYY');
   next_name:='W_'||to_char(next_start,'DD_MM_YYYY')||'_to_'||to_char(next_end,'DD_MM_YYYY');
   dbms_output.enable;
   while sysdate>next_end loop
      sql_string:= 'alter table report_eb add '||next_name||' number(30)';
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
   'select pb,eb,sum(cnt) from
   (
   (select org1.name pb,org2.name eb,count(*) cnt
   from m_fx_noe fx, 
   a_organization org1,
   a_ta ta,
   a_organization org2
   where fx.prime_broker=org1.id 
   and org1.basic_status=1
   and ta.id=fx.id
   and ta.created_date between :1 and :2
   and org2.id=ta.trading_party
   and org2.basic_status=1
   group by org1.name,org2.name
   )
   union
   (select org1.name pb,org2.name eb,count(*) cnt
   from m_fx_option_noe fx, 
   a_organization org1,
   a_ta ta,
   a_organization org2
   where fx.prime_broker=org1.id 
   and org1.basic_status=1
   and ta.id=fx.id
   and ta.created_date between :3 and :4
   and org2.id=ta.trading_party
   and org2.basic_status=1
   group by org1.name,org2.name
   )
   )
group by pb,eb';
   open v_cursor for sql_string using next_start,next_end,next_start,next_end;
   loop
      fetch v_cursor into v_pb,v_eb,v_cnt;
      exit when v_cursor%NOTFOUND;
      select count(*) into i from report_eb where pb=v_pb and eb=v_eb;
      if i=1 then
         sql_string:='update report_eb set '||next_name||'=:1 where pb=:2 and eb=:3';
         execute immediate sql_string using v_cnt,v_pb,v_eb;
      else
         sql_string:='insert into report_eb(pb,eb,'||next_name||') values(:1,:2,:3)';
         execute immediate sql_string using v_pb,v_eb,v_cnt;
      end if;
   end loop;
   next_start:=next_end;
   next_end:=next_end+7;
   next_name:='W_'||to_char(next_start,'DD_MM_YYYY')||'_to_'||to_char(next_end,'DD_MM_YYYY');
   end loop;
   commit;
--rename columns
   i:=44;
   sql_string:='select column_name from user_tab_columns where table_name=''REPORT_EB'' 
   and column_id>2 order by column_id';
   open v_cursor for sql_string;
   loop
      fetch v_cursor into v_column_name;
      exit when v_cursor%NOTFOUND;
      if i>=44 then
         execute immediate 'alter table report_eb rename column '||v_column_name||' to Y2005_W'||to_char(i);
      else
         execute immediate 'alter table report_eb rename column '||v_column_name||' to Y2006_W'||to_char(i);
      end if;
      if i<53 then
         i:=i+1;
      else
         i:=1;
      end if;
   end loop;
end;
/
commit;


--get list of fields :
--select 'sum('||column_name||') '||column_name||',' from user_tab_columns where table_name='REPORT_EB' 
--and column_id>2;

drop table report_eb_temp;
create table report_eb_temp as select * from report_eb where pb like 'ABN AMRO%' or pb like 'Deutsche Bank%'
or pb like 'Citigroup%' or pb like 'Citi RGUP PB%';

delete report_eb where pb like 'ABN AMRO%' or pb like 'Deutsche Bank%'
or pb like 'Citigroup%' or pb like 'Citi RGUP PB%';

update report_eb_temp set pb='ABN AMRO' where pb like 'ABN AMRO%';
update report_eb_temp set pb='Deutsche Bank' where pb like 'Deutsche Bank%';
update report_eb_temp set pb='Citigroup PB' where pb like 'Citigroup%' or pb like 'Citi RGUP PB%';

insert into report_eb(pb,eb,Y2005_w44,Y2005_w45,Y2005_w46,Y2005_w47,Y2005_w48,Y2005_w49,Y2005_w50,Y2005_w51,Y2005_w52,Y2005_w53,Y2006_w1,Y2006_w2,Y2006_w3,Y2006_w4,Y2006_w5,Y2006_w6)
select 'ABN AMRO',eb,sum(Y2005_w44),sum(Y2005_w45),sum(Y2005_w46),sum(Y2005_w47),sum(Y2005_w48),sum(Y2005_w49),sum(Y2005_w50),
sum(Y2005_w51),sum(Y2005_w52),sum(Y2005_w53),sum(Y2006_w1),sum(Y2006_w2),sum(Y2006_w3),sum(Y2006_w4),sum(Y2006_w5),sum(Y2006_w6)
from report_eb_temp
where pb like 'ABN AMRO%'
group by pb,eb;

insert into report_eb(pb,eb,Y2005_w44,Y2005_w45,Y2005_w46,Y2005_w47,Y2005_w48,Y2005_w49,Y2005_w50,Y2005_w51,Y2005_w52,Y2005_w53,Y2006_w1,Y2006_w2,Y2006_w3,Y2006_w4,Y2006_w5,Y2006_w6)
select 'Deutsche Bank',eb,sum(Y2005_w44),sum(Y2005_w45),sum(Y2005_w46),sum(Y2005_w47),sum(Y2005_w48),sum(Y2005_w49),sum(Y2005_w50),
sum(Y2005_w51),sum(Y2005_w52),sum(Y2005_w53),sum(Y2006_w1),sum(Y2006_w2),sum(Y2006_w3),sum(Y2006_w4),sum(Y2006_w5),sum(Y2006_w6)
from report_eb_temp
where pb like 'Deutsche Bank%'
group by pb,eb;

insert into report_eb(pb,eb,Y2005_w44,Y2005_w45,Y2005_w46,Y2005_w47,Y2005_w48,Y2005_w49,Y2005_w50,Y2005_w51,Y2005_w52,Y2005_w53,Y2006_w1,Y2006_w2,Y2006_w3,Y2006_w4,Y2006_w5,Y2006_w6)
select 'Citigroup PB',eb,sum(Y2005_w44),sum(Y2005_w45),sum(Y2005_w46),sum(Y2005_w47),sum(Y2005_w48),sum(Y2005_w49),sum(Y2005_w50),
sum(Y2005_w51),sum(Y2005_w52),sum(Y2005_w53),sum(Y2006_w1),sum(Y2006_w2),sum(Y2006_w3),sum(Y2006_w4),sum(Y2006_w5),sum(Y2006_w6)
from report_eb_temp
where pb like 'Citigroup%' or pb like 'Citi RGUP PB%'
group by pb,eb;

commit;

drop table report_eb_temp;
create table report_eb_temp as select * from report_eb where eb like 'HS %' or eb like 'CX %'
or eb like 'LV %';

delete report_eb where eb like 'HS %' or eb like 'CX %' or eb like 'LV %';

update report_eb_temp set eb='HS' where eb like 'HS %';
update report_eb_temp set eb='CX' where eb like 'CX %';
update report_eb_temp set eb='LV' where eb like 'LV %';

insert into report_eb(pb,eb,Y2005_w44,Y2005_w45,Y2005_w46,Y2005_w47,Y2005_w48,Y2005_w49,Y2005_w50,Y2005_w51,Y2005_w52,Y2005_w53,Y2006_w1,Y2006_w2,Y2006_w3,Y2006_w4,Y2006_w5,Y2006_w6)
select pb,eb,sum(Y2005_w44),sum(Y2005_w45),sum(Y2005_w46),sum(Y2005_w47),sum(Y2005_w48),sum(Y2005_w49),sum(Y2005_w50),
sum(Y2005_w51),sum(Y2005_w52),sum(Y2005_w53),sum(Y2006_w1),sum(Y2006_w2),sum(Y2006_w3),sum(Y2006_w4),sum(Y2006_w5),sum(Y2006_w6)
from report_eb_temp
where eb like 'HS%'
group by eb,pb;

insert into report_eb(pb,eb,Y2005_w44,Y2005_w45,Y2005_w46,Y2005_w47,Y2005_w48,Y2005_w49,Y2005_w50,Y2005_w51,Y2005_w52,Y2005_w53,Y2006_w1,Y2006_w2,Y2006_w3,Y2006_w4,Y2006_w5,Y2006_w6)
select pb,eb,sum(Y2005_w44),sum(Y2005_w45),sum(Y2005_w46),sum(Y2005_w47),sum(Y2005_w48),sum(Y2005_w49),sum(Y2005_w50),
sum(Y2005_w51),sum(Y2005_w52),sum(Y2005_w53),sum(Y2006_w1),sum(Y2006_w2),sum(Y2006_w3),sum(Y2006_w4),sum(Y2006_w5),sum(Y2006_w6)
from report_eb_temp
where eb like 'CX%'
group by eb,pb;

insert into report_eb(pb,eb,Y2005_w44,Y2005_w45,Y2005_w46,Y2005_w47,Y2005_w48,Y2005_w49,Y2005_w50,Y2005_w51,Y2005_w52,Y2005_w53,Y2006_w1,Y2006_w2,Y2006_w3,Y2006_w4,Y2006_w5,Y2006_w6)
select pb,eb,sum(Y2005_w44),sum(Y2005_w45),sum(Y2005_w46),sum(Y2005_w47),sum(Y2005_w48),sum(Y2005_w49),sum(Y2005_w50),
sum(Y2005_w51),sum(Y2005_w52),sum(Y2005_w53),sum(Y2006_w1),sum(Y2006_w2),sum(Y2006_w3),sum(Y2006_w4),sum(Y2006_w5),sum(Y2006_w6)
from report_eb_temp
where eb like 'LV%'
group by eb,pb;

commit;

drop table report_eb_final;
create table report_eb_final(pb varchar2(255),eb varchar2(255),week varchar2(10),NOES number(10));
declare
   cursor weeks_crs is
   select column_name from user_tab_columns
   where table_name='REPORT_EB' and column_id>2
   order by column_id;
   sql_string varchar2(4000);
begin
   dbms_output.enable();
   for rec in weeks_crs loop
      sql_string:= 'insert into report_eb_final select pb,eb,'''||rec.column_name||''','||rec.column_name||
      ' from report_eb';
      dbms_output.put_line(sql_string);
      execute immediate sql_string;
   end loop;
end;
/
commit;

--select * from report_eb_final order by pb,eb,week;
