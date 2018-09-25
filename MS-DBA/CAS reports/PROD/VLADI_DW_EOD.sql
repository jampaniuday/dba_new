WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR  EXIT SQL.SQLCODE
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET TIMING OFF
SET ECHO OFF
set pagesize 0
set linesize 10000
SET TRIMSPOOL on
SET DEFINE "^"
DEFINE delimiter=,
DEFINE quoteDelimiter='"'
DEFINE dateFormat="yyyymmdd"

spool ^1
SELECT CASE WHEN NOE_LIFE_STATUS = 7 THEN 3 ELSE 1 END
       ||'^delimiter'||'^quoteDelimiter'||to_char(sysdate, 'yyyy-mm-dd')||'-'||to_char(sysdate, 'HH24.MI.SS')||'.000000'||'^quoteDelimiter'
       ||'^delimiter'||TA.ID
       ||'^delimiter'||OLD_ID
       ||'^delimiter'||COUNTER_TA
       ||'^delimiter'||NOE_LIFE_STATUS
       ||'^delimiter'||RECON_STATUS
       ||'^delimiter'||NETTING_STATUS
       ||'^delimiter'||NETTING_GROUP_ID
       ||'^delimiter'||NETTING_SERVICE_REF
       ||'^delimiter'||CASE WHEN LIFE_STATUS_REASON_ID = 25002 THEN 0 ELSE 1 END
       ||'^delimiter'||'^quoteDelimiter'||REQUEST_ID||'^quoteDelimiter'
       ||'^delimiter'||TRADE_TYPE
       ||'^delimiter'||TP_ID
       ||'^delimiter'||'^quoteDelimiter'||CAS_PROD.HELPER_PKG.getOrganizationName(TP_ID)||'^quoteDelimiter'
       ||'^delimiter'||CP_ID
       ||'^delimiter'||'^quoteDelimiter'||CAS_PROD.HELPER_PKG.getOrganizationName(CP_ID)||'^quoteDelimiter'
           ||'^delimiter'||TO_CHAR(TRADE_DATE,'^dateFormat')
       ||'^delimiter'||TO_CHAR(VALUE_DATE,'^dateFormat')
           ||'^delimiter'||CCY_1
       ||'^delimiter'||'^quoteDelimiter'||CAS_PROD.HELPER_PKG.getMappedCCYName(CCY_1)||'^quoteDelimiter'
       ||'^delimiter'||QTY_1
       ||'^delimiter'||CCY_2
       ||'^delimiter'||'^quoteDelimiter'||CAS_PROD.HELPER_PKG.getMappedCCYName(CCY_2)||'^quoteDelimiter'
       ||'^delimiter'||QTY_2
       ||'^delimiter'||trim(to_char(RATE, '9999999990.99999999'))
       ||'^delimiter'||DIRECTION
       ||'^delimiter'||'^quoteDelimiter'||'^quoteDelimiter' --tp
       ||'^delimiter'||'^quoteDelimiter'||'^quoteDelimiter' --cp
       ||'^delimiter'||'^quoteDelimiter'||'^quoteDelimiter' --platform
       ||'^delimiter'||'^quoteDelimiter'||'^quoteDelimiter' -- region
FROM
    CAS_PROD.FD_FXPB_LINEAR_TA TA,
    CAS_PROD.FD_LINEAR_LEG_DATA LEG
WHERE TA.ID = LEG.PARENT_ID 
  AND ((
        TA.creation_date> DECODE(to_number(to_char(sysdate,'d')),2,NEXT_DAY(trunc(SYSDATE), 'THU')-6-2/24,trunc(sysdate-1)-2/24)
        AND TA.creation_date<=TRUNC(SYSDATE)-2/24                        
        AND TA.TRADE_TYPE IN (1,2)
       ) 
       OR 
       (TA.TRADE_TYPE IN (11,10) AND LEG.NETTING_SERVICE_REF IN (
                                                                    select LEG1.NETTING_SERVICE_REF
                                                                    from  CAS_PROD.FD_FXPB_LINEAR_TA TA1,CAS_PROD.FD_LINEAR_LEG_DATA LEG1
                                                                    where TA1.TRADE_TYPE = 1
                                                                    AND TA1.NOE_LIFE_STATUS=4
                                                                    AND TA1.creation_date>TRUNC(SYSDATE-1)-2/24
                                                                    AND TA1.creation_date>  DECODE(to_number(to_char(sysdate,'d')),2,NEXT_DAY(trunc(SYSDATE), 'THU')-6-2/24,trunc(sysdate-1)-2/24)
                                                                    AND TA1.creation_date<=TRUNC(SYSDATE)-2/24
                                                                    AND TA1.ID=LEG1.PARENT_ID
                                                                  )                        
       )
      )
;
spool off
exit
