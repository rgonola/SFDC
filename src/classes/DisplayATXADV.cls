public with sharing class DisplayATXADV {
public Pricebookentry advprice {get;set;}

  public DisplayATXADV(ApexPages.StandardController contoller) {
        

    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
 
    
      
     advprice = [SELECT Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'ATX-ADVANTAGE_2017') AND Pricebook2Id =:prcbkid];
    
    }
    
    }