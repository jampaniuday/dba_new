delete A_ACCOUNT where ID>=4000000;
delete A_ORG_2_ACCOUNT where ID>=4000000;
delete A_ORGANIZATION where ID>=4000000;
delete M_ORGANIZATION_EXT where ID>=4000000;
delete A_NAMER where ID>=4000000;
delete A_DATA_MAPPING where ID>=4000000 and MAP_TYPE in (2, 3, 4, 5);
delete M_PERSON_EXT where ID>=4000000;
delete A_PERSON where ID>=4000000;
delete A_ORG_2_ORG where ID>=4000000;
delete A_ORG_2_PERSON where ID>=4000000;
delete A_ORG_ROLE where ID>=4000000;
delete MIG_OWNED_ACC_ID_MAPPING where TRM_ID>=4000000;

drop sequence A_ORG_2_ACCOUNT_SEQ;
CREATE SEQUENCE A_ORG_2_ACCOUNT_SEQ
  START WITH 4000000
  MINVALUE 4000000
  INCREMENT BY 1
  NOCYCLE
  CACHE 20
  NOORDER;

drop sequence A_ACCOUNT_SEQ;
CREATE SEQUENCE A_ACCOUNT_SEQ
  START WITH 4000000
  MINVALUE 4000000
  INCREMENT BY 1
  NOCYCLE
  CACHE 20
  NOORDER;

drop sequence A_DATA_MAPPING_SEQ;
CREATE SEQUENCE A_DATA_MAPPING_SEQ
  START WITH 4000000
  MINVALUE 4000000
  INCREMENT BY 1
  NOCYCLE
  CACHE 20
  NOORDER;

drop sequence A_ORG_2_ORG_SEQ;
CREATE SEQUENCE A_ORG_2_ORG_SEQ
  START WITH 4000000
  MINVALUE 4000000
  INCREMENT BY 1
  NOCYCLE
  CACHE 20
  NOORDER;

drop sequence A_ORG_2_PERSON_SEQ;
CREATE SEQUENCE A_ORG_2_PERSON_SEQ
  START WITH 4000000
  MINVALUE 4000000
  INCREMENT BY 1
  NOCYCLE
  CACHE 20
  NOORDER;

