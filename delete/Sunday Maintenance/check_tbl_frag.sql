
define block_size=8

set pagesize 10000
set linesize 120
set serveroutput on

-- col rows_space_utilization heading "rows|space|utilization"

SELECT dt.table_name as Table_name, 
	ds.extents as Num_extents, 
	dt.num_rows as Num_rows, 
	ds.blocks*&block_size as "Segment Size (k)",
	dt.blocks*&block_size as "Table Blocks HWM (k)",
	round((dt.num_rows*dt.avg_row_len)/1024,2) as "Net Used Space (k)",
	round(100*round((dt.num_rows*dt.avg_row_len)/1024,2)/(dt.blocks*&block_size),2) as "Utilization",
	dt.empty_blocks*&block_size as "Empty blocks space", 
	round(100*(dt.blocks/ds.blocks),2) AS "hwm/total blocks"
FROM 	user_tables dt, user_segments ds
WHERE 	ds.segment_name=dt.table_name
--AND	ds.extents > 5
AND	round(100*round((dt.num_rows*dt.avg_row_len)/1024,2)/(dt.blocks*&block_size),2) < 60 /*Utilization*/
and dt.num_rows > 100
ORDER BY Num_extents DESC, "Utilization" DESC;




