@isTest 
public class TestBookCT
 {
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='ECBOOKCTTAX_2017';
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
        
          //Books - Conn Taxes
            PageReference pageRef37 = Page.Res_State_Conn; 
            
            Test.setCurrentPage(pageRef37);
            ApexPages.StandardController sc37 = new ApexPages.StandardController(prod);
            DisplayRESSTATECONN pg37 = new DisplayRESSTATECONN(sc37);
            
        
        Test.StopTest();
        
      }
      
   }