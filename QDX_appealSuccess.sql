select
      A.appealTickNum,
      A.appealCaseNum,
      A.appealReqNum,
      A.appealAccession,
      A.appealDOS,
      A.appealInscode appealInsCode,
      A.appealInsFC,
      A.appealDenReason,
	  R.clientTableDesc appealDenReasonDesc,
      A.appealAmtChg,
      A.appealAmtChgExp,
      A.appealAmtAllow,
      A.appealAmtClmRec,
      A.appealAmt,
      A.appealAmtAplRec,
      A.appealRptDt,
      A.appealCnt,
      A.appealSuccess,
      A.appealPH,
	  A.appealCurrency
from Quadax.dbo.appealsuccess A
left join (select distinct clientTableDesc, clientTableCode
			 from Quadax.dbo.clientSelfDescInfo
			where clientTableType = 'DN' 
			  and clientTableDesc != 'GOA') R
		 on appealDenReason = clientTableCode
