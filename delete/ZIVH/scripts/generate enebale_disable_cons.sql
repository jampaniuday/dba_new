set linesize 120
--disable
select 'alter table '||table_name||' disable constraint '||constraint_name||';' from user_constraints
where constraint_type='R' and table_name in
('A_LOG_MESSAGES','A_DATA_MAPPING')
;

select 'alter table '||table_name||' disable constraint '||constraint_name||';' from user_constraints
where r_constraint_name in
(select constraint_name from user_constraints
where table_name in
('A_LOG_MESSAGES','A_DATA_MAPPING')
);





