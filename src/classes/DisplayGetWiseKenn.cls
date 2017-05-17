public with sharing class DisplayGetWiseKenn {
public Pricebookentry wisekenn {get;set;}

  public DisplayGetWiseKenn(ApexPages.StandardController contoller) {
        

    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
 
    
      
     wisekenn = [SELECT Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'TRGSEMGETWISEKENDAY2_2016') AND Pricebook2Id =:prcbkid];
    
    }
    
    }