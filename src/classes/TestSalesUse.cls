@isTest 
public class TestSalesUse
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='CCHSSSUT_2016';
        prod.IsActive=true;
        insert prod;
        
        //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
        
       insert new Pricebook__c(Name = 'Pricebook2016',Pricebookid__c= priceBook.id);
        
        
        //Insert PriceBook Entry
        PricebookEntry priceBookEtry= new PricebookEntry();
        priceBookEtry.Pricebook2Id = priceBook.Id;
        priceBookEtry.Product2Id = prod.Id;
        priceBookEtry.UnitPrice = 12000; 
        priceBookEtry.IsActive = true;
        insert priceBookEtry;
        
        
        Test.StartTest();
        
         // Tax Compliance - Sales and Use Taxes Self-Study Bundle 
            PageReference pageRef8 = Page.Tax_Comp_Sales; 
            
            Test.setCurrentPage(pageRef8);
            ApexPages.StandardController sc8 = new ApexPages.StandardController(prod);
            DisplayTaxCompSalesUse pg8 = new DisplayTaxCompSalesUse(sc8);
        
        Test.StopTest();
        
      }
      
   }