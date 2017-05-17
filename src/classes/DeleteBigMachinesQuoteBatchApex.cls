/**********************************************************************
Name: DeleteBigMachinesQuoteBatchApex
Copyright © 2012 WK
======================================================
======================================================
Purpose: This batch apex class is used to delete Quotes.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Natesh   27/09/2012 INITIAL DEVELOPMENT 
***********************************************************************/
global class DeleteBigMachinesQuoteBatchApex implements Database.Batchable<sObject>, Database.AllowsCallouts{
	private List<SFDCQuote_BMQuote_Sync__c> quoteList = new List<SFDCQuote_BMQuote_Sync__c>();
	public String strQuery;
	public Boolean isTest;
	//Start Method
	global database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(strQuery);
    }
    
    //Execute Method
    global void execute(Database.BatchableContext BC, List<sObject> scope){
		try{
			for(sObject obj :scope){
				SFDCQuote_BMQuote_Sync__c newSFDCBMQuote = (SFDCQuote_BMQuote_Sync__c)obj;
				quoteList.add(newSFDCBMQuote);
	    	}
	    	
	    	if(quoteList.size() > 0){
	    		delete quoteList;
	    	}
		}
		catch(Exception e){
       		System.debug('Exception Occured:'+e);
		}
    }
    
    //Finish Method
    global void finish(Database.BatchableContext BC){
    	// Get the ID of the AsyncApexJob representing this batch job
		// from Database.BatchableContext.
		// Query the AsyncApexJob object to retrieve the current job's information.
		AsyncApexJob a = [SELECT 
								Id, 
								Status, 
								NumberOfErrors, 
								JobItemsProcessed,
								TotalJobItems, 
								CreatedBy.Email,
								CompletedDate,
								ExtendedStatus,							
								JobType,
								MethodName									
							FROM AsyncApexJob
							WHERE Id = :BC.getJobId()];	
									
	    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	    List<String> email = new List<String>();
	    email.add(a.CreatedBy.Email);
	    mail.setToAddresses(email);
	    
	    mail.setSubject('Batch Process Completed: Delete SFDC BigMachines Quote');
	    String textBody = 'Batch Process has been completed: ';
	    textBody += '\n' + 'Completed Date = ' + a.CompletedDate;	    
	    textBody += '\n' + 'Status = ' + a.Status;
	    textBody += '\n' + 'Extended Status = ' + a.ExtendedStatus;	    	    
	    textBody += '\n' + 'Job Type = ' + a.JobType;	    
	    textBody += '\n' + 'Method Name = ' + a.MethodName;
	    textBody += '\n' + 'Total Job Items = ' + a.TotalJobItems;	    
	    textBody += '\n' + 'Job Items Processed = ' + a.JobItemsProcessed;	    
	    textBody += '\n' + 'Number Of Errors = ' + a.NumberOfErrors;
	    textBody += '\n' + 'Created By.Email = ' + a.CreatedBy.Email;	    
	    mail.setPlainTextBody(textBody);
	    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	/*
    	BigMachinesUpdateController bmUpdateControllerObj = new BigMachinesUpdateController();
    	UpdateBigMachinesQuoteBatchApex batchApexObj = new UpdateBigMachinesQuoteBatchApex();
	    String strSessionId = '';
	    if(!isTest){
	    	strSessionId = bmUpdateControllerObj.getBigMachinesSession('BulkQuoteUser','aB@ku$2010','https://testcchsfs.bigmachines.com/v1_0/receiver');
	    }
	    batchApexObj.strSessionId = strSessionId;
	    batchApexObj.isTest = isTest;
        batchApexObj.strQuery = 'select Account_Id__c,Opportunity_Id__c,Quote_Id__c,Quote_Owner_Id__c,Quote_Transaction_Number__c,Updated_to_BM__c from SFDCQuote_BMQuote_Sync__c where Updated_to_BM__c=false';
    	database.executebatch(batchApexObj,9);
    	*/
    }
}