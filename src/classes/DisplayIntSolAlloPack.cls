public with sharing class DisplayIntSolAlloPack {
public Pricebookentry allopackprice {get;set;}

  public DisplayIntSolAlloPack(ApexPages.StandardController contoller) {
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
     
      allopackprice = [SELECT Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'ATX-OH CITIES_2017' ) AND Pricebook2Id =:prcbkid];

        }
}