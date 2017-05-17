public with sharing class DisplayATXtenforty {
public Pricebookentry tenfortyprice {get;set;}

  public DisplayATXtenforty(ApexPages.StandardController contoller) {
        
   
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;

       
        
        tenfortyprice = [SELECT Id, Name, UnitPrice, Product2Id, Product2.ProductCode FROM PricebookEntry WHERE (Product2.productcode = 'ATX-1040_2017' ) AND Pricebook2Id =:prcbkid];
        
        }

}