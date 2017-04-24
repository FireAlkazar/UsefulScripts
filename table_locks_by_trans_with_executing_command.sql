SELECT tl.resource_type
 --,tl.resource_associated_entity_id
 --,p.object_id
 ,OBJECT_NAME(p.object_id) AS object_name
 ,tl.request_status
 ,tl.request_mode
 ,tl.request_session_id
 ,tl.resource_description
 ,(select text from sys.dm_exec_sql_text(r.sql_handle))
FROM sys.dm_tran_locks tl
inner join sys.dm_exec_requests r on tl.request_session_id=r.session_id
LEFT JOIN sys.partitions p 
ON p.hobt_id = tl.resource_associated_entity_id
WHERE tl.resource_database_id = DB_ID()
--and 
--tl.request_status = 'CONVERT'
and 
OBJECT_NAME(p.object_id) = 'TableName'
order by tl.request_session_id

--select top 1 OBJECT_NAME(p.object_id) AS object_name, * from sys.partitions p where hobt_id = 72057594621591552