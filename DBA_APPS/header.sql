WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK WHENEVER OSERROR  EXIT SQL.SQLCODE ROLLBACK 

declare
     lSchemaName varchar2(30) := 'DBA_APPS';
begin
  if ( SYS_CONTEXT ('USERENV', 'SESSION_USER')<> upper(lSchemaName)) THEN
         raise_application_error(-20001, 'This script should be run under DBA_APPS user only.');
  end if;
end;
/

BEGIN 
       FOR i IN (SELECT synonym_name FROM dba_synonyms WHERE table_owner='DBA_APPS')
       LOOP
                           EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM '|| I.SYNONYM_NAME;
                  END LOOP;
END;
/

