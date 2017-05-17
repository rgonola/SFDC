public with sharing class DisplayiFirmSeasonal {
public PricebookEntry seasonalprice {get;set;}

  public DisplayiFirmSeasonal(ApexPages.StandardController contoller) {
        
 
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
     
    seasonalprice = [SELECT Id, Name, UnitPrice, Product2.Marketing_Name__c, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'ECCSIFIRMPM_PORT_EVER' ) AND Pricebook2Id =:prcbkid];

        
        }
}