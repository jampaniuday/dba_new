--WHENEVER SQLERROR EXIT SQL.SQLCODE
--WHENEVER OSERROR  EXIT SQL.SQLCODE

set serveroutput on
set linesize 9999

@D:\dbtools\DB2TRM4\HEADINGS

exec dbms_output.put_line('>>> Start Migration from ' || '^eSwitch' || ' to ' || '^trm');

exec dbms_output.put_line('>>> Disable Constraints');
exec ^trm.alter_constraints('disable');

exec dbms_output.put_line('>>> Preperations');
@D:\dbtools\DB2TRM4\ta_000_pre

exec dbms_output.put_line('>>> Procedures');
@D:\dbtools\DB2TRM4\ta_000_procs

exec dbms_output.put_line('>>> Organization Model');
@D:\dbtools\DB2TRM4\eswitch2trm4

exec dbms_output.put_line('>>> TA: NOE');
@D:\dbtools\DB2TRM4\ta_001_noe

exec dbms_output.put_line('>>> TA: Trade');
@D:\dbtools\DB2TRM4\ta_002_trade

exec dbms_output.put_line('>>> TA: OA');
@D:\dbtools\DB2TRM4\ta_003_oa

exec dbms_output.put_line('>>> Instruments');
@D:\dbtools\DB2TRM4\ta_004_inst

exec dbms_output.put_line('>>> Enable Constraints');
exec ^trm.alter_constraints('enable');

exec dbms_output.put_line('>>> END Migration');
