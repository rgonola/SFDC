public with sharing class DisplayRESMasterDEP {
public Pricebookentry masterdepprice {get;set;}

  public DisplayRESMasterDEP(ApexPages.StandardController contoller) {
        
 
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    

       masterdepprice = [SELECT Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ECBOOKDEPRECTAX_2017' ) AND Pricebook2Id =:prcbkid];
       

        }
}