/**********************************************************************
Name: ChangeAccountOwnerController
Copyright © 2012 WK
======================================================
======================================================
Purpose: This class is used to change the owner of the 
		 accout records depending on the BOB value selected.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Aditya   26/10/2012 INITIAL DEVELOPMENT
***********************************************************************/

public with sharing class ChangeAccountOwnerController {
	 public String strSelectedOwner{get;set;}
        public List<SelectOption> bobValues{get
        	{
        		
        		List<selectOption> options = new List<selectOption>();
        		options.add(new SelectOption('','- None -'));
        		transient String[] strObj=new String[AccountCustomSettings__c.getAll().values().size()];
        		integer i=0; 
        		for (AccountCustomSettings__c customSettingsObj: AccountCustomSettings__c.getAll().values()){
        		    strObj[i]=customSettingsObj.BOB__c;
					i++;
        		}
        		strObj.sort();
        		for(String str:strObj)
        			options.add(new SelectOption(str,str));
				return options;
        	}
        	set;}
        public String selectedBOB{get;set;}
        public ChangeAccountOwnerController(ApexPages.StandardController controller) {
        /*List<SelectOption> tempList=new List<SelectOption>();
        List<AccountCustomSettings__c> listSettings=[Select BOB__c from AccountCustomSettings__c order by BOB__c];
        tempList.add(new SelectOption('','- None -'));
        for(AccountCustomSettings__c obj:listSettings){
        	tempList.add(new SelectOption(obj.BOB__c,obj.BOB__c));
        }
        bobValues=tempList;*/
    }
    
    public PageReference changeOwner(){
    	List<Account> lstAccountRecordsToUpdate=new List<Account>();
        system.debug('---strSelectedOwner---'+strSelectedOwner); 
        system.debug('---selectedBOB---'+selectedBOB); 
        Id AMFSNSAccountRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Account'].Id;
       User userObj=[select Id,Name from User where Name=:strSelectedOwner]; 
      system.debug('---userObj---'+userObj); 
      List<Account> lstAccountsWithMatchingBOBValue=[select Id,OwnerId,BOB__c from Account where BOB__c=:selectedBOB AND RecordTypeId=:AMFSNSAccountRecordTypeId];
       system.debug('---lstAccountsWithMatchingBOBValue------size----'+lstAccountsWithMatchingBOBValue.size());
       system.debug('---lstAccountsWithMatchingBOBValue---'+lstAccountsWithMatchingBOBValue);
       if(lstAccountsWithMatchingBOBValue!=null && lstAccountsWithMatchingBOBValue.size()>0){
        for(Account accountObj:lstAccountsWithMatchingBOBValue)
        	lstAccountRecordsToUpdate.add(new Account(Id=accountObj.Id,OwnerId=userObj.Id));
       }else{
       		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No records found with the BOB value '+selectedBOB));
       		return null;
       }
      try {
      		Database.update(lstAccountRecordsToUpdate);
      		if(lstAccountRecordsToUpdate.size()==1)
      			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,lstAccountRecordsToUpdate.size()+' record updated successfully!!'));
      		else
      			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,lstAccountRecordsToUpdate.size()+' records updated successfully!!'));
      }Catch(Exception e){
      		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured while updating the owner'));
      }
      return null;
    }
    public PageReference cancel(){
    	PageReference pageRef=new PageReference('/001');
      	pageRef.setRedirect(true);
      	return pageRef;
    }
}