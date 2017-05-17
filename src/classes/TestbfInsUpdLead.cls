/**********************************************************************
Name: TestbfInsUpdLead
Copyright © 2012 WK
======================================================
======================================================
Purpose: This test class is to do test coverage for the Trigger "bfInsUpdLead" 
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Natesh   28/08/2012 INITIAL DEVELOPMENT
***********************************************************************/
@isTest(SeeAllData=true)
private class TestbfInsUpdLead {

static testMethod void updateLeadOwnerTest() {

/*  Commented as Associated Triggers are INACTIVE 
String RECORD_TYPE_ID_LEAD_AMFSNS = 'AM/FS/NS Lead';

Id AMFSNSRecordTypeId = [SELECT Id from RecordType where Name = :RECORD_TYPE_ID_LEAD_AMFSNS].Id;

CS_TestData_Utility testUtility = new CS_TestData_Utility();//common utility class which is used to create the dumy data over the current org

list<User> UsrLst = new list<User>();

//create the user with role having keyword User
User usrDataRole = testUtility.createUsersDiffProfile('Integration_Sys', 'Account Management User', 'Data Load');
UsrLst.add(usrDataRole);

//create the user with role having keyword User
User usrUserRole = testUtility.createUsersDiffProfile('Viv', 'Account Management User', 'User');
UsrLst.add(usrUserRole);

//create the user with role having keyword User
User usrUserRole2 = testUtility.createUsersDiffProfile('Nav', 'Account Management User', 'User');
UsrLst.add(usrUserRole2);

//create the user with role having keyword Manager
User usrManagerRole = testUtility.createUsersDiffProfile('Vab', 'Account Management User', 'Manager');
UsrLst.add(usrManagerRole);

//create the user with role having keyword Admin
User usrAdminRole = testUtility.createUsersDiffProfile('Kev', 'Account Management User', 'Administrator');
UsrLst.add(usrAdminRole);

//inserting users
insert UsrLst;

Test.startTest();
//creating the lead record with owner as data lead
Lead ldRec1 = testUtility.createLeadRec('tstLeadRec', AMFSNSRecordTypeId, usrUserRole2.Id);

insert ldRec1;
    
//updating the record's owner to user with role containing key word User
ldRec1.OwnerId = usrUserRole.Id;

update ldRec1;


Lead ldRec2 = testUtility.createLeadRec('tstLeadRec2', AMFSNSRecordTypeId, usrManagerRole.Id);

insert ldRec2;
    
//updating the record's owner to user with role containing key word User
ldRec2.OwnerId = usrUserRole.Id;

update ldRec2;


Lead ldRec3 = testUtility.createLeadRec('tstLeadRec2', AMFSNSRecordTypeId, usrDataRole.Id);

insert ldRec3;
    
//updating the record's owner to user with role containing key word User
ldRec3.OwnerId = usrUserRole.Id;

update ldRec3;


Test.stopTest();
*/ 
}



/*
    static testMethod void myUnitTest() {
        Id RefundsTodayRecordTypeId=[select Id from RecordType where Name='Leads Refunds Today'].Id;
        Id AMFSNSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
        
        Test.startTest();
        
        User adminUser = [SELECT Id FROM User WHERE Profile.Name='System Administrator' AND IsActive=true LIMIT 1];
        //Create Users
        Id AMUserProfileId = [SELECT Id,Name FROM Profile WHERE Name='Account Management User'].Id;
        Id AMManagerProfileId = [SELECT Id,Name FROM Profile WHERE Name='Account Management Manager'].Id;
        Id AMUserRoleId = [SELECT Id,Name FROM UserRole WHERE Name='AM User'].Id;
        Id AMManagerRoleId = [SELECT Id,Name FROM UserRole WHERE Name='AM Manager'].Id;        
        List<User> newUserList = new List<User>();
        List<User> userList = new List<User>();
        User userItem = new User();
        for(Integer i=0;i<4;i++){
          userItem = new User();
          userItem.FirstName = 'ABC User';
          if(i==0)
              userItem.FirstName = 'Test';
          userItem.LastName = 'User 00' + i;
          userItem.Email = 'TestUser00' + i + '@Test.com';
          userItem.Username = 'TestUser00' + i + '@Test.com';
          userItem.Alias = 'Test00' + i;
          userItem.CommunityNickname = 'TestCommunity 00' + i;
          if(Math.mod(i,2) == 0){ 
              userItem.ProfileId = AMUserProfileId;
              userItem.UserRoleId = AMUserRoleId;
          }
          else{
              userItem.ProfileId = AMManagerProfileId;
              userItem.UserRoleId = AMManagerRoleId;
          }
          if(i==0){
              userItem.FirstName = 'Test';
          }
          userItem.TimeZoneSidKey = 'America/New_York';
          userItem.LocaleSidKey = 'en_US';
          userItem.LanguageLocaleKey = 'en_US';
          userItem.EmailEncodingKey = 'ISO-8859-1';
          newUserList.add(userItem);
        }
        System.runAs(adminUser){
            insert newUserList;
        }
        
        //Contract Expiration Date
        Lead newLead1 = new Lead(LastName = 'Test Lead for Update EXP111', Company = 'Test Lead for Update EXP111',
                                   Status = 'Open', Primary_Contact_Email__c = 'TestEmail111@test.com',
                                   RecordTypeId = RefundsTodayRecordTypeId, Process__c = 'Sign and Close a Prospect');
        insert newLead1;
        
        Lead updateLead1 = [SELECT Id,Process__c,Contract_Expiration_Date__c 
                                  FROM Lead
                                  WHERE Id =:newLead1.Id];
        
        updateLead1.Process__c = 'Sign & Close a prospect';
        updateLead1.Contract_Expiration_Date__c = '';
        update updateLead1;
        
       
        //Refunds Today
        List<Lead> newLeadList3 = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest'+cnt;
            if(cnt<>4 && cnt<>5){
                newLead.FirstName='';
                newLead.Email='EmailTest'+cnt+'@test.com';
                newLead.Phone='117654320'+cnt;
                newLead.Fax='117654320'+cnt;
            }
            if(cnt==4 || cnt==5){
                newLead.Primary_Contact_Email__c = 'EmailTest'+cnt+'@test.com';
            }
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            newLeadList3.add(newLead);
        }
        try{
            insert newLeadList3;
        }
        catch(DmlException e){}
        
        List<Lead> newLeadList4 = new List<Lead>();
        for(Integer cnt=1; cnt<=2; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest'+cnt;
            newLead.Email='EmailTest'+cnt+'@test.com';
            newLead.Phone='117654320'+cnt;
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            newLeadList4.add(newLead);
        }
        try{
            insert newLeadList4;
        }
        catch(DmlException e){}
        
        updateLead1 = [SELECT FirstName,Email,Phone FROM Lead WHERE Id=:newLeadList3[0].id];
        updateLead1.Email = 'EmailTest1@test.com';
        updateLead1.Phone='1176543201';
        try{
            update updateLead1;
        }
        catch(DmlException e){}
        
        List<Lead> newLeadList5 = new List<Lead>();
        for(Integer cnt=1; cnt<=2; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest';
            newLead.LastName='LastNameTest';
            newLead.Company='CompanyTest';
            newLead.Email='EmailTest@test.com';
            newLead.Phone='1176543201';
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            newLeadList5.add(newLead);
        }
        try{
            insert newLeadList5;
        }
        catch(DmlException e){}
        
        //AM/NS/FS Account and Lead Creation
        Id AMFSNSaccountRecordTypeId=[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Account'].Id;
        List<Account> newAccountList = new List<Account>();
        Account accountItem = new Account();
        for(Integer i=0;i<5;i++){
            accountItem = new Account(Name = 'Test Account'+i, RecordTypeId = AMFSNSaccountRecordTypeId, Type = 'Prospect',
                                      Email__c = 'EmailTest'+i+'@test.com',Phone='117654320'+i,EFIN__c = 'TestEFIN'+i);
            newAccountList.add(accountItem);
        }
        try{
            insert newAccountList;
        }
        catch(Exception e){
            System.debug('Exception Occured: insert newAccountList - ' + e);
        }
        
        List<Lead> newLeadList = new List<Lead>();
        for(Integer cnt=0; cnt<5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest'+cnt;
            newLead.Email='EmailTest'+cnt+'@test.com';
            newLead.Phone='117654320'+cnt;
            newLead.Fax='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            if(cnt<>4 && cnt<>5){
                newLead.Street = 'Test Street'+cnt;
                newLead.City = 'Test City'+cnt;
                newLead.State = 'Test State'+cnt;
                newLead.Country = 'Test Country'+cnt;
                newLead.PostalCode = '00000'+cnt;
                newLead.IsWebToLead__c = true;
            }
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            newLeadList.add(newLead);
        }
        try{
            insert newLeadList;
        }
        catch(DmlException e){}
        
        newLeadList = new List<Lead>();
        for(Integer cnt=0; cnt<4; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest12'+cnt;
            newLead.LastName='LastNameTest12'+cnt;
            newLead.Company='CompanyTest12'+cnt;
            newLead.Email='EmailTest12'+cnt+'@test.com';
            newLead.Phone='117654312'+cnt;
            newLead.Fax='117654312'+cnt;
            newLead.OwnerId = newUserList[0].Id;
            if(cnt == 3)
                newLead.OwnerId = newUserList[1].Id;
            if(cnt == 1)
                newLead.OwnerId = newUserList[2].Id;
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            newLeadList.add(newLead);
        }
        try{
            insert newLeadList;
        }
        catch(DmlException e){}
        
        List<Lead> updateLeadList = [SELECT Id,OwnerId FROM Lead 
                                     WHERE Id IN (:newLeadList[0].Id,:newLeadList[1].Id,:newLeadList[2].Id,:newLeadList[3].Id)];
        System.runAs(newUserList[2]){
            updateLeadList[0].OwnerId = newUserList[2].Id;
            //updateLeadList[1].OwnerId = newUserList[2].Id;
            updateLeadList[2].OwnerId = newUserList[3].Id;
            updateLeadList[3].OwnerId = newUserList[2].Id;
            try{
                update updateLeadList;
            }
            catch(DmlException e){}
        }
        
        Lead updateLead = [SELECT Id,OwnerId FROM Lead WHERE Id=:newLeadList[1].Id];
        System.runAs(newUserList[0]){
            updateLead.OwnerId = newUserList[0].Id;
            try{
                update updateLead;
            }
            catch(DmlException e){}
        }
        Test.stopTest();    
    }*/
}