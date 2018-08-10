select C.*
	, Code.clientTableCode BillingCaseStatusCode
	, Code.clientTableDesc BillingCaseStatus
	, Code.clientTableInfo BillingCaseStatusSummary1
    , Case
      when code.clientTableInfo = 'On Hold' then 'On Hold'
      when code.clientTableInfo in ('Medical Records Audit','Criteria Validation', 'Pending Charge', 'Uncategorized Status', 'Bad Address','Reconsideration') then 'Claim in Process'
      else code.clientTableInfo2
	  End as BillingCaseStatusSummary2
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
