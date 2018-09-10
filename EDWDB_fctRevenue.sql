
Select Rev.OrderLineItemID
      , Rev.TicketNumber
      , Rev.Test
      , Rev.Tier1PayorID, Rev.Tier1PayorName
      , Rev.Tier2PayorID, Rev.Tier2PayorName
      , Rev.Tier4PayorID, Rev.Tier4PayorName
      , Rev.QDXInsuranceCode
      , Rev.FinancialCategory, Rev.Tier3PayorType
      , Rev.AccountingPeriod, Rev.AccountingPeriodDate
      , Rev.ClaimPeriod, Rev.ClaimPeriodDate
      , OLI.TestDeliveredDate
      , Rev.Tier2PayorCountryISOCode, Rev.ClaimPayorCountry
      , Rev.ClaimPayorBusinessUnit, Rev.ClaimPayorInternationalArea
      , Rev.ClaimPayorDivision
      , Rev.CurrencyCode
      , Rev.TotalRevenue, Rev.TotalAccrualRevenue, Rev.TotalCashRevenue
      , Rev.TotalUSDRevenue, Rev.TotalUSDAccrualRevenue, Rev.TotalUSDCashRevenue
      , Rev.IsRevenueReconciliationAdjustment
from
		(Select temp_rev.*
			, AcctPeriod.AccountingPeriod
			, AcctPeriod.AccountingPeriodDate
			, ClaimPeriod.ClaimPeriod
			, ClaimPeriod.ClaimPeriodDate
		from
							( Select
                            fctRev.OrderLineItemID OrderLineItemID
                            , fctRev.TicketNumber TicketNumber
							, fctRev.RevenueAccountingPeriodKey
                            , fctRev.ClaimAccountingPeriodKey
                            , dimTest.TestName Test
                            , dimPayor.Tier1PayorID Tier1PayorID
                            , dimPayor.Tier1PayorName Tier1PayorName
                            , dimPayor.Tier2PayorID Tier2PayorID
                            , dimPayor.Tier2PayorName Tier2PayorName
                            , dimPayor.Tier4PayorID Tier4PayorID
                            , dimPayor.Tier4PayorName Tier4PayorName
                            , dimPayor.Tier4PayorQuadaxInsuranceCode QDXInsuranceCode
                            , dimPayor.Tier4PayorFinancialCategoryDescription FinancialCategory
                            , dimPayor.Tier2PayorPricingCategoryDescription T2PricingCategory
                            , dimPayor.Tier3PayorTypeDescription Tier3PayorType
                            --, dimPayor.Tier4PayorLineOfBusiness T4LineOfBusiness
                            , dimPayor.GNAMTerritoryID GNAMTerritoryID
                            , dimPayor.StandardizedTier2PayorState ClaimPayorState
                            , dimPayor.Tier2PayorCountryISOCode
                            , dimPayorCountry.CountryCode ClaimPayorCountry
                            , dimPayorCountry.BusinessUnitName ClaimPayorBusinessUnit
                            , dimPayorCountry.InternationalAreaName ClaimPayorInternationalArea
                            , dimPayorCountry.DivisionName ClaimPayorDivision

                            /* -- OLI related information is from fctOrderLineItem
							   -- Receipt and Payment data source from Quadax file
                            , dimBS.IsCharge IsCharge
                            , dimBS.IsInCoverageCriteria IsInCoverageCriteria
                            , dimBS.RevenueStatus RevenueStatus
                            , fctRev.IsActiveClaim IsActiveClaim
                            , fctRev.TotalBilledAmount TotalBilledAmount
                            , fctRev.TotalPaymentAmount TotalPaymentAmount
                            , fctRev.TotalPayorPaymentAmount TotalPayorPaymentAmount
                            , fctRev.TotalPatientPaymentAmount TotalPatientPaymentAmount
                            , fctRev.TotalAdjustmentAmount TotalAdjustmentAmount
                            , fctRev.CurrentOutstandingAmount CurrentOutstandingAmount
                            , fctRev.CurrentPayorOutstandingAmount CurrentPayorOutstandingAmount
                            , fctRev.CurrentPatientOutstandingAmount CurrentPatientOutstandingAmount
                            */
                            , dimCurrency.CurrencyCode
                            , fctRev.TotalCashRevenue TotalCashRevenue
                            , fctRev.TotalAccrualRevenue TotalAccrualRevenue
                            , fctRev.TotalRevenue TotalRevenue
                            --, fctRev.TotalMedicareRevenue TotalMedicareRevenue
                            --, fctRev.TotalStudyRevenue TotalStudyRevenue
                            , fctRev.TotalUSDCashRevenue TotalUSDCashRevenue
                            , fctRev.TotalUSDAccrualRevenue TotalUSDAccrualRevenue
                            , fctRev.TotalUSDRevenue TotalUSDRevenue
                            --, fctRev.TotalUSDMedicareRevenue TotalUSDMedicareRevenue
                            --, fctRev.TotalUSDStudyRevenue TotalUSDStudyRevenue
                            , fctRev.IsRevenueReconciliationAdjustment IsRevenueReconciliationAdjustment

                            /* -- get the OLI related information from fctOrderLineItem
                            , dimCC.IBC_NodalStatusDescription NodalStatus
                            , dimCC.ReportingGroupDescription ReportingGroup
                            , dimHCO.HCOID OrderingHCOID
                            , dimHCO.HCOName OrderingHCOName
                            , dimHCO.HCOState OrderingHCOState
                            , dimHCOCountry.CountryName OrderingHCOCountry
                            , dimHCOCountry.BusinessUnitName OrderingHCOBusinessUnit
                            , dimHCOCountry.InternationalAreaName OrderingHCOInternationalArea
                            */
                        from EDWDB.dbo.fctRevenue fctRev
                            , EDWDB.dbo.dimTest dimTest
                            , EDWDB.dbo.dimPayor dimPayor
                            , EDWDB.dbo.dimCurrency dimCurrency
                            , EDWDB.dbo.dimCountry dimPayorCountry
                            /*
                            , EDWDB.dbo.dimBillableStatus dimBS
                            , EDWDB.dbo.dimHCO dimHCO
                            , EDWDB.dbo.dimCountry dimHCOCountry
                            , EDWDB.dbo.dimClinicalCriteria dimCC
                            */
                        where
							fctRev.TestKey = dimTest.TestKey
                        and fctRev.ClaimPayorKey = dimPayor.PayorKey
                        and fctRev.CurrencyKey = dimCurrency.CurrencyKey
                        and fctRev.ClaimPayorCountryKey = dimPayorCountry.CountryKey
						/*
                        and fctRev.BillableStatusKey = dimBS.BillableStatusKey
                        and fctRev.CurrentOrderingHCOKey = dimHCO.HCOKey
                        and fctRev.OrderingHCOCountryKey = dimHCOCountry.CountryKey
                        and fctRev.ClinicalCriteriaKey = dimCC.ClinicalCriteriaKey
                        */
                        ) temp_rev
        /* expand AccountingPeriodKey to Period and Date */
				left join (
						Select dimAC.AccountingPeriodKey
						 , dimAC.AccountingPeriodMonth_4DigitYear AccountingPeriod
						 , startdate.CalendarMonthStartDate AccountingPeriodDate
						from EDWDB.dbo.dimAccountingPeriod dimAC
								left join (Select dimDate.CalendarMonth_4DigitYear, min(DateInteger) CalendarMonthStartDate
										   from EDWDB.dbo.dimDate dimDate
										   group by dimDate.CalendarMonth_4DigitYear) startdate
								on dimAC.AccountingPeriodMonth_4DigitYear = startdate.CalendarMonth_4DigitYear
						) AcctPeriod
						on temp_rev.RevenueAccountingPeriodKey = AcctPeriod.AccountingPeriodKey
				/* expand ClaimPeriodKey to Period and Date */
				left join (
						Select dimAC.AccountingPeriodKey
						 , dimAC.AccountingPeriodMonth_4DigitYear ClaimPeriod
						 , startdate.CalendarMonthStartDate ClaimPeriodDate
						from EDWDB.dbo.dimAccountingPeriod dimAC
								left join (Select dimDate.CalendarMonth_4DigitYear, min(DateInteger) CalendarMonthStartDate
										   from EDWDB.dbo.dimDate dimDate
										   group by dimDate.CalendarMonth_4DigitYear) startdate
								on dimAC.AccountingPeriodMonth_4DigitYear = startdate.CalendarMonth_4DigitYear
						) ClaimPeriod
						on temp_rev.ClaimAccountingPeriodKey = CLaimPeriod.AccountingPeriodKey
		) Rev

    /* pulling Test Delivered Date from OrderLineItem */
		left join (select fctOLI.OrderLineItemID OrderLineItemID
		                , dimTestDeliveryDate.DateInteger TestDeliveredDate
                    from 
					     EDWDB.dbo.vwFctOrderLineItem fctOLI
                         ,EDWDB.dbo.dimDate dimTestDeliveryDate
						 /* dont use fctOrderLineItem, use vwFctOrderLineItem: the DateKey needs a lot of work to
						 resolve into Test Delivered Date and KPIs date */
						 -- EDWDB.dbo.fctOrderLineItem fctOLI
                    where fctOLI.TestDeliveredDateKey = dimTestDeliveryDate.DateKey
                    ) OLI
		on Rev.OrderLineItemID = OLI.OrderLineItemID
    where Rev.AccountingPeriodDate >= 20170101
    /*
		and Rev.OrderLineItemID = 'OL000738856'
	*/


	/* there are a few records where the sum of Accrual & Cash revenue do not equal to Revenue */

	/*
	select dimAP.AccountingPeriodYear, dimAP.AccountingPeriodMonth, * , (TotalRevenue-TotalCashRevenue-TotalAccrualRevenue) A
	from EDWDB.dbo.fctRevenue
	left join dbo.dimAccountingPeriod dimAP on RevenueAccountingPeriodKey = dimAP.AccountingPeriodKey
	where OrderLineItemID is null
	and (TotalRevenue-TotalCashRevenue-TotalAccrualRevenue) != 0.00
    */