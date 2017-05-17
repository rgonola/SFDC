@isTest 
public class TestTaxBookTenForty 
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='ECTAXBOOK1040ED_2017';
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
        
        //Books - TheTaxBook™ Deluxe 1040
        PageReference pageRef48 = Page.Res_The_TaxBook_1040;
        
        Test.setCurrentPage(pageRef48);
        ApexPages.StandardController sc48 = new ApexPages.StandardController(prod);
        DisplayRESTAXBOOKTENFORTY pg48 = new DisplayRESTAXBOOKTENFORTY(sc48);
        
        Test.StopTest();
        
      }
      
   }