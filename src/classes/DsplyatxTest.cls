@isTest
public class DsplyatxTest 
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='PRSRET1_2016';
        prod.IsActive=true;
        insert prod;
        
        //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
        
       // insert new Pricebook__c(Name = 'Pricebook2016',Pricebookid__c= priceBook.id);
        Pricebook__c pb = new Pricebook__c();
        pb.Name = 'Pricebook2016';
        pb.Pricebookid__c = priceBook.Id;
        insert pb;
        
        //Insert PriceBook Entry
        PricebookEntry priceBookEtry= new PricebookEntry();
        priceBookEtry.Pricebook2Id = priceBook.Id;
        priceBookEtry.Product2Id = prod.Id;
        priceBookEtry.UnitPrice = 12000; 
        priceBookEtry.IsActive = true;
        insert priceBookEtry;
        
        Test.StartTest(); 
           
            PageReference pageRef = Page.ATX_Product_Page; // Add your VF page Name here
            
            Test.setCurrentPage(pageRef);
             ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            Displayproducts testAccPlan = new Displayproducts(sc);

            Test.StopTest(); 
        }
        }