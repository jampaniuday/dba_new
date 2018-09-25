BEGIN
	dbms_stats.gather_schema_stats(
		ownname => 'HR',
		estimate_percent => NULL, -- DBMS_STATS.AUTO_SAMPLE_SIZE,
		method_opt => 'FOR ALL INDEXED COLUMNS SIZE 75',
		cascade => true );
END;
/

