public with sharing class TENFORTYPREP {
public Pricebookentry tenfortyprepprice {get;set;}

  public TENFORTYPREP (ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    tenfortyprepprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCH1040PREPCERT_2017') AND Pricebook2Id =:prcbkid];

        
        }
}