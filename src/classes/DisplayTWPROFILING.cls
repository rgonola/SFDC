public with sharing class DisplayTWPROFILING {
public Pricebookentry profilingprice {get;set;}

  public DisplayTWPROFILING(ApexPages.StandardController contoller) {
        

     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    profilingprice = [SELECT Product2Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'TWPROFILING_2017') AND Pricebook2Id =:prcbkid];

        
        }
}