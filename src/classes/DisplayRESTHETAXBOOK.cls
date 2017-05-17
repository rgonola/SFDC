public with sharing class DisplayRESTHETAXBOOK {
public Pricebookentry thetaxbookprice {get;set;}

  public DisplayRESTHETAXBOOK(ApexPages.StandardController contoller) {
        
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    thetaxbookprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM Pricebookentry WHERE (Product2.ProductCode = 'ECTAXBOOKDELUXE_2017') AND pricebook2id =:prcbkid];  

        }
}