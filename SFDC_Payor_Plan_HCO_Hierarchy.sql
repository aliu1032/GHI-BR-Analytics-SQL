/* HCOs with Payor relationship */
/* select the Account 1 HCO from Customer Affliliation, then find the 'parent' in the account 2 */
select 	 
	Case
		when T1.Tier1Payor is null then 'Unknown'
		when T1.Tier1Payor is not null then T1.Tier1Payor
	end as Tier1PayorName,
	T1.Tier1PayorId Tier1PayorID, T1.OSM_Payor_Hierarchy__c,
	Acct.Tier2Payor Tier2PayorName, Acct.Tier2PayorId Tier2PayorID, Acct.OSM_Payor_Hierarchy__c,
	Acct.Acct_RecType, Acct.Tier2_Type,
	Acct.Pricing_Category, Acct.Tier2_Status,
	HCO.Tier4Payor Tier4PayorName, HCO.Tier4PayorId Tier4PayorID, HCO.OSM_Payor_Hierarchy__c,
	HCO.Tier4_Status, HCO.QDX_Ins_Plan_Code, HCO.Financial_Category, HCO.LineOfBenefit,
	T1.Tier1_SysId, Acct.Tier2_SysId, HCO.Tier4_SysId,
	CA.Name Cust_Aff_Num, CA.Id Cust_Aff_SysId 
from StagingDB.ODS.stgCustomerAffiliation CA
left join (select A.Id Tier2_SysId, A.ParentId,
			A.Name Tier2Payor, A.OSM_Account_Number__c Tier2PayorId, A.OSM_Payor_Hierarchy__c,
			RecType.Name Acct_RecType, A.OSM_Payor_Type__c Tier2_Type,
			A.OSM_Payor_Category__c Pricing_Category, A. OSM_Status__c Tier2_Status
			from StagingDB.ODS.StgAccount A
			left join StagingDB.ODS.stgRecordType RecType on RecType.Id = A.RecordTypeId
		   ) Acct on CA.OSM_Account_2__c = Acct.Tier2_SysId
left join (select A.Id Tier4_SysId, A.Name Tier4Payor, A.OSM_Account_Number__c Tier4PayorId, A.OSM_Payor_Hierarchy__c, A.OSM_Status__c Tier4_Status,
			'' as QDX_Ins_Plan_Code, RecType.Name Financial_Category, A.Type LineOfBenefit
			from StagingDB.ODS.StgAccount A
			left join StagingDB.ODS.stgRecordType RecType on RecType.Id = A.RecordTypeId
		   ) HCO on CA.OSM_Account_1__c = HCO.Tier4_SysId
left join (select Id Tier1_SysId, Name Tier1Payor, OSM_Account_Number__c Tier1PayorId, OSM_Payor_Hierarchy__c
			from StagingDB.ODS.stgAccount) T1 on T1.Tier1_SysId = Acct.ParentId
where OSM_Role__c in ('Payor Association')
  and CA.IsDeleted = 0
-- order by Acct.Tier2PayorId

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