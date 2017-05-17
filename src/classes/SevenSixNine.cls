public with sharing class SevenSixNine {
public Pricebookentry sixnineprice {get;set;}

  public SevenSixNine(ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    sixnineprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCHCERTFORMS706709_2017') AND Pricebook2Id =:prcbkid];

        
        }
}