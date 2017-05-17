/**********************************************************************
Name: TestUpdateAccountNonRenewedBatch
Copyright © 2012 WK
======================================================
======================================================
Purpose: This test class is to do test coverage for the classes "UpdateAccountNonRenewedBatchApex" 
         and "UpdateAccountNonRenewedSchedule"
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Natesh   25/06/2012 INITIAL DEVELOPMENT
***********************************************************************/
@isTest
private class TestUpdateAccountNonRenewedBatch {

    static testMethod void myUnitTest() {
        Test.startTest();
        Id AMFSNSaccountRecordTypeId=[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Account'].Id;
        List<Account> newAccountList = new List<Account>();
        Account newAccount = new Account();
        for(Integer i=0;i<10;i++){
            newAccount = new Account();
            newAccount.Name = 'Test Account Batch 00' + i;
            newAccount.RecordTypeId = AMFSNSaccountRecordTypeId;
            newAccount.Type = 'Renewed customer';
            newAccountList.add(newAccount);
            
        }
        insert newAccountList;
        
        UpdateAccountNonRenewedBatchApex batchApex = new UpdateAccountNonRenewedBatchApex();
        batchApex.query = 'SELECT Id,Type FROM Account WHERE (Type=\'Renewed customer\' OR Type=\'New customer\') AND RecordTypeId=\''+AMFSNSaccountRecordTypeId+'\' LIMIT 1000';
        Id batchID = database.executebatch(batchApex,1000);
        
        Test.stopTest();
    }
    
    static testMethod void myUnitTest1() {
        Test.startTest();
        
        Lead webToLead = new Lead();
        webToLead.FirstName='FirstNameTest11';
        webToLead.LastName='LastNameTest11';
        webToLead.Company='CompanyTest11';
        webToLead.Email='EmailTest11@test.com';
        webToLead.Phone='98765432011';
        webToLead.Street = 'Test Street11';
        webToLead.City = 'Test City11';
        webToLead.State = 'Test State11';
        webToLead.Country = 'Test Country11';
        webToLead.PostalCode = '000011';
        webToLead.IsWebToLead__c = true;
        try{
            insert webToLead;
        }
        catch(DmlException e){}
        
        UpdateAccountNonRenewedBatchApex batchApex = new UpdateAccountNonRenewedBatchApex();
        batchApex.query = 'SELECT Id FROM Lead LIMIT 100';
        Id batchID = database.executebatch(batchApex,1000);
        
        Test.stopTest();
    }
    
    static testMethod void scheduleBatchTest() {
        Test.startTest();
        String CRON_EXP = '0 0 0 * * ?';
        UpdateAccountNonRenewedSchedule sch = new UpdateAccountNonRenewedSchedule();
        String jobId = System.schedule('TestScheduledApex',CRON_EXP,sch);
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        //Verify the expressions are the same
        System.assertEquals(CRON_EXP,ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        test.stopTest();
    }
}