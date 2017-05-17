@isTest
public with sharing class CalculateTaxTest{
static testMethod void InsertingSpeedTax() {
        
         //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.ProductCode = '2016EFILEFEE';
        prod.IsActive=true;
        insert prod;
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Sales Tax';
        prod1.Family = 'Hardware';
        prod1.ProductCode = '2016EFILEFEE';
        prod1.IsActive=true;
        insert prod1;
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
        
        //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',PID__c = '10084',Customer_Account_Number__c= '253');
        insert account;
        
        //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'nmallela@steelbricl.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
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
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        cpqQuote.SBQQ__ShippingName__c ='Naveen';
        cpqQuote.SBQQ__ShippingStreet__c ='Mallela';
        cpqQuote.SBQQ__ShippingCity__c = 'annapolis';
        cpqQuote.SBQQ__ShippingState__c = 'MD';
        cpqQuote.SBQQ__ShippingPostalCode__c = '21401';
        cpqQuote.SBQQ__ShippingCountry__c = 'US';
        
        insert cpqQuote;
        
        //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine.SBQQ__Product__c= prod.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine;
        
         //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine1 =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine1.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine1.SBQQ__Product__c= prod1.id;
        cpqQuoteLine1.SBQQ__Quantity__c = 1;
        cpqQuoteLine1.SBQQ__ListPrice__c = 100;
        cpqQuoteLine1.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine1.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine1;
        
           test.starttest();  
        cpqQuote.Calculate_Tax__c =true;
        update cpqQuote;
        test.stoptest();
        
        
    }
  }