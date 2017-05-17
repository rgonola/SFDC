public with sharing class DisplayInterForms {
public Pricebookentry intformsprice {get;set;}

  public DisplayInterForms(ApexPages.StandardController contoller) {
        
   
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    
       intformsprice = [SELECT Id, Name, UnitPrice, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode = 'ATX-IF_2017' ) AND Pricebook2Id =:prcbkid];

        
        }
}