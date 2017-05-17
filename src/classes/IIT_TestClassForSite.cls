@isTest
public with sharing class IIT_TestClassForSite{
    static testMethod void InsertingSite() {
       IIT_TestClassForUassage.insertCustomSetting();
        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD',invoiceit_s__Symbol__c = '$');      
        insert currency1;
        
       /* Product2 prod = new Product2();
        prod.Name = 'EFile Fee';
         prod.ProductCode = '2016EFILEFEE';
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
        insert priceBookEtry;*/
        
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
        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = account.id,invoiceit_s__Status__c = 'Draft', invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
             insert job;
              invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(Name = 'jobProduct',invoiceit_s__Job__c = job.Id,invoiceit_s__Product_Code__c = '2016EFILEFEE');
             insert jobProduct;

             invoiceit_s__Job_Rate_Plan__c jobRP = new invoiceit_s__Job_Rate_Plan__c(Name = 'JobRP',invoiceit_s__Job_Product__c =jobProduct.Id);
             insert jobRP;

             invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(Name = 'jobRPC',invoiceit_s__Job_Rate_Plan__c =jobRP.Id,invoiceit_s__Status__c='Draft',invoiceit_s__Quantity__c = 12,invoiceit_s__Price_Type__c = 'Monthly',invoiceit_s__Accounting_Code__c = '12345',invoiceit_s__Unit_Price__c = 12);
             insert charge;
             invoiceit_s__Job_Rate_Plan_Charge__c charge1 = new invoiceit_s__Job_Rate_Plan_Charge__c(Name = 'jobRPC',invoiceit_s__Service_Activation_Date__c = system.TODAY(),invoiceit_s__Service_End_Date__c=system.TODAY().addMonths(4),invoiceit_s__Job_Rate_Plan__c =jobRP.Id,invoiceit_s__Status__c='Draft',invoiceit_s__Quantity__c = 12,invoiceit_s__Price_Type__c = 'Usage',Free_EFiles__c  =5454,invoiceit_s__Accounting_Code__c = '12345',invoiceit_s__Unit_Price__c = 12);
             insert charge1;
             invoiceit_s__Job_Rate_Plan_Charge__c charge2 = new invoiceit_s__Job_Rate_Plan_Charge__c(Name = 'jobRPC',invoiceit_s__Next_Charge_Date__c = system.TODAY(),invoiceit_s__Service_End_Date__c=system.TODAY().addMonths(4),invoiceit_s__Job_Rate_Plan__c =jobRP.Id,invoiceit_s__Status__c='Draft',invoiceit_s__Quantity__c = 12,invoiceit_s__Price_Type__c ='OneTime',invoiceit_s__Accounting_Code__c = '12345',invoiceit_s__Unit_Price__c = 12);
             insert charge2;
             
             invoiceit_s__Invoice__c invoice = new invoiceit_s__Invoice__c(invoiceit_s__Account__c = account.id,invoiceit_s__Billing_Contact__c = cont.Id,invoiceit_s__Shipping_Contact__c = cont.Id,
                    invoiceit_s__CurrencyL__c = currency1.Id,invoiceit_s__Invoice_Status__c = 'POSTED',invoiceit_s__Order__c = job.Id, invoiceit_s__Target_Date__c = Date.today(),invoiceit_s__Invoice_Date__c = system.today().adddays(4));
                
            insert invoice;
            list<invoiceit_s__Invoice_Lines__c> listInvoiceLines = new list<invoiceit_s__Invoice_Lines__c>();
            listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id,invoiceit_s__Status__c='POSTED',invoiceit_s__Job_Rate_Plan_Charge__c = charge.ID,invoiceit_s__Line_Name__c = 'Broadband Installation For L',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__Line_Amount__c = 40,invoiceit_s__Job__c = job.Id, invoiceit_s__Product_Name__c = 'EFile Fee'));
            listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id,invoiceit_s__Status__c='POSTED',invoiceit_s__Job_Rate_Plan_Charge__c = charge1.ID,invoiceit_s__Line_Name__c = 'Broadband Installation For X',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__Line_Amount__c = 40,invoiceit_s__Job__c = job.Id ,invoiceit_s__Product_Name__c = 'EFile Fee'));
            listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id,invoiceit_s__Status__c='POSTED',invoiceit_s__Job_Rate_Plan_Charge__c = charge2.ID,invoiceit_s__Line_Name__c = 'Broadband Installation For M',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__Line_Amount__c = 40,invoiceit_s__Job__c = job.Id ,invoiceit_s__Product_Name__c = 'EFile Fee'));
            insert listInvoiceLines;
            
            invoice.Create_Credit_payment__c = true;
            
            update invoice;
            
            invoiceit_s__Payment__c payment = new invoiceit_s__Payment__c();
            payment.invoiceit_s__Account__c =account.id;
            payment.invoiceit_s__Amount__c =1000;
            payment.invoiceit_s__Currency__c = currency1.Id;
            payment.invoiceit_s__Payment_Date__c = system.today().adddays(4);
            payment.invoiceit_s__Payment_Type__c = 'Cash';
            payment.invoiceit_s__Status__c = 'Completed';
            
            insert payment;
            invoiceit_s__Credit_Note__c creditnote=new invoiceit_s__Credit_Note__c(invoiceit_s__Account__c=account.id,invoiceit_s__Billing_Contact__c=cont.id,invoiceit_s__Credit_Note_Date__c=system.today().addDays(4),invoiceit_s__Credit_Note_Status__c='Posted',invoiceit_s__CurrencyL__c=currency1.id,invoiceit_s__Order__c=job.id,invoiceit_s__Related_Invoice__c=invoice.id);
             insert creditnote;
   
         invoiceit_s__Credit_Line__c creditline=new invoiceit_s__Credit_Line__c(invoiceit_s__Calculated_Quantity__c=10,invoiceit_s__Charge_Start_Date__c=system.today(),invoiceit_s__Charge_End_Date__c=system.today()+30,invoiceit_s__Credit_Note__c=creditnote.id,invoiceit_s__CurrencyL__c=currency1.id,invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Invoice_Line__c=listInvoiceLines.get(0).id,invoiceit_s__Order__c=job.id,invoiceit_s__Order_Rate_Plan_Charge__c=charge.id,invoiceit_s__Quantity__c=10,invoiceit_s__Line_Amount__c=100, invoiceit_s__Credit_Type_Applied__c = 'Date');
             insert creditline;
             
             invoiceit_s__Refund__c refund = new invoiceit_s__Refund__c(invoiceit_s__Account__c = account.id,invoiceit_s__Currency__c = currency1.id,invoiceit_s__Refund_Date__c = date.today().adddays(4),invoiceit_s__Refund_Description__c = 'Test');
             insert refund;
             test.starttest();
                IIT_Batch_CreateARSnapShotForAccount newBatch= new IIT_Batch_CreateARSnapShotForAccount();
                ID batchprocessidwe = Database.executeBatch(newBatch, 1);
             test.stoptest();
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
            
            AR_Snapshot__c ar = new AR_Snapshot__c();
            ar.name = 'test';
            ar.Account__c = account.id;
            ar.Process_Date__c   = system.today();
            ar.Account_Outstanding_Balance__c    = 10;
            insert ar ;
            system.currentPageReference().getParameters().put('Id', account.id);
            system.currentPageReference().getParameters().put('redirectURL', null);
            system.currentPageReference().getParameters().put('makede', PM.id);
            system.currentPageReference().getParameters().put('updateT', PM.id);
            IIT_ControllerPaymentMethodDisplay paymentMe = new IIT_ControllerPaymentMethodDisplay();
            paymentMe.generateToken();
            paymentMe.makeDefault();
            paymentMe.updateToken();
            paymentMe.updateButton();
            paymentMe.GenerateTokenPM();
            paymentMe.CancelButton();
            paymentMe.createACH();
        date startDate = system.today().addDays(-2);
        date sendDate  =  system.today().addDays(10); 
        string sstartDate = startDate.month() + '/' + startDate.day() + '/' +startDate.year();
        string ssendDate = sendDate.month() + '/' + sendDate.day() + '/' +sendDate.year();   
        IIT_CustomerStatements.generateStatementByDatesJS((String)account.id , sstartDate, ssendDate);
            
    }
    
}