@isTest
public with sharing class CreateCartTest{
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
        
        
          //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.IsActive=true;
        prod.ProductCode='TW';
        insert prod;
        
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote= new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Opportunity2__c = opp.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote;
        
        //Create Opportunity
        Web_Opp__c op =new Web_Opp__c ();
        op.Name= 'weborder'+''+datetime.now();
        op.WebAccount__c= account.id;
        op.Amount__c = 1000;
        op.CloseDate__c = Date.today();
        op.StageName__c= 'Negotiation';
        op.Product_c__c ='Web-Order';
        op.web_quote__c =cpqQuote.id;
        op.Type__c='New to New';
         insert op;
        //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine.SBQQ__Product__c= prod.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine;
         cart__c c =new cart__C();
    c.cart_Account__c=account.id;
     c.Promo_Id__c ='ABC';
    c.Total_Price__c=2000;
    insert c;
    
    Promotion_Entry__c cp =new Promotion_Entry__c();
    
   // cp.Active__c=true;
    cp.Product__c=prod.id;
    cp.Price__c=130;
    //cp.Promo_Value__c=25;
   // cp.Promo_Code__c ='ACC';
    
    insert cp;
    
    Cookie cooky = new Cookie('rcid', c.Id, null, 1209600, false); 
            ApexPages.currentPage().setCookies(new Cookie[]{cooky }); 
            
    CreateCart cc =new CreateCart();
    cc.renewalcrt(cpqQuote.id,account.id);
    cc.Line(prod.id,c.id,null,null);
    cc.Line(prod.id,null,null,null);
    cc.Line(prod.id,'x',null,null);
    
    
    
    
    
    }
    
    static testMethod void cart1() {
    
    Account account1 = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account1;
       // IIT_PID_CID_check.PID_CID_OFFC_AccID(10084,10045,1,account.id);
        
        //Contact Insert 
        Contact cont1 = new Contact();
        cont1.AccountId = account1.id;
        cont1.Email = 'test@gmail.com';
        cont1.FirstName = 'InvoiceIT';
        cont1.LastName =  'Test';
        cont1.Is_Primary__c = true;
        insert cont1;
        
        //insert Opportunity 
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = account1.id;
        opp1.CloseDate = System.today();
        opp1.StageName = 'Validation';
        opp1.Name = 'Opportunity Test';
        opp1.ForecastCategoryName = 'Medium Probability';
        opp1.Product__c = 'ATX';
        insert opp1;    
        //Insert PriceBook
        Pricebook2 priceBook1= new Pricebook2();
        priceBook1.Name='Custom Pricebook';
        priceBook1.isActive=true ;
        insert priceBook1;
        
        
          //Insert product 
        Product2 prod1 = new Product2();
        prod1.Name = 'Laptop X200';
        prod1.Family = 'Hardware';
        prod1.IsActive=true;
        insert prod1;
        
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote1= new SBQQ__Quote__c();
        cpqQuote1.SBQQ__Account__c = account1.id;
        cpqQuote1.SBQQ__Opportunity2__c = opp1.id;
        cpqQuote1.SBQQ__Status__c = 'Draft';
        cpqQuote1.SBQQ__PrimaryContact__c =cont1.id;
        cpqQuote1.SBQQ__Type__c = 'Quote';
        cpqQuote1.SBQQ__StartDate__c = System.today();
        cpqQuote1.SBQQ__PriceBook__c = priceBook1.id;
        insert cpqQuote1;
        
        //Create Opportunity
        Web_Opp__c op1 =new Web_Opp__c ();
        op1.Name= 'weborder'+''+datetime.now();
        op1.WebAccount__c= account1.id;
        op1.Amount__c = 1000;
        op1.CloseDate__c = Date.today();
        op1.StageName__c= 'Negotiation';
        op1.Product_c__c ='Web-Order';
        op1.web_quote__c =cpqQuote1.id;
        op1.Type__c='New to New';
         insert op1;
        //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine1 =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine1.SBQQ__Quote__c = cpqQuote1.id;
        cpqQuoteLine1.SBQQ__Product__c= prod1.id;
        cpqQuoteLine1.SBQQ__Quantity__c = 1;
        cpqQuoteLine1.SBQQ__ListPrice__c = 100;
        cpqQuoteLine1.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine1.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine1;
         cart__c c1 =new cart__C();
    c1.cart_Account__c=account1.id;
   
    c1.Total_Price__c=2000;
    insert c1;
    
            
    CreateCart cc =new CreateCart();
    cc.renewalcrt(cpqQuote1.id,account1.id);
    cc.Line(prod1.id,c1.id,null,null);
    cc.Line(null,null,null,null);
    
     }
    static testMethod void cart2() {
    
    CreateCart cc =new CreateCart();
    cc.Line(null,null,null,null);
    }
   
    }