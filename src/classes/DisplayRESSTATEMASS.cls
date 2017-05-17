public with sharing class DisplayRESSTATEMASS {
public Pricebookentry statemassprice {get;set;}

  public DisplayRESSTATEMASS(ApexPages.StandardController contoller) {
        
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    statemassprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKMATAX_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}