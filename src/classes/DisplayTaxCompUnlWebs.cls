public with sharing class DisplayTaxCompUnlWebs {
public Pricebookentry unlwebsprice {get;set;}

  public DisplayTaxCompUnlWebs(ApexPages.StandardController contoller) {
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
   
    
    unlwebsprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHUNLSEM_2017') AND Pricebook2Id =:prcbkid];
    
      

    
    }
}