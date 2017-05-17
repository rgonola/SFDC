public with sharing class DisplayTaxCompEstate {
public Pricebookentry estateprice {get;set;}

  public DisplayTaxCompEstate(ApexPages.StandardController contoller) {
        

    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
   
    
    estateprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHSSESTATE_2017') AND Pricebook2Id =:prcbkid];
    

    }
}