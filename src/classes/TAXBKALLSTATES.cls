public with sharing class TAXBKALLSTATES {
public Pricebookentry allstatesprice {get;set;}

  public TAXBKALLSTATES (ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    allstatesprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'ECTAXBOOKALLSTATE_2017') AND Pricebook2Id =:prcbkid];

        
        }
}