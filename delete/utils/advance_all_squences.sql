set echo on
SPOOL PROD_PRE_IMPORT.txt

DECLARE 
	MaxSeq Number :=5000000;
	SeqVal Number;
BEGIN
	
	-- Advance all sequences
	FOR i IN (SELECT sequence_name FROM user_sequences) LOOP
		EXECUTE IMMEDIATE 'SELECT '||i.Sequence_Name||'.nextval into :SeqVal from dual' into  SeqVal;
		EXECUTE IMMEDIATE 'ALTER SEQUENCE '||i.Sequence_Name||' INCREMENT BY '||(MaxSeq-SeqVal) ;
		EXECUTE IMMEDIATE 'SELECT '||i.Sequence_Name||'.nextval into :SeqVal from dual' into  SeqVal;
		EXECUTE IMMEDIATE 'ALTER SEQUENCE '||i.Sequence_Name||' INCREMENT BY 1';
	END LOOP;

END;
/

SPOOL OFF
exit
