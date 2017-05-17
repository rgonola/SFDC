@isTest 
public class TestTPPTenFoLite
 {
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='TPP1040 LITE_2017';
        prod.IsActive=true;
        insert prod;
        
        //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
        
       insert new Pricebook__c(Name = 'Pricebook2017',Pricebookid__c= priceBook.id);
        
        
        //Insert PriceBook Entry
        PricebookEntry priceBookEtry= new PricebookEntry();
        priceBookEtry.Pricebook2Id = priceBook.Id;
        priceBookEtry.Product2Id = prod.Id;
        priceBookEtry.UnitPrice = 12000; 
        priceBookEtry.IsActive = true;
        insert priceBookEtry;
        
        
        Test.StartTest();
        
        //Books - Tax Prep Partner (TPP) 1040 Lite
            PageReference pageRef33 = Page.Res_Online_TTP_1040;
            
            Test.setCurrentPage(pageRef33);
            ApexPages.StandardController sc33 = new ApexPages.StandardController(prod);
            DisplayRESTTPLITE pg33 = new DisplayRESTTPLITE(sc33);
        
        Test.StopTest();
        
      }
      
   }