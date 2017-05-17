@isTest 
public class TestiFirmPracMngr
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='ECCSIFIRMPMSTD_EVER';
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
        
        //Ifirm Client Portal
        PageReference pageRef64 = Page.iFirm_Prac_Mngr;         
        
        Test.setCurrentPage(pageRef64);
        ApexPages.StandardController sc64 = new ApexPages.StandardController(prod);
        DisplayiFirmPracMngr pg64 = new DisplayiFirmPracMngr(sc64);
        
        Test.StopTest();
        
      }
      
   }