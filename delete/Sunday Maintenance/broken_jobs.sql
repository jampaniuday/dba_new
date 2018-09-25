-- Broken Jobs

SELECT	job, last_date, what, failures, broken
FROM 	user_jobs
WHERE	broken = 'Y'
OR	failures > 5
OR	next_date > SYSDATE + 100;
