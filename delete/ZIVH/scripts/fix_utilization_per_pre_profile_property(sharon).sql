declare
   cursor profile_crs is select * from a_profile_property
   where profile_owner_id=30000 and key='Credit Utilization Report'
   and value like  '%Precentage%' for update;
   i number(9);
begin
   for rec in profile_crs loop
   dbms_output.put_line(rec.value);
      i:=instr(rec.value,'Precentage');
      update a_profile_property set value=substr(rec.value,1,i-1)||'Percentage'||substr(rec.value,i+10)
      where current of profile_crs;
   end loop;
end;
/
commit;


