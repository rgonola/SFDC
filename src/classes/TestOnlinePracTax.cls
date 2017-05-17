@isTest 
public class TestOnlinePracTax
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='PTEP_2017';
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
        
        //Books - Practical Tax Expert Editorial Content
            PageReference pageRef24 = Page.Res_Online_Prac_Tax;
            
            Test.setCurrentPage(pageRef24);
            ApexPages.StandardController sc24 = new ApexPages.StandardController(prod);
            DisplayRESPRACTAX pg24 = new DisplayRESPRACTAX(sc24);
        
        Test.StopTest();
        
      }
      
   }