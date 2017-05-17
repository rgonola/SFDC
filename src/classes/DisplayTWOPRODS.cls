public with sharing class DisplayTWOPRODS {
public List<PricebookEntry> twoprodprice {get;set;}

  public DisplayTWOPRODS(ApexPages.StandardController contoller) {
       Set<String> twopackages= new Set<String>();     
        
        twopackages.add('TWONLINELITE_2017');//Lite
        twopackages.add('TWONLINEPRO_2017');//Pro
        twopackages.add('TWONLINEENT_2017');//Enterprise
  
    
     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
    twoprodprice = [Select Id, Name, UnitPrice, Product2.ProductCode, Product2.Marketing_Name__c , Product2.Detail_description__c , Product2.Product_Short_Description__c From PricebookEntry Where Product2.ProductCode IN: twopackages and Pricebook2id=:prcbkid  order by UnitPrice]; 

        
        }

}