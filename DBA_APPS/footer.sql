EXEC DBMS_UTILITY.compile_schema(user,false);

Prompt Selecting invalid objects:
select object_name,object_type from user_objects where status <> 'VALID';

-- generate create synonyms
BEGIN
  FOR curr IN (
    select 'create or replace public synonym '||object_name||' for DBA_APPS.'||object_name cmd
    from user_objects
    where object_type in
    ('SEQUENCE','PROCEDURE','PACKAGE','FUNCTION','TABLE','VIEW','MATERIALIZED VIEW')
	  and object_name not in ('USER_ARCHIVE_DEFINITIONS')
	)
  LOOP
     execute immediate (curr.cmd);
  END LOOP;
END;
/

-- generate grants
BEGIN
  FOR curr IN (
    SELECT 'grant select on ' || object_name || ' to public' cmd
    FROM user_objects
    WHERE object_type IN ('SEQUENCE', 'VIEW', 'MATERIALIZED VIEW')
	and object_name not in ('USER_ARCHIVE_DEFINITIONS', 'ALL_ARCHIVE_DEFINITIONS', 'V_DDL_BLOCKER_MONITOR', 'V_MON_ACTIVE_REDO'))
  LOOP
     execute immediate (curr.cmd);
  END LOOP;
END;
/

BEGIN
  FOR curr IN (
    SELECT 'grant select, insert on ' || object_name || ' to public' cmd
    FROM user_objects
    WHERE object_type IN ('TABLE')
	and object_name not in ('USER_ARCHIVE_DEFINITIONS', 'ALL_ARCHIVE_DEFINITIONS'))
  LOOP
     execute immediate (curr.cmd);
  END LOOP;
END;
/


BEGIN
  FOR curr IN (
    SELECT 'grant execute on ' || object_name || ' to public' cmd
    FROM user_objects
    WHERE object_type IN ('FUNCTION', 'PROCEDURE', 'PACKAGE'))
  LOOP
     execute immediate (curr.cmd);
  END LOOP;
END;
/

