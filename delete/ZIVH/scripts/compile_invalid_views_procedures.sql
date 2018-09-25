--compile invalid views
declare
   cursor invalid_views_crs is
      select object_name 
      from user_objects
      where status='INVALID'
      and object_type='VIEW';
begin
   for rec in invalid_views_crs loop
      begin
         execute immediate 'alter view '||rec.object_name||' compile;';
      exception when others then
         null;
      end;
   end loop;
end;
/

--compile invalid procedures
declare
   cursor invalid_views_crs is
      select object_name 
      from user_objects
      where status='INVALID'
      and object_type='PROCEDURE';
begin
   for rec in invalid_views_crs loop
      begin
         execute immediate 'alter procedure '||rec.object_name||' compile;';
      exception when others then
         null;
      end;
   end loop;
end;
/
