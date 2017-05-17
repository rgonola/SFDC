public with sharing class DisplayRESTOOLKIT {
public Pricebookentry toolkitprice {get;set;}

  public DisplayRESTOOLKIT(ApexPages.StandardController contoller) {
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    toolkitprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CLIENTLETTER_2017') AND Pricebook2Id =:prcbkid];
       

        }
}