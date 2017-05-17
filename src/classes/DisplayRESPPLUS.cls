public with sharing class DisplayRESPPLUS {
public Pricebookentry pplusprice {get;set;}

  public DisplayRESPPLUS(ApexPages.StandardController contoller) {
        

     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    

       pplusprice = [SELECT Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ALACARTE ATX DM_2017' ) AND Pricebook2Id =:prcbkid];

        }
}