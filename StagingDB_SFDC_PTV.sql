/* PTV data dump */
Select ptv.Name
, ptv.LastModifiedDate
, A.OSM_Account_Number__c Tier2PayorID
, A.Name Tier2Payor
, '' as Tier4PayorID
, '' as Tier4Payor
, '' as QDX_InsPlan_Code
, A.OSM_Status__c Payor_Plan_Status
, '' as Financial_Category
, ptv.OSM_Line_of_Business__c Line_of_Business
, '' as Line_of_Benefits
, ptv.OSM_Line_of_Benefits__c PTV_Line_of_Benefits
, Test.Name Test
, ptv.OSM_Effective_Start_Date__c
, ptv.OSM_Effective_End_Date__c
, ptv.OSM_Billing_Modifier__c Billing_Modifier
, ptv.OSM_Prior_Authorization__c
, ptv.GHI_PayorSOMNTemplate__c
, ptv.OSM_PA_Required__c
, ptv.GHI_PhysicianAlertRequired__c
--, ptv.OSM_SOMN_Required__c
--, ptv.OSM_Report_Hold__c
--, ptv.OSM_Statement_of_Medical_Necessity__c
FROM [StagingDB].[ODS].[stgPTV] ptv
left join StagingDB.ODS.StgAccount A on ptv.OSM_Payor__c = A.Id
left join StagingDB.ODS.StgProduct test on ptv.OSM_Test__c = test.Id
where 
ptv.OSM_Payor__c is not null
and A.OSM_Status__c = 'Approved'
and ptv.OSM_Line_of_Business__c != 'Default'

Union All

Select ptv.Name
, ptv.LastModifiedDate
, A.OSM_Account_Number__c Tier2PayorID
, A.Name Tier2Payor
, P.OSM_Plan_ID__c Tier4PayorID
, P.Name Tier4Payor
, P.OSM_QDX_Insurance_Plan_Code__c QDX_InsPlan_Code
, P.OSM_Status__c Payor_Plan_Status
, P.OSM_QDX_Financial_Category__c Financial_Category
, ptv.OSM_Line_of_Business__c Line_of_Business
, RecordType.Name Line_of_Benefits
, ptv.OSM_Line_of_Benefits__c PTV_Line_of_Benefits
, Test.Name Test
, ptv.OSM_Effective_Start_Date__c
, ptv.OSM_Effective_End_Date__c
, ptv.OSM_Billing_Modifier__c Billing_Modifier
, ptv.OSM_Prior_Authorization__c
, ptv.GHI_PayorSOMNTemplate__c
, ptv.OSM_PA_Required__c
, ptv.GHI_PhysicianAlertRequired__c
--, ptv.OSM_SOMN_Required__c
--, ptv.OSM_Report_Hold__c
--, ptv.OSM_Statement_of_Medical_Necessity__c
FROM [StagingDB].[ODS].[stgPTV] ptv
left join StagingDB.ODS.stgPlan P on ptv.OSM_Plan__c = P.Id
left join StagingDB.ODS.StgProduct test on ptv.OSM_Test__c = test.Id
left join StagingDB.ODS.stgRecordType RecordType on P.RecordTypeId = RecordType.Id
left join StagingDB.ODS.StgAccount A on P.OSM_Payor__c = A.Id
where 
ptv.OSM_Plan__c is not null
and P.OSM_Status__c = 'Active'
and ptv.OSM_Line_of_Business__c != 'Default'
--and P.OSM_Plan_ID__c = 'PL0006065'