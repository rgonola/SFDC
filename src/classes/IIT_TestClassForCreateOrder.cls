@isTest(seealldata=false)
public with sharing class IIT_TestClassForCreateOrder{
    static testMethod void createOrder() {
         IIT_TestClassForUassage.insertCustomSetting();

         list<Invoiceit_s__Configuration__c> objects = new list<Invoiceit_s__Configuration__c>();
        
        Invoiceit_s__Configuration__c c1 =  new Invoiceit_s__Configuration__c(Name = 'PID_last', invoiceit_s__Number_Value__c= 1000); 
         objects.add((Invoiceit_s__Configuration__c) c1);
         
         Invoiceit_s__Configuration__c c2 =  new Invoiceit_s__Configuration__c(Name = 'CID_last', invoiceit_s__Number_Value__c= 1000); 
         objects.add((Invoiceit_s__Configuration__c) c2);
         
         //insert objects;
        
         //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
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
        
        //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;
        //IIT_PID_CID_check.PID_CID_OFFC_AccID(10084,10045,1,account.id);
        
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
        
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Opportunity2__c = opp.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
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
        
        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD',invoiceit_s__Symbol__c = '$');    
        insert currency1;
        
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
        
            
            //opp.QTC__Create_Order__c = true;
           // update opp;
        
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
        
         //Insert Payment Method
        invoiceit_s__Payment_Method__c PM1 = new invoiceit_s__Payment_Method__c();
        PM1.invoiceit_s__Account__c = account.id;
        PM1.invoiceit_s__Active__c = true;
        
        PM1.invoiceit_s__Billing_Address__c = 'Bangalore';
        PM1.invoiceit_s__Billing_Country__c = 'US';
        PM1.invoiceit_s__Billing_Email__c = 'test@gmail.com';
        PM1.invoiceit_s__Billing_First_Name__c= 'Invoice';
        PM1.invoiceit_s__Billing_Last_Name__c = 'IT';
        PM1.invoiceit_s__Billing_State_Province__c= 'CA';
        PM1.invoiceit_s__Billing_Zip_Postal__c= '56009';
        PM1.invoiceit_s__Card_Expiration_Month__c  = '11';
        PM1.invoiceit_s__Card_Expiration_Year__c= '2019';
        PM1.invoiceit_s__Card_Number__c= '4111111111111111';
        PM1.invoiceit_s__Card_Type__c= 'Visa';
        PM1.invoiceit_s__Name_on_Card__c='Naveen';
        PM1.invoiceit_s__Payment_Method__c = 'Credit Card';
        
        insert PM1;
        
        
        
        //Insert Pyament plan
        invoiceit_s__Payment_Plan__c paymentPlan = new invoiceit_s__Payment_Plan__c();
        paymentPlan.Name = 'Test PaymentPlan';
        //paymentPlan.invoiceit_s__Down_Payment__c = 5;
        paymentPlan.invoiceit_s__Down_Payment_Amount__c =6;
        paymentPlan.Down_Payment_Criteria__c ='Sales Tax;Down Payment Amount';
        paymentPlan.Payment_Methods__c = 'Credit Card;COA;ACH';
        paymentPlan.invoiceit_s__Minimum_Installments__c = 2;
        paymentPlan.invoiceit_s__Maximum_Installments__c =6;
        paymentPlan.Payments_Date_Range__c= system.today();
        paymentPlan.End_Date__c = system.today().addYears(2);
        paymentPlan.Max_Number_of_Payment_Methods__c = 3;
        Insert paymentPlan;
        
        //Insert Pyament plan
        invoiceit_s__Payment_Plan__c paymentPlan1 = new invoiceit_s__Payment_Plan__c();
        paymentPlan1.Name = 'Test PaymentPlan';
        //paymentPlan1.invoiceit_s__Down_Payment__c = 5;
        paymentPlan1.invoiceit_s__Down_Payment_Amount__c =6;
        paymentPlan1.Down_Payment_Criteria__c ='Sales Tax;Down Payment Amount';
        paymentPlan1.Payment_Methods__c = 'Credit Card;COA;ACH';
        paymentPlan1.invoiceit_s__Minimum_Installments__c = 2;
        paymentPlan1.invoiceit_s__Maximum_Installments__c =6;
        //paymentPlan1.Payments_Date_Range__c= system.today();
        paymentPlan1.End_Date__c = system.today().addYears(-1);
        paymentPlan1.Max_Number_of_Payment_Methods__c = 3;
        Insert paymentPlan1;
        
        
        cpqQuote.QTC__Payment_Plan__c= paymentPlan.id;
        cpqQuote.Tax_Grand_Total__c = 100;
        cpqQuote.Tax__c=10;
        cpqQuote.SBQQ__Primary__c=true;
        cpqQuote.Tax_Time_Stamp__c =  system.now().addHours(-2);
        update cpqQuote;
        //insert payment paln installment 
        invoiceit_s__Payment_Plan_Installment__c paymentPlanInstallment =  new invoiceit_s__Payment_Plan_Installment__c();
        paymentPlanInstallment.invoiceit_s__Account__c = account.id;
        paymentPlanInstallment.invoiceit_s__Payment_Date__c = system.today();
        paymentPlanInstallment.QTC__Quote__c = cpqQuote.id;
        paymentPlanInstallment.invoiceit_s__Payment_Type__c = 'Credit Card';
        paymentPlanInstallment.invoiceit_s__Payment_Method__c = PM.id;
        paymentPlanInstallment.Min_Down_Payment__c =true;
        paymentPlanInstallment.invoiceit_s__Payment_Amount__c = 50;
        
        insert paymentPlanInstallment;
        
        invoiceit_s__Payment_Plan_Installment__c paymentPlanInstallment1 =  new invoiceit_s__Payment_Plan_Installment__c();
        paymentPlanInstallment1.invoiceit_s__Account__c = account.id;
        paymentPlanInstallment1.invoiceit_s__Payment_Date__c = system.today();
        paymentPlanInstallment1.QTC__Quote__c = cpqQuote.id;
        paymentPlanInstallment1.invoiceit_s__Payment_Type__c = 'Credit Card';
        paymentPlanInstallment1.invoiceit_s__Payment_Method__c = PM.id;
        paymentPlanInstallment1.Min_Down_Payment__c =true;
        paymentPlanInstallment1.invoiceit_s__Payment_Amount__c = 50;
        
        insert paymentPlanInstallment1;
        test.starttest();
            ApexPages.Standardcontroller stdController1 = new Apexpages.Standardcontroller(cpqQuote);
            IIT_createOrder_extension  createOrder= new IIT_createOrder_extension(stdController1);
            
            createOrder.processOrder();
            
            //Create Order class 
            
            /*ApexPages.Standardcontroller stdController11 = new Apexpages.Standardcontroller(cpqQuote);
            IIT_createOrder_extension  createOrder1= new IIT_createOrder_extension(stdController11);
            
            createOrder1.processOrder();*/
            createOrder.processDataToOracle() ;
        test.stoptest();
        
    
    
    }
    static testMethod void createOrder1() {
        IIT_TestClassForUassage.insertCustomSetting();
        list<Invoiceit_s__Configuration__c> objects = new list<Invoiceit_s__Configuration__c>();
        
        Invoiceit_s__Configuration__c c1 =  new Invoiceit_s__Configuration__c(Name = 'PID_last', invoiceit_s__Number_Value__c= 1000); 
         objects.add((Invoiceit_s__Configuration__c) c1);
         
         Invoiceit_s__Configuration__c c2 =  new Invoiceit_s__Configuration__c(Name = 'CID_last', invoiceit_s__Number_Value__c= 1000); 
         objects.add((Invoiceit_s__Configuration__c) c2);
         
         //insert objects;
         
         Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
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
        
        //Account insert
        Account account1 = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account1;
        //IIT_PID_CID_check.noPID_CID_noOFFC_AccID(null,10045,null,account.id);
        
        //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account1.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
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
        
        
        
        //insert Opportunity 
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = account1.id;
        opp1.CloseDate = System.today();
        opp1.StageName = 'Validation';
        opp1.Name = 'Opportunity Test';
        opp1.ForecastCategoryName = 'Medium Probability';
        opp1.Product__c = 'ATX';
        insert opp1;    
        
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote1 = new SBQQ__Quote__c();
        cpqQuote1.SBQQ__Account__c = account1.id;
        cpqQuote1.SBQQ__Opportunity2__c = opp1.id;
        cpqQuote1.SBQQ__Status__c = 'Draft';
        cpqQuote1.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote1.SBQQ__Type__c = 'Quote';
        cpqQuote1.SBQQ__StartDate__c = System.today();
        cpqQuote1.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote1;
        
        //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = cpqQuote1.id;
        cpqQuoteLine.SBQQ__Product__c= prod.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine;
             
        //Insert Payment Method
        invoiceit_s__Payment_Method__c PM = new invoiceit_s__Payment_Method__c();
        PM.invoiceit_s__Account__c = account1.id;
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
        
         //Insert Payment Method
        invoiceit_s__Payment_Method__c PM1 = new invoiceit_s__Payment_Method__c();
        PM1.invoiceit_s__Account__c = account1.id;
        PM1.invoiceit_s__Active__c = true;
        
        PM1.invoiceit_s__Billing_Address__c = 'Bangalore';
        PM1.invoiceit_s__Billing_Country__c = 'US';
        PM1.invoiceit_s__Billing_Email__c = 'test@gmail.com';
        PM1.invoiceit_s__Billing_First_Name__c= 'Invoice';
        PM1.invoiceit_s__Billing_Last_Name__c = 'IT';
        PM1.invoiceit_s__Billing_State_Province__c= 'CA';
        PM1.invoiceit_s__Billing_Zip_Postal__c= '56009';
        PM1.invoiceit_s__Card_Expiration_Month__c  = '11';
        PM1.invoiceit_s__Card_Expiration_Year__c= '2019';
        PM1.invoiceit_s__Card_Number__c= '4111111111111111';
        PM1.invoiceit_s__Card_Type__c= 'Visa';
        PM1.invoiceit_s__Name_on_Card__c='Naveen';
        PM1.invoiceit_s__Payment_Method__c = 'Credit Card';
        
        insert PM1;
        
        //Insert Pyament plan
        invoiceit_s__Payment_Plan__c paymentPlan = new invoiceit_s__Payment_Plan__c();
        paymentPlan.Name = 'Bill Later Payment Plan';
        //paymentPlan.invoiceit_s__Down_Payment__c = 5;
        paymentPlan.invoiceit_s__Down_Payment_Amount__c =6;
        paymentPlan.Down_Payment_Criteria__c ='Sales Tax;Down Payment Amount';
        paymentPlan.Payment_Methods__c = 'Credit Card;COA;ACH';
        paymentPlan.invoiceit_s__Minimum_Installments__c = 2;
        paymentPlan.invoiceit_s__Maximum_Installments__c =6;
        paymentPlan.Payments_Date_Range__c= system.today();
        paymentPlan.End_Date__c = system.today().addYears(2);
        paymentPlan.Max_Number_of_Payment_Methods__c = 3;
        //paymentPlan.invoiceit_s__Account__c = account1.id;
        Insert paymentPlan;
        
        //Insert Pyament plan
        invoiceit_s__Payment_Plan__c paymentPlan1 = new invoiceit_s__Payment_Plan__c();
        paymentPlan1.Name = 'Test PaymentPlan';
        //paymentPlan1.invoiceit_s__Down_Payment__c = 5;
        paymentPlan1.invoiceit_s__Down_Payment_Amount__c =6;
        paymentPlan1.Down_Payment_Criteria__c ='Sales Tax;Down Payment Amount';
        paymentPlan1.Payment_Methods__c = 'Credit Card;COA;ACH';
        paymentPlan1.invoiceit_s__Minimum_Installments__c = 2;
        paymentPlan1.invoiceit_s__Maximum_Installments__c =6;
        //paymentPlan1.Payments_Date_Range__c= system.today();
        paymentPlan1.End_Date__c = system.today().addYears(-1);
        paymentPlan1.Max_Number_of_Payment_Methods__c = 3;
        //paymentPlan.invoiceit_s__Account__c = account1.id;
        Insert paymentPlan1;
        
         invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD',invoiceit_s__Symbol__c = '$');      
        insert currency1;
        
        cpqQuote1.QTC__Payment_Plan__c= paymentPlan.id;
        cpqQuote1.Tax_Time_Stamp__c =  system.now().addHours(-2);
        cpqQuote1.Tax_Grand_Total__c = 100;
        update cpqQuote1;
        
        
           // opp.QTC__Create_Order__c = true;
            
          //  update opp;
           
        //insert payment paln installment 
        invoiceit_s__Payment_Plan_Installment__c paymentPlanInstallment =  new invoiceit_s__Payment_Plan_Installment__c();
        paymentPlanInstallment.invoiceit_s__Account__c = account1.id;
        paymentPlanInstallment.invoiceit_s__Payment_Date__c = system.today();
        paymentPlanInstallment.QTC__Quote__c = cpqQuote1.id;
        paymentPlanInstallment.invoiceit_s__Payment_Type__c = 'COA';
        //paymentPlanInstallment.invoiceit_s__Payment_Method__c = PM.id;
        paymentPlanInstallment.Min_Down_Payment__c =true;
        paymentPlanInstallment.invoiceit_s__Payment_Amount__c = 50;
        
        insert paymentPlanInstallment;
        
        invoiceit_s__Payment_Plan_Installment__c paymentPlanInstallment1 =  new invoiceit_s__Payment_Plan_Installment__c();
        paymentPlanInstallment1.invoiceit_s__Account__c = account1.id;
        paymentPlanInstallment1.invoiceit_s__Payment_Date__c = system.today();
        paymentPlanInstallment1.QTC__Quote__c = cpqQuote1.id;
        paymentPlanInstallment1.invoiceit_s__Payment_Type__c = 'Credit Card';
        paymentPlanInstallment1.invoiceit_s__Payment_Method__c = PM.id;
        paymentPlanInstallment1.Min_Down_Payment__c =true;
        paymentPlanInstallment1.invoiceit_s__Payment_Amount__c = 50;
        insert paymentPlanInstallment1;
        
        cpqQuote1.Tax__c=10;
        cpqQuote1.SBQQ__Primary__c=true;
        cpqQuote1.Tax_Time_Stamp__c = system.now();
        cpqQuote1.Tax_Grand_Total__c = 100;
        update cpqQuote1;
        
        invoiceit_s__Payment__c payment = new invoiceit_s__Payment__c();
        payment.invoiceit_s__Account__c =account1.id;
        payment.invoiceit_s__Amount__c =1000;
        payment.invoiceit_s__Currency__c = currency1.Id;
        payment.invoiceit_s__Payment_Date__c = system.today();
        payment.invoiceit_s__Payment_Type__c = 'Cash';
        payment.invoiceit_s__Status__c = 'Completed';
        insert payment;
        
        test.starttest();  
            ApexPages.Standardcontroller stdController1 = new Apexpages.Standardcontroller(cpqQuote1);
            IIT_createOrder_extension  createOrder= new IIT_createOrder_extension(stdController1);
            createOrder.processOrder();
        test.stoptest();
        
    }
    
}