public with sharing class jacksonhewittpower {
public Pricebookentry jhpowprice {get;set;}





        public jacksonhewittpower(ApexPages.StandardController contoller) {
        
        
        
        // Get prices of the Products
                Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
            string prcbkid = pricebook2id.Pricebookid__c;
   
    
    jhpowprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'TWPOWERPKGJH_2016' ) AND Pricebook2Id =:prcbkid];
                    
        }   
       
}