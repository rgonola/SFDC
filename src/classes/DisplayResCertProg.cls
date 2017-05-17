public with sharing class DisplayResCertProg {
public Pricebookentry certprog {get;set;}

  public DisplayResCertProg(ApexPages.StandardController contoller) {
        

    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
 
    
      
     certprog = [SELECT Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCHCERTIRSREP_2016') AND Pricebook2Id =:prcbkid];
    
    }
    
    }