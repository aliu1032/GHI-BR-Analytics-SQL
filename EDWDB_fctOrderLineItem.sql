Select
	fctOLI.OrderID OrderID
    	, fctOLI.OrderSystemID OrderSystemID
    	, fctOLI.OrderLineItemID OLIID
    	, fctOLI.OrderLineItemSystemID OrderLineItemSystemID
    	, dimTest.TestName Test

	/* related dates */
	, dimTestDeliveryDate.DateInteger TestDeliveredDate
    	, dimDateOfService.DateInteger DateOfService
    	, dimOrderStartDate.DateInteger OrderStartDate
    	, dimOLIStartDate.DateInteger OLIStartDate

	/* Order & OLI status */
		, dimOLIStatus.CustomerStatusDescription CustomerStatus
		, dimOLIStatus.DataEntryStatusDescription DataEntryStatus
		, dimOLIStatus.OrderStatusDescription OrderStatus
		--, dimOLIStatus.OrderStateDescription OrderState
		, dimOLIStatus.OrderLineItemStateDescription OLIState
		, dimOLIStatus.OrderLineItemLabAndReportStatusDescription LabReportStatus
		, dimChannel.ChannelDescription Channel

	/* Order & OLI Cancellation Reason */
		, dimCancellationReason.OrderCancellationReasonDescription OrderCancellationReason
		, dimCancellationReason.OrderLineItemCancellationReasonDescription OrderLineItemCancellationReason

	/* OLI Flags */
    	, fctOLI.TestDelivered TestDelivered
    	, fctOLI.BilledTest BilledTest /*IsClaim */
    	, fctOLI.IsFullyAdjudicated IsFullyAdjudicated
		, fctOLI.DemandByTest Reportable
		, fctOLI.CreditableTest Creditable
		, dimBillableStatus.IsCharge IsCharge /*ref: fctRevenue : sth. to do will bill account */
		, Case 
		  when dimBillableStatus.IsInCoverageCriteria = 1 then 'In'
		  when dimBillableStatus.IsInCoverageCriteria = 0 then 'Out'
		  else 'Unknown'
		  end as NSInCriteria /* reference: dimCoverageCriteriaStatus.IsInCoverageCriteriaName */
    	, dimBillableStatus.RevenueStatus RevenueStatus
		, dimBillableStatus.BillingStatusDescription BillingStatus /*this is the SFDC Billing Status, this does not always reflect BilledTest = 1*/
		, dimBillableStatus.BillTypeDescription BillType
		, dimBillableStatus.BillEntityDescription BillingPolicyBillEntity

	/* Original Territory */
		, dimTerritory.TerritoryName Territory
		, dimTerritory.AreaName TerritoryArea
		, dimTerritory.RegionName TerritoryRegion
    	, Case
		  when dimTerritory.BusinessUnitName = 'US Business Unit' then 'Domestic'
		  when dimTerritory.BusinessUnitName = 'International Business Unit' then 'International'
		  end as BusinessUnit

		, dimTerritory.InternationalAreaName InternationalArea
		, dimTerritory.DivisionName Division
		, dimTerritory.CountryName Country

	/* Ordering HCP and HCO information */
    	, dimOrderingHCP.FullName OrderingHCPName
    	, dimOrderingHCP.HCPCity OrderingHCPCity
    	, dimOrderingHCP.StandardizedHCPStateCode OrderingHCPState
    	, dimOrderingHCP.HCPCountry OrderingHCPCountry
    	, dimOrderingHCP.HCPCountryISOCode OrderingHCPCountryISO
		, dimOrderingHCP.SpecialtyDescription Specialty
    	, dimOrderingHCP.IsCTR IsOrderingHCPCTR
    	, dimOrderingHCP.IsPECOS IsOrderingHCPPECOS

		, dimOriginalOrderingHCO.HCOName OrderingHCO
		, dimOriginalOrderingHCO.HCOCity OrderingHCOCity
		, dimOriginalOrderingHCO.StandardizedHCOStateCode OrderingHCOState
		, dimOriginalOrderingHCO.HCOCountry OrderingHCOCountry
		, dimOriginalOrderingHCO.HCOCountryISOCode OrderingHCOCountryISO

	/* Specimen Submitting HCP */
		, dimSpecimenSubmittingHCP.FullName SpecimenSubmittingHCPName
    	, dimSpecimenSubmittingHCP.HCPCity SpecimenSubmittingHCPCity
    	, dimSpecimenSubmittingHCP.StandardizedHCPStateCode SpecimenSubmittingHCPState
    	, dimSpecimenSubmittingHCP.HCPCountry SpecimenSubmittingHCPCountry
    	, dimSpecimenSubmittingHCP.HCPCountryISOCode SpecimenSubmittingHCPCountryISO
		, dimSpecimenSubmittingHCP.NationalProviderIdentifier NPIforSpecimenSubmittingHCP
		, dimSpecimenSubmittingHCP.IsCTR CTRforSpecimenSubmittingHCP

	/* Payor and Insurance Information */
		
		/*
		, dimSalesOrderPayor.Tier1PayorID Tier1PayorID
    	, dimSalesOrderPayor.Tier1PayorName Tier1PayorName
    	, dimSalesOrderPayor.Tier2PayorID Tier2PayorID
    	, dimSalesOrderPayor.Tier2PayorName Tier2PayorName
    	, dimSalesOrderPayor.Tier4PayorID Tier4PayorID
    	, dimSalesOrderPayor.Tier4PayorName Tier4PayorName
		, dimSalesOrderPayor.Tier4PayorQuadaxInsuranceCode QDXInsPlanCode
		, dimSalesOrderPayor.Tier4PayorFinancialCategoryDescription FinancialCategory
    	, dimSalesOrderPayor.Tier3PayorTypeDescription LineOfBenefit
		*/

		, dimRecognizedPayor.Tier1PayorID Tier1PayorID
    	, dimRecognizedPayor.Tier1PayorName Tier1PayorName
    	, dimRecognizedPayor.Tier2PayorID Tier2PayorID
    	, dimRecognizedPayor.Tier2PayorName Tier2PayorName
    	, dimRecognizedPayor.Tier4PayorID Tier4PayorID
    	, dimRecognizedPayor.Tier4PayorName Tier4PayorName
		, dimRecognizedPayor.Tier4PayorQuadaxInsuranceCode QDXInsPlanCode
		, dimRecognizedPayor.Tier4PayorFinancialCategoryDescription FinancialCategory
    	, dimRecognizedPayor.Tier3PayorTypeDescription LineOfBenefit


	/* Claim information */
    	, fctOLI.CurrentTicketNumber CurrentTicketNumber
    	, dimBillingCaseStatus.CaseStatusCode BillingCaseStatusCode
    	, dimBillingCaseStatus.CaseStatusDetailDescription BillingCaseStatus
    	, dimBillingCaseStatus.CaseStatusSummaryLevel1 BillingCaseStatusSummary1
    	, dimBillingCaseStatus.CaseStatusSummaryLevel2 BillingCaseStatusSummary2
    	, dimAppLevel.AppealLevelCode AppealLevelCode /* A1, A2, etc */
    	, dimAppLevel.AppealLevelDescription AppealLevel /* 1,2,99 */
    	, dimAppStatus.AppealStatusCode AppealStatusCode
    	, dimAppStatus.AppealStatusDescription AppealStatus
    	, dimAppDenial.AppealDenialReasonCode AppealDenialReasonCode
    	, dimAppDenial.AppealDenialReasonDescription AppealDenialReason
	, dimDenialLetterDate.DateInteger DenialLetterDate
    	
	/* Claim and Payment data */
    	, dimCurrency.CurrencyCode BilledCurrency
	    , fctOLI.ListBilledCurrencyPrice ListPrice
    	, fctOLI.ContractedBilledCurrencyPrice ContractedPrice
    	, fctOLI.TotalBilledCurrencyBilledAmount BilledAmount
    	, fctOLI.TotalBilledCurrencyPaymentAmount TotalPayment
    	, fctOLI.TotalBilledCurrencyPayorPaymentAmount PayorPaid
    	, fctOLI.TotalBilledCurrencyPatientPaymentAmount PatientPaid
    	, fctOLI.TotalBilledCurrencyAdjustmentAmount TotalAdjustment
    	, fctOLI.TotalBilledCurrencyOutstandingAmount CurrentOutstanding

	/* HCP Submitted Clinical Criteria on an OLI */
		, fctOLI.SubmittingDiagnosis SubmittingDiagnosis
		, dimClinicalCriteria.ReportingGroupDescription ReportingGroup
		, Case
		  when dimClinicalCriteria.IBC_NodalStatusDescription = 'Unspecified' then 'Unknown'
		  else dimClinicalCriteria.IBC_NodalStatusDescription
		  end as NodalStatus

		, Case 
		  when dimTest.TestName = 'IBC' then dimClinicalCriteria.IBC_ClinicalStageDescription 
		  when dimTest.TestName = 'DCIS' then dimClinicalCriteria.DCIS_ClinicalStageDescription		
		  when dimTest.TestName = 'Colon' then dimClinicalCriteria.Colon_ClinicalStageDescription
		  when dimTest.TestName = 'Prostate' then dimClinicalCriteria.Prostate_HCPProvidedClinicalStageDescription
		  END AS HCPProvidedClinicalStage

		, dimClinicalCriteria.IBC_ERStatusDescription SubmittedER
		, dimClinicalCriteria.IBC_SubmittedHer2Description SubmittedHER2
		, MultiplePrimaries = (fctOLI.IsMultiplePrimaryConfirmed & fctOLI.IsMultiplePrimaryRequested)
		, fctOLI.IsMultiplePrimaryConfirmed
		, fctOLI.IsMultiplePrimaryRequested
		, fctOLI.HCPProvidedPSA
		, dimClinicalCriteria.Prostate_HCPProvidedGleasonScoreDescription HCPProvidedGleasonScore
		, dimOrderLineItem.IBC_TumorSizeCentimeters
		, dimOrderLineItem.IBC_SubmittedPRStatusDescription SubmittedPR
		, fctOLI.DCISTumorSize DCISTumorSize
    	, dimClinicalCriteria.DCIS_TumorSizeRangeDescription DCISTumorSizeRange
		, dimClinicalCriteria.Prostate_NCCNRiskCategoryDescription SubmittedNCCNRisk


	/* Test result from GHI lab */
		, dimCategoricalLabResult.RiskGroupDescription RiskGroup
		, dimCategoricalLabResult.ClincialStageDescription ClinicalStage
		, dimCategoricalLabResult.ERStatusDescription ERStatus
		, dimCategoricalLabResult.HER2StatusDescription HER2Status
		, dimCategoricalLabResult.PRStatusDescription PRStatus

		, Case
		  when dimCategoricalLabResult.EstimatedNCCNRiskDescription is null then ''
		  when dimCategoricalLabResult.EstimatedNCCNRiskDescription = 'Very_Low_Risk' then 'Very Low Risk'
		  when dimCategoricalLabResult.EstimatedNCCNRiskDescription = 'Low_Risk' then 'Low Risk'
		  when dimCategoricalLabResult.EstimatedNCCNRiskDescription = 'Intermediate_Risk' then 'Intermediate Risk'
		  when dimCategoricalLabResult.EstimatedNCCNRiskDescription = 'Favorable_Intermediate_Risk' then 'Favorable Intermediate'
		  when dimCategoricalLabResult.EstimatedNCCNRiskDescription = 'Unfavorable_Intermediate_Risk' then 'Unfavorable Intermediate'
		  when dimCategoricalLabResult.EstimatedNCCNRiskDescription = 'High_Risk' then 'High Risk'
		  when dimCategoricalLabResult.EstimatedNCCNRiskDescription = 'Unfavorable_Intermediate_or_High_Risk' then 'Unfavorable Intermediate or High Risk'
		  end as EstimatedNCCNRisk
		, dimCategoricalLabResult.FavorablePathologyComparisonDescription FavorablePathologyComparison

	/* Test result that GHI provided to Patient on report*/
		, fctOLI.ReportSpecimenExternalID ExternalSpecimenID
		, fctOLI.RecurrenceScore RecurrenceScore
		, fctOLI.HER2GeneScore HER2GeneScore
		, fctOLI.ERGeneScore ERGeneScore
		, fctOLI.PRGeneScore PRGeneScore
		, fctOLI.DCISScore DCISScore
		, fctOLI.GPScore GPScore

	/* Patient Age*/
		, fctOLI.PatientAgeAtDiagnosis
		, fctOLI.PatientAgeAtOrderStart

	/* Test failure Code */
		, dimFailureCode.FailureMessage FailureMessage
		, fctOLI.IsResult
		, fctOLI.IsFailure
		, dimTriageOutcome.TriageOutcomeDescription TriageOutcome

from EDWDB.dbo.vwFctOrderLineItem fctOLI
     
	left join EDWDB.dbo.dimTest dimTest on fctOLI.TestKey = dimTest.TestKey
	left join EDWDB.dbo.dimDate dimTestDeliveryDate on fctOLI.TestDeliveredDateKey = dimTestDeliveryDate.DateKey
	left join EDWDB.dbo.dimDate dimDateOfService on fctOLI.DateofServiceDateKey = dimDateOfService.DateKey
	left join EDWDB.dbo.dimDate dimOrderStartDate on fctOLI.OrderStartDateKey = dimOrderStartDate.DateKey
	left join EDWDB.dbo.dimDate dimOLIStartDate on fctOLI.OrderLineItemStartDateKey = dimOLIStartDate.DateKey
	left join EDWDB.dbo.dimStatus dimOLIStatus on fctOLI.StatusKey  = dimOLIStatus.StatusKey
	left join EDWDB.dbo.dimChannel dimChannel on fctOLI.ChannelKey = dimChannel.ChannelKey
	left join EDWDB.dbo.dimCancellationReason on fctOLI.CancellationReasonKey = dimCancellationReason.CancellationReasonKey
	left join EDWDB.dbo.dimBillableStatus dimBillableStatus on fctOLI.BillableStatusKey = dimBillableStatus.BillableStatusKey
	left join EDWDB.dbo.dimCoverageCriteriaStatus dimCoverageCriteriaStatus on dimBillableStatus.IsInCoverageCriteria = dimCoverageCriteriaStatus.IsInCoverageCriteria
	left join EDWDB.dbo.dimTerritory dimTerritory on fctOLI.OriginalTerritoryKey = dimTerritory.TerritoryKey
	left join EDWDB.dbo.dimHCP dimOrderingHCP on fctOLI.OrderingHCPKey = dimOrderingHCP.HCPKey
	left join EDWDB.dbo.dimHCO dimOriginalOrderingHCO on fctOLI.OriginalOrderingHCOKey = dimOriginalOrderingHCO.HCOKey 
	left join EDWDB.dbo.dimHCP dimSpecimenSubmittingHCP on fctOLI.SpecimenSubmittingHCPKey = dimSpecimenSubmittingHCP.HCPKey
	/* Recognized Payor is the one stamped on the Claim; Sales Order Payor is the one stamped in the SFDC OLI */
	--left join EDWDB.dbo.dimPayor dimSalesOrderPayor on fctOLI.SalesOrderPayorKey = dimSalesOrderPayor.PayorKey
	left join EDWDB.dbo.dimPayor dimRecognizedPayor on fctOLI.RecognizedPayorKey = dimRecognizedPayor.PayorKey
	left join EDWDB.dbo.dimBillingCaseStatus dimBillingCaseStatus on fctOLI.BillingCaseStatusKey = dimBillingCaseStatus.BillingCaseStatusKey
	left join EDWDB.dbo.dimAppealLevel dimAppLevel on fctOLI.AppealLevelKey = dimAppLevel.AppealLevelKey
	left join EDWDB.dbo.dimAppealStatus dimAppStatus on fctOLI.AppealStatusKey = dimAppStatus.AppealStatusKey
	left join EDWDB.dbo.dimDate dimDenialLetterDate on fctOLI.DenialLetterDateKey = dimDenialLetterDate.DateKey
	left join EDWDB.dbo.dimAppealDenialReason dimAppDenial on fctOLI.AppealDenialReasonKey = dimAppDenial.AppealDenialReasonKey
	left join EDWDB.dbo.dimCurrency dimCurrency on fctOLI.CurrentBilledCurrencyKey = dimCurrency.CurrencyKey
	left join EDWDB.dbo.dimClinicalCriteria dimClinicalCriteria on fctOLI.ClinicalCriteriaKey = dimClinicalCriteria.ClinicalCriteriaKey
	left join EDWDB.dbo.dimOrderLineItem dimOrderLineItem on fctOLI.OrderLineItemID = dimOrderLineItem.OrderLineItemID
	left join EDWDB.dbo.dimCategoricalLabResult dimCategoricalLabResult on fctOLI.CategoricalLabResultKey = dimCategoricalLabResult.CategoricalLabResultKey
	left join EDWDB.dbo.dimFailureCode dimFailureCode on fctOLI.FailureCodeKey = dimFailureCode.FailureCodeKey
	left join EDWDB.dbo.dimTriageOutcome dimTriageOutcome on fctOLI.TriageOutcomeKey = dimTriageOutcome.TriageOutcomeKey

where 
	/* select the OrderLineItem which has transactions posted in the selected accounting period range or Order start in select year
	   Accounting Period grain in months. cannot choose for a date */

	fctOLI.OrderLineItemID in (
       Select fctRev.OrderLineItemID
		 FROM [EDWDB].[dbo].[fctRevenue] fctRev
		     ,[EDWDB].[dbo].[dimAccountingPeriod] dimAcctPeriod
		where fctRev.RevenueAccountingPeriodKey = dimAcctPeriod.AccountingPeriodKey
		  and dimAcctPeriod.AccountingPeriodYearValue >=2016
		  --and dimAcctPeriod.AccountingPeriodMonthValue = 11
		  --and dimAcctPeriod.AccountingPeriodMonthValue <= 11

		 UNION

		 Select OrderLineItemID
		   from EDWDB.dbo.vwFctOrderLineItem
		 	  , EDWDB.dbo.dimDate dimOrderStartDateA
		 where OrderStartDateKey = dimOrderStartDateA.DateKey
		   and dimOrderStartDateA.CalendarYearValue >= 2016
		   --and dimOrderStartDateA.CalendarMonthValue = 11
        )
 -- and fctOLI.OrderLineItemID in ('OL001046979','OL001006299','OL001097795','OL001097779','OL001096680','OL001098246','OL001100732')
 -- and fctOLI.OrderLineItemID in ('OL000761250','OL000913816')
 -- and fctOLI.OrderID in ('OR001077870','OR001077883','OR001078111')

 /** need to use left join because there are null values in keys **/
 

 /*ISCharge - CAST(CASE StgAccount.OSM_Account_Number__c WHEN  'CR088578'
                              THEN 0
                              ELSE 1
                         END AS SMALLINT) IsCharge*/