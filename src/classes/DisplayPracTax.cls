public with sharing class DisplayPracTax {
public Pricebookentry practaxprice {get;set;}

    public DisplayPracTax(ApexPages.StandardController controller) {
        

    // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
        
    
     
    practaxprice = [SELECT Id, Name, UnitPrice, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'ATX-PTEP_2016' ) AND Pricebook2Id =:prcbkid];

        }
}