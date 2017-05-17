public with sharing class DisplayRESTTPPSTNDRD {
public Pricebookentry tppstndrdprice {get;set;}

  public DisplayRESTTPPSTNDRD(ApexPages.StandardController contoller) {
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    tppstndrdprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'TPPSTDBUND_2017') AND Pricebook2Id =:prcbkid];
       
        

        
        }
}