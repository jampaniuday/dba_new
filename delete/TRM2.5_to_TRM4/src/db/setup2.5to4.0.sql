@headings.sql

--***** advance sequence  *********
VARIABLE MaxID number;
CREATE or REPLACE PROCEDURE ^trm.SetSeqVal(
	SeqName 	IN varchar2,
	SeqTarget 	IN number
) as
	sVal 	number;
	tmp 	number;
BEGIN 
	execute immediate 'SELECT ^trm.'||SeqName||'.NEXTVAL FROM DUAL' INTO sVal ;
	IF SeqTarget>sVal THEN 
		tmp:=SeqTarget-sVal;
		execute immediate 'ALTER SEQUENCE ^trm.'||SeqName||' INCREMENT BY '||tmp;
		execute immediate 'SELECT ^trm.'        ||SeqName||'.NEXTVAL FROM DUAL' into tmp;
		execute immediate 'ALTER SEQUENCE ^trm.'||SeqName||' INCREMENT BY 1';
	END IF;
END;
/

--------------------------------
--------- Accounts -------------
--------------------------------
-- Create Accounts	
INSERT INTO ^trm.A_Account (
	ID, 
	TYPE, 
	NAME, 
	DESCRIPTION, 
	BASIC_STATUS, 
	BASIC_STATUS_REASON
) SELECT
	(ACC.ID+^incID), 
	1, 
	ACC.External_ref,
	ACC.user_comment,
	CASE 
		WHEN SD.STATUS_VALUE=0 THEN ^nDisabled
		WHEN SD.STATUS_VALUE=1 THEN ^nEnabled
		ELSE ^nDeleted
	END,
	'^mReason'
FROM 	^oldTRM.A_ACCOUNT ACC,
	^oldTRM.ARCH_DATA_MAPPING DM,
	^oldTRM.A_STATE_DETAIL SD
WHERE 	ACC.ID<>^nOldPB
  AND	ACC.ID=DM.internal_value 
  AND 	DM.Map_type=^MapACC
  AND	ACC.STATE_ID=SD.STATE_ID
  AND 	DM.TYPE=0
;



--***** advance sequence  *********
BEGIN 
	select max(id) into :MaxID from ^trm.A_ACCOUNT;
	^trm.SetSeqVal('A_ACCOUNT_SEQ', :MaxID);
END;
/


-- update Organization <--> Account relations
INSERT INTO ^trm.a_org_2_account (
	ID, 
	org_id,
	account_id,
	role) 
SELECT 
	^trm.A_ORG_2_ACCOUNT_SEQ.nextval,
	CASE -- switch from Old PB to new PB
		WHEN org.id=^nOldPB 	THEN ^nNewPB
		ELSE (org.id+^incID)
	END ORG_ID,
	CASE -- attach old PB accounts to new PB
		WHEN ACC.id=^nOldPB 	THEN ^nNewPB
		ELSE (ACC.id+^incID)
	END ACC_ID,
	CASE
		WHEN o2o.Relation=1  THEN ^OWNER
		WHEN o2o.Relation=3  THEN ^CoupledOrg
		WHEN o2o.Relation=4  THEN ^CoupledOrg
		WHEN o2o.Relation=5  THEN ^OwnerCoupledAcc
	END ROLE
FROM 
	 ^oldTRM.A_ACCOUNT acc,
	 ^oldTRM.a_object_2_object o2o,
	 ^oldTRM.A_ORGANIZATION org
WHERE 	org.id=o2o.from_object_id AND o2o.from_object_type=1000 
  AND 	o2o.to_object_type=2000 AND o2o.to_object_id=acc.id
  AND 	o2o.relation in (1,3,4,5)
  AND NOT (o2o.from_object_id=^nOldPB and o2o.relation=1);


-- SET Account Role
INSERT INTO ^trm.A_ACCOUNT_ROLE (
	ID, 
	Account_ID, 
	Role, 
	Description)
SELECT 
	^trm.A_ACCOUNT_ROLE_SEQ.nextval, 
	TMP.ID,
	TMP.ROLE,
	TMP.REF
FROM
	(SELECT DISTINCT 
		CASE -- attach old PB accounts to new PB
			WHEN ACC.id=^nOldPB 	THEN ^nNewPB
			ELSE (ACC.id+^incID)
		END id,
		CASE
			WHEN o2o.Relation=1  THEN ^OWNER
			ELSE ^CoupledAcc
		END ROLE,
		acc.external_ref REF
	FROM 	^oldTRM.A_OBJECT_2_OBJECT O2O
		,^oldTRM.A_ACCOUNT acc
	WHERE	O2O.TO_OBJECT_ID=ACC.ID 
	  AND	O2O.TO_OBJECT_TYPE=2000
	  AND 	O2O.FROM_OBJECT_TYPE=1000
	  AND	O2O.RELATION IN (1,3,4,5)
	  AND	ACC.ID<>^nOldPB
	 ) tmp;


-- Account Data mapping
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
	CASE
		WHEN DM.Namer_ID=^nOldPB 	THEN ^nNewPB
		WHEN DM.Namer_ID=^nTraianaNamer THEN ^nTraianaNamer
		WHEN DM.Namer_ID>1000000	THEN (DM.Namer_ID+^incID)
		WHEN DM.Namer_ID=0		THEN ^nNewPB
		ELSE NULL
	END , 
	CASE  -- group_ids trm4:14 trm2.5:14
		WHEN dm.map_type=1	THEN 1	
		WHEN dm.map_type=2	THEN 2	
		WHEN dm.map_type=3	THEN 3	
		WHEN dm.map_type=4	THEN 4	
		WHEN dm.map_type=7	THEN 5	
		WHEN dm.map_type=10	THEN ^nNewPB	
		ELSE ^nError
	END,
	CASE 
		WHEN DM.STATUS in (0,1) THEN DM.external_value
		ELSE 'DELETED_'||DM.external_value||'_'||DM.STATUS
	END EXTERNAL_VALUE,
	(ACC.id+^incID),
	CASE 
		WHEN DM.STATUS=0 THEN ^nDisabled
		WHEN DM.STATUS=1 THEN ^nEnabled
		ELSE ^nDeleted
	END,
	^nType_in,
	^nType_out,
	'^mReason' 
FROM 	^oldTRM.A_ACCOUNT ACC,
	^oldTRM.ARCH_DATA_MAPPING DM
WHERE	acc.id=dm.internal_value
  AND 	DM.Map_type=^MapACC
  AND 	ACC.ID<>^nOldPB 
  AND 	DM.TYPE=0
;


--------------------------
-- COUPLED ACC  PROFILE --
--------------------------
DEFINE nProfile=2000001
INSERT INTO ^trm.A_ENTITY_2_PROFILE (
	ENTITY,	
	ENTITY_TYPE,
	PROFILE_ID,
	PROFILE_TYPE
) SELECT 
	ACC.ID, 
	2000, 
	^trm.A_PROFILE_OWNER_SEQ.NEXTVAL,
	^nProfile
FROM 	^trm.A_Account ACC, 
	^trm.A_ORG_2_ACCount O2A
WHERE	ACC.ID>^incID -- MIGRATED ACC ONLY
  AND 	ACC.ID=O2A.Account_ID 
  AND 	O2A.ROLE=2000004 -- Triple account owner
;


INSERT INTO ^trm.A_PROFILE_OWNER (
	ID, 
	NAME,
	TYPE,
	PARENT_OWNER,
	TIME
) SELECT
	E2P.PROFILE_ID,
	ACC.Name,
	0,
	^nNewPB,
	SYSDATE
FROM 	^trm.A_ENTITY_2_PROFILE E2P,
	^trm.A_Account ACC
WHERE	E2P.PROFILE_TYPE=^nProfile
  AND 	E2P.ENTITY_TYPE=2000
  AND 	E2P.ENTITY=TO_CHAR(ACC.ID)
  AND 	ACC.ID>^incID -- MIGRATED ACCs 
;
	

--------------------------------
----- ORGANIZATION -------------
--------------------------------
-- Create Organizations
 INSERT INTO ^trm.A_ORGANIZATION (
 	ID,
 	name,
	namer_id,
 	type,
 	basic_status,
 	description
 ) SELECT 
	(org.ID+^incID),
	name, 
	CASE
		WHEN Namer_ID=^nOldPB 	THEN ^nNewPB
		WHEN Namer_ID=100 	THEN ^nTraianaNamer
		WHEN Namer_ID>^nOldPB	THEN (Namer_ID+^incID)
		WHEN Namer_ID=0		THEN ^nNewPB
		ELSE NULL
	END, 
	CASE --group_ids: trm4:2000016 trm2.5:1000000 
		WHEN role.role=1000003	THEN 2
		WHEN role.role=1000002	THEN 3
		WHEN role.role=1000001	THEN 4
		WHEN role.role=1000005	THEN 6
		WHEN role.role=1000008	THEN 7
		WHEN role.role=1000007	THEN 8
		WHEN role.role=1000004	THEN 9
		ELSE ^nError
	END,
	CASE 
		WHEN sdl.STATUS_VALUE=1	THEN ^nEnabled
		WHEN sdl.STATUS_VALUE=0	THEN ^nDisabled
		ELSE ^nDeleted
	END,
	'^mReason'
FROM 	^oldTRM.A_ORGANIZATION org,
	^oldTRM.A_STATE_DETAIL sdl,
	^oldTRM.A_OBJECT_ROLE role
WHERE	org.id >= ^nLowerOrgID 
  AND	org.TYPE=1000
  AND	org.state_id=sdl.STATE_ID
  AND	org.id=role.object_id and role.object_type=1000;


--***** advance sequence  *********
BEGIN
	select max(id) into :MaxID from ^trm.A_ORGANIZATION;
	^trm.SetSeqVal('A_ORGANIZATION_SEQ',:MaxID );
END;
/


-- Copy Organization roles
 INSERT INTO ^trm.A_ORG_ROLE (
 	ID, 
	ORG_ID, 
	ROLE, 
	DESCRIPTION
) SELECT
	^trm.A_ORG_ROLE_SEQ.nextval,
	(org.ID+^incID),
	CASE
		WHEN ROLE.ROLE=1000003   THEN 2000001
		WHEN ROLE.ROLE=1000002   THEN 2000002	
		WHEN ROLE.ROLE=1000005   THEN 2000002
		WHEN ROLE.ROLE=1000004   THEN 2000003
		WHEN ROLE.ROLE=1000001   THEN 2000000
		ELSE 20000
	END,
	'^mReason'
FROM 	^oldTRM.A_ORGANIZATION org,
	^oldTRM.A_OBJECT_ROLE role
WHERE	org.id>=^nLowerOrgID
  AND	org.id=role.object_id and role.object_type=1000;


-- Add organization Extension for module
INSERT INTO ^trm.M_ORGANIZATION_EXT (
	ID, 
	REGION,
	MATCHING_STALE_TIMEOUT, 
	ALLOCATION_STALE_TIMEOUT,
	CONNECTIVITY_ENABLE
) SELECT 
	(org.ID+^incID),
	CASE -- map to M_REGION table ID
		WHEN prop.value='^NYkRegion'	THEN 2000001 --NY
		WHEN prop.value='^LDNRegion'	THEN 2000002 --London
		--WHEN prop.value='^TKYRegion'	THEN 2000003 --Tokyo
		--WHEN prop.value='^SDNRegion'	THEN 2000005 --Sedney
		--WHEN prop.value='^SGPRegion'	THEN 2000005 --Singapore
		ELSE 2000000 --All regions
	END,
	^nDefaultTimeout,
	^nDefaultTimeout, 
	0
FROM 	^oldTRM.A_ORGANIZATION org, 
	^oldTRM.ARCH_OBJECT_PROPS prop
WHERE	org.id>^nLowerOrgID 
  AND	org.id=prop.object_id(+)
  AND	prop.object_type(+)=1000
  AND	prop.code_id(+)=1100000 --region ;
      

-- Create Namers
INSERT INTO ^trm.A_NAMER (
	ID, 
	name, 
	parent_namer )
SELECT
	(oldNamer.ID+^incID),
	oldNamer.name,
	CASE 
		WHEN oldNamer.PARENT_NAMER=^nOldPB THEN ^nNewPB
		ELSE (oldNamer.PARENT_NAMER+^incID)
	END
FROM 	^oldTRM.ARCH_NAMER oldNamer
WHERE	Parent_namer<>^nTraianaNamer
  AND  	ID>=^nLowerOrgID;


--***** advance sequence  *********
BEGIN
	select max(id) into :MaxID from ^trm.A_NAMER;
	^trm.SetSeqVal('A_NAMER_SEQ',:MaxID );
END;
/


-- Organizations DataMapping 
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
	CASE
		WHEN DM.Namer_ID=^nOldPB 	THEN ^nNewPB
		WHEN DM.Namer_ID=^nTraianaNamer THEN ^nTraianaNamer
		WHEN DM.Namer_ID=0		THEN ^nNewPB
		ELSE (DM.Namer_ID+^incID)
	END , 
	CASE  -- map_type 
		WHEN DM.Map_Type=3 THEN ^MapORG
		ELSE ^MapFND
	END , 
	CASE 
		WHEN DM.STATUS in (0,1) THEN DM.external_value
		ELSE 'DELETED_'||DM.external_value||'_'||DM.STATUS
	END EXTERNAL_VALUE,
	CASE -- Map old PB accounts to new PB
		WHEN org.id=^nOldPB 	THEN ^nNewPB
		ELSE (org.id+^incID)
	END,
	CASE 
		WHEN DM.STATUS=0 THEN ^nDisabled
		WHEN DM.STATUS=1 THEN ^nEnabled
		ELSE ^nDeleted
	END,
	^nType_in,
	^nType_out,
	'^mReason' 
FROM 	^oldTRM.A_ORGANIZATION org,
	^oldTRM.ARCH_DATA_MAPPING DM
WHERE	org.id=dm.internal_value
  AND	DM.Map_Type in(3,7) -- 1=info 2=acct, 3=org,4=user, 7=fund (no 5 and 6)
  AND 	(DM.internal_value>=^nLowerOrgID OR DM.namer_id>=^nLowerOrgID)
  AND   DM.type = 0;
  
  

-- Org 2 Org relations
INSERT INTO ^trm.A_ORG_2_ORG (
	ID, 
	FROM_ORG_ID, 
	TO_ORG_ID,
	ROLE )
SELECT 
	^trm.A_ORG_2_ORG_SEQ.nextval, 	
	CASE
		WHEN o2o.FROM_OBJECT_ID=^nOldPB THEN ^nNewPB
		ELSE (o2o.FROM_OBJECT_ID+^incID)
	END,
	(o2o.TO_OBJECT_ID+^incID), 
	^OWNER
FROM 	^oldTRM.A_OBJECT_2_OBJECT o2o, --join orgs to aviod orphans
	^oldTRM.A_ORGANIZATION Org1,
	^oldTRM.A_ORGANIZATION Org2
WHERE	o2o.FROM_OBJECT_TYPE=1000 and o2o.TO_OBJECT_TYPE=1000
  AND 	o2o.from_object_id=org1.id
  AND   o2o.to_object_id=org2.id
  AND 	org1.id>=^nLowerOrgID;



-- Mark PO IsDirect organization 
UPDATE ^trm.M_ORGANIZATION_EXT  SET 
	IS_DIRECT=1
WHERE ID IN 	(
		SELECT 	OBJECT_ID+^incID
		FROM 	^oldTRM.ARCH_OBJECT_PROPS
		WHERE	OBJECT_TYPE=1000 --ORGs
		  AND	CODE_ID=1000003  --IsDirect 
		  AND 	UPPER(VALUE)='TRUE'
		);


-- Move backoffice organizations data mapping. 
-- Backoffice organizations are not migrated. Their data mapping is attached to TRM4 backoffice organizations
DECLARE
	TYPE ids_list IS VARRAY(10) OF NUMBER;
	
	oldBackoffice ids_list := ids_list(^nOldBackOffice);
	newBackoffice ids_list := ids_list(^nNewBackOffice);
	
BEGIN
	FOR i in 1..oldBackOffice.COUNT LOOP
		
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
			CASE
				WHEN DM.Namer_ID=oldBackOffice(i)	THEN newBackOffice(i)
				WHEN DM.Namer_ID=^nOldPB 		THEN ^nNewPB
				WHEN DM.Namer_ID=^nTraianaNamer 	THEN ^nTraianaNamer
				WHEN DM.Namer_ID=0			THEN ^nNewPB
				ELSE (DM.Namer_ID+^incID)
			END , 
			^MapORG, 
			CASE 
				WHEN DM.STATUS in (0,1) THEN DM.external_value
				ELSE 'DELETED_'||DM.external_value||'_'||DM.STATUS
			END EXTERNAL_VALUE,
			CASE -- Map old PB accounts to new PB
				WHEN DM.INTERNAL_VALUE=^nOldPB 		THEN ^nNewPB
				WHEN DM.INTERNAL_VALUE=newBackOffice(i)	THEN oldBackOffice(i)
				ELSE (DM.INTERNAL_VALUE+^incID)
			END INTERNAL_VALUE,
 			CASE 
				WHEN DM.STATUS=0 THEN ^nDisabled
				WHEN DM.STATUS=1 THEN ^nEnabled
				ELSE ^nDeleted
			END,
			^nType_in,
			^nType_out,
			'^mReason' 
		FROM 	^oldTRM.ARCH_DATA_MAPPING DM
		WHERE	DM.namer_id=oldBackOffice(i)
		  AND	DM.Map_Type=3 -- Org
		  AND 	DM.internal_value<>DM.namer_id;
		  
	END LOOP /*(first..last)*/;
END;
/


-- Delete obsolete backoffice organizations
UPDATE ^trm.A_ORGANIZATION SET
	basic_status = ^nDeleted,
	basic_status_reason = 'DELETED BY MIGRATION: obsolete backoffice organizations'
WHERE ID BETWEEN (^nLowDeleteID+^incID) AND (^nHighDeleteID+^incID);


------------------------------
-----  CLIENT PROFILE --------
------------------------------
-- Add 2 records for each client in A_ORG_2_RECON_COMBINATION
INSERT INTO ^trm.A_ORG_2_RECON_COMBINATION (
	ID, 
	ORG_ID, 
	COMBINATION_ID, 
	ROLE
) SELECT 
	^trm.A_ORG_2_RECON_COMBINATION_SEQ.nextval,
	Client.ID, 
	^ReconComb1,
	^OWNER
FROM 	
	^trm.A_ORGANIZATION Client
WHERE 	Client.type=2 -- Clients only ;


INSERT INTO ^trm.A_ORG_2_RECON_COMBINATION (
	ID, 
	ORG_ID, 
	COMBINATION_ID, 
	ROLE
) SELECT 
	^trm.A_ORG_2_RECON_COMBINATION_SEQ.nextval,
	Client.ID, 
	^ReconComb2,
	^OWNER
FROM 	
	^trm.A_ORGANIZATION Client
WHERE 	Client.type=2 -- Clients only ;


-- Create profile for 2000000 (ENTITY_2_PROFILE, A_PROFILE_OWNER,A_PROFILE_PROPERTY)
---------------------------------
DEFINE 	nClientProfile=2000000
INSERT INTO ^trm.A_ENTITY_2_PROFILE (
	ENTITY,	
	ENTITY_TYPE,
	PROFILE_ID,
	PROFILE_TYPE
) SELECT 
	ORG.ID, 
	1000, 
	^trm.A_PROFILE_OWNER_SEQ.NEXTVAL,
	^nClientProfile
FROM 	^trm.A_ORGANIZATION ORG
WHERE	ORG.ID>^incID -- MIGRATED CLIENTS ONLY
  AND 	ORG.TYPE=2    -- CLIENTS;


INSERT INTO ^trm.A_PROFILE_OWNER (
	ID, 
	NAME,
	TYPE,
	PARENT_OWNER,
	TIME
) SELECT
	E2P.PROFILE_ID,
	ORG.NAME,
	0,
	^nNewPB,
	SYSDATE
FROM 	^trm.A_ENTITY_2_PROFILE E2P,
	^trm.A_ORGANIZATION ORG
WHERE	E2P.PROFILE_TYPE=^nClientProfile
  AND 	E2P.ENTITY_TYPE=1000
  AND 	E2P.ENTITY=TO_CHAR(ORG.ID)
  AND 	ORG.TYPE=2    -- CLIENTS 
  AND 	ORG.ID>^incID -- MIGRATED ORGS ;
	


-- Create profile for 2000001 (ENTITY_2_PROFILE, A_PROFILE_OWNER,A_PROFILE_PROPERTY)
---------------------------------
DEFINE 	nClientProfile=2000001
INSERT INTO ^trm.A_ENTITY_2_PROFILE (
	ENTITY,	
	ENTITY_TYPE,
	PROFILE_ID,
	PROFILE_TYPE
) SELECT 
	ORG.ID, 
	1000, 
	^trm.A_PROFILE_OWNER_SEQ.NEXTVAL,
	^nClientProfile
FROM 	^trm.A_ORGANIZATION ORG
WHERE	ORG.ID>^incID -- MIGRATED ORGS ONLY
  AND 	ORG.TYPE=2    -- CLIENTS;


INSERT INTO ^trm.A_PROFILE_OWNER (
	ID, 
	NAME,
	TYPE,
	PARENT_OWNER,
	TIME
) SELECT
	E2P.PROFILE_ID,
	ORG.Name,
	0,
	^nNewPB,
	SYSDATE
FROM 	^trm.A_ENTITY_2_PROFILE E2P,
	^trm.A_ORGANIZATION ORG
WHERE	E2P.PROFILE_TYPE=^nClientProfile
  AND 	E2P.ENTITY_TYPE=1000
  AND 	E2P.ENTITY=TO_CHAR(ORG.ID)
  AND 	ORG.TYPE=2    -- CLIENTS 
  AND 	ORG.ID>^incID -- MIGRATED ORGS ;


-- Create the client account as solution billing sone
INSERT INTO ^trm.A_PROFILE_OWNER (
	ID, 
	NAME,
	TYPE,
	PARENT_OWNER,
	TIME
) SELECT
	^trm.A_PROFILE_OWNER_SEQ.NEXTVAL,
	'BillingAccount/'||O2A.Account_ID,
	0,
	^nSolBilling,
	SYSDATE
FROM 	^trm.A_ORGANIZATION ORG,
	^trm.A_ORG_2_ACCOUNT O2A 
WHERE	ORG.TYPE=2    -- CLIENTS 
  AND 	ORG.ID>^incID -- MIGRATED ORGS 
  AND	ORG.ID=O2A.ORG_ID
  AND	O2A.ROLE=^OWNER;
  
  
---------------------------
-----  FUND PROFILE  ------
---------------------------
DEFINE nProfile=2000000
INSERT INTO ^trm.A_ENTITY_2_PROFILE (
	ENTITY,	
	ENTITY_TYPE,
	PROFILE_ID,
	PROFILE_TYPE
) SELECT 
	ORG.ID, 
	1000, 
	^trm.A_PROFILE_OWNER_SEQ.NEXTVAL,
	^nProfile
FROM 	^trm.A_ORGANIZATION ORG
WHERE	ORG.ID>^incID -- MIGRATED ORGS ONLY
  AND 	ORG.TYPE=9    -- Funds;


-- Create fund account as child of the parent client account 
INSERT INTO ^trm.A_PROFILE_OWNER (
	ID, 
	NAME,
	TYPE,
	PARENT_OWNER,
	TIME
) SELECT
	^trm.A_PROFILE_OWNER_SEQ.NEXTVAL,
	'BillingAccount/'||Funds.ID name,
	0,
	PO.ID,
	SYSDATE
FROM 	^trm.A_ORGANIZATION Funds,
	^trm.A_ORG_2_ORG O2O,
	^trm.A_ORGANIZATION Clients,
	^trm.A_ORG_2_ACCOUNT O2A,
	^trm.A_PROFILE_OWNER PO
WHERE	fUNDS.id>^incID
  AND	Funds.type=9 --Fund
  AND 	Funds.ID=O2O.to_org_id 
  AND 	O2O.role=^OWNER
  AND 	O2O.from_org_id=Clients.id
  AND 	Clients.type=2 --Clients
  AND 	Clients.ID=O2A.org_id 
  AND 	O2A.role=^OWNER
  AND 	('BillingAccount/'||O2A.Account_ID)=PO.Name
  AND 	PO.Parent_Owner=^nSolBilling;
	

--------------------------
-----  EB PROFILE --------
--------------------------
DEFINE nProfile=2000000
INSERT INTO ^trm.A_ENTITY_2_PROFILE (
	ENTITY,	
	ENTITY_TYPE,
	PROFILE_ID,
	PROFILE_TYPE
) SELECT 
	ORG.ID, 
	1000, 
	^trm.A_PROFILE_OWNER_SEQ.NEXTVAL,
	^nProfile
FROM 	^trm.A_ORGANIZATION ORG
WHERE	ORG.ID>^incID -- MIGRATED ORGS ONLY
  AND 	ORG.TYPE=3    -- EB;


INSERT INTO ^trm.A_PROFILE_OWNER (
	ID, 
	NAME,
	TYPE,
	PARENT_OWNER,
	TIME
) SELECT
	E2P.PROFILE_ID,
	ORG.Name,
	0,
	^nNewPB,
	SYSDATE
FROM 	^trm.A_ENTITY_2_PROFILE E2P,
	^trm.A_ORGANIZATION ORG
WHERE	E2P.PROFILE_TYPE=^nProfile
  AND 	E2P.ENTITY_TYPE=1000
  AND 	E2P.ENTITY=TO_CHAR(ORG.ID)
  AND 	ORG.TYPE=3    -- EBs 
  AND 	ORG.ID>^incID -- MIGRATED ORGS ;
	


INSERT INTO ^trm.A_PROFILE_PROPERTY (
	ID,
	PROFILE_OWNER_ID,
	KEY,
	SEQUENCE,
	VALUE,
	TIME
) SELECT 
	^trm.A_PROFILE_PROPERTY_SEQ.NEXTVAL,
	E2P.PROFILE_ID, 
	'Date Convention',
	1,
	2,
	SYSDATE
FROM 	^trm.A_ENTITY_2_PROFILE E2P,
	^trm.A_ORGANIZATION ORG
WHERE	E2P.PROFILE_TYPE=^nClientProfile
  AND 	E2P.ENTITY_TYPE=1000
  AND 	E2P.ENTITY=TO_CHAR(ORG.ID)
  AND 	ORG.TYPE=3    -- EBs 
  AND 	ORG.ID>^incID -- MIGRATED ORGS ;

--------------------------
-----  PB PROFILE --------
--------------------------
DEFINE nProfile=2000000
INSERT INTO ^trm.A_ENTITY_2_PROFILE (
	ENTITY,	
	ENTITY_TYPE,
	PROFILE_ID,
	PROFILE_TYPE
) SELECT 
	ORG.ID, 
	1000, 
	^trm.A_PROFILE_OWNER_SEQ.NEXTVAL,
	^nProfile
FROM 	^trm.A_ORGANIZATION ORG
WHERE	ORG.ID>^incID -- MIGRATED ORGS ONLY
  AND 	ORG.TYPE=4    -- PBs;


INSERT INTO ^trm.A_PROFILE_OWNER (
	ID, 
	NAME,
	TYPE,
	PARENT_OWNER,
	TIME
) SELECT
	E2P.PROFILE_ID,
	ORG.Name,
	0,
	^nNewPB,
	SYSDATE
FROM 	^trm.A_ENTITY_2_PROFILE E2P,
	^trm.A_ORGANIZATION ORG
WHERE	E2P.PROFILE_TYPE=^nProfile
  AND 	E2P.ENTITY_TYPE=1000
  AND 	E2P.ENTITY=TO_CHAR(ORG.ID)
  AND 	ORG.TYPE=4    -- PBs 
  AND 	ORG.ID>^incID -- MIGRATED ORGS ;
	


INSERT INTO ^trm.A_PROFILE_PROPERTY (
	ID,
	PROFILE_OWNER_ID,
	KEY,
	SEQUENCE,
	VALUE,
	TIME
) SELECT 
	^trm.A_PROFILE_PROPERTY_SEQ.NEXTVAL,
	E2P.PROFILE_ID, 
	'Date Convention',
	1,
	2,
	SYSDATE
FROM 	^trm.A_ENTITY_2_PROFILE E2P,
	^trm.A_ORGANIZATION ORG
WHERE	E2P.PROFILE_TYPE=^nClientProfile
  AND 	E2P.ENTITY_TYPE=1000
  AND 	E2P.ENTITY=TO_CHAR(ORG.ID)
  AND 	ORG.TYPE=4    -- PBs 
  AND 	ORG.ID>^incID -- MIGRATED ORGS ;


------------------------
-----  PARTNERS --------
------------------------
INSERT INTO ^trm.A_PARTNER(
	ID, 
	DESCRIPTION, 
	DOMAIN_ID, 
	BASIC_STATUS, 
	BASIC_STATUS_REASON
) SELECT
	(PTNR.ID+^incID),
	PTNR.NAME,
	CASE -- Map old PB  to new PB
		WHEN PTNR.DOMAIN_ID=^nOldPB 	THEN ^nNewPB
		ELSE (PTNR.DOMAIN_ID+^incID)
	END,
	CASE 
		WHEN PTNR.STATUS=1	THEN ^nEnabled
		WHEN PTNR.STATUS=0	THEN ^nDisabled
		ELSE ^nDeleted
	END,
	'^mReason'
FROM 	^oldTRM.ARCH_PARTNER PTNR,
	^oldTRM.A_ORGANIZATION ORG
WHERE 	PTNR.ID=ORG.ID
  AND 	PTNR.ID>=^nLowerOrgID;


-- Update connectvity
UPDATE ^trm.M_ORGANIZATION_EXT SET
	CONNECTIVITY_ENABLE=1 
WHERE ID in (SELECT ID FROM ^trm.A_PARTNER);

UPDATE ^trm.A_ORGANIZATION Org SET
	NAMER_ID=(SELECT ID FROM ^trm.A_PARTNER p where P.id=org.id) 
WHERE ID in (SELECT ID FROM ^trm.A_PARTNER );

-----------------------
-----  PERSONS --------
-----------------------
-- 2.2.3.1 Person Definition (A)
INSERT INTO ^trm.A_PERSON (
	ID, 
	title, 
	first_name, 
	last_name, 
	user_name, 
	basic_status,
	type,
	owner_domain_id,
	basic_status_reason )
SELECT 
	(p.ID+^incID), 
	p.title, 
	p.first_name, 
	p.last_name, 
	nvl(p.user_name,'U'||to_char(p.id+^incID)), --if no username use Uxxxx where xxxx is new person ID
	CASE 
		WHEN sdl.STATUS_VALUE=1	THEN ^nEnabled
		WHEN sdl.STATUS_VALUE=0	THEN ^nDisabled
		ELSE ^nDeleted
	END,
	0,
	^nNewPB,
	'^mReason'
FROM	^oldTRM.A_PERSON p,
	^oldTRM.A_STATE_DETAIL sdl
WHERE 	p.type=^nTypePerson
  AND 	p.state_id=sdl.state_id;


--***** advance sequence  *********
BEGIN
	select max(id) into :MaxID from ^trm.A_PERSON;
	^trm.SetSeqVal('A_PERSON_SEQ',:MaxID );
END;
/

-- 2.2.3.1 Person Definition 
INSERT INTO ^trm.M_PERSON_EXT (
	ID, 
	LAST_ADMIN_PWD_CHANGED, 
	phone_number,
	PREFERRED_CONTACT_METHOD, 
	REGION )
SELECT 
	(p.ID+^incID), 
	NULL, 
	prop.value phone, 
	1, 
	2000000
FROM	^oldTRM.A_PERSON p,
	^oldTRM.arch_object_props prop
WHERE	p.type=^nTypePerson
  AND	p.id = prop.object_id(+) 
  AND	prop.object_type(+)=3000
  AND	prop.code_id(+)=^nPropPhone;



-- Person <--> Organization relations
INSERT INTO ^trm.A_ORG_2_PERSON (
	ID, 
	ORG_ID,
	PERSON_ID,
	ROLE )
SELECT
	^trm.A_ORG_2_PERSON_SEQ.nextval,
	CASE
		WHEN o2o.FROM_OBJECT_ID=^nOldPB THEN ^nNewPB
		ELSE (o2o.FROM_OBJECT_ID+^incID)
	END,
	(o2o.TO_OBJECT_ID+^incID), 
	^OWNER
FROM 	^oldTRM.A_OBJECT_2_OBJECT o2o, 
	^oldTRM.A_PERSON P
WHERE	p.type=^nTypePerson
  AND 	o2o.FROM_OBJECT_TYPE=1000 and o2o.TO_OBJECT_TYPE=3000
  AND 	O2O.TO_OBJECT_ID=P.ID;



-- Add persons roles (2M25, 2M26, 2M27)
DEFINE SecRole=2000025
INSERT INTO ^trm.A_PERSON_ROLE (
	ID, 
	PERSON_ID, 
	ROLE, 
	DESCRIPTION 
) SELECT 
	^trm.A_PERSON_ROLE_SEQ.nextval, 
	P.ID, 
	^SecRole, 
	'^mReason'
FROM	^trm.A_PERSON P
WHERE	P.ID >= ^incID  -- Migrated persons only;
	

DEFINE SecRole=2000026
INSERT INTO ^trm.A_PERSON_ROLE (
	ID, 
	PERSON_ID, 
	ROLE, 
	DESCRIPTION 
) SELECT 
	^trm.A_PERSON_ROLE_SEQ.nextval, 
	P.ID, 
	^SecRole, 
	'^mReason'
FROM	^trm.A_PERSON P
WHERE	P.ID >= ^incID  -- Migrated persons only;


DEFINE SecRole=2000027
INSERT INTO ^trm.A_PERSON_ROLE (
	ID, 
	PERSON_ID, 
	ROLE, 
	DESCRIPTION 
) SELECT 
	^trm.A_PERSON_ROLE_SEQ.nextval, 
	P.ID, 
	^SecRole, 
	'^mReason'
FROM	^trm.A_PERSON P
WHERE	P.ID >= ^incID  -- Migrated persons only;


-- SECURITY DEFINITIONS
-----------------------
INSERT INTO ^trm.A_SECURITY_PRINCIPAL (
	   ID, 
	   TYPE 
) SELECT 	
	P.ID, 
	0
FROM	^trm.A_PERSON P
WHERE	P.ID >= ^incID  -- Migrated persons only;


INSERT INTO ^trm.A_SECURITY_PRINCIPAL_GROUP (
	ID, 
	PRINCIPAL_ID, 
	GROUP_ID 
) SELECT 
	P.ID, 
	P.ID, 
	2000002
FROM	^trm.A_PERSON P
WHERE	P.ID >= ^incID  -- Migrated persons only;


INSERT INTO ^trm.A_SECURITY_PRINCIPAL_ROLE (
	ID, 
	PRINCIPAL_ID, 
	ROLE_ID )
SELECT 
	P.ID, 
	P.ID, 
	2000007
FROM	^trm.A_PERSON P
WHERE	P.ID >= ^incID  -- Migrated persons only  ;



INSERT INTO ^trm.A_SECURITY_USER (
	ID, 
	PERSON_ID, 
	USER_NAME, 
	LAST_PWD_CHANGE, 
	FORCE_CHANGE_PWD, 
	ACCOUNT_DISABLED, 
	IS_LOCKED, 
	PASSWORD 
) SELECT 
	(p.ID+^incID),
	(p.ID+^incID),
	nvl(p.user_name,('U'||to_char(p.ID+^incID))),
	SYSDATE,
	1, -- force pwd change
	usr.account_disabled,
	0,
	'0fffffff5ffffffa5ffffff9affffffdcffffffa2ffffffe20ffffffaf64ffffffd34fffffff9effffffa9ffffffe42f3540fffffff0ffffff933f'
FROM	^oldTRM.arch_user usr, 
	^oldTRM.a_person p
WHERE	p.type=^nTypePerson
  AND	p.user_name=usr.user_name(+);



INSERT INTO ^trm.A_SECURITY_USER_PWD_HISTORY (
	ID, 
	USER_ID, 
	PASSWORD, 
	CHANGE_TIME
) SELECT 
	^trm.A_SECURITY_USER_PWD_HSTRY_SEQ.nextval,
	SU.ID,
	SU.PASSWORD, 
	sysdate
FROM 	^trm.A_SECURITY_USER SU
WHERE 	ID>^incID;
	



-- Persons DataMapping 
-- 1. All users should have a data_mapping with username as external value and namer=^nNewPB.
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
	^nNewPB, 
	4,
	P.USER_NAME,
	P.ID,
	P.basic_status,
	0,
	0,
	'^mReason' 
FROM 	^trm.A_PERSON P
WHERE	p.id>^incID /*Migrated persons only*/;



-- 2. Migrate other data mapping info on persons 
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
	CASE
		WHEN DM.Namer_ID=^nOldPB 	THEN ^nNewPB
		WHEN DM.Namer_ID=^nTraianaNamer THEN ^nTraianaNamer
		WHEN DM.Namer_ID>=^nLowerOrgID	THEN (DM.Namer_ID+^incID)
		WHEN DM.Namer_ID=0		THEN ^nNewPB
		ELSE NULL
	END Namer_ID, 
	4 Map_Type,
	CASE 
		WHEN DM.STATUS in (0,1) THEN DM.external_value
		ELSE 'DELETED_'||DM.external_value||'_'||DM.STATUS
	END EXTERNAL_VALUE,
	CASE -- Map old PB accounts to new PB
		WHEN DM.internal_value=^nOldPB 	THEN ^nNewPB
		ELSE (DM.internal_value+^incID)
	END Internal_value,
	CASE 
		WHEN DM.STATUS=0 THEN ^nDisabled
		WHEN DM.STATUS=1 THEN ^nEnabled
		ELSE ^nDeleted
	END Basic_status,
	^nType_in,
	^nType_out+1, 
	'^mReason' 
FROM 	^oldTRM.ARCH_DATA_MAPPING DM, 
	^oldTRM.A_PERSON P
WHERE	DM.Map_Type=^MapPSN
  AND 	DM.internal_value=P.id
  AND 	P.type=1 /*person*/
  AND 	DM.type<>0        	-- type=0 and namer=PO replaced by previous SQL
  AND 	(DM.namer_id<^nOldPB or DM.namer_id>^nLowerOrgID)
;


-- Migrate existing emails for persons
INSERT INTO ^trm.A_PERSON_2_ADDRESS (
	ID, 
	PERSON_ID, 
	ADDRESS_ID, 
	ROLE	
) SELECT
	^trm.A_PERSON_2_ADDRESS_SEQ.nextval,
	(B.FROM_object_id+^incID),
	(B.TO_object_id+^incID),
	^OWNER
FROM 
	^oldTRM.ARCH_ADDRESS A,
	^oldTRM.A_OBJECT_2_OBJECT B,
	^oldTRM.A_PERSON P,
	^oldTRM.ARCH_CON_MAIL M
WHERE 	p.type=^nTypePerson
  AND 	P.ID = B.FROM_OBJECT_ID 
  AND 	B.FROM_OBJECT_TYPE = 3000 -- Person
  AND 	B.TO_OBJECT_TYPE = 10000  -- Address
  AND 	B.TO_OBJECT_ID = A.ID 
  AND 	A.TRANSPORT_TYPE=7 -- MAIL OUT trm2.5 C.G 41
  AND	A.ID = M.ADDRESS_ID;
  
  

INSERT INTO ^trm.A_ADDRESS (
	ID, 
	NAME, 
	SYSTEM_MODE, -- Code group 8
	PROTOCOL_ID, -- Code group 42
	IS_DYNAMIC, 
	BASIC_STATUS, 
	BASIC_STATUS_REASON
)SELECT 
	(tmp.id+^incID),
	tmp.name,
	2,
	8,
	0,
	CASE 
		WHEN TMP.STATUS=0 THEN ^nDisabled
		WHEN TMP.STATUS=1 THEN ^nEnabled
		ELSE ^nDeleted
	END,
	'^mReason'
FROM 	
	(SELECT
		a.id,
		p.user_name||' '||A.NAME Name,	
		a.status Status
	FROM 
		^oldTRM.ARCH_ADDRESS A,
		^oldTRM.A_OBJECT_2_OBJECT B,
		^oldTRM.A_PERSON P,
		^oldTRM.ARCH_CON_MAIL M
	WHERE 	p.type=^nTypePerson
	  AND 	P.ID = B.FROM_OBJECT_ID 
	  AND 	B.FROM_OBJECT_TYPE = 3000 
	  AND 	B.TO_OBJECT_TYPE = 10000 
	  AND 	B.TO_OBJECT_ID = A.ID 
	  AND 	A.TRANSPORT_TYPE=7 -- MAIL OUT trm2.5 C.G 41
	  AND	A.ID=M.ADDRESS_ID ) TMP;

--***** advance sequence  *********
BEGIN
	select max(id) into :MaxID from ^trm.A_ADDRESS;
	^trm.SetSeqVal('A_ADDRESS_SEQ',:MaxID );
END;
/

INSERT INTO ^trm.A_CON_MAIL_OUT (
	ADDRESS_ID, 
	MAIL_RECIPIENTS, 
	SUBJECT, 
	MAIL_FROM, 
	ATTACHMENT 
) SELECT 
	(TMP.ID+^incID), 
	TMP.MAIL_RECIPIENTS, 
	TMP.SUBJECT, 
	TMP.MAIL_FROM, 
	TMP.ATTACHMENT
FROM 	
	(SELECT
		m.address_id ID,
		m.MAIL_RECIPIENTS, 
		m.SUBJECT, 
		m.MAIL_FROM, 
		m.ATTACHMENT
	FROM 
		^oldTRM.ARCH_ADDRESS A,
		^oldTRM.A_OBJECT_2_OBJECT B,
		^oldTRM.A_PERSON P,
		^oldTRM.ARCH_CON_MAIL M
	WHERE 	p.type=^nTypePerson
	  AND 	P.ID = B.FROM_OBJECT_ID 
	  AND 	B.FROM_OBJECT_TYPE = 3000 
	  AND 	B.TO_OBJECT_TYPE = 10000 
	  AND 	B.TO_OBJECT_ID = A.ID 
	  AND	A.ID=M.ADDRESS_ID ) TMP;	



-- Create DUMMY EMAIL address for persons 
-- (TRM2.5 email is optional, trm4 email is mandatory
------------------------------------------
CREATE TABLE  ^trm.TMP_PERSON_EMAIL 
AS SELECT
	P.ID PERSON_ID,
	^trm.A_ADDRESS_SEQ.nextval Address_ID,
	P.ID||'^mMailDummy' email
FROM 
	^trm.A_PERSON P
WHERE 	P.ID not in (	SELECT 	PERSON_ID 
			FROM  	^trm.A_PERSON_2_ADDRESS 
			WHERE 	ROLE=^OWNER
		    );

  
INSERT INTO ^trm.A_PERSON_2_ADDRESS (
	ID, 
	PERSON_ID, 
	ADDRESS_ID, 
	ROLE	
) SELECT
	^trm.A_PERSON_2_ADDRESS_SEQ.nextval,
	tmp.PERSON_ID, 
	tmp.ADDRESS_ID,
	^OWNER
FROM 	^trm.TMP_PERSON_EMAIL tmp;



INSERT INTO ^trm.A_ADDRESS (
	ID, 
	NAME, 
	SYSTEM_MODE, -- Code group 8
	PROTOCOL_ID, -- Code group 42
	IS_DYNAMIC, 
	BASIC_STATUS, 
	BASIC_STATUS_REASON
)SELECT 
	tmp.ADDRESS_ID,
	tmp.person_id||' ^mDummy',
	2,
	8,
	0,
	^nDisabled,
	'^mReason'
FROM 	^trm.TMP_PERSON_EMAIL tmp ;


INSERT INTO ^trm.A_CON_MAIL_OUT (
	ADDRESS_ID, 
	MAIL_RECIPIENTS, 
	SUBJECT, 
	MAIL_FROM
) SELECT 
	TMP.ADDRESS_ID, 
	TMP.EMAIL, 
	'^mDummy', 
	'dummy'||'^mMailDummy'
FROM 	^trm.TMP_PERSON_EMAIL tmp ;	
	  
	  
drop table ^trm.TMP_PERSON_EMAIL;


------------------------------
-----  USERS PROFILE  --------
------------------------------
DEFINE 	nGeneralProfile=2000000
INSERT INTO ^trm.A_ENTITY_2_PROFILE (
	ENTITY,	
	ENTITY_TYPE,
	PROFILE_ID,
	PROFILE_TYPE
) SELECT 
	P.User_Name, 
	3000, 
	^trm.A_PROFILE_OWNER_SEQ.NEXTVAL,
	^nGeneralProfile
FROM 	^trm.A_PERSON P
WHERE	P.ID>^incID -- MIGRATED USERS ONLY;


INSERT INTO ^trm.A_PROFILE_OWNER (
	ID, 
	NAME,
	TYPE,
	PARENT_OWNER,
	TIME
) SELECT
	E2P.PROFILE_ID,
	P.USER_NAME,
	0,
	^nNewPB,
	SYSDATE
FROM 	^trm.A_ENTITY_2_PROFILE E2P,
	^trm.A_PERSON P
WHERE	E2P.PROFILE_TYPE=^nGeneralProfile
  AND 	E2P.ENTITY_TYPE=3000
  AND 	E2P.ENTITY=P.USER_NAME
  AND 	P.ID>^incID -- MIGRATED users ;
	


INSERT INTO ^trm.A_PROFILE_PROPERTY (
	ID,
	PROFILE_OWNER_ID,
	KEY,
	SEQUENCE,
	VALUE,
	TIME
) SELECT 
	^trm.A_PROFILE_PROPERTY_SEQ.NEXTVAL,
	E2P.PROFILE_ID, 
	'Date Convention',
	1,
	2,
	SYSDATE
FROM 	^trm.A_ENTITY_2_PROFILE E2P,
	^trm.A_PERSON P
WHERE	E2P.PROFILE_TYPE=^nGeneralProfile
  AND 	E2P.ENTITY_TYPE=3000
  AND 	E2P.ENTITY=P.USER_NAME
  AND 	P.ID>^incID -- MIGRATED ORGS ;



-----------------------
-----  TRADERS --------
-----------------------

INSERT INTO ^trm.M_TRADER (
	ID, 
	PARENT_ORG, 
	NAME, 
	EMAIL, 
	PHONE, 
	BASIC_STATUS, 
	BASIC_STATUS_REASON
) SELECT 
	(TMP.ID+^incID),
	CASE -- Map old PB accounts to new PB
		WHEN PARENT_ID=^nOldPB 	THEN ^nNewPB
		ELSE (PARENT_ID+^incID)
	END,
	TMP.NAME,
	TMP.EMAIL,
	TMP.PHONE,
	TMP.STATUS,
	'^mReason'
FROM 	
	(SELECT
		p.id,
		p2o.from_object_id parent_id,
		p.first_name||' '||p.last_name name,
		mail.email,
		phone.phone_number PHONE,
		CASE
			WHEN sdl.STATUS_VALUE=1	THEN 1
			WHEN sdl.STATUS_VALUE=0	THEN 0
			ELSE 2
		END STATUS
	FROM
		^oldTRM.A_PERSON P,
		^oldTRM.A_STATE_DETAIL sdl,
		^oldTRM.A_OBJECT_2_OBJECT P2O,
		(
			SELECT 	P2A.FROM_OBJECT_ID P_ID, 
				M.MAIL_RECIPIENTS EMAIL	   
			FROM 	^oldTRM.ARCH_CON_MAIL M,
				^oldTRM.ARCH_ADDRESS ADR,
				^oldTRM.A_OBJECT_2_OBJECT P2A
			WHERE 	P2A.FROM_OBJECT_TYPE = 3000 AND P2A.TO_OBJECT_TYPE = 10000 --ADDRESS TO 
			  AND 	P2A.TO_OBJECT_ID = ADR.ID
			  AND	ADR.ID=M.ADDRESS_ID
		) Mail, 
		(
			SELECT 	prop.object_id p_id, 
				prop.value phone_number
			FROM 	^oldTRM.arch_object_props prop
			WHERE 	prop.object_type=3000
			  AND	prop.code_id=1100012
		) Phone
	WHERE 	p.type=2
	  AND 	P.ID=P2O.TO_OBJECT_ID
	  AND 	P2O.FROM_OBJECT_TYPE=1000  AND 	P2O.TO_OBJECT_TYPE=3000 -- ORG TO PERSON
	  AND 	P.ID = MAIL.p_id(+)
	  AND 	p.state_id=sdl.state_id
	  AND	P.ID = PHONE.p_id(+)
	) TMP;	

	
--***** advance sequence  *********
BEGIN
	select max(id) into :MaxID from ^trm.M_TRADER;
	^trm.SetSeqVal('M_TRADER_SEQ',:MaxID );
END;
/

-- Traders DataMapping 
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
	CASE
		WHEN DM.Namer_ID=^nOldPB 	THEN ^nNewPB
		WHEN DM.Namer_ID=^nTraianaNamer THEN ^nTraianaNamer
		WHEN DM.Namer_ID>^nOldPB	THEN (DM.Namer_ID+^incID)
		WHEN DM.Namer_ID=0		THEN ^nNewPB
		ELSE NULL
	END , 
	2000001,
	CASE 
		WHEN DM.STATUS in (0,1) THEN DM.external_value
		ELSE 'DELETED_'||DM.external_value||'_'||DM.STATUS
	END EXTERNAL_VALUE,
	CASE -- Map old PB accounts to new PB
		WHEN p.id=^nOldPB 	THEN ^nNewPB
		ELSE (p.id+^incID)
	END,
	CASE 
		WHEN DM.STATUS=0 THEN ^nDisabled
		WHEN DM.STATUS=1 THEN ^nEnabled
		ELSE ^nDeleted
	END,
	^nType_in,
	^nType_out,
	'^mReason' 
FROM 	^oldTRM.A_PERSON P,
	^oldTRM.ARCH_DATA_MAPPING DM
WHERE	p.type=^nTypeTrader
  AND 	p.id=dm.internal_value
  AND	DM.Map_Type=^MapPSN;



-----------------------
-----  PORTFOLIO ------
-----------------------
INSERT INTO ^trm.M_PORTFOLIO (
	ID, 
	PARENT_ORG, 
	NAME, 
	DESCRIPTION, 
	BASIC_STATUS, 
	BASIC_STATUS_REASON
) SELECT 
	(PFL.ID+^incID), 
	CASE -- Map old PB accounts to new PB
		WHEN PFL.ORGANIZATION_ID=^nOldPB 	THEN ^nNewPB
		ELSE (PFL.ORGANIZATION_ID+^incID)
	END,
	dm.external_value,
	DESCRIPTION,
	CASE 
		WHEN PFL.STATUS=0 THEN ^nDisabled
		WHEN PFL.STATUS=1 THEN ^nEnabled
		ELSE ^nDeleted
	END,
	'^mReason'
FROM 	^oldTRM.ARCH_DATA_MAPPING DM,
	^oldTRM.FXPB_PORTFOLIO PFL
WHERE	DM.Map_Type=^MapPFL
  AND 	DM.internal_value=PFL.ID
  AND	dm.namer_id=^nOldPB
;



--***** advance sequence  *********
BEGIN
	select max(id) into :MaxID from ^trm.M_PORTFOLIO;
	^trm.SetSeqVal('M_PORTFOLIO_SEQ',:MaxID );
END;
/

-- Portfolio DataMapping 
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
	CASE
		WHEN DM.Namer_ID=^nOldPB 	THEN ^nNewPB
		WHEN DM.Namer_ID=^nTraianaNamer THEN ^nTraianaNamer
		WHEN DM.Namer_ID>^nOldPB	THEN (DM.Namer_ID+^incID)
		WHEN DM.Namer_ID=0		THEN ^nNewPB
		ELSE NULL
	END , 
	2000000,
	CASE 
		WHEN DM.STATUS in (0,1) THEN DM.external_value
		ELSE 'DELETED_'||DM.external_value||'_'||DM.STATUS
	END EXTERNAL_VALUE,
	(PFL.id+^incID),
	CASE 
		WHEN DM.STATUS=0 THEN ^nDisabled
		WHEN DM.STATUS=1 THEN ^nEnabled
		ELSE ^nDeleted
	END,
	^nType_in,
	^nType_out,
	'^mReason' 
FROM 	^oldTRM.ARCH_DATA_MAPPING DM,
	^oldTRM.FXPB_PORTFOLIO PFL
WHERE	DM.Map_Type=^MapPFL
  AND 	DM.internal_value=PFL.ID;

/*-----------------*/
/* --- CR 12650 ---*/
/*-----------------*/
-- Clear all PO <--> Clients relations
DELETE ^trm.A_ORG_2_PERSON 
WHERE role=2000011 
  AND person_id IN ( -- PO persons
			SELECT person_id
			FROM ^trm.a_org_2_person
			WHERE org_id=^nNewPB
		   ) 
;

-- Create cartezian PO Users * clients relations
INSERT INTO ^trm.A_ORG_2_PERSON (
	ID, 
	PERSON_ID, 
	ORG_ID, 
	ROLE
) SELECT 
	^trm.A_ORG_2_PERSON_SEQ.nextval, 
	O2P.Person_ID, 
	ORG.ID, 
	2000011
FROM 	^trm.A_ORG_2_PERSON O2P,
	^trm.A_ORGANIZATION ORG
WHERE 	O2P.org_id=^nNewPB -- PO 
  AND	O2P.role=^OWNER
  AND 	ORG.type in (2,5) -- Clients,ECNs
;
/*-----------------*/
/*-----------------*/

commit;
exec ^trm.alter_constraints('enable');


/*------------------------*/
/* --- CR 12908, 12621 ---*/
/*------------------------*/
DECLARE 
	sqlText varchar2(150);
BEGIN
	FOR j IN (	SELECT 	cols.table_name, 
				cols.column_name 
			FROM 	DBA_tab_columns cols, 
				DBA_tables tables
			WHERE 	cols.data_type='NUMBER' 
			  AND 	data_precision=1 
			  AND 	cols.table_name=tables.table_name
			  AND 	cols.owner||'.'=UPPER('^trm')
			  AND 	tables.owner||'.'=UPPER('^trm') 
		)
	LOOP
		sqlText := 'UPDATE ^trm.' || j.table_name || ' SET ' ||   j.column_name || '= NVL(' || j.column_name || ',0)';
		execute immediate sqlText;
		commit;
	END LOOP ;
END;
/

/*-----------------*/
/*-----------------*/


spool off
exit;
