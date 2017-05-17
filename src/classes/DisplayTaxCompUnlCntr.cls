public with sharing class DisplayTaxCompUnlCntr {
public Pricebookentry unlcntrprice {get;set;}

  public DisplayTaxCompUnlCntr(ApexPages.StandardController contoller) {

    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
   
    
    unlcntrprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHLRNGCTR_2017') AND Pricebook2Id =:prcbkid];
    

    }
}