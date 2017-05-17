public with sharing class jacksonhewittTPP {
public Pricebookentry jhtppprice {get;set;}





        public jacksonhewittTPP(ApexPages.StandardController contoller) {
        
        
        
        // Get prices of the Products
                Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
            string prcbkid = pricebook2id.Pricebookid__c;
   
    
    jhtppprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCHTPPBIZ_2016' ) AND Pricebook2Id =:prcbkid];
                    
        }   
       
}