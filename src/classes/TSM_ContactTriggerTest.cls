@isTest
public class TSM_ContactTriggerTest {
	// for data prep like custom settings, etc.
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
    }
    // for testing the insert single record - negative
    @isTest static void testInsertNegative() {
        Account acct = new Account(Name='Test');
        insert acct;
        Contact cont = new Contact(Firstname='Test',LastName='Test',Email='test1@teswk.com',AccountId=acct.Id);
        Test.startTest();
        insert cont;
        Test.stopTest(); 
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        String sfsAdminUser = tsmCS.HouseAdminUserName__c;
        User u = [SELECT Id FROM User WHERE Email = :sfsAdminUser AND IsActive = true AND Profile.Name='System Administrator' LIMIT 1];
        
        List<Contact> acctExt = new List<Contact>([SELECT Id, OwnerId FROM Contact WHERE OwnerId = :u.Id]);     
        // make sure the owner id is not same as SFS Admin user
        System.assertEquals(0, acctExt.size());
        acctExt = [SELECT Id, OwnerId FROM Contact WHERE OwnerId = :UserInfo.getUserId()]; 
        // make sure the owner id is same as the record creator (running user)
        System.assertEquals(1, acctExt.size());
    }
    // for testing the insert single record - positive
    @isTest static void testInsertPositive() {
        Account acct = new Account(Name='Test');
        insert acct;
        Contact cont = new Contact(Firstname='Test',LastName='Test',Email='test1@teswk.com',AccountId=acct.Id,
                                  TAA_Contact_Record_Id__c='test');
        Test.startTest();
        insert cont;
        Test.stopTest();        
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        String sfsAdminUser = tsmCS.HouseAdminUserName__c;
        User u = [SELECT Id FROM User WHERE Email = :sfsAdminUser AND IsActive = true AND Profile.Name='System Administrator' LIMIT 1];
        
        List<Contact> contExt = new List<Contact>([SELECT Id, OwnerId FROM Contact WHERE OwnerId = :u.Id]);   
        // make sure the owner id is same as the SFS house admin user
        System.assertEquals(u.Id, contExt[0].OwnerId);
    }
    
    // for testing the insert single record - positive
    @isTest static void testInsertPositiveWithTAAAccount() {
        Account acct = new Account(Name='Test',TAA_Account_Record_Id__c='0010002100000G0J2f');
        insert acct;
        Contact cont = new Contact(Firstname='Test',LastName='Test',Email='test1@teswk.com',AccountId=null,
                                  TAA_Contact_Record_Id__c='0030002100000FAZc2', TAA_Account_Record_Id__c='0010002100000G0J2f');
        Test.startTest();
        insert cont;
        Test.stopTest();        
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        String sfsAdminUser = tsmCS.HouseAdminUserName__c;
        User u = [SELECT Id FROM User WHERE Email = :sfsAdminUser AND IsActive = true AND Profile.Name='System Administrator' LIMIT 1];
        List<Account> acctExt = [SELECT Id FROM Account];
        List<Contact> contExt = new List<Contact>([SELECT Id, OwnerId, AccountId FROM Contact WHERE OwnerId = :u.Id]);   
        // make sure the owner id is same as the SFS house admin user
        System.assertEquals(u.Id, contExt[0].OwnerId);
        // make sure the account id is assigned
        System.assertEquals(contExt[0].Accountid, acctExt[0].Id);
    }
    
    // for testing the bulk records insert
    @isTest static void testInsertBulk() {
        Test.startTest();
        List<Account> accts = TSM_TestDataUtil.createAccounts(100, 2, 0); 
        Test.stopTest();
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        String sfsAdminUser = tsmCS.HouseAdminUserName__c;
        User u = [SELECT Id FROM User WHERE Email = :sfsAdminUser AND IsActive = true AND Profile.Name='System Administrator' LIMIT 1];
        
        List<Contact> contacts = [SELECT Id, OwnerId FROM Contact WHERE OwnerId = :u.Id];        
        // ensure 200 contacts are created with the SFSHOUSEADMIN User name (as per the TSM_App_Config__c)
        System.assertEquals(200, contacts.size());
    }    
}