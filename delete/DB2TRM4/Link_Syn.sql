-- Executing user should have 
--	Create synonym
--	Create database link
-- 
-- This script is to be run on the TRM Oracle Server Machine
-- Note:
--	DBName: tnsnames.ora entry on current Database Server(TRM), 
-- 		defines the eSwitch Database Server.
-- 	uName: DB Production (eSwitch) Schema Name
-- 	uPWD:  DB Production (eSwitch) Schema Password
--

BEGIN
	EXECUTE IMMEDIATE 'DROP USER ^eswitchUser CASCADE';
EXCEPTION
	WHEN OTHERS THEN NULL;
END;
/
CREATE USER ^eswitchUser IDENTIFIED BY ^eswitchUser
	DEFAULT TABLESPACE TR_DATA
	TEMPORARY TABLESPACE TEMP;
GRANT RESOURCE, CONNECT, CREATE SYNONYM, CREATE DATABASE LINK TO ^eswitchUser;


BEGIN
	EXECUTE IMMEDIATE 'DROP PUBLIC DATABASE LINK DBLink';
EXCEPTION
	WHEN OTHERS THEN NULL;
END;
/
ALTER SYSTEM SET GLOBAL_NAMES=FALSE;
CREATE PUBLIC DATABASE LINK DBLink CONNECT TO ^uName IDENTIFIED BY ^uPWD USING  '^DBName';

BEGIN
	FOR i IN (select table_name from user_tables@DBLink order by table_name) LOOP
	 	 EXECUTE IMMEDIATE 'CREATE  SYNONYM ^eswitch' || i.table_name || ' FOR ' || i.table_name || '@DBLink'; 
	END LOOP;
END;
/

