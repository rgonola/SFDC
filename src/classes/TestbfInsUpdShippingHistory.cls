/**********************************************************************
Name: TestbfInsUpdShippingHistory
Copyright © 2012 WK
======================================================
======================================================
Purpose: This test class is to do test coverage for the Trigger "bfInsUpdShippingHistory" 
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR               DATE       DETAIL 
1.0       Natesh               17/07/2012 INITIAL DEVELOPMENT
1.1       Vaibhav Kulkarni     27/May/2013   Test Coverage Updated
***********************************************************************/
/* @Description: Test class for 'bfInsUpdShippingHistory'
   @Modified By: Vaibhav Kulkarni
   @Date: 27.May.2013
*/ 

@isTest
private class TestbfInsUpdShippingHistory {

    //Test method to check wether the SFS_History__c owner is same as Lead's owner if Lead is populated or Account's Owner if Account field is populated
    static testMethod void myUnitTest() {
    
        //Commented @Vaibhav
        /*
        Test.startTest();
        Id AMFSNSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
        Lead newLeadRecord = new Lead();
        newLeadRecord.RecordTypeId = AMFSNSRecordTypeId;
        newLeadRecord.LastName = 'Test Lead 0003';
        newLeadRecord.Company = 'Test Company 0003';
        newLeadRecord.Language__c = 'Spanish';
        newLeadRecord.LeadSource = 'Additional Office';
        //newLeadRecord.OwnerId = newUserList1[i/2].Id;
        newLeadRecord.Status = 'Open';
        insert newLeadRecord;
        
        Shipping_History__c newShipHistRec = new Shipping_History__c();
        //newShipHistRec.Name = 'Test Shipping History';
        newShipHistRec.Lead_del__c = newLeadRecord.Id;
        insert newShipHistRec;
        
        Test.stopTest();
        */
        //Commented @Vaibhav
        
        Id AMFSNSRecordTypeIdLead=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
        Id AMFSNSRecordTypeIdAccount=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
        
        Profile profiledata = [select Id FROM profile where name='System Administrator'];
        List<User> UserLst = new List<User>();
        
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
      
        User objUser2 = new User();
            objUser2.FirstName ='testFirst2';
            objUser2.LastName = 'testLasst2';
            objUser2.Email = 'test2@gmail.com';
            objUser2.Alias = 'tesF2';
            objUser2.CommunityNickname='aTest2';
            objUser2.emailencodingkey='UTF-8';
            objUser2.Username = 'test8956789@gmail.com';
            objUser2.LocaleSidKey='en_US';
            objUser2.LanguageLocaleKey = 'en_US';    //Language
            objUser2.TimeZoneSidKey = 'America/New_York';    // Timezone
            objUser2.IsActive=true;
            objUser2.SALES_REP_CODE__c='444444';
            objUser2.ProfileId =   profiledata.id;                                              
            
            UserLst.add(objUser2);
 
           insert UserLst;
        
       Lead newLeadRecord;
       Account newAccountRecord;
       
       //Inserting Record in User Context
       System.runAs(UserLst[0]){
       
            //Creating Lead record
            newLeadRecord = new Lead();
            newLeadRecord.RecordTypeId = AMFSNSRecordTypeIdLead;
            newLeadRecord.LastName = 'Test Lead 0003';
            newLeadRecord.Company = 'Test Company 0003';
            newLeadRecord.Language__c = 'Spanish';
            newLeadRecord.LeadSource = 'Additional Office';
            newLeadRecord.Status = 'Open';
               
            insert newLeadRecord;
        }
        
        System.runAs(UserLst[1]){
               
            //Creating Account Record
            newAccountRecord = new Account();
            newAccountRecord.Name = 'Test Account 0003';
                
            insert newAccountRecord;
        }
            
        List<Shipping_History__c> Shipping_HistoryLst = new List<Shipping_History__c>();
        Shipping_History__c newShipping_HistoryRec;
       
        for(integer i=0;i<100;i++){
            newShipping_HistoryRec = new Shipping_History__c();
            newShipping_HistoryRec.Lead_del__c = newLeadRecord.id;
            Shipping_HistoryLst.add(newShipping_HistoryRec);
        }
        for(integer i=0;i<100;i++){
            newShipping_HistoryRec = new Shipping_History__c();
            newShipping_HistoryRec.Account__c = newAccountRecord.id;
            Shipping_HistoryLst.add(newShipping_HistoryRec);
        }
        
        Test.startTest();
        
        insert Shipping_HistoryLst;
        
        Test.stopTest();
 
        for(Shipping_History__c sh:[Select id,OwnerId,Lead_del__c,Account__c,Account__r.OwnerId,Lead_del__r.OwnerId From Shipping_History__c Where id IN:Shipping_HistoryLst]){
            if(sh.Lead_del__c <> null){
                System.assertEquals(sh.OwnerId,sh.Lead_del__r.OwnerId);
            }
            if(sh.Account__c <> null){
                System.assertEquals(sh.OwnerId,sh.Account__r.OwnerId);
            }
        }
    }
}