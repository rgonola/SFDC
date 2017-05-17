@isTest
public with sharing class UpsellExtensionTest{
    static testMethod void cart() {
    
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
        //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
        
        insert new Pricebook__c(Name = 'Pricebook2016',Pricebookid__c= priceBook.id);
         
        invoiceit_s__Gateway__c gateway1 = new invoiceit_s__Gateway__c();
        gateway1.Name = 'Speed Tax';
        gateway1.invoiceit_s__Merchant_ID__c = 'naveen';
        gateway1.invoiceit_s__Merchant_Reference__c = 'naveen';
        gateway1.invoiceit_s__Security_Key__c = 'dsdqew32wdwd32de323ddsd' ;
        gateway1.invoiceit_s__Gateway_Type__c = 'CyberSource_CC_Token';
        gateway1.invoiceit_s__Active__c = true ;
        gateway1.invoiceit_s__Default__c = true;
        gateway1.invoiceit_s__Test_Mode__c = true;
        insert gateway1;
        
          //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.ProductCode = 'CCHUNLSEM_2016';
        prod.IsActive=true;
        insert prod;
        
           //Insert PriceBook Entry
        PricebookEntry priceBookEtry= new PricebookEntry();
        priceBookEtry.Pricebook2Id = priceBook.Id;
        priceBookEtry.Product2Id = prod.Id;
        priceBookEtry.UnitPrice = 12000; 
        priceBookEtry.IsActive = true;
        insert priceBookEtry;
        
         Product2 prod1 = new Product2();
        prod1.Name = 'Salews Tax';
        prod1.Family = 'Hardware';
        prod1.ProductCode = 'CCHLRNGCTR_2016';
        prod1.IsActive=true;
        insert prod1;
        
        Product2 prod2 = new Product2();
        prod2.Name = 'Sales Tax';
        prod2.Family = 'Hardware';
        prod2.ProductCode = '2016EFILEFEE';
        prod2.IsActive=true;
         
         insert prod2;
        
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
                
        //  Feature     
        SBQQ__ProductFeature__c feature1 = new SBQQ__ProductFeature__c();       
        feature1.Name = 'Test Featuresd';       
        feature1.SBQQ__Number__c = 2;       
        feature1.SBQQ__MinOptionCount__c = 1;       
        feature1.SBQQ__ConfiguredSKU__c = prod1.Id;     
        insert feature1;        
                
         //  Product Options        
        SBQQ__ProductOption__c po1 = new SBQQ__ProductOption__c();      
        po1.SBQQ__Number__c = 1;        
        po1.SBQQ__ConfiguredSKU__c = prod1.Id;      
        po1.SBQQ__OptionalSKU__c = prod1.Id;        
        po1.SBQQ__Feature__c = feature1.Id;     
        po1.Display_Type__c = 'Checkbox';       
        insert po1;
        
           //Insert PriceBook Entry
        PricebookEntry priceBookEtry1= new PricebookEntry();
        priceBookEtry1.Pricebook2Id = priceBook.Id;
        priceBookEtry1.Product2Id = prod1.Id;
        priceBookEtry1.UnitPrice = 12000; 
        priceBookEtry1.IsActive = true;
        insert priceBookEtry1;
        
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote= new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Opportunity2__c = opp.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__Primary__c =true;
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote;
        
        
        //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine.SBQQ__Product__c= prod2.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        
        //insert cpqQuoteLine;
            
        cart__c c =new cart__C();
        c.cart_Account__c=account.id;
        c.Promo_Id__c ='ABC';
        c.Total_Price__c=2000;
        insert c;
        
    Cookie cooky = new Cookie('rcid', c.Id, null, 1209600, false); 
            ApexPages.currentPage().setCookies(new Cookie[]{cooky }); 
            
     Promotion__c pm =new Promotion__c();
    pm.Name='perk';
    pm.Start__c=system.Today();
    pm.End__c=pm.Start__c.addYears(2);
    insert pm;
    
       
    Promotion_Entry__c cp =new Promotion_Entry__c();
    
   // cp.Active__c=true;
    cp.Product__c=prod.id;
    cp.Price__c=130;
    cp.Promotion__c=pm.id;
    //cp.Promo_Value__c=25;
   // cp.Promo_Code__c ='ACC';
    
    insert cp;
    
    test.starttest();
    
           PageReference pageRef = Page.ResearchProductPage;
           
              pageRef.getCookies().put('rcid', cooky);
           
             Test.setCurrentPage(pageRef); 
  
    ResearchPageExtension cx = new ResearchPageExtension();
    
    cx.prcbkid=priceBook.id;
    cx.nothanks();
    pageRef.getParameters().put( 'pymnhg',prod.id); 
    cx.ad2cart();
    pageRef.getParameters().put( 'pymnhg1',prod.id); 
    cx.ad2cart();
    cx.CreatePayment();   
    cx.createorder();     
    //cx.linkquoteandopp();
    test.stoptest();
    }
    
    
    }