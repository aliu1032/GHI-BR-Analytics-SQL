Select
	Ord.OrderNumber OrderID
	, OLI.OSM_Order_Line_Item_ID__c OLIID
	, C.Id Case_SysId
	, C.IsDeleted
	, C.CaseNumber
	, C.Type
	, C.Subject
	, C.Status Case_Status
	, C.OSM_Contact_Specialty__c
	, C.CreatedDate Case_CreatedDate
	, C.ClosedDate Case_CloseDate
	, C.OSM_Case_Age__c
	, Task.SOMN_Task_Result
	, Task.SOMN_Task_Status
	, Task.SOMN_Task_ResultDate
from StagingDB.ODS.stgCase C
left join
	(SELECT A.Id
	       ,A.RecordTypeId
	       ,A.WhatId -- this is the case id
               ,A.Subject SOMN_Task_Result
               ,A.Status  SOMN_Task_Status
	       ,A.CreatedDate SOMN_Task_ResultDate
	 FROM [StagingDB].[ODS].[stgTask] A
         left join StagingDB.ODS.stgRecordType RecType on A.RecordTypeId = RecType.Id
	 where A.Subject like '%rcvd%'
-- '%SOMN%ONBASE%'
	 --   and CreatedDate >= '2017-01-01' and CreatedDate <= '2017-03-31'
	 ) Task on C.Id = Task.WhatId
left join StagingDB.ODS.StgOrderItem OLI on OLI.Id = C.OSM_Primary_Order_Line_Item__c
left join StagingDB.ODS.stgOrder Ord on Ord.Id = C.OSM_Primary_Order__c
where C.OSM_Case_Record_Type__c in ('Customer Outreach')
and C.Type = 'Missing Data'
and C.Subject like '%SOMN%'
and C.CreatedDate >='2015-07-01'
and C.IsDeleted = 0
--and C.Id = '5000B00000gGyJIQA0'