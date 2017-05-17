public with sharing class DisplayRESSTATEOH {
public Pricebookentry stateohprice {get;set;}

  public DisplayRESSTATEOH(ApexPages.StandardController contoller) {
        
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    stateohprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKOHTAX_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}