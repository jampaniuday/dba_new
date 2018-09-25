@ECHO OFF
@echo set echo on		 >tmp.sql
@echo SET FEEDBACK ON		>>tmp.sql
@echo SET VERIFY ON		>>tmp.sql
type %2				>>tmp.sql
ECHO EXIT;			>>tmp.sql
ECHO --END-- 			>>tmp.sql
@ECHO                  EXECUTING SCRIPT %2
sqlplus %1 @tmp.sql  > %3

del tmp.sql

