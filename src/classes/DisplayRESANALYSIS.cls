public with sharing class DisplayRESANALYSIS {
public Pricebookentry analysisprice {get;set;}

  public DisplayRESANALYSIS(ApexPages.StandardController contoller) {
        
    
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    
       analysisprice = [SELECT Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'BOOKACA_2016' ) AND Pricebook2Id =:prcbkid]; 

        }
}