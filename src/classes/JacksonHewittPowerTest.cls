@isTest 
public class JacksonHewittPowerTest
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='TWPOWERPKGJH_2016';
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
        
        //ATX PPR
        PageReference pageRef231 = Page.Jackson_Hewitt_TW_Power_Biz;
        
        Test.setCurrentPage(pageRef231);
        ApexPages.StandardController sc231 = new ApexPages.StandardController(prod);
        jacksonhewittpower pg231 = new jacksonhewittpower(sc231);   
        
        Test.StopTest();
        
      }
      
   }