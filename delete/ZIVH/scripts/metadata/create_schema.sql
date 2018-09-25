create table meta_tables(
version              varchar2(50),
owner                varchar2(30),
table_name           varchar2(30),
tablespace_name      varchar2(30),
pct_free             number(2),
pct_used             number(2),
initial_extent       number(20),
next_extent          number(20), 
min_extents          number(20),
max_extents          number(20),
pct_increase         number(2),
degree               number(3),
cache                varchar2(5),
constraint meta_tables_pk primary key(version,owner,table_name));


create table meta_tab_columns(
version              varchar2(50),
owner                varchar2(30),
table_name           varchar2(30),
column_id            number(5),
column_name          varchar2(30),
data_type            varchar2(106),
data_length          number(5),
data_precision       number(5), 
data_scale           number(5),
nullable             varchar2(1),
constraint meta_tab_columns_pk primary key(version,owner,table_name,column_name));

create table meta_indexes(
version              varchar2(50),
owner                varchar2(30),
index_name           varchar2(30),   
table_name           varchar2(30),
tablespace_name      varchar2(30),
uniqueness           varchar2(9),
initial_extent       number(20),
next_extent          number(20), 
min_extents          number(20),
max_extents          number(20),
pct_free             number(2),
pct_increase         number(2),
constraint meta_indexes_pk primary key(version,owner,table_name,index_name));

create table meta_ind_columns(
version              varchar2(50),
owner                varchar2(30),
index_name           varchar2(30),   
table_name           varchar2(30),
column_name          varchar2(4000),
column_position      number(3),
constraint meta_ind_columns_pk primary key(version,owner,index_name,column_position));

create table meta_constraints(
version              varchar2(50),
owner                varchar2(30),
constraint_name      varchar2(30),
constraint_type      varchar2(1),
table_name           varchar2(30),
r_constraint_name    varchar2(30),
delete_rule          varchar2(9),
status               varchar2(8),
constraint meta_constraints_pk primary key(version,owner,constraint_name));

create table meta_cons_columns(
version              varchar2(50),
owner                varchar2(30),
constraint_name      varchar2(30),
table_name           varchar2(30),
column_name          varchar2(40),
position             number(3),
constraint meta_cons_columns_pk primary key(version,owner,constraint_name,column_name));

