/**********************************************************************
Name: TestbfInsUpdAfDelLeadRRAssignment2
Copyright © 2012 WK
======================================================
======================================================
Purpose: This test class is to do test coverage for the Trigger "bfInsUpdAfDelLeadRRAssignment" 
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Natesh   04/06/2012 INITIAL DEVELOPMENT
***********************************************************************/
@isTest
private class TestbfInsUpdAfDelLeadRRAssignment2 {

    static testMethod void myUnitTest() {
        Test.startTest();
        
        //Create RR Queues
        
        List<RR_Queue__c> rrQueueList = new List<RR_Queue__c>();
        RR_Queue__c newRRQueue = new RR_Queue__c();
        newRRQueue.Queue_Name__c = 'Spanish Queue';
        rrQueueList.add(newRRQueue);
        
        newRRQueue = new RR_Queue__c();
        newRRQueue.Queue_Name__c = 'Non-Spanish Queue';
        rrQueueList.add(newRRQueue);
        
        newRRQueue = new RR_Queue__c();
        newRRQueue.Queue_Name__c = 'Non-Spanish';
        //rrQueueList.add(newRRQueue);
        
        try{
            insert rrQueueList;
        }
        catch(exception e){
            System.debug('Exception Occured: insert rrQueueList - ' + e);
            rrQueueList = [SELECT Id,Queue_Name__c FROM RR_Queue__c 
                           WHERE Queue_Name__c IN ('Spanish Queue','Non-Spanish Queue')];
        }
        
        //Create Users
        Id AMUserProfileId = [SELECT Id,Name FROM Profile WHERE Name='Account Management User'].Id;
        List<User> newUserList = new List<User>();
        List<User> userList = new List<User>();
        User userItem = new User();
        for(Integer i=0;i<10;i++){
            userItem = new User();
            userItem.FirstName = 'Test11';
            userItem.LastName = 'RoundRobin User 001' + i;
            userItem.Email = 'TestUser00' + i + '@Test.com';
            userItem.Username = 'TestRoundRobinUser001' + i + '@Test.com';
            userItem.Alias = 'Test1' + i;
            userItem.CommunityNickname = 'TestCommunity 001' + i;
            userItem.ProfileId = AMUserProfileId;
            userItem.TimeZoneSidKey = 'America/New_York';
            userItem.LocaleSidKey = 'en_US';
            userItem.LanguageLocaleKey = 'en_US';
            userItem.EmailEncodingKey = 'ISO-8859-1';
            newUserList.add(userItem);
        }
        
        userList.addAll(newUserList);
        //insert newUserList;
        
        List<User> newUserList1 = new List<User>();
        for(Integer i=10;i<15;i++){
            userItem = new User();
            userItem.FirstName = 'Test22';
            userItem.LastName = 'RoundRobin User 002' + i;
            userItem.Email = 'TestRoundRobinUser00' + i + '@Test.com';
            userItem.Username = 'TestRoundRobinUser001' + i + '@Test.com';
            userItem.Alias = 'Test2' + i;
            userItem.CommunityNickname = 'TestRRCommunity 002' + i;
            userItem.ProfileId = AMUserProfileId;
            userItem.TimeZoneSidKey = 'America/New_York';
            userItem.LocaleSidKey = 'en_US';
            userItem.LanguageLocaleKey = 'en_US';
            userItem.EmailEncodingKey = 'ISO-8859-1';
            newUserList1.add(userItem);
        }
        //insert newUserList1;
        userList.addAll(newUserList1);
        insert userList;
        
        //Create RR Members
        List<RR_Member__c> newRRMemberList = new List<RR_Member__c>();
        RR_Member__c rrMemberItem = new RR_Member__c();
        for(User userRec :newUserList){
            rrMemberItem = new RR_Member__c();
            rrMemberItem.Member__c = userRec.Id;
            newRRMemberList.add(rrMemberItem);
        }
        for(Integer i=0;i<5;i++){
            rrMemberItem = new RR_Member__c();
            rrMemberItem.Member__c = newUserList1[i].Id;
            if(i==2){
                rrMemberItem.No_of_Other_Leads_Assigned__c = 248;
            }
            newRRMemberList.add(rrMemberItem);
        }
        
        insert newRRMemberList;
        
        //Create RR Queue Members
        List<RR_Queue_Member__c> newRRQueueMemberList = new List<RR_Queue_Member__c>();
        RR_Queue_Member__c rrQueueMemberItem = new RR_Queue_Member__c();
        for(Integer i=0;i<10;i++){
            rrQueueMemberItem = new RR_Queue_Member__c();
            rrQueueMemberItem.Queue_Name__c = rrQueueList[0].Id;
            rrQueueMemberItem.RR_Member__c = newRRMemberList[i].Id;
            rrQueueMemberItem.Sequence_Number__c = i + 1001;
            if(i==2){
                rrQueueMemberItem.Enable_Round_Robin__c = false;
            }
            if(i==4){
                rrQueueMemberItem.No_of_Leads_Assigned__c = 248;
            }
            newRRQueueMemberList.add(rrQueueMemberItem);
            
            rrQueueMemberItem = new RR_Queue_Member__c();
            rrQueueMemberItem.Queue_Name__c = rrQueueList[1].Id;
            rrQueueMemberItem.RR_Member__c = newRRMemberList[i].Id;
            rrQueueMemberItem.Sequence_Number__c = i + 1001;
            if(i==6){
                rrQueueMemberItem.Enable_Round_Robin__c = false;
            }
            if(i==8){
                rrQueueMemberItem.No_of_Leads_Assigned__c = 248;
            }
            newRRQueueMemberList.add(rrQueueMemberItem);
        }
        
        try{
            insert newRRQueueMemberList;
        }
        catch(exception e){
            System.debug('Exception Occured: insert newRRQueueMemberList - ' + e);
        }
        
        //Create Web to Lead (Spanish/NonSpanish) Leads to follow round robin
        Id AMFSNSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
        List<Lead> leadList1 = new List<Lead>();
        List<Lead> newLeadList2 = new List<Lead>();
        Lead newLeadRecord = new Lead();
        for(Integer i=0;i<2;i++){
            newLeadRecord = new Lead();
            newLeadRecord.RecordTypeId = AMFSNSRecordTypeId;
            newLeadRecord.LastName = 'Test Lead 0002' + i;
            newLeadRecord.Company = 'Test Company 0002' + i;
            newLeadRecord.Language__c = 'Spanish';
            if(Math.mod(i, 2) == 1){
                newLeadRecord.Language__c = 'English';
            }
            newLeadRecord.LeadSource = 'Web';
            newLeadRecord.IsWebToLead__c = true;
            newLeadList2.add(newLeadRecord);
        }
        try{
            //leadList1.addAll(newLeadList2);
            insert newLeadList2;
        }
        catch(exception e){
            System.debug('Exception Occured: insert newLeadList2 - ' + e);
        }
        
        //Create Individual Leads for Spanish/Non-Spanish Queue
        List<Lead> newLeadList1 = new List<Lead>();
        for(Integer i=0;i<3;i++){
            newLeadRecord = new Lead();
            newLeadRecord.RecordTypeId = AMFSNSRecordTypeId;
            newLeadRecord.LastName = 'Test Lead 0001' + i;
            newLeadRecord.Company = 'Test Company 0001' + i;
            newLeadRecord.Language__c = 'English';
            newLeadRecord.LeadSource = 'Additional Office';
            newLeadRecord.OwnerId = newUserList[i/2].Id;
            newLeadRecord.Status = 'Open';
            newLeadList1.add(newLeadRecord);
        }
        try{
            insert newLeadList1;
        }
        catch(exception e){
            System.debug('Exception Occured: insert newLeadList1 - ' + e);
        }
        
        //Change of Owner
        List<Lead> updateLeadList = [SELECT Id, OwnerId FROM Lead
                                     WHERE Id IN (:newLeadList1[0].Id,:newLeadList1[1].Id,:newLeadList1[2].Id)];
        updateLeadList[0].OwnerId = newUserList[6].Id;
        
        updateLeadList[1].OwnerId = newUserList1[3].Id;
        
        //Update Lead Status from Open to Closed
        updateLeadList[2].Status = 'Qualified';
        //update updateLeadList;
        /*
        //Update Lead Status from Closed to Open
        Lead updateLeadRecord = [SELECT Id, OwnerId, Status
                            FROM Lead WHERE Id =:newLeadList1[2].Id];
        updateLeadRecord.Status = 'Open';
        update updateLeadRecord;
        */
        //Delete a Lead Record
        delete updateLeadList[0];
        
        List<RR_Queue_Member__c> delRRQueueMemberList = [SELECT Id FROM RR_Queue_Member__c];
        delete delRRQueueMemberList;
        
        //Create duplicate Web to Lead (Spanish/NonSpanish)
        newLeadList2 = new List<Lead>();
        for(Integer i=0;i<4;i++){
            newLeadRecord = new Lead();
            newLeadRecord.RecordTypeId = AMFSNSRecordTypeId;
            newLeadRecord.LastName = 'Test Lead 0002' + i;
            newLeadRecord.Company = 'Test Company 0002' + i;
            newLeadRecord.Language__c = 'Spanish';
            if(Math.mod(i, 2) == 1){
                newLeadRecord.Language__c = 'English';
            }
            newLeadRecord.LeadSource = 'Web';
            newLeadRecord.IsWebToLead__c = true;
            newLeadList2.add(newLeadRecord);
        }
        try{
            //leadList1.addAll(newLeadList2);
            insert newLeadList2;
        }
        catch(exception e){
            System.debug('Exception Occured: insert newLeadList2 - ' + e);
        }
        
        List<RR_Queue__c> delRRQueueList = [SELECT Id FROM RR_Queue__c];
        delete delRRQueueList;
    }
}