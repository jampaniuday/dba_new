-- Last Analyzed

set null ===

SELECT TO_CHAR(last_analyzed, 'DD-MON-YYYY') Day, count(*)
FROM 	user_tables
GROUP BY TO_CHAR(last_analyzed, 'DD-MON-YYYY');
