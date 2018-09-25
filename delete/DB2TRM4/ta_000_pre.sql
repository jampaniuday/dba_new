------------------------------------------
-- Remove duplicate CCYs :
-- 		  808(Gold, dup with 797) 
-- 		 809(Silver, dup with 798)
------------------------------------------
DELETE from ^eswitch.A_INSTRUMENT where ID in (808, 809); 	


---------------------------------------------------
--  Import Preperations 
-- This script should be run ONCE 
---------------------------------------------------

------------------------------------
--  2.2.1.1	Owned Accounts 
------------------------------------
-- Create ID Mapping table fro (Owned accounts only)
CREATE TABLE ^trm.MIG_OWNED_ACC_ID_MAPPING (
	ESWITCH_ID 	NUMBER(30) NOT NULL primary key,
	TRM_ID		NUMBER(30) NOT NULL)
ORGANIZATION INDEX;

------------------------------------
--  6.2.1	NOEs: 
------------------------------------

-- Create ID Mapping table
CREATE TABLE ^trm.MIG_TA_ID_MAPPING_NOE (
	ESWITCH_ID 	NUMBER(30) NOT NULL primary key,
	TRM_ID		NUMBER(30) NOT NULL)
ORGANIZATION INDEX;


------------------------------------
--  6.2.2	Trades 
------------------------------------

-- Create ID Mapping table
CREATE TABLE ^trm.MIG_TA_ID_MAPPING_TRADE (
	ESWITCH_ID 	NUMBER(30) NOT NULL primary key,
	TRM_ID		NUMBER(30) NOT NULL)
ORGANIZATION INDEX;

	
------------------------------------
--  6.2.3	OAs
------------------------------------

-- Create ID Mapping table
CREATE TABLE ^trm.MIG_TA_ID_MAPPING_OA (
	ESWITCH_ID 	NUMBER(30) NOT NULL primary key,
	TRM_ID		NUMBER(30) NOT NULL
	)
ORGANIZATION INDEX;


