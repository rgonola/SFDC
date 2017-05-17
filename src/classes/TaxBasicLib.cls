public with sharing class TaxBasicLib {
public Pricebookentry taxbasicprice {get;set;}

  public TaxBasicLib (ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    taxbasicprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCHTAXBASICTAXLIB_2017') AND Pricebook2Id =:prcbkid];

        
        }
}