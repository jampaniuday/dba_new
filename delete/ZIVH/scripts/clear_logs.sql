set serveroutput on
exec alter_constraints('disable');
truncate table A_ALERT;
truncate table A_AUDIT;
truncate table A_BATCH_ANSWERS;
truncate table A_BATCH_DATA;
truncate table A_BUSINESS_PROCESS ;
truncate table A_CONVERSATION ;
INSERT INTO A_BUSINESS_PROCESS ( ID, START_TIME, END_TIME, INITIATOR_ID, INITIATOR_TYPE,
LOGIC_MSG_ID, STATUS ) VALUES ( 
-1,  SYSDATE, NULL, 0, 0, 0, 0); 
INSERT INTO A_CONVERSATION ( ID, BUSINESS_PROCESS_ID, START_TIME, END_TIME, INITIATOR_ID,
INITIATOR_TYPE, STATUS ) VALUES ( 
-1, -1,  TO_Date( '12/31/2003 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL, 0, 0
, 0); 
COMMIT;
truncate table A_GENERIC_NOE_DEALS;
truncate table A_GENERIC_OA_DEALS;
truncate table A_GENERIC_REQUEST_DEALS;
truncate table A_LOG;
truncate table A_SECURITY_AUDIT;
truncate table A_TRACKING_DATA;
truncate table A_TRANSITION_STATE_HISTORY;
truncate table A_UID;
truncate table a_flow_answer;
truncate table a_flow;
exec alter_constraints('enable'); 
