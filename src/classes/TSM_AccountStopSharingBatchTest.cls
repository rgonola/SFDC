/*
 * Test class for apex classes TSM_AccountStopSharingBatch and TSM_AccountStopSharingScheduler
 * */
@isTest
public class TSM_AccountStopSharingBatchTest {
    // data preparation
    @testSetup static void dataPrep() {
    	TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c='CCH TAA';
        config.ScheduleSecondFrequency__c=60;
        List<User> otherAdminUser = [SELECT Id, Email, UserName FROM User WHERE IsActive = true 
                                     AND Profile.Name='System Administrator' 
                                    AND Id != :UserInfo.getUserId() LIMIT 1];
        config.HouseAdminUserName__c = otherAdminUser[0].Email;        
        insert config;        
    }
    
    // for schedule job testing schedule job
    @isTest static void testScheduleJob() {
        // schedule the test job
        Test.startTest();        
        String jobId = System.schedule('jobName', '0 0 0 1 1 ? 2018', new TSM_AccountStopSharingScheduler());
        Test.stopTest();
        List<CronTrigger> ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];                
        System.assertEquals(0, ct.size());             
    }
    
    // test the batch process
    @isTest static void testBatchProcess() {
        List<Account> accounts = TSM_TestDataUtil.createAccounts(200, 1, 0);
		// mock test and it is not possible to test the scenario because we can't make the replication between 2 orgs 
		// in test classes and test data without depending org data existing PNRC shared records        
        Test.startTest();
        Database.executeBatch(new TSM_AccountStopSharingBatch());
        Test.stopTest();
        // mock test assertion which is fake       
        List<Account> acctExt = [SELECT Id FROM Account WHERE ConnectionReceivedId = null];
        List<Contact> contExt = [SELECT Id FROM Contact WHERE ConnectionReceivedId = null];
        System.assertEquals(200, acctExt.size());
        System.assertEquals(200, contExt.size());         
    }
    
}