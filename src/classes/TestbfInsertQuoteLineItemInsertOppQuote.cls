@isTest(seeAllData=true)
public class TestbfInsertQuoteLineItemInsertOppQuote   {
    static testMethod void TestbfInsertQuoteLineItemInsertOppQuote() {
    
        Id AMFSNSaccountRecordTypeId=[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Account'].Id;
        Id AMFSNSproductRecordTypeId=[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Product'].Id;
        
        Account newAccount = new Account(Name = 'Test Account1 for Renewal Quote', RecordTypeId = AMFSNSaccountRecordTypeId, 
                                         Primary_Contact_Name__c = 'Test Contact', Email__c ='testcontact@test.com',
                                         CID__c = '444444', PID__c = '333333', OFFC__c = 0); 
        insert newAccount;   
        
        Account newAccount1 = new Account(Name = 'Test Account1 for Renewal Quote1', RecordTypeId = AMFSNSaccountRecordTypeId, 
                                         Primary_Contact_Name__c = 'Test Contact', Email__c ='testcontact2@test.com',
                                         CID__c = '555555', PID__c = '333333', OFFC__c = 1); 
        insert newAccount1; 
              
        System.assertEquals(newAccount.RecordTypeId, AMFSNSaccountRecordTypeId);
        
        Pricebook2 newPricebook = new Pricebook2(Name = 'Renewal Quote Test', IsActive = True, 
                                                 Description = 'test pricebook');
        insert newPricebook;
           
        Product2 newProduct = new Product2(Name = 'TEST PRODUCT RENEWAL', ProductCode = 'TEST PRODUCT RENEWAL', 
                                           Family = 'Others', IsActive = True, Description = 'test product',
                                           RecordTypeId = AMFSNSproductRecordTypeId);
        insert newProduct;                 
        System.assertEquals(newProduct.RecordTypeId, AMFSNSproductRecordTypeId);
        
        /*PricebookEntry newPBE = new PricebookEntry(Pricebook2Id = newPricebook.Id, Product2Id = newProduct.Id,
                                                   IsActive = True, UnitPrice = 0.0); 
        insert newPBE;
        System.assertEquals(newPBE.Pricebook2Id, newPricebook.Id);
        System.assertEquals(newPBE.Product2Id, newProduct.Id);  */  
                                                       
        QuoteLineItem newQLI = new QuoteLineItem(Discount = 10, PROMO_DESC__c = 'test prduct', SALES_CODE__c =  'TST',
                                                 UnitPrice = 156,  Quantity = 5, Item_Id__c = 'TEST PRODUCT RENEWAL',
                                                 CID__c = '444444', Quote_Id__c = 1111111, Description = 'test product', 
                                                 LINE_NO__c = 1);
        insert newQLI;       
        
    }
}