public with sharing class DisplayTaxCompMulti {
public Pricebookentry multistateprice {get;set;}

  public DisplayTaxCompMulti(ApexPages.StandardController contoller) {
        
        
   
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    multistateprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'CCHSSMULTI_2017') AND Pricebook2Id =:prcbkid];
       
        
        }
}