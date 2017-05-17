@isTest 
public class TestPayrollComp 
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='ATX-PRCOMP ALACARTE_2017';
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
        
        //Payroll Compliance Reporting
        PageReference pageRef61 = Page.Acco_PR_Comp_Repo;
        
        Test.setCurrentPage(pageRef61);
        ApexPages.StandardController sc61 = new ApexPages.StandardController(prod);
        DisplayAccoPRCOMPREPO pg61 = new DisplayAccoPRCOMPREPO(sc61);
        
        Test.StopTest();
        
      }
      
   }