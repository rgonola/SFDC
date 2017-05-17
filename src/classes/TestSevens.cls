@isTest 
public class TestSevens
  {
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='CCHSSFORM706_2017';
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
        
        // Tax Compliance - Form 706 & 709 Preparation and Planning Self-Study Bundle 
            PageReference pageRef10 = Page.Tax_Comp_Sevens; 
            
            Test.setCurrentPage(pageRef10);
            ApexPages.StandardController sc10 = new ApexPages.StandardController(prod);
            DisplayTaxCompSevens pg10 = new DisplayTaxCompSevens(sc10);
        
        Test.StopTest();
        
      }
      
   }