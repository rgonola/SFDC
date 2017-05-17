public with sharing class DisplayRESSTATEFLA {
public Pricebookentry stateflaprice {get;set;}

  public DisplayRESSTATEFLA(ApexPages.StandardController contoller) {
        

     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    stateflaprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKFLTAX_2017') AND Pricebook2Id =:prcbkid];

        
        }
}