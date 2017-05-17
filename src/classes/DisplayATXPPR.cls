public with sharing class DisplayATXPPR {
public Pricebookentry atxpprprice {get;set;}

  public DisplayATXPPR(ApexPages.StandardController contoller) {
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    atxpprprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ATX-PRSPKG_2017') AND Pricebook2Id =:prcbkid];
       

        
        }

}