/* Retrieve all HCOs. If there is a Payor Association relationship */
/* then find the assoicated Tier2 and Tier1 
In the Customer Affliliation object, the Account 1 is HCO , Account 2 is the 'parent', i.e. the Tier2 Payor */

select  
		case when T1.Tier1Payor is null then 'Unknown' else T1.Tier1Payor end as Tier1PayorName, T1.Tier1PayorID, T1.OSM_Payor_Hierarchy__c,
		case when T2.Tier2Payor is null then 'Unknown' else T2.Tier2Payor end as Tier2PayorName, T2.Tier2PayorID, T2.OSM_Payor_Hierarchy__c,
		T2.Acct_RecType, T2.Tier2_type, T2.Pricing_Category, T2.Tier2_Status,
		HCO.Name Tier4PayorName, HCO.OSM_Account_Number__c Tier4PayorID, HCO.OSM_Payor_Hierarchy__c,
		HCO.OSM_Status__c Tier4_Status, '' as QDX_Ins_Plan_Code, RecType.Name Financial_Category, HCO.Type LineOfBenefit,
		T1.Tier1_SysId, T2.Tier2_SysId,--Hierachy.HCO_SysId, Hierachy.Tier2Payor_SysId,
	    HCO.Id Tier4_SysId,
		CA.Name Cust_Aff_Num, CA.Id Cust_Aff_SysId
from StagingDB.ODS.StgAccount HCO
left join StagingDB.ODS.stgRecordType RecType on RecType.Id = HCO.RecordTypeId
left join (select OSM_Account_1__c HCO_SysId, OSM_Account_2__c Tier2Payor_SysId, Name, Id
		   from StagingDB.ODS.stgCustomerAffiliation
		   where OSM_Role__c in ('Payor Association')
		   and IsDeleted = 0) CA on HCO.Id = CA.HCO_SysId
left join (select Tier2.Id Tier2_SysId, Tier2.ParentId,
			Tier2.Name Tier2Payor, Tier2.OSM_Account_Number__c Tier2PayorID, Tier2.OSM_Payor_Hierarchy__c,
			RecType.Name Acct_RecType, Tier2.OSM_Payor_Type__c Tier2_Type,
			Tier2.OSM_Payor_Category__c Pricing_Category, Tier2.OSM_Status__c Tier2_Status
			from StagingDB.ODS.StgAccount Tier2
			left join StagingDB.ODS.stgRecordType RecType on RecType.Id = Tier2.RecordTypeId
			where Tier2.OSM_Payor_Hierarchy__c = 2
			) T2 on T2.Tier2_SysId = CA.Tier2Payor_SysId
left join (select Tier1.Id Tier1_SysId, Tier1.Name Tier1Payor, Tier1.OSM_Account_Number__c Tier1PayorID, Tier1.OSM_Payor_Hierarchy__c
		   from StagingDB.ODS.stgAccount Tier1
		   where Tier1.OSM_Payor_Hierarchy__c = 1
		   ) T1 on T1.Tier1_SysId = T2.ParentId
where (HCO.OSM_Payor_Hierarchy__c = 4 or HCO.OSM_Payor_Hierarchy__c is null)

UNION

/* Insurance Plans Info */
select
	   Case
			when T1.Tier1Payor is null then 'Unknown'
			when T1.Tier1Payor is not null then T1.Tier1Payor
	   end as Tier1PayorName,
	    T1.Tier1PayorId Tier1PayorID, T1.OSM_Payor_Hierarchy__c,
		A.Name Tier2PayorName, A.OSM_Account_Number__c Tier2PayorID, A.OSM_Payor_Hierarchy__c,
		RecType.Name Acct_RecType, A.OSM_Payor_Type__c Tier2_Type,
		A.OSM_Payor_Category__c Pricing_Category, A. OSM_Status__c Tier2_Status,
		PP.Tier4Payor Tier4PayorName, PP.Tier4PayorID,  PP. OSM_Payor_Hierarchy__c, PP.Tier4_Status,
		PP.QDX_Ins_Plan_Code, PP.Financial_Category, PP.LineOfBenefit,
--		A.ParentId,
		T1.Tier1_SysId, A.Id Tier2_SysId, PP.Tier4_SysId,
		'' as Cust_Aff_Num, '' as Cust_Aff_SysId 
from (
	   /* Plan records where IsDeleted = 0 */
	   select P.OSM_Payor__c, P.Id Tier4_SysId, P.Name Tier4Payor, P.OSM_Plan_ID__c Tier4PayorID, P.OSM_QDX_Insurance_Plan_Code__c QDX_Ins_Plan_Code, P. OSM_Payor_Hierarchy__c
	 		, RecType.Name LineOfBenefit , P.OSM_QDX_Financial_Category__c Financial_Category
			, P.OSM_Status__c Tier4_Status
	   from StagingDB.ODS.stgPlan P
	   left join StagingDB.ODS.stgRecordType RecType on RecType.Id = P.RecordTypeId
	   where P.IsDeleted = 0
	 ) PP
	left join StagingDB.ODS.StgAccount A on A.Id = PP.OSM_Payor__c
	left join StagingDB.ODS.stgRecordType RecType on RecType.Id = A.RecordTypeId
	left join (select Id Tier1_SysId, Name Tier1Payor, OSM_Account_Number__c Tier1PayorId, OSM_Payor_Hierarchy__c
			   from StagingDB.ODS.stgAccount) T1 on T1.Tier1_SysId = A.ParentId
order by Tier2PayorId