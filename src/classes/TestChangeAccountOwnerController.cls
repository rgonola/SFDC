/**********************************************************************
Name: TestChangeAccountOwerController
Copyright © 2012 WK
======================================================
======================================================
Purpose: This class is the test class for the controller "ChangeAccountOnwerController"
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Aditya   29/10/2012 INITIAL DEVELOPMENT
***********************************************************************/
 
@isTest
public with sharing class TestChangeAccountOwnerController {
    static testMethod void myUnitTest() {
        Test.startTest();
        Account accountObj=new Account(); 
        Id AMFSNSAccountRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Account'].Id;
        Account account1 = new Account(Name = 'Test Account111', RecordTypeId = AMFSNSAccountRecordTypeId, BOB__c = 'A01');
        Account account2 = new Account(Name = 'Test Account222', RecordTypeId = AMFSNSAccountRecordTypeId, BOB__c = 'A01');
        Account account3 = new Account(Name = 'Test Account333', RecordTypeId = AMFSNSAccountRecordTypeId, BOB__c = 'A03');
        
        AccountCustomSettings__c customsettingsObj1=new AccountCustomSettings__c(BOB__c='A01',Name='ACS01');
        AccountCustomSettings__c customsettingsObj2=new AccountCustomSettings__c(BOB__c='A02',Name='ACS02');
        AccountCustomSettings__c customsettingsObj3=new AccountCustomSettings__c(BOB__c='A03',Name='ACS03');
        try{
            insert account1;
            insert account2;
            insert account3;
            insert customsettingsObj1;
            insert customsettingsObj2;
            insert customsettingsObj3;
        }catch(Exception e){ 
            System.debug('Exception Occured: insert accountItem - ' + e);
        } 
        PageReference pageRef=new PageReference('/apex/ChangeAccountOwner');
        System.Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc=new ApexPages.Standardcontroller(accountObj);
        ChangeAccountOwnerController obj=new ChangeAccountOwnerController(sc);
        List<SelectOption> lstOptionValues=obj.bobValues;
        obj.strSelectedOwner='SFS Lead Integration';
        obj.selectedBOB='A01';
        obj.changeOwner();
        obj.selectedBOB='A02';
        obj.changeOwner();
        obj.selectedBOB='A03';
        obj.changeOwner();
        obj.cancel();
                    
        Test.stopTest();    
    }
    
}