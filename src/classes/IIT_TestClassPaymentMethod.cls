@isTest
public with sharing class IIT_TestClassPaymentMethod{

    static testMethod void paymentMethod(){
         IIT_TestClassForUassage.insertCustomSetting();
        test.starttest();
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
        
        system.currentPageReference().getParameters().put('Id', account.id);
        system.currentPageReference().getParameters().put('pmid', PM.id);
        system.currentPageReference().getParameters().put('pm', PM.invoiceit_s__Payment_Method__c );
        
        /*IIT_CreditCardTokenGenerate token = new IIT_CreditCardTokenGenerate();
        token.GenerateTokenPM();
        token.CancelButton();*/
        system.currentPageReference().getParameters().put('aid', PM.invoiceit_s__Account__c);
        ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(PM);
        IIT_CreditCardPaymentMethod creditcard = new IIT_CreditCardPaymentMethod(stdController);
        creditcard.saveCC();
        creditcard.cancelQuote();
        system.currentPageReference().getParameters().put('aid', PM.invoiceit_s__Account__c);
        ApexPages.Standardcontroller stdController1 = new Apexpages.Standardcontroller(PM);
        IIT_createPaymentMethod achPM = new IIT_createPaymentMethod(stdController1);
        achPM.save();
        achPM.cancelPaymentOption();
        
        IIT_RunSchedulerTaxCalPosted sh1 = new IIT_RunSchedulerTaxCalPosted();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        
        test.stoptest();
    }
}