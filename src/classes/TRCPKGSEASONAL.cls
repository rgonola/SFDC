public with sharing class TRCPKGSEASONAL {
public Pricebookentry trcpkgprice {get;set;}

  public TRCPKGSEASONAL(ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    trcpkgprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCH-ICONNECTTRCSEAS_2017') AND Pricebook2Id =:prcbkid];

        
        }
}