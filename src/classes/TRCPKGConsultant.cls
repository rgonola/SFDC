public with sharing class TRCPKGConsultant {
public Pricebookentry trconsultprice {get;set;}

  public TRCPKGConsultant (ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    trconsultprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCH-ICONNECT_TRC_PKG_2017') AND Pricebook2Id =:prcbkid];

        
        }
}