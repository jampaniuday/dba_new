CREATE OR REPLACE FUNCTION policy_no_password (oowner IN VARCHAR2, ojname IN VARCHAR2) RETURN VARCHAR2 AS
	con VARCHAR2 (200);
BEGIN
   IF dbms_mview.i_am_a_refresh THEN
   	return null;
   end if;

   con := '((SYS_CONTEXT (''userenv'',''session_user'') <> ''READ_ONLY'' and SYS_CONTEXT (''userenv'',''session_user'') <> ''3RD_LEVEL_SUPPORT'') or (1=0))';
   RETURN (con);

END policy_no_password;
/
