public with sharing class DisplayTaxCompSevens {
public Pricebookentry sevensprice {get;set;}

  public DisplayTaxCompSevens(ApexPages.StandardController contoller) {
        
        
   
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    sevensprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHSSFORM706_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}