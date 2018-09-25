
-- This block truncate all the user tables. 
BEGIN
	alter_constraints('disable');

	-- truncate all tables
	FOR i IN (SELECT table_name FROM user_tables) LOOP
		EXECUTE IMMEDIATE 'truncate table '||i.table_name||' drop storage';
	END LOOP;
END;
/