public with sharing class DisplayRESMASTERTAX {
public Pricebookentry mastertaxprice {get;set;}

  public DisplayRESMASTERTAX(ApexPages.StandardController contoller) {
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    
       mastertaxprice = [SELECT Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKMTG 17_2017' ) AND Pricebook2Id =:prcbkid];

        
        }
}