public with sharing class DisplayTWPPR {
public Pricebookentry twpprprice {get;set;}

  public DisplayTWPPR(ApexPages.StandardController contoller) {
        
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    twpprprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'TWPAYPERPKG_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}