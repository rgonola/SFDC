public with sharing class DisplayTaxCompPassThru {
public Pricebookentry passthruprice {get;set;}

  public DisplayTaxCompPassThru(ApexPages.StandardController contoller) {
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    passthruprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHSSPASSTHRU_2017') AND Pricebook2Id =:prcbkid];
       

        }
}