set pagesize 10000
set linesize 120
set serveroutput on size 1000000

DECLARE
	s_table_name  user_tables.table_name%TYPE; 
	i_num_rows    user_tables.num_rows%TYPE;
	height        index_stats.height%TYPE := 0;
	lf_rows       index_stats.lf_rows%TYPE := 0;
	del_lf_rows   index_stats.del_lf_rows%TYPE := 0;
	distinct_keys index_stats.distinct_keys%TYPE := 0;

	CURSOR c_indx IS
		SELECT	tab.table_name, ind.index_name, tab.num_rows
		FROM 	user_indexes ind
			,user_tables tab
		WHERE 	ind.table_name = tab.table_name;
      
BEGIN

	DBMS_OUTPUT.PUT_LINE (  rpad('INDEX NAME', 30, ' ') ||
				rpad('TABLE NAME', 30, ' ') ||
				lpad('#ROWS', 10, ' ') ||
				lpad('%DELETED', 10, ' ') ||
				lpad('HEIGHT',7,' ') || 
				lpad('DISTINCTIVENESS', 16, ' ')			
				);
	DBMS_OUTPUT.PUT_LINE ('-----------------------------------------------------------------------------------------------------------------');

	FOR r_indx IN c_indx LOOP
	
		EXECUTE IMMEDIATE 'analyze index ' || r_indx.index_name || ' validate structure';

		SELECT  height, DECODE(lf_rows,0,1,lf_rows), del_lf_rows, DECODE(distinct_keys, 0, 1, distinct_keys)
		INTO 	height, lf_rows, del_lf_rows, distinct_keys
		FROM 	index_stats;

		-- Index is considered as candidate for rebuild when :
		--   - when deleted entries represent 20% or more of the current entries
		--   - when the index depth is more then 4 levels.(height starts counting from 1 so > 5)
		-- Index is (possible) candidate for a bitmap index when :
		--   - distinctiveness is more than 99%
		IF ( height > 5 ) OR ( (del_lf_rows/lf_rows) > 0.2 ) THEN			
			DBMS_OUTPUT.PUT_LINE (rpad(r_indx.index_name,30,' ') ||
				rpad(r_indx.table_name, 30, ' ') ||
				lpad(r_indx.num_rows, 10, ' ') ||
				lpad(round((del_lf_rows/lf_rows)*100,2),10,' ') ||
				lpad(height-1,7,' ') || 
				lpad(round((lf_rows-distinct_keys)*100/lf_rows,2),16,' '));
		END IF;
	END LOOP;
END;
/

