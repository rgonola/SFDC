public with sharing class SalesUseCert {
public Pricebookentry salesuseprice {get;set;}

  public SalesUseCert(ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    salesuseprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCHCERTSUT_2017') AND Pricebook2Id =:prcbkid];

        
        }
}