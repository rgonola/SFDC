@isTest
public with sharing class ATXPdfTest{
    static testMethod void orderconf() {
         //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.T_Cs__c='Standard 2016';
        prod.Marketing_Name__c='marketing';
        prod.IsActive=true;
        insert prod;
        
        //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
        
        
        
        //Insert PriceBook Entry
        PricebookEntry priceBookEtry= new PricebookEntry();
        priceBookEtry.Pricebook2Id = priceBook.Id;
        priceBookEtry.Product2Id = prod.Id;
        priceBookEtry.UnitPrice = 12000; 
        priceBookEtry.IsActive = true;
        insert priceBookEtry;
        
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__c = '10045',PID__c = '10084');
        insert account;
        
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'nmallela@steelbricl.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        cont.MailingStreet = 'Test';
        cont.MailingState  = 'MD';
        cont.MailingPostalCode = '21401';
        cont.MailingCity = 'annapolis';
        cont.MailingCountry = 'US';
        insert cont;
        
         //insert cart
        cart__c cc =new cart__C();
        cc.cart_Account__c=account.id;
        cc.Total_Price__c=2000;
        insert cc;
        
        //cookie 
        Cookie cooky = new Cookie('cartid', cc.Id, null, 1209600, false); 
            ApexPages.currentPage().setCookies(new Cookie[]{cooky }); 
            
        //insert cartlines
        Cart_Line__c cl =new Cart_Line__c();
        cl.Cart__c=cc.id;
        cl.Product__c=prod.id;
        cl.Quantity__c=1;
       // cl.Option_Id__c= ;
        insert cl;
        
          //insert Opportunity 
        Opportunity opp = new Opportunity();
        opp.AccountId = account.id;
        opp.CloseDate = System.today();
        opp.StageName = 'Validation';
        opp.Name = 'Opportunity Test';
        opp.ForecastCategoryName = 'Medium Probability';
        opp.Product__c = 'ATX';
        insert opp;  
        
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Opportunity2__c = opp.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__Primary__c =true;
        cpqQuote.Batch_Print__c ='Batch1';
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote;
        insert new PDF_Quote_Ids__c(Name = 'Batch',Batch_No__c= 'Batch1');
        SBQQ__ProductOption__c ml=new SBQQ__ProductOption__c (SBQQ__ConfiguredSKU__c=prod.id,SBQQ__OptionalSKU__c=prod.id
                                    ,SBQQ__Feature__c =prod.id , SBQQ__Bundled__c =TRUE,SBQQ__Required__c = true);
        
          //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine1 =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine1.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine1.SBQQ__Product__c= prod.id;
        cpqQuoteLine1.SBQQ__Quantity__c = 1;
        cpqQuoteLine1.SBQQ__Bundled__c=False;
        
        //cpqQuoteLine1.SBQQ__RequiredBy__c =cpqQuote.id;
        cpqQuoteLine1.SBQQ__ListPrice__c = 100;
        cpqQuoteLine1.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine1.SBQQ__NetPrice__c = 100;
        cpqQuoteLine1.SBQQ__ProductOption__c =ml.id;
        insert cpqQuoteLine1;
        
         //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine.SBQQ__Product__c= prod.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__Bundled__c=False;
        cpqQuoteLine.SBQQ__RequiredBy__c =cpqQuoteLine1.id;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        cpqQuoteLine.SBQQ__ProductOption__c =ml.id;
        insert cpqQuoteLine;
        
  
        
      
             
               Test.StartTest();   
           
             
              PageReference pageRef3 = Page.OrderConfirmationPdf;
           
             pageRef3.getParameters().put('accuntId', String.valueOf(cpqQuote.id));
             
             Test.setCurrentPage(pageRef3);
              ATXTWQuotepdfgenerator q2= new ATXTWQuotepdfgenerator();
         Test.StopTest();
}
}