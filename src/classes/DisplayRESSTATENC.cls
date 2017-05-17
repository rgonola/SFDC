public with sharing class DisplayRESSTATENC {
public Pricebookentry statencprice {get;set;}

  public DisplayRESSTATENC(ApexPages.StandardController contoller) {
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    statencprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKNCTAX_2017') AND Pricebook2Id =:prcbkid];

        
        }
}