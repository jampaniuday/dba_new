set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 

spool shrink_truncate.log

define DUMP_ID=^1

ALTER TABLESPACE TBS_STATIC_^DUMP_ID READ WRITE;

BEGIN
	FOR I IN (
						
						SELECT 'truncate table ' || T.OWNER || '.' || TABLE_NAME STATEMENT,
										'begin ' ||  T.OWNER || '.CMN_DB_UTILS_PKG.alterFksReferringTable(''disable'',''' ||
										TABLE_NAME || ''',''' || t.OWNER || '''); end;' DISABLE_STATEMENT,
										'begin ' ||  T.OWNER || '.CMN_DB_UTILS_PKG.alterFksReferringTable(''enable'',''' ||
										TABLE_NAME || ''',''' || t.OWNER || '''); end;' ENABLE_STATEMENT      
						FROM   DBA_TABLES T
						WHERE  T.OWNER = 'DMP_' || '^DUMP_ID'
						AND    (T.TABLE_NAME LIKE 'DW_%' OR T.TABLE_NAME LIKE 'DW2_%' OR
									T.TABLE_NAME LIKE 'LOG_%' OR T.TABLE_NAME LIKE '%AUDIT')) LOOP
	

		EXECUTE IMMEDIATE I.DISABLE_STATEMENT;
		EXECUTE IMMEDIATE I.STATEMENT;
		EXECUTE IMMEDIATE I.ENABLE_STATEMENT;
	END LOOP;
END;
/

ALTER TABLESPACE TBS_STATIC_^DUMP_ID READ ONLY;

spool off
exit;

