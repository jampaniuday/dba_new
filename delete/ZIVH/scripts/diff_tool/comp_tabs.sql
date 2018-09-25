declare
   -------------------------
   -- cursors definitions
   -------------------------
   cursor tabs_crs is select table_name from dba_tables where owner='TMP2_1109153324663'
   and table_name not like 'DIFF_TABLES%';

   cursor cols_crs(p_table_name varchar2) is 
   select column_name,data_type,data_length,data_precision,data_scale
   from dba_tab_columns where owner='TMP2_1109153324663' and table_name=p_table_name
   order by column_id asc;
   
   cursor pk_crs(p_index varchar2) is
   select column_name from dba_ind_columns
   where index_owner='TMP2_1109153324663' and index_name=p_index
   order by column_position;
   
   -------------------------
   -- variables definitions
   -------------------------
   sql_string          varchar2(4000);
   datatype_string     varchar2(100);
   first_col_ind       boolean;
   command_string1     varchar2(4000);
   command_string2     varchar2(4000);
   pk_name             varchar2(40);
   pk_list             varchar2(200);
begin
   dbms_output.enable();
   execute immediate('create table TMP2_1109153324663.diff_tables(table_name varchar2(40),pk_list varchar2(200))');
   for tab_rec in tabs_crs loop
      sql_string:='create table TMP2_1109153324663.'||tab_rec.table_name||'#(';
      first_col_ind:=TRUE;
      for tab_col_rec in cols_crs(tab_rec.table_name) loop
         if tab_col_rec.data_type='NUMBER' then
            if tab_col_rec.data_scale=0 then
               datatype_string:='NUMBER('||to_char(tab_col_rec.data_precision)||')' ;
            elsif tab_col_rec.data_scale is null and tab_col_rec.data_precision is null then
               datatype_string:='NUMBER';
            else
               datatype_string:='NUMBER('||to_char(tab_col_rec.data_precision)||','||to_char(tab_col_rec.data_scale)||')' ;
            end if;
         elsif tab_col_rec.data_type='CHAR' then
            datatype_string:='CHAR('||to_char(tab_col_rec.data_length)||')' ;
         elsif tab_col_rec.data_type='VARCHAR2' then
            datatype_string:='VARCHAR2('||to_char(tab_col_rec.data_length)||')' ;
         else
            datatype_string:=tab_col_rec.data_type;   
         end if;
         if first_col_ind then
            sql_string:=sql_string||tab_col_rec.column_name||' '||datatype_string;
            first_col_ind:=FALSE;
         else
            sql_string:=sql_string||','||tab_col_rec.column_name||' '||datatype_string;
         end if;
      end loop;
      sql_string:=sql_string||')';
      execute immediate sql_string;
      sql_string:='insert into TMP2_1109153324663.'||tab_rec.table_name||'# select * from TMP2_1109153324663.'
      ||tab_rec.table_name||' minus select * from TMP1_1109153324663.'||tab_rec.table_name;
      execute immediate sql_string;


      sql_string:='create table TMP2_1109153324663.'||tab_rec.table_name||'$(';
      first_col_ind:=TRUE;
      for tab_col_rec in cols_crs(tab_rec.table_name) loop
         if tab_col_rec.data_type='NUMBER' then
            if tab_col_rec.data_scale=0 then
               datatype_string:='NUMBER('||to_char(tab_col_rec.data_precision)||')' ;
            elsif tab_col_rec.data_scale is null and tab_col_rec.data_precision is null then
               datatype_string:='NUMBER';
            else
               datatype_string:='NUMBER('||to_char(tab_col_rec.data_precision)||','||to_char(tab_col_rec.data_scale)||')' ;
            end if;
         elsif tab_col_rec.data_type='CHAR' then
            datatype_string:='CHAR('||to_char(tab_col_rec.data_length)||')' ;
         elsif tab_col_rec.data_type='VARCHAR2' then
            datatype_string:='VARCHAR2('||to_char(tab_col_rec.data_length)||')' ;
         else
            datatype_string:=tab_col_rec.data_type;   
         end if;
         if first_col_ind then
            sql_string:=sql_string||tab_col_rec.column_name||' '||datatype_string;
            first_col_ind:=FALSE;
         else
            sql_string:=sql_string||','||tab_col_rec.column_name||' '||datatype_string;
         end if;
      end loop;
      sql_string:=sql_string||')';
      execute immediate sql_string;
      sql_string:='insert into TMP2_1109153324663.'||tab_rec.table_name||'$ select * from TMP1_1109153324663.'
      ||tab_rec.table_name||' minus select * from TMP2_1109153324663.'||tab_rec.table_name;
      execute immediate sql_string;

      select constraint_name into pk_name
      from dba_constraints
      where owner='TMP2_1109153324663' and table_name=tab_rec.table_name
      and constraint_type='P';

      first_col_ind:=TRUE;
      for pk_rec in pk_crs(pk_name) loop
         if first_col_ind then
            pk_list:=pk_rec.column_name;
            first_col_ind:=FALSE;
         else
            pk_list:=pk_list||','||pk_rec.column_name;
         end if;
      end loop;
      dbms_output.put_line(tab_rec.table_name||' pk is:'||pk_list);

      ---------------------
      --clear temp tables
      ---------------------
--    sql_string:='drop table TMP2_1109153324663.'||tab_rec.table_name||'#';
--    execute immediate sql_string;
--    sql_string:='drop table TMP2_1109153324663.'||tab_rec.table_name||'$';
--    execute immediate sql_string;
   end loop;
end;
/

drop table TMP2_1109153324663.diff_tables;
drop table TMP2_1109153324663.diff_tables#;
drop table TMP2_1109153324663.a_profile_owner#;
drop table TMP2_1109153324663.a_profile_property#;
drop table TMP2_1109153324663.a_profile_owner$;
drop table TMP2_1109153324663.a_profile_property$;
drop table TMP2_1109153324663.a_uid#;
drop table TMP2_1109153324663.a_uid$;



