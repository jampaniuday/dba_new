-- electric NOEs per hour
select trunc(exec_time,'HH24'),f1 name,count(*) 
from  A_GENERIC_REQUEST_DEALS 
where (F15 = 'NOE' or F15='OA+NOE')
and exec_time>=trunc(sysdate-7)
group by  trunc(exec_time,'HH24'),f1
order by  trunc(exec_time,'HH24');

-- UI reports per hour
select  trunc(start_time,'HH24'),count(*) 
from V_A_REPORT_FLOW
where flow_name='WebFormattedReportFlow'
and start_time>=trunc(sysdate-7)
group by trunc(start_time,'HH24')
order by trunc(start_time,'HH24');

-- UI - setup operations per hour
select  trunc(start_time,'HH24'),flow_name,count(*) 
from V_A_REPORT_FLOW
where flow_class like '%setup%'
and nested_depth=1
and flow_name not like '%WebFlow'
and start_time>=trunc(sysdate-7)
group by trunc(start_time,'HH24'),flow_name
order by trunc(start_time,'HH24');


-- UI - Multiple NOE - all new + retrieve , per hour
select start_time,flow_name,count(*) from 
(select   trunc(start_time,'HH24') start_time,uuid,flow_name
from v_a_report_flow 
where uuid in
(select uuid 
from v_a_report_flow 
where (flow_name='NewNoeFlow' or flow_name='RetrieveNoeFlow')
and nested_depth=1
and start_time>=trunc(sysdate-7)
group by uuid
having count(*)>1)
and (flow_name='NewNoeFlow' or flow_name='RetrieveNoeFlow')
and nested_depth=1
and start_time>=trunc(sysdate-7)
group by trunc(start_time,'HH24'),uuid,flow_name
order by trunc(start_time,'HH24'))
group by start_time,flow_name;


--UI regular(not multiple or TRML) NOES per hour
select  trunc(start_time,'HH24'),flow_name,count(*) 
from V_A_REPORT_FLOW
where flow_name in( 'ManualNoeApprovalUpdateFlow','ManualDummyNoeFlow')
and start_time>=trunc(sysdate-7)
group by trunc(start_time,'HH24'),flow_name
UNION
select  trunc(start_time,'HH24'),flow_name,count(*) 
from V_A_REPORT_FLOW
where flow_name in ( 'DeleteNoeFlow','ModifyNoeFlow')
and start_time>=trunc(sysdate-7)
and uuid not in(select exec_uuid from a_Generic_request_deals where exec_time>=trunc(sysdate-7))
group by trunc(start_time,'HH24'),flow_name
UNION
select start_time,flow_name,count(*) from 
(select   trunc(start_time,'HH24') start_time,uuid,flow_name
from v_a_report_flow 
where uuid in
(select uuid 
from v_a_report_flow 
where flow_name='RetrieveNoeFlow'
and nested_depth=1
and start_time>=trunc(sysdate-7)
group by uuid
having count(*)=1)
and flow_name='RetrieveNoeFlow'
and nested_depth=1
and start_time>=trunc(sysdate-7)
group by trunc(start_time,'HH24'),uuid,flow_name
)
group by start_time,flow_name
UNION
select start_time,flow_name,count(*) from 
(select   trunc(start_time,'HH24') start_time,uuid,flow_name
from v_a_report_flow 
where uuid in
(select uuid 
from v_a_report_flow 
where flow_name='NewNoeFlow'
and nested_depth=1
and start_time>=trunc(sysdate-7)
and uuid not in(select exec_uuid from a_Generic_request_deals where exec_time>=trunc(sysdate-7))
group by uuid
having count(*)=1)
and flow_name='NewNoeFlow'
and nested_depth=1
and start_time>=trunc(sysdate-7)
group by trunc(start_time,'HH24'),uuid,flow_name
)
group by start_time,flow_name;





