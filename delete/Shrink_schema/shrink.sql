Create or replace procedure shrink_schema(schema_name in varchar2 ,nExtSize_k in number :=800 ) 
AS
-- The executing user mus have the following grants (not in a  roll)
-- 	SELECT ANY TABLE 
--	ALTER ANY TABLE
-- 	ALTER ANY INDEX
-- To apply use the grant command from a DBA user: 
-- GRANT SELECT ANY TABLE,ALTER ANY TABLE,ALTER ANY INDEX to xxxx;

	nPCTI 	 NUMBER	:= 0;
	SQL1	 VARCHAR2 (512);
	SQL2	 VARCHAR2 (512);
	sColName VARCHAR2 (35);
	sColType VARCHAR2 (15);
	sColDesc VARCHAR2 (30);
BEGIN
-- Shrink tables:
	FOR i IN (
		SELECT 	schema_name ||'.'|| t.TABLE_NAME as TBL,
			t.TABLE_NAME as Table_Name,
			tbs.tablespace_name as TS, 
			DECODE(tbs.EXTENT_MANAGEMENT,'DICTIONARY',
				'STORAGE (INITIAL '||nExtSize_k||' K NEXT '|| nExtSize_k ||' K PCTINCREASE ' ||nPCTI||' MAXEXTENTS UNLIMITED) ' ,
				NULL
			) Strg
		FROM 	DBA_TABLES t, 
			DBA_TABLESPACES tbs
		WHERE 	OWNER=UPPER(schema_name)
		  AND 	t.TABLESPACE_NAME=tbs.TABLESPACE_NAME
		ORDER BY TABLE_NAME
	) LOOP
	BEGIN
		SQL1 := 'ALTER TABLE ' || i.TBL || ' MOVE ' || i.Strg || ' TABLESPACE ' || i.ts;
		--dbms_output.put_line(SQL1);
		EXECUTE IMMEDIATE SQL1 ;
	EXCEPTION
		WHEN OTHERS THEN
			--dbms_output.put_line(' LONG !!!!');

			-- Get the long column (only one at a table).
			SELECT 	c.COLUMN_NAME||' ' ,
				c.DATA_TYPE,
				decode(c.NULLABLE,'N',' NOT NULL ',' NULL ')
			INTO 	sColName,
				sColType,
				sColDesc
			FROM 	DBA_TAB_COLUMNS c
			WHERE 	c.TABLE_NAME=i.Table_Name 
			  AND 	c.OWNER=UPPER(schema_name)
			  AND 	c.DATA_TYPE LIKE 'LONG%';

			-- drop the column
			SQL2 := 'ALTER TABLE ' || i.TBL || ' DROP (' || sColName || ')';
			--dbms_output.put_line(SQL2);
			EXECUTE IMMEDIATE SQL2 ;
			
			--dbms_output.put_line('--> '||SQL1);
			-- move the table
			--dbms_output.put_line(SQL1);
			EXECUTE IMMEDIATE SQL1 ;

			-- return the column
			SQL2 :=  'ALTER TABLE ' || i.TBL || ' ADD(' || sColName || sColType || sColDesc || ')';
			--dbms_output.put_line(SQL2);
			EXECUTE IMMEDIATE SQL2 ;

	END;
	END LOOP /* tables */;

-- Shrink indexes
	FOR i IN (
		SELECT 	schema_name ||'.'|| t.INDEX_NAME as IDX, 
			tbs.tablespace_name as TS, 
			DECODE(tbs.EXTENT_MANAGEMENT,'DICTIONARY',
				'STORAGE (INITIAL '||nExtSize_k||' K NEXT '|| nExtSize_k ||' K PCTINCREASE ' ||nPCTI||' MAXEXTENTS UNLIMITED) ' ,
				NULL
			) Strg
		FROM 	DBA_INDEXES t, 
			DBA_TABLESPACES tbs
		WHERE 	OWNER=UPPER(schema_name)
		  AND 	t.TABLESPACE_NAME=tbs.TABLESPACE_NAME
		ORDER BY TABLE_NAME, INDEX_NAME
	) LOOP
		SQL1 := 'ALTER INDEX ' || i.IDX || ' REBUILD MOVE ' || i.Strg || ' TABLESPACE ' || i.ts;
		--dbms_output.put_line(SQL1);
	END LOOP /* indexes */; 		
END;
/