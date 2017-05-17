public with sharing class DisplayRESTAXBOOKTENFORTY {
public Pricebookentry taxbooktenfortyprice {get;set;}

  public DisplayRESTAXBOOKTENFORTY(ApexPages.StandardController contoller) {
        
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    taxbooktenfortyprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECTAXBOOK1040ED_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}