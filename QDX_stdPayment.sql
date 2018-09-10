Select
    stdPymntAcctNum,stdPymntTickNum,stdPymntCaseNum
    ,stdPymntReqNum 
	,Case
		when (stdPymntAccession is null or stdPymntAccession ='') then 'NONE'
		else stdPymntAccession
	 end stdPymntAccession
	,stdPymntPH
    ,stdPymntDOS ,stdPymntDt ,stdPymntAcctPeriod
    ,stdPymntCurrency ,stdPymntAmt
    ,stdPymntLine ,stdPymntType ,stdPymntCode
    ,stdPymntCategoryCode ,stdPymntCategoryType
    /*
    Information on the Payor & plan where the claim ticket is submitted to */
    ,stdPymntReRouteIns1Comp ,stdPymntReRouteIns1,stdPymntReRouteInsCompName
    ,stdPymntReRouteInsPlanName ,stdPymntReRouteInsFC ,stdPymntReRouteIns1CompAlt ,stdPymntReRouteIns1AltCode
    ,stdPymntRostAcctNum
    ,stdPymntIns1Comp ,stdPymntIns1CompAlt ,stdPymntIns1AltCode
    /*
       Information about the Payor & plan making the payment */
    ,stdPymntCodeComp ,stdPymntFC ,stdPymntCodeCompAlt ,stdPymntCodeAltCode
    /*  */
    ,stdPymntAllowedAmt ,stdPymntDeductibleAmt ,stdPymntCoinsAmt
from Quadax.dbo.stdPaymentFile
where stdPymntAccession in (
                            Select stdPymntAccession
                            from Quadax.dbo.stdPaymentFile
                            where stdPymntDOS like '2017%'
                            or stdPymntDOS like '2018%'
                            or stdPymntDOS like '201610%'
                            or stdPymntDOS like '201611%'
                            or stdPymntDOS like '201612%'
                            )
--and stdPymntTickNum in ('701515','704486')