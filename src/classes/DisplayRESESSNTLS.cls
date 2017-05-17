public with sharing class DisplayRESESSNTLS {
public Pricebookentry essentialsprice {get;set;}

  public DisplayRESESSNTLS(ApexPages.StandardController contoller) {
        

     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    essentialsprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHESSENTIALSPKG_2017') AND Pricebook2Id =:prcbkid];

        }
}