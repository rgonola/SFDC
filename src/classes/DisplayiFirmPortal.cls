public with sharing class DisplayiFirmPortal {
public PricebookEntry portalprice {get;set;}

  public DisplayiFirmPortal(ApexPages.StandardController contoller) {
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    
       
      portalprice = [SELECT Id, Name, UnitPrice, Product2.Marketing_Name__c, Product2.productcode FROM PricebookEntry WHERE (Product2.Productcode= 'ECCSIFIRMPORTSTD_EVER' ) AND Pricebook2Id =:prcbkid];
 
        
        }
}