select
	A.appealCaseNumber
	, A.appealInsCode
	, A.appealDenReason
	, R.clientTableDesc appealDenReasonDesc
	, A.appealLvl
	, L.virtualTableCode appealLvlCode
	, L.virtualTableDesc appealLvlDesc
	, A.appealStatus
	, B.virtualTableDesc appealStatusDesc
	, A.appealEntryDt, A.appealDenialLetterDt, A.appealPendDt
	, A.appealAllowed
from Quadax.dbo.appeal A
left join (select distinct virtualTableCode, virtualTableDesc
		   from Quadax.dbo.virtualSelfDescInfo
		   where virtualTableType = 'AS') B
	   on appealStatus = virtualTableCode
left join (select distinct virtualTableCode
				  , virtualTableDesc, virtualTableInfo
		   from Quadax.dbo.virtualSelfDescInfo
		   where virtualTableType = 'AA') L
		on appealLvl = virtualTableInfo
left join (select distinct clientTableDesc, clientTableCode
			 from Quadax.dbo.clientSelfDescInfo
			where clientTableType = 'DN' 
			  and clientTableDesc != 'GOA') R
		 on appealDenReason = clientTableCode
where A.appealEntryDt != ''
