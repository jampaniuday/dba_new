drop table A_TA;
drop table A_OA;
drop table M_FX_NOE;
drop table A_TA_TA_REL;
drop table M_FX_OPTION_NOE;
drop table A_ORGANIZATION;
drop table A_PERSON;
drop table A_VAL_MD_CURRENCY;
drop table A_TA_HIS;
drop table M_FX_NOE_HIS;
drop table A_TA_TA_REL_HIS;
drop table A_VAL_MD_CURRENCY_HIS;
drop table M_FX_OPTION_NOE_HIS;
drop table A_OA_HIS;
drop table A_ROLE;
drop table A_SECURITY_GROUP;
drop table A_SECURITY_PRINCIPAL_GROUP;
drop table A_SECURITY_PRINCIPAL_ROLE;
drop table A_SECURITY_USER;

create table A_TA as select * from A_TA@citi_prod;

create table A_OA as select * from A_OA@citi_prod;

create table M_FX_NOE as select * from M_FX_NOE@citi_prod;

create table A_TA_TA_REL as select * from A_TA_TA_REL@citi_prod;

create table M_FX_OPTION_NOE as select * from M_FX_OPTION_NOE@citi_prod;

create table A_ORGANIZATION as select * from A_ORGANIZATION@citi_prod;

create table A_PERSON as select * from A_PERSON@citi_prod;

create table A_VAL_MD_CURRENCY as select * from A_VAL_MD_CURRENCY@citi_prod;

create table A_TA_HIS as select * from A_TA_HIS@citi_prod;

create table M_FX_NOE_HIS as select * from M_FX_NOE_HIS@citi_prod;

create table A_TA_TA_REL_HIS as select * from A_TA_TA_REL_HIS@citi_prod;

create table A_VAL_MD_CURRENCY_HIS as select * from A_VAL_MD_CURRENCY_HIS@citi_prod;

create table M_FX_OPTION_NOE_HIS as select * from M_FX_OPTION_NOE_HIS@citi_prod;

create table A_OA_HIS as select * from A_OA_HIS@citi_prod;

create table A_ROLE as select * from A_ROLE@citi_prod;

create table A_SECURITY_GROUP as select * from A_SECURITY_GROUP@citi_prod; 

create table A_SECURITY_PRINCIPAL_GROUP as select * from A_SECURITY_PRINCIPAL_GROUP@citi_prod;

create table A_SECURITY_PRINCIPAL_ROLE as select * from A_SECURITY_PRINCIPAL_ROLE@citi_prod;

create table A_SECURITY_USER as select * from A_SECURITY_USER@citi_prod;

exit
