public with sharing class DisplayTaxCompSalesUse {
public Pricebookentry salesuseprice {get;set;}

  public DisplayTaxCompSalesUse(ApexPages.StandardController contoller) {
        
        
    
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    salesuseprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHSSSUT_2016') AND Pricebook2Id =:prcbkid];
       

        
        }
}