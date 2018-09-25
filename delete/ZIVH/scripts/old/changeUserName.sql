
exec alter_constraints('disable');

update a_data_mapping set EXTERNAL_VALUE='Israeli'
where id=2000041;

update A_ENTITY_2_PROFILE set entity='Israeli'
where entity='TRMAdmin'
and entity_type=3000
and profile_type=2000000;

update A_PERSON set user_name='Israeli'
where id=2000000;

update A_PERSON_ROLE set DESCRIPTION='Israeli'
where id=2000000;

update A_PROFILE_OWNER set NAME='Israeli'
where id=2000002;

update A_SECURITY_USER set USER_NAME='Israeli'
where id=2000000;

commit;

exec alter_constraints('enable');
