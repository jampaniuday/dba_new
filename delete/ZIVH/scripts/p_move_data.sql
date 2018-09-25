procedure p_move_data(p_source_schema in varchar2,
                      p_target_schema in varchar2) is
---------------------------------------------------------------------------------
-- p_source_schema = the schema to take data from.
-- p_target_schema = the schema to put the data into.
-- Before running, compare schemas(structure).
---------------------------------------------------------------------------------
-- Ziv Himmelfarb
-- 10-11/2005
---------------------------------------------------------------------------------

begin

end p_move_data;



select table_name from tabs a
where (table_name like 'A%' or table_name like 'M%')
and table_name not in
(select table_name from user_tab_columns where 