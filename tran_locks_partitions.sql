--SELECT top 1 * FROM sys.dm_tran_locks   
--WHERE request_owner_type = N'TRANSACTION'   
--    AND request_owner_id = 83208915658

--SELECT * from sys.dm_tran_locks
--WHERE 
--request_status = 'CONVERT'
--and 
--resource_associated_entity_id = 72057594977517568

SELECT tl.resource_type
 --,tl.resource_associated_entity_id
 --,p.object_id
 ,OBJECT_NAME(p.object_id) AS object_name
 ,tl.request_status
 ,tl.request_mode
 ,tl.request_session_id
 ,tl.resource_description
FROM sys.dm_tran_locks tl
LEFT JOIN sys.partitions p 
ON p.hobt_id = tl.resource_associated_entity_id
WHERE tl.resource_database_id = DB_ID()
--and 
--tl.request_status = 'CONVERT'
and 
OBJECT_NAME(p.object_id) = 'Campaigns'
order by tl.request_session_id

--select top 1 OBJECT_NAME(p.object_id) AS object_name, * from sys.partitions p where hobt_id = 72057594621591552