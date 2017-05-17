public with sharing class DisplayRESCALC {
public Pricebookentry calculatorprice {get;set;}

  public DisplayRESCALC(ApexPages.StandardController contoller) {
        
   
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
       
       calculatorprice = [SELECT Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'FEDPENALTY-INTEREST_2017' ) AND Pricebook2Id =:prcbkid];

        }
}