set linesize 120

col pct_free format a8

SELECT	ts.tablespace_name, tssize, fssize free_total, fslargest free_largest, floor(fssize/tssize*100)||'%' pct_free
FROM	(SELECT	ts.tablespace_name, floor(sum(df.bytes)/1024/1024) tssize
	FROM	dba_tablespaces ts
		,dba_data_files df
	WHERE	ts.tablespace_name = df.tablespace_name
	GROUP BY ts.tablespace_name) ts,
	(SELECT	tablespace_name, floor(sum(bytes)/1024/1024) fssize, floor(max(bytes)/1024/1024) fslargest
	FROM	dba_free_space
	GROUP BY tablespace_name) fs
WHERE ts.tablespace_name = fs.tablespace_name;

