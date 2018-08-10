select 
	PA.priorAuthCaseNum
	, PA.priorAuthNumber
	, PA.priorAuthDate
	, PA.priorAuthEnteredDt
	, PA.priorAuthEnteredTime
--	, CONCAT(PA.priorAuthEnteredDt, ' ', PA.priorAuthEnteredTime) as priorAuthEnteredDateTime
	, PA.priorAuthStatus
	, Code.virtualTableDesc priorAuthResult
	, PA.priorAuthReq
--	, CONCAT(PA.priorAuthReq, PA.priorAuthStatus) as priorAuth
	, Code.virtualTableInfo3 priorAuthReqDesc
	, Code.virtualTableInfo
	, priorAuthStatus_Category =
	  case
		when Code.virtualTableInfo = 'CC' then 'Completed'
		when Code.virtualTableInfo like'%O%' then 'Open'
	  end
	, Code.virtualTableInfo2
	, priorAuthResult_Category = 
	  case
		when Code.virtualTableInfo2 = 'PPA' then 'Pending'  -- Pending PA
		when Code.virtualTableInfo2 = 'PAY' then 'Success'  -- PA Yes
		when Code.virtualTableInfo2 = 'PAN' then 'Failed'   -- PA No
	  end
	, case
	  when Code.virtualTableDesc in ( 'Attempts Exhausted' ,'DOS/No Retro', 'MD NonCompliant', 'AIM MD Non-Compliant','Received Incomplete') then 'Failure'
	  end as PreClaim_Failure
from Quadax.dbo.priorAuth PA
left join (select distinct virtualTableCode
				,virtualTableDesc
				,virtualTableInfo
				,virtualTableInfo2
				,virtualTableInfo3
			from Quadax.dbo.virtualSelfDescInfo
			where virtualTableType = 'PS') Code
on CONCAT(PA.priorAuthReq, PA.priorAuthStatus) = Code.virtualTableCode
where (priorAuthEnteredDt like '2015%'
   or priorAuthEnteredDt like '2016%'
   or priorAuthEnteredDt like '2017%'
   or priorAuthEnteredDt like '2018%')


-- dropped priorAuthCaseNum= '985296' because the row do not have the matching PA Req+Status code
