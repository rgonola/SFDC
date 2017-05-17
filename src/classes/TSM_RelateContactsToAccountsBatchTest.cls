/*
 * test class for the batch apex class TSM_RelateContactsToAccountsBatch
 */
@isTest
public class TSM_RelateContactsToAccountsBatchTest {
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
        // insert the new accounts for data
        List<Contact> accounts = TSM_TestDataUtil.createOrphanContacts(200);
    }
	// for schedule job testing schedule job
    @isTest static void testScheduleJob() {
        // schedule the test job
        Test.startTest();        
        String jobId = System.schedule('jobName', '0 0 0 1 1 ? 2018', new TSM_RelateContactsToAccountsScheduler());
        Test.stopTest();
        List<CronTrigger> ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];                
        System.assertEquals(0, ct.size());             
    }
    
    // for testing the accountids not null
    @isTest static void testAccountLinks() {
        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, AccountId FROM Contact]);
        List<Contact> contList = contactMap.values();
        for(Contact ct: contList) {
            ct.AccountId = null;
        }
        update contList;
        List<Contact> contsExt = [SELECT Id, AccountId FROM Contact WHERE AccountId = null];
        System.assertEquals(200, contsExt.size());
        Test.startTest();
        Database.executeBatch(new TSM_RelateContactsToAccountsBatch());
        Test.stopTest();
        // assert the number of contacts are updated with respective accounts
        List<Contact> contsWithAccounts = [SELECT Id, AccountId FROM Contact WHERE AccountId != null];
        System.assertEquals(200, contsWithAccounts.size());
    }

}