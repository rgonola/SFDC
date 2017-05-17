public with sharing class tppseasonal {
public Pricebookentry tppseasonalprice {get;set;}





        public tppseasonal(ApexPages.StandardController contoller) {
        
        
        
        // Get prices of the Products
                Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
            string prcbkid = pricebook2id.Pricebookid__c;
   
    
    tppseasonalprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'TPP1040 SEASONAL_2017' ) AND Pricebook2Id =:prcbkid];
                    
        }   
       
}