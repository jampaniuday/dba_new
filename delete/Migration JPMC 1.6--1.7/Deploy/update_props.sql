----------------------------------------------------------------------------------------------------------
--													--
-- Date : 01-APR-2004											--
-- Company: Traiana Inc. 										--
-- Author : Isaac Raz 											--
--													--
-- Script Target: 											--
--	Add to all the organizations defined by the client the 						--
--	missing properties from the schema migration of version 1.6 					--
--	to version 1.7											--
--													--
-- Script methodology:											--
--	1. Create a temporary flat table and flat the meta groups table into it. 			--
--	   All properties are defined by the meta groups passing through 				--
--	   Groups to the properties table. Meta groups has a list pg groups with properties.		--
--	2. For readability, create a view that returns a list of all the organizations in the system 	--
--	3. Create a view with all the missing properties. This view is created by finding all the 	--
--	   proprties of the organizations and then removing the existing properties			--
--	4. Inserting the missing properties with the default value defined for each property		--
--	5. Cleanup											--
--													--
----------------------------------------------------------------------------------------------------------


-----------------------------------------------------------
-- STEP 1: Flat the meta groups table
-----------------------------------------------------------
-- Create a flat table from arch_obj_prop_meta_group_def
create table flat_arch_obj_prop_mgd (
	SOLUTION_ID number (30) ,
	OBJECT_TYPE number (30) , 
	META_GROUP  varchar(255), 
	GROUP_ID    number (30)
);


-----------------------------------------------------------
-- create stored procedure
CREATE OR REPLACE PROCEDURE FLAT_META_GROUP AS
	cursor MetaData is select * from arch_obj_prop_meta_group_def where solution_id>999999 ;
	nStartPos number;
	nEndPos number; 
	nVal number;  
	nOccurences  number; 
BEGIN
	-- Clear the table
	delete from flat_arch_obj_prop_mgd;
	commit;
	-- Flat the table arch_obj_prop_meta_group_def
	for MetaGroup in MetaData loop
		-- Assumption : There  are no records with empty groups_ids field																		 
		nOccurences:=  1 ;
		nEndPos    := -1 ;
		While instr(MetaGroup.Group_IDs,',',1,nOccurences)<>0 LOOP
			-- extract all IDs but the last one
			nStartPos := nEndPos+2;                                       --  skip the comma 
			nEndPos   := instr(MetaGroup.Group_IDs,',',1,nOccurences)-1;
			nVal      :=to_number( substr(MetaGroup.Group_IDs,nStartPos,nEndPos-nStartPos+1));
			INSERT INTO flat_arch_obj_prop_mgd 
                                        ( SOLUTION_ID          , OBJECT_TYPE          ,META_GROUP          ,GROUP_ID) 
				  Values( MetaGroup.Solution_id, MetaGroup.Object_Type,MetaGroup.Meta_Group,nVal    );
			COMMIT;
			nOccurences:= nOccurences+1;
		End /* while */loop ;   
		IF nOccurences = 1 THEN                                               -- Single group_id
			nVal  := to_number(MetaGroup.Group_IDs);
		ELSE                                                                  -- Last group_id in the list
			nVal  :=to_number(  substr(MetaGroup.Group_IDs,nEndPos+2,length(MetaGroup.Group_IDs)-nEndPos+3));
		END IF;
		INSERT INTO flat_arch_obj_prop_mgd 
                              ( SOLUTION_ID          , OBJECT_TYPE          ,META_GROUP          ,GROUP_ID) 
			Values( MetaGroup.Solution_id, MetaGroup.Object_Type,MetaGroup.Meta_Group,nVal    );
		COMMIT;
	 end /*cursor*/ loop ; -- for each 
END;
/
-----------------------------------------------------------
-- Activate flat table procedure
begin
	Flat_Meta_Group;
end; 
/


-----------------------------------------------------------
-- STEP 2: Create the organizations view
-----------------------------------------------------------
-- Create view that returns all the organizations
CREATE OR REPLACE VIEW V_UPG_ORGS AS
	SELECT  (A.EXTERNAL_VALUE) PARTICIPANT_NAME,
		(F.ID) ID, 
	        (C1.DATA) PARTICIPANT_ROLE
	FROM ARCH_DATA_MAPPING A,
	     A_OBJECT_ROLE E,
	     A_ORGANIZATION F,
	     ARCH_CODE_MEMBER C1,
	     A_STATE_DETAIL D,
	     ARCH_CODE_MEMBER M 
	WHERE A.MAP_TYPE  = 3         AND 
	      A.TYPE      = 0         AND 
	      A.INTERNAL_VALUE = F.ID AND 
	      E.OBJECT_ID = F.ID      AND 
	      E.OBJECT_TYPE    = 1000 AND 
	      C1.CODE_KEY = TO_CHAR(E.ROLE) AND 
	      C1.GROUP_ID = 1000000   AND 
	      A.NAMER_ID  = 1000000   AND 
	      D.STATE_ID  = F.STATE_ID AND 
	      D.STATUS_TYPE   = 6     AND 
--	      D.STATUS_VALUE <> -1    AND 
	      M.GROUP_ID  = 6         AND 
	      M.CODE_KEY  = D.STATUS_VALUE;


-----------------------------------------------------------
-- STEP 3: Create the missing properties view
-----------------------------------------------------------
-- Create view that returns all the missing properties 
-- for all the organizations
CREATE OR REPLACE FORCE VIEW V2_UPG_MISSING_PROPS
(OBJECT_ID, OBJECT_TYPE, CODE_ID)
AS 
SELECT 
   org.ID Object_ID, 
   1000 Object_Type, 
   props.id Code_ID 
FROM 
	v_UPG_Orgs org             , 
	flat_arch_obj_prop_mgd flat, 
	arch_obj_prop_def     props 
WHERE 
	org.participant_role = flat.meta_group and  /* Join                 */ 
	flat.GROUP_ID        = props.group_id and   /*join                  */ 
	flat.object_type     = 1000 and             /* get orga only        */ 
	props.required       = 1                    /* only must properties */ 
MINUS 
-- Existing properties 
SELECT 
	 OBJECT_ID  , 
	 OBJECT_TYPE, 
	 CODE_ID 
FROM arch_object_props 
WHERE 
	 Object_Type =1000;


		 
-----------------------------------------------------------
-- STEP 4: Insert raws with the missing properties
-----------------------------------------------------------
-- Insert all missing properties with the defualt values 
INSERT INTO arch_object_props (ID, object_id, object_type, code_id, value) 
SELECT 
	ARCH_OBJECT_PROPS_SEQ.nextval, 
	m.OBJECT_ID                  , 
	m.OBJECT_TYPE                , 
	m.Code_ID                    , 
	pd.default_value 
FROM 
	V2_UPG_MISSING_PROPS m, 
	arch_obj_prop_def pd 
WHERE 
    m.CODE_ID=pd.ID;
    
-- CR 6673 - begin fix
update arch_object_props set value='No auto-match'  where code_id=1000004 and value='Confirm';
update arch_object_props set value='Auto-match'  where code_id=1000004 and value='No' ;
-- CR 6673 - end fix

-----------------------------------------------------------
-- STEP 5: Cleanup
-----------------------------------------------------------
Drop view      V2_UPG_MISSING_PROPS  ;
Drop view      V_UPG_ORGS            ;
Drop procedure FLAT_META_GROUP       ;
Drop table     flat_arch_obj_prop_mgd;
