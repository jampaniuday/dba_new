create or replace package pkg_expimp is
   function fc_parse_first(p_list in out varchar2) return varchar2;
   function fc_get_other_tables(p_owner in varchar2,
                                p_exclude_list in varchar2) return varchar2;
end pkg_expimp;
/

show error

create or replace package body pkg_expimp is

function fc_parse_first(p_list in out varchar2) return varchar2 is
   v_coma_location number(30);
   v_return        varchar2(8000);
begin
   v_coma_location:=instr(p_list,',');
   if v_coma_location=0 then
      v_return:=p_list;
      p_list:='';
   else
      v_return:=substr(p_list,1,v_coma_location-1);
      p_list:=substr(p_list,v_coma_location+1);
   end if;      
   return v_return;
end fc_parse_first;

function fc_get_other_tables(p_owner in varchar2,
                             p_exclude_list in varchar2) return varchar2 is
   TYPE cur_type is ref cursor;
   v_cursor              cur_type;
   v_cursor_sql          varchar2(4000);
   v_table_name          varchar2(50);
   v_other_tables        varchar2(16000):='';
   v_other_tables_length number(30);
begin
   v_cursor_sql:='select table_name from all_tables where owner='''||p_owner||
                 ''' and table_name not in('||upper(p_exclude_list)||') order by table_name';
   open v_cursor for v_cursor_sql;
   loop
      fetch v_cursor into v_table_name;
      exit when v_cursor%NOTFOUND;
      v_other_tables:=v_other_tables||v_table_name||',';
   end loop;
   v_other_tables_length:=length(v_other_tables);
   if v_other_tables_length>0 then --remove last coma
      v_other_tables:=substr(v_other_tables,1,v_other_tables_length-1);
   end if;
   return v_other_tables;
end fc_get_other_tables;

end pkg_expimp;
/

show error

