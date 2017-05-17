public with sharing class DisplayATXTTO {
public Pricebookentry ttoprice {get;set;}





        public DisplayATXTTO(ApexPages.StandardController contoller) {
        
        
        
        // Get prices of the Products
                Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
            string prcbkid = pricebook2id.Pricebookid__c;
   
    
    ttoprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'ATX-TTO_2017' ) AND Pricebook2Id =:prcbkid];
                    
        }   
       
}