 select denResp.*,
		E.CodeSeq, E.ErrorCode, E.ansiErrorDesc
 from 
	/* find the unique denialRespInfo from Payor */
	(select denialRespTickNum, denialRespInsCode, denialRespDt, min(denialRespSeq) denialRespSeq, denialRespInsName
	   from Quadax.dbo.denialRespInfo
   group by denialRespTickNum, denialRespDt, denialRespInsCode, denialRespInsName
	) as denResp
 left join (
			/* unpivot denialErrorCode, each response may have up to 6 denial error codes */
			select denialErrorTickNum, denialErrorSeq, CodeSeq, ErrorCode, CodeDesc.ansiErrorDesc
			from (Select denialErrorTickNum, denialErrorSeq, denialErrorCode1, denialErrorCode2,
						 denialErrorCode3, denialErrorCode4, denialErrorCode5, denialErrorCode6 
				    from Quadax.dbo.denialErrorInfo) as A
			unpivot (ErrorCode for CodeSeq IN 
						(denialErrorCode1, denialErrorCode2, denialErrorCode3, denialErrorCode4, denialErrorCode5, denialErrorCode6)) unpiv
						/* joing the ansiErrorCode to get the error description */
						left join (select distinct ansiErrorCode, ansiErrorDesc
											  from Quadax.dbo.ansiErrorCodes) CodeDesc on ErrorCode = CodeDesc.ansiErrorCode
											 where ErrorCode != ''
			) E
	on denialRespSeq = E.denialErrorSeq and denialRespTickNum = denialErrorTickNum
    where denialRespTickNum in (select stdClmTickNum
								from Quadax.dbo.stdClaimFile
								where stdClmDOS like '2017%'
								   or stdClmDOS like '2018%'
								   or stdClmDOS like '2016%')
	--denialRespTickNum = '380987'
	--where denialRespDt like '2017%'
	--   or denialRespDt like '2018%'
	order by denialErrorSeq