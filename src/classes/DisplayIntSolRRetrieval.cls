public with sharing class DisplayIntSolRRetrieval {
public Pricebookentry retretrievalprice {get;set;}

  public DisplayIntSolRRetrieval(ApexPages.StandardController contoller) {
        

     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;

       retretrievalprice = [SELECT Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'ATX-RETURN RETRIEVAL_2017' ) AND Pricebook2Id =:prcbkid];

        }
}