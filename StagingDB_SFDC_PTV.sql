/* PTV data dump */
Select ptv.Name PTV_id
, ptv.LastModifiedDate
, A.OSM_Account_Number__c Tier2PayorId
, A.Name Tier2Payor
, '' as Tier4PayorId
, '' as Tier4Payor
, '' as QDX_InsPlan_Code
, A.OSM_Status__c Payor_Plan_Status
, '' as Financial_Category
, ptv.OSM_Line_of_Business__c
, '' as Tier3
, ptv.OSM_Line_of_Benefits__c
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
, StagingDB.ODS.StgAccount A
, StagingDB.ODS.StgProduct test
where 
ptv.OSM_Payor__c = A.Id
and ptv.OSM_Payor__c is not null
and A.OSM_Status__c = 'Approved'
and ptv.OSM_Test__c = test.Id
and ptv.LastModifiedDate >= '04-17-2018'

Union All

Select ptv.Name PTV_id
, ptv.LastModifiedDate
, A.OSM_Account_Number__c Tier2PayorId
, A.Name Tier2Payor
, P.OSM_Plan_ID__c Tier4PayorId
, P.Name Tier4Payor
, P.OSM_QDX_Insurance_Plan_Code__c QDX_InsPlan_Code
, P.OSM_Status__c Payor_Plan_Status
, P.OSM_QDX_Financial_Category__c Financial_Category
, ptv.OSM_Line_of_Business__c
, RecordType.Name Tier3
, ptv.OSM_Line_of_Benefits__c
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
, StagingDB.ODS.StgAccount A
, StagingDB.ODS.stgPlan P
, StagingDB.ODS.StgProduct test
, StagingDB.ODS.stgRecordType RecordType
where 
ptv.OSM_Plan__c = P.Id
and ptv.OSM_Plan__c is not null
and ptv.OSM_Test__c = test.Id
and P.RecordTypeId = RecordType.Id
and P.OSM_Status__c = 'Active'
and P.OSM_Payor__c = A.Id
and ptv.LastModifiedDate >= '04-17-2018'
--and P.OSM_Plan_ID__c = 'PL0006065'