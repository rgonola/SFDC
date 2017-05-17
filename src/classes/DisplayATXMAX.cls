public with sharing class DisplayATXMAX {
public Pricebookentry maxprice {get;set;}

  public DisplayATXMAX(ApexPages.StandardController contoller) {
        
        
     
    
        // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
        
        maxprice = [SELECT Id, Name, UnitPrice, Product2Id, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'ATX-MAX_2017') AND Pricebook2Id =:prcbkid];
        
        }

}