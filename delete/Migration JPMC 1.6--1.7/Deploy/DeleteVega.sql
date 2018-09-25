-- Target: Remove Vega definitions from DB
-- Tables dependencies: 
--------------------------------------
-- arch_flow_def
--		^
--		|<----- arch_flow (dynamic)
--		|
--		|<-----arch_msg_logic_info 
--				^
--				|<-----arch_msg_group_detail
--				|
--				|<-----arch_roll_txn (dynamic)


--Dynamic data Show & Delete.
select * from arch_roll_txn 
where  MSG_PROTOCOL_INFO_ID in 
	  (select ID 
			  from arch_msg_logic_info 
			  where flow_id=1100051 or pre_flow_id=1100051
	  );

select * from arch_flow where flow_def_id=1100051;


delete arch_roll_txn 
where  MSG_PROTOCOL_INFO_ID in 
	  (select ID 
			  from arch_msg_logic_info 
			  where flow_id=1100051 or pre_flow_id=1100051
	  );

delete arch_flow where flow_def_id=1100051;	  

-- Delete protocol definitions:
DELETE ARCH_MSG_TOKEN 		WHERE PROTOCOL_MSG_ID=1100051;
DELETE ARCH_MSG_GROUP_DETAIL	WHERE PROTOCOL_MSG_ID=1100051  ;
DELETE ARCH_MSG_PROTOCOL_INFO 	WHERE ID=1100051 ;
DELETE ARCH_MSG_LOGIC_INFO 		WHERE ID=1100051 ;
DELETE ARCH_FLOW_DEF		WHERE ID=1100051 ;
DELETE ARCH_CODE_MEMBER		WHERE GROUP_ID=1100038 and  CODE_KEY='ClientName' ;
DELETE ARCH_CODE_MEMBER		WHERE GROUP_ID=1100038 and  CODE_KEY='SubmitterName' ;
DELETE ARCH_CODE_GROUP		WHERE ID=1100038  ;
