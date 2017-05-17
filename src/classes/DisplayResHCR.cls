public with sharing class DisplayResHCR {
public Pricebookentry hcrprice {get;set;}

  public DisplayResHCR(ApexPages.StandardController contoller) {
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
       
        hcrprice = [SELECT Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'HCR LIBRARY_2017' ) AND Pricebook2Id =:prcbkid];

        
        }
}