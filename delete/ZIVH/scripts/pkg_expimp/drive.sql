declare
   v_str varchar2(2000):='''A_LOG'',''A_AUDIT''';
   v_OTHER_TABLES varchar2(16000);
begin
   dbms_output.enable();
   v_OTHER_TABLES:=pkg_expimp.fc_get_other_tables('EMPTY',v_str);
   while v_OTHER_TABLES is not null loop
      dbms_output.put_line(pkg_expimp.fc_parse_first(v_OTHER_TABLES));
   end loop;
end;   
/

   
   