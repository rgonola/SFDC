public with sharing class FormThreeOne {
public Pricebookentry threeoneprice {get;set;}

  public FormThreeOne (ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    threeoneprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCHTPP3115_2017') AND Pricebook2Id =:prcbkid];

        
        }
}