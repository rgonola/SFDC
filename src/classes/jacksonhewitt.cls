public with sharing class jacksonhewitt {
public Pricebookentry jhprice {get;set;}





        public jacksonhewitt(ApexPages.StandardController contoller) {
        
        
        
        // Get prices of the Products
                Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
            string prcbkid = pricebook2id.Pricebookid__c;
   
    
    jhprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'TWPOWERPKGBIZJH_2016' ) AND Pricebook2Id =:prcbkid];
                    
        }   
       
}