select 
	top 10 
	r1.wait_time/1000 as time_sec, 
	r1.session_id as ses_id,
	r1.blocking_session_id as bses_id,
	r2.session_id as ses2_id,
	r3.session_id as ses3_id,
	r4.session_id as ses4_id,
	r4.blocking_session_id as another_blocking_id,
	(select text from sys.dm_exec_sql_text(r1.sql_handle)) as c1,
	(select text from sys.dm_exec_sql_text(r2.sql_handle)) as c2,
	(select text from sys.dm_exec_sql_text(r3.sql_handle)) as c3,
    (select text from sys.dm_exec_sql_text(r4.sql_handle)) as c4
	--,* 
from 
	sys.dm_exec_requests r1 
	inner join sys.dm_exec_requests r2 on r1.blocking_session_id = r2.session_id
	inner join sys.dm_exec_requests r3 on r2.blocking_session_id = r3.session_id
	inner join sys.dm_exec_requests r4 on r3.blocking_session_id = r4.session_id
where r1.transaction_id > 0
and r1.blocking_session_id > 0
order by r1.wait_time desc