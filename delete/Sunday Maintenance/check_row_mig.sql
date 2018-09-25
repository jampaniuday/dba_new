-- Row migration check

set pagesize 10000 linesize 120


SELECT table_name, num_rows, chain_cnt, round(((chain_cnt/num_rows)*100),2) pct_chained
FROM 	user_tables
WHERE 	chain_cnt > 0;
