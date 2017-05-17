/**********************************************************************
Name: TestafInsUpdOpportunity
Copyright © 2012 WK
======================================================
======================================================
Purpose: This test class is to do test coverage for the Trigger "afInsUpdOpportunity" 
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR               DATE       DETAIL 
1.0       Natesh               17/08/2012 INITIAL DEVELOPMENT
1.1       Vaibhav Kulkarni     31/05/2013   Test Coverage Updated
***********************************************************************/

@isTest
private class TestafInsUpdOpportunity {
    static testMethod void myUnitTest() {
        //Commented @ Vaibhav
        /*
        Test.startTest();
        Id AMFSNSOppRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Opportunity'].Id;
        Id AMFSNSAccountRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Account'].Id;
        
        //List<Account> newAccountList = new List<Account>();
        Account accountItem = new Account(Name = 'Test Account111', RecordTypeId = AMFSNSAccountRecordTypeId, Type = 'New Customer');
        try{
            insert accountItem;
        }
        catch(Exception e){
            System.debug('Exception Occured: insert accountItem - ' + e);
        }
        
        Opportunity oppItem = new Opportunity(Name = 'Test Opp111', RecordTypeId = AMFSNSOppRecordTypeId, AccountId = accountItem.Id, CloseDate = System.today(), StageName = 'Present Solution', Refund_Customer_type__c = 'Prospect');
        insert oppItem;
        
        Opportunity updateOppItem1 = [SELECT Id,Refund_Customer_type__c FROM Opportunity WHERE Id = :oppItem.Id];
        updateOppItem1.Refund_Customer_type__c = 'Prior Customer';
        update updateOppItem1;

        Opportunity updateOppItem2 = [SELECT Id,Refund_Customer_type__c FROM Opportunity WHERE Id = :oppItem.Id];
        updateOppItem2.Refund_Customer_type__c = 'Non Renewed';
        update updateOppItem2;
        
        Opportunity updateOppItem3 = [SELECT Id,Refund_Customer_type__c FROM Opportunity WHERE Id = :oppItem.Id];
        updateOppItem3.Refund_Customer_type__c = 'First Year Non Renewed';
        update updateOppItem3;
        
        Test.stopTest();
    }
    */
    //Commented @ Vaibhav
    
    /*  Commented as Associated Triggers are INACTIVE  
        Id AMFSNSOppRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Opportunity'].Id;
        Id AMFSNSAccountRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Account'].Id;
           
        Profile profiledata = [select Id FROM profile where name='System Administrator'];
        List<User> UserLst = new List<User>();
        List<Opportunity> OppLst = new List<Opportunity>();      
      
        //Creating User Record for Inserting the Record in the particular User Context
        User objUser1 = new User();
            objUser1.FirstName ='testFirst1';
            objUser1.LastName = 'testLast1';
            objUser1.Email = 'test@gmail.com';
            objUser1.Alias = 'tesF1';
            objUser1.CommunityNickname='aTest1';
            objUser1.emailencodingkey='UTF-8';
            objUser1.Username = 'test1245896@gmail.com';
            objUser1.LocaleSidKey='en_US';
            objUser1.LanguageLocaleKey = 'en_US';    //Language
            objUser1.TimeZoneSidKey = 'America/New_York';    // Timezone
            objUser1.IsActive=true;
            objUser1.ProfileId =   profiledata.id; 
            objUser1.SALES_REP_CODE__c='3333333';  
            UserLst.add(objUser1);  
         
         insert UserLst;
         
           
         Account accountItem = new Account(Name = 'Test Account111', RecordTypeId = AMFSNSAccountRecordTypeId, Type = 'New Customer',Prior_Software_Vendor__c='CCH');
           //Inserting Record in User Context
         System.runAs(UserLst[0]){
       
         insert accountItem;
         
         }
 
         for(integer i=0;i<200;i++){
             Opportunity oppItem = new Opportunity(Name = 'Test Opp111',AccountId = accountItem.Id, CloseDate = System.today(), StageName = 'Present Solution', Refund_Customer_type__c = 'Prospect');
             OppLst.add(oppItem);
         }
         
         //Inserting Record in User Context
         System.runAs(UserLst[0]){
       
         insert OppLst;
         
         }

         for(Opportunity opp:[Select id,OwnerId,Current_Provider__c From Opportunity Where id IN:OppLst]){
             System.assertEquals(opp.OwnerId,UserLst[0].id);
             System.assertEquals(opp.Current_Provider__c,accountItem.Prior_Software_Vendor__c);
         }
     */
     }
     
}