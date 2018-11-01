Select
  A.stdClmTickNum ,A.stdClmCaseNum
  ,A.stdClmReqNum 
  ,case
   when (A.stdClmAccession is null or A.stdClmAccession = '') then 'NONE'
   else A.stdClmAccession
   end stdClmAccession
  ,A.stdClmPH
  ,A.stdClmDOS ,A.stdClmChgEntryDt ,A.stdClmChgAcctPeriod
  ,A.stdClmCurrency ,A.stdClmAmtChg ,A.stdClmAmtRec ,A.stdClmAmtAdj ,A.stdClmTickBal
  ,A.stdClmReRouteIns1Comp ,Ltrim(RTRIM(A.stdClmReRouteIns1)) stdClmReRouteIns1, A.stdClmReRouteInsCompName
  ,A.stdClmReRouteInsPlanName ,A.stdClmReRouteInsFC
  ,A.stdClmReRouteIns1CompAlt ,LTRIM(RTRIM(A.stdClmReRouteIns1AltCode)) stdClmReRouteIns1AltCode
  ,LTRIM(RTRIM(A.stdClmRostAcctNum)) stdClmRostAcctNum
--  ,stdClmRostInvoice
  ,A.stdClmIns1Comp , LTRIM(RTRIM(A.stdClmIns1)) stdClmIns1 ,A.stdClmInsCompName
  ,A.stdClmInsPlanName ,A.stdClmInsFC ,A.stdClmIns1CompAlt ,LTRIM(RTRIM(A.stdClmIns1AltCode)) stdClmIns1AltCode
  ,A.stdClmStatusDt ,A.stdClmCaseStatus ,A.stdClmTickStatus
  ,A.stdClmCIE, A.stdClmPtState

  , A.stdClmInitBillDt, A.stdClmInitPymntDt, A.stdClmLastBillDt, A.stdClmLastPymntDt
  , Code.clientTableCode BillingCaseStatusCode
  , Code.clientTableDesc BillingCaseStatus
  , Code.clientTableInfo BillingCaseStatusSummary1
  , Code.clientTableInfo2 BillingCaseStatusSummary2
from Quadax.dbo.stdClaimFile A
left join (select distinct clientTableCode, clientTableDesc
					 ,clientTableInfo, clientTableInfo2
			   from Quadax.dbo.clientSelfDescInfo
			   where clientTableType = 'CS') Code
	on stdClmCaseStatus = clientTableCode
where stdClmTickNum in (
                          Select stdClmTickNum
                          from Quadax.dbo.stdClaimFile
                          where stdClmDOS like '2017%'
                          or stdClmDOS like '2018%'
                          or stdClmDOS like '201610%'
                          or stdClmDOS like '201611%'
                          or stdClmDOS like '201612%'
                          )
/*
where stdClmAccession in (
                          Select stdClmAccession
                          from Quadax.dbo.stdClaimFile
                          where stdClmDOS like '2017%'
                          or stdClmDOS like '2018%'
                          or stdClmDOS like '201610%'
                          or stdClmDOS like '201611%'
                          or stdClmDOS like '201612%'
                          )
						  */
--and stdClmTickNum in ('701515','704486')