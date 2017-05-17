public with sharing class DisplayRESSTATECALI {
public Pricebookentry statecaliprice {get;set;}

  public DisplayRESSTATECALI(ApexPages.StandardController contoller) {
        
   
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    statecaliprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKCATAX_2017') AND Pricebook2Id =:prcbkid];

        
        }
}