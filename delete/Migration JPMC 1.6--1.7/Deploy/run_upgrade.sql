--WHENEVER OSERROR  EXIT 99
--WHENEVER SQLERROR EXIT 99
spool run_upgrade
set sqlblanklines on
set scan off
set sqlprefix %
set echo on


create or replace procedure wait1 as 
  --*********************************
  --* wait of at least one second.  *
  --* The reason for this is to     *
  --* enable the use of SYSDATE in  *
  --* in ARCH_VERSION and avoid     *
  --* duplicate keys.               *
  --*********************************
 starttime date;
 now date;
 begin
	select sysdate into starttime from dual;
	select sysdate into now from dual;
	while starttime=now loop  
		    select sysdate into now from dual;
	end loop;
end;
/

@DeleteVega.sql

@upgrade_script.sql

exec alter_constraints('disable');

-- deleting the LOG tables
truncate table ARCH_LOG;
truncate table ARCH_UID;

@delete_old_pure.sql
@insert_pure.sql
@update_props.sql

------------------ Deactivate Sunrise protocol (start)--------------------
select 'ABOUT TO DELETE RECORD(S)' "START" from dual;
select * from arch_partner_2_msg_group msg_g
	   where msg_g.MSG_GROUP_ID in 
	   		 (select id from arch_msg_protocol_info info
			  where    msg_g.MSG_GROUP_ID=info.ID and upper(info.OUT_TRANSFORMER) like '%SUNRISE%');
delete arch_partner_2_msg_group msg_g
	   where msg_g.MSG_GROUP_ID in 
	   		 (select id from arch_msg_protocol_info info
			  where    msg_g.MSG_GROUP_ID=info.ID and upper(info.OUT_TRANSFORMER) like '%SUNRISE%');
select 'ABOUT TO DELETE RECORD(S)' "END" from dual;
------------------ Deactivate Sunrise protocol (end)----------------------

-- CR 6418 fix:START
insert into fxpb_ta (id, type)  
	select * from 
	(
	 (select id, type from fxpb_split union
	 select id, type from fxpb_trade) 
	 minus
	 select id, type from fxpb_ta
	 );
-- CR 6418 fix:END

@JPMC_1-7STF12-1B2.sql
exec wait1;
@JPMC_1-7STF12-1B4.sql
exec wait1;
@JPMC_1-7STF12-1B5.sql
exec wait1;
@JPMC_1-7STF12-1B7.sql
exec wait1;
@JPMC_1-7STF12-1B8.sql
exec wait1;
@JPMC_1-7STF12-1B16.sql
exec wait1;
@1.7.12.2.1.sql
exec wait1;
@1.7.12.3.sql
exec wait1;
@1.7.12.4.sql
exec wait1;
@1.7.12.5.1.sql
exec wait1;
@1.7.12.6.sql
exec wait1;
--drop existing index so next script can build it. 
drop index ARCH_AUDIT_UUID; 
@1.7.14.1.sql
exec wait1;
@1.7.14.1A.sql
exec wait1;
@1.7.14.1B.sql
exec wait1;
@1.7.14.2.sql
exec wait1;
@1.7.14.3.sql
exec wait1;
@1.7.14.4.sql
exec wait1;
@1.7.14.5.sql

-----Other.sql (start)--------------------------------------------------------
-- Override Origin System Defs for Linear/Option Back-Office Systems
DELETE FROM ARCH_CODE_MEMBER WHERE group_id = 1001000 AND code_key IN ('2', '3');

INSERT INTO ARCH_CODE_MEMBER ( GROUP_ID, CODE_KEY, DATA, NAME, CODE_COMMENT, STATUS ) VALUES ( 
1001000, '2', 'IRFE', 'IRFE', 'Origin System IRFE', 1); 
INSERT INTO ARCH_CODE_MEMBER ( GROUP_ID, CODE_KEY, DATA, NAME, CODE_COMMENT, STATUS ) VALUES ( 
1001000, '3', 'Murex', 'Murex', 'Origin System Murex', 1);

-- Override MAIL connector def for JP
Delete ARCH_CONN_CHECKER_DATA where PROTOCOL_NAME='MAIL';
INSERT INTO ARCH_CONN_CHECKER_DATA ( PROTOCOL_NAME, IMPLEMENTATION_CLASS,TO_CHECK ) 
	VALUES ( 'MAIL', 'com.traiana.sol.jpmc.core.engine.connector.mail.WEduMailData', 1); 
-----Other.sql (end)----------------------------------------------------------

----------- fix for CR 7644 start
-- find all persons who r missing the required property of region
-- and set it to default NYK

INSERT INTO ARCH_OBJECT_PROPS ( ID, OBJECT_ID, OBJECT_TYPE, CODE_ID,VALUE )
	select ARCH_OBJECT_PROPS_SEQ.nextval, ID,3000,1100011,'NYK' 
	from a_person 
	where id not in (
		select object_id 
		from arch_object_props a 
		where a.object_type=3000 and code_id=1100011 and a.OBJECT_ID in (
			select ID from a_person
		)
	);
----------- fix for CR 7644 end

----------- fix for CR  7714 start
-- Remove all Gapp and Volmeister addresses
-- cant delete address, because of FK in batch_data, so we applicatively delete it (status change)

-- exists in 1.6, but not in prod db:
delete ARCH_CON_MQ where address_id=1000100;
update ARCH_ADDRESS set STATUS=-1 where id=1000100;
-- exists in 1.7 only
delete ARCH_CON_MQ where address_id=1000200;
update ARCH_ADDRESS set STATUS=-1 where id=1000200;
delete ARCH_CON_MQ where address_id=1000300;
update ARCH_ADDRESS set STATUS=-1 where id=1000300;
----------- fix for CR  7714 start

----------- fix BoNY msg group (no CR) start
delete 	ARCH_PARTNER_2_MSG_GROUP where PARTNER_ID=2000039 and MSG_GROUP_ID=1000600;
----------- fix BoNY msg group (no CR) end
	


exec  ADVANCE_SEQUENCES(6000000);
INSERT INTO ARCH_VERSION ( TIMESTAMP, VERSION, DESCRIPTION, LOGFILE, SOLUTION_VERSION )
	VALUES (sysdate , '3.0.3.1', 'FULL MIGRATION (1.6.20.1 --> 1.7.14.5)', '/Arch2.0/installationLog/databaseInstall.log', '1.7.14.5');
exec alter_constraints('enable');
drop procedure wait1;

COMMIT;

set scan on
spool off
EXIT
