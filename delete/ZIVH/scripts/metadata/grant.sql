
--these permission must be granted to the running user, BY USER SYS. replace "meta_owner" with the
--running user name.
grant select on dba_tables to meta_owner;
grant select on dba_tab_columns to meta_owner;
grant select on dba_indexes to meta_owner;
grant select on dba_ind_columns to meta_owner;
grant select on dba_tablespaces to meta_owner;
grant select on dba_constraints to meta_owner;
grant select on dba_cons_columns to meta_owner;
grant select on dba_views to meta_owner;

