SPOOL mig.log
set echo on
set sqlblanklines off
set verify on
set serveroutput on
set define "^"


-- Schemas:
DEFINE trm=SG_TRM4.
DEFINE oldTRM = SG_TRM25.


-- General migration constants values 
DEFINE nError=(-9)
DEFINE nTodo=-9		--use as numeric place holder for TODO A.I
DEFINE cTodo='TODO'	--use as string place holder for TODO A.I
DEFINE incID=4000000
DEFINE mReason="TRM2.5 -->TRM4.0 Migration"
DEFINE mMailDummy="@migration.dummy"
DEFINE mDummy="Migration Dummy for empty emails"


-- Primary ACC/Org mapping
DEFINE nTraianaNamer=100


-----------
-- TRM 4 --
-----------
--	Organizations
DEFINE nNewPB=2000000
DEFINE nNewBackOffice="3000000,3000005" /* Add a coma seperated list of organization IDs coresponding to nBackOffice25 */
-- 	TRM4 Status mapping
DEFINE nDeleted=2
DEFINE nEnabled=1
DEFINE nDisabled=0
--	Org to Acc Relation Mapping
DEFINE OWNER=20000
DEFINE CoupledOrg=2000005
DEFINE OwnerCoupledAcc=2000004
DEFINE CoupledAcc=2000006
-- 	org_2_recon_combinations values
DEFINE ReconComb1=2100000
DEFINE ReconComb2=2100001

DEFINE nSolBilling=1000001
DEFINE nPropPhone=1100012
DEFINE nType_in=0
DEFINE nType_out=DM.type
DEFINE nDefaultTimeout=60

-------------
-- TRM 2.5 --
-------------
-- 	Organizations
DEFINE nOldPB=1000000
DEFINE nOldBackOffice="1001000,1001010" /* Add a coma seperated list of organization IDs coresponding to nBackOffice4 */
DEFINE nLowerOrgID=1000001
DEFINE nLowDeleteID=(^nOldPB+1)
DEFINE nHighDeleteID=(^nOldPB+999999)

-- 	Region 
DEFINE NYkRegion=NYK
DEFINE LDNRegion=LDN
DEFINE TKYRegion=''
DEFINE SDNRegion=''
DEFINE SGPRegion=''
-- 	Persons 
DEFINE nTypePerson=1
DEFINE nTypeTrader=2
-- 	Data Mapping Types C.G. 14
DEFINE MapACC=2
DEFINE MapORG=3
DEFINE MapPSN=4
DEFINE MapFND=5
DEFINE MapPFL=10
-- 	Properties
DEFINE nECN=1100015




exec ^trm.alter_constraints('disable');


