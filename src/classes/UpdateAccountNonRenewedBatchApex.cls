/**********************************************************************
Name: UpdateAccountNonRenewedBatchApex
Copyright © 2012 WK
======================================================
======================================================
Purpose: This batch apex class is used to update all the account to non-renewed once in a year (march 1st).
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Natesh   19/06/2012 INITIAL DEVELOPMENT 
***********************************************************************/
global class UpdateAccountNonRenewedBatchApex implements Database.Batchable<sObject>{
	public String query;
	private List<Account> accountList = new List<Account>();
	
	//Start Method
	global database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    //Execute Method
    global void execute(Database.BatchableContext BC, List<sObject> scope){
		try{
			for(sObject obj :scope){
				Account newAccount = (Account)obj;
				System.debug('----------newAccount:'+newAccount);
	    		newAccount.Type = 'Non-renewed customer';
	    		accountList.add(newAccount);
	    	}
	    	
	    	if(accountList.size() > 0){
	    		update accountList;
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
	    
	    mail.setSubject('Batch Process Completed');
	    String textBody = 'Batch Process has completed: ';
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
    }
}