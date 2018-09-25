--instead of a_batch_param
create or replace view zivh_batch_param as select
ID,
REPORT_INTERVAL,
DESCRIPTION,
DOMAIN_ID,
TYPE,
BASIC_STATUS,
BASIC_STATUS_REASON
from a_batch_param;

--instead of a_profile_owner
create or replace view zivh_profile_owner as select
ID,
NAME,
TYPE,
PARENT_OWNER
from a_profile_owner;

--instead of a_profile_property
create or replace view zivh_profile_property as select
ID,
PROFILE_OWNER_ID,
KEY,
SEQUENCE,
EXPRESSION,
VALUE
from a_profile_property;

--instead of a_security_user
create or replace view zivh_security_user as select
ID,
PERSON_ID,
USER_NAME,
FORCE_CHANGE_PWD,
ACCOUNT_DISABLED,
IS_LOCKED,
FAILED_LOGINS_NUM,
PASSWORD
from a_security_user;

--instead of a_security_user_pwd_history
create or replace view zivh_security_user_pwd_history as select
ID,
USER_ID,
PASSWORD
from a_security_user_pwd_history;

--drop view zivh_batch_param;
--drop view zivh_profile_owner;
--drop view zivh_profile_property;
--drop view zivh_security_user;
--drop view zivh_security_user_pwd_history;
