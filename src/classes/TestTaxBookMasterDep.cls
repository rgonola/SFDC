@isTest 
public class TestTaxBookMasterDep 
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='ECBOOKDEPRECTAX_2017';
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
        
        //Books - U.S. Master Depreciation Guide (2016)
        PageReference pageRef49 = Page.Res_Master_Dep;
        
        Test.setCurrentPage(pageRef49);
        ApexPages.StandardController sc49 = new ApexPages.StandardController(prod);
        DisplayRESMasterDEP pg49 = new DisplayRESMasterDEP(sc49);
        
        Test.StopTest();
        
      }
      
   }