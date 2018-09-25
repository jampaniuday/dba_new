drop table core_monitor_checks;
create table core_monitor_checks
(check_id     number(5),
 name         varchar2(300),
 last_checked date,
 params       varchar2(2000))
storage(initial 10m next 10m pctincrease 0);
  
insert into core_monitor_checks(check_id,name) values(1,'broken jobs'); 
insert into core_monitor_checks(check_id,name) values(2,'tablespace checks'); 
insert into core_monitor_checks(check_id,name) values(3,'segments'); 
insert into core_monitor_checks(check_id,name) values(4,'invalid objects'); 
insert into core_monitor_checks(check_id,name) values(5,'disabled triggers'); 
insert into core_monitor_checks(check_id,name) values(6,'disabled constraints'); 
insert into core_monitor_checks(check_id,name,params) values(7,'last analyzed','ADEMO_2_0_05'); 
insert into core_monitor_checks(check_id,name,params) values(7,'last analyzed','HARMONY_1006_FINAL'); 
insert into core_monitor_checks(check_id,name,params) values(7,'last analyzed','ADEMO_1_4_05'); 
insert into core_monitor_checks(check_id,name,params) values(7,'last analyzed','HARMONY_1006_DEMO'); 
insert into core_monitor_checks(check_id,name,params) values(7,'last analyzed','JPMC_1702_DEMO'); 
insert into core_monitor_checks(check_id,name,params) values(7,'last analyzed','AIGDEMO_1_4_01'); 
insert into core_monitor_checks(check_id,name,params) values(7,'last analyzed','CITI_1_4_01'); 
insert into core_monitor_checks(check_id,name,params) values(7,'last analyzed','TRM_DEMO'); 
insert into core_monitor_checks(check_id,name,params) values(7,'last analyzed','CSFB_DEMO'); 
insert into core_monitor_checks(check_id,name,params) values(7,'last analyzed','CSFB_PILOT'); 
commit;

DROP SEQUENCE CORE_MONITOR_ALERTS_SEQ;

CREATE SEQUENCE CORE_MONITOR_ALERTS_seq
  START WITH 1
  MAXVALUE 9999999999999999999
  MINVALUE 1
  NOCYCLE;
  
 
drop table core_monitor_alerts;
create table core_monitor_alerts
(alert_id     number(20),
 check_id     number(5),
 alert_time   date,
 message      varchar2(4000),
 constraint core_monitor_alerts_pk primary key(alert_id))
storage(initial 10m next 10m pctincrease 0);
 
 
DROP SEQUENCE CORE_MONITOR_tablespaces_SEQ;

CREATE SEQUENCE CORE_MONITOR_tablespaces_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999
  MINVALUE 1
  NOCYCLE;
  
drop table core_monitor_tablespaces;
create table core_monitor_tablespaces
(ts_check_id         number(20),
 check_time          date,
 tablespace_name     varchar2(30),
 total_bytes         number(30),
 used_bytes          number(30),
 free_bytes          number(30),
 free_bytes_ratio    number(5,2),
 biggest_free_extent number(30),
 constraint core_monitor_tablespaces_pk primary key(ts_check_id,tablespace_name))
 storage(initial 10m next 10m pctincrease 0);
 
 
 
 DROP SEQUENCE CORE_MONITOR_segments_SEQ;
 
 CREATE SEQUENCE CORE_MONITOR_segments_SEQ
   START WITH 1
   MAXVALUE 9999999999999999999
   MINVALUE 1
   NOCYCLE;
   
 drop table core_monitor_segments;
 create table core_monitor_segments
 (segment_check_id    number(20),
  check_time          date,
  owner               varchar2(30),
  segment_name        varchar2(81),
  tablespace_name     varchar2(30),
  bytes               number(30),
  extents             number(30),
  max_extents         number(30),
  next_extent         number(30),
  constraint core_monitor_segments_pk primary key(segment_check_id,owner,segment_name))
  storage(initial 10m next 10m pctincrease 0);
 