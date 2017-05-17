public with sharing class DisplayiFirmPracMngr {
public PricebookEntry pracmngrprice {get;set;}

  public DisplayiFirmPracMngr(ApexPages.StandardController contoller) {
       // Set<String> pracmngroptions= new Set<String>();     
        
        // pracmngroptions.add('CSIFIRMSFM1-3_NONSB_2016');//1-3 users
        // pracmngroptions.add('CSIFIRMSFM4_6_NONSB_2016');//4-6 users
        // pracmngroptions.add('CSIFIRMSFM7-10_NONSB_2016');//7-10 users

     // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2017'); 
        string prcbkid = pricebook2id.Pricebookid__c;
    
     
     pracmngrprice = [SELECT Id, Name, UnitPrice, Product2.Marketing_Name__c, Product2.Productcode FROM PricebookEntry WHERE (Product2.Productcode = 'ECCSIFIRMPMSTD_EVER') AND Pricebook2Id =:prcbkid]; 

        
        }

}