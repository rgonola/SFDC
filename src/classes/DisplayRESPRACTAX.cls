public with sharing class DisplayRESPRACTAX {
public Pricebookentry practaxprice {get;set;}

  public DisplayRESPRACTAX(ApexPages.StandardController contoller) {
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    
        practaxprice = [SELECT Id, Name, UnitPrice, Product2Id, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'PTEP_2017' ) AND Pricebook2Id =:prcbkid];
        
        
        }
}