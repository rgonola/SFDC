@isTest
public class IFirmExtensionTest {
    static testMethod void m1() {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.productcode='CSIFIRMPLSTD5GBNONSB_2016';
        prod.IsActive=true;
        insert prod;
        
        //  Feature
        SBQQ__ProductFeature__c feature = new SBQQ__ProductFeature__c();
        feature.Name = 'Test Feature';
        feature.SBQQ__Number__c = 1;
        feature.SBQQ__MinOptionCount__c = 1;
        feature.SBQQ__ConfiguredSKU__c = prod.Id;
        insert feature;
        
         //  Product Options
        SBQQ__ProductOption__c po = new SBQQ__ProductOption__c();
        po.SBQQ__Number__c = 1;
        po.SBQQ__ConfiguredSKU__c = prod.Id;
        po.SBQQ__OptionalSKU__c = prod.Id;
        po.SBQQ__Feature__c = feature.Id;
        po.Display_Type__c = 'Checkbox';
        insert po;
        
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
        
        //    Account
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;
        IIT_PID_CID_check.PID_CID_OFFC_AccID(10084,10045,1,account.id);
        
         //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
        //insert Opportunity 
        Opportunity opp = new Opportunity();
        opp.AccountId = account.id;
        opp.CloseDate = System.today();
        opp.StageName = 'Validation';
        opp.Name = 'Opportunity Test';
        opp.ForecastCategoryName = 'Medium Probability';
        opp.Product__c = 'ATX';
        insert opp; 
       
       
        Promotion_Entry__c cp =new Promotion_Entry__c();
        // cp.Active__c=true;
        cp.Product__c=prod.id;
        cp.Price__c=130;
        //cp.Promo_Value__c=25;
        // cp.Promo_Code__c ='ACC';
        
        insert cp;
        
        //    Cart
        cart__c cc =new cart__C();
        cc.cart_Account__c=account.id;
        cc.Total_Price__c=2000;
        insert cc;
        
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Opportunity2__c = opp.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__Primary__c =true;
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote;
        
        //    Cookie
        Cookie cooky = new Cookie('rcid', cc.Id, null, 1209600, false); 
        
         test.starttest();
         
        PageReference pageRef = Page.IFrimUpsellPage;
           pageRef.getCookies().put('rcid', cooky);
             
             Test.setCurrentPage(pageRef);
        IFirmExtension obj = new IFirmExtension();
        obj.nothanks();
        obj.ad2cart();
        obj.crtqutl();
        
        
        
          test.stoptest();
    }
    
    static testMethod void m2() {
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.productcode='CSIFIRMPLSTD5GBNONSB_2016';
        prod.IsActive=true;
        insert prod;
        
        //  Feature
        SBQQ__ProductFeature__c feature = new SBQQ__ProductFeature__c();
        feature.Name = 'Test Feature';
        feature.SBQQ__Number__c = 1;
        feature.SBQQ__MinOptionCount__c = 1;
        feature.SBQQ__ConfiguredSKU__c = prod.Id;
        insert feature;
        
         //  Product Options
        SBQQ__ProductOption__c po = new SBQQ__ProductOption__c();
        po.SBQQ__Number__c = 1;
        po.SBQQ__ConfiguredSKU__c = prod.Id;
        po.SBQQ__OptionalSKU__c = prod.Id;
        po.SBQQ__Feature__c = feature.Id;
        po.Display_Type__c = 'Checkbox';
        insert po;
        
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
        
        //    Account
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;
        IIT_PID_CID_check.PID_CID_OFFC_AccID(10084,10045,1,account.id);
        
         //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
        //insert Opportunity 
        Opportunity opp = new Opportunity();
        opp.AccountId = account.id;
        opp.CloseDate = System.today();
        opp.StageName = 'Validation';
        opp.Name = 'Opportunity Test';
        opp.ForecastCategoryName = 'Medium Probability';
        opp.Product__c = 'ATX';
        insert opp; 
       
       
        Promotion_Entry__c cp =new Promotion_Entry__c();
        // cp.Active__c=true;
        cp.Product__c=prod.id;
        cp.Price__c=130;
        //cp.Promo_Value__c=25;
        // cp.Promo_Code__c ='ACC';
        
        insert cp;
        
        //    Cart
        cart__c cc =new cart__C();
        cc.cart_Account__c=account.id;
        cc.Total_Price__c=2000;
        insert cc;
        
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Opportunity2__c = opp.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__Primary__c =true;
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote;
        
        //    Cookie
        Cookie cooky = new Cookie('rcid', cc.Id, null, 1209600, false); 
        
         test.starttest();
         
       
        
        PageReference pageRef1 = Page.OffersIFrimUpsellPage;
           pageRef1.getCookies().put('rcid', cooky);
             
             Test.setCurrentPage(pageRef1);
        OffersIFirmExtension obj1 = new OffersIFirmExtension();
        obj1.nothanks();
        obj1.ad2cart();
        obj1.cql();
        
          test.stoptest();
    }
}