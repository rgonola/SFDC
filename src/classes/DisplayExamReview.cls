@isTest(seealldata=true)
public class DisplayExamReview
{
    static testMethod void AtxPackages() 
    {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.Productcode='TRGEOEAALL1_2017';
        prod.IsActive=true;
        insert prod;
        
        //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
        
        //insert new Pricebook__c(Name = 'Pricebook2017',Pricebookid__c= priceBook.id);
        
        
        //Insert PriceBook Entry
        PricebookEntry priceBookEtry= new PricebookEntry();
        priceBookEtry.Pricebook2Id = priceBook.Id;
        priceBookEtry.Product2Id = prod.Id;
        priceBookEtry.UnitPrice = 12000; 
        priceBookEtry.IsActive = true;
        insert priceBookEtry;
        
        Test.StartTest(); 

// Tax Compliance - EA Exam Review
            PageReference pageRef1 = Page.Tax_Comp_ExamRev;
            
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController sc1 = new ApexPages.StandardController(prod);
            DisplayTaxCompExamRev pg = new DisplayTaxCompExamRev (sc1);
    
    
    Test.StopTest();

    }

}