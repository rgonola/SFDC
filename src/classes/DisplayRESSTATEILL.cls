public with sharing class DisplayRESSTATEILL {
public Pricebookentry stateillprice {get;set;}

  public DisplayRESSTATEILL(ApexPages.StandardController contoller) {
        
   
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    stateillprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKILTAX_2017') AND Pricebook2Id =:prcbkid];

        
        }
}