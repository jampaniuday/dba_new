SET VERIFY OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON 
SET DEFINE "^"
UNDEFINE DEBUG, SDEBUG,EDEBUG
-- DEBUG MODE 
DEFINE DEBUG=" "	
DEFINE sDEBUG=" "
DEFINE eDEBUG=" "
DEFINE CommitLoopMod=100
 
-- uncommet next 6 lines for NO DEBUG mode	
DEFINE DEBUG=---- 	
/* */
DEFINE eDEBUG=*/
/* */
DEFINE sDEBUG=/*  
/* */

-- GENERAL REPLACEMENTS
DEFINE trm=TRM_MIG_TEST.
DEFINE eswitchUser=LINKED
DEFINE eswitch=^eswitchUser..
DEFINE nTodo=-9		--use as numeric place holder for TODO A.I
DEFINE cTodo='TODO'	--use as string place holder for TODO A.I
DEFINE incID=4000000
DEFINE TraianaNamer=100
DEFINE PBnamerID=2000000
DEFINE PBOrgID=2000000
DEFINE PBOrgAccID=2000000

-- DUETSCHE BANK SPECIFIC
DEFINE mReason=	"'eSwitch to TRM4.0 Migration'"
DEFINE domain=700
DEFINE DBpartner=701

-- 2.3.6 Org to Acc Relation Mapping
DEFINE OWNER=20000
DEFINE CoupledOrg=2000005
DEFINE OwnerCoupledAcc=2000004

-- Data Mapping
DEFINE DMType_CCY=2000002
DEFINE E_DMType_CCY=16

-- Instruments
DEFINE InstType_CCY=8
DEFINE E_InstType_CCY=0
DEFINE E_InstType_CCYPair=8
DEFINE FinCenterID_NY=2000000

-- TA Conversion SPECIFIC 
-- Change the following to start conversion from a specific NOE ID
DEFINE noe_id_start=0
-- Change the following to start conversion from a specific Value Date (Format:  mm/dd/yyyy)
DEFINE noe_value_date_start=01/01/2004

-- 12/28/2004
-- 11/28/2008
-- 01/01/2004