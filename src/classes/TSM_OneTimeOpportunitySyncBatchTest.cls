/*
 * test class for TSM_OneTimeOpportunitySyncBatch
 * */
@isTest
public class TSM_OneTimeOpportunitySyncBatchTest {
    // data preparation
    @testSetup static void dataPrep() {
    	TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c='CCH TAA';
        insert config;
        List<Account> accounts = TSM_TestDataUtil.createAccounts(1, 1, 200);		
    }
    // test the batch process for opportunities does meet criteria
    @isTest static void testPositive() {
    	Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, Migrate_Oppty__c FROM Opportunity]);
        List<Opportunity> oppList = oppMap.values();
        System.assertEquals(200, oppList.size());
        for(Opportunity opp : oppList) {
            opp.Migrate_Oppty__c = true;            
        }
        update oppList;
        Test.startTest();
        Database.executeBatch(new TSM_OneTimeOpportunitySyncBatch());
        Test.stopTest();
        // assert the number of opportunities
        List<Opportunity> oppExt = [SELECT Id FROM Opportunity WHERE Migrate_Oppty__c =true];        
        System.assertEquals(200, oppExt.size());
        // asser the number of PNRC entries
        List<PartnerNetworkRecordConnection> pnrcExt = [SELECT Id, LocalRecordId FROM PartnerNetworkRecordConnection
                                                       WHERE LocalRecordId IN :oppMap.keySet()];
        System.assertEquals(200, pnrcExt.size());
    }
	// test the batch process for opportunities doesn't meet criteria
    @isTest static void testNegative() {
    	Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, Migrate_Oppty__c FROM Opportunity]);
        List<Opportunity> oppList = oppMap.values();
        System.assertEquals(200, oppList.size());
        for(Opportunity opp : oppList) {
            opp.Migrate_Oppty__c = false;            
        }
        update oppList;
        Test.startTest();
        Database.executeBatch(new TSM_OneTimeOpportunitySyncBatch());
        Test.stopTest();
        // assert the number of opportunities
        List<Opportunity> oppExt = [SELECT Id FROM Opportunity WHERE Migrate_Oppty__c =false];        
        System.assertEquals(200, oppExt.size());
        // asser the number of PNRC entries
        List<PartnerNetworkRecordConnection> pnrcExt = [SELECT Id, LocalRecordId FROM PartnerNetworkRecordConnection
                                                       WHERE LocalRecordId IN :oppMap.keySet()];
        System.assertEquals(0, pnrcExt.size());
    }
}