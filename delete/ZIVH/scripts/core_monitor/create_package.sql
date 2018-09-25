create or replace package core_monitor_pkg is
   procedure run_all_checks; 
   procedure clear_alerts_from_log(p_check_id in number);
   procedure check_1;                       --broken jobs check
   procedure check_2;                       --tablespace checks
   procedure check_3;                       --segments
   procedure check_4;                       --invalid objects
   procedure check_5;                       --disabled triggers
   procedure check_6;                       --disabled constraints
   procedure check_7(p_schema in varchar2); --last analyzed
end core_monitor_pkg;
/
sho err


create or replace package body core_monitor_pkg is

   procedure run_all_checks is
      cursor checks_crs is
      select rowid,check_id,params from core_monitor_checks;
      cur_date date;
      v_sql_String varchar2(500);
   begin
      select sysdate into cur_date from dual;
      for checks_rec in checks_crs loop
         if checks_rec.params is not null then
            v_sql_string:='begin core_monitor_pkg.check_'||to_char(checks_rec.check_id)||
            '('''||checks_rec.params||'''); end;' ;
         else
            v_sql_string:='begin core_monitor_pkg.check_'||to_char(checks_rec.check_id)||'; end;' ;
         end if;
         execute immediate v_sql_string;
         update core_monitor_checks set last_checked=sysdate where rowid=checks_rec.rowid;
      end loop;
   end run_all_checks;

   procedure clear_alerts_from_log(p_check_id in number) is
   begin
      if p_check_id=0 then
         delete core_monitor_alerts;
      else
         delete core_monitor_alerts
         where check_id=p_check_id;
      end if;
      commit;
   end clear_alerts_from_log;

--------------------------------------------------------------
--- check #1 : broken jobs
--------------------------------------------------------------
   procedure check_1 is
      v_check_time date;
   begin
      select sysdate into v_check_time from dual;
      insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
      select CORE_MONITOR_ALERTS_SEQ.nextval,1,v_check_time,'job '||to_char(job)||
      ' of user '||schema_user||' is broken'
      from dba_jobs where broken='Y';
      commit;
   exception when others then
      null;
   end check_1;

--------------------------------------------------------------
--- check #2 : tablespace checks
--------------------------------------------------------------
   procedure check_2 is
      cursor ts_crs is
      select tablespace_name from dba_tablespaces;
      v_ts_check_id           number(20);
      v_check_time            date;
      v_total_bytes           number(30);
      v_used_bytes            number(30);
      v_free_bytes            number(30);
      v_free_bytes_ratio      number(5,2);
      v_biggest_free_extent   number(30);
      prv_total_bytes         number(30);
      prv_used_bytes          number(30);
      prv_free_bytes          number(30);
      prv_biggest_free_extent number(30);
   begin
      select sysdate,CORE_MONITOR_TABLESPACES_SEQ.nextval 
      into v_check_time,v_ts_check_id from dual;
      for ts_rec in ts_crs loop
         select sum(bytes) into v_total_bytes
         from dba_data_files
         where tablespace_name=ts_rec.tablespace_name;
         select sum(bytes) into v_used_bytes
         from dba_segments
         where tablespace_name=ts_rec.tablespace_name;
         select sum(bytes),max(bytes) into v_free_bytes,v_biggest_free_extent
         from dba_free_space
         where tablespace_name=ts_rec.tablespace_name;
         v_free_bytes_ratio:=v_free_bytes/v_total_bytes;
         insert into core_monitor_tablespaces(ts_check_id,check_time,tablespace_name,total_bytes,used_bytes,
                                              free_bytes,free_bytes_ratio,biggest_free_extent)
                                       values(v_ts_check_id,v_check_time,ts_rec.tablespace_name,v_total_bytes,
                                              nvl(v_used_bytes,0),nvl(v_free_bytes,0),
                                              nvl(v_free_bytes_ratio,0),nvl(v_biggest_free_extent,0));
         if v_free_bytes_ratio<0.15 then
            insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
	    values(CORE_MONITOR_ALERTS_SEQ.nextval,2,v_check_time,'tablespace '||ts_rec.tablespace_name||
            ' has only '||to_char(v_free_bytes_ratio*100)||'% free space');
         end if;
         --compare this run to the previous one
         begin
            select total_bytes,used_bytes,free_bytes,biggest_free_extent
            into prv_total_bytes,prv_used_bytes,prv_free_bytes,prv_biggest_free_extent
            from core_monitor_tablespaces
            where tablespace_name=ts_rec.tablespace_name
            and ts_check_id=v_ts_check_id-1;
            
            if v_total_bytes/prv_total_bytes>1.02 then
               insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
               values(CORE_MONITOR_ALERTS_SEQ.nextval,2,v_check_time,'tablespace '||ts_rec.tablespace_name||
               ' has grown since last check by '||to_char(trunc(((v_total_bytes/prv_total_bytes)-1)*100))||' %');
            end if;            
            
            if v_used_bytes/prv_used_bytes>1.02 then
               insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
               values(CORE_MONITOR_ALERTS_SEQ.nextval,2,v_check_time,'tablespace '||ts_rec.tablespace_name||
               ' has used more space(out of the already allocated) since last check. growth is '||
               to_char(trunc(((v_used_bytes/prv_used_bytes)-1)*100))||' %');
            end if;
         exception when others then
            null;
         end;
      end loop;
      commit;
   exception when others then
      null;
   end check_2;
--------------------------------------------------------------
--- check #3 : segments
--------------------------------------------------------------
   procedure check_3 is
      v_check_time        date;
      v_segments_check_id number(20);
      v_biggest_free_extent number(30);
      prv_bytes           number(30);
      prv_extents         number(30);
      prv_max_extents     number(30); 
      prv_next_extent     number(30);
      cursor segments_crs(p_check_id number) is
      select * from core_monitor_segments
      where segment_check_id=p_check_id;
   begin
      select sysdate,CORE_MONITOR_segments_SEQ.nextval 
      into v_check_time,v_segments_check_id from dual;
      insert into core_monitor_segments
      (segment_check_id,check_time,owner,segment_name,tablespace_name,bytes,extents,max_extents,next_extent)
      select v_segments_check_id,v_check_time,owner,segment_name,tablespace_name,bytes,extents,max_extents,next_extent
      from dba_segments
      where owner<>'SYSTEM' and owner<>'SYS';
      commit;
      for segments_rec in segments_crs(v_segments_check_id) loop
         begin
            select bytes,extents,max_extents,next_extent
            into prv_bytes,prv_extents,prv_max_extents,prv_next_extent
            from core_monitor_segments
            where owner=segments_rec.owner
            and segment_name=segments_rec.segment_name
            and segment_check_id=v_segments_check_id-1;
         if segments_rec.extents>20 then
            insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
            values(CORE_MONITOR_ALERTS_SEQ.nextval,3,v_check_time,'segment '||segments_rec.owner||'.'||
            segments_rec.segment_name||' has '||segments_rec.extents||' extents allocated');
         end if;
         if segments_rec.max_extents-segments_rec.extents<10 then
            insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
            values(CORE_MONITOR_ALERTS_SEQ.nextval,3,v_check_time,'segment '||segments_rec.owner||'.'||
            segments_rec.segment_name||' is very close to it''s max extents('||
            segments_rec.max_extents-segments_rec.extents||' extents left)');
         end if;
         if segments_rec.bytes/prv_bytes>1.1 then
            insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
            values(CORE_MONITOR_ALERTS_SEQ.nextval,3,v_check_time,'segment '||segments_rec.owner||'.'||
            segments_rec.segment_name||' has grown by '||
            to_char(trunc(((segments_rec.bytes/prv_bytes)-1)*100))||'% since the last check');
         end if;
         if segments_rec.extents-2>=prv_extents then
            insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
            values(CORE_MONITOR_ALERTS_SEQ.nextval,3,v_check_time,'segment '||segments_rec.owner||'.'||
            segments_rec.segment_name||' has allocated '||
            to_char(segments_rec.extents-prv_extents)||' extents since the last check');
         end if;
         select nvl(max(bytes),0) into v_biggest_free_extent
         from dba_free_space
         where tablespace_name=segments_rec.tablespace_name;
         if v_biggest_free_extent<segments_rec.next_extent then
            insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
            values(CORE_MONITOR_ALERTS_SEQ.nextval,3,v_check_time,'segment '||segments_rec.owner||'.'||
            segments_rec.segment_name||' has no space to extend in tablespace '||segments_rec.tablespace_name);
         end if;
         exception when no_data_found then
            prv_bytes:=1;
            prv_extents:=1;
            prv_max_extents:=1;
            prv_next_extent:=1;
            insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
            values(CORE_MONITOR_ALERTS_SEQ.nextval,3,v_check_time,'segment '||segments_rec.owner||'.'||
            segments_rec.segment_name||' is new ');
         end;
         commit;
      end loop;
   exception when others then
      null;
   end check_3;
--------------------------------------------------------------
--- check #4 : invalid objects
--------------------------------------------------------------
   procedure check_4 is
      v_check_time date;
   begin
      select sysdate into v_check_time from dual;
      insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
      select CORE_MONITOR_ALERTS_SEQ.nextval,4,v_check_time,object_type||' '||owner||'.'||object_name||
      ' is invalid'
      from dba_objects where status='INVALID' and owner<>'SYS' and owner<>'SYSTEM';
      commit;
   exception when others then
      null;
   end check_4;
--------------------------------------------------------------
--- check #5 : disabled triggers
--------------------------------------------------------------
   procedure check_5 is
      v_check_time date;
   begin
      select sysdate into v_check_time from dual;
      insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
      select CORE_MONITOR_ALERTS_SEQ.nextval,5,v_check_time,'trigger '||owner||'.'||trigger_name||' is disabled'
      from dba_triggers
      where status='DISABLED';
      commit;
   exception when others then
      null;
   end check_5;
--------------------------------------------------------------
--- check #6 : disabled constraints
--------------------------------------------------------------
   procedure check_6 is
      v_check_time date;
   begin
      select sysdate into v_check_time from dual;
      insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
      select CORE_MONITOR_ALERTS_SEQ.nextval,6,v_check_time,'constraint '||constraint_name||
      ' on table '||owner||'.'||table_name||' is disabled'
      from dba_constraints
      where status='DISABLED';
      commit;
   exception when others then
      null;
   end check_6;
--------------------------------------------------------------
--- check #7 : last_analyzed
--------------------------------------------------------------
   procedure check_7(p_schema in varchar2) is
      v_check_time date;
      v_tab_shouldnt_be_analyzed number(20);
      v_ind_shouldnt_be_analyzed number(20);
   begin
      select sysdate into v_check_time from dual;
      select count(*) 
      into v_tab_shouldnt_be_analyzed
      from dba_tables
      where last_analyzed is not null
      and (owner='SYS' or owner='SYSTEM');
      if v_tab_shouldnt_be_analyzed>0 then
         insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
         values(CORE_MONITOR_ALERTS_SEQ.nextval,7,v_check_time,'user SYS or SYSTEM has analyzed tables');
      end if;
      select count(*) 
      into v_ind_shouldnt_be_analyzed
      from dba_indexes
      where last_analyzed is not null
      and (owner='SYS' or owner='SYSTEM');
      if v_ind_shouldnt_be_analyzed>0 then
         insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
         values(CORE_MONITOR_ALERTS_SEQ.nextval,7,v_check_time,'user SYS or SYSTEM has analyzed indexes');
      end if;

      insert into core_monitor_alerts(alert_id,check_id,alert_time,message)
      select CORE_MONITOR_ALERTS_SEQ.nextval,7,v_check_time,'table '||upper(p_schema)||'.'||table_name||
      ' has not been analyzed for more then 10 days'
      from dba_tables
      where (last_analyzed is null or sysdate-10>last_analyzed)
      and owner=upper(p_schema);
      
      
      commit;
   exception when others then
      null;
   end check_7;
end core_monitor_pkg;
/

sho err
