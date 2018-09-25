-----------------------------------------------------
--- Creation Date: 16-MAY-2004
--- Aouthor : Isaac Raz
--- Company : Traiana Inc
--- Script Target:
---	Sync database schema pure data with the matching data from production site
--- Last Update :  16-MAY-2004
------------------------------------------------------
set echo on
-- spool DBScript1-7-12-6-1.log

begin
 alter_constraints('disable');
end;
/

INSERT INTO ARCH_VERSION ( TIMESTAMP, VERSION, DESCRIPTION, LOGFILE, SOLUTION_VERSION )
	VALUES (sysdate , '1.7.12.6:1', 'Sync pure datat with production data', '/Arch2.0/installationLog/databaseInstall.log', '2.8.12.5');

--------------------------------
-------platform updates---------
--------------------------------


--------------------------------
-------solution updates---------
--------------------------------
delete ARCH_CODE_MEMBER where group_id=1100047 and CODE_KEY='SubmitterName';
delete ARCH_CODE_MEMBER where group_id=1100047 and CODE_KEY='ClientName';
delete ARCH_CODE_MEMBER where group_id=1001020 and CODE_KEY='3';
INSERT INTO ARCH_CODE_MEMBER ( GROUP_ID, CODE_KEY, DATA, NAME, CODE_COMMENT, STATUS )
	VALUES ( 1100047, 'SubmitterName', 'hrussell', 'Default Submmiter Name ', NULL, 1);
INSERT INTO ARCH_CODE_MEMBER ( GROUP_ID, CODE_KEY, DATA, NAME, CODE_COMMENT, STATUS )
	VALUES ( 1100047, 'ClientName', 'BNYOA', 'Client Name', NULL, 1);
INSERT INTO ARCH_CODE_MEMBER ( GROUP_ID, CODE_KEY, DATA, NAME, CODE_COMMENT, STATUS )
    VALUES (  1001020, '3', 'MISMATCH', 'MISMATCH', 'MISMATCH', 1);


commit;
         
begin
 alter_constraints('enable');
end;
/

-- spool off
------ END OF SCRIPT ---------