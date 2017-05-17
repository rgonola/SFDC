public with sharing class DisplayATXADDIUSERS {
public List<PricebookEntry> addiusersprice {get;set;}

  public DisplayATXADDIUSERS(ApexPages.StandardController contoller) {
       Set<String> additionalusers= new Set<String>();     
        
        additionalusers.add('ATX-UL1_2017');//1 additional user
        additionalusers.add('ATX-UL5_2017');//5 additional users
        additionalusers.add('ATX-UL10_2017');//10 additional users
        additionalusers.add('ATX-UL20_2017');//20 additional user
   
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
       addiusersprice = [SELECT Id, Name, UnitPrice, Product2.Marketing_Name__c, Product2.productcode FROM PricebookEntry WHERE (Product2.productcode IN: additionalusers) AND Pricebook2Id =:prcbkid order by UnitPrice];

        
        }
}