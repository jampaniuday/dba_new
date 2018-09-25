-- Disabled Constraints check

set pagesize 10000 linesize 120 null ===


SELECT table_name, trigger_name
FROM 	user_triggers
WHERE 	status = 'DISABLED';
