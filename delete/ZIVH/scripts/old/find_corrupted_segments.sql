declare
   cursor corrupted_blocks_crs is
      select file#,block# 
      from corrupted_blocks;
   v_block_id number(20);
   v_segment_name varchar2(100);
   v_ts_name varchar2(100);
   v_segment_type varchar2(100);
begin
   for rec in corrupted_blocks_crs loop
      select max(block_id) 
      into v_block_id
      from dba_extents where file_id=rec.file# and block_id<rec.block#;
      
      select owner||'.'||segment_name,tablespace_name,segment_Type 
      into v_segment_name,v_ts_name,v_segment_type
      from dba_extents where file_id=rec.file# and block_id=v_block_id;
   
      insert into corrupted_segments values(v_segment_name,v_ts_name,v_Segment_type);
   end loop;
   commit;
end;
/

      