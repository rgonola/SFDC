public with sharing class DisplayRESSTATENJ {
public Pricebookentry statenjprice {get;set;}

  public DisplayRESSTATENJ(ApexPages.StandardController contoller) {
        
        

     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    statenjprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKNJTAX_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}