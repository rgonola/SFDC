public with sharing class PrepPlanning {
public Pricebookentry prepplanprice {get;set;}

  public PrepPlanning(ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    prepplanprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCHCERT1041_2017') AND Pricebook2Id =:prcbkid];

        
        }
}