------------------------------------
--  6.2.1	NOEs: 
------------------------------------

-- Create ID Mapping table
CREATE TABLE ^trm.TA_ID_MAPPING_NOE (
	ESWITCH_ID 	NUMBER(30) NOT NULL,
	TRM_ID		NUMBER(30) NOT NULL);


------------------------------------
--  6.2.2	Trades 
------------------------------------

-- Create ID Mapping table
CREATE TABLE ^trm.TA_ID_MAPPING_TRADE (
	ESWITCH_ID 	NUMBER(30) NOT NULL,
	TRM_ID		NUMBER(30) NOT NULL);

	
------------------------------------
--  6.2.3	OAs
------------------------------------

-- Create ID Mapping table
CREATE TABLE ^trm.TA_ID_MAPPING_OA (
	ESWITCH_ID 	NUMBER(30) NOT NULL,
	TRM_ID		NUMBER(30) NOT NULL);


