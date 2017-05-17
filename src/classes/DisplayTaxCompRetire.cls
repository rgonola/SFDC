public with sharing class DisplayTaxCompRetire {
public Pricebookentry retireprice {get;set;}

  public DisplayTaxCompRetire(ApexPages.StandardController contoller) {
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
   
    
    retireprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHSSRETPLAN_2017') AND Pricebook2Id =:prcbkid];
    

    
    }
}