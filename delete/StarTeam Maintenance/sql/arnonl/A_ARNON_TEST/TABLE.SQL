CREATE OR REPLACE
procedure DELETE_LOG_TABLES(ROWS_COMMIT IN NUMBER := 50, DAYS_TO_DELETE IN NUMBER := 30) as

--	ROWS_COMMIT number := 50;   
--	DAYS_TO_DELETE number := 30;

   integrity_constraint EXCEPTION;
   PRAGMA EXCEPTION_INIT(integrity_constraint , -2292);

 	n number := 0;

	cursor c1 is
		select rowid
		from  SWTC_BATCH_ANSWERS where TIME < trunc(sysdate-DAYS_TO_DELETE);
     cursor c2 is
         select rowid
		 from SWTC_FLOW_INSTANCES where START_DATE < trunc(sysdate-DAYS_TO_DELETE);
     cursor c3 is
         select rowid
		 from SWTC_FLOW_ANSWERS where TIME < trunc(sysdate-DAYS_TO_DELETE);
     cursor c4 is
         select rowid
		 from SWTC_MSG_CONTAINER  where TIME < trunc(sysdate-DAYS_TO_DELETE);
     cursor c5 is
         select rowid
		 from SWTC_CONVERSATION where START_DATE < trunc(sysdate-DAYS_TO_DELETE);
     cursor c6 is
         select rowid
		 from SWTC_BUSINESS_PROCESS where START_DATE < trunc(sysdate-DAYS_TO_DELETE);
     cursor c7 is
         select rowid
		 from  SWTC_NOTIFICATION_TASK where START_TIME < trunc(sysdate-DAYS_TO_DELETE);
     cursor c8 is
         select rowid
		 from  SWTC_PARTNER_MSG_AUDIT where DATE_CREATED < trunc(sysdate-DAYS_TO_DELETE);
     cursor c9 is
         select rowid
		 from  SYSTEM_ALERT where TIME < trunc(sysdate-DAYS_TO_DELETE);
     cursor c10 is
         select rowid
		 from  SYSTEM_LOG where TIME < trunc(sysdate-DAYS_TO_DELETE);

 begin

   for i in c1 loop
   	   delete from  SWTC_BATCH_ANSWERS where rowid = i.rowid;
	   n := n+1;
       if mod(n,ROWS_COMMIT) = 0 then
       	  commit;
       end if;
   end loop;
   commit;

   for i in c2 loop
   	   delete from  SWTC_FLOW_INSTANCES where rowid = i.rowid;
	   n := n+1;
	    if mod(n,ROWS_COMMIT) = 0 then
	       commit;
	    end if;
   end loop;
   commit;

   for i in c3 loop
   	   delete from  SWTC_FLOW_ANSWERS where rowid = i.rowid;
	   n := n+1;
	   if mod(n,ROWS_COMMIT) = 0 then
	   	  commit;
	   end if;
   end loop;
   commit;

   for i in c4 loop
   	   delete from  SWTC_MSG_CONTAINER where rowid = i.rowid;
	   n := n+1;
	    if mod(n,ROWS_COMMIT) = 0 then
	       commit;
	    end if;
   end loop;
   commit;

   for i in c5 loop
	   begin
       delete from  SWTC_CONVERSATION where rowid = i.rowid;
	   n := n+1;
	    if mod(n,ROWS_COMMIT) = 0 then
	       commit;
	    end if;
exception
       when integrity_constraint then
 	  null; -- ignore deletion of a linked row
   end;
   end loop;
   commit;

   for i in c6 loop
   	   begin
	       delete from  SWTC_BUSINESS_PROCESS where rowid = i.rowid;
		   n := n+1;
		    if mod(n,ROWS_COMMIT) = 0 then
		       commit;
		    end if;
	exception
			 when integrity_constraint then
			 	  null; -- ignore deletion of a linked row
	   end;
   end loop;
   commit;

   for i in c7 loop
       delete from  SWTC_NOTIFICATION_TASK where rowid = i.rowid;
	   n := n+1;
	    if mod(n,ROWS_COMMIT) = 0 then
	       commit;
	    end if;
   end loop;
   commit;

   for i in c8 loop
       delete from  SWTC_PARTNER_MSG_AUDIT where rowid = i.rowid;
	   n := n+1;
	    if mod(n,ROWS_COMMIT) = 0 then
	       commit;
	    end if;
   end loop;
   commit;

   for i in c9 loop
       delete from  SYSTEM_ALERT where rowid = i.rowid;
	   n := n+1;
	    if mod(n,ROWS_COMMIT) = 0 then
	       commit;
	    end if;
   end loop;
   commit;

   for i in c10 loop
       delete from  SYSTEM_LOG where rowid = i.rowid;
	   n := n+1;
	   if mod(n,ROWS_COMMIT) = 0 then
	       commit;
	   end if;
   end loop;
   commit;

	execute immediate('alter index SWTC_BUSINESS_PROCESS_PK rebuild');
	execute immediate('alter index SWTC_CONVERSATION_PK rebuild');
	execute immediate('alter index SWTC_CONVERSATION_IDX1 rebuild');
	execute immediate('alter index SWTC_FLOW_ANSWERS_PK rebuild');
	execute immediate('alter index SWTC_FLOW_INSTANCES_IDX1 rebuild');
	execute immediate('alter index SWTC_FLOW_INSTANCES_PK rebuild');
	execute immediate('alter index SWTC_MSG_CONTAINER_PK rebuild');
	execute immediate('alter index SWTC_MSGCNT_UUID_INDEX rebuild');
	execute immediate('alter index SWTC_NOTIFICATION_TASK_PK rebuild');
	execute immediate('alter index SWTC_MSGADT_CERT_INDEX rebuild');
	execute immediate('alter index SWTC_MSGADT_UUID_INDEX rebuild');
	execute immediate('alter index SWTC_PARTNER_MSG_AUDIT_PK rebuild');
	execute immediate('alter index SYSTEM_ALERT_PK rebuild');
	execute immediate('alter index SYSTEM_LOG_IDX1 rebuild');
	execute immediate('alter index SYSTEM_LOG_IDX2 rebuild');
	execute immediate('alter index SYSTEM_LOG_PK rebuild');

   dbms_output.put_line(n|| ' ROWS DELETED');

 end DELETE_LOG_TABLES;
/
