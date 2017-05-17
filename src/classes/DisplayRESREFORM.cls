public with sharing class DisplayRESREFORM {
public Pricebookentry reformprice {get;set;}
public String reformpageid {get;set;}
  public Map<String, Decimal> unitprice {get;set;}
  public Cart__C cart {get;set;}
  public DisplayRESREFORM(ApexPages.StandardController contoller) {
        
        
  
            
        reformpageid = ApexPages.currentPage().getParameters().get('packageid');
        cart = new Cart__c();   
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
        unitprice = new Map<String, Decimal>();
    
   
       reformprice = [SELECT Id, Name, UnitPrice, Product2Id, Product2.ProductCode FROM PricebookEntry WHERE (Product2.ProductCode = 'HCR LIBRARY_2016' ) AND Pricebook2Id =:prcbkid];
        
        for(PricebookEntry price : [SELECT Id, Name, UnitPrice, Product2Id FROM PricebookEntry WHERE (Product2Id = '01tE00000092llL' ) AND Pricebook2Id =:prcbkid]){
            if(price.UnitPrice != null)
            unitprice.put(price.Product2Id, price.UnitPrice);
            }
        
        }
}