public with sharing class DisplayAccoWtwo {
public Pricebookentry wtwotennineprice {get;set;}

  public DisplayAccoWtwo(ApexPages.StandardController contoller) {
        
        

     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;


       
        
       wtwotennineprice = [SELECT Id, Name, UnitPrice, Product2Id, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'ALACARTE ATX W2_2017' ) AND Pricebook2Id =:prcbkid];
        
        }
}