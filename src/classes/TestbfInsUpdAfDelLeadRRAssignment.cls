/**********************************************************************
Name: TestbfInsUpdAfDelLeadRRAssignment
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
private class TestbfInsUpdAfDelLeadRRAssignment {
	static testMethod void myUnitTest() {
		
		Test.startTest();
		//Create Queues
		/*List<Group> queueList = new List<Group>();
		Group newQueue = new Group();
		newQueue.Name = 'Spanish Queue';
		newQueue.Type = 'Queue';
		queueList.add(newQueue);
		
		newQueue = new Group();
		newQueue.Name = 'Non-Spanish Queue';
		newQueue.Type = 'Queue';
		queueList.add(newQueue);
		
		insert queueList;
		
		List<QueueSobject> qSObjList = new List<QueueSobject>();
		QueueSobject newQSObj = new QueueSobject();
		newQSObj.QueueId = queueList[0].id;
		newQSObj.SobjectType = 'Lead';
		qSObjList.add(newQSObj);
		
		newQSObj = new QueueSobject();
		newQSObj.QueueId = queueList[1].id;
		newQSObj.SobjectType = 'Lead';
		qSObjList.add(newQSObj);
		
		insert qSObjList;*/
			
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
			userItem.FirstName = 'RoundRobin Test1';
			userItem.LastName = 'User 00' + i;
			userItem.Email = 'TestUser00' + i + '@Test.com';
			userItem.Username = 'RoundRobinTestUser003' + i + '@Test.com';
			userItem.Alias = 'Test4' + i;
			userItem.CommunityNickname = 'TestCommunity 004' + i;
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
			userItem.FirstName = 'RoundRobin Test2';
			userItem.LastName = 'User 00' + i;
			userItem.Email = 'RoundRobinTestUser00' + i + '@Test.com';
			userItem.Username = 'RoundRobinTestUser004' + i + '@Test.com';
			userItem.Alias = 'Test3' + i;
			userItem.CommunityNickname = 'RRTestCommunity 003' + i;
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
		
		//update sequence number
		List<RR_Queue_Member__c> queueMemberList = new List<RR_Queue_Member__c>();
		RR_Queue_Member__c updateRRQueueMember = new RR_Queue_Member__c();
		updateRRQueueMember = [SELECT Id,Sequence_Number__c,RR_Member__c FROM RR_Queue_Member__c
							   WHERE Id = :newRRQueueMemberList[12].Id];
		updateRRQueueMember.Sequence_Number__c = 1004;
		queueMemberList.add(updateRRQueueMember);
		try{
			//update updateRRQueueMember;
		}
		catch(exception e){
			System.debug('Exception Occured: update updateRRQueueMember - ' + e);
		}
		
		//insert RR Member which is already exists
		rrQueueMemberItem = new RR_Queue_Member__c();
		rrQueueMemberItem.Queue_Name__c = rrQueueList[0].Id;
		rrQueueMemberItem.RR_Member__c = newRRMemberList[2].Id;
		rrQueueMemberItem.Sequence_Number__c = 120;
		queueMemberList.add(rrQueueMemberItem);
		try{
			//insert rrQueueMemberItem;
			upsert queueMemberList;
		}
		catch(exception e){
			System.debug('Exception Occured: upsert queueMemberList - ' + e);
		}
		
		Id AMFSNSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
		//Create Non-Spanish Leads and assign to Queue
		List<Lead> newLeadList1 = new List<Lead>();
		Lead newLeadRecord = new Lead();
		for(Integer i=0;i<2;i++){
			newLeadRecord = new Lead();
			newLeadRecord.RecordTypeId = AMFSNSRecordTypeId;
			newLeadRecord.LastName = 'Test Lead 000' + i;
			newLeadRecord.Company = 'Test Company 000' + i;
			newLeadRecord.Language__c = 'English';
			newLeadRecord.LeadSource = 'Additional Office';
			newLeadRecord.Assign_using_active_assignment_rule__c = true;
			newLeadList1.add(newLeadRecord);
		}
		try{
			insert newLeadList1;
		}
		catch(exception e){
			System.debug('Exception Occured: insert newLeadList1 - ' + e);
		}
		
		List<Lead> upDelLeadRecord = [SELECT Id, OwnerId FROM Lead
							   		  WHERE Id IN (:newLeadList1[0].Id,:newLeadList1[1].Id)];
		upDelLeadRecord[0].OwnerId = newUserList[2].Id;
		
		update upDelLeadRecord[0];
		
		//Delete a Lead Record
		delete upDelLeadRecord[1];
		
		//Create Web to Lead (Spanish/NonSpanish) Leads to follow round robin
		List<Lead> leadList1 = new List<Lead>();
		List<Lead> newLeadList2 = new List<Lead>();
		for(Integer i=0;i<6;i++){
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
			leadList1.addAll(newLeadList2);
			//insert newLeadList2;
		}
		catch(exception e){
			System.debug('Exception Occured: insert newLeadList2 - ' + e);
		}
		
		//Create Individual Leads for Non Queue Member
		newLeadList2 = new List<Lead>();
		for(Integer i=0;i<4;i++){
			newLeadRecord = new Lead();
			newLeadRecord.RecordTypeId = AMFSNSRecordTypeId;
			newLeadRecord.LastName = 'Test Lead 0003' + i;
			newLeadRecord.Company = 'Test Company 0003' + i;
			newLeadRecord.Language__c = 'Spanish';
			newLeadRecord.LeadSource = 'Additional Office';
			newLeadRecord.OwnerId = newUserList1[i/2].Id;
			newLeadRecord.Status = 'Open';
			newLeadList2.add(newLeadRecord);
		}
		try{
			//insert newLeadList2;
			leadList1.addAll(newLeadList2);
			insert leadList1;
		}
		catch(exception e){
			System.debug('Exception Occured: insert leadList1 - ' + e);
		}
		
		//Delete Non Queue Member Leads
		List<Lead> LeadList = [SELECT Id, OwnerId FROM Lead
							   WHERE Id IN (:newLeadList2[2].Id,:newLeadList2[3].Id,:newLeadList2[1].Id,:newLeadList2[0].Id)];
		
		//Change of Owner
		LeadList[0].OwnerId = newUserList[6].Id;
		update LeadList[0];
		
		delete LeadList;
		
		Test.stopTest();
	}
}