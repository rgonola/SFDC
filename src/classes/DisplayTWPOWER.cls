public with sharing class DisplayTWPOWER {
public Pricebookentry powerprice {get;set;}

  public DisplayTWPOWER(ApexPages.StandardController contoller) {
        
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    powerprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'TWPOWERPKG_2017') AND Pricebook2Id =:prcbkid];
 
        }
}