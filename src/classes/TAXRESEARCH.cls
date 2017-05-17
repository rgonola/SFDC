public with sharing class TAXRESEARCH {
public Pricebookentry taxresearchprice {get;set;}

  public TAXRESEARCH (ApexPages.StandardController contoller) {
        
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    taxresearchprice = [SELECT Product2Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'CCHTAXRESEARCHCERT_2017') AND Pricebook2Id =:prcbkid];

        
        }
}