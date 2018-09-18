select O.OrderNumber, OSM_Order_Line_Item_ID__c OLIID
, specimen.OSM_Procedure_Type__c ProcedureType
, OLI.OSM_Test_Name__c Test
, result.Name CurrentResult, specimen.Name ResultedSpecimenID
, OLI.OSM_OLI_Start_Date__c 'OLI Start Date', OLI.OSM_Test_Delivered_Date__c 'Test Delivered Date'
--, OLI.OSM_Resulted_Order_Specimen_ID_Current__c OLI_Result_Specimen
from StagingDB.ODS.StgOrderItem OLI
left join StagingDB.ODS.stgOrder O on OLI.OrderId = O.Id
left join StagingDB.ODS.stgResult result on result.Id = OLI.OSM_Result_Current__c
left join StagingDB.ODS.stgOrderSpecimen specimen on result.OSM_Resulted_Order_Specimen_ID__c = specimen.Id
where OSM_OLI_Start_Date__c >= '2017-01-01'
and OLI.OSM_Result_Current__c is not null
order by OSM_OLI_Start_Date__c