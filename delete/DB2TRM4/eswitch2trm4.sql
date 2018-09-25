----------------------------------------------
-- Spec tracking:
-- 	Initial Documet: TRM 4 Table Mapping1.1.doc branch level 1
--
--Scipt Tracking
--	
----------------------------------------------

@HEADINGS.SQL

------------------------------------
--  2.2.1 ACCOUNTS:
------------------------------------

/**********************************/
/* 2.2.1.2 Owned Accounts         */
/**********************************/

-- STEP 1: A_ACCOUNT
INSERT INTO ^trm.A_ACCOUNT (
	id, 
	type, 
	basic_status, 
	name,
	basic_status_reason)
SELECT 
	tmp.ACCOUNT_ID+^incID, 
	tmp.type /*decode(tmp.type,-1,-1,^nTODO)*/ ,
	CASE when DM_STATUS > 1then 2 else decode(tmp.status,1,1,2,0,^nTODO) end, 
	tmp.name, 
	^mReason
FROM 	(
SELECT 
		MIN(A.ID) as ACCOUNT_ID, 
		MIN(A.type) as type, 
		MIN(A.status) as status,
		MIN(DM.STATUS) as DM_STATUS,
		MIN(LE.NAME||' Owned (eSwitch: '||(A.ID)||')') as NAME
	FROM
		^eswitch.A_ACCOUNT A,
		^eswitch.A_DATA_MAPPING DM, 
		^eswitch.A_LEGAL_ENTITY LE, 
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE
	WHERE
		A.DOMAIN_ID in (^domain)
		AND DM.INTERNAL_VALUE = A.ID
	    AND DM.MAP_TYPE = 4
		AND DM.PARTNER_ID = ^DBpartner
		AND ALE.ACCOUNT_ID = A.ID
		AND ALE.RELATION_TYPE = 1
		AND LE.ID = ALE.LEGAL_ENTITY_ID
		group by ale.LEGAL_ENTITY_ID
	) tmp ;

-- Add Mapping for Old Owned accounts (For banks  which had N owned accounts - all will be mapped to 1 new Owned Account)
INSERT INTO ^trm.MIG_OWNED_ACC_ID_MAPPING(
	   ESWITCH_ID, 
	   TRM_ID) 
SELECT
	  old_id, 
	  new_id_trm
FROM(
SELECT 	
		old_id, 
		new_id, 
		new_id + ^incID as new_id_trm, 
		a.leid, 
		a.leid+^incID as leid_trm
FROM
	(SELECT 
		ALE.ACCOUNT_ID old_id, 
		Ale.LEGAL_ENTITY_ID leid
	FROM
		^eswitch.A_ACCOUNT A,
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE
	WHERE
		A.DOMAIN_ID in (^domain)
		AND ALE.ACCOUNT_ID = A.ID
		AND ALE.RELATION_TYPE = 1
		order by ALE.LEGAL_ENTITY_ID, ALE.ACCOUNT_ID
 	) A,
	(SELECT 
		min(ALE.ACCOUNT_ID) new_id, 
		min(Ale.LEGAL_ENTITY_ID) leid
	FROM
		^eswitch.A_ACCOUNT A,
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE
	WHERE
		A.DOMAIN_ID in (^domain)
		AND ALE.ACCOUNT_ID = A.ID
		AND ALE.RELATION_TYPE = 1
		group by ALE.LEGAL_ENTITY_ID
 	) b
where a.leid=b.leid);	

-- STEP 2: A_ORG_TO_ACCOUNT
INSERT INTO ^trm.a_org_2_account (
	ID, 
	org_id,
	account_id,
	role) 
SELECT 
	^trm.A_ORG_2_ACCOUNT_SEQ.nextval,
	tmp.OWNER_LE+^incID, 
	tmp.ACCOUNT_ID+^incID,
	^OWNER
FROM 	(SELECT 
		MIN(A.ID) as ACCOUNT_ID, 
		ALE.LEGAL_ENTITY_ID as OWNER_LE
	FROM
		^eswitch.A_ACCOUNT A,
		^eswitch.A_LEGAL_ENTITY LE, 
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE
	WHERE
		A.DOMAIN_ID in (^domain)
		AND ALE.ACCOUNT_ID = A.ID
		AND ALE.RELATION_TYPE = 1
		AND LE.ID = ALE.LEGAL_ENTITY_ID
		group by ale.LEGAL_ENTITY_ID
	) tmp ;


-- STEP 3: UPDATE SEQUNECE ACCORDING TO TABLE DATA
DECLARE
	maxID 	number;
	sVal 	number;
	tmp 	number;
BEGIN
	SELECT MAX(ID) INTO maxID FROM ^trm.a_account;
	SELECT ^trm.a_account_seq.NEXTVAL INTO sVal FROM DUAL;
	IF maxID>sVal THEN 
		tmp:=maxID-sVal+1;
		EXECUTE IMMEDIATE 'ALTER SEQUENCE ^trm.a_account_seq INCREMENT BY '||tmp;
		SELECT ^trm.a_account_seq.NEXTVAL INTO sVal FROM DUAL;
		EXECUTE IMMEDIATE 'ALTER SEQUENCE ^trm.a_account_seq INCREMENT BY 1';
	END IF;
END;
/


-- 2.2.1.3.1 Account Data mapping - Owned Accounts
INSERT INTO ^trm.A_DATA_MAPPING (
	ID, 
	Namer_ID, 
	Map_Type, 
	External_Value, 
	Internal_value, 
	Basic_status, 
	type_in, 
	type_out, 
	basic_status_reason )
SELECT 	
	^trm.A_DATA_MAPPING_SEQ.nextval, 
	tmp.Namer_ID, 
	2,
	tmp.external_value,
	ACC.id,
	ACC.BASIC_STATUS, 
	0,
	0,
	^mReason 
FROM 	^trm.A_ACCOUNT ACC,
	(SELECT
		 DM.EXTERNAL_VALUE, 
		 (DM.INTERNAL_VALUE+^incID) as internal_value, 
		 DM.MAP_TYPE,
		 (LE.ID+^incID),
		 decode(DM.PARTNER_ID,100,^PBnamerID,^DBpartner,^PBnamerID,le.ID+^incID)  as Namer_id,
--		 DM.STATUS,
		 (A.ID+^incID) as ACCOUNT_ID, 
		 A.STATUS
	FROM
		 ^eSwitch.A_DATA_MAPPING DM,
		 ^eSwitch.A_ACCOUNT A,
		 ^eSwitch.A_LEGAL_ENTITY LE
	WHERE
		DM.PARTNER_ID = ^DBpartner
	  AND	DM.PARTNER_ID = LE.PARTNER_ID
	  AND 	DM.MAP_TYPE = 4
	  AND 	A.ID = DM.INTERNAL_VALUE 
	  AND 	A.DOMAIN_ID in (^domain)
	  AND	LE.DOMAIN_ID in (^domain)
	) tmp
WHERE ACC.ID=tmp.internal_value;

/********************************/
/*  2.2.1.2 Coupled Accounts  */
/********************************/


-- 2.2.1.2.1 Coupled accounts + Relations (owned by original user)
-- STEP 1: CREATE COUPLED ACCOUNT (owned by original owner)
INSERT INTO ^trm.A_Account (
	id,
	type, 
	basic_status, 	
	name, 
	basic_status_reason, 
	description) 
SELECT 
	^trm.A_ACCOUNT_SEQ.nextval,
	decode(tmp.type,1,1,2,0,^nTODO), 
	decode(tmp.status,1,1,2,0,^nTODO) status, 
	tmp.name, 
	^mReason,
	tmp.id
FROM	(
	SELECT 	
		A.type,
		A.id,
		LE_O.NAME||' Coupled (eSwitch: '||(A.ID)||')' NAME,
		LE_O.STATUS STATUS
	FROM  
		^eswitch.A_ACCOUNT A,  
		^eswitch.A_LEGAL_ENTITY LE,   
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_O, 
		^eswitch.A_LEGAL_ENTITY LE_O,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_PB, 
		^eswitch.A_LEGAL_ENTITY LE_PB  
	WHERE  	A.DOMAIN_ID in (^domain)  
	  AND 	ALE.ACCOUNT_ID = A.ID  
	  AND 	ALE.RELATION_TYPE = 8 -- Coupled
	  AND 	LE.ID = ALE.LEGAL_ENTITY_ID
	  AND 	ALE_O.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_O.RELATION_TYPE = 1 -- Owner
	  AND 	LE_O.ID = ALE_O.LEGAL_ENTITY_ID
	  AND 	ALE_PB.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_PB.RELATION_TYPE = 4 -- PB
	  AND 	LE_PB.ID = ALE_PB.LEGAL_ENTITY_ID 
	) tmp;


-- STEP 2: "Coupled Owner" relation
INSERT INTO ^trm.A_ORG_2_ACCOUNT (
	ID, 
	Org_ID, 
	Account_ID,
	Role )
SELECT 
	^trm.a_account_seq.NEXTVAL,
	tmp.OrgID+^incID,
	a2.id,
	^OwnerCoupledAcc
FROM	^trm.A_Account A2,
	(SELECT 	
		ALE_O.LEGAL_ENTITY_ID OrgID,
		ALE.ACCOUNT_ID AccountID,
		A.id
	FROM  
		^eswitch.A_ACCOUNT A,  
		^eswitch.A_LEGAL_ENTITY LE,   
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_O, 
		^eswitch.A_LEGAL_ENTITY LE_O,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_PB, 
		^eswitch.A_LEGAL_ENTITY LE_PB  
	WHERE  	A.DOMAIN_ID in (^domain)  
	  AND 	ALE.ACCOUNT_ID = A.ID  
	  AND 	ALE.RELATION_TYPE = 8 -- Coupled
	  AND 	LE.ID = ALE.LEGAL_ENTITY_ID
	  AND 	ALE_O.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_O.RELATION_TYPE = 1 -- Owner
	  AND 	LE_O.ID = ALE_O.LEGAL_ENTITY_ID
	  AND 	ALE_PB.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_PB.RELATION_TYPE = 4 -- PB
	  AND 	LE_PB.ID = ALE_PB.LEGAL_ENTITY_ID 
	) tmp
WHERE tmp.id=to_number(a2.description);


-- STEP 3: "Coupled" relatoin (Coupled Org)
INSERT INTO ^trm.A_ORG_2_ACCOUNT (
	ID, 
	Org_ID, 
	Account_id,
	Role )
SELECT 
	^trm.a_account_seq.NEXTVAL,
	tmp.OrgID+^incID,
	a2.id,
	^CoupledOrg
FROM	^trm.A_Account A2,
	(SELECT 	
		ALE.LEGAL_ENTITY_ID OrgID,
		ALE.ACCOUNT_ID AccountID
	FROM  
		^eswitch.A_ACCOUNT A,  
		^eswitch.A_LEGAL_ENTITY LE,   
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_O, 
		^eswitch.A_LEGAL_ENTITY LE_O,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_PB, 
		^eswitch.A_LEGAL_ENTITY LE_PB  
	WHERE  	A.DOMAIN_ID in (^domain)  
	  AND 	ALE.ACCOUNT_ID = A.ID  
	  AND 	ALE.RELATION_TYPE = 8 -- Coupled
	  AND 	LE.ID = ALE.LEGAL_ENTITY_ID
	  AND 	ALE_O.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_O.RELATION_TYPE = 1 -- Owner
	  AND 	LE_O.ID = ALE_O.LEGAL_ENTITY_ID
	  AND 	ALE_PB.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_PB.RELATION_TYPE = 4 -- PB
	  AND 	LE_PB.ID = ALE_PB.LEGAL_ENTITY_ID 
	) tmp
WHERE tmp.AccountID=to_number(a2.description);


-- STEP 4: "Coupled" relatoin (PB)
INSERT INTO ^trm.A_ORG_2_ACCOUNT (
	ID, 
	Org_ID, 
	Account_ID,
	Role )
SELECT 
	^trm.a_account_seq.NEXTVAL,
	tmp.OrgID+^incID,
	A2.ID,
	^CoupledOrg
FROM	^trm.A_Account A2,
	(SELECT 	
		ALE_PB.LEGAL_ENTITY_ID OrgID,
		ALE.ACCOUNT_ID AccountID
	FROM  
		^eswitch.A_ACCOUNT A,  
		^eswitch.A_LEGAL_ENTITY LE,   
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_O, 
		^eswitch.A_LEGAL_ENTITY LE_O,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_PB, 
		^eswitch.A_LEGAL_ENTITY LE_PB  
	WHERE  	A.DOMAIN_ID in (^domain)  
	  AND 	ALE.ACCOUNT_ID = A.ID  
	  AND 	ALE.RELATION_TYPE = 8 -- Coupled
	  AND 	LE.ID = ALE.LEGAL_ENTITY_ID
	  AND 	ALE_O.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_O.RELATION_TYPE = 1 -- Owner
	  AND 	LE_O.ID = ALE_O.LEGAL_ENTITY_ID
	  AND 	ALE_PB.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_PB.RELATION_TYPE = 4 -- PB
	  AND 	LE_PB.ID = ALE_PB.LEGAL_ENTITY_ID 
	) tmp
WHERE tmp.AccountID=to_number(a2.description);


-- 2.2.1.3.2 A - Coupled accounts data mapping
insert into ^trm.A_DATA_MAPPING (
	ID, 
	namer_id, 
	map_type, 
	external_value, 
	internal_value, 
	basic_status, 
	type_in, 
	type_out,
	basic_status_reason )
SELECT 
	^trm.A_DATA_MAPPING_SEQ.nextval, 
	^PBnamerID, 
	2,
	ACC.Name,
	ACC.ID,
	ACC.BASIC_STATUS,
--	1,  
	0,
	0,
	^mReason
FROM	^trm.A_ACCOUNT ACC
WHERE	ACC.Description is not null;
	

-- clear old id's from description for coupled-accounts use.
UPDATE ^trm.A_ACCOUNT SET DESCRIPTION=NULL;
	

/**********************************/
/*  2.2.1.2 Coupled Accounts      */
/**********************************/


-- 2.2.1.2.2 Coupled Account + Relations (Owned by original coupled organization)
-- STEP 5: CREATE COUPLED ACCOUNT (owned by original owner)
INSERT INTO ^trm.A_Account (
	id,
	type, 
	basic_status, 	
	name, 
	basic_status_reason,
	description) 
SELECT 
	^trm.A_ACCOUNT_SEQ.nextval,
	decode(tmp.type,1,1,2,0,^nTODO), 
	decode(tmp.status,1,1,2,0,^nTODO) status, 
	tmp.name, 
	^mReason,
	tmp.id
FROM	(SELECT 
		A.ID,
		A.type,
		LE.NAME||' Coupled (eSwitch: '||(A.ID)||')' NAME,
		LE.STATUS STATUS 
	FROM  
		^eswitch.A_ACCOUNT A,  
		^eswitch.A_LEGAL_ENTITY LE,   
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_O, 
		^eswitch.A_LEGAL_ENTITY LE_O,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_PB, 
		^eswitch.A_LEGAL_ENTITY LE_PB  
	WHERE  	A.DOMAIN_ID in (^domain)  
	  AND 	ALE.ACCOUNT_ID = A.ID  
	  AND 	ALE.RELATION_TYPE = 8 -- Coupled
	  AND 	LE.ID = ALE.LEGAL_ENTITY_ID
	  AND 	ALE_O.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_O.RELATION_TYPE = 1 -- Owner
	  AND 	LE_O.ID = ALE_O.LEGAL_ENTITY_ID
	  AND 	ALE_PB.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_PB.RELATION_TYPE = 4 -- PB
	  AND 	LE_PB.ID = ALE_PB.LEGAL_ENTITY_ID 
	) tmp;


-- STEP 6: "Coupled Owner" relation
INSERT INTO ^trm.A_ORG_2_ACCOUNT (
	ID, 
	Org_ID, 
	Account_ID,
	Role )
SELECT 
	^trm.a_account_seq.NEXTVAL,
	tmp.OrgID+^incID,
	A2.id,
	^OwnerCoupledAcc
FROM	^trm.A_Account A2,
	(SELECT 	
		ALE.LEGAL_ENTITY_ID  OrgID,
		A.ID AccountID
	FROM  
		^eswitch.A_ACCOUNT A,  
		^eswitch.A_LEGAL_ENTITY LE,   
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_O, 
		^eswitch.A_LEGAL_ENTITY LE_O,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_PB, 
		^eswitch.A_LEGAL_ENTITY LE_PB  
	WHERE  	A.DOMAIN_ID in (^domain)  
	  AND 	ALE.ACCOUNT_ID = A.ID  
	  AND 	ALE.RELATION_TYPE = 8 -- Coupled
	  AND 	LE.ID = ALE.LEGAL_ENTITY_ID
	  AND 	ALE_O.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_O.RELATION_TYPE = 1 -- Owner
	  AND 	LE_O.ID = ALE_O.LEGAL_ENTITY_ID
	  AND 	ALE_PB.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_PB.RELATION_TYPE = 4 -- PB
	  AND 	LE_PB.ID = ALE_PB.LEGAL_ENTITY_ID 
	) tmp
WHERE tmp.AccountID=to_number(a2.description);


-- STEP 7: "Coupled" relatoin (Coupled Org)
INSERT INTO ^trm.A_ORG_2_ACCOUNT (
	ID, 
	Org_ID, 
	Account_ID,
	Role )
SELECT 
	^trm.a_account_seq.NEXTVAL,
	tmp.OrgID+^incID,
	A2.id,
	^CoupledOrg
FROM	^trm.A_Account A2,
	(SELECT 	
		ALE_O.LEGAL_ENTITY_ID  OrgID,
		ALE_O.ACCOUNT_ID AccountID
	FROM  
		^eswitch.A_ACCOUNT A,  
		^eswitch.A_LEGAL_ENTITY LE,   
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_O, 
		^eswitch.A_LEGAL_ENTITY LE_O,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_PB, 
		^eswitch.A_LEGAL_ENTITY LE_PB  
	WHERE  	A.DOMAIN_ID in (^domain)  
	  AND 	ALE.ACCOUNT_ID = A.ID  
	  AND 	ALE.RELATION_TYPE = 8 -- Coupled
	  AND 	LE.ID = ALE.LEGAL_ENTITY_ID
	  AND 	ALE_O.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_O.RELATION_TYPE = 1 -- Owner
	  AND 	LE_O.ID = ALE_O.LEGAL_ENTITY_ID
	  AND 	ALE_PB.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_PB.RELATION_TYPE = 4 -- PB
	  AND 	LE_PB.ID = ALE_PB.LEGAL_ENTITY_ID 
	) tmp
WHERE tmp.AccountID=to_number(a2.description);


-- STEP 8: "Coupled" relatoin (PB)
INSERT INTO ^trm.A_ORG_2_ACCOUNT (
	ID, 
	Org_ID, 
	Account_ID,
	Role )
SELECT 
	^trm.a_account_seq.NEXTVAL,
	tmp.OrgID+^incID,
	A2.id,
	^CoupledOrg
FROM	^trm.A_Account A2,
	(SELECT 	
		ALE_PB.LEGAL_ENTITY_ID OrgID,
		ALE.ACCOUNT_ID AccountID
	FROM  
		^eswitch.A_ACCOUNT A,  
		^eswitch.A_LEGAL_ENTITY LE,   
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_O, 
		^eswitch.A_LEGAL_ENTITY LE_O,  
		^eswitch.A_ACCOUNT_LEGAL_ENTITY ALE_PB, 
		^eswitch.A_LEGAL_ENTITY LE_PB  
	WHERE  	A.DOMAIN_ID in (^domain)  
	  AND 	ALE.ACCOUNT_ID = A.ID  
	  AND 	ALE.RELATION_TYPE = 8 -- Coupled
	  AND 	LE.ID = ALE.LEGAL_ENTITY_ID
	  AND 	ALE_O.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_O.RELATION_TYPE = 1 -- Owner
	  AND 	LE_O.ID = ALE_O.LEGAL_ENTITY_ID
	  AND 	ALE_PB.ACCOUNT_ID = ALE.ACCOUNT_ID
	  AND 	ALE_PB.RELATION_TYPE = 4 -- PB
	  AND 	LE_PB.ID = ALE_PB.LEGAL_ENTITY_ID 
	) tmp
WHERE tmp.AccountID=to_number(a2.description);


-- 2.2.1.3.2 B - Coupled accounts data mapping
insert into ^trm.A_DATA_MAPPING (
	ID, 
	namer_id, 
	map_type, 
	external_value, 
	internal_value, 
	basic_status, 
	type_in, 
	type_out,
	basic_status_reason )
SELECT 
	^trm.A_DATA_MAPPING_SEQ.nextval, 
	^PBnamerID, 
	2,
	ACC.Name,
	ACC.ID,
	ACC.BASIC_STATUS,
--	1,
	0,
	0,
	^mReason
FROM	^trm.A_ACCOUNT ACC
WHERE	ACC.Description is not null;


-- clear old id's from description.
UPDATE ^trm.A_ACCOUNT SET DESCRIPTION=NULL;

	
 ---------------------------
 -- 2.2.2 ORGANIZATIONS
 ---------------------------
 
 

 -- 2.2.2.1 Organization Definition
 -- 2.2.2.2 Organization type
 -- 2.2.2.3 Namer (partial coverage)
 INSERT INTO ^trm.A_ORGANIZATION (
 	ID,
 	name,
 	basic_status,
 	description, 
 	basic_status_reason,
	namer_id,
 	type)
 SELECT
 	le.ID+^incID, 
 	le.name, 
 	CASE when dm.STATUS > 1 then 2 else decode(le.status,1,1,2,0,4,2,^nTODO) end, 
 	'eSwitch Organization Import',
 	^mReason,
-- 	decode(le.partner_id,0,(le.id+^incID),null,(le.id+^incID),^PBnamerID),
	le.id+^incID,
	CASE
		WHEN to_number(bitand(2, ler.role)) = 2	 THEN 3	
		WHEN to_number(bitand(1, ler.role)) = 1	 THEN 4	
		WHEN to_number(bitand(4, ler.role)) = 4	 THEN 2	
		WHEN to_number(bitand(8, ler.role)) = 8	 THEN 9	
		WHEN to_number(bitand(64,ler.role)) = 64 THEN 6	
		ELSE ^nTODO
	END 
FROM	
		^eSwitch.A_LEGAL_ENTITY le,
		^eSwitch.A_DATA_MAPPING dm,
		^eSwitch.A_LEGAL_ENTITY_ROLE ler 
 WHERE	le.Domain_id in (^domain)
   AND	le.id=ler.a_legalentity_id
   AND dm.INTERNAL_VALUE = le.ID
   AND dm.map_type in (1,128)
   AND dm.TYPE = 0
   AND dm.PARTNER_ID = ^DBpartner;


 INSERT INTO ^trm.A_ORG_ROLE (
 	ID, 
	ORG_ID, 
	ROLE, 
	DESCRIPTION)
 SELECT
 	^trm.A_ORG_ROLE_SEQ.nextval,
 	le.ID+^incID, 
	CASE
		WHEN to_number(bitand(2, ler.role)) = 2	 THEN 2000002	
		WHEN to_number(bitand(1, ler.role)) = 1	 THEN 2000000	
		WHEN to_number(bitand(4, ler.role)) = 4	 THEN 2000001	
		WHEN to_number(bitand(8, ler.role)) = 8	 THEN 2000003	
		WHEN to_number(bitand(64,ler.role)) = 64 THEN 2000002
		ELSE ^nTODO
	END,  
	NULL
FROM	^eSwitch.A_LEGAL_ENTITY le,
	^eSwitch.A_LEGAL_ENTITY_ROLE ler 
 WHERE	le.Domain_id in (^domain)
   AND	le.id=ler.a_legalentity_id;

   
-- 2.2.2.1 Organization Definition (B)
INSERT INTO ^trm.M_ORGANIZATION_EXT (
	   ID, REGION, BIC_CODE, 
	   MATCHING_STALE_TIMEOUT, ALLOCATION_STALE_TIMEOUT, 
	   NOE_AUTO_ALLCOATE, 
	   IS_DIRECT, 
	   HARMONY_ENABLED, 
	   NOE_CONFIRM_SIMPLE_EXERCISE, 
	   NOE_CONFIRM_SIMPLE_FIXING, 
	   NOE_CONFIRM_SIMPLE_ECN, 
	   NOE_CONFIRM_SIMPLE_DIRECT, 
	   NOE_CONFIRM_OPTIONS_EXERCISE, 
	   NOE_CONFIRM_OPTIONS_EXPIRE, 
	   NOE_CONFIRM_OPTIONS_DIRECT, 
	   CONNECTIVITY_ENABLE, 
	   ALLOCATION_TEMPLATE, 
	   CREATE_FUND_RELATIONSHIP )
SELECT 
	ID, 
	2000000,  
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL 
FROM	^trm.A_ORGANIZATION
WHERE ID >= 4000000;

   
 
-- 2.2.2.3 Namer 
INSERT INTO ^trm.A_NAMER (
	ID, 
	name, 
	parent_namer )
SELECT
	org.Namer_ID, 
	org.name||' (' || org.ID || ')Namer',
	^PBnamerID
FROM 	^trm.A_ORGANIZATION org
WHERE	namer_id not in (^PBnamerID, ^TraianaNamer);


-- 2.2.2.4 Data Mapping
INSERT INTO ^trm.A_DATA_MAPPING (
	ID,
	Namer_ID,
	map_type,
	external_value, 
	internal_value, 
	basic_status, 
	type_in, 
	type_out, 
	basic_status_reason)
SELECT
	^trm.A_DATA_MAPPING_SEQ.nextval,
	decode(map.partner_id,100,^PBnamerID,^DBpartner,^PBnamerID,le.ID+^incID),
	decode(map.map_type,1,3,128,5,^nTODO),
	map.external_value, 
	map.internal_value+^incID,
	org.BASIC_STATUS, 
-- 	decode(le.status,1,1,2,0,4,2,^nTODO), 
	0,
	0,
	^mReason
FROM	
	^eswitch.A_DATA_MAPPING map, 
	^eswitch.A_LEGAL_ENTITY LE, 
	^trm.A_ORGANIZATION org
WHERE	
		map.map_type in (1,128)
		AND LE.PARTNER_ID = map.PARTNER_ID
		AND LE.DOMAIN_ID in (^domain)
		AND map.TYPE = 0
		AND org.ID = ( map.internal_value + ^incID);

-- 2.2.2.5 Org-Org Relations
INSERT INTO ^trm.A_ORG_2_ORG (
	ID, 
	FROM_ORG_ID, 
	TO_ORG_ID,
	ROLE )
SELECT 
	^trm.A_ORG_2_ORG_SEQ.nextval, 	
	A.FROM_LE+^incID,
	A.TO_LE+^incID, 
	^OWNER
FROM 	^eSwitch.A_LE_2_LE_ROLE A, 
	^eSwitch.A_LEGAL_ENTITY B1, 
	^eSwitch.A_LEGAL_ENTITY_ROLE B1_R, 
	^eSwitch.A_LEGAL_ENTITY B2, 
	^eSwitch.A_LEGAL_ENTITY_ROLE B2_R 
WHERE 	A.FROM_LE = B1.ID
  AND 	B1.DOMAIN_ID in (^domain)
  AND 	A.TO_LE = B2.ID
  AND 	B2.DOMAIN_ID in (^domain)
  AND 	B1_R.A_LEGALENTITY_ID = B1.ID
  AND 	B2_R.A_LEGALENTITY_ID = B2.ID
  AND 	B1_R.ROLE = 4 -- Client
  AND 	B2_R.ROLE = 8 -- Fund ;


 ---------------------------
 -- 2.2.3 PERSONS
 ---------------------------

-- 2.2.3.1 Person Definition (A)
INSERT INTO ^trm.A_PERSON (
	ID, 
	title, 
	first_name, 
	last_name, 
	user_name, 
	basic_status,
	type,
	basic_status_reason )
SELECT 
	p.ID+^incID, 
	p.title, 
	p.first_name, 
	p.last_name, 
	p.user_name || '_' || p.ID, 
	CASE when dm.STATUS > 1 then 2 else decode(p.status,1,1,2,0,4,2,^nTODO) end,
	8,
	^mReason
FROM	
		^eswitch.A_PERSON p ,
		^eswitch.A_DATA_MAPPING dm
WHERE 
	  dm.INTERNAL_VALUE(+) = p.ID		
 	   AND DM.MAP_TYPE(+)=2 -- PERSON
	  AND DM.PARTNER_ID(+) = 701
 	  AND DM.TYPE(+) = 0;


-- 2.2.3.1 Person Definition (B)
INSERT INTO ^trm.M_PERSON_EXT (
	ID, 
	LAST_ADMIN_PWD_CHANGED, 
	phone_number,
	fax_number, 
	PREFERRED_CONTACT_METHOD, 
	REGION )
SELECT 
	ID+^incID, 
	NULL, 
	phone, 
	fax, 
	1, 
	2000000
FROM	^eSwitch.A_PERSON;


-- 2.2.3.3 Person-Organization relation
INSERT INTO ^trm.A_ORG_2_PERSON (
	ID, 
	ORG_ID,
	PERSON_ID,
	ROLE )
SELECT
	^trm.A_ORG_2_PERSON_SEQ.nextval,
	ple.legal_entity_id+^incID,
	ple.person_id+^incID,
	^OWNER
FROM	
		^eSwitch.A_PERSON_LEGAL_ENTITY ple, 
		^eSwitch.A_LEGAL_ENTITY le
WHERE
	 ple.legal_entity_id = le.id
	 and le.domain_id in (^domain);


-- 2.2.3.4 Person Data Mapping
INSERT INTO ^trm.A_DATA_MAPPING (
	ID,
	NAMER_ID, 
	MAP_TYPE, 
	EXTERNAL_VALUE,
	INTERNAL_VALUE,
	BASIC_STATUS, 
	TYPE_IN,
	TYPE_OUT,
	BASIC_STATUS_REASON)
SELECT
	^trm.A_DATA_MAPPING_SEQ.NEXTVAL,
	DECODE(DM.PARTNER_ID,100,^PBnamerID,^DBpartner,^PBnamerID,LE.ID+^incID),
	4,
	DM.EXTERNAL_VALUE, 
	DM.INTERNAL_VALUE+^incID,
	DECODE(P.STATUS,1,1,2,0,4,2,^nTODO),
	0,
	0,
	^mReason
FROM	
	^eSwitch.A_DATA_MAPPING DM,
	^eSwitch.A_LEGAL_ENTITY LE, 
	^eSwitch.A_PERSON p
WHERE	
  DM.MAP_TYPE=2 -- PERSON
  AND	DM.PARTNER_ID=LE.PARTNER_ID
  AND DM.STATUS =1
  AND DM.TYPE = 0
  AND LE.DOMAIN_ID in (^domain)
  AND P.ID = DM.INTERNAL_VALUE;

	
 ---------------------------
--  8.1	TRMAdmin&Clients - add "Role Allowed":   
 ---------------------------
INSERT INTO ^trm.A_ORG_2_PERSON(
	ID, 
	ORG_ID,
	PERSON_ID,
	ROLE )
SELECT
	^trm.A_ORG_2_PERSON_SEQ.nextval,
	org.ID, 
	2000000,
	2000011
FROM	  
	^trm.A_ORGANIZATION org
WHERE
	 org.TYPE = 2 --Client
	 and org.BASIC_STATUS = 1 -- Enabled  
	 -- TODO: This condition should be removed . currently, TRM has a Bug that prevents the Report from uploading if the Organization is Disabled/Deleted
--	 and org.Id <= 4307488
	 -- TODO: This condition should be removed . currently, TRM has a Bug that prevents the Report from uploading if there is a big list of organizations with "Role Allowed"
	 ;
	 

 ---------------------------
--  8.2	"Direct" Property:   
 ---------------------------
 
 UPDATE ^trm.M_ORGANIZATION_EXT
 SET IS_DIRECT =1 where ID in (
 SELECT
 	   ler.TO_LE + ^IncID
 FROM 
 	  ^eswitch.A_LE_2_LE_ROLE ler
 WHERE
		ler.FROM_LE = 710 
	 	and ROLE = 4 --Direct
		);

 ---------------------------
--  8.3	"ECN" Type:   
 ---------------------------
-- Se t type to ECN instead of Bank Role

Update ^trm.A_ORGANIZATION set TYPE=5 where ID in (
	select 
		   distinct(lerb.A_LEGALENTITY_ID) + ^incID
	from 
		 ^eswitch.A_LEGAL_ENTITY_ROLE lerb,
		 ^eswitch.A_LEGAL_ENTITY leb, 
		 ^eswitch.A_LEGAL_ENTITY_ROLE lerf, 
		 ^eswitch.A_LE_2_LE_ROLE l2l
	where 
		 lerb.ROLE = 2 --TP
		 and lerf.ROLE = 8 -- Fund
		 and l2l.FROM_LE = lerb.A_LEGALENTITY_ID
		 and l2l.TO_LE = lerf.A_LEGALENTITY_ID
		 and l2l.ROLE = 1 -- Ownes
		 and leb.ID = lerb.A_LEGALENTITY_ID
		 and leb.DOMAIN_ID in (^domain) );
		