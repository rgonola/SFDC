@isTest 
public class TestBookOH
 {
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='ECBOOKOHTAX_2017';
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
        
             //Books - OH Taxes
            PageReference pageRef45 = Page.Res_State_OH;
            
            Test.setCurrentPage(pageRef45);
            ApexPages.StandardController sc45 = new ApexPages.StandardController(prod);
            DisplayRESSTATEOH pg45 = new DisplayRESSTATEOH(sc45);
        
        Test.StopTest();
        
      }
      
   }