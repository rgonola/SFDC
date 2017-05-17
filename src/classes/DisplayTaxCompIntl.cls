public with sharing class DisplayTaxCompIntl {
public Pricebookentry intlprice {get;set;}

  public DisplayTaxCompIntl(ApexPages.StandardController contoller) {
        
        
   
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    intlprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHSSINTLTAX_2017') AND Pricebook2Id =:prcbkid];
       

        }
}