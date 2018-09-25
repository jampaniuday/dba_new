drop table cas_preprod_tickets;

create table cas_preprod_tickets as
select cas_preprod.helper_pkg.GetOrganizationName(tp_id) Trading_party
        ,Regular
        ,Position
        ,Offset
        ,Aggregation
        ,Total
	,OFAC_HITS
FROM
( select
        tp_id,
        sum(decode(trade_type,1,1,0))  Regular,
        sum(decode(trade_type,2,1,0))  Position,
        sum(decode(trade_type,10,1,0)) Offset,
        sum(decode(trade_type,11,1,0)) Aggregation,
        count(*)                       Total,
	sum(decode(LIFE_STATUS_REASON_ID,25002,1,0)) OFAC_HITS
    from cas_preprod.fd_fxpb_linear_TA ta
    where creation_date>= trunc(sysdate-1)
      and creation_date<  trunc(sysdate)
      and ta.trade_type in (
                1,  -- Regular
                2,  -- Position
                10, -- Offset
                11  -- Aggregation
          )
    group by tp_id
)
order by 1;

SET DEFINE "^"
set pau off pages 1000 feed off lines 120
col "Regular"           format 9,999,999
col "Position"          format 9,999,999
col "Offset"            format 9,999,999
col "Aggregation"       format 9,999,999
col "Total"             format 9,999,999
col "OFAC_HITS"		format 9,999,999
col sum(Total) heading 'Total Blocks' format 9,999,999
col sum(Regular) heading 'Total Regular' format 9,999,999
col sum(Position) heading 'Total Position' format 9,999,999
col sum(Offset) heading 'Total Offset' format 9,999,999
col sum(Aggregation) heading 'Total Aggregation' format 9,999,999
col sum(OFAC_HITS) heading 'Total OFAC_HITS' format 9,999,999
col "Trading party" format a24
compute sum LABEL 'Total CAS PREPROD Blocks:' of "Total" "Regular" "Position" "Offset" "Aggregation" "OFAC_HITS" on report
break on report
spool ^1
select Trading_party "Trading party",Regular "Regular",Position "Position",Offset "Offset",Aggregation "Aggregation",Total "Total",OFAC_HITS "OFAC_HITS" from cas_preprod_tickets;
spool off
exit;
