set define "^"
set echo on
set heading on
set feedback on
set sqlblank on
set sqlprefix off
set timing on
set time on 
set serveroutput on
spool create_trigger.log
CREATE OR REPLACE TRIGGER ^1..trg_qin_no_clob
    BEFORE INSERT
        ON msg_queue_in
        FOR EACH ROW

BEGIN
    -- Update create_date field to current system date
    :new.msg := NULL;
END;
/	
spool off
exit
	