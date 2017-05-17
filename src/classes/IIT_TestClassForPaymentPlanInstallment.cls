@isTest(seealldata=false)
public with sharing class IIT_TestClassForPaymentPlanInstallment{
     
    static testMethod void InsertingPPI() {
         IIT_TestClassForUassage.insertCustomSetting();
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
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__c = '10045',PID__c = '10084');
        insert account;
        IIT_PID_CID_check.PID_CID_newOFFC_AccID(10084,10045,2,account.id);
        
        //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'nmallela@steelbricl.com';
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
        
        //Insert Payment Method
        invoiceit_s__Payment_Method__c PM = new invoiceit_s__Payment_Method__c();
        PM.invoiceit_s__Account__c = account.id;
        PM.invoiceit_s__Active__c = true;
        PM.invoiceit_s__Default__c= true;
        PM.invoiceit_s__Billing_Address__c = 'Bangalore';
        PM.invoiceit_s__Billing_Country__c = 'US';
        PM.invoiceit_s__Billing_Email__c = 'nmallela@steelbrick.com';
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
        PM1.invoiceit_s__Billing_Email__c = 'nmallela@steelbrick.com';
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
        
        
        ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(cpqQuote);
        IIT_ControllerHandlingForPaymentPlan paymentPalnInstallment = new IIT_ControllerHandlingForPaymentPlan(stdController);   
        paymentPalnInstallment.processpaymentPlanButton();
        paymentPalnInstallment.saveProcesspaymentPlan();
        
        paymentPalnInstallment.addInstallment();
        string  sParamCount = system.currentPageReference().getParameters().put('unWantedInstallmentCount', '1');
        paymentPalnInstallment.removeInstallment();
        paymentPalnInstallment.addErrrorMsg();
        
        
         //insert payment paln installment 
        invoiceit_s__Payment_Plan_Installment__c paymentPlanInstallmentn1 =  new invoiceit_s__Payment_Plan_Installment__c();
        paymentPlanInstallmentn1.invoiceit_s__Account__c = account.id;
        paymentPlanInstallmentn1.invoiceit_s__Payment_Date__c = system.today().addDays(2);
        paymentPlanInstallmentn1.QTC__Quote__c = cpqQuote.id;
        paymentPlanInstallmentn1.invoiceit_s__Payment_Type__c = 'COA';
        //paymentPlanInstallmentn1.invoiceit_s__Payment_Method__c = PM.id;
        paymentPlanInstallmentn1.Min_Down_Payment__c =true;
        paymentPlanInstallmentn1.invoiceit_s__Payment_Amount__c = 500;
        
       // insert paymentPlanInstallmentn1;
        
        invoiceit_s__Payment_Plan_Installment__c paymentPlanInstallmentn11=  new invoiceit_s__Payment_Plan_Installment__c();
        paymentPlanInstallmentn11.invoiceit_s__Account__c = account.id;
        paymentPlanInstallmentn11.invoiceit_s__Payment_Date__c = system.today().addDays(2);
        paymentPlanInstallmentn11.QTC__Quote__c = cpqQuote.id;
        paymentPlanInstallmentn11.invoiceit_s__Payment_Type__c = '--None--';
        //paymentPlanInstallmentn11.invoiceit_s__Payment_Method__c = PM.id;
        paymentPlanInstallmentn11.Min_Down_Payment__c =true;
        paymentPlanInstallmentn11.invoiceit_s__Payment_Amount__c = 50;
        
        for(IIT_ControllerHandlingForPaymentPlan.InstallmentWrapper installmentWrapperobj : paymentPalnInstallment.listOFInstallmentWrapper) {
            installmentWrapperobj.paymetnInstallment.invoiceit_s__Payment_Date__c  = system.today().addDays(2);
            installmentWrapperobj.paymetnInstallment.invoiceit_s__Payment_Type__c = 'COA';
            installmentWrapperobj.paymetnInstallment.Min_Down_Payment__c =true;
            //installmentWrapperobj.paymetnInstallment.invoiceit_s__Payment_Type__c = '--None--';
        }
        
        //insert paymentPlanInstallmentn11;
        paymentPalnInstallment.saveProcesspaymentPlan();
        
        for(IIT_ControllerHandlingForPaymentPlan.InstallmentWrapper installmentWrapperobj : paymentPalnInstallment.listOFInstallmentWrapper) {
            installmentWrapperobj.paymetnInstallment.invoiceit_s__Payment_Date__c  = system.today().addDays(2);
            installmentWrapperobj.paymetnInstallment.invoiceit_s__Payment_Type__c = 'COA';
            installmentWrapperobj.paymetnInstallment.Min_Down_Payment__c =true;
            //installmentWrapperobj.paymetnInstallment.invoiceit_s__Payment_Type__c = '--None--';
        }
        
        //insert paymentPlanInstallmentn11;
        paymentPalnInstallment.saveProcesspaymentPlan();
        
         //IIT_TestClassForUassage.insertCustomSetting();
        //
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote1 = new SBQQ__Quote__c();
        cpqQuote1.SBQQ__Account__c = account.id;
        cpqQuote1.SBQQ__Opportunity2__c = opp.id;
        cpqQuote1.SBQQ__Status__c = 'Draft';
        cpqQuote1.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote1.SBQQ__Type__c = 'Quote';
        cpqQuote1.SBQQ__StartDate__c = System.today();
        cpqQuote1.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote1;
        
        //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine1 =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine1.SBQQ__Quote__c = cpqQuote1.id;
        cpqQuoteLine1.SBQQ__Product__c= prod.id;
        cpqQuoteLine1.SBQQ__Quantity__c = 1;
        cpqQuoteLine1.SBQQ__ListPrice__c = 100;
        cpqQuoteLine1.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine1.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine1;
        
       // cpqQuote1.QTC__Payment_Plan__c= paymentPlan1.id;
        //update cpqQuote1;
        
         for(IIT_ControllerHandlingForPaymentPlan.InstallmentWrapper installmentWrapperobj : paymentPalnInstallment.listOFInstallmentWrapper) {
            installmentWrapperobj.paymetnInstallment.invoiceit_s__Payment_Date__c  = system.today().addDays(2);
            installmentWrapperobj.paymetnInstallment.invoiceit_s__Payment_Type__c = 'COA';
            installmentWrapperobj.paymetnInstallment.Min_Down_Payment__c =true;
            //installmentWrapperobj.paymetnInstallment.invoiceit_s__Payment_Type__c = '--None--';
        }
        
        //insert paymentPlanInstallmentn11;
        paymentPalnInstallment.saveProcesspaymentPlan();
        
        
        //Create Order class 
        cpqQuote.Tax__c=10;
        cpqQuote.SBQQ__Primary__c=true;
        cpqQuote.Tax_Time_Stamp__c =  system.now().addHours(-2);
        update cpqQuote;
        Test.startTest();
        ApexPages.Standardcontroller stdController1 = new Apexpages.Standardcontroller(cpqQuote);
        IIT_createOrder_extension  createOrder= new IIT_createOrder_extension(stdController1);
        
        createOrder.processOrder();
        
        
        ApexPages.Standardcontroller stdController11 = new Apexpages.Standardcontroller(cpqQuote);
        IIT_createOrder_extension  createOrder1= new IIT_createOrder_extension(stdController11);
        
        createOrder1.processOrder();
        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD',invoiceit_s__Symbol__c = '$');
            
            insert currency1;
        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = account.id,QTC__Opportunity__c = opp.id,invoiceit_s__Status__c = 'Draft',invoiceit_s__Billing_Contact__c = cont.Id,invoiceit_s__Shipping_Contact__c = cont.Id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
             insert job;
        //invoiceit_s__Job__c job = [SELECT Id FROM invoiceit_s__Job__c LIMIT 1];
        cpqQuote.QTC__Order__c = job.Id;
        update cpqQuote;
        
        ApexPages.Standardcontroller stdControllerObj = new Apexpages.Standardcontroller(cpqQuote);
        IIT_ControllerHandlingForPaymentPlan paymentPalnInstallment1 = new IIT_ControllerHandlingForPaymentPlan(stdControllerObj );  
        
        paymentPalnInstallment1.saveProcesspaymentPlan();
        Test.stopTest();
    }
    static testMethod void PID_CID_newOFFC_AccID() {
     IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__c = '10045',PID__c = '10084',OFFC__c=1);
        insert account;
        IIT_PID_CID_check.PID_CID_OFFC_AccID(10084,10045,2,account.id);
        IIT_PID_CID_check.output output = new IIT_PID_CID_check.output();
    }
    static testMethod void PID_CID_OFFC_AccID() {
     IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__c = '10045',PID__c = '10084',OFFC__c=1);
        insert account;
        IIT_PID_CID_check.PID_CID_OFFC_AccID(10084,10045,1,account.id);
    }
    static testMethod void noPID_CID_noOFFC_AccID() {
        IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__c = '10045');
        insert account;
        IIT_PID_CID_check.noPID_CID_noOFFC_AccID(null,10045,null,account.id);
    }
    static testMethod void PID_noCID_OFFC_AccID() {
     IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',PID__c = '10084',OFFC__c=-1);
        insert account;
        IIT_PID_CID_check.PID_noCID_OFFC_AccID(10084,null,1,account.id);
    }
    
    static testMethod void PID_noCID_OFFC_AccID1() {
     IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',PID__c = '10084',OFFC__c=1);
        insert account;
        IIT_PID_CID_check.PID_noCID_OFFC_AccID(10084,null,1,account.id);
    }
    
    static testMethod void PID_noCID_noOFFC_AccID(){
     IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',PID__c = '10084');
        insert account;
         PID_GROUP__c pidgroup= new PID_GROUP__c(Account_Record__c = account.id, name= account.Name) ;
         insert pidgroup;
        IIT_PID_CID_check.PID_noCID_noOFFC_AccID(10084,null,null,account.id);
    }
    static testMethod void noPID_noCID_noOFFC_AccID(){
     IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;
        IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(null,null,null,account.id);
    }
    //Nagative cover
    static testMethod void PID_CID_OFFC_AccID_Ngative(){
     IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;
        IIT_PID_CID_check.PID_CID_OFFC_AccID(null,null,null,account.id);
    }
    static testMethod void noPID_CID_noOFFC_AccID_Ngative(){
     IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',PID__c = '10084');
        insert account;
        IIT_PID_CID_check.noPID_CID_noOFFC_AccID(10084,null,null,account.id);
    }
    static testMethod void PID_noCID_OFFC_AccID_Nagative(){
     IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;
        IIT_PID_CID_check.PID_noCID_OFFC_AccID(null,10097,null,account.id);
    
    }
    static testMethod void noPID_noCID_noOFFC_AccID_Nagative(){
     IIT_TestClassForUassage.insertCustomSetting();
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__c = '10045',PID__c = '10084',OFFC__c=1);
        insert account;
        IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(10084,10097,null,account.id);
        IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(null,null,null,account.id);
        IIT_PID_CID_check.PID_noCID_noOFFC_AccID(null,null,null,account.id);
        IIT_PID_CID_check.noPID_CID_noOFFC_AccID(null,null,null,account.id);
        IIT_PID_CID_check.PID_CID_OFFC_AccID(null,null,null,account.id);
        IIT_PID_CID_check.PID_CID_newOFFC_AccID(null,null,null,account.id);
    }
}