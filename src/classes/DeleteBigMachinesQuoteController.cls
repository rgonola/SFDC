public with sharing class DeleteBigMachinesQuoteController {
	public DeleteBigMachinesQuoteController(){
	}
	public void deleteBigMachineQuote(){
		DeleteBigMachinesQuoteBatchApex batchApexObj=new DeleteBigMachinesQuoteBatchApex();
        batchApexObj.strQuery='SELECT Id,Updated_to_BM__c FROM SFDCQuote_BMQuote_Sync__c WHERE Updated_to_BM__c = true and Response_from_BigMachines__c=\'Ok\'';
    	database.executebatch(batchApexObj,10000);
	}
}