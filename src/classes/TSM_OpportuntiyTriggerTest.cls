/*
 * test classs for opportunity trigger for ownership and parent records relationship changes
 */
@isTest
public class TSM_OpportuntiyTriggerTest {
    // data preparation for custom settings/accounts
    @testSetup static void dataPrep() {
    	TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c='CCH TAA';
        List<User> otherAdminUser = [SELECT Id, UserName, Email FROM User WHERE IsActive = true 
                                     AND Profile.Name='System Administrator' 
                                    AND Id != :UserInfo.getUserId() LIMIT 1];
        config.HouseAdminUserName__c = otherAdminUser[0].Email;        
        insert config;
        List<TSM_Trigger_Control__c> controlList = new List<TSM_Trigger_Control__c>();
        controlList.add(new TSM_Trigger_Control__c(Name='Account',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='Contact',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='Opportunity',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='OpportunityLineItem',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='TSM_Shared_Product__c',TriggerOff__c=false));
        insert controlList;
        List<Account> accts = TSM_TestDataUtil.createNewAccounts(100);
        List<Contact> contacts = TSM_TestDataUtil.createNewContacts(accts[0].Id, 1);
    }
    // test the oppportunity insert with respective fields
    @isTest static void testInsertPositive() {
        List<Contact> contactsList = [SELECT Id, TAA_Contact_Record_id__c FROM Contact];
        List<Account> acctsList = [SELECT Id, X1Force_Account__c FROM Account];
        Test.startTest();
		TSM_TestDataUtil.createOpportunities(acctsList[0],contactsList[0],1,UserInfo.getUserEmail());        
        Test.stopTest();
        // ensure that opporunity is created with respective fields
        List<Opportunity> oppList = [SELECT Id, AccountId, OwnerId, Contact__c FROM Opportunity];
        System.assertEquals(1, oppList.size());
        System.assertEquals(acctsList[0].id, oppList[0].AccountId);
        System.assertEquals(UserInfo.getUserId(), oppList[0].OwnerId);
        System.assertEquals(contactsList[0].Id, oppList[0].Contact__c);
    }
    
    // test the opportunity insert without accountId and with TAA account record Id
    @isTest static void testInsertWithTAAAcctRecordId() {
        Account acct = new Account(Name='TestTAAExampleRecordTrig',TAA_Account_Record_Id__c='0010002100000G0J2f');
        insert acct;
        Contact cont = new Contact(Firstname='Test',LastName='Test',Email='test1@teswk.com',AccountId=null,
                                  TAA_Contact_Record_Id__c='0030002100000FAZc2', TAA_Account_Record_Id__c='0010002100000G0J2f');
        insert cont;
        Opportunity opp = new Opportunity(StageName='1. Gain Accesss',CloseDate=System.today()+30,
                                       AccountId=null, Name=acct.Id+'OpptyTest1',
                                       TAA_Account_Record_Id__c='0010002100000G0J2f',                                       
                                       TAA_Primary_Contact_for_Proposal__c=cont.TAA_Contact_Record_ID__c,
                                       TAA_Opportunity_Owner_ID__c=UserInfo.getUserEmail(), 
                                       TAA_Opportunity_Record_ID__c='RecordIdabc123');
       	insert opp;
        // assert the account mapping
        Account acctExt = [SELECT Id, TAA_Account_Record_Id__c FROM Account WHERE Name='TestTAAExampleRecordTrig' LIMIT 1];
        List<Opportunity> oppList = [SELECT Id, TAA_Account_Record_Id__c, AccountId FROM Opportunity];
        System.assertEquals(acctExt.Id, oppList[0].accountId);
    }
    
    // test the oppportunity insert without accountId
    @isTest static void testInsertWithouAccountId() {
        List<Contact> contactsList = [SELECT Id, TAA_Contact_Record_id__c FROM Contact];
        List<Account> acctsList = [SELECT Id, X1Force_Account__c FROM Account];
        Test.startTest();
		TSM_TestDataUtil.createOpportunity(new Account(),contactsList[0], acctsList[0].X1Force_Account__c,
                                           UserInfo.getUserEmail());        
        Test.stopTest();
        // ensure that opporunity is created with respective fields
        List<Opportunity> oppList = [SELECT Id, AccountId, OwnerId, Contact__c FROM Opportunity];
        System.assertEquals(1, oppList.size());
        System.assertEquals(acctsList[0].id, oppList[0].AccountId);
    }
    // test the negative scenario without proper parent records
    @isTest static void testInsertNegative() {
        List<Contact> contactsList = [SELECT Id, TAA_Contact_Record_id__c FROM Contact];
        List<Account> acctsList = [SELECT Id, X1Force_Account__c FROM Account];
        Test.startTest();
		TSM_TestDataUtil.createOpportunities(new Account(),new Contact(),1,null);        
        Test.stopTest();
        // ensure that opporunity is created with respective fields
        List<Opportunity> oppList = [SELECT Id, AccountId, OwnerId, Contact__c FROM Opportunity];
        System.assertEquals(1, oppList.size());
        System.assertEquals(null, oppList[0].AccountId);
        System.assertEquals(UserInfo.getUserId(), oppList[0].OwnerId);
        System.assertEquals(null, oppList[0].Contact__c);
    }
    // test the bulk insertion
    @isTest static void testInsertBulk() {
        List<Contact> contactsList = [SELECT Id, TAA_Contact_Record_id__c FROM Contact];
        List<Account> acctsList = [SELECT Id, X1Force_Account__c FROM Account];
        Test.startTest();
		TSM_TestDataUtil.createOpportunities(acctsList[0],contactsList[0],200,UserInfo.getUserEmail());        
        Test.stopTest();
        // ensure that opporunity is created with respective fields
        List<Opportunity> oppList = [SELECT Id, AccountId, OwnerId, Contact__c FROM Opportunity];
        System.assertEquals(200, oppList.size());
        Id acctId = acctsList[0].Id;
        Id contactId = contactsList[0].Id;
        // this is to assert the proper relationship of account
        List<Opportunity> oppList2 = [SELECT Id, AccountId, OwnerId, Contact__c FROM Opportunity WHERE
                                    AccountId = :acctId];        
        System.assertEquals(200, oppList2.size());
        // this is to assert the proper relationship of contact
        List<Opportunity> oppList3 = [SELECT Id, AccountId, OwnerId, Contact__c FROM Opportunity WHERE
                                    Contact__c = :contactId];        
        System.assertEquals(200, oppList3.size());
        // this is to assert the proper ownership
        List<Opportunity> oppList4 = [SELECT Id, AccountId, OwnerId, Contact__c FROM Opportunity WHERE
                                    OwnerId = :UserInfo.getUserId()];        
        System.assertEquals(200, oppList4.size());
    }
    // test the future method 
    @isTest static void testFutureMethod() {
        List<Contact> contactsList = [SELECT Id, TAA_Contact_Record_id__c FROM Contact];
        List<Account> acctsList = [SELECT Id, X1Force_Account__c FROM Account];
        TSM_TestDataUtil.createOpportunities(acctsList[0],contactsList[0],1,UserInfo.getUserEmail());        
        Map<id, opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        Test.startTest();
       	TSM_Util.touchOpportunities(oppMap.keySet());
        Test.stopTest();
        // ensure that record has been updated
        List<Opportunity> oppList = [SELECT id from Opportunity];
        System.assertEquals(1, oppList.size());        
    }
}