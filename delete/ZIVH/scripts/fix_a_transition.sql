declare
   v_in_str varchar2(1000) :=';com.traiana.module.cds.flow.financial.transition.position.CdsTransitionPositionProcessor';
   v_in_str_pos number(10);
   v_in_str_length number(3);   
   v_parent_processor_len number(10);
   v_new_parent_processor varchar2(4000);
   cursor get_rec_crs is select * from a_transition
   where instr(parent_processor,v_in_str)>0
   for update;
begin
   v_in_str_length:=length(v_in_str);
   for rec in get_rec_crs loop
      v_in_str_pos:=instr(rec.parent_processor,v_in_str);
      v_parent_processor_len:=length(rec.parent_processor);
      if v_in_str_length=v_parent_processor_len then
         update a_transition set parent_processor=''
         where current of get_rec_crs;
      elsif v_in_str_pos=1 then
         update a_transition set parent_processor=substr(rec.parent_processor,v_in_str_length+1)
         where current of get_rec_crs;
      else
         v_new_parent_processor:=substr(rec.parent_processor,1,v_in_str_pos-1);
         v_new_parent_processor:=v_new_parent_processor||substr(rec.parent_processor,(v_in_str_pos+v_in_str_length));
         update a_transition set parent_processor=v_new_parent_processor
         where current of get_rec_crs;
      end if;
   end loop;
end;
/
commit;
