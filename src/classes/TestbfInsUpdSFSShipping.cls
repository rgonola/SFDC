/**********************************************************************
Name: TestbfInsUpdSFSShipping
Copyright © 2012 WK
======================================================
======================================================
Purpose: This test class is to do test coverage for the Trigger "bfInsUpdSFSShipping" 
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR           DATE       DETAIL 
1.0       Natesh           30/08/2012 INITIAL DEVELOPMENT
1.1       Vaibhav Kulkarni 27/May/2013   Test Coverage Updated
***********************************************************************/
/* @Description: Test class for 'bfInsUpdSFSShipping'
   @Modified By: Vaibhav Kulkarni
   @Date: 27.May.2013
*/ 

@isTest
private class TestbfInsUpdSFSShipping {
    
    //Test method to check wether the SFS_Shipping__c owner is same as Lead's owner if Lead is populated or Account's Owner if Account field is populated
    static testMethod void myUnitTest() {
        //Commented by @Vaibhav
        /*
        Test.startTest();
        Id AMFSNSLeadRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
        Id AMFSNSAccountRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Account'].Id;
        Lead newLeadRecord = new Lead(RecordTypeId = AMFSNSLeadRecordTypeId,LastName = 'Test Lead 0003',Company = 'Test Company 0003',LeadSource = 'Additional Office',Status = 'Open');
        insert newLeadRecord;
        
        Account newAccountRecord = new Account(Name='Test Account 001', RecordTypeId=AMFSNSAccountRecordTypeId);
        insert newAccountRecord;
        
        SFS_Shipping__c newSFSShipRec = new SFS_Shipping__c();
        newSFSShipRec.Name = 'Test SFS Shipping';
        newSFSShipRec.Lead__c = newLeadRecord.Id;
        insert newSFSShipRec;
        
        newSFSShipRec = new SFS_Shipping__c();
        newSFSShipRec.Name = 'Test SFS Shipping';
        newSFSShipRec.Account__c = newAccountRecord.Id;
        insert newSFSShipRec;
        
        Test.stopTest();
        */
        //Commented by @Vaibhav
        
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
            
        List<SFS_Shipping__c> SFS_ShippinLst = new List<SFS_Shipping__c>();
        SFS_Shipping__c newSFS_ShippingRec;
       
        for(integer i=0;i<100;i++){
            newSFS_ShippingRec = new SFS_Shipping__c();
            newSFS_ShippingRec.Lead__c = newLeadRecord.id;
            SFS_ShippinLst.add(newSFS_ShippingRec);
        }
        for(integer i=0;i<100;i++){
            newSFS_ShippingRec = new SFS_Shipping__c();
            newSFS_ShippingRec.Account__c = newAccountRecord.id;
            SFS_ShippinLst.add(newSFS_ShippingRec);
        }
        
        Test.startTest();
        
        insert SFS_ShippinLst;
        
        Test.stopTest();
 
        for(SFS_Shipping__c sh:[Select id,OwnerId,Lead__c,Account__c,Account__r.OwnerId,Lead__r.OwnerId From SFS_Shipping__c Where id IN:SFS_ShippinLst]){
            if(sh.Lead__c <> null){
                System.assertEquals(sh.OwnerId,sh.Lead__r.OwnerId);
            }
            if(sh.Account__c <> null){
                System.assertEquals(sh.OwnerId,sh.Account__r.OwnerId);
            }
        }
    }
}