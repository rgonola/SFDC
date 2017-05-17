/*
 * Test apex class for TSM_OpportunityLineItemTrigger and TSM_OpportunityLineItemTriggerHandler
 * 
 * */
@isTest
public class TSM_OpportunityLineItemTriggerTest {
    // for data preparation
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
        List<Account> accts = TSM_TestDataUtil.createNewAccounts(1);
        List<Contact> contacts = TSM_TestDataUtil.createNewContacts(accts[0].Id, 1);
        List<Contact> contList = [SELECT Id, TAA_Contact_Record_id__c FROM Contact];
        List<Account> acctList = [SELECT Id, X1Force_Account__c FROM Account];
        List<Opportunity> opps = TSM_TestDataUtil.createOpportunities(acctList[0], contList[0], 1, UserInfo.getUserEmail());
        // Insert the test products.
        List<Product2> products = new List<Product2>();
        for(Integer i=0;i<200;i++) {
            products.add(new Product2(Name = 'Laptop X200'+i, Family = 'Hardware', ProductCode='PC1000'+i,
                                      X1Force_Product__c='10000'+i));
        }
        insert products;        
        // Get standard price book ID.
        Id pricebookId = Test.getStandardPricebookId();
        // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        // fetch the product2 records before creating pbentry records because it will throw DUPLICATE_ROW error
        List<Product2> prodList = [SELECT Id FROM Product2];
        //System.debug(prodList.size());
        // Insert a price book entry for the standard price book.
        List<PricebookEntry> stdPBEntries = new List<PricebookEntry>();
        for(Integer j=0;j<200;j++) {
            stdPBEntries.add(new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prodList[j].Id,
            				UnitPrice = j, IsActive = true));
        }
        insert stdPBEntries;
    }
    // test the positive scenario - insert
    @isTest static void testInsertPositive() {
    	List<Opportunity> oppList = [SELECT Id, TAA_Opportunity_Record_Id__c FROM Opportunity];
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.X1Force_Product__c FROM PricebookEntry];
        List<Product2> prodList = [SELECT Id, X1Force_Product__c FROM Product2];
        
        Test.startTest();
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId=oppList[0].Id,
                                                           PricebookentryId=pbList[0].Id,
                                                           UnitPrice=1,Quantity=10);
        insert item;
        Test.stopTest();
        List<OpportunityLineItem> itemExt = [SELECT Id, X1Force_product__c, Oppty_Record_Id__c,
                                             UnitPrice, Quantity FROM OpportunityLineItem];
        // assert the number of items are created
        System.assertEquals(1, itemExt.size());
        // assert the number of TSM_Shared_product__c records are created
        List<TSM_Shared_Product__c> tspExt = [SELECT Id, X1Force_Product__c, Oppty_Record_Id__c, Unit_price__c,
                                             Quantity__c, Oppty_Product_Record_ID__c FROM TSM_Shared_Product__c];
        // assert the respective field values in TSM_Shared_Product__c records
        System.assertEquals(1, tspExt.size());
        System.assertEquals(itemExt[0].X1Force_Product__c, tspExt[0].X1Force_Product__c);
        System.assertEquals(itemExt[0].Oppty_Record_Id__c, tspExt[0].Oppty_Record_Id__c);
        System.assertEquals(itemExt[0].Id, tspExt[0].Oppty_Product_Record_Id__c);
        System.assertEquals(itemExt[0].UnitPrice, tspExt[0].Unit_price__c);
        System.assertEquals(itemExt[0].Quantity, tspExt[0].Quantity__c);
    }
    // test the negative scenario - insert
    @isTest static void testInsertNegative() {
        List<Opportunity> oppList = [SELECT Id, TAA_Opportunity_Record_Id__c FROM Opportunity];
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.X1Force_Product__c FROM PricebookEntry];
        List<Product2> prodList = [SELECT Id, X1Force_Product__c FROM Product2];
        for(Opportunity opp: oppList) {
            opp.TAA_Opportunity_Record_Id__c = null;
        }
        update oppList;
        Test.startTest();
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId=oppList[0].Id,
                                                           PricebookentryId=pbList[0].Id,
                                                           UnitPrice=1,Quantity=10);
        insert item;
        Test.stopTest();
        List<OpportunityLineItem> itemExt = [SELECT Id, X1Force_product__c, Oppty_Record_Id__c,
                                             UnitPrice, Quantity FROM OpportunityLineItem];
        // assert the number of items are created
        System.assertEquals(1, itemExt.size());
        // assert the number of TSM_Shared_product__c records are created
        List<TSM_Shared_Product__c> tspExt = [SELECT Id, X1Force_Product__c, Oppty_Record_Id__c, Unit_price__c,
                                             Quantity__c, Oppty_Product_Record_ID__c FROM TSM_Shared_Product__c];
        System.assertEquals(0, tspExt.size());        
    }    
    // test the bulk records handling - insert
    @isTest static void testInsertBulk() {
    	List<Opportunity> oppList = [SELECT Id, TAA_Opportunity_Record_Id__c FROM Opportunity];
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.X1Force_Product__c FROM PricebookEntry];
        List<Product2> prodList = [SELECT Id, X1Force_Product__c FROM Product2];
        List<OpportunityLineItem> itemsList = new List<OpportunityLineItem>();
        for(Integer i=0;i<200;i++) {
            OpportunityLineItem item = new OpportunityLineItem(OpportunityId=oppList[0].Id,
                                                           PricebookentryId=pbList[0].Id,
                                                           UnitPrice=1,Quantity=20);        
            itemsList.add(item);
        }
        Test.startTest();
        insert itemsList;
        Test.stopTest();
        List<OpportunityLineItem> itemExt = [SELECT Id, X1Force_product__c, Oppty_Record_Id__c,
                                             UnitPrice, Quantity FROM OpportunityLineItem];
        // assert the number of items are created
        System.assertEquals(200, itemExt.size());
        // assert the number of TSM_Shared_product__c records are created
        List<TSM_Shared_Product__c> tspExt = [SELECT Id, X1Force_Product__c, Oppty_Record_Id__c, Unit_price__c,
                                             Quantity__c, Oppty_Product_Record_ID__c FROM TSM_Shared_Product__c];
         System.assertEquals(200, tspExt.size());           
    }
    // test the positive scenario - update
    @isTest static void testUpdatePositive() {
    	List<Opportunity> oppList = [SELECT Id, TAA_Opportunity_Record_Id__c FROM Opportunity];
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.X1Force_Product__c FROM PricebookEntry];
        List<Product2> prodList = [SELECT Id, X1Force_Product__c FROM Product2];
        // insert the line item
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId=oppList[0].Id,
                                                           PricebookentryId=pbList[0].Id,
                                                           UnitPrice=1,Quantity=10);
        insert item;
        List<OpportunityLineItem> itemExt = [SELECT Id, X1Force_product__c, Oppty_Record_Id__c,
                                             UnitPrice, Quantity FROM OpportunityLineItem];
        // assert the number of items are created
        System.assertEquals(1, itemExt.size());
        itemExt[0].Quantity = 100;
        itemExt[0].UnitPrice = 100;
        Test.startTest();
        update itemExt;
        Test.stopTest();
        List<OpportunityLineItem> itemExt2 = [SELECT Id, X1Force_product__c, Oppty_Record_Id__c,
                                             UnitPrice, Quantity FROM OpportunityLineItem 
                                             WHERE Quantity=100 AND UnitPrice=100];
        // assert the number of items are updated
        System.assertEquals(1, itemExt2.size());
        // assert the number of TSM_Shared_product__c records are updated
        List<TSM_Shared_Product__c> tspExt = [SELECT Id, X1Force_Product__c, Oppty_Record_Id__c, Unit_price__c,
                                             Quantity__c, Oppty_Product_Record_ID__c FROM TSM_Shared_Product__c 
                                              WHERE Quantity__c=100];
        // assert the respective field values in TSM_Shared_Product__c records
        System.assertEquals(1, tspExt.size());
        System.assertEquals(itemExt[0].X1Force_Product__c, tspExt[0].X1Force_Product__c);
        System.assertEquals(itemExt[0].Oppty_Record_Id__c, tspExt[0].Oppty_Record_Id__c);
        System.assertEquals(itemExt[0].Id, tspExt[0].Oppty_Product_Record_Id__c);
        System.assertEquals(itemExt[0].UnitPrice, tspExt[0].Unit_price__c);
        System.assertEquals(itemExt[0].Quantity, tspExt[0].Quantity__c);
    }
    
    // test the negative scenario - update
    @isTest static void testUpdateNegative() {
    	List<Opportunity> oppList = [SELECT Id, TAA_Opportunity_Record_Id__c FROM Opportunity];
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.X1Force_Product__c FROM PricebookEntry];
        List<Product2> prodList = [SELECT Id, X1Force_Product__c FROM Product2];
        // insert the line item
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId=oppList[0].Id,
                                                           PricebookentryId=pbList[0].Id,
                                                           UnitPrice=1,Quantity=10);
        insert item;
        List<OpportunityLineItem> itemExt = [SELECT Id, X1Force_product__c, Oppty_Record_Id__c,
                                             UnitPrice, Quantity FROM OpportunityLineItem];
        // assert the number of items are created
        System.assertEquals(1, itemExt.size());
        // update the record without changing unitprice and quantity
        itemExt[0].UnitPrice=1;
        itemExt[0].Quantity=10;
        Test.startTest();        
        update itemExt;
        Test.stopTest();
        List<OpportunityLineItem> itemExt2 = [SELECT Id, X1Force_product__c, Oppty_Record_Id__c,
                                             UnitPrice, Quantity FROM OpportunityLineItem];
        // assert the number of items are updated
        System.assertEquals(1, itemExt2.size());
        // assert the number of TSM_Shared_product__c records are updated
        List<TSM_Shared_Product__c> tspExt = [SELECT Id, X1Force_Product__c, Oppty_Record_Id__c, Unit_price__c,
                                             Quantity__c, Oppty_Product_Record_ID__c FROM TSM_Shared_Product__c];
        // assert the respective field values in TSM_Shared_Product__c records
        System.assertEquals(1, tspExt.size());
        System.assertEquals(itemExt[0].X1Force_Product__c, tspExt[0].X1Force_Product__c);
        System.assertEquals(itemExt[0].Oppty_Record_Id__c, tspExt[0].Oppty_Record_Id__c);
        System.assertEquals(itemExt[0].Id, tspExt[0].Oppty_Product_Record_Id__c);
        System.assertEquals(itemExt[0].UnitPrice, tspExt[0].Unit_price__c);
        System.assertEquals(itemExt[0].Quantity, tspExt[0].Quantity__c);
    }
    // test the bulk records handling - update
    @isTest static void testUpdateBulk() {
    	List<Opportunity> oppList = [SELECT Id, TAA_Opportunity_Record_Id__c FROM Opportunity];
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.X1Force_Product__c FROM PricebookEntry];
        List<Product2> prodList = [SELECT Id, X1Force_Product__c FROM Product2];
        List<OpportunityLineItem> itemsList = new List<OpportunityLineItem>();
        for(Integer i=0;i<200;i++) {
            OpportunityLineItem item = new OpportunityLineItem(OpportunityId=oppList[0].Id,
                                                           PricebookentryId=pbList[0].Id,
                                                           UnitPrice=1,Quantity=20);        
            itemsList.add(item);
        }
        insert itemsList;
        List<OpportunityLineItem> itemExt = [SELECT Id, X1Force_product__c, Oppty_Record_Id__c,
                                             UnitPrice, Quantity FROM OpportunityLineItem];
        // assert the number of items are created
        System.assertEquals(200, itemExt.size());
        for(OpportunityLineItem item: itemExt) {
            item.Quantity=200;
        }
        Test.startTest();
        update itemExt;
        Test.stopTest();
        List<OpportunityLineItem> itemExt2 = [SELECT Id, X1Force_product__c, Oppty_Record_Id__c,
                                             UnitPrice, Quantity 
                                              FROM OpportunityLineItem WHERE Quantity=200];
        // assert the number of items are updated
        System.assertEquals(200, itemExt2.size());        
        // assert the number of TSM_Shared_product__c records are created
        List<TSM_Shared_Product__c> tspExt = [SELECT Id, X1Force_Product__c, Oppty_Record_Id__c, Unit_price__c,
                                             Quantity__c, Oppty_Product_Record_ID__c FROM TSM_Shared_Product__c
                                             WHERE Quantity__c=200];
        System.assertEquals(200, tspExt.size());           
    }
    
      // test the delete scenario 
    @isTest static void testDelete() {
    	List<Opportunity> oppList = [SELECT Id, TAA_Opportunity_Record_Id__c FROM Opportunity];
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.X1Force_Product__c FROM PricebookEntry];
        List<Product2> prodList = [SELECT Id, X1Force_Product__c FROM Product2];
        
        Test.startTest();
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId=oppList[0].Id,
                                                           PricebookentryId=pbList[0].Id,
                                                           UnitPrice=1,Quantity=10);
        insert item;
        
        Test.stopTest();
        
        // assert the number of TSM_Shared_product__c records are created
        List<TSM_Shared_Product__c> tspExt = [SELECT Id, X1Force_Product__c, Oppty_Record_Id__c, Unit_price__c,
                                             Quantity__c, Oppty_Product_Record_ID__c FROM TSM_Shared_Product__c];
        // assert the respective field values in TSM_Shared_Product__c records
        System.assertEquals(1, tspExt.size());
        
        OpportunityLineItem item2 = [Select Id from OpportunityLineItem Where Id =: item.Id limit 1];
       
        delete item2;
        List<OpportunityLineItem> itemExt = [SELECT Id, X1Force_product__c, Oppty_Record_Id__c,
                                             UnitPrice, Quantity FROM OpportunityLineItem];
        // assert the number of items are created
        System.assertEquals(0, itemExt.size());
        
    }
    
}