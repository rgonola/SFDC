public with sharing class DisplayRESTPPTENFO {
public Pricebookentry tpptenfoprice {get;set;}

  public DisplayRESTPPTENFO(ApexPages.StandardController contoller) {
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
            
    tpptenfoprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'TPP1040_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}