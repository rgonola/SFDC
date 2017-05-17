public with sharing class DisplayRESSTATEHB {
public Pricebookentry statehbprice {get;set;}

  public DisplayRESSTATEHB(ApexPages.StandardController contoller) {
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    statehbprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKSTATETAX_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}