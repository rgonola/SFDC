/**********************************************************************
Name: TestbfInsUpdAfDelAccountCheck250
Copyright © 2012 WK
======================================================
======================================================
Purpose: This test class is to do test coverage for the Trigger "bfInsUpdAfDelAccountCheck250" 
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Natesh   01/08/2012 INITIAL DEVELOPMENT
***********************************************************************/
@isTest
private class TestbfInsUpdAfDelAccountCheck250 {
    static testMethod void myUnitTest() {
        /*  Commented as Associated Triggers are INACTIVE  
        Test.startTest();
        //Create Users
        Id AMUserProfileId = [SELECT Id,Name FROM Profile WHERE Name='Account Management User'].Id;
        List<User> newUserList = new List<User>();
        User userItem = new User();
        for(Integer i=0;i<5;i++){
            userItem = new User();
            userItem.FirstName = 'Test';
            userItem.LastName = 'User 00' + i;
            userItem.Email = 'TestUser00' + i + '@Test.com';
            userItem.Username = 'TestUser00' + i + '@Test.com';
            userItem.Alias = 'Test00' + i;
            userItem.CommunityNickname = 'TestCommunity 00' + i;
            userItem.ProfileId = AMUserProfileId;
            userItem.TimeZoneSidKey = 'America/New_York';
            userItem.LocaleSidKey = 'en_US';
            userItem.LanguageLocaleKey = 'en_US';
            userItem.EmailEncodingKey = 'ISO-8859-1';
            newUserList.add(userItem);
        }
        insert newUserList;
        
        //Create RR Members
        List<RR_Member__c> newRRMemberList = new List<RR_Member__c>();
        RR_Member__c rrMemberItem = new RR_Member__c();
        
        for(Integer i=0;i<5;i++){
            rrMemberItem = new RR_Member__c();
            rrMemberItem.Member__c = newUserList[i].Id;
            if(i==2){
                rrMemberItem.No_of_Other_Leads_Assigned__c = 248;
            }
            newRRMemberList.add(rrMemberItem);
        }
        
        insert newRRMemberList;
        
        //Create Accounts
        Id AMFSNSaccountRecordTypeId=[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Account'].Id;
        List<Account> newAccountList = new List<Account>();
        Account accountItem = new Account();
        for(Integer i=0;i<10;i++){
            accountItem = new Account(Name = 'Test Account'+i, RecordTypeId = AMFSNSaccountRecordTypeId, Type = 'Prospect',
                                      OwnerId = newUserList[i/5].Id);
            newAccountList.add(accountItem);
        }
        try{
            insert newAccountList;
        }
        catch(Exception e){
            System.debug('Exception Occured: insert newAccountList - ' + e);
        }
        
        List<Account> updateAccountList = [SELECT Id, Type, OwnerId FROM Account
                                       WHERE Id IN (:newAccountList[0].Id,:newAccountList[1].Id,:newAccountList[2].Id,:newAccountList[3].Id,:newAccountList[4].Id)];
        updateAccountList[0].Type = 'New Customer';
        updateAccountList[1].OwnerId = newUserList[4].Id;
        updateAccountList[4].OwnerId = newUserList[2].Id;
        try{
            update updateAccountList;
            delete updateAccountList[3];
        }
        catch(Exception e){
            System.debug('Exception Occured: update updateAccountList - ' + e);
        }
        
        newAccountList = new List<Account>();
        for(Integer i=0;i<5;i++){
            accountItem = new Account(Name = 'Test Account'+i, RecordTypeId = AMFSNSaccountRecordTypeId, Type = 'Prospect',
                                      OwnerId = newUserList[2].Id, Phone = '1234567890', Fax = '1555557890');
            newAccountList.add(accountItem);
        }
        try{
            insert newAccountList;
        }
        catch(Exception e){
            System.debug('Exception Occured: insert newAccountList - ' + e);
        }
        
        Test.stopTest();
        */
    }
}