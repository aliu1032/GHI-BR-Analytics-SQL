select C.*
	, Code.clientTableCode BillingCaseStatusCode
	, Code.clientTableDesc BillingCaseStatus
	, Code.clientTableInfo BillingCaseStatusSummary1
	, Code.clientTableInfo2 BillingCaseStatusSummary2
    from Quadax.dbo.cases C
	left join (select distinct clientTableCode, clientTableDesc
					 ,clientTableInfo, clientTableInfo2
			   from Quadax.dbo.clientSelfDescInfo
			   where clientTableType = 'CS') Code
	on caseStatus = clientTableCode
where caseAccession is not null and
          (caseEntryYrMth like '2015%' or
           caseEntryYrMth like '2016%' or
           caseEntryYrMth like '2017%' or
           caseEntryYrMth like '2018%')
