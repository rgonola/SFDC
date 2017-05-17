public with sharing class DisplayTaxCompFormTenfo {
public Pricebookentry formtenfoprice {get;set;}

  public DisplayTaxCompFormTenfo(ApexPages.StandardController contoller) {
        
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    formtenfoprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHSSFORM1041_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}