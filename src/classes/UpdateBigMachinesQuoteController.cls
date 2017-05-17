public with sharing class UpdateBigMachinesQuoteController {
	public String strSessionId{get;set;}
	public boolean isTest{get;set;}
	public UpdateBigMachinesQuoteController(){
	}
	public void updateBigMachineQuote(){
		/*String isTestStr = system.currentPageReference().getParameters().get('isTest');
		if(isTestStr!=null && isTestStr!='' && isTestStr == 'false'){
			isTest = false;
		}
		BigMachinesUpdateController bmUpdateControllerObj = new BigMachinesUpdateController();
    	UpdateBigMachinesQuoteBatchApex batchApexObj = new UpdateBigMachinesQuoteBatchApex();
	    strSessionId = '';
	    if(!isTest){
	    	//strSessionId = bmUpdateControllerObj.getBigMachinesSession('BulkQuoteUser','aB@ku$2010','https://testcchsfs.bigmachines.com/v1_0/receiver');          //this is for test environment
	    	strSessionId = bmUpdateControllerObj.getBigMachinesSession('BulkQuoteUser','aB@ku$2010','https://cchsfs.bigmachines.com/v1_0/receiver');             //this is for production environment.
	    }
	    system.debug('------strSessionId------'+strSessionId);
	    batchApexObj.strSessionId = strSessionId;
	    batchApexObj.isTest = isTest;
        batchApexObj.strQuery = 'select Account_Id__c,Opportunity_Id__c,Quote_Id__c,Quote_Owner_Id__c,Quote_Transaction_Number__c,Updated_to_BM__c from SFDCQuote_BMQuote_Sync__c where Updated_to_BM__c=false';
    	database.executebatch(batchApexObj,9);*/
	}
}