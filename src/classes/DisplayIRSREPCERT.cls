public with sharing class DisplayIRSREPCERT {
public Pricebookentry irsrepcertprice {get;set;}

  public DisplayIRSREPCERT(ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    irsrepcertprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCHCERTIRSREP_2017') AND Pricebook2Id =:prcbkid];

        
        }
}