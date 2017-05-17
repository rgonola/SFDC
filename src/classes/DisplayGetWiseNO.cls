public with sharing class DisplayGetWiseNO {
public Pricebookentry wiseno {get;set;}

  public DisplayGetWiseNO(ApexPages.StandardController contoller) {
        

    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
 
    
      
     wiseno = [SELECT Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'TRGSEMGETWISENOREG_2016') AND Pricebook2Id =:prcbkid];
    
    }
    
    }