public with sharing class DisplayGetWiseLV {
public Pricebookentry wiselv {get;set;}

  public DisplayGetWiseLV(ApexPages.StandardController contoller) {
        

    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
 
    
      
     wiselv = [SELECT Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'TRGSEMGETWISELVREG_2016') AND Pricebook2Id =:prcbkid];
    
    }
    
    }