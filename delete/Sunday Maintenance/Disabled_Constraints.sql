-- Disabled Constraints check

set pagesize 10000 linesize 120


SELECT table_name, constraint_name
FROM 	user_constraints
WHERE 	status = 'DISABLED';
