CREATE OR REPLACE FORCE VIEW Feed_Monitoring (TP,
											  TP_ID,
											  INTERVAL,
											  LAST_RECEIVED_MIN,
											  TOP_WAIT,
											  STATUS)
AS
select TP,
       TP_ID,
       INTERVAL,
       LAST_RECEIVED_MIN,
       TOP_WAIT,
       case
         when ((INTERVAL + 2) * 10 <= TOP_WAIT) then
           '_OK (no feed expected)'
         when (LAST_RECEIVED_MIN > (TOP_WAIT * 2) + 5) then
           'CRITICAL'
         when (LAST_RECEIVED_MIN > (TOP_WAIT * 1.25) + 5) then
           'WARNING'
         else
           '_OK'
       end STATUS
   from (select Decode(NAME, 'Jump 1', 'Jump', NAME)                                        TP,
                TA.TP_ID                                                                    TP_ID,
                Trunc((SYSDATE - Trunc(SYSDATE)) * 144)                                     INTERVAL,
                Round((SYSDATE - Greatest(Max(TA.CREATION_DATE),Trunc(SYSDATE))) * 60 * 24) LAST_RECEIVED_MIN,
                Round(TOP_WAIT / 60)                                                        TOP_WAIT               
         from  (select -- count Jump 1,2,3,4,5 as one TP.
                       Decode(TP_ID,6000201,6000200,
                                    6000202,6000200,
                                    6000203,6000200,
                                    6000204,6000200,
                                    6000205,6000200,
                              TP_ID) TP_ID,
                                     CREATION_DATE 
               from  FXCM_PROD.FD_FXPB_LINEAR_TA) TA,
                     TEMP_MONITORING              MON,
                     FXCM_PROD.A_ORGANIZATION     ORG
               -- Take only TP's that had trades in the last 4 days
               where TA.CREATION_DATE >= Trunc(SYSDATE - 3)
                 and TA.CREATION_DATE <= Trunc(SYSDATE + 1)
                 and MON.TP_ID = TA.TP_ID
                 and ORG.ID    = TA.TP_ID
                 and MON.ORIG_INTER_VAL = Trunc((SYSDATE - Trunc(SYSDATE)) * 144)
               group by TA.TP_ID,
                        NAME,
                        Trunc((SYSDATE - Trunc(SYSDATE)) * 144),
                        Round(TOP_WAIT / 60));
