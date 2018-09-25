
begin 
    execute immediate 'drop table EB_AS_CLIENTS';
exception
    when others then null;
end;
/

CREATE TABLE EB_AS_CLIENTS (EB_AS_CLIENT_NAME varchar2(1000));
CREATE INDEX EB_AS_CLIENTS_IDX on EB_AS_CLIENTS (EB_AS_CLIENT_NAME);
/*
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('AUTOMAT GFT');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('BLUEFIRE GFT');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('EWT LLC');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('FCStone (as EB)');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('GAIN GTX EB');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('IKON as EB');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('Ikon Global Markets Metals (EB)');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('LUCID EB');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('MF Global as EB');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('PFG CHICAGO as EB');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('PFG Executing Bank');
INSERT INTO EB_AS_CLIENTS (EB_AS_CLIENT_NAME) VALUES ('PFGEFX as EB');
COMMIT;
*/

begin 
    execute immediate 'drop index sd_dm_grp_idx';
exception
    when others then null;
end;
/

Create unique index sd_dm_grp_idx on ^DB_SCHEMA..sd_dm_group (mod(class_id,1000),id, namer_id);
 
EXEC DBMS_STATS.gather_table_stats(ownname => '^DB_SCHEMA.',tabname => 'SD_DM_GROUP',method_opt => 'for all columns size auto');

begin
  gather_Statistics.tables(user,'EB_AS_CLIENTS');
  gather_Statistics.tables('^DB_SCHEMA.','sd_dm_group');
end;
/


begin 
    execute immediate 'drop table MIG_TRANSLATIONS';
exception
    when others then null;
end;
/

CREATE TABLE MIG_TRANSLATIONS (
    KEY  varchar2(100),
    CODE NUMBER(10), 
    STRING VARCHAR2(200),
    CONSTRAINT MIG_TRANSLATIONS_PK PRIMARY KEY (KEY,CODE)
) ORGANIZATION INDEX;

-- product group (map_type = 152)
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductGroup', 1, 'FX');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductGroup', 2, 'SWAP');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductGroup', 3, 'SWAP');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductGroup', 4, '');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductGroup', 5, 'FX');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductGroup', 6, 'NDF');
-- product type (equivalent to product group)
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductType', 1, 'FORWARED');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductType', 2, 'SWAP');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductType', 3, 'SWAP');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductType', 4, '');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductType', 5, 'FORWARED');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('ProductType', 6, 'NDF');
-- trade type (Map_type = 154)
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('TradeType', 1, 'REGULAR');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('TradeType', 2, 'POSITION');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('TradeType', 3, 'EXERCISE');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('TradeType', 4, '');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('TradeType', 5, 'FIX');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('TradeType', 6, 'HEDGE');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('TradeType', 7, 'FIX');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('TradeType', 8, 'FIX');
-- trade type (Map_type = 154)
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginType', 1, 'External');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginType', 2, 'Booking');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginType', 3, 'Booking');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginType', 4, 'External');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginType', 5, 'External');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginType', 6, 'HARMONY');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginType', 7, 'Booking');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginType', 8, 'Booking');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginType', 9, 'Booking');
-- Linear OA trade type (Map_type = 154)
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginTypeOA', 1, 'External');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginTypeOA', 2, 'Booking');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginTypeOA', 3, 'Booking');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginTypeOA', 4, 'External');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginTypeOA', 5, 'External');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginTypeOA', 6, 'HARMONY');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginTypeOA', 7, 'Booking');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginTypeOA', 8, 'Booking');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OriginTypeOA', 9, 'Booking');
-- Option premium  type 
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('optPremiumType', 1, 'PREC');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('optPremiumType', 2, 'PREC');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('optPremiumType', 3, 'FLAT');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('optPremiumType', 4, 'FLAT');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('optPremiumType', 5, 'FLAT');
-- Option trade type (GROUP_ID=408037 --FXPBOptionType)
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  1, 'REGULAR');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  2, 'REGULAR');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  3, 'EXERCISE');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  5, 'REGULAR');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  6, 'REGULAR');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  7, 'REGULAR');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  8, 'REGULAR');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  10, 'REGULAR');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  11, 'REGULAR');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  12, 'REGULAR');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptTradeType',  13, 'REGULAR');
-- Barrier direction 
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptBarrierType',  1, 'I');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptBarrierType',  2, 'O');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptBarrierType',  3, 'UI');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptBarrierType',  4, 'UO');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptBarrierType',  5, 'DI');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('OptBarrierType',  6, 'DO');
-- Option premium  type 
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('HarmonyMap', 3, 'Organization');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('HarmonyMap', 12,'Organization');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('HarmonyMap', 7, 'Fund');
insert into MIG_TRANSLATIONS (KEY, CODE, STRING) values ('HarmonyMap', 4, 'User');


														 
commit;



begin
    execute immediate 'drop table single_fund_clients';
exception 
    when others then null;     
end;
/

create table single_fund_clients as  
select 
    client.id client_id, 
    fund.id fund_id 
from 
    ^DB_SCHEMA..a_state_detail s_client,
    ^DB_SCHEMA..a_organization client, 
    ^DB_SCHEMA..a_object_2_object o2o, 
    ^DB_SCHEMA..a_organization fund,
    ^DB_SCHEMA..a_state_detail s_fund
where 
  -- Link client & fund by o2o list.
      client.id = o2o.from_object_id
  and o2o.from_object_type = ^TYPE_ORG
  and o2o.to_object_type = ^TYPE_ORG
  and o2o.to_object_id = FUND.ID
  -- Enabled funds 
  and fund.state_id = s_fund.state_id
  and s_fund.status_value = 1
  -- Enabled clients 
  and client.state_id = s_client.state_id
  and s_client.status_value = 1
  -- Single funds clients only 
  and o2o.from_object_id in 
    (
    -- Clients with a single fund 
    select from_object_id--, count(*)
    from 
		^DB_SCHEMA..a_object_2_object o2o,
		^DB_SCHEMA..a_organization org,
		^DB_SCHEMA..a_State_detail s
    where from_object_type = ^TYPE_ORG  and to_object_type = ^TYPE_ORG 
	  and to_object_id = org.id 
	  and org.state_id = s.state_id
	  and s.status_value = 1
    group by from_object_id
    having count(*) = 1   
    )
;



begin
    execute immediate 'drop table fund_clients_conflict';
exception 
    when others then null;     
end;
/

create table fund_clients_conflict (
	client_id 	number(30), 
	fund_id		number(30),
	txt			varchar2(50) not null
);


/*
-- find all cilents/funds with the same external value 
insert into fund_clients_conflict (client_id, fund_id, txt) select  client_org.id, fund_org.id, '_mig'
--select 'insert into fund_clients_conflict (client_id, fund_id, txt) values ('||client_org.id||', '|| fund_org.id||q'~, '_mig'); ~'
from ^DB_SCHEMA..v_arch_data_mapping client,
     ^DB_SCHEMA..v_arch_data_mapping fund, 
     ^DB_SCHEMA..a_organization client_org,
     ^DB_SCHEMA..a_organization fund_org
where -- 2 identical external names 
	  client.internal_value<>fund.internal_value
  and client.external_value=fund.external_value 
  and client.namer_id = fund.namer_id
  -- make sure client is defined with client role
  and client.internal_value = client_org.id
  and client.map_type = ^MAP_CLIENT 
  and client_org.role = ^ROLE_CLIENT
  -- make sure fund is defined with fund role
  and fund.internal_value = fund_org.id
  and fund.map_type = ^MAP_FUND
  and fund_org.role = ^ROLE_FUND
;
*/

insert into fund_clients_conflict (client_id, fund_id, txt) select client.id,fund.id, '_' 
-- select 'insert into fund_clients_conflict (client_id, fund_id, txt) values ('||client.id||', '|| fund.id||q'~, '_'); ~'
from 
    ^DB_SCHEMA..a_organization client,
    ^DB_SCHEMA..a_organization fund, 
    ^DB_SCHEMA..a_state_detail s_client,
    ^DB_SCHEMA..a_state_detail s_fund, 
	^DB_SCHEMA..V_ARCH_DATA_MAPPING F_NAME
where client.name = F_NAME.EXTERNAL_VALUE
and client.role = ^ROLE_CLIENT
and fund.role = ^ROLE_FUND
and client.state_id = s_client.state_id
and fund.state_id = s_fund.state_id
and s_client.status_value = 1
and s_fund.status_value = 1
AND F_NAME.INTERNAL_VALUE = FUND.ID
AND F_NAME.map_type = ^MAP_FUND
and F_NAME.type = 0 
and F_NAME.namer_id = ^PRIME_ORG
;


commit;


CREATE OR REPLACE FUNCTION SMART_NAME (P_NAME IN VARCHAR2, P_STRING varchar2 default '%%') RETURN VARCHAR2 AS
    l_end_position number;
BEGIN
    
    l_end_position := instr(P_NAME,P_STRING);
    if l_end_position = 0 then 
        return (P_NAME );
    else
        return (substr(P_NAME,1, l_end_position-1));
    end if;
END;
/


CREATE OR REPLACE FORCE VIEW V_EXTERNAL_ORG_NAME
AS 
select org.name full_name, org.role, org.namer_id org_namer , map."ID",map."NAMER_ID",map."MAP_TYPE",map."EXTERNAL_VALUE",map."INTERNAL_VALUE",map."TYPE",map."STATUS"
from
    ^DB_SCHEMA..v_arch_data_mapping map,
    ^DB_SCHEMA..a_organization org,
    ^DB_SCHEMA..a_state_detail state
where map.internal_value = org.id
  and map.map_type in (^MAP_ORG, ^MAP_FUND, ^MAP_ECN)
  and org.state_id = state.state_id
  and state.status_value = 1;

create or replace function get_list_from_sql(
    p_sql       in varchar2, 
    p_delimiter in varchar2 default ';',
    p_string_qoute in varchar2 default '"') return varchar2 
as
    TYPE cur_typ IS REF CURSOR; 
    listData    cur_typ;
    lList       varchar2(4000);
    lItem       varchar2(4000);
    lElements   number;
begin
    
    lElements := 0;
    open listData for p_sql;
    loop    
        fetch listData into lItem;
        exit when listData%NOTFOUND;
        
        if (lItem is not null) then 
            lItem :=  p_string_qoute || lItem || p_string_qoute;
        end if;
        
        if (lElements = 0) then
            lList :=  lItem ;
        else
            lList :=  lList || p_delimiter || lItem;
        end if;        
        lElements := lElements + 1;
    end loop;
     
    close listData;
    return (lList);
    
exception
    when others then 
        if (listData%ISOPEN) then 
            close listData;
        end if;
       raise;
end;    
/
