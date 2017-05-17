/*
 * test class for TSM_SharedProductTrigger and TSM_ProductTriggerHandler
 * */
@isTest
public class TSM_SharedProductTriggerTest {
    // data preparation
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
    // insert positive scenario
    @isTest static void testInsertPositive() {
        TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
        tsp.X1Force_Product__c = 'X1Force123';
        tsp.Oppty_Record_ID__c='OpptyRecord123';
        tsp.Oppty_Product_Record_ID__c = 'OpptyPrdRec123';
        Test.startTest();
        insert tsp;
        Test.stopTest();
        // assert the TSP_Shared_product__c records count
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c];
        System.assertEquals(1, tspExt.size());
        // assert the PNRC sharing entries count
        List<PartnerNetworkRecordConnection> pnrcExt = [SELECT Id FROM PartnerNetworkRecordConnection 
                                                        WHERE LocalRecordId = :tspExt[0].Id];
        System.assertEquals(1, pnrcExt.size());
    }
    // insert negative scenario
    @isTest static void testInsertNegative() {
    	TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
        tsp.X1Force_Product__c = 'X1Force123';
        tsp.Oppty_Record_ID__c='OpptyRecord123';
        tsp.Oppty_Product_Record_ID__c = null;
        Test.startTest();
        insert tsp;
        Test.stopTest();
        // assert the TSP_Shared_product__c records count
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c];
        System.assertEquals(1, tspExt.size());
        // assert the PNRC sharing entries count
        List<PartnerNetworkRecordConnection> pnrcExt = [SELECT Id FROM PartnerNetworkRecordConnection 
                                                        WHERE LocalRecordId = :tspExt[0].Id];
        System.assertEquals(0, pnrcExt.size());    
    }
    // insert bulk operation
    @isTest static void testBulk() {
    	List<TSM_Shared_Product__c> tspList = new List<TSM_Shared_Product__c>();
        for(Integer i=0;i<200; i++) {
            TSM_Shared_product__c tsp = new TSM_Shared_Product__c();
            tsp.X1Force_Product__c = 'X1Force123';
            tsp.Oppty_Record_ID__c='OpptyRecord123';
            tsp.Oppty_Product_Record_ID__c = 'OpptyPrdRec123';
            tspList.add(tsp);
        }
        Test.startTest();
        insert tspList;
        Test.stopTest();
        // assert the TSP_Shared_product__c records count
        Map<Id, TSM_Shared_Product__c> tspMap = new Map<Id, TSM_Shared_Product__c>([SELECT Id 
                                                                                    FROM TSM_Shared_Product__c]);
        List<TSM_Shared_Product__c> tspExt = tspMap.values();
        System.assertEquals(200, tspExt.size());
        // assert the PNRC sharing entries count
        List<PartnerNetworkRecordConnection> pnrcExt = [SELECT Id FROM PartnerNetworkRecordConnection 
                                                        WHERE LocalRecordId IN :tspMap.keySet()];
        System.assertEquals(200, pnrcExt.size());   
    }
    
    // test the delete shares
    @isTest static void testDeleteShares() {
    	TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
        tsp.X1Force_Product__c = 'X1Force123';
        tsp.Oppty_Record_ID__c='OpptyRecord123';
        tsp.Oppty_Product_Record_ID__c = 'OpptyPrdRec123';
        insert tsp;
        // assert the TSP_Shared_product__c records count
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c];
        System.assertEquals(1, tspExt.size());
        // assert the PNRC sharing entries count
        List<PartnerNetworkRecordConnection> pnrcList = [SELECT Id FROM PartnerNetworkRecordConnection 
                                                        WHERE LocalRecordId = :tspExt[0].Id AND Status='Invite'];
        System.assertEquals(1, pnrcList.size());
        TSM_Util.deleteShares(pnrcList, 'test', 'trigger');
        Test.startTest();        
        TSM_Util.deleteShares(pnrcList, 'test', 'trigger');
        Test.stopTest();
        // assert it is deactivated
        List<PartnerNetworkRecordConnection> pnrcExt = [SELECT Id FROM PartnerNetworkRecordConnection 
                                                        WHERE LocalRecordId = :tspExt[0].Id AND Status='Inactive'];
        System.assertEquals(1, pnrcExt.size());
        // assert the errors/exceptions for multiple times of delete operations.
        List<TSM_App_Log__c> logExt = [SELECT Id FROM TSM_App_Log__c];
        System.assertEquals(1, logExt.size());
    }
    
    // test insert shares
    @isTest static void testInsertShares() {
        TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
        tsp.X1Force_Product__c = 'X1Force123';
        tsp.Oppty_Record_ID__c='OpptyRecord123';
        tsp.Oppty_Product_Record_ID__c = 'OpptyPrdRec123';
        insert tsp;
        List<PartnerNetworkRecordConnection> pnrcList = new List<PartnerNetworkRecordConnection>();
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();	   
        Id networkId = TSM_Util.getNetworkId(tsmCS.connectionName__c);        
        pnrcList.add(TSM_Util.prepareShare(tsp.Id, null, null));
        Test.startTest();
        TSM_Util.insertShares(pnrcList, 'testing', 'trigger');
        Test.stopTest();
        // assert the log entry DML error
        List<TSM_App_Log__c> logList = [SELECT Id, Error_message__c FROM TSM_App_Log__c];
        System.assertEquals(1, logList.size());
        System.assertEquals(true, loglist[0].Error_Message__c.contains('Required fields are missing: [ConnectionId]'));
    }
  
}