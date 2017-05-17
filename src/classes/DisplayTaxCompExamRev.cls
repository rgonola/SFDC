public with sharing class DisplayTaxCompExamRev {
public Pricebookentry examrevprice {get;set;}

  public Map<String, Decimal> unitprice {get;set;}

  public DisplayTaxCompExamRev(ApexPages.StandardController contoller) {
         
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    examrevprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'TRGEOEAALL1_2017') AND Pricebook2Id =:prcbkid];
       

        
        }
}