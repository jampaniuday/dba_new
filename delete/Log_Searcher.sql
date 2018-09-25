create or replace procedure Log_Searcher (
    pLogTable       in varchar2,
    pQueryFilter    in varchar2,
    pMsg            in varchar2 default null
) as 
/*
Required grant: 
grant select on dba_Tables to dba_apps
*/
    cursor c_check_list (tbl_name in varchar2) is
        select owner, table_name, owner||'.'||table_name tbl
        from dba_tables 
        where table_name=tbl_name
        order by owner;
        
    lSQLWhere varchar2(1000);  
    lTableName varchar2(1000);      
    lCount     number;
    lMsg       varchar2(1000);
    lAppName   varchar2(200);
begin   

    lTableName := upper(substr(pLogTable, 1, 1000));
    lSQLWhere := upper(substr(pQueryFilter, 1, 1000));
    lAppName := 'Log_Searcher';

    
    for curr_table in c_check_list(lTableName) loop
        
        begin     
            execute immediate 'select count(*) from '||curr_table.tbl||lSQLWhere into lCount;
            
            
            lMsg:= curr_table.tbl||' has '||lCount||' records. '||pMsg;
            if (lCount>0) then
                log_manager.Write_To_Log_Table(lAppName, systimestamp,lMsg ,null,log_manager.MSG_TYPE_WARNING);
            end if;
        
        exception 
            when others then null;
        end;
        
    end loop;    
end;
/
show errors



/*
-- Schedule this to run once a day: 
begin
     Log_Searcher('HIS_LOG',q'! WHERE LOG_TIME>sysdate-24 and MSG_TYPE='ERROR'!');
     Log_Searcher('LOG_CMN_DB_TASK',q'! WHERE start_time>sysdate-24 and status=-1 or result is not null !');
     Log_Searcher('DW_ARCHIVE_MSG',q'! WHERE msg_time>sysdate-24 and  CATEGORY='Error'!');
end;
/
*/

