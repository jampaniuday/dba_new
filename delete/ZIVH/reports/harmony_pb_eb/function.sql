create or replace function report_f_name(p_name     in varchar2,
                                         p_col_name in varchar2,
                                         p_tab_name in varchar2
                                        ) return varchar2 is
   i number(30);
   first_name varchar2(30);
   sql_string varchar2(4000);
begin
   first_name:=substr(p_name,1,instr(p_name,' '));
   sql_string:= 'select count(*) from '||p_tab_name||' where substr('||p_col_name||',1,instr('||p_col_name||','' ''))=:1';
   execute immediate sql_string into i using first_name;
   if i=1 then 
      return p_name;
   else
      return first_name;
   end if;
end report_f_name;
/
