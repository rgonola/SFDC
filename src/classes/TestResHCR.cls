@isTest 
public class TestResHCR
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='HCR LIBRARY_2017';
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
        
           // Tax Compliance - Health Care Reform Library 
            PageReference pageRef14 = Page.Res_HCR;
            
            Test.setCurrentPage(pageRef14);
            ApexPages.StandardController sc14 = new ApexPages.StandardController(prod);
            DisplayResHCR pg14 = new DisplayResHCR(sc14);
        
        Test.StopTest();
        
      }
      
   }