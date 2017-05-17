@isTest 
public class TestTWOnline 
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='TWONLINELITE_2017';
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
        priceBookEtry.Pricebook2Id = '01sE0000000Zxht';
        priceBookEtry.Product2Id = prod.Id;
        priceBookEtry.UnitPrice = 12000; 
        priceBookEtry.IsActive = true;
        insert priceBookEtry;
        
        
        Test.StartTest();
        
        //TaxWise Online
        PageReference pageRef53 = Page.TW_Online_Grid;
        
        Test.setCurrentPage(pageRef53);
        ApexPages.StandardController sc53 = new ApexPages.StandardController(prod);
        DisplayTWOPRODS pg53 = new DisplayTWOPRODS(sc53);
        
        Test.StopTest();
        
      }
      
   }