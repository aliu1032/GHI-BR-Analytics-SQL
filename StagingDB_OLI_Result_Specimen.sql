select OSM_Order_Line_Item_ID__c OLIID, result.Name CurrentResult, specimen.Name ResultedSpecimen, specimen.OSM_Procedure_Type__c ProcedureType
from StagingDB.ODS.StgOrderItem OLI
left join StagingDB.ODS.stgResult result on result.Id = OLI.OSM_Result_Current__c
left join StagingDB.ODS.stgOrderSpecimen specimen on result.OSM_Resulted_Order_Specimen_ID__c = specimen.Id
where OSM_OLI_Start_Date__c >= '2016-01-01'
and OLI.OSM_Result_Current__c is not null