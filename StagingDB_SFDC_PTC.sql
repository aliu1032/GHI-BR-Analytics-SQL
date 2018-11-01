select
	ptc.Name
	, ptc.OSM_Type__c Policy
	, RecT.Name Test
	, ptc.LastModifiedDate
--	, ptc.OSM_Test_Name__c
	, A.Name Tier2PayorName
	, A.OSM_Account_Number__c Tier2PayorID
	, '' as Tier4PayorName
	, '' as Tier4PayorID
	, '' as QDX_InsPlan_Code
	, A.OSM_Status__c Payor_Plan_Status
	, '' as Financial_Category
	, ptc.OSM_Line_of_Business__c Line_of_Business
	, ptc.OSM_Eff_Start_Clinical_Criteria__c
	, ptc.OSM_Eff_End_Clinical_Criteria__c
	, ptc.OSM_Policy_Status__c Policy_Status

	, ptc.GHI_RecentlyNewlyDiagnosis__c  --IBC
	, ptc.GHI_AgeAtDiagnosisRange__c   --IBC
	, ptc.GHI_PatientHadAPriorOncotypeTest__c   --IBC
	, ptc.GHI_PatientGender__c   --IBC
	, ptc.GHI_MultiTumor__c   --IBC
	, ptc.GHI_Stage__c  -- IBC & DCIS
	, ptc.GHI_NodeStatus__c  -- IBC & DCS
	, ptc.GHI_ERStatus__c   -- IBC & DCS
	, ptc.GHI_PRStatus__c  -- IBC & DCS
	, ptc.GHI_HormoneReceptorHR__c  -- DCIS
	, ptc.GHI_HER2mode__c  -- IBC & DCS
	, ptc.GHI_HER2Status__c   --IBC
	, ptc.GHI_DCISSize__c  -- DCIS
	, ptc.GHI_TumorSize__c   --IBC
	, ptc.GHI_TumorHistology__c   --IBC
	, ptc.GHI_ProcedureType__c   --IBC
	, ptc.GHI_PostMenopausalWomen__c   --IBC
	, ptc.GHI_MedOncOrder__c  -- IBC & DCS
	, ptc.GHI_EvidenceOfDistantMetastaticBC__c   --IBC
	, ptc.GHI_MultifocalityPerPathologyReport__c  -- DCIS
	, ptc.GHI_UniOrBiLateral__c  -- DCIS
	, ptc.GHI_PresenceOfNecrosis__c  -- DCIS
	, ptc.GHI_HistologicSubtype__c  -- DCIS
	, ptc.GHI_PathologicalGrade__c  -- DCIS
	, ptc.GHI_MultiTumorTestExecution__c   --IBC

	, ptc.GHI_AgeOfBiopsy__c
	, ptc.Prostate_Patient_life_expectance_10_20__c
	, ptc.GHI_NCCNRiskCategory__c
	, ptc.GHI_HCPProvidedGleasonScore__c
	, ptc.GHI_HCPProvidedClinicalStage__c
	, ptc.GHI_MaxTumorInvolvement__c
	, ptc.GHI_CTR__c
	, ptc.GHI_HCPProvidedPSANgMl__c
	, ptc.GHI_HCPProvidedNumberOfPositiveCores__c
	, ptc.GHI_NumberOfCores__c

	, ptc.GHI_CastrateResistanceProstateCancer__c
	, ptc.GHI_ClinicalStageAtLastVisit__c
	, ptc.GHI_PriorTherapies__c

	, ptc.GHI_ExtraNoteOnTestCoverage__c

from StagingDB.ODS.stgPTC ptc
left join StagingDB.ODS.StgAccount A on A.Id = ptc.OSM_Payor__c
left join StagingDB.ODS.stgRecordType RecT on ptc.RecordTypeId = RecT.Id
where ptc.OSM_Payor__c is not null and ptc.OSM_Plan__c is null
  and A.OSM_Status__c = 'Approved'	
  and ptc.OSM_Type__c in ('CT','MP')
  and ptc.IsDeleted = 0
  and ptc.OSM_Line_of_Business__c != 'Default'
--  and RecT.Name = 'IBC'

  Union All

select

	ptc.Name
	, ptc.OSM_Type__c Policy
	, RecT.Name Test	
	, ptc.LastModifiedDate
	, A.Name Tier2PayorName
	, A.OSM_Account_Number__c Tier2PayorID
	, P.Name Tier4PayorName
	, P.OSM_Plan_ID__c Tier4PayorID
	, P.OSM_QDX_Insurance_Plan_Code__c QDX_InsPlan_Code
	, P.OSM_Status__c Payor_Plan_Status
	, P.OSM_QDX_Financial_Category__c Financial_Category
	, ptc.OSM_Line_of_Business__c Line_of_Business
	, ptc.OSM_Eff_Start_Clinical_Criteria__c
	, ptc.OSM_Eff_End_Clinical_Criteria__c
	, ptc.OSM_Policy_Status__c Policy_Status

	, ptc.GHI_RecentlyNewlyDiagnosis__c  --IBC
	, ptc.GHI_AgeAtDiagnosisRange__c   --IBC
	, ptc.GHI_PatientHadAPriorOncotypeTest__c   --IBC
	, ptc.GHI_PatientGender__c   --IBC
	, ptc.GHI_MultiTumor__c   --IBC
	, ptc.GHI_Stage__c  -- IBC & DCIS
	, ptc.GHI_NodeStatus__c  -- IBC & DCS
	, ptc.GHI_ERStatus__c   -- IBC & DCS
	, ptc.GHI_PRStatus__c  -- IBC & DCS
	, ptc.GHI_HormoneReceptorHR__c  -- DCIS
	, ptc.GHI_HER2mode__c  -- IBC & DCS
	, ptc.GHI_HER2Status__c   --IBC
	, ptc.GHI_DCISSize__c  -- DCIS
	, ptc.GHI_TumorSize__c   --IBC
	, ptc.GHI_TumorHistology__c   --IBC
	, ptc.GHI_ProcedureType__c   --IBC
	, ptc.GHI_PostMenopausalWomen__c   --IBC
	, ptc.GHI_MedOncOrder__c  -- IBC & DCS
	, ptc.GHI_EvidenceOfDistantMetastaticBC__c   --IBC
	, ptc.GHI_MultifocalityPerPathologyReport__c  -- DCIS
	, ptc.GHI_UniOrBiLateral__c  -- DCIS
	, ptc.GHI_PresenceOfNecrosis__c  -- DCIS
	, ptc.GHI_HistologicSubtype__c  -- DCIS
	, ptc.GHI_PathologicalGrade__c  -- DCIS
	, ptc.GHI_MultiTumorTestExecution__c   --IBC

	, ptc.GHI_AgeOfBiopsy__c
	, ptc.Prostate_Patient_life_expectance_10_20__c
	, ptc.GHI_NCCNRiskCategory__c
	, ptc.GHI_HCPProvidedGleasonScore__c
	, ptc.GHI_HCPProvidedClinicalStage__c
	, ptc.GHI_MaxTumorInvolvement__c
	, ptc.GHI_CTR__c
	, ptc.GHI_HCPProvidedPSANgMl__c
	, ptc.GHI_HCPProvidedNumberOfPositiveCores__c
	, ptc.GHI_NumberOfCores__c

	, ptc.GHI_CastrateResistanceProstateCancer__c
	, ptc.GHI_ClinicalStageAtLastVisit__c
	, ptc.GHI_PriorTherapies__c

	, ptc.GHI_ExtraNoteOnTestCoverage__c

from StagingDB.ODS.stgPTC ptc
left join StagingDB.ODS.stgPlan P on P.Id = ptc.OSM_Plan__c
left join StagingDB.ODS.StgAccount A on A.Id = P.OSM_Payor__c
left join StagingDB.ODS.stgRecordType RecT on RecT.Id = ptc.RecordTypeId
where 
  ptc.OSM_Plan__c is not null
  and P.OSM_Status__c = 'Active'
  and ptc.OSM_Type__c in ('CT','MP')
  and ptc.IsDeleted = 0
  and ptc.OSM_Line_of_Business__c != 'Default'
--  and RecT.Name = 'IBC'
-- and p.OSM_Plan_ID__c = 'PL0003959'