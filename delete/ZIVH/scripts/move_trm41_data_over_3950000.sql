--connect as the target schema
set echo on
spool move.log
set serveroutput on
exec alter_constraints('disable')
insert into A_PROFILE_OWNER select * from qa_trm_410015_template.A_PROFILE_OWNER where id>=3950000;                                                                                                              
insert into A_PROFILE_PROPERTY select * from qa_trm_410015_template.A_PROFILE_PROPERTY where id>=3950000;                                                                                                        
delete a_profile_property where profile_owner_id=2000001 and key like 'IRD%' and id<4000000
and key  in(select key from a_profile_property where profile_owner_id=2000001 and key like 'IRD%' and id>=4000000);
insert into A_RECON_COMBINATION select * from qa_trm_410015_template.A_RECON_COMBINATION where id>=3950000;                                                                                                      
insert into A_RECON_COMBINATION_2_RECON select * from qa_trm_410015_template.A_RECON_COMBINATION_2_RECON where id>=3950000;                                                                                      
insert into A_RECON_DEF select * from qa_trm_410015_template.A_RECON_DEF where id>=3950000;                                                                                                                      
insert into A_RECON_DETAIL select * from qa_trm_410015_template.A_RECON_DETAIL where id>=3950000;                                                                                                                
insert into A_RECON_EXP select * from qa_trm_410015_template.A_RECON_EXP where id>=3950000;                                                                                                                      
insert into A_ROLE select * from qa_trm_410015_template.A_ROLE where id>=3950000;                                                                                                                                
insert into A_RULE_RULESET select * from QA_TRM_410015_TEMPLATE.A_RULE_RULESET where seq>=3950000;                                         
insert into A_SECURITY_GROUP select * from qa_trm_410015_template.A_SECURITY_GROUP where id>=3950000;                                                                                                            
insert into A_SECURITY_PERMISSION select * from qa_trm_410015_template.A_SECURITY_PERMISSION where id>=3950000;                                                                                                  
insert into A_SECURITY_PRINCIPAL select * from qa_trm_410015_template.A_SECURITY_PRINCIPAL where id>=3950000;                                                                                                    
insert into A_SECURITY_PRINCIPAL_GROUP select * from qa_trm_410015_template.A_SECURITY_PRINCIPAL_GROUP where id>=3950000;                                                                                        
insert into A_SECURITY_PRINCIPAL_ROLE select * from qa_trm_410015_template.A_SECURITY_PRINCIPAL_ROLE where id>=3950000;                                                                                          
insert into A_SECURITY_RESOURCE select * from qa_trm_410015_template.A_SECURITY_RESOURCE where id>=3950000;                                                                                                      
insert into A_SECURITY_USER select * from qa_trm_410015_template.A_SECURITY_USER where id>=3950000;                                                                                                              
insert into A_SECURITY_USER_PWD_HISTORY select * from qa_trm_410015_template.A_SECURITY_USER_PWD_HISTORY where id>=3950000;                                                                                      
insert into A_SP_JMS_DEF select * from qa_trm_410015_template.A_SP_JMS_DEF where id>=3950000;                                                                                                                    
insert into A_SP_MESSAGE_TYPE_DEF select * from qa_trm_410015_template.A_SP_MESSAGE_TYPE_DEF where id>=3950000;                                                                                                  
insert into A_TA select * from qa_trm_410015_template.A_TA where id>=3950000;                                                                                                                                    
insert into A_TA_TA_REL select * from qa_trm_410015_template.A_TA_TA_REL where id>=3950000;                                                                                                                      
insert into A_TRANSITION select * from qa_trm_410015_template.A_TRANSITION where id>=3950000;                                                                                                                    
insert into A_TRANSITION_STATE select * from qa_trm_410015_template.A_TRANSITION_STATE where id>=3950000;                                                                                                        
insert into A_VAL_FUNCTION_PARAM select * from qa_trm_410015_template.A_VAL_FUNCTION_PARAM where id>=3950000;                                                                                                    
insert into A_VAL_MARKET_CONTEXT select * from qa_trm_410015_template.A_VAL_MARKET_CONTEXT where id>=3950000;                                                                                                    
insert into A_VAL_MARKET_DATA select * from qa_trm_410015_template.A_VAL_MARKET_DATA where id>=3950000;                                                                                                          
insert into A_VAL_MARKET_FUNCTION select * from qa_trm_410015_template.A_VAL_MARKET_FUNCTION where id>=3950000;                                                                                                  
insert into A_VAL_MD_CURRENCY select * from qa_trm_410015_template.A_VAL_MD_CURRENCY ;                                                                                                          
insert into A_VAL_SOURCE_DATA select * from qa_trm_410015_template.A_VAL_SOURCE_DATA where id>=3950000;                                                                                                          
insert into M_ALLOCATION_TEMPLATE select * from qa_trm_410015_template.M_ALLOCATION_TEMPLATE where id>=3950000;                                                                                                  
insert into M_ALLOCATION_TEMPLATE_2_FUNDS select * from qa_trm_410015_template.M_ALLOCATION_TEMPLATE_2_FUNDS where id>=3950000;                                                                                  
insert into M_BOOKING select * from qa_trm_410015_template.M_BOOKING where id>=3950000;                                                                                                                          
insert into M_CUT_OF_TIME_ZONE select * from qa_trm_410015_template.M_CUT_OF_TIME_ZONE where id>=3950000;                                                                                                        
insert into M_ORGANIZATION_EXT select * from qa_trm_410015_template.M_ORGANIZATION_EXT where id>=3950000;                                                                                                        
insert into M_PERSON_EXT select * from qa_trm_410015_template.M_PERSON_EXT where id>=3950000;                                                                                                                    
insert into M_PORTFOLIO select * from qa_trm_410015_template.M_PORTFOLIO where id>=3950000;                                                                                                                      
insert into M_REGION select * from qa_trm_410015_template.M_REGION where id>=3950000;                                                                                                                            
insert into M_REGION_2_CALENDAR_CENTER select * from qa_trm_410015_template.M_REGION_2_CALENDAR_CENTER where id>=3950000;                                                                                        
insert into M_TRADER select * from qa_trm_410015_template.M_TRADER where id>=3950000;                                                                                                                            
insert into M_IRD_NOE select * from qa_trm_410015_template.M_IRD_NOE where id>=3950000;                                                                                                                          
insert into A_MSG_PROTOCOL_INFO select * from qa_trm_410015_template.A_MSG_PROTOCOL_INFO where id>=3950000;                                                                                                      
insert into A_MSG_TOKEN select * from qa_trm_410015_template.A_MSG_TOKEN where id>=3950000;                                                                                                                      
insert into A_NAMER select * from qa_trm_410015_template.A_NAMER where id>=3950000;                                                                                                                              
insert into A_NOE_TRADEGROUP select * from qa_trm_410015_template.A_NOE_TRADEGROUP where id>=3950000;                                                                                                            
insert into A_NOTIFICATION select * from qa_trm_410015_template.A_NOTIFICATION where id>=3950000;                                                                                                                
insert into A_OA select * from qa_trm_410015_template.A_OA where id>=3950000;                                                                                                                                    
insert into A_OA_ALLOCATION select * from qa_trm_410015_template.A_OA_ALLOCATION where id>=3950000;                                                                                                              
insert into A_ORGANIZATION select * from qa_trm_410015_template.A_ORGANIZATION where id>=3950000;                                                                                                                
insert into A_ORG_2_ACCOUNT select * from qa_trm_410015_template.A_ORG_2_ACCOUNT where id>=3950000;                                                                                                              
insert into A_ORG_2_ADDRESS select * from qa_trm_410015_template.A_ORG_2_ADDRESS where id>=3950000;                                                                                                              
insert into A_ORG_2_DL select * from qa_trm_410015_template.A_ORG_2_DL where id>=3950000;                                                                                                                        
insert into A_ORG_2_ORG select * from qa_trm_410015_template.A_ORG_2_ORG where id>=3950000;                                                                                                                      
insert into A_ORG_2_PERSON select * from qa_trm_410015_template.A_ORG_2_PERSON where id>=3950000;                                                                                                                
insert into A_ORG_2_RECON_COMBINATION select * from qa_trm_410015_template.A_ORG_2_RECON_COMBINATION where id>=3950000;                                                                                          
insert into A_ORG_ROLE select * from qa_trm_410015_template.A_ORG_ROLE where id>=3950000;                                                                                                                        
delete a_org_role where id in(2000011,2000009);
insert into A_PARTNER select * from qa_trm_410015_template.A_PARTNER where id>=3950000;                                                                                                                          
insert into A_PARTNER_2_MSG_GROUP select * from QA_TRM_410015_TEMPLATE.A_PARTNER_2_MSG_GROUP where partner_id>=3950000;                                  
insert into A_PERSON select * from qa_trm_410015_template.A_PERSON where id>=3950000;                                                                                                                            
insert into A_PERSON_2_ADDRESS select * from qa_trm_410015_template.A_PERSON_2_ADDRESS where id>=3950000;                                                                                                        
insert into A_PERSON_ROLE select * from qa_trm_410015_template.A_PERSON_ROLE where id>=3950000;                                                                                                                  
insert into A_POSITION_PCM select * from qa_trm_410015_template.A_POSITION_PCM where id>=3950000;                                                                                                                
insert into A_POSITION_SEMI_AGG_INSTR(ID,ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,
VALUE_DATE,TRADE_DATE,INSTRUMENT_ID,AMOUNT,GROSS) select ID,ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,
VALUE_DATE,TRADE_DATE,INSTRUMENT_ID,AMOUNT,GROSS from qa_trm_410015_template.A_POSITION_SEMI_AGG_INSTR where id>=3950000;                                                                                          
insert into A_POSITION_SEMI_AGG_INSTR_2_TA select * from qa_trm_410015_template.A_POSITION_SEMI_AGG_INSTR_2_TA where id>=3950000;                                                                                
insert into A_POSITION_SEMI_AGG_INSTR_ALL(ID,ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,VALUE_DATE,INSTRUMENT_ID,AMOUNT,CURR_DATE,TA_ID,LAST_UPDATE,IS_DELETED)
select ID,ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,VALUE_DATE,INSTRUMENT_ID,AMOUNT,CURR_DATE,TA_ID,LAST_UPDATE,IS_DELETED from qa_trm_410015_template.A_POSITION_SEMI_AGG_INSTR_ALL where id>=3950000;                                                                                  
insert into A_POSITION_SEMI_AGG_TRADE(ID,ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,VALUE_DATE,TRADE_DATE,INSTRUMENT_ID_1,INSTRUMENT_ID_2,AMOUNT_1,AMOUNT_2) 
select ID,ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,VALUE_DATE,TRADE_DATE,INSTRUMENT_ID_1,INSTRUMENT_ID_2,AMOUNT_1,AMOUNT_2
from qa_trm_410015_template.A_POSITION_SEMI_AGG_TRADE where id>=3950000;                                                                                          
insert into A_POSITION_SEMI_AGG_TRADE_2_TA select * from qa_trm_410015_template.A_POSITION_SEMI_AGG_TRADE_2_TA where id>=3950000;                                                                                
insert into A_POSITION_SEMI_AGG_TRADE_ALL(ID,ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,VALUE_DATE,INSTRUMENT_ID_1,INSTRUMENT_ID_2,AMOUNT_1,AMOUNT_2,CURR_DATE,TA_ID,LAST_UPDATE,IS_DELETED) select 
ID,ACCOUNT_ID,POSITION_TYPE,POSITION_COMBINATION,VALUE_DATE,INSTRUMENT_ID_1,INSTRUMENT_ID_2,AMOUNT_1,AMOUNT_2,CURR_DATE,TA_ID,LAST_UPDATE,IS_DELETED 
from qa_trm_410015_template.A_POSITION_SEMI_AGG_TRADE_ALL where id>=3950000;                                                                                  
insert into A_ACCOUNT select * from qa_trm_410015_template.A_ACCOUNT where id>=3950000;                                                                                                                          
insert into A_ACCOUNT_ROLE select * from qa_trm_410015_template.A_ACCOUNT_ROLE where id>=3950000;                                                                                                                
insert into A_ADDRESS select * from qa_trm_410015_template.A_ADDRESS where id>=3950000;                                                                                                                          
insert into A_BATCH_PARAM select * from qa_trm_410015_template.A_BATCH_PARAM where id>=3950000;                                                                                                                  
insert into A_BILLING_CCY_PAIR(ID,RATE_FACTOR,FIRST_CCY_ID,SECOND_CCY_ID,RATE_DIRECTION,AMT_PLACES,CCY_PAIR,INVERSE_AMT_PLACES,SPOT_LAG,NETTING_ENABLED,BASIC_STATUS,BASIC_STATUS_REASON) 
select ID,RATE_FACTOR,FIRST_CCY_ID,SECOND_CCY_ID,RATE_DIRECTION,AMT_PLACES,CCY_PAIR,INVERSE_AMT_PLACES,SPOT_LAG,0,BASIC_STATUS,BASIC_STATUS_REASON from qa_trm_410015_template.A_BILLING_CCY_PAIR where id>=3950000;                                                                                                        
insert into A_BILLING_CCY_PAIR_2_FIN_CNTR select * from qa_trm_410015_template.A_BILLING_CCY_PAIR_2_FIN_CNTR where id>=3950000;                                                                                  
insert into A_CALENDAR_CENTER select * from qa_trm_410015_template.A_CALENDAR_CENTER where id>=3950000;                                                                                                          
insert into A_CALENDAR_HOLIDAY_TYPE select * from qa_trm_410015_template.A_CALENDAR_HOLIDAY_TYPE where id>=3950000;                                                                                              
insert into A_CASHFLOW_GEN_MAP select * from qa_trm_410015_template.A_CASHFLOW_GEN_MAP where id>=3950000;                                                                                                        
insert into A_CODE_GROUP select * from qa_trm_410015_template.A_CODE_GROUP where id>=3950000;                                                                                                                    
insert into A_CODE_MEMBER select * from QA_TRM_410015_TEMPLATE.A_CODE_MEMBER where group_id>=3950000;                                          
insert into A_CON_DIR_IN select * from qa_trm_410015_template.A_CON_DIR_IN where address_id>=3950000;                                                                                                                    
insert into A_CON_DIR_OUT select * from qa_trm_410015_template.A_CON_DIR_OUT where address_id>=3950000;                                                                                                                  
insert into A_CON_MAIL_OUT select * from qa_trm_410015_template.A_CON_MAIL_OUT where address_id>=3950000;                                                                                                                
insert into A_CON_PROTOCOLS select * from qa_trm_410015_template.A_CON_PROTOCOLS where id>=3950000;                                                                                                              
update A_CON_PROTOCOLS set basic_status=0 where id=11;
insert into A_CREDIT_ACCOUNT select * from qa_trm_410015_template.A_CREDIT_ACCOUNT where id>=3950000;                                                                                                            
insert into A_CREDIT_LINE select * from qa_trm_410015_template.A_CREDIT_LINE where id>=3950000;                                                                                                                  
insert into A_CREDIT_LINE_2_UCM select * from qa_trm_410015_template.A_CREDIT_LINE_2_UCM where id>=3950000;                                                                                                      
insert into A_CREDIT_MULTI_RESULTS select * from qa_trm_410015_template.A_CREDIT_MULTI_RESULTS where id>=3950000;                                                                                                
insert into A_CREDIT_POS_BASIS_2_UCM select * from qa_trm_410015_template.A_CREDIT_POS_BASIS_2_UCM where id>=3950000;                                                                                            
insert into A_CREDIT_POS_CALL_2_POS_COM select * from qa_trm_410015_template.A_CREDIT_POS_CALL_2_POS_COM where id>=3950000;                                                                                      
insert into A_CREDIT_POS_CALL_2_UCM select * from qa_trm_410015_template.A_CREDIT_POS_CALL_2_UCM where id>=3950000;                                                                                              
insert into A_CREDIT_RESULTS select * from qa_trm_410015_template.A_CREDIT_RESULTS where id>=3950000;                                                                                                            
insert into A_CREDIT_UCM select * from qa_trm_410015_template.A_CREDIT_UCM where id>=3950000;                                                                                                                    
insert into A_DATA_MAPPING select * from qa_trm_410015_template.A_DATA_MAPPING where id>=3950000;                                                                                                                
insert into A_DL select * from qa_trm_410015_template.A_DL where id>=3950000;                                                                                                                                    
insert into A_DL_DETAIL select * from qa_trm_410015_template.A_DL_DETAIL where id>=3950000;                                                                                                                      
insert into A_DOMAIN select * from qa_trm_410015_template.A_DOMAIN where id>=3950000;                                                                                                                            
insert into A_ENTITY_2_PROFILE select * from QA_TRM_410015_TEMPLATE.A_ENTITY_2_PROFILE where profile_id>=3950000;                                     
insert into A_EOD_SCHEDULER_GROUP select * from qa_trm_410015_template.A_EOD_SCHEDULER_GROUP where id>=3950000;                                                                                                  
insert into A_EOD_SCHEDULER_SUPPORTED select * from qa_trm_410015_template.A_EOD_SCHEDULER_SUPPORTED where id>=3950000;                                                                                          
insert into A_EVENT select * from qa_trm_410015_template.A_EVENT where id>=3950000;                                                                                                                              
insert into A_EVENT_2_DL select * from qa_trm_410015_template.A_EVENT_2_DL where id>=3950000;                                                                                                                    
insert into A_EVENT_GROUP select * from QA_TRM_410015_TEMPLATE.A_EVENT_GROUP where event_id>=3950000;                                          
insert into A_FLOW_DEF select * from qa_trm_410015_template.A_FLOW_DEF where id>=3950000;                                                                                                                        
insert into A_GENERIC_PARTNER_STATIC_DATA select * from qa_trm_410015_template.A_GENERIC_PARTNER_STATIC_DATA where id>=3950000;                                                                                  
insert into A_INSTRUMENT_2_FIN_CENTER select * from qa_trm_410015_template.A_INSTRUMENT_2_FIN_CENTER where id>=3950000;                                                                                          
insert into A_INSTRUMENT_BASE select * from qa_trm_410015_template.A_INSTRUMENT_BASE where id>=3950000;                                                                                                          
insert into A_INSTRUMENT_CURRENCY select * from qa_trm_410015_template.A_INSTRUMENT_CURRENCY where id>=3950000;                                                                                                  
insert into A_INSTRUMENT_INTEREST_PAYMENTS select * from qa_trm_410015_template.A_INSTRUMENT_INTEREST_PAYMENTS where id>=3950000;                                                                                
insert into A_LOG_MESSAGES select * from QA_TRM_410015_TEMPLATE.A_LOG_MESSAGES where msg_id>=3950000;                                         
insert into A_LOG_MSG_DEVISION select * from qa_trm_410015_template.A_LOG_MSG_DEVISION where id>=3950000;                                                                                                        
insert into A_MSG_LOGIC_INFO select * from qa_trm_410015_template.A_MSG_LOGIC_INFO where id>=3950000;                                                                                                            
commit;
exec alter_constraints('enable')
exec advance_sequences(5000000)
spool off
