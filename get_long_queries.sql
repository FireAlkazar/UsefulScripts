SELECT 
	max(datediff(s, start_time, getdate())) as max_secs, [text], count(*) as [query_count]
FROM 
	sys.dm_exec_requests 
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) 
WHERE 
	session_id IN 
		(SELECT 
			blocking_session_id 
		FROM 
			sys.dm_exec_requests 
		WHERE 
			DB_NAME(database_id)='JTI' 
			--and blocking_session_id <>0
		)
GROUP BY
	[text]
HAVING
	max(datediff(s, start_time, getdate())) > 0
ORDER BY
	max_secs desc
--SELECT top 1 * FROM sys.dm_exec_requests where DB_NAME(database_id)='JTI' and blocking_session_id <>0

--select top 100 wait_duration_ms/1000/60 as mins, wait_duration_ms/1000 as secs, *  from sys.dm_os_waiting_tasks
--order by wait_duration_ms desc

--select DB_ID(), DB_NAME()


--SELECT resource_type, resource_associated_entity_id,  
--    request_status, request_mode,request_session_id,  
--    resource_description   
--    FROM sys.dm_tran_locks  
--    WHERE resource_database_id = DB_ID() 