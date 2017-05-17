public with sharing class DisplayRESSTATECONN {
public Pricebookentry stateconnprice {get;set;}

  public DisplayRESSTATECONN(ApexPages.StandardController contoller) {
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    stateconnprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKCTTAX_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}