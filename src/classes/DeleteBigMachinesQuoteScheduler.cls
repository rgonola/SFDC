/**********************************************************************
Name: DeleteBigMachinesQuoteScheduler
Copyright © 2012 WK
======================================================
======================================================
Purpose: This class will be scheduled to delete records in salesforce and Bigmachines quote object.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Natesh   27/09/2012 INITIAL DEVELOPMENT 
***********************************************************************/
global class DeleteBigMachinesQuoteScheduler implements Schedulable {
	global void execute(SchedulableContext SC) {
		DeleteBigMachinesQuoteBatchApex batchApexObj=new DeleteBigMachinesQuoteBatchApex();
        batchApexObj.strQuery='SELECT Id,Updated_to_BM__c FROM SFDCQuote_BMQuote_Sync__c WHERE Updated_to_BM__c = true and Response_from_BigMachines__c=\'Ok\'';
    	database.executebatch(batchApexObj,10000);
	}
}