public with sharing class DisplayRESSTATEMICH {
public Pricebookentry statemichprice {get;set;}

  public DisplayRESSTATEMICH(ApexPages.StandardController contoller) {
        

     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    statemichprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKMITAX_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}