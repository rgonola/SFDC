public with sharing class DisplayRESELEC {
public Pricebookentry electprice {get;set;}

  public DisplayRESELEC(ApexPages.StandardController contoller) {
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    electprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ELECTIONCOMPLIANCE_2017') AND Pricebook2Id =:prcbkid];
 
        }
}