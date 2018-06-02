Select ORD.*
	, C.Id Case_SysId
	, C.CaseNumber
	, C.OSM_Case_Record_Type__c
	, C.Type
	, E.Name Case_Owner
	, C.CreatedDate Case_CreatedDate
	, C.ClosedDate Case_CloseDate
	, C.OSM_Case_Age__c
	, C.Status Case_Status
	, C.OSM_BI_Sent_Date__c PreBilling_SentDate
	, C.OSM_BI_Update_Sent_Date__c PreBilling_Update
	, C.OSM_BI_Complete__c PreBilling_Complete
	, C.OSM_Data_Transmission_Status__c
	, C.OSM_BI_Status__c
	, C.OSM_Contact_Specialty__c
	, C.Subject
	, C.Description   -- Description contains LineBreak Character
--  , C.OSM_PA_Hold__c -- Field is not extracted 
	, C.OSM_PA_Status__c
	, C.OSM_PA_Number__c
--	, C.PSA_Notes
--	, C.OSM_SOMN_Status__c
	, C.OSM_ABN_Required__c
	, C.OSM_ABN_Status__c
	, C.OSM_Self_Pay_Status__c
	, C.OSM_Lab_Hold__c
	, C.OSM_Report_Hold__c
--	, C.OSM_PTV__c -- Field is not extracted
from (
		Select B.Id Order_SysId
			 , A.Id OLI_SysId
			 , B.OrderNumber
			 , A.OSM_Order_Line_Item_ID__c
			 , A.OSM_Test_Delivered_Date__c
		from StagingDB.ODS.StgOrderItem A
			 , StagingDB.ODS.stgOrder B
		where
			A.OSM_Test_Delivered_Date__c >= '2016-01-01' 
			--and A.OSM_Test_Delivered_Date__c <= '2017-02-01'
			and
			A.OrderId = B.Id
			--and B.OrderNumber in ('OR000905868', 'OR000773847','OR000775361','OR000960897')
	) ORD
left join StagingDB.ODS.stgCase C on ORD.OLI_SysId = C.OSM_Primary_Order_Line_Item__c
left join StagingDB.ODS.stgGroup E on C.OwnerId = E.Id
where C.OSM_Case_Record_Type__c in ('Pre-Billing')
order by ORD.OrderNumber, ORD.OSM_Order_Line_Item_ID__c

