@isTest
public with sharing class OrderConfirmationTest{
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
        
        insert new Pricebook__c(Name = 'Pricebook2016',Pricebookid__c= priceBook.id);
        
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
        //cc.customer_Type__c = 'Renewal';
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
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote;
        
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
        
        invoiceit_s__Gateway__c gateway = new invoiceit_s__Gateway__c();
        gateway.Name = 'Test';
        gateway.invoiceit_s__Merchant_ID__c = 'naveen';
        gateway.invoiceit_s__Merchant_Reference__c = 'naveen';
        gateway.invoiceit_s__Security_Key__c = 'dsdqew32wdwd32de323ddsd' ;
        gateway.invoiceit_s__Gateway_Type__c = 'CyberSource_CC_Token';
        gateway.invoiceit_s__Active__c = true ;
        gateway.invoiceit_s__Default__c = true;
        gateway.invoiceit_s__Test_Mode__c = true;
        insert gateway; 
        
        //Insert Payment Method
        invoiceit_s__Payment_Method__c PM = new invoiceit_s__Payment_Method__c();
        PM.invoiceit_s__Account__c = account.id;
        PM.invoiceit_s__Active__c = true;
        PM.invoiceit_s__Default__c= true;
        PM.invoiceit_s__Billing_Address__c = 'Bangalore';
        PM.invoiceit_s__Billing_Country__c = 'US';
        PM.invoiceit_s__Billing_Email__c = 'test@gmail.com';
        PM.invoiceit_s__Billing_First_Name__c= 'Invoice';
        PM.invoiceit_s__Billing_Last_Name__c = 'IT';
        PM.invoiceit_s__Billing_State_Province__c= 'CA';
        PM.invoiceit_s__Billing_Zip_Postal__c= '56009';
        PM.invoiceit_s__Card_Expiration_Month__c  = '11';
        PM.invoiceit_s__Card_Expiration_Year__c= '2019';
        PM.invoiceit_s__Card_Number__c= '4111111111111111';
        PM.invoiceit_s__Card_Type__c= 'Visa';
        PM.invoiceit_s__Name_on_Card__c='Naveen';
        PM.invoiceit_s__Payment_Method__c = 'Credit Card';
        insert PM;
        
      
             
               Test.StartTest();   
           
           
            PageReference pageRef = Page.OrderConfirmationPage; // Add your VF page Name here
            pageRef.getParameters().put('type', String.valueOf(cc.Id));
            Test.setCurrentPage(pageRef); 
             OrderConfirmationExtension pg2 = new OrderConfirmationExtension();
            
             PageReference pageRef1 = Page.Printquotepdf;
           
             pageRef1.getParameters().put('accuntId', String.valueOf(account.id));
             
             Test.setCurrentPage(pageRef1);
              QuotePDF  q= new QuotePDF ();
             
             
             PageReference pageRef2 = Page.OrderConfirmationPdf;
           
             pageRef2.getParameters().put('accuntId', String.valueOf(account.id));
             
             Test.setCurrentPage(pageRef2);
              OrderPdf q1= new OrderPdf ();
             
             
         Test.StopTest();
}
}