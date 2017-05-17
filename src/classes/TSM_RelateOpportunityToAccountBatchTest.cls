/*
 * test class for the batch apex class TSM_RelateOpportunityToAccountBatch
 */
@isTest
public class TSM_RelateOpportunityToAccountBatchTest {
    // for data prep
    @testSetup static void dataPrep() {
    	TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c='CCH TAA';
        config.ScheduleSecondFrequency__c=60;
        List<User> otherAdminUser = [SELECT Id, Email, UserName FROM User WHERE IsActive = true 
                                     AND Profile.Name='System Administrator' 
                                    AND Id != :UserInfo.getUserId() LIMIT 1];
        config.HouseAdminUserName__c = otherAdminUser[0].Email;        
        insert config;
        // insert the new accounts, contacts and opportunities for data
        List<Opportunity> opps = TSM_TestDataUtil.createOrphanOpportunities(200);
    }
	// for schedule job testing schedule job
    @isTest static void testScheduleJob() {
        // schedule the test job
        Test.startTest();        
        String jobId = System.schedule('jobName', '0 0 0 1 1 ? 2018', new TSM_RelateOpportunityToAccountScheduler());
        Test.stopTest();
        List<CronTrigger> ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];                
        System.assertEquals(0, ct.size());             
    }
    
    // for testing the accountids not null
    @isTest static void testAccountLinks() {
        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, AccountId FROM Contact]);
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, AccountId, Contact__c FROM Opportunity]);
        List<Opportunity> oppList = new List<Opportunity>();
        for(Opportunity opp: oppMap.values()) {
            opp.AccountId = null;
            opp.Contact__c = null;
            oppList.add(opp);
        }
        update oppList;
        List<Opportunity> oppsExt = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = null];
        System.assertEquals(200, oppsExt.size());
        Test.startTest();
        Database.executeBatch(new TSM_RelateOpportunityToAccountBatch());
        Test.stopTest();
        // assert the number of opportunities are updated with respective accounts & contacts        
        List<Opportunity> oppsWithAccounts = [SELECT Id, AccountId, Contact__c FROM Opportunity WHERE AccountId != null];
        System.assertEquals(200, oppsWithAccounts.size());
        List<Opportunity> oppsWithContacts = [SELECT Id, AccountId, Contact__c FROM Opportunity WHERE Contact__c != null];
        System.assertEquals(200, oppsWithContacts.size());
    }
    
    // for testing xforceacct
    @isTest static void testX1ForceAccts() {
        Account acct = new Account(Name='Test',X1Force_Account__c='TestX1ForceAcct');
        insert acct;
        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, AccountId FROM Contact]);
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, AccountId, Contact__c, X1Force_Account__c, 
                                                                TAA_Account_Record_ID__c
                                                                FROM Opportunity]);
        List<Opportunity> oppList = new List<Opportunity>();
        for(Opportunity opp: oppMap.values()) {
            opp.AccountId = null;
            opp.Contact__c = null;
            opp.X1Force_Account__c = acct.X1Force_Account__c;
            opp.TAA_Account_Record_ID__c = null;
            oppList.add(opp);
        }
        update oppList;
        List<Opportunity> oppsExt = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = null];
        System.assertEquals(200, oppsExt.size());
        Test.startTest();
        Database.executeBatch(new TSM_RelateOpportunityToAccountBatch());
        Test.stopTest();
        // assert the number of opportunities are updated with respective accounts & contacts        
        List<Opportunity> oppsWithAccounts = [SELECT Id, AccountId, Contact__c FROM Opportunity WHERE AccountId != null];
        System.assertEquals(200, oppsWithAccounts.size());
        List<Opportunity> oppsWithContacts = [SELECT Id, AccountId, Contact__c FROM Opportunity WHERE Contact__c != null];
        System.assertEquals(200, oppsWithContacts.size());
    }
    
    // testing the accounts without matching taa_account_Record_id__c
    @isTest static void testDiffAcctConts() {
    	Account acct = new Account(Name='testfinal',TAA_Account_Record_Id__c='0010002100000F1xA1');
        insert acct;
        List<Contact> contacts = new List<Contact>();
        for(Integer i=100;i<300;i++) {
            String emailformat= 'testcont'+i+'@testwk.com';
            contacts.add(new Contact(FirstName='FN'+i,LastName='LN'+i,Email=emailformat,AccountId=acct.Id,
                       TAA_Account_Record_Id__c='0010002100000F2'+i,TAA_Contact_Record_ID__c='0030002100000F2'+i));
        }
        insert contacts;
        List<Contact> contactExt = [SELECT Id, AccountId, TAA_Account_Record_Id__c, TAA_Contact_Record_Id__c 
                                    FROM Contact WHERE Account.Name='testfinal'];
        System.assertEquals(200, contactExt.size());
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, AccountId, Contact__c,
                                                                TAA_Primary_Contact_for_Proposal__c,
                                                                TAA_Account_Record_Id__c FROM Opportunity]);
        List<Opportunity> oppList = oppMap.values();
        for(Integer j=0;j<200;j++) {
            oppList[j].TAA_Account_Record_Id__c = contactExt[j].TAA_Account_Record_Id__c;
            oppList[j].TAA_Primary_Contact_for_Proposal__c = contactExt[j].TAA_Contact_Record_Id__c;
            oppList[j].AccountId = null;
            oppList[j].Contact__c = null;
        }
        update oppList;
        List<Opportunity> oppsExt = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = null];
        System.assertEquals(200, oppsExt.size());
        Test.startTest();
        Database.executeBatch(new TSM_RelateOpportunityToAccountBatch());
        Test.stopTest();
        // assert the number of opportunities are updated with respective accounts & contacts        
        List<Opportunity> oppsWithAccounts = [SELECT Id, AccountId, Contact__c FROM Opportunity WHERE AccountId != null];
        System.assertEquals(200, oppsWithAccounts.size());
        List<Opportunity> oppsWithContacts = [SELECT Id, AccountId, Contact__c FROM Opportunity WHERE Contact__c != null];
        System.assertEquals(200, oppsWithContacts.size());
    }

}