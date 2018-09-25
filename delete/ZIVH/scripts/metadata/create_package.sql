create or replace package meta_catalog is
   procedure generate_catalog(p_version in varchar2,
                              p_owner   in varchar2);
   procedure generate_cre_script(p_version in varchar2,
                                 p_owner   in varchar2);
   procedure generate_table_script(p_version in varchar2,
                                   p_owner   in varchar2,
                                   p_table   in varchar2);
   procedure generate_diff_script(p_old_version in varchar2,
                                  p_old_owner   in varchar2,
                                  p_new_version in varchar2,
                                  p_new_owner   in varchar2);
end meta_catalog;
/

create or replace package body meta_catalog is
procedure generate_catalog(p_version in varchar2,
                           p_owner   in varchar2) is

begin
   delete meta_cons_columns where version=p_version and owner=p_owner;
   delete meta_constraints where version=p_version and owner=p_owner;
   delete meta_tab_columns where version=p_version and owner=p_owner;
   delete meta_ind_columns where version=p_version and owner=p_owner;
   delete meta_indexes where version=p_version and owner=p_owner;
   delete meta_tables where version=p_version and owner=p_owner;
   
   insert into meta_tables(version,owner,table_name,tablespace_name,pct_free,pct_used,initial_extent,next_extent,min_extents,max_extents,pct_increase,degree,cache) 
   select p_version,owner,table_name,tablespace_name,pct_free,pct_used,initial_extent,next_extent,min_extents,max_extents,pct_increase,degree,cache
   from dba_tables where owner=p_owner;

   insert into meta_tab_columns(version,owner,table_name,column_id,column_name,data_type,data_length,
   data_precision,data_scale,nullable)
   select p_version,p_owner,table_name,column_id,column_name,data_type,data_length,
   data_precision,data_scale,nullable
   from dba_tab_columns
   where owner=p_owner and table_name in(select table_name from meta_tables where version=p_version and owner=p_owner);

   insert into meta_indexes(version,owner,index_name,table_name,tablespace_name,uniqueness,initial_extent,
   next_extent,min_extents,max_extents,pct_free,pct_increase)
   select p_version,owner,index_name,table_name,tablespace_name,uniqueness,initial_extent,
   next_extent,min_extents,max_extents,pct_free,pct_increase
   from dba_indexes where owner=p_owner and index_type<>'LOB';

   insert into meta_ind_columns(version,owner,index_name,table_name,column_name,column_position)
   select p_version,p_owner,index_name,table_name,column_name,column_position
   from dba_ind_columns
   where index_owner=p_owner and index_name in(select index_name from meta_indexes where version=p_version and owner=p_owner);

   insert into meta_constraints(version,owner,constraint_name,constraint_type,table_name,
   r_constraint_name,delete_rule,status)
   select p_version,owner,constraint_name,constraint_type,table_name,r_constraint_name,delete_rule,status
   from dba_constraints where owner=p_owner ;

   insert into meta_cons_columns(version,owner,constraint_name,table_name,column_name,position)
   select p_version,owner,constraint_name,table_name,column_name,position
   from dba_cons_columns where owner=p_owner;

--sequences

   commit;
end generate_catalog;

procedure generate_cre_script(p_version in varchar2,
                              p_owner   in varchar2) is

--------------------------------------------------------
-- cursor definitions
--------------------------------------------------------
cursor get_tabs_crs is select * 
from meta_tables
where version=p_version
and owner=p_owner ;

cursor get_fk_crs is select * 
from meta_constraints 
where constraint_type='R'
and owner=p_owner
and version=p_version;

--------------------------------------------------------
-- variables definitions
--------------------------------------------------------
cons_column_name        varchar2(40);
r_table_name            varchar2(40);
r_column_name           varchar2(40);

begin
   dbms_output.enable(999999999999999);
   for tab_rec in get_tabs_crs loop
      generate_table_script(p_version,p_owner,tab_rec.table_name);
   end loop;
   dbms_output.put_line('-- ');
   dbms_output.put_line('--creating foreign key constraints');
-- after all tables are created, adding Foreign keys
   for fk_rec in get_fk_crs loop
      select table_name into r_table_name
      from meta_constraints 
      where constraint_name=fk_rec.r_constraint_name
      and owner=p_owner 
      and version=p_version;
      select column_name into r_column_name
      from meta_ind_columns
      where index_name=fk_rec.r_constraint_name
      and owner=p_owner 
      and version=p_version;
      select column_name into cons_column_name
      from meta_cons_columns
      where constraint_name=fk_rec.constraint_name
      and version=p_version
      and owner=p_owner;
      dbms_output.put_line('-- ');
      dbms_output.put_line('alter table '||fk_rec.table_name||' add(constraint '||fk_rec.constraint_name||
      ' foreign key('||cons_column_name||') references '||r_table_name||'('||r_column_name||'));');
   end loop;
end generate_cre_script;

procedure generate_table_script(p_version in varchar2,
                                p_owner   in varchar2,
                                p_table   in varchar2) is
--------------------------------------------------------
-- cursor definitions
--------------------------------------------------------
cursor get_tab_columns_crs(p_table_name varchar2) is select *
from meta_tab_columns
where version=p_version
and owner=p_owner
and table_name=p_table_name
order by column_id asc;

cursor get_tab_uq_cons(p_table_name varchar2) is select *
from meta_constraints
where version=p_version
and owner=p_owner
and table_name=p_table_name
and constraint_type='U';

cursor get_uq_cons_columns(p_uk varchar2) is select *
from meta_cons_columns
where version=p_version
and owner=p_owner
and constraint_name=p_uk
order by position asc;

cursor get_indexes_crs(p_table_name varchar2,p_table_pk varchar2) is select * 
from meta_indexes
where version=p_version
and owner=p_owner
and table_name=p_table_name
and index_name<>p_table_pk
and index_name not in(select constraint_name from meta_constraints
where version=p_version and owner=p_owner and constraint_type='U' and table_name=p_table_name);

cursor get_ind_columns_crs(p_ind_name varchar2) is select *
from meta_ind_columns
where version=p_version
and owner=p_owner
and index_name=p_ind_name
order by column_position asc;
--------------------------------------------------------
-- variables definitions
--------------------------------------------------------
datatype_string         varchar2(1000);
storage_string          varchar2(1000);
first_col_ind           boolean;
ts_name                 varchar2(50);
ts_type                 varchar2(50);
initial_extent          number(20);
next_extent             number(20);
min_extents             number(20);
max_extents             number(20);
pct_increase            number(2);
pct_free                number(2);
pct_used                number(2);
ind_columns_string      varchar2(1000);
first_ind_col_ind       boolean;
ind_storage_string      varchar2(1000);
table_pk                varchar2(50);
pk_string               varchar2(1000);
cons_column_name        varchar2(40);
r_table_name            varchar2(40);
r_column_name           varchar2(40);
uq_string               varchar2(1000);

begin
   dbms_output.enable(999999999999999);
      dbms_output.put_line('--create table '||p_table);
      dbms_output.put_line('create table '||p_table||'(');
      first_col_ind:=TRUE;
      for tab_col_rec in get_tab_columns_crs(p_table) loop
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
         if tab_col_rec.nullable='N' then
            datatype_string:=datatype_string||' NOT NULL';
         end if;
         if first_col_ind then
            dbms_output.put_line(tab_col_rec.column_name||' '||datatype_string);
            first_col_ind:=FALSE;
         else
            dbms_output.put_line(','||tab_col_rec.column_name||' '||datatype_string);
         end if;
      end loop;
      select tablespace_name into ts_name
      from meta_tables
      where table_name=p_table
      and version=p_version
      and owner=p_owner;
      select extent_management into ts_type
      from dba_tablespaces
      where tablespace_name=ts_name;
      if ts_type='LOCAL' then
         storage_string:='';
      else
         select initial_extent,next_extent,min_Extents,max_extents,pct_increase,pct_free,pct_used
         into initial_extent,next_extent,min_Extents,max_extents,pct_increase,pct_free,pct_used
         from meta_tables
         where owner=p_owner
         and version=p_version
         and table_name=p_table;
         storage_string:='STORAGE (INITIAL '||initial_extent||' NEXT '||next_extent
         ||' MINEXTENTS '||min_extents
         ||' MAXEXTENTS '||max_extents||' PCTINCREASE '||pct_increase
         ||') '||' PCTFREE '||pct_free||' PCTUSED '||pct_used;
      end if;
      begin
         select constraint_name into table_pk from meta_constraints
         where constraint_type='P' and table_name=p_table
         and owner=p_owner and version=p_version;
         pk_string:=',CONSTRAINT '||table_pk||' PRIMARY KEY ';
         first_ind_col_ind:=TRUE;
         for ind_col_rec in get_ind_columns_crs(table_pk) loop
            if first_ind_col_ind then
               pk_string:=pk_string||'('||ind_col_rec.column_name;
               first_ind_col_ind:=FALSE;
            else
               pk_string:=pk_string||','||ind_col_rec.column_name;
            end if;
         end loop;
         pk_string:=pk_string||')';
         dbms_output.put_line(pk_string);
      exception when no_data_found then
         pk_string:=null;
      end;
      for rec_uq_cons in get_tab_uq_cons(p_table) loop
         uq_string:=',CONSTRAINT '||rec_uq_cons.constraint_name||' UNIQUE(';
         first_ind_col_ind:=TRUE;
         for rec_uq_cons_columns in get_uq_cons_columns(rec_uq_cons.constraint_name) loop
            if first_ind_col_ind then
               uq_string:=uq_string||rec_uq_cons_columns.column_name;
               first_ind_col_ind:=FALSE;
            else
               uq_string:=uq_string||','||rec_uq_cons_columns.column_name;
            end if;
         end loop;
         uq_string:=uq_string||')';
         dbms_output.put_line(uq_string);
      end loop;
      dbms_output.put_line(')');
      dbms_output.put_line('TABLESPACE '||ts_name||' '||storage_string);
      dbms_output.put_line(';');
      dbms_output.put_line('');
      for ind_rec in get_indexes_crs(p_table,table_pk) loop
         if ind_rec.uniqueness='UNIQUE' then
            dbms_output.put_line('CREATE UNIQUE INDEX '||ind_rec.index_name||' ON '||ind_rec.table_name);
         else
            dbms_output.put_line('CREATE INDEX '||ind_rec.index_name||' ON '||ind_rec.table_name);
         end if;
         first_ind_col_ind:=TRUE;
         for ind_col_rec in get_ind_columns_crs(ind_rec.index_name) loop
            if first_ind_col_ind then
               dbms_output.put_line('('||ind_col_rec.column_name);
               first_ind_col_ind:=FALSE;
            else
               dbms_output.put_line(','||ind_col_rec.column_name);
            end if;
         end loop;
         select extent_management into ts_type
         from dba_tablespaces
         where tablespace_name=ind_rec.tablespace_name;
         if ts_type='LOCAL' then
            storage_string:='';
         else
            ind_storage_string:='STORAGE (INITIAL '||ind_rec.initial_extent||' NEXT '||ind_rec.next_extent
            ||' MINEXTENTS '||ind_rec.min_extents
            ||' MAXEXTENTS '||ind_rec.max_extents||' PCTINCREASE '||ind_rec.pct_increase
            ||') '||' PCTFREE '||ind_rec.pct_free;
         end if;
         dbms_output.put_line(')');
         dbms_output.put_line('TABLESPACE '||ind_rec.tablespace_name||' '||ind_storage_string);
         dbms_output.put_line(';');
      end loop;
      dbms_output.put_line('-- ');
end generate_table_script;

procedure generate_diff_script(p_old_version in varchar2,
                               p_old_owner   in varchar2,
                               p_new_version in varchar2,
                               p_new_owner   in varchar2) is

--------------------------------------------------------
-- cursor definitions
--------------------------------------------------------
--cursor for all tables that are no longer needed
cursor get_obsolete_tables is select table_name
from meta_tables
where version=p_old_version
and owner=p_old_owner
and table_name not in(select table_name from meta_tables
where version=p_new_version and owner=p_new_owner);

--cursor for all table that are new
cursor get_new_tables is select table_name
from meta_tables
where version=p_new_version
and owner=p_new_owner
and table_name not in(select table_name from meta_tables
where version=p_old_version and owner=p_old_owner);

--cursor for all tables that are in both schemas
cursor get_all_tabs_crs is select table_name 
from meta_tables
where version=p_old_version
and owner=p_old_owner
and table_name in(select table_name from meta_tables
where version=p_new_version and owner=p_new_owner);
--------------------------------------------------------
-- variables definitions
--------------------------------------------------------
i number(10);
begin
   dbms_output.enable(9999999999999999);
   dbms_output.put_line('--dropping tables that are no longer needed');
   for obsolete_tab_rec in get_obsolete_tables loop
      dbms_output.put_line('drop table '||obsolete_tab_rec.table_name||';');
   end loop;

   dbms_output.put_line('--creating new tables');
   for new_tab_rec in get_new_tables loop
      generate_table_script(p_new_version,p_new_owner,new_tab_rec.table_name);
   end loop;
   
   for all_tab_rec in get_all_tabs_crs loop
      null;
   end loop;
end generate_diff_script;

end meta_catalog;
/

sho err
