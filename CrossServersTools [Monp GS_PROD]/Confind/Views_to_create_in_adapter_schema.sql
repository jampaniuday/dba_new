create or replace function schema_name return varchar2
as
v_schema   user_users.username%TYPE;
begin
SELECT username
     INTO v_schema
     FROM user_users;
return v_schema;
end;
/


CREATE OR REPLACE FORCE VIEW ADAPTER
(
   ID,
   NAME,
   PATH
)
AS
   WITH transformed_xml
        AS (SELECT t.ID,
                   XMLTYPE (blob_to_clob (FILECONTENT)).transform (
                      XMLTYPE (xsls.xsl),
                         'FILE_NAME="'''
                      || filename
                      || '''" '
                      || 'SCHEMA="''' 
                      || schema_name
                      || '''" '
                      || 'ENV_SERVER="'''
                      || SYS_CONTEXT ('USERENV', 'ip_address')
                      || '''" '
                      || 'UPDATE_TIME="'''
                      || TO_CHAR (updatedon, 'DD/MM/YYYY HH24:MI:SSxFF')
                      || '''"')
                      connectivity_xml
              FROM configs t JOIN xsls ON (xsls.id = 1)
             WHERE t.status = 1),
        flattened
        AS (SELECT t.id adapter_id, m.*
              FROM transformed_xml t,
                   XMLTABLE (
                      'root/adapter'
                      PASSING t.connectivity_xml
                      --    columns id                          for ordinality
                      COLUMNS name VARCHAR2 (200) PATH 'name',
                              PATH VARCHAR2 (200) PATH 'path') m)
   SELECT ORA_HASH (PATH || name) id, name, PATH
     FROM flattened t;

	 
CREATE OR REPLACE FORCE VIEW ADAPTER_TRANSFORMER
(
   ID,
   NAME,
   CLASS_NAME,
   PARAMETERS,
   PATH
)
AS
   WITH transformed_xml
        AS (SELECT t.ID,
                   XMLTYPE (blob_to_clob (FILECONTENT)).transform (
                      XMLTYPE (xsls.xsl),
                         'FILE_NAME="'''
                      || filename
                      || '''" '
                      || 'SCHEMA="''' 
                      || schema_name
                      || '''" '
                      || 'ENV_SERVER="'''
                      || SYS_CONTEXT ('USERENV', 'ip_address')
                      || '''" '
                      || 'UPDATE_TIME="'''
                      || TO_CHAR (updatedon, 'DD/MM/YYYY HH24:MI:SSxFF')
                      || '''"')
                      connectivity_xml
              FROM configs t JOIN xsls ON (xsls.id = 1)
             WHERE t.status = 1),
        flattened
        AS (    SELECT t.id adapter_id, m.*,
                           RANK() OVER (PARTITION BY m.name, m.class_name ORDER BY rownum) rnk   
                  FROM transformed_xml t,
                       XMLTABLE (
                          'root/adapter_transformer'
                          PASSING t.connectivity_xml
                          --    columns id                          for ordinality
                          COLUMNS name VARCHAR2 (200) PATH 'name',
                                  class_name VARCHAR2 (200) PATH 'class_name',
                                  parameters VARCHAR2 (200) PATH 'parameters',
                                  PATH VARCHAR2 (200) PATH 'path') m)
   SELECT ORA_HASH (PATH || name) id,
          name,
          class_name,
          parameters,
          PATH
     FROM flattened t
     where rnk=1;

	 
CREATE OR REPLACE FORCE VIEW SD_ADDRESS_2_TRANSFORMER
(
   ID,
   ADDRESS_ID,
   TRANSFORM_ORDER,
   DESCRIPTION,
   PARAMETERS,
   TRANSFORMER_ID,
   TRANSFORMER_NAME,
   PATH
)
AS
   WITH transformed_xml
        AS (SELECT t.ID,
                   XMLTYPE (blob_to_clob (FILECONTENT)).transform (
                      XMLTYPE (xsls.xsl),
                         'FILE_NAME="'''
                      || filename
                      || '''" '
                      || 'SCHEMA="''' 
                      || schema_name
                      || '''" '
                      || 'ENV_SERVER="'''
                      || SYS_CONTEXT ('USERENV', 'ip_address')
                      || '''" '
                      || 'UPDATE_TIME="'''
                      || TO_CHAR (updatedon, 'DD/MM/YYYY HH24:MI:SSxFF')
                      || '''"')
                      connectivity_xml
              FROM configs t JOIN xsls ON (xsls.id = 1)
			  WHERE t.status = 1),
        flattened
        AS (      SELECT t.id adapter_id, m.*
                    FROM transformed_xml t,
                         XMLTABLE (
                            'root/address_to_transformer'
                            PASSING t.connectivity_xml
                            --    columns id                          for ordinality
                            COLUMNS adapter_name VARCHAR2 (200) PATH 'adapter_name',
                                    address_name VARCHAR2 (200) PATH 'address_name',
                                    transformer_name VARCHAR2 (200)
                                          PATH 'transformer_name',
                                    transformer_order VARCHAR2 (50)
                                          PATH 'transformer_order',
                                    PATH VARCHAR2 (200) PATH 'path') m)
   SELECT ORA_HASH (transformer_name || address_name || transformer_order) ID,
          ORA_HASH (PATH || address_name) address_id,
          case  when transformer_order > 9999 then 9999 else to_number(transformer_order) end TRANSFORM_ORDER,
          NULL DESCRIPTION,
          NULL PARAMETERS,
          ORA_HASH (PATH || transformer_name) TRANSFORMER_ID,
          transformer_name,
          PATH
     FROM flattened t;

	 
CREATE OR REPLACE FORCE VIEW SD_ADDRESS_ROUTE
(
   SOURCE_ADDRESS_ID,
   DESTINATION_ADDRESS_ID,
   PATH
)
AS
   WITH transformed_xml
        AS (SELECT t.ID,
                   XMLTYPE (blob_to_clob (FILECONTENT)).transform (
                      XMLTYPE (xsls.xsl),
                         'FILE_NAME="'''
                      || filename
                      || '''" '
                      || 'SCHEMA="''' 
                      || schema_name
                      || '''" '
                      || 'ENV_SERVER="'''
                      || SYS_CONTEXT ('USERENV', 'ip_address')
                      || '''" '
                      || 'UPDATE_TIME="'''
                      || TO_CHAR (updatedon, 'DD/MM/YYYY HH24:MI:SSxFF')
                      || '''"')
                      connectivity_xml
              FROM configs t JOIN xsls ON (xsls.id = 1)
			  WHERE t.status = 1),
        flattened
        AS (      SELECT t.id adapter_id, m.*
                    FROM transformed_xml t,
                         XMLTABLE (
                            'root/address_route'
                            PASSING t.connectivity_xml
                            --    columns id                          for ordinality
                            COLUMNS adapter_name VARCHAR2 (200) PATH 'adapter_name',
                                    source_address_name VARCHAR2 (50)
                                          PATH 'source_address_name',
                                    destination_address_name VARCHAR2 (50)
                                          PATH 'destination_address_name',
                                    PATH VARCHAR2 (200) PATH 'path') m)
   SELECT ORA_HASH (PATH || source_address_name) source_address_id,
          ORA_HASH (PATH || destination_address_name) destination_address_id,
          PATH
     FROM flattened t;


CREATE OR REPLACE FORCE VIEW V_CONNECTIVITIES
(
   ADDRESS_ID,
   ADDRESS_NAME,
   DIRECTION,
   UPDATE_TIME,
   CONNECTIVITY_TYPE,
   ADAPTER,
   QUEUE_NAME,
   QUEUE_MGR,
   CHANNEL,
   SERVER,
   PORT,
   USERNAME,
   EMAIL,
   DIRECTORY,
   FIX_CONNECTION_TYPE,
   SENDER_COMP_ID,
   TARGET_COMP_ID,
   ADDRESS_STATUS,
   ADDRESS_SERVER_NAME,
   CHANNELS_COUNT,
   ENABLED_CHANNELS,
   ADDITIONAL_INFO,
   PATH
)
AS
   WITH transformed_xml
        AS (SELECT t.ID,
                   XMLTYPE (blob_to_clob (FILECONTENT)).transform (
                      XMLTYPE (xsls.xsl),
                         'FILE_NAME="'''
                      || filename
                      || '''" '
                      || 'SCHEMA="''' 
                      || schema_name
                      || '''" '
                      || 'ENV_SERVER="'''
                      || SYS_CONTEXT ('USERENV', 'ip_address')
                      || '''" '
                      || 'UPDATE_TIME="'''
                      || TO_CHAR (updatedon, 'DD/MM/YYYY HH24:MI:SSxFF')
                      || '''"')
                      connectivity_xml
              FROM configs t JOIN xsls ON (xsls.id = 1)
             WHERE t.status = 1),
        flattened
        AS (      SELECT t.id adapter_id, m.*
                    FROM transformed_xml t,
                         XMLTABLE (
                            'root/connectivity'
                            PASSING t.connectivity_xml
                            --    columns id                          for ordinality
                            COLUMNS connectivity_type NUMBER (10)
                                          PATH 'connectivity_type',
                                    adapter_name VARCHAR2 (100) PATH 'adapter_name',
                                    address_name VARCHAR2 (200) PATH 'address_name',
                                    direction VARCHAR2 (50) PATH 'direction',
                                    server VARCHAR2 (50) PATH 'server',
                                    queue_name VARCHAR2 (50) PATH 'queue_name',
                                    port VARCHAR2 (50) PATH 'port',
                                    channel VARCHAR2 (50) PATH 'channel',
                                    queue_mgr VARCHAR2 (50) PATH 'queue_mgr',
                                    update_time VARCHAR2 (50) PATH 'update_time',
                                    username VARCHAR2 (50) PATH 'user_name',
                                    email VARCHAR2 (50) PATH 'email',
                                    DIRECTORY VARCHAR2 (50) PATH 'directory',
                                    fix_connection_type VARCHAR2 (50)
                                          PATH 'fix_connection_type',
                                    sender_comp_id VARCHAR2 (50)
                                          PATH 'sender_comp_id',
                                    target_comp_id VARCHAR2 (50)
                                          PATH 'target_comp_id',
                                    ADDRESS_STATUS VARCHAR2 (50)
                                          PATH 'address_status',
                                    ADDRESS_SERVER_NAME VARCHAR2 (50)
                                          PATH 'address_server_name',
                                    CHANNELS_COUNT VARCHAR2 (50)
                                          PATH 'channels_count',
                                    ENABLED_CHANNELS VARCHAR2 (50)
                                          PATH 'enabled_channels',
                                    ADDITIONAL_INFO VARCHAR2 (50)
                                          PATH 'additional_info',
                                    PATH VARCHAR2 (200) PATH 'path') m)
   SELECT address_id,
          address_name,
          direction,
          update_time,
          connectivity_type,
          adapter,
          queue_name,
          queue_mgr,
          channel,
          server,
          port,
          username,
          email,
          DIRECTORY,
          fix_connection_type,
          sender_comp_id,
          target_comp_id,
          1 address_status,
          address_server_name,
          channels_count,
          enabled_channels,
          additional_info,
          PATH
     FROM (SELECT ORA_HASH (PATH || address_name) address_id,
                  ROW_NUMBER ()
                  OVER (PARTITION BY ORA_HASH (PATH || address_name)
                        ORDER BY 1)
                     rn,
                  address_name,
                  direction,
                  SYSDATE update_time,
                  connectivity_type,
                  ORA_HASH (PATH || adapter_name) adapter,
                  queue_name,
                  queue_mgr,
                  channel,
                  server,
                  port,
                  username,
                  email,
                  DIRECTORY,
                  fix_connection_type,
                  sender_comp_id,
                  target_comp_id,
                  address_status,
                  address_server_name,
                  channels_count,
                  enabled_channels,
                  additional_info,
                  PATH
             FROM flattened t)
    WHERE rn = 1;
