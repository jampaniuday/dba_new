--create table A_INSTRUMENT_FX_SWAP_LEG                                         
create table A_INSTRUMENT_FX_SWAP_LEG(                                          
ID NUMBER(30) NOT NULL                                                          
,CURRENCY_1 NUMBER(30)                                                          
,CURRENCY_2 NUMBER(30)                                                          
,CURRENCY_1_AMOUNT NUMBER(30,8)                                                 
,CURRENCY_2_AMOUNT NUMBER(30,8)                                                 
,CURRENCY_1_DATE DATE                                                           
,CURRENCY_2_DATE DATE                                                           
,CONSTRAINT A_INSTRUMENT_FX_SWAP_LEG_PK PRIMARY KEY (ID)                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_INTEREST_PAYMENTS                                   
create table A_INSTRUMENT_INTEREST_PAYMENTS(                                    
ID NUMBER(30) NOT NULL                                                          
,PRINCIPAL_AMOUNT NUMBER(30,8)                                                  
,START_DATE DATE                                                                
,MATURITY_DATE DATE                                                             
,FIRST_PAYMENT_DATE DATE                                                        
,PAYMENT_STRUCTURE_CALCULATER VARCHAR2(255)                                     
,PAYMENT_DAYCOUNT NUMBER(8)                                                     
,PAYMENT_FREQUENCY NUMBER(8)                                                    
,PAYMENT_LAG NUMBER(30)                                                         
,PAYMENT_LAG_DAYS NUMBER(8)                                                     
,PAYMENT_TIMING NUMBER(8)                                                       
,CURRENCY_ID NUMBER(30)                                                         
,TERM NUMBER(30)                                                                
,ACCURAL_DAYCOUNT NUMBER(8)                                                     
,ACCURAL_DATE_ROLL DATE                                                         
,ACTUAL_NOTIONAL NUMBER(8)                                                      
,FIXED_RATE NUMBER(30,8)                                                        
,FIXED_AMOUNT NUMBER(30,8)                                                      
,CONSTRAINT A_INSTR_INTEREST_PAYMENTS_PK PRIMARY KEY (ID)                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_OPTION                                              
create table A_INSTRUMENT_OPTION(                                               
ID NUMBER(30) NOT NULL                                                          
,TRADE_TYPE NUMBER(8)                                                           
,MATURITY_DATE DATE                                                             
,OPTION_TYPE NUMBER(8)                                                          
,AMERICAN_TYPE_CODE NUMBER(8)                                                   
,CALL_PUT NUMBER(8)                                                             
,INSTRUMENT_1 NUMBER(30)                                                        
,INSTRUMENT_2 NUMBER(30)                                                        
,STRIKE_PRICE NUMBER(30,8)                                                      
,CONSTRAINT A_INSTRUMENT_OPTION_PK PRIMARY KEY (ID)                             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_JMSSTATE                                                       
create table A_JMSSTATE(                                                        
RECORDHANDLE NUMBER                                                             
,RECORDSTATE NUMBER                                                             
,RECORDGENERATION NUMBER                                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_JMSSTORE                                                       
create table A_JMSSTORE(                                                        
RECORDHANDLE NUMBER                                                             
,RECORDSTATE NUMBER                                                             
,RECORD LONG RAW                                                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_LOG                                                            
create table A_LOG(                                                             
ID NUMBER(30) NOT NULL                                                          
,MSG_ID NUMBER(30) NOT NULL                                                     
,REF VARCHAR2(255) NOT NULL                                                     
,SEVERITY NUMBER(10) NOT NULL                                                   
,TIME DATE NOT NULL                                                             
,OBJECT VARCHAR2(4000) NOT NULL                                                 
,EXCEPTION_NAME VARCHAR2(4000)                                                  
,EXCEPTION_MSG VARCHAR2(4000)                                                   
,EXCEPTION_MORE VARCHAR2(4000)                                                  
,IP VARCHAR2(255) NOT NULL                                                      
,SERVER VARCHAR2(255) NOT NULL                                                  
,MSG BLOB                                                                       
,CONSTRAINT A_LOG_PK PRIMARY KEY (ID)                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX LOG_REF_INDEX ON A_LOG                                             
(REF                                                                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_LOG_MESSAGES                                                   
create table A_LOG_MESSAGES(                                                    
MSG_ID NUMBER(30) NOT NULL                                                      
,MESSAGE VARCHAR2(255) NOT NULL                                                 
,LOG_MSG_DEVISION NUMBER(30) NOT NULL                                           
,LANG VARCHAR2(255)                                                             
,CONSTRAINT A_LOG_MESSAGES_PK PRIMARY KEY (MSG_ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_LOG_MSG_DEVISION                                               
create table A_LOG_MSG_DEVISION(                                                
ID NUMBER(30) NOT NULL                                                          
,SYSTEM VARCHAR2(255) NOT NULL                                                  
,CATEGORY VARCHAR2(255)                                                         
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_LOG_MSG_DEVISION_PK PRIMARY KEY (ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_MSG_GROUP_DETAIL                                               
create table A_MSG_GROUP_DETAIL(                                                
MSG_GROUP_ID NUMBER(30) NOT NULL                                                
,PROTOCOL_MSG_ID NUMBER(30) NOT NULL                                            
,CONSTRAINT A_MSG_GROUP_DETAIL_PK PRIMARY KEY (MSG_GROUP_ID,PROTOCOL_MSG_ID)    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_MSG_LOGIC_INFO                                                 
create table A_MSG_LOGIC_INFO(                                                  
ID NUMBER(30) NOT NULL                                                          
,ATTR NUMBER(30) NOT NULL                                                       
,DESCRIPTION VARCHAR2(255)                                                      
,PRE_FLOW_ID NUMBER(30)                                                         
,FLOW_ID NUMBER(30)                                                             
,CONSTRAINT A_MSG_LOGIC_INFO_PK PRIMARY KEY (ID)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_MSG_PROTOCOL_INFO                                              
create table A_MSG_PROTOCOL_INFO(                                               
ID NUMBER(30) NOT NULL                                                          
,LOGIC_MSG_ID NUMBER(30) NOT NULL                                               
,IN_TRANSFORMER VARCHAR2(255)                                                   
,IN_TRANSFORMER_TYPE NUMBER(10)                                                 
,OUT_TRANSFORMER VARCHAR2(255)                                                  
,OUT_TRANSFORMER_TYPE NUMBER(10)                                                
,DESCRIPTION VARCHAR2(255)                                                      
,NAME VARCHAR2(255) NOT NULL                                                    
,CONSTRAINT A_MSG_PROTOCOL_INFO_PK PRIMARY KEY (ID)                             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_MSG_TOKEN                                                      
create table A_MSG_TOKEN(                                                       
ID NUMBER(30) NOT NULL                                                          
,PROTOCOL_MSG_ID NUMBER(30) NOT NULL                                            
,TOKEN VARCHAR2(255)                                                            
,CONSTRAINT A_MSG_TOKEN_PK PRIMARY KEY (ID)                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_NAMER                                                          
create table A_NAMER(                                                           
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,PARENT_NAMER NUMBER(30) NOT NULL                                               
,CONSTRAINT A_NAMER_PK PRIMARY KEY (ID)                                         
,CONSTRAINT UNQ_A_NAMER UNIQUE(NAME,PARENT_NAMER)                               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_NOTIFICATION                                                   
create table A_NOTIFICATION(                                                    
ID NUMBER(30) NOT NULL                                                          
,TEXT BLOB                                                                      
,CONSTRAINT A_NOTIFICATION_PK PRIMARY KEY (ID)                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_OA                                                             
create table A_OA(                                                              
ID NUMBER(30) NOT NULL                                                          
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,NOE_ID NUMBER(30) NOT NULL                                                     
,RELATED_OA_ID NUMBER(30) NOT NULL                                              
,ORG_ACCOUNT_ID NUMBER(30) NOT NULL                                             
,INSTRUMENT_ID NUMBER(30) NOT NULL                                              
,TOTAL NUMBER(30,10) NOT NULL                                                   
,CONSTRAINT A_OA_PK PRIMARY KEY (ID)                                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX A_OA_NOE_ID_INDEX ON A_OA                                          
(NOE_ID                                                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_OA_ALLOCATION                                                  
create table A_OA_ALLOCATION(                                                   
ID NUMBER(30) NOT NULL                                                          
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,OA_ID NUMBER(30) NOT NULL                                                      
,FUND_ACCOUNT_ID NUMBER(30) NOT NULL                                            
,QUANTITY NUMBER(30,10) NOT NULL                                                
,CONSTRAINT A_OA_ALLOCATION_PK PRIMARY KEY (ID)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ORGANIZATION                                                   
create table A_ORGANIZATION(                                                    
ID NUMBER(30) NOT NULL                                                          
,TYPE NUMBER(8)                                                                 
,NAME VARCHAR2(255) NOT NULL                                                    
,NAMER_ID NUMBER(30) NOT NULL                                                   
,DESCRIPTION VARCHAR2(255)                                                      
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT A_ORGANIZATION_PK PRIMARY KEY (ID)                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ORG_2_ACCOUNT                                                  
create table A_ORG_2_ACCOUNT(                                                   
ID NUMBER(30) NOT NULL                                                          
,ORG_ID NUMBER(30) NOT NULL                                                     
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,ROLE NUMBER(30) NOT NULL                                                       
,CONSTRAINT A_ORG_2_ACC_PK PRIMARY KEY (ID)                                     
,CONSTRAINT ORG_ACC_ROLE_UNQ UNIQUE(ACCOUNT_ID,ORG_ID,ROLE)                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ORG_2_ADDRESS                                                  
create table A_ORG_2_ADDRESS(                                                   
ID NUMBER(30) NOT NULL                                                          
,ORG_ID NUMBER(30) NOT NULL                                                     
,ADDRESS_ID NUMBER(30) NOT NULL                                                 
,ROLE NUMBER(30) NOT NULL                                                       
,CONSTRAINT A_ORG_2_ADD_PK PRIMARY KEY (ID)                                     
,CONSTRAINT ORG_ADD_ROLE_UNQ UNIQUE(ROLE,ORG_ID,ADDRESS_ID)                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ORG_2_DL                                                       
create table A_ORG_2_DL(                                                        
ID NUMBER(30) NOT NULL                                                          
,ORG_ID NUMBER(30) NOT NULL                                                     
,DL_ID NUMBER(30) NOT NULL                                                      
,ROLE NUMBER(30) NOT NULL                                                       
,CONSTRAINT A_ORG_2_DL_PK PRIMARY KEY (ID)                                      
,CONSTRAINT ORG_DL_ROLE_UNQ UNIQUE(ROLE,ORG_ID,DL_ID)                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ORG_2_ORG                                                      
create table A_ORG_2_ORG(                                                       
ID NUMBER(30) NOT NULL                                                          
,FROM_ORG_ID NUMBER(30) NOT NULL                                                
,TO_ORG_ID NUMBER(30) NOT NULL                                                  
,ROLE NUMBER(30) NOT NULL                                                       
,CONSTRAINT A_ORG_2_ORG_PK PRIMARY KEY (ID)                                     
,CONSTRAINT ORG_ORG_ROLE_UNQ UNIQUE(FROM_ORG_ID,TO_ORG_ID,ROLE)                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ORG_2_PERSON                                                   
create table A_ORG_2_PERSON(                                                    
ID NUMBER(30) NOT NULL                                                          
,ORG_ID NUMBER(30) NOT NULL                                                     
,PERSON_ID NUMBER(30) NOT NULL                                                  
,ROLE NUMBER(30) NOT NULL                                                       
,CONSTRAINT A_ORG_2_PER_PK PRIMARY KEY (ID)                                     
,CONSTRAINT ORG_PER_ROLE_UNQ UNIQUE(ORG_ID,PERSON_ID,ROLE)                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ORG_2_RECON_COMBINATION                                        
create table A_ORG_2_RECON_COMBINATION(                                         
ID NUMBER(30) NOT NULL                                                          
,ORG_ID NUMBER(30) NOT NULL                                                     
,COMBINATION_ID NUMBER(30) NOT NULL                                             
,ROLE NUMBER(30) NOT NULL                                                       
,CONSTRAINT A_ORG_2_RECON_COMBINATION_PK PRIMARY KEY (ID)                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ORG_ROLE                                                       
create table A_ORG_ROLE(                                                        
ID NUMBER(30) NOT NULL                                                          
,ORG_ID NUMBER(30) NOT NULL                                                     
,ROLE NUMBER(30) NOT NULL                                                       
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_ORG_ROLE_PK PRIMARY KEY (ID)                                      
,CONSTRAINT ORG_ROLE_UNQ UNIQUE(ORG_ID,ROLE)                                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_PARTNER                                                        
create table A_PARTNER(                                                         
ID NUMBER(30) NOT NULL                                                          
,DESCRIPTION VARCHAR2(255)                                                      
,DOMAIN_ID NUMBER(30) NOT NULL                                                  
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT A_PARTNER_PK PRIMARY KEY (ID)                                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_PARTNER_2_MSG_GROUP                                            
create table A_PARTNER_2_MSG_GROUP(                                             
PARTNER_ID NUMBER(30) NOT NULL                                                  
,MSG_GROUP_ID NUMBER(30) NOT NULL                                               
,CONSTRAINT A_PARTNER_2_MSG_GROUP_PK PRIMARY KEY (PARTNER_ID,MSG_GROUP_ID)      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_PERSON                                                         
create table A_PERSON(                                                          
ID NUMBER(30) NOT NULL                                                          
,TYPE NUMBER(8)                                                                 
,TITLE VARCHAR2(255)                                                            
,FIRST_NAME VARCHAR2(255)                                                       
,LAST_NAME VARCHAR2(255)                                                        
,DESCRIPTION VARCHAR2(255)                                                      
,USER_NAME VARCHAR2(255)                                                        
,OWNER_DOMAIN_ID NUMBER(30)                                                     
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT A_PERSON_PK PRIMARY KEY (ID)                                        
,CONSTRAINT USER_NAME_UNQ UNIQUE(USER_NAME)                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_PERSON_2_ACCOUNT                                               
create table A_PERSON_2_ACCOUNT(                                                
ID NUMBER(30) NOT NULL                                                          
,PERSON_ID NUMBER(30) NOT NULL                                                  
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,ROLE NUMBER(30) NOT NULL                                                       
,CONSTRAINT A_PER_2_ACC_PK PRIMARY KEY (ID)                                     
,CONSTRAINT PER_ACC_ROLE_UNQ UNIQUE(PERSON_ID,ACCOUNT_ID,ROLE)                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_PERSON_2_ADDRESS                                               
create table A_PERSON_2_ADDRESS(                                                
ID NUMBER(30) NOT NULL                                                          
,PERSON_ID NUMBER(30) NOT NULL                                                  
,ADDRESS_ID NUMBER(30) NOT NULL                                                 
,ROLE NUMBER(30) NOT NULL                                                       
,CONSTRAINT A_PER_2_ADD_PK PRIMARY KEY (ID)                                     
,CONSTRAINT PER_ADD_ROLE_UNQ UNIQUE(ROLE,PERSON_ID,ADDRESS_ID)                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_PERSON_ROLE                                                    
create table A_PERSON_ROLE(                                                     
ID NUMBER(30) NOT NULL                                                          
,PERSON_ID NUMBER(30) NOT NULL                                                  
,ROLE NUMBER(30) NOT NULL                                                       
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_PERSON_ROLE_PK PRIMARY KEY (ID)                                   
,CONSTRAINT PER_ROLE_UNQ UNIQUE(PERSON_ID,ROLE)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_POSITION_PCM                                                   
create table A_POSITION_PCM(                                                    
ID NUMBER(30) NOT NULL                                                          
,BASIS NUMBER(8) NOT NULL                                                       
,PCM_IMPL VARCHAR2(255) NOT NULL                                                
,ARREGATION_TYPE NUMBER(8) NOT NULL                                             
,CONSTRAINT A_POSITION_PCM_PK PRIMARY KEY (ID)                                  
,CONSTRAINT A_POSITION_PCM_UNQ UNIQUE(ARREGATION_TYPE,BASIS)                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_POSITION_SEMI_AGG_INSTR                                        
create table A_POSITION_SEMI_AGG_INSTR(                                         
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30)                                                          
,POSITION_TYPE NUMBER(30)                                                       
,POSITION_COMBINATION NUMBER(30)                                                
,VALUE_DATE DATE                                                                
,INSTRUMENT_ID NUMBER(30)                                                       
,AMOUNT NUMBER(30,10)                                                           
,GROSS NUMBER(30,10)                                                            
,CONSTRAINT A_POSITION_SEMI_AGG_INSTR_PK PRIMARY KEY (ID)                       
,CONSTRAINT A_POS_SEMI_AGG_INSTR_UNQ                                            
UNIQUE(ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,VALUE_DATE,INSTRUMENT_ID)  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX A_POS_SEMI_AGG_INSTR_IND1 ON A_POSITION_SEMI_AGG_INSTR             
(ACCOUNT_ID                                                                     
,POSITION_TYPE                                                                  
,POSITION_COMBINATION                                                           
,VALUE_DATE                                                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_POS_SEMI_AGG_INSTR_IND2 ON A_POSITION_SEMI_AGG_INSTR             
(ACCOUNT_ID                                                                     
,POSITION_TYPE                                                                  
,POSITION_COMBINATION                                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_POSITION_SEMI_AGG_INSTR_2_TA                                   
create table A_POSITION_SEMI_AGG_INSTR_2_TA(                                    
ID NUMBER(30) NOT NULL                                                          
,POSITION_SEMI_AGG_INSTR_ID NUMBER(30)                                          
,TA_ID NUMBER(30)                                                               
,CONSTRAINT A_POS_SEMI_AGG_INSTR_2_TA_PK PRIMARY KEY (ID)                       
,CONSTRAINT A_POS_SEMI_AGG_INSTR_2_TA_UNQ                                       
UNIQUE(POSITION_SEMI_AGG_INSTR_ID,TA_ID)                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_POSITION_SEMI_AGG_INSTR_ALL                                    
create table A_POSITION_SEMI_AGG_INSTR_ALL(                                     
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30)                                                          
,POSITION_TYPE NUMBER(30)                                                       
,POSITION_COMBINATION NUMBER(30)                                                
,VALUE_DATE DATE                                                                
,INSTRUMENT_ID NUMBER(30)                                                       
,AMOUNT NUMBER(30,10)                                                           
,CURR_DATE DATE                                                                 
,TA_ID NUMBER(30)                                                               
,CONSTRAINT A_POS_SEMI_AGG_INSTR_ALL_PK PRIMARY KEY (ID)                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX A_POS_SEMI_AGG_INSTR_ALL_IND ON A_POSITION_SEMI_AGG_INSTR_ALL      
(ACCOUNT_ID                                                                     
,POSITION_TYPE                                                                  
,POSITION_COMBINATION                                                           
,CURR_DATE                                                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_POSITION_SEMI_AGG_TRADE                                        
create table A_POSITION_SEMI_AGG_TRADE(                                         
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30)                                                          
,POSITION_TYPE NUMBER(30)                                                       
,POSITION_COMBINATION NUMBER(30)                                                
,VALUE_DATE DATE                                                                
,INSTRUMENT_ID_1 NUMBER(30)                                                     
,INSTRUMENT_ID_2 NUMBER(30)                                                     
,AMOUNT_1 NUMBER(30,10)                                                         
,AMOUNT_2 NUMBER(30,10)                                                         
,CONSTRAINT A_POSITION_SEMI_AGG_TRADE_PK PRIMARY KEY (ID)                       
,CONSTRAINT A_POS_SEMI_AGG_TRADE_UNQ                                            
UNIQUE(ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,VALUE_DATE,INSTRUMENT_ID_1,
INSTRUMENT_ID_2)                                                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX A_POS_SEMI_AGG_TRADE_IND1 ON A_POSITION_SEMI_AGG_TRADE             
(ACCOUNT_ID                                                                     
,POSITION_TYPE                                                                  
,POSITION_COMBINATION                                                           
,VALUE_DATE                                                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_POS_SEMI_AGG_TRADE_IND2 ON A_POSITION_SEMI_AGG_TRADE             
(ACCOUNT_ID                                                                     
,POSITION_TYPE                                                                  
,POSITION_COMBINATION                                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_POSITION_SEMI_AGG_TRADE_2_TA                                   
create table A_POSITION_SEMI_AGG_TRADE_2_TA(                                    
ID NUMBER(30) NOT NULL                                                          
,POSITION_SEMI_AGG_TRADE_ID NUMBER(30)                                          
,TA_ID NUMBER(30)                                                               
,CONSTRAINT A_POS_SEMI_AGG_TRADE_2_TA_PK PRIMARY KEY (ID)                       
,CONSTRAINT A_POS_SEMI_AGG_TRADE_2_TA_UNQ                                       
UNIQUE(POSITION_SEMI_AGG_TRADE_ID,TA_ID)                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_POSITION_SEMI_AGG_TRADE_ALL                                    
create table A_POSITION_SEMI_AGG_TRADE_ALL(                                     
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30)                                                          
,POSITION_TYPE NUMBER(30)                                                       
,POSITION_COMBINATION NUMBER(30)                                                
,VALUE_DATE DATE                                                                
,INSTRUMENT_ID_1 NUMBER(30)                                                     
,INSTRUMENT_ID_2 NUMBER(30)                                                     
,AMOUNT_1 NUMBER(30,10)                                                         
,AMOUNT_2 NUMBER(30,10)                                                         
,CURR_DATE DATE                                                                 
,TA_ID NUMBER(30)                                                               
,CONSTRAINT A_POS_SEMI_AGG_TRADE_ALL_PK PRIMARY KEY (ID)                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX A_POS_SEMI_AGG_TRADE_ALL_IND ON A_POSITION_SEMI_AGG_TRADE_ALL      
(ACCOUNT_ID                                                                     
,POSITION_TYPE                                                                  
,POSITION_COMBINATION                                                           
,CURR_DATE                                                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_POSITION_SEMI_AG_IN_2_TA_HIS                                   
create table A_POSITION_SEMI_AG_IN_2_TA_HIS(                                    
ID NUMBER(30) NOT NULL                                                          
,POSITION_SEMI_AG_IN_HIS_ID NUMBER(30)                                          
,TA_ID NUMBER(30)                                                               
,CONSTRAINT A_POS_SEMI_AG_IN_HIS_2_TA_PK PRIMARY KEY (ID)                       
,CONSTRAINT A_POS_SEMI_AG_IN_2_TA_HIS_UNQ                                       
UNIQUE(POSITION_SEMI_AG_IN_HIS_ID,TA_ID)                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_POSITION_SEMI_AG_IN_HIS                                        
create table A_POSITION_SEMI_AG_IN_HIS(                                         
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30)                                                          
,POSITION_TYPE NUMBER(30)                                                       
,POSITION_COMBINATION NUMBER(30)                                                
,VALUE_DATE DATE                                                                
,INSTRUMENT_ID NUMBER(30)                                                       
,AMOUNT NUMBER(30,10)                                                           
,GROSS NUMBER(30,10)                                                            
,CONSTRAINT A_POSITION_SEMI_AG_IN_HIS_PK PRIMARY KEY (ID)                       
,CONSTRAINT A_POS_SEMI_AGG_INSTR_HIS_UNQ                                        
UNIQUE(ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,VALUE_DATE,INSTRUMENT_ID)  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX A_POS_SEMI_AG_IN_HIS_IND1 ON A_POSITION_SEMI_AG_IN_HIS             
(ACCOUNT_ID                                                                     
,POSITION_TYPE                                                                  
,POSITION_COMBINATION                                                           
,VALUE_DATE                                                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_POS_SEMI_AG_IN_HIS_IND2 ON A_POSITION_SEMI_AG_IN_HIS             
(ACCOUNT_ID                                                                     
,POSITION_TYPE                                                                  
,POSITION_COMBINATION                                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_POSITION_SEMI_AG_TR_2_TA_HIS                                   
create table A_POSITION_SEMI_AG_TR_2_TA_HIS(                                    
ID NUMBER(30) NOT NULL                                                          
,POSITION_SEMI_AG_TR_HIS_ID NUMBER(30)                                          
,TA_ID NUMBER(30)                                                               
,CONSTRAINT A_POS_SEMI_AG_TR_2_TA_HIS_PK PRIMARY KEY (ID)                       
,CONSTRAINT A_POS_SEMI_AG_TR_2_TA_HIS_UNQ                                       
UNIQUE(POSITION_SEMI_AG_TR_HIS_ID,TA_ID)                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_POSITION_SEMI_AG_TR_HIS                                        
create table A_POSITION_SEMI_AG_TR_HIS(                                         
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30)                                                          
,POSITION_TYPE NUMBER(30)                                                       
,POSITION_COMBINATION NUMBER(30)                                                
,VALUE_DATE DATE                                                                
,INSTRUMENT_ID_1 NUMBER(30)                                                     
,INSTRUMENT_ID_2 NUMBER(30)                                                     
,AMOUNT_1 NUMBER(30,10)                                                         
,AMOUNT_2 NUMBER(30,10)                                                         
,CONSTRAINT A_POSITION_SEMI_AG_TR_HIS_PK PRIMARY KEY (ID)                       
,CONSTRAINT A_POS_SEMI_AGG_TRADE_HIS_UNQ                                        
UNIQUE(ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,VALUE_DATE,INSTRUMENT_ID_1,
INSTRUMENT_ID_2)                                                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX A_POS_SEMI_AG_TR_HIS_IND1 ON A_POSITION_SEMI_AG_TR_HIS             
(ACCOUNT_ID                                                                     
,POSITION_TYPE                                                                  
,POSITION_COMBINATION                                                           
,VALUE_DATE                                                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_POS_SEMI_AG_TR_HIS_IND2 ON A_POSITION_SEMI_AG_TR_HIS             
(ACCOUNT_ID                                                                     
,POSITION_TYPE                                                                  
,POSITION_COMBINATION                                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_PROFILE_OWNER                                                  
create table A_PROFILE_OWNER(                                                   
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,TYPE NUMBER(30)                                                                
,PARENT_OWNER NUMBER(30) NOT NULL                                               
,TIME DATE NOT NULL                                                             
,CONSTRAINT A_PROFILE_OWNER_PK PRIMARY KEY (ID)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_PROFILE_PROPERTY                                               
create table A_PROFILE_PROPERTY(                                                
ID NUMBER(30) NOT NULL                                                          
,PROFILE_OWNER_ID NUMBER(30) NOT NULL                                           
,KEY VARCHAR2(255) NOT NULL                                                     
,SEQUENCE NUMBER(30,10) NOT NULL                                                
,EXPRESSION VARCHAR2(4000)                                                      
,VALUE VARCHAR2(4000) NOT NULL                                                  
,TIME DATE NOT NULL                                                             
,CONSTRAINT A_PROFILE_PROPERTY_PK PRIMARY KEY (ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_RECON_COMBINATION                                              
create table A_RECON_COMBINATION(                                               
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,DESCRIPTION VARCHAR2(255)                                                      
,IS_DEFAULT NUMBER(1)                                                           
,CONSTRAINT A_RECON_COMBINATION_PK PRIMARY KEY (ID)                             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_RECON_COMBINATION_2_RECON                                      
create table A_RECON_COMBINATION_2_RECON(                                       
ID NUMBER(30) NOT NULL                                                          
,COMBINATION_ID NUMBER(30) NOT NULL                                             
,RECON_ID NUMBER(30) NOT NULL                                                   
,CONSTRAINT A_RECON_COMBINATION_2_RECON_PK PRIMARY KEY (ID)                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_RECON_DEF                                                      
create table A_RECON_DEF(                                                       
ID NUMBER(30) NOT NULL                                                          
,RECON_NAME VARCHAR2(255) NOT NULL                                              
,TRESHOLD NUMBER(30,10)                                                         
,MATCH_LIST_SIZE NUMBER(30)                                                     
,STOP_ONCE_FOUND NUMBER(1)                                                      
,AUTO_MATCH NUMBER(8)                                                           
,RECON_TYPE NUMBER(8)                                                           
,CONSTRAINT A_RECON_DEF_PK PRIMARY KEY (ID)                                     
,CONSTRAINT A_RECON_DEF_U1 UNIQUE(RECON_NAME)                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_RECON_DETAIL                                                   
create table A_RECON_DETAIL(                                                    
ID NUMBER(30) NOT NULL                                                          
,RECON_ID NUMBER(30) NOT NULL                                                   
,SOURCE_METHOD_NAME VARCHAR2(255) NOT NULL                                      
,SOURCE_LOGIC_NAME VARCHAR2(255) NOT NULL                                       
,VIEW_IN_TRACE_MODE NUMBER(1)                                                   
,COMPARING_TYPE NUMBER(1)                                                       
,CONSTRAINT A_RECON_DETAIL_PK PRIMARY KEY (ID,RECON_ID)                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_RECON_EXP                                                      
create table A_RECON_EXP(                                                       
ID NUMBER(30) NOT NULL                                                          
,RECON_DETAIL_ID NUMBER(30) NOT NULL                                            
,COMPARE_TARGET_METHOD_NAME VARCHAR2(255) NOT NULL                              
,COMPARE_TARGET_LOGIC_NAME VARCHAR2(255) NOT NULL                               
,EXPRESSION VARCHAR2(255)                                                       
,EXPRESSION_TYPE NUMBER(1)                                                      
,WEIGHT NUMBER(30,10)                                                           
,METHOD_PATH VARCHAR2(255)                                                      
,METHOD_NAME VARCHAR2(255)                                                      
,CONSTRAINT A_RECON_EXP_PK PRIMARY KEY (ID,RECON_DETAIL_ID)                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ROLE                                                           
create table A_ROLE(                                                            
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,TYPE NUMBER(8) NOT NULL                                                        
,DESCRIPTION VARCHAR2(255)                                                      
,SUB_TYPE NUMBER(8)                                                             
,CONSTRAINT A_ROLE_PK PRIMARY KEY (ID)                                          
,CONSTRAINT ROLE_NAME_TYPE_UNQ UNIQUE(NAME,TYPE)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ROLL_TXN                                                       
create table A_ROLL_TXN(                                                        
ID NUMBER(30) NOT NULL                                                          
,UUID VARCHAR2(255) NOT NULL                                                    
,PARTNER_ID NUMBER(30) NOT NULL                                                 
,CREATION_TIME DATE NOT NULL                                                    
,EXEC_TIME DATE                                                                 
,PRIORITY NUMBER(30) NOT NULL                                                   
,ADDITIONAL_REF VARCHAR2(255)                                                   
,MSG_PROTOCOL_INFO_ID NUMBER(30) NOT NULL                                       
,CONTENT BLOB NOT NULL                                                          
,CONSTRAINT A_ROLL_TXN_PK PRIMARY KEY (ID)                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX ROLL_TXN_UUID_INDEX ON A_ROLL_TXN                                  
(UUID                                                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_RULE_PROJECT                                                   
create table A_RULE_PROJECT(                                                    
PACKAGE_NAME VARCHAR2(255) NOT NULL                                             
,PROJECT_NAME VARCHAR2(255) NOT NULL                                            
,UUID VARCHAR2(255)                                                             
,TEMPLATE_TYPE VARCHAR2(255)                                                    
,RW_MODE NUMBER(1)                                                              
,CONSTRAINT A_RULE_PROJECT_PK PRIMARY KEY (PROJECT_NAME)                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_RULE_RULE                                                      
create table A_RULE_RULE(                                                       
RULE_NAME VARCHAR2(255) NOT NULL                                                
,IF_UUID VARCHAR2(255)                                                          
,THEN_STATEMENT_UUID VARCHAR2(255)                                              
,ELSE_STATEMENT_UUID VARCHAR2(255)                                              
,UUID VARCHAR2(255) NOT NULL                                                    
,PROJECT_NAME VARCHAR2(255)                                                     
,RULESET_NAME VARCHAR2(255)                                                     
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_RULE_RULE_PK PRIMARY KEY (UUID)                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_RULE_RULESET                                                   
create table A_RULE_RULESET(                                                    
SEQ NUMBER(30) NOT NULL                                                         
,RULESET_NAME VARCHAR2(255) NOT NULL                                            
,UUID VARCHAR2(255) NOT NULL                                                    
,PROJECT_NAME VARCHAR2(255)                                                     
,CONSTRAINT A_RULE_RULESET_PK PRIMARY KEY (UUID)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SECURITY_AUDIT                                                 
create table A_SECURITY_AUDIT(                                                  
ID NUMBER(30) NOT NULL                                                          
,MSG_ID NUMBER(30) NOT NULL                                                     
,MSG VARCHAR2(255) NOT NULL                                                     
,REF VARCHAR2(255) NOT NULL                                                     
,SEVERITY NUMBER(10) NOT NULL                                                   
,TIME DATE NOT NULL                                                             
,OBJECT VARCHAR2(4000) NOT NULL                                                 
,EXCEPTION_NAME VARCHAR2(4000)                                                  
,EXCEPTION_MSG VARCHAR2(4000)                                                   
,EXCEPTION_MORE VARCHAR2(4000)                                                  
,IP VARCHAR2(255) NOT NULL                                                      
,SERVER VARCHAR2(255) NOT NULL                                                  
,CONSTRAINT A_SECURITY_AUDIT_PK PRIMARY KEY (ID)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX SECURITY_AUDIT_REF_INDEX ON A_SECURITY_AUDIT                       
(REF                                                                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_SECURITY_GROUP                                                 
create table A_SECURITY_GROUP(                                                  
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,SUBTYPE NUMBER(30)                                                             
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_SECURITY_GROUP_PK PRIMARY KEY (ID)                                
,CONSTRAINT A_SEC_GRP_NAME_UNQ UNIQUE(NAME)                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SECURITY_PERMISSION                                            
create table A_SECURITY_PERMISSION(                                             
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,DESCRIPTION VARCHAR2(255)                                                      
,ROLE_ID NUMBER(30) NOT NULL                                                    
,RESOURCE_ID NUMBER(30) NOT NULL                                                
,CONSTRAINT SEC_PERMISSION_PK PRIMARY KEY (ID)                                  
,CONSTRAINT A_SEC_PERMISSION_UNQ UNIQUE(NAME,RESOURCE_ID,ROLE_ID)               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SECURITY_PRINCIPAL                                             
create table A_SECURITY_PRINCIPAL(                                              
ID NUMBER(30) NOT NULL                                                          
,TYPE NUMBER(8) NOT NULL                                                        
,CONSTRAINT A_SECURITY_PRINCIPAL_PK PRIMARY KEY (ID)                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SECURITY_PRINCIPAL_GROUP                                       
create table A_SECURITY_PRINCIPAL_GROUP(                                        
ID NUMBER(30) NOT NULL                                                          
,PRINCIPAL_ID NUMBER(30) NOT NULL                                               
,GROUP_ID NUMBER(30) NOT NULL                                                   
,CONSTRAINT A_SECURITY_PRINCIPAL_GROUP_PK PRIMARY KEY (ID)                      
,CONSTRAINT SECURITY_PRNCPL_GROUP_UNQ UNIQUE(PRINCIPAL_ID,GROUP_ID)             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SECURITY_PRINCIPAL_ROLE                                        
create table A_SECURITY_PRINCIPAL_ROLE(                                         
ID NUMBER(30) NOT NULL                                                          
,PRINCIPAL_ID NUMBER(30) NOT NULL                                               
,ROLE_ID NUMBER(30) NOT NULL                                                    
,CONSTRAINT A__SECURITY_PRINCIPAL_ROLE_PK PRIMARY KEY (ID)                      
,CONSTRAINT A_SECURITY_PRINCIPAL_ROLE_UNQ UNIQUE(ROLE_ID,PRINCIPAL_ID)          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SECURITY_RESOURCE                                              
create table A_SECURITY_RESOURCE(                                               
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,DESCRIPTION VARCHAR2(255)                                                      
,TYPE NUMBER(8)                                                                 
,CONSTRAINT USER_SEC_RESOURCE_PK PRIMARY KEY (ID)                               
,CONSTRAINT A_RESOURCE_NAME_UNIQUE UNIQUE(NAME)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SECURITY_USER                                                  
create table A_SECURITY_USER(                                                   
ID NUMBER(30) NOT NULL                                                          
,PERSON_ID NUMBER(30) NOT NULL                                                  
,USER_NAME VARCHAR2(255) NOT NULL                                               
,LAST_LOGIN_TIME DATE                                                           
,LAST_PWD_CHANGE DATE                                                           
,FORCE_CHANGE_PWD NUMBER(1)                                                     
,ACCOUNT_DISABLED NUMBER(1)                                                     
,IS_LOCKED NUMBER(1)                                                            
,FAILED_LOGINS_NUM NUMBER(8)                                                    
,PASSWORD VARCHAR2(255)                                                         
,CONSTRAINT A_USER_PK PRIMARY KEY (ID)                                          
,CONSTRAINT A_SEC_PERSON_ID_UNQ UNIQUE(PERSON_ID)                               
,CONSTRAINT A_SEC_USER_NAME_UNQ UNIQUE(USER_NAME)                               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SECURITY_USER_HISTORY                                          
create table A_SECURITY_USER_HISTORY(                                           
ID NUMBER(30) NOT NULL                                                          
,USER_ID NUMBER(30)                                                             
,USER_NAME VARCHAR2(255)                                                        
,DATE_DELETED DATE                                                              
,PERSON_ID NUMBER(30)                                                           
,PASSWORD VARCHAR2(255)                                                         
,CONSTRAINT SEC_USER_HISTORY_PK PRIMARY KEY (ID)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SECURITY_USER_LOCKS_HISTORY                                    
create table A_SECURITY_USER_LOCKS_HISTORY(                                     
ID NUMBER(30) NOT NULL                                                          
,USER_ID NUMBER(30) NOT NULL                                                    
,LOCK_TIME DATE NOT NULL                                                        
,UNLOCK_TIME DATE                                                               
,LOCK_REASON VARCHAR2(255)                                                      
,CONSTRAINT SEC_USER_LOCKS_HISTORY_PK PRIMARY KEY (ID)                          
,CONSTRAINT A_SEC_USER_LCKS_UNQ UNIQUE(USER_ID,LOCK_TIME)                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SECURITY_USER_PWD_HISTORY                                      
create table A_SECURITY_USER_PWD_HISTORY(                                       
ID NUMBER(30) NOT NULL                                                          
,USER_ID NUMBER(30) NOT NULL                                                    
,PASSWORD VARCHAR2(255) NOT NULL                                                
,CHANGE_TIME DATE NOT NULL                                                      
,CONSTRAINT A_USER_PWD_HIS_PK PRIMARY KEY (ID)                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SP_JMS_DEF                                                     
create table A_SP_JMS_DEF(                                                      
ID NUMBER(30) NOT NULL                                                          
,JNDI_NAME VARCHAR2(255) NOT NULL                                               
,DEST_TYPE NUMBER(30) NOT NULL                                                  
,A_SP_TYPE_ID NUMBER(30) NOT NULL                                               
,LISTENER_COUNT NUMBER(30) NOT NULL                                             
,TXN_EXSIST NUMBER(1) NOT NULL                                                  
,SERVER_NAME VARCHAR2(255) NOT NULL                                             
,TTL NUMBER(30)                                                                 
,CONSTRAINT A_SP_JMS_DEF_PK PRIMARY KEY (ID)                                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_SP_MESSAGE_TYPE_DEF                                            
create table A_SP_MESSAGE_TYPE_DEF(                                             
ID NUMBER(30) NOT NULL                                                          
,MSG_TYPE_ID NUMBER(30) NOT NULL                                                
,TOKEN VARCHAR2(255) NOT NULL                                                   
,CONSTRAINT A_SP_MESSAGE_TYPE_DEF_PK PRIMARY KEY (ID)                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_TA                                                             
create table A_TA(                                                              
ID NUMBER(30) NOT NULL                                                          
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,ISSUER_ACCOUNT_ID NUMBER(30) NOT NULL                                          
,TXN_TYPE NUMBER(10) NOT NULL                                                   
,SELLER_ACCOUNT_ID NUMBER(30) NOT NULL                                          
,BUYER_ACCOUNT_ID NUMBER(30) NOT NULL                                           
,BASE_INSTRUMENT_ID NUMBER(30) NOT NULL                                         
,SECONDERY_INSTRUMENT_ID NUMBER(30) NOT NULL                                    
,BASE_INSTRUMENT_QTY NUMBER(30,10) NOT NULL                                     
,SECONDERY_INSTRUMENT_QTY NUMBER(30,10) NOT NULL                                
,SELLER_NOE_ID NUMBER(30) NOT NULL                                              
,BUYER_NOE_ID NUMBER(30) NOT NULL                                               
,RATE NUMBER(30,10) NOT NULL                                                    
,FAR_RATE NUMBER(30,10)                                                         
,VALUE_DATE DATE NOT NULL                                                       
,TRADE_DATE DATE NOT NULL                                                       
,CREATED_DATE DATE NOT NULL                                                     
,TXN_CONTRACT_DIRECTION VARCHAR2(255) NOT NULL                                  
,RELATED_TXN_ID NUMBER(30) NOT NULL                                             
,TRADE_GROUP_ID NUMBER(30) NOT NULL                                             
,PARENT_TRADE_ID NUMBER(30) NOT NULL                                            
,DESCRIPTION VARCHAR2(255)                                                      
,TRADING_PARTY NUMBER(30)                                                       
,COUNTER_PARTY NUMBER(30)                                                       
,TRADING_PARTY_NOE_ID NUMBER(30)                                                
,COUNTER_PARTY_NOE_ID NUMBER(30)                                                
,BOOKING_ID VARCHAR2(255)                                                       
,CONSTRAINT A_TA_PK PRIMARY KEY (ID)                                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX A_TA_BUYER_NOE_IND ON A_TA                                         
(BUYER_NOE_ID                                                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_TA_COUNTER_PARTY_IDX ON A_TA                                     
(COUNTER_PARTY                                                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_TA_CREATED_DATE_IDX ON A_TA                                      
(CREATED_DATE                                                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_TA_SELLER_NOE_IND ON A_TA                                        
(SELLER_NOE_ID                                                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_TA_TRADE_DATE_IDX ON A_TA                                        
(TRADE_DATE                                                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_TA_TRADE_GROUP_ID_IDX ON A_TA                                    
(TRADE_GROUP_ID                                                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_TA_TRADING_PARTY_IDX ON A_TA                                     
(TRADING_PARTY                                                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_TA_VALUE_DATE_IDX ON A_TA                                        
(VALUE_DATE                                                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_TA_TA_REL                                                      
create table A_TA_TA_REL(                                                       
ID NUMBER(30) NOT NULL                                                          
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,PARENT_TA_ID NUMBER(30) NOT NULL                                               
,CHILD_TA_ID NUMBER(30) NOT NULL                                                
,RELATION NUMBER(30) NOT NULL                                                   
,CONSTRAINT A_TA_TA_REL_PK PRIMARY KEY (ID)                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_TRACKING_DATA                                                  
create table A_TRACKING_DATA(                                                   
UUID VARCHAR2(255) NOT NULL                                                     
,TIME DATE NOT NULL                                                             
,ADAPTER_PROCESS NUMBER(30) NOT NULL                                            
,FLOW_PROCESS NUMBER(30) NOT NULL                                               
,DATA BLOB NOT NULL                                                             
,CONSTRAINT TRACKING_DATA_PK PRIMARY KEY (UUID)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_TRANSITION                                                     
create table A_TRANSITION(                                                      
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255)                                                             
,PARENT_TYPE NUMBER(8)                                                          
,PARENT_STATE_FROM NUMBER(30)                                                   
,PARENT_STATE_TO NUMBER(30)                                                     
,CHILD_TYPE NUMBER(8)                                                           
,CHILD_STATE_FROM NUMBER(30)                                                    
,CHILD_STATE_TO NUMBER(30)                                                      
,ROLE NUMBER(30)                                                                
,ORDER_SEQ NUMBER(8) NOT NULL                                                   
,IS_STRICT NUMBER(1)                                                            
,SUB_TRANSITION NUMBER(30)                                                      
,PARENT_PROCESSOR VARCHAR2(255)                                                 
,CHILD_PROCESSOR VARCHAR2(255)                                                  
,CONSTRAINT A_TRANSITION_PK PRIMARY KEY (ID,ORDER_SEQ)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_TRANSITION_STATE                                               
create table A_TRANSITION_STATE(                                                
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255)                                                             
,STATUS_TYPE NUMBER(30)                                                         
,STATUS_VALUE NUMBER(8)                                                         
,CONSTRAINT A_TRANSITION_STATE_PK PRIMARY KEY (ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_TRANSITION_STATE_HISTORY                                       
create table A_TRANSITION_STATE_HISTORY(                                        
ID NUMBER(30) NOT NULL                                                          
,TRANSITION_ID NUMBER(30) NOT NULL                                              
,DCO_ID NUMBER(30) NOT NULL                                                     
,DCO_TYPE NUMBER(8) NOT NULL                                                    
,IS_PARENT NUMBER(1) NOT NULL                                                   
,STATE_FROM NUMBER(30) NOT NULL                                                 
,STATE_TO NUMBER(30) NOT NULL                                                   
,REASON BLOB                                                                    
,PROCESS_ID VARCHAR2(255) NOT NULL                                              
,EXECUTED_BY VARCHAR2(255)                                                      
,CHANGE_DATE DATE NOT NULL                                                      
,CONSTRAINT A_TRANSITION_STATE_HISTORY_PK PRIMARY KEY (ID)                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_UID                                                            
create table A_UID(                                                             
UUID VARCHAR2(255) NOT NULL                                                     
,BUSINESS_PROCESS_ID NUMBER(30) NOT NULL                                        
,CONVERSATION_ID NUMBER(30) NOT NULL                                            
,CREATION_TIME DATE NOT NULL                                                    
,CONSTRAINT A_UID_PK PRIMARY KEY (UUID,BUSINESS_PROCESS_ID,CONVERSATION_ID)     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VAL_FUNCTION_PARAM                                             
create table A_VAL_FUNCTION_PARAM(                                              
ID NUMBER(30) NOT NULL                                                          
,FUNCTION_ID NUMBER(30) NOT NULL                                                
,NAME VARCHAR2(255)                                                             
,TYPE VARCHAR2(255) NOT NULL                                                    
,PARAM_INDEX NUMBER(10) NOT NULL                                                
,SOURCE_DATA_TYPE_ID NUMBER(30) NOT NULL                                        
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_VAL_FUNCTION_PARAMS_PK PRIMARY KEY (ID)                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VAL_MARKET_2_SOURCE_DATA                                       
create table A_VAL_MARKET_2_SOURCE_DATA(                                        
ID NUMBER(30) NOT NULL                                                          
,MARKET_DATA_ID NUMBER(30) NOT NULL                                             
,SOURCE_DATA_ID NUMBER(30) NOT NULL                                             
,CONSTRAINT A_VAL_MARKET_2_SOUR_DATA_PK PRIMARY KEY (ID)                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VAL_MARKET_CONTEXT                                             
create table A_VAL_MARKET_CONTEXT(                                              
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255)                                                             
,MARKET_DATA_ID NUMBER(30) NOT NULL                                             
,FUNCTION_ID NUMBER(30) NOT NULL                                                
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_VAL_MARKET_CONTEXT_PK PRIMARY KEY (ID)                            
,CONSTRAINT A_FUNCTION_MARKET_DATA_UNIQ UNIQUE(FUNCTION_ID,MARKET_DATA_ID)      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VAL_MARKET_DATA                                                
create table A_VAL_MARKET_DATA(                                                 
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255)                                                             
,MARKET_TYPE NUMBER(10) NOT NULL                                                
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_VAL_MARKET_DATA_PK PRIMARY KEY (ID)                               
,CONSTRAINT A_VAL_MARKET_DATA_NAME_UNIQ UNIQUE(NAME)                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VAL_MARKET_FUNCTION                                            
create table A_VAL_MARKET_FUNCTION(                                             
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,CLASS_NAME VARCHAR2(255) NOT NULL                                              
,METHOD_NAME VARCHAR2(255) NOT NULL                                             
,OPERATION_TYPE NUMBER(10) NOT NULL                                             
,IMPLEMENTATION_TYPE NUMBER(10) NOT NULL                                        
,STATUS NUMBER(10) NOT NULL                                                     
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_VAL_MARKET_FUNCTIONS_PK PRIMARY KEY (ID)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VAL_MD_CURRENCY                                                
create table A_VAL_MD_CURRENCY(                                                 
ID NUMBER(30) NOT NULL                                                          
,INSTRUMENT_ID NUMBER(30) NOT NULL                                              
,SPOT_RATE NUMBER(30,10) NOT NULL                                               
,CURRENCY_DATE DATE NOT NULL                                                    
,SOURCE_ID NUMBER(10) NOT NULL                                                  
,CONSTRAINT A_VAL_MD_CURRENCY_PK PRIMARY KEY (ID)                               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE UNIQUE INDEX A_VAL_MD_DATE_INST_SOU_UNIQ ON A_VAL_MD_CURRENCY            
(INSTRUMENT_ID                                                                  
,CURRENCY_DATE                                                                  
,SOURCE_ID                                                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_VAL_MD_DISCOUNT_CURVE                                          
create table A_VAL_MD_DISCOUNT_CURVE(                                           
ID NUMBER(30) NOT NULL                                                          
,RATE NUMBER(30,10) NOT NULL                                                    
,DISCOUNT_DATE DATE NOT NULL                                                    
,SOURCE_ID NUMBER(10) NOT NULL                                                  
,INSTRUMENT_ID NUMBER(30) NOT NULL                                              
,CONSTRAINT A_VAL_MD_DISCOUNT_CURVE_PK PRIMARY KEY (ID)                         
,CONSTRAINT A_VAL_INST_DATE_SOUR_UNIQ                                           
UNIQUE(SOURCE_ID,INSTRUMENT_ID,DISCOUNT_DATE)                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VAL_MD_INTEREST_RATE                                           
create table A_VAL_MD_INTEREST_RATE(                                            
ID NUMBER(30) NOT NULL                                                          
,RATE NUMBER(30,10) NOT NULL                                                    
,SOURCE_ID NUMBER(10) NOT NULL                                                  
,INSTRUMENT_ID NUMBER(30) NOT NULL                                              
,INTEREST_DATE DATE NOT NULL                                                    
,ACCRUAL_METHOD NUMBER(10) NOT NULL                                             
,RATE_TYPE NUMBER(10)                                                           
,CONSTRAINT A_VAL_MD_INTEREST_RATE_PK PRIMARY KEY (ID)                          
,CONSTRAINT A_VAL_MD_INTEREST_RATE_UNIQ UNIQUE(INSTRUMENT_ID,SOURCE_ID)         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VAL_MD_OPTION                                                  
create table A_VAL_MD_OPTION(                                                   
ID NUMBER(30) NOT NULL                                                          
,INSTRUMENT_ID NUMBER(30)                                                       
,DELTA NUMBER(30,10)                                                            
,DELTA_CURRENCY NUMBER(30)                                                      
,SIGMA NUMBER(30,10)                                                            
,MARKET_SPOT NUMBER(30,10)                                                      
,SOURCE_ID NUMBER(10) NOT NULL                                                  
,UPDATE_DATE DATE                                                               
,DELTA_SEC NUMBER(30,10)                                                        
,TA_ID NUMBER(30) NOT NULL                                                      
,VEGA NUMBER(30,10)                                                             
,GAMMA NUMBER(30,10)                                                            
,VOLATILITY NUMBER(30,10)                                                       
,CONSTRAINT A_VAL_MD_OPTION_PK PRIMARY KEY (ID)                                 
,CONSTRAINT A_VAL_TA_SOUR_UNIQ UNIQUE(TA_ID,SOURCE_ID)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VAL_SOURCE_DATA                                                
create table A_VAL_SOURCE_DATA(                                                 
ID NUMBER(30) NOT NULL                                                          
,SOURCE_ID NUMBER(10) NOT NULL                                                  
,SOURCE_DATA_TYPE_ID NUMBER(30) NOT NULL                                        
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_VAL_SOURCE_DATA_PK PRIMARY KEY (ID)                               
,CONSTRAINT A_SOU_ID_SOU_DATA_TYPE_UNQ UNIQUE(SOURCE_DATA_TYPE_ID,SOURCE_ID)    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VAL_SOURCE_DATA_TYPE                                           
create table A_VAL_SOURCE_DATA_TYPE(                                            
ID NUMBER(30) NOT NULL                                                          
,CODE_GROUP_ID NUMBER(30)                                                       
,SOURCE_TARGET_IMPL_CLASS VARCHAR2(255) NOT NULL                                
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_VAL_SOURCE_DATA_TYPES_PK PRIMARY KEY (ID)                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_VERSION                                                        
create table A_VERSION(                                                         
TIMESTAMP DATE NOT NULL                                                         
,VERSION VARCHAR2(255) NOT NULL                                                 
,DESCRIPTION VARCHAR2(4000)                                                     
,LOGFILE VARCHAR2(255)                                                          
,SOLUTION_VERSION VARCHAR2(255)                                                 
,CONSTRAINT A_VERSION_PK PRIMARY KEY (TIMESTAMP)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table CORE_LOG_TABLES                                                  
create table CORE_LOG_TABLES(                                                   
TABLE_NAME VARCHAR2(30) NOT NULL                                                
,COLUMN_NAME VARCHAR2(30)                                                       
,DAYS_TO_KEEP NUMBER(20)                                                        
,COMMIT_ROWS NUMBER(20)                                                         
,ORDER_SEQ NUMBER(5)                                                            
,CONSTRAINT CORE_LOG_TABLES_PK PRIMARY KEY (TABLE_NAME)                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_ALIAS_CATEGORY                                                 
create table D_ALIAS_CATEGORY(                                                  
CATEGORY_ID NUMBER(30) NOT NULL                                                 
,NAME VARCHAR2(255) NOT NULL                                                    
,CONSTRAINT PK_D_ALIAS_CATEGORY PRIMARY KEY (CATEGORY_ID)                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_ALIAS_DEF                                                      
create table D_ALIAS_DEF(                                                       
DEF_ID NUMBER(30) NOT NULL                                                      
,ACTUAL_NAME VARCHAR2(255) NOT NULL                                             
,FILE_NAME VARCHAR2(255) NOT NULL                                               
,OUT_PARAM NUMBER(30)                                                           
,CONSTRAINT PK_D_ALIAS_DEF PRIMARY KEY (DEF_ID)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_ALIAS_INFO                                                     
create table D_ALIAS_INFO(                                                      
INFO_ID NUMBER(30) NOT NULL                                                     
,NAME VARCHAR2(255) NOT NULL                                                    
,DESCRIPTION VARCHAR2(255)                                                      
,CATEGORY NUMBER(30) NOT NULL                                                   
,ALIAS_DEF NUMBER(30) NOT NULL                                                  
,CONSTRAINT PK_D_ALIAS_INFO PRIMARY KEY (INFO_ID)                               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_ALIAS_IN_PARAM                                                 
create table D_ALIAS_IN_PARAM(                                                  
IN_PARAM_ID NUMBER(30) NOT NULL                                                 
,NAME VARCHAR2(255) NOT NULL                                                    
,TYPE VARCHAR2(255) NOT NULL                                                    
,DESCRIPTION VARCHAR2(255)                                                      
,ALIAS_DEF NUMBER(30) NOT NULL                                                  
,CONSTRAINT PK_D_ALIAS_IN_PARAM PRIMARY KEY (IN_PARAM_ID)                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_ALIAS_OUT_PARAM                                                
create table D_ALIAS_OUT_PARAM(                                                 
OUT_PARAM_ID NUMBER(30) NOT NULL                                                
,TYPE VARCHAR2(255) NOT NULL                                                    
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT PK_D_ALIAS_OUT_PARAM PRIMARY KEY (OUT_PARAM_ID)                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_ALIAS                                                     
create table D_RULE_ALIAS(                                                      
RETURN_IS_VEC NUMBER(1) NOT NULL                                                
,IS_STATIC_FIELD NUMBER(1)                                                      
,MEMBER_NAME VARCHAR2(255) NOT NULL                                             
,ALIAS_NAME VARCHAR2(255) NOT NULL                                              
,UUID VARCHAR2(255)                                                             
,RETURN_TYPE_LOCATION_UUID VARCHAR2(255)                                        
,MEMBER_TYPE_LOCATION_UUID VARCHAR2(255)                                        
,ALIAS_ARGUMENT_UUID VARCHAR2(255)                                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ACCOUNT                                                        
create table A_ACCOUNT(                                                         
ID NUMBER(30) NOT NULL                                                          
,TYPE NUMBER(8)                                                                 
,NAME VARCHAR2(255) NOT NULL                                                    
,DESCRIPTION VARCHAR2(255)                                                      
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT A_ACCOUNT_PK PRIMARY KEY (ID)                                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ACCOUNT_ROLE                                                   
create table A_ACCOUNT_ROLE(                                                    
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,ROLE NUMBER(30) NOT NULL                                                       
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_ACCOUNT_ROLE_PK PRIMARY KEY (ID)                                  
,CONSTRAINT ACC_ROLE_UNQ UNIQUE(ACCOUNT_ID,ROLE)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ADDRESS                                                        
create table A_ADDRESS(                                                         
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,SYSTEM_MODE NUMBER(30) NOT NULL                                                
,PROTOCOL_ID NUMBER(8) NOT NULL                                                 
,IS_DYNAMIC NUMBER(1) NOT NULL                                                  
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT A_ADDRESS_PK PRIMARY KEY (ID)                                       
,CONSTRAINT A_ADDRESS_NAME_UNIQUE UNIQUE(NAME)                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ALERT                                                          
create table A_ALERT(                                                           
ID NUMBER(30) NOT NULL                                                          
,ALERT_ID NUMBER(30) NOT NULL                                                   
,MSG VARCHAR2(4000) NOT NULL                                                    
,TIME DATE NOT NULL                                                             
,SOURCE VARCHAR2(255) NOT NULL                                                  
,TYPE NUMBER(10) NOT NULL                                                       
,SEVERITY NUMBER(10) NOT NULL                                                   
,MORE VARCHAR2(4000)                                                            
,SERVER VARCHAR2(255) NOT NULL                                                  
,IP VARCHAR2(255) NOT NULL                                                      
,CONSTRAINT A_ALERT_PK PRIMARY KEY (ID)                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ALERT_EVENT                                                    
create table A_ALERT_EVENT(                                                     
ID NUMBER(30) NOT NULL                                                          
,TYPE NUMBER(10) NOT NULL                                                       
,EVENT_ID NUMBER(30) NOT NULL                                                   
,STATUS NUMBER(1) NOT NULL                                                      
,CONSTRAINT A_ALERT_EVENT_PK PRIMARY KEY (ID,TYPE)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ANOMALY_DETECTOR                                               
create table A_ANOMALY_DETECTOR(                                                
ID NUMBER(30) NOT NULL                                                          
,MESSAGE VARCHAR2(4000) NOT NULL                                                
,CLASS_NAME VARCHAR2(255) NOT NULL                                              
,CONSTRAINT A_ANOMALY_DETECTOR_PK PRIMARY KEY (ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_AUDIT                                                          
create table A_AUDIT(                                                           
ID NUMBER(30) NOT NULL                                                          
,DIRECTION NUMBER(30) NOT NULL                                                  
,PARTNER_ID NUMBER(30) NOT NULL                                                 
,AUDIT_TIME DATE NOT NULL                                                       
,UUID VARCHAR2(255) NOT NULL                                                    
,DATA_TYPE NUMBER(30) NOT NULL                                                  
,DATA BLOB NOT NULL                                                             
,CONSTRAINT A_AUDIT_PK PRIMARY KEY (ID,DIRECTION)                               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX AUDIT_UUID_INDEX ON A_AUDIT                                        
(UUID                                                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_AUTHORIZATION_RELATION                                         
create table A_AUTHORIZATION_RELATION(                                          
ID NUMBER(30) NOT NULL                                                          
,AUTHO_NAME VARCHAR2(255) NOT NULL                                              
,GROUP_ID NUMBER(30) NOT NULL                                                   
,SEQ NUMBER(30) NOT NULL                                                        
,COMPONENT_NAME VARCHAR2(255) NOT NULL                                          
,RELATION NUMBER(30)                                                            
,CONSTRAINT A_AUTHORIZATION_RELATION_PK PRIMARY KEY (AUTHO_NAME,GROUP_ID,SEQ)   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BATCH_ANSWERS                                                  
create table A_BATCH_ANSWERS(                                                   
UUID VARCHAR2(255) NOT NULL                                                     
,BATCH_NAME VARCHAR2(255) NOT NULL                                              
,INSERT_TIME DATE NOT NULL                                                      
,ANSWER NUMBER(30) NOT NULL                                                     
,MSG VARCHAR2(4000)                                                             
,CONSTRAINT A_BATCH_ANSWER_PK PRIMARY KEY (UUID)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BATCH_DATA                                                     
create table A_BATCH_DATA(                                                      
ID NUMBER(30) NOT NULL                                                          
,EVENT_ID NUMBER(30) NOT NULL                                                   
,ADDRESS_ID NUMBER(30) NOT NULL                                                 
,ADDITIONAL_REF VARCHAR2(255)                                                   
,REQUEST_TIME DATE NOT NULL                                                     
,EXEC_TIME DATE                                                                 
,STATUS NUMBER(8) NOT NULL                                                      
,STATUS_REASON VARCHAR2(4000)                                                   
,UID_TRIGGER VARCHAR2(255)                                                      
,UID_OUT VARCHAR2(255)                                                          
,UID_INSERT VARCHAR2(255) NOT NULL                                              
,BP_ID NUMBER(30) NOT NULL                                                      
,CONV_ID NUMBER(30) NOT NULL                                                    
,REPOSITORY VARCHAR2(255)                                                       
,BATCH_PARAM_ID NUMBER(30) NOT NULL                                             
,DATA_TYPE NUMBER(8) NOT NULL                                                   
,DATA BLOB NOT NULL                                                             
,CONSTRAINT A_BATCH_DATA_PK PRIMARY KEY (ID)                                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX BATCH_DATA_UUID_INSERT_INDEX ON A_BATCH_DATA                       
(UID_INSERT                                                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX BATCH_DATA_UUID_OUT_INDEX ON A_BATCH_DATA                          
(UID_OUT                                                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_BATCH_DATA_STATUS_INDEX ON A_BATCH_DATA                          
(STATUS                                                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_BATCH_DIRECT                                                   
create table A_BATCH_DIRECT(                                                    
DESCRIPTION VARCHAR2(255)                                                       
,EVENT_ID NUMBER(30) NOT NULL                                                   
,DIRECT_CLASS VARCHAR2(255) NOT NULL                                            
,BATCH_PARAM_ID NUMBER(30) NOT NULL                                             
,CONSTRAINT A_BATCH_DIRECT_PK PRIMARY KEY (BATCH_PARAM_ID)                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BATCH_PARAM                                                    
create table A_BATCH_PARAM(                                                     
ID NUMBER(30) NOT NULL                                                          
,REPORT_INTERVAL NUMBER(30) NOT NULL                                            
,NEXT_REPORT DATE NOT NULL                                                      
,DESCRIPTION VARCHAR2(255)                                                      
,DOMAIN_ID NUMBER(30) NOT NULL                                                  
,TYPE NUMBER(10) NOT NULL                                                       
,BASIC_STATUS NUMBER NOT NULL                                                   
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT A_BATCH_PARAM_PK PRIMARY KEY (ID)                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_ACCOUNT_2_TRADE                                        
create table A_BILLING_ACCOUNT_2_TRADE(                                         
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,TRADING_ACTIVITY_ID NUMBER(30) NOT NULL                                        
,CCY_PAIR_ID NUMBER(30) NOT NULL                                                
,STATUS NUMBER(1) NOT NULL                                                      
,CONSTRAINT A_BILLING_ACCOUNT_2_TRADE_PK PRIMARY KEY (ID)                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_BCM_LINE                                               
create table A_BILLING_BCM_LINE(                                                
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,STATUS NUMBER(1) NOT NULL                                                      
,PROJECT_NAME VARCHAR2(255) NOT NULL                                            
,RULE_NAME VARCHAR2(255) NOT NULL                                               
,RULE_TYPE NUMBER(10) NOT NULL                                                  
,PRODUCT_TYPE NUMBER(30) NOT NULL                                               
,CONSTRAINT A_BILLING_BCM_LINE_PK PRIMARY KEY (ID)                              
,CONSTRAINT BCM_LINE_NAME_UNIQUE UNIQUE(NAME)                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_BCM_RESPONSE                                           
create table A_BILLING_BCM_RESPONSE(                                            
ID NUMBER(30) NOT NULL                                                          
,BILLING_RESPONSE_ID NUMBER(30) NOT NULL                                        
,BILLING_BCM_DEF_ID NUMBER(30) NOT NULL                                         
,BILLING_REQUEST_ID NUMBER(30) NOT NULL                                         
,BILLING_FEE_TRACKING_ID NUMBER(30) NOT NULL                                    
,CONSTRAINT A_BILLING_BCM_RESPONSE_PK PRIMARY KEY (ID)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_BOI                                                    
create table A_BILLING_BOI(                                                     
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,RULE_TYPE NUMBER(8) NOT NULL                                                   
,REQUEST_TYPE NUMBER(8) NOT NULL                                                
,STATUS NUMBER(1) NOT NULL                                                      
,TRADING_ACTIVITY_ID NUMBER(30) NOT NULL                                        
,BILLING_REQUEST_ID NUMBER(30) NOT NULL                                         
,COMBINATION_ID NUMBER(30) NOT NULL                                             
,COMBINATION_NAME VARCHAR2(255) NOT NULL                                        
,CCY_PAIR_ID NUMBER(30) NOT NULL                                                
,MARKET_SOURCE_ID NUMBER(10) NOT NULL                                           
,BASE_CURRENCY_SPOT_RATE NUMBER(30,10) NOT NULL                                 
,PRODUCT_TYPE NUMBER(30) NOT NULL                                               
,IS_EXERCISE NUMBER(1)                                                          
,IS_SWAP NUMBER(1)                                                              
,IS_DIRECT NUMBER(1)                                                            
,IS_FIXING NUMBER(1)                                                            
,CONSTRAINT A_BILLING_BOI_PK PRIMARY KEY (ID)                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_CCY_PAIR                                               
create table A_BILLING_CCY_PAIR(                                                
ID NUMBER(30) NOT NULL                                                          
,RATE_FACTOR NUMBER(30,10)                                                      
,FIRST_CCY_ID NUMBER(30) NOT NULL                                               
,SECOND_CCY_ID NUMBER(30) NOT NULL                                              
,RATE_DIRECTION NUMBER(1)                                                       
,AMT_PLACES NUMBER(10)                                                          
,CCY_PAIR VARCHAR2(255) NOT NULL                                                
,INVERSE_AMT_PLACES NUMBER(10)                                                  
,SPOT_LAG NUMBER(8) NOT NULL                                                    
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT A_BILLING_CCY_PAIR_PK PRIMARY KEY (ID)                              
,CONSTRAINT AR_BIL_CCY_PAI_CCY_ID_UK UNIQUE(SECOND_CCY_ID,FIRST_CCY_ID)         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_CCY_PAIR_2_FIN_CNTR                                    
create table A_BILLING_CCY_PAIR_2_FIN_CNTR(                                     
ID NUMBER(30) NOT NULL                                                          
,CCY_PAIR_ID NUMBER(30) NOT NULL                                                
,FINANCIAL_CENTER_ID NUMBER(30) NOT NULL                                        
,CONSTRAINT A_BLNG_CCYPAIR_2_FIN_CNTR_PK PRIMARY KEY (ID)                       
,CONSTRAINT A_BLNG_CCY_PAIR_2_FIN_CNTR_UNQ                                      
UNIQUE(FINANCIAL_CENTER_ID,CCY_PAIR_ID)                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_CCY_PAIR_DISCOUNT                                      
create table A_BILLING_CCY_PAIR_DISCOUNT(                                       
ID NUMBER(30) NOT NULL                                                          
,CCY_PAIR_ID NUMBER(30)                                                         
,RULE_LINE_ID NUMBER(30)                                                        
,IS_DEFAULT NUMBER(1)                                                           
,STATUS NUMBER(10)                                                              
,DISCOUNT_TYPE NUMBER(10)                                                       
,IS_OVERALL NUMBER(1)                                                           
,MIN_VOLUME NUMBER(30,10)                                                       
,MAX_VOLUME NUMBER(30,10)                                                       
,DISCOUNT NUMBER(30,10)                                                         
,CONSTRAINT A_BILLING_CCY_PAIR_DISCOUNT_PK PRIMARY KEY (ID)                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_COMB_2_ACCOUNT                                         
create table A_BILLING_COMB_2_ACCOUNT(                                          
ID NUMBER(30) NOT NULL                                                          
,COMBINATION_ID NUMBER(30)                                                      
,ACCOUNT_ID NUMBER(30)                                                          
,CONSTRAINT A_BILLING_COMB_2_ACCOUNT_PK PRIMARY KEY (ID)                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_COMB_2_LINE                                            
create table A_BILLING_COMB_2_LINE(                                             
ID NUMBER(30) NOT NULL                                                          
,COMBINATION_ID NUMBER(30)                                                      
,BILLING_LINE_ID NUMBER(30)                                                     
,CONSTRAINT A_BILLING_COMB_2_LINE_PK PRIMARY KEY (ID)                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_FEE_TRACKING                                           
create table A_BILLING_FEE_TRACKING(                                            
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,CCY_PAIR_ID NUMBER(30)                                                         
,LINE_ID NUMBER(30)                                                             
,COMBINATION_ID NUMBER(30)                                                      
,COMBINATION_NAME VARCHAR2(255)                                                 
,TRADING_ACTIVITY_ID NUMBER(30)                                                 
,PRODUCT_TYPE NUMBER(30) NOT NULL                                               
,STATUS NUMBER(1) NOT NULL                                                      
,FEE_STATUS NUMBER(10) NOT NULL                                                 
,ORIGINAL_SPOT_RATE NUMBER(30,10)                                               
,ORIGINAL_CURRENCY NUMBER(30)                                                   
,ACCOUNT_SPOT_RATE NUMBER(30,10)                                                
,BASE_CURRENCY_FEE NUMBER(30,10)                                                
,SOLUTION_FEE NUMBER(30,10) NOT NULL                                            
,ACCOUNT_FEE NUMBER(30,10)                                                      
,FEE_CREATION_TIME DATE NOT NULL                                                
,BILLING_RESPONSE_ID NUMBER(30)                                                 
,BILLING_REQUEST_ID NUMBER(30)                                                  
,BILLING_BOI_ID NUMBER(30)                                                      
,MANUAL_DESCRIPTION VARCHAR2(255)                                               
,IS_SWAP NUMBER(1)                                                              
,CONSTRAINT A_BILLING_FEE_TRACKING_PK PRIMARY KEY (ID)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_FIX_DISCOUNT                                           
create table A_BILLING_FIX_DISCOUNT(                                            
ID NUMBER(30) NOT NULL                                                          
,RULE_LINE_ID NUMBER(30)                                                        
,IS_DEFAULT NUMBER(1)                                                           
,STATUS NUMBER(10)                                                              
,DISCOUNT_TYPE NUMBER(10)                                                       
,DISCOUNT NUMBER(30,10)                                                         
,CONSTRAINT A_BILLING_FIX_DISCOUNT_PK PRIMARY KEY (ID)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_FLAT_FEE_BCM                                           
create table A_BILLING_FLAT_FEE_BCM(                                            
ID NUMBER(30) NOT NULL                                                          
,BCM_LINE_ID NUMBER(30)                                                         
,IS_DEFAULT NUMBER(1)                                                           
,STATUS NUMBER(10)                                                              
,FLAT_FEE NUMBER(30,10)                                                         
,CONSTRAINT A_BILLING_FLAT_FEE_BCM_PK PRIMARY KEY (ID)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_LINE                                                   
create table A_BILLING_LINE(                                                    
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,DESCRIPTION VARCHAR2(255)                                                      
,LINE_ID NUMBER(30) NOT NULL                                                    
,BCM_LINE_ID NUMBER(30)                                                         
,RULE_LINE_ID NUMBER(30)                                                        
,STATUS NUMBER(1) NOT NULL                                                      
,CONSTRAINT A_BILLING_LINE_PK PRIMARY KEY (ID)                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_MIN_LIMITS                                             
create table A_BILLING_MIN_LIMITS(                                              
ID NUMBER(30) NOT NULL                                                          
,RULE_LINE_ID NUMBER(30)                                                        
,IS_DEFAULT NUMBER(1)                                                           
,STATUS NUMBER(10)                                                              
,LIMIT_TYPE NUMBER(10)                                                          
,MIN_AMOUNT NUMBER(30,10)                                                       
,FEE NUMBER(30,10)                                                              
,CONSTRAINT A_BILLING_MIN_LIMITS_PK PRIMARY KEY (ID)                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_PER_MILLION_BCM                                        
create table A_BILLING_PER_MILLION_BCM(                                         
ID NUMBER(30) NOT NULL                                                          
,BCM_LINE_ID NUMBER(30)                                                         
,CCY_PAIR_ID NUMBER(30)                                                         
,PRODUCT_TYPE NUMBER(30)                                                        
,IS_DEFAULT NUMBER(1)                                                           
,STATUS NUMBER(10)                                                              
,PER_MILLION NUMBER(30,10)                                                      
,PER_MILLION_CCY NUMBER(30)                                                     
,CONSTRAINT A_BILLING_PER_MILLION_BCM_PK PRIMARY KEY (ID)                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_REQUEST                                                
create table A_BILLING_REQUEST(                                                 
ID NUMBER(30) NOT NULL                                                          
,LINE_SEQ_ID NUMBER(30) NOT NULL                                                
,LINE_ID NUMBER(30) NOT NULL                                                    
,RULE_NAME VARCHAR2(255) NOT NULL                                               
,REQUEST_TYPE NUMBER(8) NOT NULL                                                
,PROJECT_NAME VARCHAR2(255) NOT NULL                                            
,RULE_EXECUTION_TYPE NUMBER(8) NOT NULL                                         
,ORDER_SEQUENCE NUMBER(30) NOT NULL                                             
,STATUS NUMBER(1) NOT NULL                                                      
,UPDATE_TIME DATE                                                               
,RULE_TYPE NUMBER(8) NOT NULL                                                   
,CONSTRAINT A_BILLING_REQUEST_PK PRIMARY KEY (ID)                               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_RESPONSE                                               
create table A_BILLING_RESPONSE(                                                
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,TRADING_ACTIVITY_ID NUMBER(30)                                                 
,BILLING_DATE DATE NOT NULL                                                     
,UUID VARCHAR2(255) NOT NULL                                                    
,TRIGGER_TYPE NUMBER(8) NOT NULL                                                
,CONSTRAINT A_BILLING_RESPONSE_PK PRIMARY KEY (ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_RULE_DEFAULT                                           
create table A_BILLING_RULE_DEFAULT(                                            
ID NUMBER(30) NOT NULL                                                          
,RULE_NAME VARCHAR2(255) NOT NULL                                               
,REQUEST_TYPE NUMBER(8) NOT NULL                                                
,PROJECT_NAME VARCHAR2(255) NOT NULL                                            
,CONSTRAINT A_BILLING_RULE_DEFAULT_PK PRIMARY KEY (ID)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_RULE_LINE                                              
create table A_BILLING_RULE_LINE(                                               
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,STATUS NUMBER(1) NOT NULL                                                      
,PROJECT_NAME VARCHAR2(255) NOT NULL                                            
,RULE_NAME VARCHAR2(255) NOT NULL                                               
,RULE_TYPE NUMBER(10) NOT NULL                                                  
,PRODUCT_TYPE NUMBER(30) NOT NULL                                               
,CONSTRAINT A_BILLING_RULE_LINE_PK PRIMARY KEY (ID)                             
,CONSTRAINT RULE_LINE_NAME_UNIQUE UNIQUE(NAME)                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_RULE_RESPONSE                                          
create table A_BILLING_RULE_RESPONSE(                                           
ID NUMBER(30) NOT NULL                                                          
,BILLING_RESPONSE_ID NUMBER(30) NOT NULL                                        
,BILLING_RULE_DEF_ID NUMBER(30) NOT NULL                                        
,BILLING_REQUEST_ID NUMBER(30) NOT NULL                                         
,BILLING_FEE_TRACKING_ID NUMBER(30) NOT NULL                                    
,CONSTRAINT A_BILLING_RULE_RESPONSE_PK PRIMARY KEY (ID)                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_SPREAD_BCM                                             
create table A_BILLING_SPREAD_BCM(                                              
ID NUMBER(30) NOT NULL                                                          
,BCM_LINE_ID NUMBER(30)                                                         
,CCY_PAIR_ID NUMBER(30)                                                         
,PRODUCT_TYPE NUMBER(30)                                                        
,IS_DEFAULT NUMBER(1)                                                           
,STATUS NUMBER(10)                                                              
,SPREAD NUMBER(30,10)                                                           
,CONSTRAINT A_BILLING_SPREAD_BCM_PK PRIMARY KEY (ID)                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_TRACKING                                               
create table A_BILLING_TRACKING(                                                
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,LINE_ID NUMBER(30) NOT NULL                                                    
,STATUS NUMBER(10) NOT NULL                                                     
,CONSTRAINT A_BILLING_TRACKING_PK PRIMARY KEY (ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BILLING_TRADE_DISCOUNT                                         
create table A_BILLING_TRADE_DISCOUNT(                                          
ID NUMBER(30) NOT NULL                                                          
,RULE_LINE_ID NUMBER(30)                                                        
,IS_DEFAULT NUMBER(1)                                                           
,STATUS NUMBER(10)                                                              
,DISCOUNT_TYPE NUMBER(10)                                                       
,IS_OVERALL NUMBER(1)                                                           
,MIN_VOLUME NUMBER(30,10)                                                       
,MAX_VOLUME NUMBER(30,10)                                                       
,DISCOUNT NUMBER(30,10)                                                         
,CONSTRAINT A_BILLING_TRADE_DISCOUNT_PK PRIMARY KEY (ID)                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_BUSINESS_PROCESS                                               
create table A_BUSINESS_PROCESS(                                                
ID NUMBER(30) NOT NULL                                                          
,START_TIME DATE NOT NULL                                                       
,END_TIME DATE                                                                  
,INITIATOR_ID NUMBER(30) NOT NULL                                               
,INITIATOR_TYPE NUMBER(30) NOT NULL                                             
,LOGIC_MSG_ID NUMBER(30) NOT NULL                                               
,STATUS NUMBER(8) NOT NULL                                                      
,STATUS_REASON VARCHAR2(255)                                                    
,CONSTRAINT A_BUSINESS_PROCESS_PK PRIMARY KEY (ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CALENDAR_CENTER                                                
create table A_CALENDAR_CENTER(                                                 
ID NUMBER(30) NOT NULL                                                          
,CODE VARCHAR2(255)                                                             
,CENTER VARCHAR2(255) NOT NULL                                                  
,COUNTRY VARCHAR2(255)                                                          
,TYPE VARCHAR2(255)                                                             
,LAST_UPDATE_DATE DATE                                                          
,CONSTRAINT A_CALENDAR_CENTER_PK PRIMARY KEY (ID)                               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CALENDAR_HOLIDAY                                               
create table A_CALENDAR_HOLIDAY(                                                
ID NUMBER(30) NOT NULL                                                          
,HOLIDAY_DATE DATE NOT NULL                                                     
,CENTER_ID NUMBER(30) NOT NULL                                                  
,TYPE_ID NUMBER(30) NOT NULL                                                    
,FINCAD_DATE NUMBER(30)                                                         
,CONSTRAINT A_CALENDAR_HOLIDAY_PK PRIMARY KEY (ID)                              
,CONSTRAINT A_CALEN_HOLI_DATE_CE_UNIQ UNIQUE(CENTER_ID,HOLIDAY_DATE)            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CALENDAR_HOLIDAY_TYPE                                          
create table A_CALENDAR_HOLIDAY_TYPE(                                           
ID NUMBER(30) NOT NULL                                                          
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_CALENDAR_HOLIDAY_TYPE_ID PRIMARY KEY (ID)                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CASHFLOW                                                       
create table A_CASHFLOW(                                                        
ID NUMBER(30) NOT NULL                                                          
,LINK_TYPE NUMBER(8) NOT NULL                                                   
,TYPE NUMBER(8) NOT NULL                                                        
,ITEM_ID NUMBER(30) NOT NULL                                                    
,CURRENCY_ID NUMBER(8) NOT NULL                                                 
,AMOUNT NUMBER(30,10)                                                           
,TRADE_LEG_ID NUMBER(1)                                                         
,START_DATE DATE                                                                
,END_DATE DATE                                                                  
,PAY_DATE DATE                                                                  
,RESET_DATE DATE                                                                
,FIXING_RATE NUMBER(30,10)                                                      
,FIXING_INDEX NUMBER(8)                                                         
,SPREAD NUMBER(30,10)                                                           
,FACTOR NUMBER(30,10)                                                           
,NOTIONAL NUMBER(30,10)                                                         
,RATE NUMBER(30,10)                                                             
,CUSTOM_FLAG NUMBER(1) NOT NULL                                                 
,PROCESSING_STATE NUMBER(8) NOT NULL                                            
,LIFE_CYCLE NUMBER(30) NOT NULL                                                 
,CONSTRAINT PK_A_CASHFLOW PRIMARY KEY (ID)                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CASHFLOW_GEN_MAP                                               
create table A_CASHFLOW_GEN_MAP(                                                
ID NUMBER(30) NOT NULL                                                          
,LINK_TYPE NUMBER(8) NOT NULL                                                   
,ITEM_TYPE_ID NUMBER(30) NOT NULL                                               
,GENERATOR_CLASS_NAME VARCHAR2(255) NOT NULL                                    
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT PK_A_CASHFLOW_GEN_MAP PRIMARY KEY (ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CODE_GROUP                                                     
create table A_CODE_GROUP(                                                      
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,STATUS NUMBER(10) NOT NULL                                                     
,ATTR NUMBER(30) NOT NULL                                                       
,SOURCE VARCHAR2(255)                                                           
,SOLUTION_NAME VARCHAR2(255) NOT NULL                                           
,GROUP_COMMENT VARCHAR2(255)                                                    
,KEYS_DATA_TYPE VARCHAR2(255) NOT NULL                                          
,VALUES_DATA_TYPE VARCHAR2(255) NOT NULL                                        
,CONSTRAINT A_CODE_GROUP_PK PRIMARY KEY (ID)                                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CODE_MEMBER                                                    
create table A_CODE_MEMBER(                                                     
GROUP_ID NUMBER(30) NOT NULL                                                    
,CODE_KEY VARCHAR2(255) NOT NULL                                                
,DATA VARCHAR2(255) NOT NULL                                                    
,NAME VARCHAR2(255) NOT NULL                                                    
,CODE_COMMENT VARCHAR2(255)                                                     
,STATUS NUMBER(10) NOT NULL                                                     
,CONSTRAINT A_CODE_MEMBER_PK PRIMARY KEY (GROUP_ID,CODE_KEY)                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CONVERSATION                                                   
create table A_CONVERSATION(                                                    
ID NUMBER(30) NOT NULL                                                          
,BUSINESS_PROCESS_ID NUMBER(30) NOT NULL                                        
,START_TIME DATE NOT NULL                                                       
,END_TIME DATE                                                                  
,INITIATOR_ID NUMBER(30) NOT NULL                                               
,INITIATOR_TYPE NUMBER(30) NOT NULL                                             
,STATUS NUMBER(8) NOT NULL                                                      
,STATUS_REASON VARCHAR2(255)                                                    
,CONSTRAINT A_CONVERSATION_PK PRIMARY KEY (ID)                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_DB                                                         
create table A_CON_DB(                                                          
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,HOOK_CLASS VARCHAR2(255) NOT NULL                                              
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_CON_DB_PK PRIMARY KEY (ADDRESS_ID)                                
,CONSTRAINT A_CON_DB_ADDRESS_UNIQUE UNIQUE(HOOK_CLASS)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_DIR_IN                                                     
create table A_CON_DIR_IN(                                                      
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,DIRECTORY VARCHAR2(255) NOT NULL                                               
,HOOK_CLASS VARCHAR2(255)                                                       
,DATA_MODE NUMBER(1) NOT NULL                                                   
,TIME_IN_QUEUE NUMBER(30) NOT NULL                                              
,CONSTRAINT A_CON_DIR_IN_PK PRIMARY KEY (ADDRESS_ID)                            
,CONSTRAINT A_DIR_IN_ADDRESS_UNIQUE UNIQUE(DIRECTORY)                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_DIR_OUT                                                    
create table A_CON_DIR_OUT(                                                     
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,DIRECTORY VARCHAR2(255) NOT NULL                                               
,FILE_NAME VARCHAR2(255)                                                        
,HOOK_CLASS VARCHAR2(255)                                                       
,RENAME_INTERVAL NUMBER(10)                                                     
,RENAME_NEEDED NUMBER(1) NOT NULL                                               
,CONSTRAINT A_CON_DIR_OUT_PK PRIMARY KEY (ADDRESS_ID)                           
,CONSTRAINT A_DIR_OUT_ADDRESS_UNIQUE UNIQUE(DIRECTORY,FILE_NAME)                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_FTP_IN                                                     
create table A_CON_FTP_IN(                                                      
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,SERVER VARCHAR2(255) NOT NULL                                                  
,PORT NUMBER(8)                                                                 
,USER_NAME VARCHAR2(255) NOT NULL                                               
,PASSWORD VARCHAR2(255) NOT NULL                                                
,DIRECTORY VARCHAR2(255)                                                        
,FILE_NAME VARCHAR2(255)                                                        
,HOOK_CLASS VARCHAR2(255)                                                       
,DATA_MODE NUMBER(1) NOT NULL                                                   
,TIME_IN_QUEUE NUMBER(30) NOT NULL                                              
,CONSTRAINT A_CON_FTP_IN_PK PRIMARY KEY (ADDRESS_ID)                            
,CONSTRAINT A_FTP_IN_ADDRESS_UNIQUE                                             
UNIQUE(SERVER,USER_NAME,PASSWORD,DIRECTORY,FILE_NAME)                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_FTP_OUT                                                    
create table A_CON_FTP_OUT(                                                     
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,SERVER VARCHAR2(255) NOT NULL                                                  
,PORT NUMBER(8)                                                                 
,USER_NAME VARCHAR2(255) NOT NULL                                               
,PASSWORD VARCHAR2(255) NOT NULL                                                
,DIRECTORY VARCHAR2(255)                                                        
,FILE_NAME VARCHAR2(255) NOT NULL                                               
,HOOK_CLASS VARCHAR2(255)                                                       
,CONSTRAINT A_CON_FTP_OUT_PK PRIMARY KEY (ADDRESS_ID)                           
,CONSTRAINT A_FTP_OUT_ADDRESS_UNIQUE                                            
UNIQUE(SERVER,USER_NAME,PASSWORD,DIRECTORY,FILE_NAME)                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_HEADER_DATA                                                
create table A_CON_HEADER_DATA(                                                 
ID NUMBER(30) NOT NULL                                                          
,PARTNER_ID NUMBER(30) NOT NULL                                                 
,ADDITIONAL_REF VARCHAR2(255) NOT NULL                                          
,INSERT_UUID VARCHAR2(255) NOT NULL                                             
,HEADER_DATA VARCHAR2(255) NOT NULL                                             
,CONSTRAINT A_CON_HEADER_DATA_PK PRIMARY KEY (ID)                               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_HTTP_OUT                                                   
create table A_CON_HTTP_OUT(                                                    
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,URL VARCHAR2(255) NOT NULL                                                     
,CONSTRAINT A_CON_HTTP_OUT_PK PRIMARY KEY (ADDRESS_ID)                          
,CONSTRAINT A_HTTP_OUT_ADDRESS_UNIQUE UNIQUE(URL)                               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_JMS_IN                                                     
create table A_CON_JMS_IN(                                                      
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,SERVER_URL VARCHAR2(255) NOT NULL                                              
,SERVER_PORT NUMBER(8) NOT NULL                                                 
,SERVER_PROTOCOL VARCHAR2(255) NOT NULL                                         
,FACTORY_JNDI_NAME VARCHAR2(255)                                                
,JNDI_NAME VARCHAR2(255) NOT NULL                                               
,DEST_TYPE NUMBER(8) NOT NULL                                                   
,IS_DURABLE NUMBER(1) NOT NULL                                                  
,LISTENER_MAX_NUMBER NUMBER(30) NOT NULL                                        
,LISTENER_NAME VARCHAR2(255)                                                    
,DURABLE_SUBSCRIBER_NAME VARCHAR2(255)                                          
,FILTER VARCHAR2(255)                                                           
,TXN_EXIST NUMBER(1) NOT NULL                                                   
,DATA_MODE NUMBER(1) NOT NULL                                                   
,CONSTRAINT A_CON_JMS_IN_PK PRIMARY KEY (ADDRESS_ID)                            
,CONSTRAINT A_JMS_IN_ADDRESS_UNIQUE UNIQUE(DURABLE_SUBSCRIBER_NAME)             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_JMS_OUT                                                    
create table A_CON_JMS_OUT(                                                     
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,SERVER_URL VARCHAR2(255) NOT NULL                                              
,SERVER_PORT NUMBER(8) NOT NULL                                                 
,SERVER_PROTOCOL VARCHAR2(255) NOT NULL                                         
,FACTORY_JNDI_NAME VARCHAR2(255)                                                
,JNDI_NAME VARCHAR2(255) NOT NULL                                               
,DEST_TYPE NUMBER(8) NOT NULL                                                   
,IS_PERSISTANT NUMBER(1) NOT NULL                                               
,TTL NUMBER(30) NOT NULL                                                        
,FILTER VARCHAR2(255)                                                           
,TXN_EXIST NUMBER(1) NOT NULL                                                   
,DATA_MODE NUMBER(1) NOT NULL                                                   
,CONSTRAINT A_CON_JMS_OUT_PK PRIMARY KEY (ADDRESS_ID)                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_MAIL_IN                                                    
create table A_CON_MAIL_IN(                                                     
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,SERVER VARCHAR2(255) NOT NULL                                                  
,USER_NAME VARCHAR2(255) NOT NULL                                               
,PASSWORD VARCHAR2(255) NOT NULL                                                
,USE_ATTACHMENT NUMBER(1) NOT NULL                                              
,DECODER_CLASS VARCHAR2(255)                                                    
,HOOK_CLASS VARCHAR2(255)                                                       
,DATA_MODE NUMBER(1) NOT NULL                                                   
,TIME_IN_QUEUE NUMBER(30) NOT NULL                                              
,CONSTRAINT A_CON_MAIL_IN_PK PRIMARY KEY (ADDRESS_ID)                           
,CONSTRAINT A_MAIL_IN_ADDRESS_UNIQUE UNIQUE(SERVER,USER_NAME,PASSWORD)          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_MAIL_OUT                                                   
create table A_CON_MAIL_OUT(                                                    
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,SERVER VARCHAR2(255)                                                           
,MAIL_RECIPIENTS VARCHAR2(255) NOT NULL                                         
,SUBJECT VARCHAR2(255) NOT NULL                                                 
,MAIL_FROM VARCHAR2(255) NOT NULL                                               
,ATTACHMENT VARCHAR2(255)                                                       
,HOOK_CLASS VARCHAR2(255)                                                       
,RECIPIENT_TYPE NUMBER(8)                                                       
,CONSTRAINT A_CON_MAIL_OUT_PK PRIMARY KEY (ADDRESS_ID)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_MQ_IN                                                      
create table A_CON_MQ_IN(                                                       
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,SERVER VARCHAR2(255) NOT NULL                                                  
,PORT NUMBER(30) NOT NULL                                                       
,CHANNEL VARCHAR2(255)                                                          
,QUEUE_NAME VARCHAR2(255) NOT NULL                                              
,QUEUE_MANAGER VARCHAR2(255) NOT NULL                                           
,LISTENER_MAX_NUMBER NUMBER(30) NOT NULL                                        
,LISTENER_CLASS VARCHAR2(255)                                                   
,TIME_IN_QUEUE NUMBER(30) NOT NULL                                              
,CONSTRAINT A_CON_MQ_IN_PK PRIMARY KEY (ADDRESS_ID)                             
,CONSTRAINT A_MQ_IN_ADDRESS_UNIQUE                                              
UNIQUE(SERVER,CHANNEL,QUEUE_NAME,QUEUE_MANAGER)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_MQ_OUT                                                     
create table A_CON_MQ_OUT(                                                      
ADDRESS_ID NUMBER(30) NOT NULL                                                  
,SERVER VARCHAR2(255) NOT NULL                                                  
,PORT NUMBER(30) NOT NULL                                                       
,CHANNEL VARCHAR2(255)                                                          
,QUEUE_NAME VARCHAR2(255) NOT NULL                                              
,QUEUE_MANAGER VARCHAR2(255) NOT NULL                                           
,CONSTRAINT A_CON_MQ_OUT_PK PRIMARY KEY (ADDRESS_ID)                            
,CONSTRAINT A_MQ_OUT_ADDRESS_UNIQUE                                             
UNIQUE(SERVER,CHANNEL,QUEUE_NAME,QUEUE_MANAGER)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CON_PROTOCOLS                                                  
create table A_CON_PROTOCOLS(                                                   
ID NUMBER(30) NOT NULL                                                          
,TRANSPORT_ID NUMBER(8) NOT NULL                                                
,INVOCATION_TYPE NUMBER(8) NOT NULL                                             
,IMPL_CLASS VARCHAR2(255)                                                       
,SERVICE_CLASS VARCHAR2(255)                                                    
,ACTIVATION_CLASS VARCHAR2(255)                                                 
,MONITOR_LOADER_CLASS VARCHAR2(255)                                             
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,BULK_SIZE NUMBER(8) NOT NULL                                                   
,CONSTRAINT A_CON_PROTOCOLS_DEF_PK PRIMARY KEY (ID)                             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CREDIT_ACCOUNT                                                 
create table A_CREDIT_ACCOUNT(                                                  
ID NUMBER(30) NOT NULL                                                          
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,UCM_ID NUMBER(30) NOT NULL                                                     
,CREDIT_LINE_ID NUMBER(30) NOT NULL                                             
,LIMIT NUMBER(30,10) NOT NULL                                                   
,REQUEST_TYPE NUMBER(8) NOT NULL                                                
,POSITION_TYPE NUMBER(8) NOT NULL                                               
,POSITION_BASIS NUMBER(8) NOT NULL                                              
,NAME VARCHAR2(255) NOT NULL                                                    
,POSITION_CALL NUMBER(8) NOT NULL                                               
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT A_CREDIT_ACCOUNT_PK PRIMARY KEY (ID)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE UNIQUE INDEX A_CREDIT_ACCOUNT_UIDX ON A_CREDIT_ACCOUNT                   
(ACCOUNT_ID                                                                     
,CREDIT_LINE_ID                                                                 
,POSITION_TYPE                                                                  
,REQUEST_TYPE                                                                   
,POSITION_BASIS                                                                 
,UCM_ID                                                                         
,POSITION_CALL                                                                  
,BASIC_STATUS                                                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_CREDIT_LINE                                                    
create table A_CREDIT_LINE(                                                     
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,TYPE NUMBER(8) NOT NULL                                                        
,DESCRIPTION VARCHAR2(255)                                                      
,IMPL_CLASS VARCHAR2(255) NOT NULL                                              
,CONSTRAINT A_CREDIT_LINE_PK PRIMARY KEY (ID)                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CREDIT_LINE_2_UCM                                              
create table A_CREDIT_LINE_2_UCM(                                               
ID NUMBER(30) NOT NULL                                                          
,CREDIT_LINE_ID NUMBER(30) NOT NULL                                             
,UCM_ID NUMBER(30) NOT NULL                                                     
,CONSTRAINT A_CREDIT_LINE_2_UCM_PK PRIMARY KEY (ID)                             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CREDIT_POS_BASIS_2_UCM                                         
create table A_CREDIT_POS_BASIS_2_UCM(                                          
ID NUMBER(30) NOT NULL                                                          
,POSITION_BASIS NUMBER(8) NOT NULL                                              
,UCM_ID NUMBER(30) NOT NULL                                                     
,CONSTRAINT A_CREDIT_POS_BASIS_2_UCM_PK PRIMARY KEY (ID)                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CREDIT_POS_CALL_2_POS_COM                                      
create table A_CREDIT_POS_CALL_2_POS_COM(                                       
ID NUMBER(30) NOT NULL                                                          
,POSITION_CALL NUMBER(8) NOT NULL                                               
,POSITION_COMBINATION NUMBER(8) NOT NULL                                        
,CONSTRAINT A_CREDIT_POS_CALL_2_POS_PK PRIMARY KEY (ID)                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CREDIT_POS_CALL_2_UCM                                          
create table A_CREDIT_POS_CALL_2_UCM(                                           
ID NUMBER(30) NOT NULL                                                          
,POSITION_CALL NUMBER(8) NOT NULL                                               
,UCM_ID NUMBER(30) NOT NULL                                                     
,CONSTRAINT A_CREDIT_POS_CALL_2_UCM_PK PRIMARY KEY (ID)                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CREDIT_RESULTS                                                 
create table A_CREDIT_RESULTS(                                                  
ID NUMBER(30) NOT NULL                                                          
,CURRENT_EXPOSURE NUMBER(30,10) NOT NULL                                        
,UTILIZATION_PERCENT NUMBER(30,10) NOT NULL                                     
,CALC_DATE DATE NOT NULL                                                        
,RESPONSE NUMBER(8)                                                             
,CONSTRAINT A_CREDIT_RESULTS_PK PRIMARY KEY (ID)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CREDIT_RESULTS_HISTORY                                         
create table A_CREDIT_RESULTS_HISTORY(                                          
ID NUMBER(30) NOT NULL                                                          
,CURRENT_EXPOSURE NUMBER(30,10) NOT NULL                                        
,UTILIZATION_PERCENT NUMBER(30,10) NOT NULL                                     
,CALC_DATE DATE NOT NULL                                                        
,RESPONSE NUMBER(8)                                                             
,CREDIT_ACCOUNT_ID NUMBER(30) NOT NULL                                          
,CONSTRAINT A_CREDIT_RESULTS_HISTORY_PK PRIMARY KEY (ID)                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_CREDIT_UCM                                                     
create table A_CREDIT_UCM(                                                      
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,DESCRIPTION VARCHAR2(255) NOT NULL                                             
,IMPL_CLASS VARCHAR2(255) NOT NULL                                              
,UNIT VARCHAR2(255) NOT NULL                                                    
,TYPE NUMBER(8)                                                                 
,CONSTRAINT A_CREDIT_UCM_PK PRIMARY KEY (ID)                                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_DATA_MAPPING                                                   
create table A_DATA_MAPPING(                                                    
ID NUMBER(30) NOT NULL                                                          
,NAMER_ID NUMBER(30) NOT NULL                                                   
,MAP_TYPE NUMBER(30) NOT NULL                                                   
,EXTERNAL_VALUE VARCHAR2(255) NOT NULL                                          
,INTERNAL_VALUE NUMBER(30) NOT NULL                                             
,TYPE_IN NUMBER(30) NOT NULL                                                    
,TYPE_OUT NUMBER(30) NOT NULL                                                   
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT A_DATA_MAPPING_PK PRIMARY KEY (ID)                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE UNIQUE INDEX A_DATA_MAPPING_UIDX1 ON A_DATA_MAPPING                      
(EXTERNAL_VALUE                                                                 
,MAP_TYPE                                                                       
,NAMER_ID                                                                       
,TYPE_IN                                                                        
,BASIC_STATUS                                                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE UNIQUE INDEX A_DATA_MAPPING_UIDX2 ON A_DATA_MAPPING                      
(INTERNAL_VALUE                                                                 
,MAP_TYPE                                                                       
,NAMER_ID                                                                       
,TYPE_OUT                                                                       
,BASIC_STATUS                                                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_DL                                                             
create table A_DL(                                                              
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,IS_GLOBAL NUMBER(1) NOT NULL                                                   
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_DL_PK PRIMARY KEY (ID)                                            
,CONSTRAINT A_DL_NAME_UNIQ UNIQUE(NAME)                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_DL_DETAIL                                                      
create table A_DL_DETAIL(                                                       
ID NUMBER(30) NOT NULL                                                          
,DL_ID NUMBER(30) NOT NULL                                                      
,ADDRESS_ID NUMBER(30) NOT NULL                                                 
,BATCH_PARAM_ID NUMBER(30) NOT NULL                                             
,TRANSFORMER_PARSER VARCHAR2(255)                                               
,CONSTRAINT A_DL_DETAIL_PK PRIMARY KEY (ID)                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_DOMAIN                                                         
create table A_DOMAIN(                                                          
ID NUMBER(30) NOT NULL                                                          
,CREATE_DATE DATE                                                               
,SOLUTION_NAME VARCHAR2(255) NOT NULL                                           
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_DOMAIN_PK PRIMARY KEY (ID)                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_ENTITY_2_PROFILE                                               
create table A_ENTITY_2_PROFILE(                                                
ENTITY VARCHAR2(255) NOT NULL                                                   
,ENTITY_TYPE NUMBER(30) NOT NULL                                                
,PROFILE_ID NUMBER(30) NOT NULL                                                 
,PROFILE_TYPE NUMBER(30) NOT NULL                                               
,CONSTRAINT A_ENTITY_2_PROFILE_PK PRIMARY KEY (ENTITY,ENTITY_TYPE,PROFILE_TYPE) 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_EVENT                                                          
create table A_EVENT(                                                           
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,TYPE NUMBER(30) NOT NULL                                                       
,TRANSFORMER_DOC VARCHAR2(255) NOT NULL                                         
,TRANSFORMER_PARSER VARCHAR2(255) NOT NULL                                      
,DESCRIPTION VARCHAR2(255)                                                      
,CONSTRAINT A_EVENT_PK PRIMARY KEY (ID)                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_EVENT_2_DL                                                     
create table A_EVENT_2_DL(                                                      
ID NUMBER(30) NOT NULL                                                          
,EVENT_ID NUMBER(30) NOT NULL                                                   
,DL_ID NUMBER(30) NOT NULL                                                      
,CONSTRAINT A_EVENT_2_DL_PK PRIMARY KEY (ID)                                    
,CONSTRAINT A_EVENT_2_DL_UNIQ UNIQUE(DL_ID,EVENT_ID)                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_EVENT_GROUP                                                    
create table A_EVENT_GROUP(                                                     
EVENT_ID NUMBER(30) NOT NULL                                                    
,GROUP_NUMBER NUMBER(10) NOT NULL                                               
,ORD_SEQ NUMBER(10) NOT NULL                                                    
,CONSTRAINT A_EVENT_GROUP_PK PRIMARY KEY (EVENT_ID)                             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_FLOW                                                           
create table A_FLOW(                                                            
ID NUMBER(30) NOT NULL                                                          
,BUSINESS_PROCESS_ID NUMBER(30) NOT NULL                                        
,CONVERSATION_ID NUMBER(30) NOT NULL                                            
,UUID VARCHAR2(255) NOT NULL                                                    
,START_TIME DATE NOT NULL                                                       
,TYPE NUMBER(30) NOT NULL                                                       
,FLOW_DEF_ID NUMBER(30) NOT NULL                                                
,NESTED_DEPTH NUMBER(8) NOT NULL                                                
,NESTED_ORDER NUMBER(8) NOT NULL                                                
,NESTED_ATTR NUMBER(30) NOT NULL                                                
,CONSTRAINT A_FLOW_PK PRIMARY KEY (ID)                                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX FLOW_UUID_INDEX ON A_FLOW                                          
(UUID                                                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_FLOW_ANSWER                                                    
create table A_FLOW_ANSWER(                                                     
FLOW_ID NUMBER(30) NOT NULL                                                     
,LOGIC_REF VARCHAR2(255)                                                        
,ANSWER NUMBER(10) NOT NULL                                                     
,MSG VARCHAR2(4000)                                                             
,END_TIME DATE NOT NULL                                                         
,ADAPTER_PROCESS NUMBER(30) NOT NULL                                            
,FLOW_PROCESS NUMBER(30) NOT NULL                                               
,TRACKING_DATA VARCHAR2(4000) NOT NULL                                          
,TRACE BLOB                                                                     
,CONSTRAINT A_FLOW_ANSWER_PK PRIMARY KEY (FLOW_ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_FLOW_DEF                                                       
create table A_FLOW_DEF(                                                        
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,EXEC_DATA VARCHAR2(255) NOT NULL                                               
,TYPE NUMBER(8) NOT NULL                                                        
,CONSTRAINT A_FLOW_DEF_PK PRIMARY KEY (ID)                                      
,CONSTRAINT UNIQUE_NAME UNIQUE(NAME)                                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_GENERIC_NOE_DEALS                                              
create table A_GENERIC_NOE_DEALS(                                               
ID NUMBER(30) NOT NULL                                                          
,DOMAIN_ID NUMBER(30) NOT NULL                                                  
,PARTNER_ID NUMBER(30) NOT NULL                                                 
,STATUS NUMBER(10)                                                              
,REASON VARCHAR2(4000)                                                          
,TIME DATE                                                                      
,UUID VARCHAR2(255) NOT NULL                                                    
,NOE_REF VARCHAR2(255)                                                          
,LIFE_CYCLE_STATUS NUMBER(30)                                                   
,LIFE_CYCLE_REASON VARCHAR2(255)                                                
,RECONCILIATION_STATUS NUMBER(30)                                               
,RECONCILIATION_REASON VARCHAR2(255)                                            
,ALLOCATION_STATUS NUMBER(30)                                                   
,ALLOCATION_REASON VARCHAR2(255)                                                
,APPROVE_STATUS NUMBER(30)                                                      
,APPROVE_REASON VARCHAR2(255)                                                   
,REQUEST_DEALS_ID NUMBER(30)                                                    
,F1 VARCHAR2(255)                                                               
,F2 VARCHAR2(255)                                                               
,F3 VARCHAR2(255)                                                               
,F4 VARCHAR2(255)                                                               
,F5 VARCHAR2(255)                                                               
,F6 VARCHAR2(255)                                                               
,F7 VARCHAR2(255)                                                               
,F8 VARCHAR2(255)                                                               
,F9 VARCHAR2(255)                                                               
,F10 VARCHAR2(255)                                                              
,F11 VARCHAR2(255)                                                              
,F12 VARCHAR2(255)                                                              
,F13 VARCHAR2(255)                                                              
,F14 VARCHAR2(255)                                                              
,F15 VARCHAR2(255)                                                              
,F16 VARCHAR2(255)                                                              
,F17 VARCHAR2(255)                                                              
,F18 VARCHAR2(255)                                                              
,F19 VARCHAR2(255)                                                              
,F20 VARCHAR2(255)                                                              
,F30 VARCHAR2(255)                                                              
,F21 VARCHAR2(255)                                                              
,F22 VARCHAR2(255)                                                              
,F23 VARCHAR2(255)                                                              
,F24 VARCHAR2(255)                                                              
,F25 VARCHAR2(255)                                                              
,F26 VARCHAR2(255)                                                              
,F27 VARCHAR2(255)                                                              
,F28 VARCHAR2(255)                                                              
,F29 VARCHAR2(255)                                                              
,F31 VARCHAR2(255)                                                              
,F32 VARCHAR2(255)                                                              
,F33 VARCHAR2(255)                                                              
,F34 VARCHAR2(255)                                                              
,F35 VARCHAR2(255)                                                              
,F36 VARCHAR2(255)                                                              
,F37 VARCHAR2(255)                                                              
,F38 VARCHAR2(255)                                                              
,F39 VARCHAR2(255)                                                              
,F40 VARCHAR2(255)                                                              
,F41 VARCHAR2(255)                                                              
,F42 VARCHAR2(255)                                                              
,F43 VARCHAR2(255)                                                              
,F44 VARCHAR2(255)                                                              
,F45 VARCHAR2(255)                                                              
,F46 VARCHAR2(255)                                                              
,F47 VARCHAR2(255)                                                              
,F48 VARCHAR2(255)                                                              
,F49 VARCHAR2(255)                                                              
,F50 VARCHAR2(255)                                                              
,F51 VARCHAR2(255)                                                              
,F52 VARCHAR2(255)                                                              
,F53 VARCHAR2(255)                                                              
,F54 VARCHAR2(255)                                                              
,F55 VARCHAR2(255)                                                              
,F56 VARCHAR2(255)                                                              
,F57 VARCHAR2(255)                                                              
,F58 VARCHAR2(255)                                                              
,F59 VARCHAR2(255)                                                              
,F60 VARCHAR2(255)                                                              
,F61 VARCHAR2(255)                                                              
,F62 VARCHAR2(255)                                                              
,F63 VARCHAR2(255)                                                              
,F64 VARCHAR2(255)                                                              
,F65 VARCHAR2(255)                                                              
,F66 VARCHAR2(255)                                                              
,F67 VARCHAR2(255)                                                              
,F68 VARCHAR2(255)                                                              
,F69 VARCHAR2(255)                                                              
,F70 VARCHAR2(255)                                                              
,F71 VARCHAR2(255)                                                              
,F72 VARCHAR2(255)                                                              
,F73 VARCHAR2(255)                                                              
,F74 VARCHAR2(255)                                                              
,F75 VARCHAR2(255)                                                              
,F76 VARCHAR2(255)                                                              
,F77 VARCHAR2(255)                                                              
,F78 VARCHAR2(255)                                                              
,F79 VARCHAR2(255)                                                              
,F80 VARCHAR2(255)                                                              
,F81 VARCHAR2(255)                                                              
,F82 VARCHAR2(255)                                                              
,F83 VARCHAR2(255)                                                              
,F84 VARCHAR2(255)                                                              
,F85 VARCHAR2(255)                                                              
,F86 VARCHAR2(255)                                                              
,F87 VARCHAR2(255)                                                              
,F88 VARCHAR2(255)                                                              
,F89 VARCHAR2(255)                                                              
,F90 VARCHAR2(255)                                                              
,CONSTRAINT A_GENERIC_NOE_DEALS_PK PRIMARY KEY (ID)                             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX GENERIC_NOE_DEALS_UID_INDEX ON A_GENERIC_NOE_DEALS                 
(UUID                                                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_GENERIC_OA_DEALS                                               
create table A_GENERIC_OA_DEALS(                                                
ID NUMBER(30) NOT NULL                                                          
,DOMAIN_ID NUMBER(30) NOT NULL                                                  
,PARTNER_ID NUMBER(30) NOT NULL                                                 
,STATUS NUMBER(10)                                                              
,REASON VARCHAR2(4000)                                                          
,TIME DATE                                                                      
,UUID VARCHAR2(255) NOT NULL                                                    
,OA_REF VARCHAR2(255)                                                           
,LIFE_CYCLE_STATUS NUMBER(30)                                                   
,LIFE_CYCLE_REASON VARCHAR2(255)                                                
,APPROVE_STATUS NUMBER(30)                                                      
,APPROVE_REASON VARCHAR2(255)                                                   
,REQUEST_DEALS_ID NUMBER(30)                                                    
,F1 VARCHAR2(255)                                                               
,F2 VARCHAR2(255)                                                               
,F3 VARCHAR2(255)                                                               
,F4 VARCHAR2(255)                                                               
,F5 VARCHAR2(255)                                                               
,F6 VARCHAR2(255)                                                               
,F7 VARCHAR2(255)                                                               
,F8 VARCHAR2(255)                                                               
,F9 VARCHAR2(255)                                                               
,F10 VARCHAR2(255)                                                              
,F11 VARCHAR2(255)                                                              
,F12 VARCHAR2(255)                                                              
,F13 VARCHAR2(255)                                                              
,F14 VARCHAR2(255)                                                              
,F15 VARCHAR2(255)                                                              
,F16 VARCHAR2(255)                                                              
,F17 VARCHAR2(255)                                                              
,F18 VARCHAR2(255)                                                              
,F19 VARCHAR2(255)                                                              
,F20 VARCHAR2(255)                                                              
,F30 VARCHAR2(255)                                                              
,F21 VARCHAR2(255)                                                              
,F22 VARCHAR2(255)                                                              
,F23 VARCHAR2(255)                                                              
,F24 VARCHAR2(255)                                                              
,F25 VARCHAR2(255)                                                              
,F26 VARCHAR2(255)                                                              
,F27 VARCHAR2(255)                                                              
,F28 VARCHAR2(255)                                                              
,F29 VARCHAR2(255)                                                              
,F31 VARCHAR2(255)                                                              
,F32 VARCHAR2(255)                                                              
,F33 VARCHAR2(255)                                                              
,F34 VARCHAR2(255)                                                              
,F35 VARCHAR2(255)                                                              
,F36 VARCHAR2(255)                                                              
,F37 VARCHAR2(255)                                                              
,F38 VARCHAR2(255)                                                              
,F39 VARCHAR2(255)                                                              
,F40 VARCHAR2(255)                                                              
,F41 VARCHAR2(255)                                                              
,F42 VARCHAR2(255)                                                              
,F43 VARCHAR2(255)                                                              
,F44 VARCHAR2(255)                                                              
,F45 VARCHAR2(255)                                                              
,F46 VARCHAR2(255)                                                              
,F47 VARCHAR2(255)                                                              
,F48 VARCHAR2(255)                                                              
,F49 VARCHAR2(255)                                                              
,F50 VARCHAR2(255)                                                              
,F51 VARCHAR2(255)                                                              
,F52 VARCHAR2(255)                                                              
,F53 VARCHAR2(255)                                                              
,F54 VARCHAR2(255)                                                              
,F55 VARCHAR2(255)                                                              
,F56 VARCHAR2(255)                                                              
,F57 VARCHAR2(255)                                                              
,F58 VARCHAR2(255)                                                              
,F59 VARCHAR2(255)                                                              
,F60 VARCHAR2(255)                                                              
,F61 VARCHAR2(255)                                                              
,F62 VARCHAR2(255)                                                              
,F63 VARCHAR2(255)                                                              
,F64 VARCHAR2(255)                                                              
,F65 VARCHAR2(255)                                                              
,F66 VARCHAR2(255)                                                              
,F67 VARCHAR2(255)                                                              
,F68 VARCHAR2(255)                                                              
,F69 VARCHAR2(255)                                                              
,F70 VARCHAR2(255)                                                              
,F71 VARCHAR2(255)                                                              
,F72 VARCHAR2(255)                                                              
,F73 VARCHAR2(255)                                                              
,F74 VARCHAR2(255)                                                              
,F75 VARCHAR2(255)                                                              
,F76 VARCHAR2(255)                                                              
,F77 VARCHAR2(255)                                                              
,F78 VARCHAR2(255)                                                              
,F79 VARCHAR2(255)                                                              
,F80 VARCHAR2(255)                                                              
,F81 VARCHAR2(255)                                                              
,F82 VARCHAR2(255)                                                              
,F83 VARCHAR2(255)                                                              
,F84 VARCHAR2(255)                                                              
,F85 VARCHAR2(255)                                                              
,F86 VARCHAR2(255)                                                              
,F87 VARCHAR2(255)                                                              
,F88 VARCHAR2(255)                                                              
,F89 VARCHAR2(255)                                                              
,F90 VARCHAR2(255)                                                              
,CONSTRAINT A_GENERIC_OA_DEALS_PK PRIMARY KEY (ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX GENERIC_OA_DEALS_UID_INDEX ON A_GENERIC_OA_DEALS                   
(UUID                                                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_GENERIC_REQUEST_DEALS                                          
create table A_GENERIC_REQUEST_DEALS(                                           
ID NUMBER(30) NOT NULL                                                          
,DOMAIN_ID NUMBER(30) NOT NULL                                                  
,PARTNER_ID NUMBER(30) NOT NULL                                                 
,PARTNER_NAME VARCHAR2(255) NOT NULL                                            
,NAMER_ID NUMBER(30) NOT NULL                                                   
,STATUS NUMBER(10) NOT NULL                                                     
,REASON VARCHAR2(4000)                                                          
,INSERT_TIME DATE NOT NULL                                                      
,EXEC_TIME DATE                                                                 
,INSERT_UUID VARCHAR2(255) NOT NULL                                             
,EXEC_UUID VARCHAR2(255) NOT NULL                                               
,TRANSFORMER_NAME VARCHAR2(255) NOT NULL                                        
,PROTOCOL_INFO_MESSAGE_ID NUMBER(30) NOT NULL                                   
,TARGET_DATA BLOB NOT NULL                                                      
,CONSTRAINT A_GENERIC_REQUEST_DEALS_PK PRIMARY KEY (ID)                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX GENERIC_DEALS_UID_INSERT_INDEX ON A_GENERIC_REQUEST_DEALS          
(INSERT_UUID                                                                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX A_GENERIC_REQ_DEALS_EXTIME_IDX ON A_GENERIC_REQUEST_DEALS          
(EXEC_TIME                                                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table A_INSTALL_PARAMS                                                 
create table A_INSTALL_PARAMS(                                                  
PARAMETER VARCHAR2(255) NOT NULL                                                
,VALUE VARCHAR2(255)                                                            
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_2_FIN_CENTER                                        
create table A_INSTRUMENT_2_FIN_CENTER(                                         
ID NUMBER(30) NOT NULL                                                          
,INSTRUMENT_ID NUMBER(30)                                                       
,FINANCIAL_CENTER_ID NUMBER(30)                                                 
,CONSTRAINT A_INSTRUMENT_2_FIN_CENTER_PK PRIMARY KEY (ID)                       
,CONSTRAINT A_INSTRUMENT_2_FIN_CENTER_UNQ                                       
UNIQUE(FINANCIAL_CENTER_ID,INSTRUMENT_ID)                                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_BARRIER_CAP_FLOOR                                   
create table A_INSTRUMENT_BARRIER_CAP_FLOOR(                                    
ID NUMBER(30) NOT NULL                                                          
,BARRIER_TYPE NUMBER(8)                                                         
,LOWER_BARRIER_LEVEL NUMBER(30,8)                                               
,UPPER_BARRIER_LEVEL NUMBER(30,8)                                               
,REBATE_TYPE NUMBER(8)                                                          
,REBATE_PERCENT1 NUMBER(30,8)                                                   
,REBATE_PERCENT2 NUMBER(30,8)                                                   
,REBATE_AMOUNT1 NUMBER(30,8)                                                    
,REBATE_AMOUNT2 NUMBER(30,8)                                                    
,REBATE_CURRENCY NUMBER(30)                                                     
,CONSTRAINT A_INSTR_BARRIER_CAP_FLOOR_PK PRIMARY KEY (ID)                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_BARRIER_OPTION                                      
create table A_INSTRUMENT_BARRIER_OPTION(                                       
ID NUMBER(30) NOT NULL                                                          
,BARRIER_TYPE NUMBER(8)                                                         
,LOWER_BARRIER_LEVEL NUMBER(30,8)                                               
,UPPER_BARRIER_LEVEL NUMBER(30,8)                                               
,REBATE_TYPE NUMBER(8)                                                          
,REBATE_QUOTE_MODE NUMBER(8)                                                    
,REBATE_PERCENT_1 NUMBER(30,8)                                                  
,REBATE_PERCENT_2 NUMBER(30,8)                                                  
,REBATE_AMOUNT1 NUMBER(30,8)                                                    
,REBATE_AMOUNT2 NUMBER(30,8)                                                    
,REBATE_CURRENCY NUMBER(30)                                                     
,CONSTRAINT A_INSTRUMENT_BARRIER_OPTION_PK PRIMARY KEY (ID)                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_BASE                                                
create table A_INSTRUMENT_BASE(                                                 
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,TYPE NUMBER(8) NOT NULL                                                        
,TIME_ZONE NUMBER(8)                                                            
,FINANCIAL_CENTER_LIST NUMBER(30)                                               
,PAYMENT_DATE_ROLL NUMBER(8)                                                    
,DESCRIPTION VARCHAR2(255)                                                      
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,IS_CASHFLOW NUMBER(1)                                                          
,CONSTRAINT A_INSTRUMENT_PK PRIMARY KEY (ID)                                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_BERM_OPT_EX_DATE                                    
create table A_INSTRUMENT_BERM_OPT_EX_DATE(                                     
ID NUMBER(30) NOT NULL                                                          
,INSTRUMENT_OPTION_ID NUMBER(30) NOT NULL                                       
,EXERCISE_DATE DATE NOT NULL                                                    
,CONSTRAINT A_INSTR_BERM_OPT_EX_DATE_PK PRIMARY KEY (ID)                        
,CONSTRAINT A_INSTR_BERM_OPT_EX_DATE_UNQ                                        
UNIQUE(INSTRUMENT_OPTION_ID,EXERCISE_DATE)                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_BINARY_OPTION                                       
create table A_INSTRUMENT_BINARY_OPTION(                                        
ID NUMBER(30) NOT NULL                                                          
,PAYOUT_INSTRUMENT NUMBER(30)                                                   
,PAYOUT_AMOUNT NUMBER(30,8)                                                     
,CONSTRAINT A_INSTRUMENT_BINARY_OPTION_PK PRIMARY KEY (ID)                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_CAP_FLOOR                                           
create table A_INSTRUMENT_CAP_FLOOR(                                            
ID NUMBER(30) NOT NULL                                                          
,STRIKE_RATE NUMBER(30,8)                                                       
,CAP_FLOOR_TYPE NUMBER(8)                                                       
,PAYOUT_INSTRUMENT NUMBER(30)                                                   
,PAYOUT_AMOUNT NUMBER(30,8)                                                     
,CONSTRAINT A_INSTRUMENT_CAP_FLOOR_PK PRIMARY KEY (ID)                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_CURRENCY                                            
create table A_INSTRUMENT_CURRENCY(                                             
ID NUMBER(30) NOT NULL                                                          
,IS_NDF NUMBER(8)                                                               
,AMT_PLACES NUMBER(10)                                                          
,ROUNDING_METHOD NUMBER(1)                                                      
,CONSTRAINT A_INSTRUMENT_CURRENCY_PK PRIMARY KEY (ID)                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_FIX_RATE_BOND                                       
create table A_INSTRUMENT_FIX_RATE_BOND(                                        
ID NUMBER(30) NOT NULL                                                          
,ISSUER VARCHAR2(255)                                                           
,BOND_TYPE NUMBER(30)                                                           
,BOND_CUSIP VARCHAR2(255)                                                       
,BOND_ISIP VARCHAR2(255)                                                        
,ANNOUNCE_DATE DATE                                                             
,AUCTION_DATE DATE                                                              
,ACCRUAL_START_DATE DATE                                                        
,PENULTIMATE_DATE DATE                                                          
,CALLABLE_DATE DATE                                                             
,CALLABLE_PRICE NUMBER(30,8)                                                    
,TAX_RECLAIM_OFFSET NUMBER(30,8)                                                
,SETTLEMENT_TERM NUMBER(30)                                                     
,ON_THE_RUN_BOND NUMBER(8)                                                      
,CONSTRAINT A_INSTRUMENT_FIX_RATE_BOND_PK PRIMARY KEY (ID)                      
,CONSTRAINT BOND_CUSIP_UNQ UNIQUE(BOND_CUSIP)                                   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table A_INSTRUMENT_FLOAT_INTER_PAY                                     
create table A_INSTRUMENT_FLOAT_INTER_PAY(                                      
ID NUMBER(30) NOT NULL                                                          
,REFERENCE_INDEX NUMBER(8)                                                      
,REFERENCE_INDEX_FACTOR NUMBER(30,8)                                            
,REFERENCE_INDEX_SPREAD NUMBER(30,8)                                            
,REFERENCE_INDEX_SOURCE NUMBER(8)                                               
,REFERENCE_INDEX_TERM NUMBER(30,8)                                              
,RESET_START_TERM NUMBER(30)                                                    
,RESET_DAY_OF_WEEK NUMBER(8)                                                    
,RESET_DAY_OF_MONTH NUMBER(8)                                                   
,RESET_FREQUENCY NUMBER(8)                                                      
,CALCULATION_START_DATE DATE                                                    
,CALCULATION_TIMING NUMBER(8)                                                   
,CALCULATION_DATE_ROLL NUMBER(8)                                                
,CALCULATION_FREQUENCY NUMBER(30)                                               
,CALCULATION_LAG_DAYS NUMBER(8)                                                 
,CALCULATION_LAG NUMBER(30)                                                     
,CONSTRAINT A_INSTR_FLOAT_INTER_PAY_PK PRIMARY KEY (ID)                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_ALIAS_ARGUMENT                                            
create table D_RULE_ALIAS_ARGUMENT(                                             
PARAM_INDEX NUMBER(30) NOT NULL                                                 
,IS_VECTOR NUMBER(1) NOT NULL                                                   
,UUID VARCHAR2(255)                                                             
,CLASS_TYPE_LOCATION_UUID VARCHAR2(255)                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_CATEGORIES                                                
create table D_RULE_CATEGORIES(                                                 
ID NUMBER(30) NOT NULL                                                          
,CATEGORY_NAME VARCHAR2(255) NOT NULL                                           
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_CLASS_TYPE_LOCATION                                       
create table D_RULE_CLASS_TYPE_LOCATION(                                        
CATEGORY_ID NUMBER(30) NOT NULL                                                 
,PACKAGE_NAME VARCHAR2(255)                                                     
,CLASS_NAME VARCHAR2(255) NOT NULL                                              
,IS_ACTIVE NUMBER(1)                                                            
,UUID VARCHAR2(255)                                                             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_EXPRESSION                                                
create table D_RULE_EXPRESSION(                                                 
COMPERATOR VARCHAR2(255)                                                        
,RIGHT_VALUE VARCHAR2(255)                                                      
,OPERATOR VARCHAR2(2)                                                           
,LEFT_FRAGMENT_UUID VARCHAR2(255)                                               
,RIGHT_FRAGMENT_UUID VARCHAR2(255)                                              
,PROJECT_NAME VARCHAR2(255)                                                     
,RULESET_NAME VARCHAR2(255)                                                     
,RULE_NAME VARCHAR2(255)                                                        
,UUID VARCHAR2(255)                                                             
,LEFT_EXPRESSION_UUID VARCHAR2(255)                                             
,RIGHT_EXPRESSION_UUID VARCHAR2(255)                                            
,LEFT_VARIABLE_UUID VARCHAR2(255)                                               
,RIGHT_VARIABLE_UUID VARCHAR2(255)                                              
,DESCRIPTION VARCHAR2(255)                                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_FRAGMENTS                                                 
create table D_RULE_FRAGMENTS(                                                  
SEQ NUMBER(30) NOT NULL                                                         
,CATEGORY_ID NUMBER(30) NOT NULL                                                
,TEMPLATE_NAME VARCHAR2(255)                                                    
,STATIC_VALUE VARCHAR2(255)                                                     
,OPERATOR VARCHAR2(255)                                                         
,DEFINE_AS_NEW NUMBER(1)                                                        
,IS_VECTOR NUMBER(1)                                                            
,PROJECT_NAME VARCHAR2(255)                                                     
,RULESET_NAME VARCHAR2(255)                                                     
,RULE_NAME VARCHAR2(255)                                                        
,UUID VARCHAR2(255)                                                             
,FRAGMENT_UUID VARCHAR2(255)                                                    
,FRAGMENT_ARGUMENT_UUID VARCHAR2(255)                                           
,VARIABLE_UUID VARCHAR2(255)                                                    
,ALIAS_UUID VARCHAR2(255)                                                       
,RETURN_TYPE_LOCATION_UUID VARCHAR2(255)                                        
,STATIC_CLASS_TYPE_UUID VARCHAR2(255)                                           
,DATE_CREATED DATE                                                              
,DESCRIPTION VARCHAR2(255)                                                      
,TEMPLATE_GROUP_NAME VARCHAR2(255)                                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_FRAGMENT_ARGUMENTS                                        
create table D_RULE_FRAGMENT_ARGUMENTS(                                         
SEQ NUMBER(30) NOT NULL                                                         
,PARAM_TYPE NUMBER(30)                                                          
,PROJECT_NAME VARCHAR2(255)                                                     
,RULESET_NAME VARCHAR2(255)                                                     
,RULE_NAME VARCHAR2(255)                                                        
,D_RULE_FRAGMENT_UUID VARCHAR2(255)                                             
,UUID VARCHAR2(255)                                                             
,VALUE2 VARCHAR2(255)                                                           
,DESCRIPTION VARCHAR2(255)                                                      
,TEMPLATE_GROUP_NAME VARCHAR2(255)                                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_IF                                                        
create table D_RULE_IF(                                                         
SEQ NUMBER(30) NOT NULL                                                         
,STATEMENT_UID VARCHAR2(255)                                                    
,PROJECT_NAME VARCHAR2(255)                                                     
,RULESET_NAME VARCHAR2(255)                                                     
,RULE_NAME VARCHAR2(255)                                                        
,UUID VARCHAR2(255)                                                             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_STATEMENT                                                 
create table D_RULE_STATEMENT(                                                  
SEQ NUMBER(30) NOT NULL                                                         
,PROJECT_NAME VARCHAR2(255)                                                     
,RULESET_NAME VARCHAR2(255)                                                     
,RULE_NAME VARCHAR2(255)                                                        
,UUID VARCHAR2(255)                                                             
,CALLING_RULE_UUID VARCHAR2(255)                                                
,EXPRESSION_UUID VARCHAR2(255)                                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_TEMPLATE_TYPES                                            
create table D_RULE_TEMPLATE_TYPES(                                             
TEMPLATE_TYPE_NAME VARCHAR2(255) NOT NULL                                       
,CONSTRAINT ARCH_RULE_TEMPLATE_TYPE_PK PRIMARY KEY (TEMPLATE_TYPE_NAME)         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_RULE_VARIABLES                                                 
create table D_RULE_VARIABLES(                                                  
IS_VECTOR NUMBER(1) NOT NULL                                                    
,VARIABLE_NAME VARCHAR2(255) NOT NULL                                           
,VALUE VARCHAR2(255)                                                            
,UUID VARCHAR2(255)                                                             
,FRAGMENT_UUID VARCHAR2(255)                                                    
,PROJECT_NAME VARCHAR2(255)                                                     
,RULESET_NAME VARCHAR2(255)                                                     
,CLASS_TYPE_LOCATION_UUID VARCHAR2(255)                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table D_WORKFLOW_INFO                                                  
create table D_WORKFLOW_INFO(                                                   
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,CATEGORY VARCHAR2(255) NOT NULL                                                
,CONSTRAINT PK_D_WORKFLOW_INFO PRIMARY KEY (ID)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table META_CONSTRAINTS                                                 
create table META_CONSTRAINTS(                                                  
VERSION VARCHAR2(50) NOT NULL                                                   
,OWNER VARCHAR2(30) NOT NULL                                                    
,CONSTRAINT_NAME VARCHAR2(30) NOT NULL                                          
,CONSTRAINT_TYPE VARCHAR2(1)                                                    
,TABLE_NAME VARCHAR2(30)                                                        
,R_CONSTRAINT_NAME VARCHAR2(30)                                                 
,DELETE_RULE VARCHAR2(9)                                                        
,STATUS VARCHAR2(8)                                                             
,CONSTRAINT META_CONSTRAINTS_PK PRIMARY KEY (VERSION,OWNER,CONSTRAINT_NAME)     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table META_CONS_COLUMNS                                                
create table META_CONS_COLUMNS(                                                 
VERSION VARCHAR2(50) NOT NULL                                                   
,OWNER VARCHAR2(30) NOT NULL                                                    
,CONSTRAINT_NAME VARCHAR2(30) NOT NULL                                          
,TABLE_NAME VARCHAR2(30)                                                        
,COLUMN_NAME VARCHAR2(40) NOT NULL                                              
,POSITION NUMBER(3)                                                             
,CONSTRAINT META_CONS_COLUMNS_PK PRIMARY KEY                                    
(VERSION,OWNER,CONSTRAINT_NAME,COLUMN_NAME)                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table META_INDEXES                                                     
create table META_INDEXES(                                                      
VERSION VARCHAR2(50) NOT NULL                                                   
,OWNER VARCHAR2(30) NOT NULL                                                    
,INDEX_NAME VARCHAR2(30) NOT NULL                                               
,TABLE_NAME VARCHAR2(30) NOT NULL                                               
,TABLESPACE_NAME VARCHAR2(30)                                                   
,UNIQUENESS VARCHAR2(9)                                                         
,INITIAL_EXTENT NUMBER(20)                                                      
,NEXT_EXTENT NUMBER(20)                                                         
,MIN_EXTENTS NUMBER(20)                                                         
,MAX_EXTENTS NUMBER(20)                                                         
,PCT_FREE NUMBER(2)                                                             
,PCT_INCREASE NUMBER(2)                                                         
,CONSTRAINT META_INDEXES_PK PRIMARY KEY (VERSION,OWNER,TABLE_NAME,INDEX_NAME)   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table META_IND_COLUMNS                                                 
create table META_IND_COLUMNS(                                                  
VERSION VARCHAR2(50) NOT NULL                                                   
,OWNER VARCHAR2(30) NOT NULL                                                    
,INDEX_NAME VARCHAR2(30) NOT NULL                                               
,TABLE_NAME VARCHAR2(30)                                                        
,COLUMN_NAME VARCHAR2(4000)                                                     
,COLUMN_POSITION NUMBER(3) NOT NULL                                             
,CONSTRAINT META_IND_COLUMNS_PL PRIMARY KEY                                     
(VERSION,OWNER,INDEX_NAME,COLUMN_POSITION)                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table META_TABLES                                                      
create table META_TABLES(                                                       
VERSION VARCHAR2(50) NOT NULL                                                   
,OWNER VARCHAR2(30) NOT NULL                                                    
,TABLE_NAME VARCHAR2(30) NOT NULL                                               
,TABLESPACE_NAME VARCHAR2(30)                                                   
,PCT_FREE NUMBER(2)                                                             
,PCT_USED NUMBER(2)                                                             
,INITIAL_EXTENT NUMBER(20)                                                      
,NEXT_EXTENT NUMBER(20)                                                         
,MIN_EXTENTS NUMBER(20)                                                         
,MAX_EXTENTS NUMBER(20)                                                         
,PCT_INCREASE NUMBER(2)                                                         
,DEGREE NUMBER(3)                                                               
,CACHE VARCHAR2(5)                                                              
,CONSTRAINT META_TABLES_PK PRIMARY KEY (VERSION,OWNER,TABLE_NAME)               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table META_TAB_COLUMNS                                                 
create table META_TAB_COLUMNS(                                                  
VERSION VARCHAR2(50) NOT NULL                                                   
,OWNER VARCHAR2(30) NOT NULL                                                    
,TABLE_NAME VARCHAR2(30) NOT NULL                                               
,COLUMN_ID NUMBER(5)                                                            
,COLUMN_NAME VARCHAR2(30) NOT NULL                                              
,DATA_TYPE VARCHAR2(106)                                                        
,DATA_LENGTH NUMBER(5)                                                          
,DATA_PRECISION NUMBER(5)                                                       
,DATA_SCALE NUMBER(5)                                                           
,NULLABLE VARCHAR2(1)                                                           
,CONSTRAINT META_TAB_COLUMNS_PK PRIMARY KEY                                     
(VERSION,OWNER,TABLE_NAME,COLUMN_NAME)                                          
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table META_VIEWS                                                       
create table META_VIEWS(                                                        
VERSION VARCHAR2(50) NOT NULL                                                   
,OWNER VARCHAR2(30) NOT NULL                                                    
,VIEW_NAME VARCHAR2(30) NOT NULL                                                
,TEXT_LENGTH NUMBER(20)                                                         
,TEXT LONG                                                                      
,CONSTRAINT NETA_VIEWS_PK PRIMARY KEY (VERSION,OWNER,VIEW_NAME)                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_ACCOUNT_2_COMBINATIONS                                         
create table M_ACCOUNT_2_COMBINATIONS(                                          
ID NUMBER(30) NOT NULL                                                          
,PRODUCT_TYPE VARCHAR2(255) NOT NULL                                            
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,COMBINATION_NAME VARCHAR2(255) NOT NULL                                        
,STATUS NUMBER(1) NOT NULL                                                      
,UUID VARCHAR2(255) NOT NULL                                                    
,TIME_CREATED DATE                                                              
,CONSTRAINT SYS_C00521566 PRIMARY KEY                                           
(PRODUCT_TYPE,ACCOUNT_ID,COMBINATION_NAME,UUID)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_ALLOCATION_TEMPLATE                                            
create table M_ALLOCATION_TEMPLATE(                                             
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,PARENT_ORG NUMBER(30) NOT NULL                                                 
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT SYS_C00521571 PRIMARY KEY (ID)                                      
,CONSTRAINT UNIQUE_ALLOC_TEMP_NAME UNIQUE(NAME)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_ALLOCATION_TEMPLATE_2_FUNDS                                    
create table M_ALLOCATION_TEMPLATE_2_FUNDS(                                     
ID NUMBER(30) NOT NULL                                                          
,ALLOC_TEMPLATE_ID NUMBER(30) NOT NULL                                          
,FUND_ID NUMBER(30) NOT NULL                                                    
,PERCENTAGE NUMBER(30,10) NOT NULL                                              
,CONSTRAINT SYS_C00521576 PRIMARY KEY (ID)                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_BOOKING                                                        
create table M_BOOKING(                                                         
ID NUMBER(30) NOT NULL                                                          
,TYPE NUMBER(30)                                                                
,PRODUCT_TYPE VARCHAR2(255)                                                     
,EVENT_ID NUMBER(30)                                                            
,BOOK_DATA_MSG_FACTORY VARCHAR2(255)                                            
,CONSTRAINT PK_A_BOOKING PRIMARY KEY (ID)                                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_COMBINATIONS                                                   
create table M_COMBINATIONS(                                                    
ID NUMBER(30) NOT NULL                                                          
,PRODUCT_TYPE VARCHAR2(255) NOT NULL                                            
,COMBINATION_UUID VARCHAR2(255) NOT NULL                                        
,VERSION NUMBER(3) NOT NULL                                                     
,COMBINATION_NAME VARCHAR2(255) NOT NULL                                        
,COMBINATION_TYPE VARCHAR2(255) NOT NULL                                        
,OPERATOR VARCHAR2(2) NOT NULL                                                  
,COMBINATION_VALUE VARCHAR2(255) NOT NULL                                       
,STATUS NUMBER(1) NOT NULL                                                      
,TIME_CREATED DATE NOT NULL                                                     
,TIME_STATUS_CHANGED DATE                                                       
,CONSTRAINT SYS_C00521589 PRIMARY KEY (PRODUCT_TYPE,COMBINATION_UUID,VERSION)   
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_COMBINATION_2_BILLING_LINE                                     
create table M_COMBINATION_2_BILLING_LINE(                                      
ID NUMBER(30) NOT NULL                                                          
,PRODUCT_TYPE VARCHAR2(255) NOT NULL                                            
,ACCOUNT_ID NUMBER(30) NOT NULL                                                 
,COMBINATION_UUID VARCHAR2(255) NOT NULL                                        
,BILLING_LINE_ID NUMBER(30) NOT NULL                                            
,TIME_CREATED DATE                                                              
,CONSTRAINT SYS_C00521595 PRIMARY KEY (PRODUCT_TYPE,ACCOUNT_ID,COMBINATION_UUID)
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_CUT_OF_TIME_ZONE                                               
create table M_CUT_OF_TIME_ZONE(                                                
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,TIME_ZONE NUMBER(8) NOT NULL                                                   
,AUTO_ADJUST_SUMMER_TIME NUMBER(1)                                              
,CALENDAR_CENTER NUMBER(30) NOT NULL                                            
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT PK_M_CUT_OF_TIME_ZONES PRIMARY KEY (ID)                             
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_FX_NOE                                                         
create table M_FX_NOE(                                                          
ID NUMBER(30) NOT NULL                                                          
,USER_ID NUMBER(30) NOT NULL                                                    
,ENTERED_BY NUMBER(30) NOT NULL                                                 
,LIFECYCLE_STATUS NUMBER(8) NOT NULL                                            
,LIFECYCLE_STATUS_REASON VARCHAR2(255)                                          
,ALLOCATION_STATUS NUMBER(8) NOT NULL                                           
,ALLOCATION_STATUS_REASON VARCHAR2(255)                                         
,MATCHING_STATUS NUMBER(8) NOT NULL                                             
,MATCHING_STATUS_REASON VARCHAR2(255)                                           
,APPROVAL_STATUS NUMBER(8) NOT NULL                                             
,APPROVAL_STATUS_REASON VARCHAR2(255)                                           
,PROCESSING_STATUS NUMBER(8) NOT NULL                                           
,PROCESSING_STATUS_REASON VARCHAR2(255)                                         
,TRADER NUMBER(30) NOT NULL                                                     
,PORTFOLIO NUMBER(30)                                                           
,CLIENT_REF VARCHAR2(255)                                                       
,ORIGIN_SYSTEM NUMBER(8) NOT NULL                                               
,MATCHING_TIME DATE                                                             
,AGREEMENT_TYPE NUMBER(8)                                                       
,REPORTER VARCHAR2(255)                                                         
,TRADE_TYPE NUMBER(8) NOT NULL                                                  
,PRODUCT_TYPE NUMBER(8) NOT NULL                                                
,PRIME_BROKER NUMBER(30) NOT NULL                                               
,HARMONY_LIFECYCLE_STATUS VARCHAR2(255)                                         
,HARMONY_ID NUMBER(30)                                                          
,FAR_QUANTITY NUMBER(30,10)                                                     
,FAR_VALUE_DATE DATE                                                            
,FAR_QUANTITY2 NUMBER(30,10)                                                    
,MANUALLY_APPROVED NUMBER(1)                                                    
,NDF_INDICATOR NUMBER(1) NOT NULL                                               
,NDF_FIXING_DATE DATE                                                           
,NDF_FIXING_REFERENCE NUMBER(8)                                                 
,EXECUTING_PLATFORM NUMBER(30)                                                  
,UNDERLYING_CLIENT_REF VARCHAR2(255)                                            
,CALC_AGENT NUMBER(8)                                                           
,CONSTRAINT M_FX_NOE_PK PRIMARY KEY (ID)                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX M_FX_NOE_CLIENT_REF_IDX ON M_FX_NOE                                
(CLIENT_REF                                                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX M_FX_NOE_FAR_VALUE_DATE_IDX ON M_FX_NOE                            
(FAR_VALUE_DATE                                                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX M_FX_NOE_NDF_FIXING_DATE_IDX ON M_FX_NOE                           
(NDF_FIXING_DATE                                                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table M_FX_NOE_2_POS_COMBINATION                                       
create table M_FX_NOE_2_POS_COMBINATION(                                        
ID NUMBER(30) NOT NULL                                                          
,FX_NOE_ID NUMBER(30)                                                           
,POSITION_COMBINATION_ID NUMBER(30)                                             
,CONSTRAINT M_FX_NOE_2_POS_COMBINATION_PK PRIMARY KEY (ID)                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_FX_OA                                                          
create table M_FX_OA(                                                           
ID NUMBER(30) NOT NULL                                                          
,ACTIVITY_STATUS NUMBER(8) NOT NULL                                             
,ACTIVITY_STATUS_REASON VARCHAR2(255)                                           
,APPROVAL_STATUS NUMBER(8) NOT NULL                                             
,APPROVAL_STATUS_REASON VARCHAR2(255)                                           
,USER_ID NUMBER(30) NOT NULL                                                    
,USER_PARTY NUMBER(30) NOT NULL                                                 
,CLIENT_REF VARCHAR2(255)                                                       
,DESCRIPTION VARCHAR2(255)                                                      
,CREATION_TIME DATE NOT NULL                                                    
,TRADE_DATE DATE NOT NULL                                                       
,MANUALLY_APPROVED NUMBER(1)                                                    
,PRESET_ALLOCATION NUMBER(30)                                                   
,TRADING_PARTY NUMBER(30) NOT NULL                                              
,TOTAL_PREMIUM NUMBER(30,10) NOT NULL                                           
,CONSTRAINT SYS_C00521664 PRIMARY KEY (ID)                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX M_FX_OA_CREATION_TIME_IDX ON M_FX_OA                               
(CREATION_TIME                                                                  
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX M_FX_OA_TRADE_DATE_INDEX ON M_FX_OA                                
(TRADE_DATE                                                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table M_FX_OA_ALLOCATION                                               
create table M_FX_OA_ALLOCATION(                                                
ID NUMBER(30) NOT NULL                                                          
,FX_OA_ID NUMBER(30) NOT NULL                                                   
,FUND NUMBER(30) NOT NULL                                                       
,CLIENT_REF VARCHAR2(255)                                                       
,PREMIUM_QUANTITY NUMBER(30,10) NOT NULL                                        
,CONSTRAINT SYS_C00521669 PRIMARY KEY (ID)                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_FX_OPTION_NOE                                                  
create table M_FX_OPTION_NOE(                                                   
ID NUMBER(30) NOT NULL                                                          
,USER_ID NUMBER(30) NOT NULL                                                    
,ENTERED_BY NUMBER(30) NOT NULL                                                 
,LIFECYCLE_STATUS NUMBER(8) NOT NULL                                            
,LIFECYCLE_STATUS_REASON VARCHAR2(255)                                          
,ALLOCATION_STATUS NUMBER(8) NOT NULL                                           
,ALLOCATION_STATUS_REASON VARCHAR2(255)                                         
,MATCHING_STATUS NUMBER(8) NOT NULL                                             
,MATCHING_STATUS_REASON VARCHAR2(255)                                           
,APPROVAL_STATUS NUMBER(8) NOT NULL                                             
,APPROVAL_STATUS_REASON VARCHAR2(255)                                           
,PROCESSING_STATUS NUMBER(8) NOT NULL                                           
,PROCESSING_STATUS_REASON VARCHAR2(255)                                         
,TRADER NUMBER(30) NOT NULL                                                     
,PORTFOLIO NUMBER(30)                                                           
,CLIENT_REF VARCHAR2(255)                                                       
,ORIGIN_SYSTEM NUMBER(8) NOT NULL                                               
,MATCHING_TIME DATE                                                             
,AGREEMENT_TYPE NUMBER(8)                                                       
,REPORTER VARCHAR2(255)                                                         
,TRADE_TYPE NUMBER(8) NOT NULL                                                  
,PRODUCT_TYPE NUMBER(8) NOT NULL                                                
,PRIME_BROKER NUMBER(30) NOT NULL                                               
,HARMONY_LIFECYCLE_STATUS VARCHAR2(255)                                         
,HARMONY_ID NUMBER(30)                                                          
,EXECUTING_PLATFORM NUMBER(30)                                                  
,UNDERLYING_CLIENT_REF VARCHAR2(255)                                            
,STRIKE_QUOTE_MODE NUMBER(8) NOT NULL                                           
,OPTION_STYLE NUMBER(8) NOT NULL                                                
,CONTRACT_TYPE NUMBER(8) NOT NULL                                               
,PRECENTAGE_PREMIUM_AMOUNT NUMBER(30,10)                                        
,FLAT_PREMIUM_AMOUNT NUMBER(30,10) NOT NULL                                     
,PREMIUM_PAY_DATE DATE NOT NULL                                                 
,PREMIUM_CURRENCY NUMBER(30) NOT NULL                                           
,PREMIUM_TYPE NUMBER(8) NOT NULL                                                
,PREMIUM_MODE NUMBER(8) NOT NULL                                                
,EXPIRY_DATE DATE NOT NULL                                                      
,EXPIRY_TIME NUMBER(8) NOT NULL                                                 
,CUT_OF_TIME_ZONE NUMBER(30) NOT NULL                                           
,DELIVERY NUMBER(8) NOT NULL                                                    
,NDF_CCY NUMBER(30)                                                             
,FIXING_DATE DATE                                                               
,FIXING_INDEX NUMBER(8)                                                         
,CALC_AGENT NUMBER(8)                                                           
,MANUALLY_APPROVED NUMBER(1)                                                    
,BARRIER_TYPE NUMBER(8)                                                         
,BARRIER NUMBER(30,10)                                                          
,REBATE_MODE NUMBER(8)                                                          
,REBATE_CURRENCY NUMBER(8)                                                      
,PRECENTAGE_REBATE_AMOUNT NUMBER(30,10)                                         
,FLAT_REBATE_AMOUNT NUMBER(30,10)                                               
,LOWER_BARRIER NUMBER(30,10)                                                    
,UPPER_BARRIER NUMBER(30,10)                                                    
,LOWER_REBATE_MODE NUMBER(8)                                                    
,LOWER_REBATE_CURRENCY NUMBER(30)                                               
,PRECENTAGE_LOWER_REBATE_AMOUNT NUMBER(30,10)                                   
,FLAT_LOWER_REBATE_AMOUNT NUMBER(30,10)                                         
,UPPER_REBATE_MODE NUMBER(8)                                                    
,UPPER_REBATE_CURRENCY NUMBER(30)                                               
,PRECENTAGE_UPPER_REBATE_AMOUNT NUMBER(30,10)                                   
,FLAT_UPPER_REBATE_AMOUNT NUMBER(30,10)                                         
,REBATE_AT NUMBER(8)                                                            
,REBATE_DATE DATE                                                               
,REBATE_PAYOUT NUMBER(30,10)                                                    
,PAYOUT_MODE NUMBER(8)                                                          
,PAYOUT_CURRENCY NUMBER(30)                                                     
,PRECENTAGE_PAYOUT_AMOUNT NUMBER(30,10)                                         
,FLAT_PAYOUT_AMOUNT NUMBER(30,10)                                               
,PAYOUT_DATE DATE                                                               
,PAYOUT_AT NUMBER(8)                                                            
,CONSTRAINT M_FX_OPTION_NOE_PK PRIMARY KEY (ID)                                 
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
CREATE INDEX M_FX_OPTION_NOE_EXP_DATE_IDX ON M_FX_OPTION_NOE                    
(EXPIRY_DATE                                                                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
CREATE INDEX M_FX_OPTN_NOE_PRMMPAYDATE_IDX ON M_FX_OPTION_NOE                   
(PREMIUM_PAY_DATE                                                               
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10                                                 
;                                                                               
--                                                                              
--create table M_FX_TRADE                                                       
create table M_FX_TRADE(                                                        
ID NUMBER(30) NOT NULL                                                          
,LIFECYCLE_STATUS NUMBER(8) NOT NULL                                            
,LIFECYCLE_STATUS_REASON VARCHAR2(255)                                          
,BSR_STATUS NUMBER(8) NOT NULL                                                  
,BSR_STATUS_REASON VARCHAR2(255)                                                
,PROCESSING_STATUS NUMBER(8) NOT NULL                                           
,PROCESSING_STATUS_REASON VARCHAR2(255)                                         
,PREMIUM_QUANTITY NUMBER(30,10)                                                 
,CONSTRAINT SYS_C00521700 PRIMARY KEY (ID)                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_ORGANIZATION_EXT                                               
create table M_ORGANIZATION_EXT(                                                
ID NUMBER(30) NOT NULL                                                          
,REGION NUMBER(30)                                                              
,BIC_CODE VARCHAR2(255)                                                         
,MATCHING_STALE_TIMEOUT NUMBER(30)                                              
,ALLOCATION_STALE_TIMEOUT NUMBER(30)                                            
,NOE_AUTO_ALLCOATE NUMBER(1)                                                    
,IS_DIRECT NUMBER(1)                                                            
,HARMONY_ENABLED NUMBER(1)                                                      
,NOE_CONFIRM_SIMPLE_EXERCISE NUMBER(1)                                          
,NOE_CONFIRM_SIMPLE_FIXING NUMBER(1)                                            
,NOE_CONFIRM_SIMPLE_ECN NUMBER(1)                                               
,NOE_CONFIRM_SIMPLE_DIRECT NUMBER(1)                                            
,NOE_CONFIRM_OPTIONS_EXERCISE NUMBER(1)                                         
,NOE_CONFIRM_OPTIONS_EXPIRE NUMBER(1)                                           
,NOE_CONFIRM_OPTIONS_DIRECT NUMBER(1)                                           
,CONNECTIVITY_ENABLE NUMBER(1)                                                  
,ALLOCATION_TEMPLATE NUMBER(30)                                                 
,CREATE_FUND_RELATIONSHIP NUMBER(1)                                             
,CONSTRAINT PK_M_ORGANIZATION_EXT PRIMARY KEY (ID)                              
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_PERSON_EXT                                                     
create table M_PERSON_EXT(                                                      
ID NUMBER(30) NOT NULL                                                          
,LAST_ADMIN_PWD_CHANGED DATE                                                    
,PHONE_NUMBER VARCHAR2(255)                                                     
,FAX_NUMBER VARCHAR2(255)                                                       
,PREFERRED_CONTACT_METHOD NUMBER(30)                                            
,REGION NUMBER(8)                                                               
,CONSTRAINT PK_M_PERSON_EXT PRIMARY KEY (ID)                                    
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_PORTFOLIO                                                      
create table M_PORTFOLIO(                                                       
ID NUMBER(30) NOT NULL                                                          
,PARENT_ORG NUMBER(30) NOT NULL                                                 
,NAME VARCHAR2(255) NOT NULL                                                    
,DESCRIPTION VARCHAR2(255)                                                      
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT PK_M_PORTFOLIO PRIMARY KEY (ID)                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_REGION                                                         
create table M_REGION(                                                          
ID NUMBER(30) NOT NULL                                                          
,NAME VARCHAR2(255) NOT NULL                                                    
,TIME_ZONE NUMBER(8) NOT NULL                                                   
,AUTO_ADJUST_SUMMER_TIME NUMBER(1)                                              
,END_OF_DAY DATE NOT NULL                                                       
,CLOSE_OF_BUSINESS DATE NOT NULL                                                
,CONSTRAINT PK_M_REGION PRIMARY KEY (ID)                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_REGION_2_CALENDAR_CENTER                                       
create table M_REGION_2_CALENDAR_CENTER(                                        
ID NUMBER(30) NOT NULL                                                          
,REGION NUMBER(30) NOT NULL                                                     
,CALENDAR_CENTER NUMBER(30) NOT NULL                                            
,CONSTRAINT PK_M_REGION_2_CALENDAR_CENTER PRIMARY KEY (ID)                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table M_TRADER                                                         
create table M_TRADER(                                                          
ID NUMBER(30) NOT NULL                                                          
,PARENT_ORG NUMBER(30) NOT NULL                                                 
,NAME VARCHAR2(255) NOT NULL                                                    
,EMAIL VARCHAR2(255)                                                            
,PHONE VARCHAR2(255)                                                            
,DESCRIPTION VARCHAR2(255)                                                      
,BASIC_STATUS NUMBER(8) NOT NULL                                                
,BASIC_STATUS_REASON VARCHAR2(255)                                              
,CONSTRAINT PK_M_TRADER PRIMARY KEY (ID)                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table T1                                                               
create table T1(                                                                
C1 NUMBER                                                                       
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table T_TEST1                                                          
create table T_TEST1(                                                           
ID NUMBER(30) NOT NULL                                                          
,VALUE NUMBER(30)                                                               
,STATUS_A NUMBER(8) NOT NULL                                                    
,STATUS_A_REASON VARCHAR2(255)                                                  
,STATUS_B NUMBER(8) NOT NULL                                                    
,STATUS_B_REASON VARCHAR2(255)                                                  
,CONSTRAINT T_TEST1_PK PRIMARY KEY (ID)                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table T_TEST2                                                          
create table T_TEST2(                                                           
ID NUMBER(30) NOT NULL                                                          
,VALUE_2 NUMBER(30)                                                             
,STATUS_C NUMBER(8) NOT NULL                                                    
,STATUS_C_REASON VARCHAR2(255)                                                  
,TEST1_ID NUMBER(30) NOT NULL                                                   
,CONSTRAINT T_TEST2_PK PRIMARY KEY (ID)                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table T_TEST3                                                          
create table T_TEST3(                                                           
ID NUMBER(30) NOT NULL                                                          
,NUMBER_1 NUMBER(30)                                                            
,NUMBER_2 NUMBER(30)                                                            
,NUMBER_3 NUMBER(30)                                                            
,NUMBER_4 NUMBER(30)                                                            
,NUMBER_5 NUMBER(30)                                                            
,DOUBLE_1 NUMBER(30,10)                                                         
,DOUBLE_2 NUMBER(30,10)                                                         
,DOUBLE_3 NUMBER(30,10)                                                         
,DOUBLE_4 NUMBER(30,10)                                                         
,DOUBLE_5 NUMBER(30,10)                                                         
,VAR_1 VARCHAR2(255)                                                            
,VAR_2 VARCHAR2(255)                                                            
,VAR_3 VARCHAR2(255)                                                            
,VAR_4 VARCHAR2(255)                                                            
,VAR_5 VARCHAR2(255)                                                            
,DATE_1 DATE                                                                    
,DATE_2 DATE                                                                    
,DATE_3 DATE                                                                    
,DATE_4 DATE                                                                    
,DATE_5 DATE                                                                    
,STATUS_A NUMBER(8)                                                             
,STATUS_A_REASON VARCHAR2(255)                                                  
,TEST2_ID NUMBER(30)                                                            
,STATUS_B NUMBER(8)                                                             
,CONSTRAINT T_TEST3_PK PRIMARY KEY (ID)                                         
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table T_TEST_3                                                         
create table T_TEST_3(                                                          
ID NUMBER(30) NOT NULL                                                          
,VALUE_2 NUMBER(30)                                                             
,CONSTRAINT T_TEST_3_PK PRIMARY KEY (ID)                                        
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table T_TEST_TABLE                                                     
create table T_TEST_TABLE(                                                      
ID NUMBER(30) NOT NULL                                                          
,TYPE NUMBER(3)                                                                 
,MY_DATE DATE NOT NULL                                                          
,STATUS NUMBER(10)                                                              
,MY_BOOL NUMBER(1)                                                              
,EXTERNAL_REF VARCHAR2(255)                                                     
,ATTR NUMBER(30)                                                                
,MY_FRACTION NUMBER(30,10)                                                      
,USER_COMMENT VARCHAR2(255)                                                     
,MY_BINFLD BLOB                                                                 
,CONSTRAINT TEST_TABLE_PK PRIMARY KEY (ID)                                      
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table T_TEST_TABLE_EXT                                                 
create table T_TEST_TABLE_EXT(                                                  
ID NUMBER(30) NOT NULL                                                          
,MY_EXT VARCHAR2(255)                                                           
,CONSTRAINT T_TEST_TABLE_EXT_PK PRIMARY KEY (ID)                                
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--create table ZIV_CON_HEEP_OUT                                                 
create table ZIV_CON_HEEP_OUT(                                                  
ADDRESS_ID NUMBER(30)                                                           
,URL VARCHAR2(255) NOT NULL                                                     
)                                                                               
TABLESPACE USERS STORAGE (INITIAL 131072 NEXT 131072 MINEXTENTS 1 MAXEXTENTS    
4096 PCTINCREASE 0)  PCTFREE 10 PCTUSED 40                                      
;                                                                               
--                                                                              
--                                                                              
--creating foreign key constraints                                              
--                                                                              
alter table A_DATA_MAPPING add(constraint DATA_MAPPING_NAMER_FK foreign         
key(NAMER_ID) references A_NAMER(ID));                                          
--                                                                              
alter table M_ALLOCATION_TEMPLATE add(constraint FK_M_ALLOCATION_TEMPLATE_ORG   
foreign key(PARENT_ORG) references A_ORGANIZATION(ID));                         
--                                                                              
alter table M_ALLOCATION_TEMPLATE_2_FUNDS add(constraint                        
FK_M_ALLOC_TEMP_2_FUNDS_ALLOC foreign key(ALLOC_TEMPLATE_ID) references         
M_ALLOCATION_TEMPLATE(ID));                                                     
--                                                                              
alter table M_ALLOCATION_TEMPLATE_2_FUNDS add(constraint                        
FK_M_ALLOC_TEMP_2_FUNDS_FUND foreign key(FUND_ID) references                    
A_ORGANIZATION(ID));                                                            
--                                                                              
alter table M_CUT_OF_TIME_ZONE add(constraint FK_M_CUT_OF_TIME_ZONE_CENTER      
foreign key(CALENDAR_CENTER) references A_CALENDAR_CENTER(ID));                 
--                                                                              
alter table M_FX_NOE add(constraint FK_M_FX_NOE_ENTERED_BY foreign              
key(ENTERED_BY) references A_ORGANIZATION(ID));                                 
--                                                                              
alter table M_FX_NOE add(constraint FK_M_FX_NOE_PARENT foreign key(ID)          
references A_TA(ID));                                                           
--                                                                              
alter table M_FX_NOE add(constraint FK_M_FX_NOE_PRIME_BROKER foreign            
key(PRIME_BROKER) references A_ORGANIZATION(ID));                               
--                                                                              
alter table M_FX_NOE add(constraint FK_M_FX_NOE_USER foreign key(USER_ID)       
references A_PERSON(ID));                                                       
--                                                                              
alter table M_FX_OA_ALLOCATION add(constraint FK_M_FX_OA_ALLOCATION_FUND foreign
key(FUND) references A_ORGANIZATION(ID));                                       
--                                                                              
alter table M_FX_OA_ALLOCATION add(constraint FK_M_FX_OA_ALLOCATION_OA foreign  
key(FX_OA_ID) references M_FX_OA(ID));                                          
--                                                                              
alter table M_FX_OA_ALLOCATION add(constraint FK_M_FX_OA_ALLOCATION_PARENT      
foreign key(ID) references A_OA_ALLOCATION(ID));                                
--                                                                              
alter table M_FX_OA add(constraint FK_M_FX_OA_PARENT foreign key(ID) references 
A_OA(ID));                                                                      
--                                                                              
alter table M_FX_OA add(constraint FK_M_FX_OA_TRADING_PARTY foreign             
key(TRADING_PARTY) references A_ORGANIZATION(ID));                              
--                                                                              
alter table M_FX_OA add(constraint FK_M_FX_OA_USER foreign key(USER_ID)         
references A_PERSON(ID));                                                       
--                                                                              
alter table M_FX_OA add(constraint FK_M_FX_OA_USER_PARTY foreign key(USER_PARTY)
references A_ORGANIZATION(ID));                                                 
--                                                                              
alter table M_FX_OPTION_NOE add(constraint FK_M_FX_OPTION_NOE_ENTERED_BY foreign
key(ENTERED_BY) references A_ORGANIZATION(ID));                                 
--                                                                              
alter table M_FX_OPTION_NOE add(constraint FK_M_FX_OPTION_NOE_PARENT foreign    
key(ID) references A_TA(ID));                                                   
--                                                                              
alter table M_FX_OPTION_NOE add(constraint FK_M_FX_OPTION_NOE_PRIMEBROKER       
foreign key(PRIME_BROKER) references A_ORGANIZATION(ID));                       
--                                                                              
alter table M_FX_OPTION_NOE add(constraint FK_M_FX_OPTION_NOE_TIMEZONE foreign  
key(CUT_OF_TIME_ZONE) references M_CUT_OF_TIME_ZONE(ID));                       
--                                                                              
alter table M_FX_OPTION_NOE add(constraint FK_M_FX_OPTION_NOE_USER foreign      
key(USER_ID) references A_PERSON(ID));                                          
--                                                                              
alter table M_FX_TRADE add(constraint FK_M_FX_TRADE_PARENT foreign key(ID)      
references A_TA(ID));                                                           
--                                                                              
alter table M_ORGANIZATION_EXT add(constraint FK_M_ORGANIZATION_EXT_PARENT      
foreign key(ID) references A_ORGANIZATION(ID));                                 
--                                                                              
alter table M_PERSON_EXT add(constraint FK_M_PERSON_EXT_PARENT foreign key(ID)  
references A_PERSON(ID));                                                       
--                                                                              
alter table M_REGION_2_CALENDAR_CENTER add(constraint                           
FK_M_REGION_2_CALENDAR_CENTER foreign key(CALENDAR_CENTER) references           
A_CALENDAR_CENTER(ID));                                                         
--                                                                              
alter table M_REGION_2_CALENDAR_CENTER add(constraint                           
FK_M_REGION_2_CALENDAR_REGION foreign key(REGION) references M_REGION(ID));     
--                                                                              
alter table A_FLOW add(constraint FLOW_FLOW_DEF_FK foreign key(FLOW_DEF_ID)     
references A_FLOW_DEF(ID));                                                     
--                                                                              
alter table A_OA_ALLOCATION add(constraint FUND_ACCOUNT_ID_FK foreign           
key(FUND_ACCOUNT_ID) references A_ACCOUNT(ID));                                 
--                                                                              
alter table A_LOG add(constraint LOG_LOG_MESSAGES_FK foreign key(MSG_ID)        
references A_LOG_MESSAGES(MSG_ID));                                             
--                                                                              
alter table M_COMBINATION_2_BILLING_LINE add(constraint                         
M_COMBINATION_2_BILLING_FK1 foreign key(BILLING_LINE_ID) references             
A_BILLING_LINE(ID));                                                            
--                                                                              
alter table M_FX_NOE_2_POS_COMBINATION add(constraint M_FX_NOE_2_POS_COM_FX_FK  
foreign key(FX_NOE_ID) references A_TA(ID));                                    
--                                                                              
alter table M_PORTFOLIO add(constraint M_PORTFOLIO_PARENT_ORG_FK foreign        
key(PARENT_ORG) references A_ORGANIZATION(ID));                                 
--                                                                              
alter table M_TRADER add(constraint M_TRADER_PARENT_ORG_FK foreign              
key(PARENT_ORG) references A_ORGANIZATION(ID));                                 
--                                                                              
alter table A_GENERIC_NOE_DEALS add(constraint NOE_REQUEST_DEALS_CONSTRAINT     
foreign key(REQUEST_DEALS_ID) references A_GENERIC_REQUEST_DEALS(ID));          
--                                                                              
alter table A_NOTIFICATION add(constraint NOTIFICATION_EVENT_FK foreign key(ID) 
references A_EVENT(ID));                                                        
--                                                                              
alter table A_GENERIC_OA_DEALS add(constraint OA_REQUEST_DEALS_CONSTRAINT       
foreign key(REQUEST_DEALS_ID) references A_GENERIC_REQUEST_DEALS(ID));          
--                                                                              
alter table A_OA add(constraint ORG_ACCOUNT_ID_FK foreign key(ORG_ACCOUNT_ID)   
references A_ACCOUNT(ID));                                                      
--                                                                              
alter table D_ALIAS_DEF add(constraint OUT_PARAM_FK foreign key(OUT_PARAM)      
references D_ALIAS_OUT_PARAM(OUT_PARAM_ID));                                    
--                                                                              
alter table A_TA add(constraint SECONDERY_INSTRUMENT_ID_FK foreign              
key(SECONDERY_INSTRUMENT_ID) references A_INSTRUMENT_BASE(ID));                 
--                                                                              
alter table A_TA add(constraint SELLER_ACCOUNT_ID_FK foreign                    
key(SELLER_ACCOUNT_ID) references A_ACCOUNT(ID));                               
--                                                                              
alter table A_ROLL_TXN add(constraint A_ROLL_TXN_PROTOCOL_INFO_FK foreign       
key(MSG_PROTOCOL_INFO_ID) references A_MSG_PROTOCOL_INFO(ID));                  
--                                                                              
alter table A_SECURITY_PRINCIPAL_ROLE add(constraint                            
A_SCRTY_PRNCPL_ROLE_PRNCPL_FK foreign key(PRINCIPAL_ID) references              
A_SECURITY_PRINCIPAL(ID));                                                      
--                                                                              
alter table A_SECURITY_PRINCIPAL_ROLE add(constraint A_SCRTY_PRNCPL_ROLE_ROLE_FK
foreign key(ROLE_ID) references A_ROLE(ID));                                    
--                                                                              
alter table A_SECURITY_GROUP add(constraint A_SEC_GRP_PRNCPL_FK foreign key(ID) 
references A_SECURITY_PRINCIPAL(ID));                                           
--                                                                              
alter table A_SECURITY_PERMISSION add(constraint A_SEC_PERMISSION_ROLE_FK       
foreign key(ROLE_ID) references A_ROLE(ID));                                    
--                                                                              
alter table A_SECURITY_PERMISSION add(constraint A_SEC_PERMISSION_SEC_RSRC_FK   
foreign key(RESOURCE_ID) references A_SECURITY_RESOURCE(ID));                   
--                                                                              
alter table A_SECURITY_PRINCIPAL_GROUP add(constraint A_SEC_PRINCPL_GRP_GRP_FK  
foreign key(GROUP_ID) references A_SECURITY_GROUP(ID));                         
--                                                                              
alter table A_SECURITY_PRINCIPAL_GROUP add(constraint                           
A_SEC_PRINCPL_GRP_PRNCPL_FK foreign key(PRINCIPAL_ID) references                
A_SECURITY_PRINCIPAL(ID));                                                      
--                                                                              
alter table A_SECURITY_USER_LOCKS_HISTORY add(constraint                        
A_SEC_USER_LCKS_HIS_USER_FK foreign key(USER_ID) references                     
A_SECURITY_USER(ID));                                                           
--                                                                              
alter table A_SECURITY_USER add(constraint A_SEC_USER_PERSON_ID_FK foreign      
key(PERSON_ID) references A_PERSON(ID));                                        
--                                                                              
alter table A_SECURITY_USER add(constraint A_SEC_USER_PERSON_NAME_FK foreign    
key(USER_NAME) references A_PERSON(USER_NAME));                                 
--                                                                              
alter table A_SECURITY_USER add(constraint A_SEC_USER_PRNCPL_FK foreign key(ID) 
references A_SECURITY_PRINCIPAL(ID));                                           
--                                                                              
alter table A_SECURITY_USER_PWD_HISTORY add(constraint                          
A_SEC_USER_PWD_HIS_USER_FK foreign key(USER_ID) references A_SECURITY_USER(ID));
--                                                                              
alter table A_TRANSITION add(constraint A_TRAN_CHILD_STATE_FROM_FK foreign      
key(CHILD_STATE_FROM) references A_TRANSITION_STATE(ID));                       
--                                                                              
alter table A_TRANSITION add(constraint A_TRAN_CHILD_STATE_TO_FK foreign        
key(CHILD_STATE_TO) references A_TRANSITION_STATE(ID));                         
--                                                                              
alter table A_TRANSITION add(constraint A_TRAN_PARENT_STATE_FROM_FK foreign     
key(PARENT_STATE_FROM) references A_TRANSITION_STATE(ID));                      
--                                                                              
alter table A_TRANSITION add(constraint A_TRAN_PARENT_STATE_TO_FK foreign       
key(PARENT_STATE_TO) references A_TRANSITION_STATE(ID));                        
--                                                                              
alter table A_UID add(constraint A_UID_A_CONV_FK foreign key(CONVERSATION_ID)   
references A_CONVERSATION(ID));                                                 
--                                                                              
alter table A_UID add(constraint A_UID_BUSINESS_PROCESS_FK foreign              
key(BUSINESS_PROCESS_ID) references A_BUSINESS_PROCESS(ID));                    
--                                                                              
alter table A_VAL_FUNCTION_PARAM add(constraint A_VAL_FUNC_PAR_FUNCTION_FK      
foreign key(FUNCTION_ID) references A_VAL_MARKET_FUNCTION(ID));                 
--                                                                              
alter table A_VAL_MARKET_CONTEXT add(constraint A_VAL_MARKET_CON_FUNC_FK foreign
key(FUNCTION_ID) references A_VAL_MARKET_FUNCTION(ID));                         
--                                                                              
alter table A_VAL_MARKET_2_SOURCE_DATA add(constraint                           
A_VAL_MAR_2_SOU_DATA_MAR_FK foreign key(MARKET_DATA_ID) references              
A_VAL_MARKET_DATA(ID));                                                         
--                                                                              
alter table A_VAL_MARKET_2_SOURCE_DATA add(constraint                           
A_VAL_MAR_2_SOU_DATA_SOU_FK foreign key(SOURCE_DATA_ID) references              
A_VAL_SOURCE_DATA(ID));                                                         
--                                                                              
alter table A_VAL_MD_DISCOUNT_CURVE add(constraint A_VAL_MD_DISC_CURVE_INST     
foreign key(INSTRUMENT_ID) references A_INSTRUMENT_BASE(ID));                   
--                                                                              
alter table A_VAL_MD_INTEREST_RATE add(constraint A_VAL_MD_INTE_RATE_INST_FK    
foreign key(INSTRUMENT_ID) references A_INSTRUMENT_BASE(ID));                   
--                                                                              
alter table A_VAL_MD_OPTION add(constraint A_VAL_MD_OPTION_TA_FK foreign        
key(TA_ID) references A_TA(ID));                                                
--                                                                              
alter table A_VAL_MD_CURRENCY add(constraint A__VAL_MD_CUR_INSTRUMENT_FK foreign
key(INSTRUMENT_ID) references A_INSTRUMENT_CURRENCY(ID));                       
--                                                                              
alter table A_TA add(constraint BASE_INSTRUMENT_ID_FK foreign                   
key(BASE_INSTRUMENT_ID) references A_INSTRUMENT_BASE(ID));                      
--                                                                              
alter table A_TA add(constraint BUYER_ACCOUNT_ID_FK foreign                     
key(BUYER_ACCOUNT_ID) references A_ACCOUNT(ID));                                
--                                                                              
alter table D_ALIAS_INFO add(constraint CATEGORY_FK foreign key(CATEGORY)       
references D_ALIAS_CATEGORY(CATEGORY_ID));                                      
--                                                                              
alter table A_CODE_MEMBER add(constraint CODE_MEMBER_CODE_GROUP_FK foreign      
key(GROUP_ID) references A_CODE_GROUP(ID));                                     
--                                                                              
alter table A_CON_DIR_IN add(constraint CON_DIR_IN_ADDRESS_FK foreign           
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_CON_DIR_OUT add(constraint CON_DIR_OUT_ADDRESS_FK foreign         
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_CON_FTP_OUT add(constraint CON_FTP_ADDRESS_OUT_FK foreign         
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_CON_FTP_IN add(constraint CON_FTP_IN_ADDRESS_FK foreign           
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_CON_HEADER_DATA add(constraint CON_HEADER_DATA_PARTNER_FK foreign 
key(PARTNER_ID) references A_PARTNER(ID));                                      
--                                                                              
alter table A_CON_HTTP_OUT add(constraint CON_HTTP_OUT_ADDRESS_FK foreign       
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_CON_MAIL_IN add(constraint CON_MAIL_IN_ADDRESS_FK foreign         
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_CON_MAIL_OUT add(constraint CON_MAIL_OUT_ADDRESS_FK foreign       
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_CON_MQ_IN add(constraint CON_MQ_IN_ADDRESS_FK foreign             
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_CON_MQ_OUT add(constraint CON_MQ_OUT_ADDRESS_FK foreign           
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_MSG_TOKEN add(constraint A_MSG_TOKEN foreign key(PROTOCOL_MSG_ID) 
references A_MSG_PROTOCOL_INFO(ID));                                            
--                                                                              
alter table A_ORG_2_ACCOUNT add(constraint A_ORG_2_ACC_ACC_FK foreign           
key(ACCOUNT_ID) references A_ACCOUNT(ID));                                      
--                                                                              
alter table A_ORG_2_ACCOUNT add(constraint A_ORG_2_ACC_ORG_FK foreign           
key(ORG_ID) references A_ORGANIZATION(ID));                                     
--                                                                              
alter table A_ORG_2_ACCOUNT add(constraint A_ORG_2_ACC_ROLE_FK foreign key(ROLE)
references A_ROLE(ID));                                                         
--                                                                              
alter table A_ORG_2_ADDRESS add(constraint A_ORG_2_ADD_ADD_FK foreign           
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_ORG_2_ADDRESS add(constraint A_ORG_2_ADD_ORG_FK foreign           
key(ORG_ID) references A_ORGANIZATION(ID));                                     
--                                                                              
alter table A_ORG_2_ADDRESS add(constraint A_ORG_2_ADD_ROLE_FK foreign key(ROLE)
references A_ROLE(ID));                                                         
--                                                                              
alter table A_ORG_2_DL add(constraint A_ORG_2_DL_DL_FK foreign key(DL_ID)       
references A_DL(ID));                                                           
--                                                                              
alter table A_ORG_2_DL add(constraint A_ORG_2_DL_ORG_FK foreign key(ORG_ID)     
references A_ORGANIZATION(ID));                                                 
--                                                                              
alter table A_ORG_2_DL add(constraint A_ORG_2_DL_ROLE_FK foreign key(ROLE)      
references A_ROLE(ID));                                                         
--                                                                              
alter table A_ORG_2_ORG add(constraint A_ORG_2_ORG_FROM_ORG_FK foreign          
key(FROM_ORG_ID) references A_ORGANIZATION(ID));                                
--                                                                              
alter table A_ORG_2_ORG add(constraint A_ORG_2_ORG_ROLE_FK foreign key(ROLE)    
references A_ROLE(ID));                                                         
--                                                                              
alter table A_ORG_2_ORG add(constraint A_ORG_2_ORG_TO_ORG_FK foreign            
key(TO_ORG_ID) references A_ORGANIZATION(ID));                                  
--                                                                              
alter table A_ORG_2_PERSON add(constraint A_ORG_2_PER_ORG_FK foreign key(ORG_ID)
references A_ORGANIZATION(ID));                                                 
--                                                                              
alter table A_ORG_2_PERSON add(constraint A_ORG_2_PER_PER_FK foreign            
key(PERSON_ID) references A_PERSON(ID));                                        
--                                                                              
alter table A_ORG_2_PERSON add(constraint A_ORG_2_PER_ROLE_FK foreign key(ROLE) 
references A_ROLE(ID));                                                         
--                                                                              
alter table A_ORG_2_RECON_COMBINATION add(constraint A_ORG_2_REC_COMB_COMB_FK   
foreign key(COMBINATION_ID) references A_RECON_COMBINATION(ID));                
--                                                                              
alter table A_ORG_2_RECON_COMBINATION add(constraint A_ORG_2_REC_COMB_ORG_FK    
foreign key(ORG_ID) references A_ORGANIZATION(ID));                             
--                                                                              
alter table A_ORG_2_RECON_COMBINATION add(constraint A_ORG_2_REC_COMB_ROLE_FK   
foreign key(ROLE) references A_ROLE(ID));                                       
--                                                                              
alter table A_ORG_ROLE add(constraint A_ORG_ROLE_ORG_FK foreign key(ORG_ID)     
references A_ORGANIZATION(ID));                                                 
--                                                                              
alter table A_ORG_ROLE add(constraint A_ORG_ROLE_ROLE_FK foreign key(ROLE)      
references A_ROLE(ID));                                                         
--                                                                              
alter table A_PARTNER_2_MSG_GROUP add(constraint A_PARTNER_2_MSG_GRP_A_PARTNER  
foreign key(PARTNER_ID) references A_PARTNER(ID));                              
--                                                                              
alter table A_PARTNER add(constraint A_PARTNER_ORG_FK foreign key(ID) references
A_ORGANIZATION(ID));                                                            
--                                                                              
alter table A_PERSON_2_ACCOUNT add(constraint A_PER_2_ACC_ACC_FK foreign        
key(ACCOUNT_ID) references A_ACCOUNT(ID));                                      
--                                                                              
alter table A_PERSON_2_ACCOUNT add(constraint A_PER_2_ACC_PER_FK foreign        
key(PERSON_ID) references A_PERSON(ID));                                        
--                                                                              
alter table A_PERSON_2_ACCOUNT add(constraint A_PER_2_ACC_ROLE_FK foreign       
key(ROLE) references A_ROLE(ID));                                               
--                                                                              
alter table A_PERSON_2_ADDRESS add(constraint A_PER_2_ADD_ADD_FK foreign        
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_PERSON_2_ADDRESS add(constraint A_PER_2_ADD_PER_FK foreign        
key(PERSON_ID) references A_PERSON(ID));                                        
--                                                                              
alter table A_PERSON_2_ADDRESS add(constraint A_PER_2_ADD_ROLE_FK foreign       
key(ROLE) references A_ROLE(ID));                                               
--                                                                              
alter table A_PERSON_ROLE add(constraint A_PER_ROLE_PER_FK foreign              
key(PERSON_ID) references A_PERSON(ID));                                        
--                                                                              
alter table A_PERSON_ROLE add(constraint A_PER_ROLE_ROLE_FK foreign key(ROLE)   
references A_ROLE(ID));                                                         
--                                                                              
alter table A_POSITION_SEMI_AGG_INSTR_2_TA add(constraint                       
A_POS_SEMI_AGG_INSTR_FK foreign key(POSITION_SEMI_AGG_INSTR_ID) references      
A_POSITION_SEMI_AGG_INSTR(ID));                                                 
--                                                                              
alter table A_POSITION_SEMI_AG_IN_2_TA_HIS add(constraint                       
A_POS_SEMI_AGG_INSTR_HIS_FK foreign key(POSITION_SEMI_AG_IN_HIS_ID) references  
A_POSITION_SEMI_AG_IN_HIS(ID));                                                 
--                                                                              
alter table A_POSITION_SEMI_AGG_TRADE_2_TA add(constraint                       
A_POS_SEMI_AGG_TRADE_FK foreign key(POSITION_SEMI_AGG_TRADE_ID) references      
A_POSITION_SEMI_AGG_TRADE(ID));                                                 
--                                                                              
alter table A_POSITION_SEMI_AG_TR_2_TA_HIS add(constraint                       
A_POS_SEMI_AGG_TRADE_HIS_FK foreign key(POSITION_SEMI_AG_TR_HIS_ID) references  
A_POSITION_SEMI_AG_TR_HIS(ID));                                                 
--                                                                              
alter table A_PROFILE_PROPERTY add(constraint A_PROFILE_PROPERTY_FK1 foreign    
key(PROFILE_OWNER_ID) references A_PROFILE_OWNER(ID));                          
--                                                                              
alter table A_RECON_COMBINATION_2_RECON add(constraint                          
A_RECON_COMB_2_REC_REC_FK1 foreign key(RECON_ID) references A_RECON_DEF(ID));   
--                                                                              
alter table A_CREDIT_LINE_2_UCM add(constraint A_CREDIT_LINE_2_UCM_UCM_FK       
foreign key(UCM_ID) references A_CREDIT_UCM(ID));                               
--                                                                              
alter table A_CREDIT_RESULTS add(constraint A_CREDIT_RESULTS_ACCOUNT_FK foreign 
key(ID) references A_CREDIT_ACCOUNT(ID));                                       
--                                                                              
alter table A_CREDIT_RESULTS_HISTORY add(constraint A_CREDIT_RES_HIS_ACC_FK     
foreign key(CREDIT_ACCOUNT_ID) references A_CREDIT_ACCOUNT(ID));                
--                                                                              
alter table A_CREDIT_POS_BASIS_2_UCM add(constraint A_CRE_POSBASIS_2_UCM_FK     
foreign key(UCM_ID) references A_CREDIT_UCM(ID));                               
--                                                                              
alter table A_CREDIT_POS_CALL_2_UCM add(constraint A_CRE_POSCALL_2_UCM_UCM_FK   
foreign key(UCM_ID) references A_CREDIT_UCM(ID));                               
--                                                                              
alter table A_DL_DETAIL add(constraint A_DL_DETAIL_ADDRESS_FK foreign           
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_DL_DETAIL add(constraint A_DL_DETAIL_BATCH_PARAM_FK foreign       
key(BATCH_PARAM_ID) references A_BATCH_PARAM(ID));                              
--                                                                              
alter table A_DL_DETAIL add(constraint A_DL_DETAIL_DL_FK foreign key(DL_ID)     
references A_DL(ID));                                                           
--                                                                              
alter table A_EVENT_2_DL add(constraint A_EVENT_2_DL_A_DL_FK foreign key(DL_ID) 
references A_DL(ID));                                                           
--                                                                              
alter table A_EVENT_2_DL add(constraint A_EVENT_2_DL_A_EVENT_FK foreign         
key(EVENT_ID) references A_EVENT(ID));                                          
--                                                                              
alter table A_ALERT_EVENT add(constraint A_EVENT_FK foreign key(EVENT_ID)       
references A_EVENT(ID));                                                        
--                                                                              
alter table A_EVENT_GROUP add(constraint A_EVENT_GROUP_EVENT_FK foreign         
key(EVENT_ID) references A_EVENT(ID));                                          
--                                                                              
alter table A_INSTRUMENT_2_FIN_CENTER add(constraint A_FINANCIAL_CENTER_ID_FK   
foreign key(FINANCIAL_CENTER_ID) references A_CALENDAR_CENTER(ID));             
--                                                                              
alter table A_FLOW add(constraint A_FLOW_BP_FK foreign key(BUSINESS_PROCESS_ID) 
references A_BUSINESS_PROCESS(ID));                                             
--                                                                              
alter table A_FLOW add(constraint A_FLOW_CONV_FK foreign key(CONVERSATION_ID)   
references A_CONVERSATION(ID));                                                 
--                                                                              
alter table A_MSG_LOGIC_INFO add(constraint A_FLOW_DEF_FK1 foreign key(FLOW_ID) 
references A_FLOW_DEF(ID));                                                     
--                                                                              
alter table A_MSG_LOGIC_INFO add(constraint A_FLOW_DEF_FK2 foreign              
key(PRE_FLOW_ID) references A_FLOW_DEF(ID));                                    
--                                                                              
alter table A_INSTRUMENT_2_FIN_CENTER add(constraint A_INSTRUMENT_ID_FK foreign 
key(INSTRUMENT_ID) references A_INSTRUMENT_BASE(ID));                           
--                                                                              
alter table A_INSTRUMENT_BARRIER_OPTION add(constraint                          
A_I_BARRIER_OPTION_I_OPTION_PK foreign key(ID) references                       
A_INSTRUMENT_OPTION(ID));                                                       
--                                                                              
alter table A_INSTRUMENT_BARRIER_CAP_FLOOR add(constraint                       
A_I_BARR_CAP_FL_I_CAP_FL_FK foreign key(ID) references                          
A_INSTRUMENT_CAP_FLOOR(ID));                                                    
--                                                                              
alter table A_INSTRUMENT_BERM_OPT_EX_DATE add(constraint                        
A_I_BERM_OPT_EX_DATE_I_OPT_FK foreign key(INSTRUMENT_OPTION_ID) references      
A_INSTRUMENT_OPTION(ID));                                                       
--                                                                              
alter table A_INSTRUMENT_BINARY_OPTION add(constraint                           
A_I_BINARY_OPTION_I_OPTION_FK foreign key(ID) references                        
A_INSTRUMENT_OPTION(ID));                                                       
--                                                                              
alter table A_INSTRUMENT_CAP_FLOOR add(constraint A_I_CAP_FLOOR_I_FL_INT_PAY_FK 
foreign key(ID) references A_INSTRUMENT_FLOAT_INTER_PAY(ID));                   
--                                                                              
alter table A_INSTRUMENT_CURRENCY add(constraint A_I_CURRENCY_I_BASE_FK foreign 
key(ID) references A_INSTRUMENT_BASE(ID));                                      
--                                                                              
alter table A_INSTRUMENT_FIX_RATE_BOND add(constraint                           
A_I_FIX_RATE_BOND_I_INT_PAY_FK foreign key(ID) references                       
A_INSTRUMENT_INTEREST_PAYMENTS(ID));                                            
--                                                                              
alter table A_INSTRUMENT_FLOAT_INTER_PAY add(constraint A_I_FLOAT_INTER_PAY_FK  
foreign key(ID) references A_INSTRUMENT_INTEREST_PAYMENTS(ID));                 
--                                                                              
alter table A_INSTRUMENT_FX_SWAP_LEG add(constraint A_I_FX_SWAP_LEG_I_BASE_FK   
foreign key(ID) references A_INSTRUMENT_BASE(ID));                              
--                                                                              
alter table A_INSTRUMENT_INTEREST_PAYMENTS add(constraint                       
A_I_INTEREST_PAY_I_BASE_FK foreign key(ID) references A_INSTRUMENT_BASE(ID));   
--                                                                              
alter table A_INSTRUMENT_OPTION add(constraint A_I_OPTION_I_BASE_FK foreign     
key(ID) references A_INSTRUMENT_BASE(ID));                                      
--                                                                              
alter table A_LOG_MESSAGES add(constraint A_LOG_MESSAGES_DEVISION_FK foreign    
key(LOG_MSG_DEVISION) references A_LOG_MSG_DEVISION(ID));                       
--                                                                              
alter table A_MSG_GROUP_DETAIL add(constraint A_MSG_GRP_MSG_PRTCL_INF_FK foreign
key(PROTOCOL_MSG_ID) references A_MSG_PROTOCOL_INFO(ID));                       
--                                                                              
alter table A_MSG_PROTOCOL_INFO add(constraint A_MSG_PRTCL_MSG_LOG_INF_FK       
foreign key(LOGIC_MSG_ID) references A_MSG_LOGIC_INFO(ID));                     
--                                                                              
alter table D_ALIAS_INFO add(constraint ALIAS_DEFIN_FK foreign key(ALIAS_DEF)   
references D_ALIAS_DEF(DEF_ID));                                                
--                                                                              
alter table D_ALIAS_IN_PARAM add(constraint ALIAS_DEF_FK foreign key(ALIAS_DEF) 
references D_ALIAS_DEF(DEF_ID));                                                
--                                                                              
alter table A_VAL_SOURCE_DATA_TYPE add(constraint ARC_VAL_SOU_DATA_TYPE_COD_G_FK
foreign key(CODE_GROUP_ID) references A_CODE_GROUP(ID));                        
--                                                                              
alter table A_ACCOUNT_ROLE add(constraint A_ACC_ROLE_ACC_FK foreign             
key(ACCOUNT_ID) references A_ACCOUNT(ID));                                      
--                                                                              
alter table A_ACCOUNT_ROLE add(constraint A_ACC_ROLE_ROLE_FK foreign key(ROLE)  
references A_ROLE(ID));                                                         
--                                                                              
alter table A_ADDRESS add(constraint A_ADDRESS_CON_PROTOCOLS_FK foreign         
key(PROTOCOL_ID) references A_CON_PROTOCOLS(ID));                               
--                                                                              
alter table A_BATCH_DATA add(constraint A_BATCH_DATA_ADDRESS_FK foreign         
key(ADDRESS_ID) references A_ADDRESS(ID));                                      
--                                                                              
alter table A_BATCH_DATA add(constraint A_BATCH_DATA_A_CONVERSATION_FK foreign  
key(CONV_ID) references A_CONVERSATION(ID));                                    
--                                                                              
alter table A_BATCH_DATA add(constraint A_BATCH_DATA_A_EVENT_FK foreign         
key(EVENT_ID) references A_EVENT(ID));                                          
--                                                                              
alter table A_BATCH_DATA add(constraint A_BATCH_DATA_BATCH_PARAM_FK foreign     
key(BATCH_PARAM_ID) references A_BATCH_PARAM(ID));                              
--                                                                              
alter table A_BATCH_DATA add(constraint A_BATCH_DATA_BUS_PROCESS_FK foreign     
key(BP_ID) references A_BUSINESS_PROCESS(ID));                                  
--                                                                              
alter table A_BATCH_DIRECT add(constraint A_BATCH_DIRECT_BAT_PARAM_FK foreign   
key(BATCH_PARAM_ID) references A_BATCH_PARAM(ID));                              
--                                                                              
alter table A_BATCH_DIRECT add(constraint A_BATCH_DIRECT_EVENT_FK foreign       
key(EVENT_ID) references A_EVENT(ID));                                          
--                                                                              
alter table A_BILLING_CCY_PAIR add(constraint A_BILLING_CCY_PAIR_FCCY_FK foreign
key(FIRST_CCY_ID) references A_INSTRUMENT_BASE(ID));                            
--                                                                              
alter table A_BILLING_CCY_PAIR add(constraint A_BILLING_CCY_PAIR_SCCY_FK foreign
key(SECOND_CCY_ID) references A_INSTRUMENT_BASE(ID));                           
--                                                                              
alter table A_BILLING_CCY_PAIR_2_FIN_CNTR add(constraint                        
A_BLNG_CCY_PAIR_FIN_CNTR_ID_FK foreign key(FINANCIAL_CENTER_ID) references      
A_CALENDAR_CENTER(ID));                                                         
--                                                                              
alter table A_CALENDAR_HOLIDAY add(constraint A_CALENDAR_HOLIDA_TYP_ID_FK       
foreign key(TYPE_ID) references A_CALENDAR_HOLIDAY_TYPE(ID));                   
--                                                                              
alter table A_CALENDAR_HOLIDAY add(constraint A_CALENDAR_HOLID_CENTER_FK foreign
key(CENTER_ID) references A_CALENDAR_CENTER(ID));                               
--                                                                              
alter table A_BILLING_CCY_PAIR_2_FIN_CNTR add(constraint A_CCY_PAIR_ID_FK       
foreign key(CCY_PAIR_ID) references A_BILLING_CCY_PAIR(ID));                    
--                                                                              
alter table A_VAL_MARKET_CONTEXT add(constraint A_CONTEXT_MARKET_DATA_FK foreign
key(MARKET_DATA_ID) references A_VAL_MARKET_DATA(ID));                          
--                                                                              
alter table A_CONVERSATION add(constraint A_CONV_BUSINESS_PROCESS_FK foreign    
key(BUSINESS_PROCESS_ID) references A_BUSINESS_PROCESS(ID));                    
--                                                                              
alter table A_CON_DB add(constraint A_CON_DB_ADDRESS_FK foreign key(ADDRESS_ID) 
references A_ADDRESS(ID));                                                      
--                                                                              
alter table A_CREDIT_ACCOUNT add(constraint A_CREDIT_ACCOUNT_ACCOUNT_FK foreign 
key(ACCOUNT_ID) references A_ACCOUNT(ID));                                      
--                                                                              
alter table A_CREDIT_ACCOUNT add(constraint A_CREDIT_ACCOUNT_CL_FK foreign      
key(CREDIT_LINE_ID) references A_CREDIT_LINE(ID));                              
--                                                                              
alter table A_CREDIT_ACCOUNT add(constraint A_CREDIT_ACCOUNT_UCM_FK foreign     
key(UCM_ID) references A_CREDIT_UCM(ID));                                       
--                                                                              
alter table A_CREDIT_LINE_2_UCM add(constraint A_CREDIT_LINE_2_UCM_CL_FK foreign
key(CREDIT_LINE_ID) references A_CREDIT_LINE(ID));                              
--                                                                              
alter table ZIV_CON_HEEP_OUT add(constraint Z_FK foreign key(ADDRESS_ID)        
references A_ADDRESS(ID));                                                      
