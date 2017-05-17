public with sharing class DisplayAccoPRCOMPREPO {
public PricebookEntry price {get;set;}

  public DisplayAccoPRCOMPREPO(ApexPages.StandardController contoller) {
        
        
  
            
         
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
        
    
       
        
        price = [SELECT Id, Name, Product2Id, Product2.productcode, UnitPrice FROM PricebookEntry WHERE (Product2.productcode = 'ATX-PRCOMP ALACARTE_2017' ) AND Pricebook2Id =:prcbkid];
           
}
}