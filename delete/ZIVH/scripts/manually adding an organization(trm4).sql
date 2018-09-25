
insert into a_organization(id,type,name,namer_id,description,basic_status,basic_status_reason)
values(a_organization_seq.nextval,7,'Harmony internal',2000000,'Harmony',1,null);

--the IDs in the next two statements should be taken from a_organization after
--running the previous statement, using select max(id) from a_organization;
insert into M_ORGANIZATION_EXT(id,harmony_enabled)
values(4000047,1);

insert into a_org_role(id,org_id,role) 
values(a_org_role_seq.nextval,4000047,20000);


