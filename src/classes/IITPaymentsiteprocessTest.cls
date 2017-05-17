@isTest
public with sharing class IITPaymentsiteprocessTest{
 static testMethod void InsertingSpeedTaxInvoice() {
         IIT_TestClassForUassage.insertCustomSetting();
        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD',invoiceit_s__Symbol__c = '$');      
        insert currency1;
        
        Product2 prod = new Product2();
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
        insert priceBookEtry;
        
        Account account = new Account(Cutoff__c = true,Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__c = '10045',PID__c = '10084');
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
        
        //Speed tax 
        
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
                    invoiceit_s__CurrencyL__c = currency1.Id,invoiceit_s__Invoice_Status__c = 'POSTED',invoiceit_s__Order__c = job.Id, invoiceit_s__Target_Date__c = Date.today());
                
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
            payment.invoiceit_s__Payment_Date__c = system.today();
            payment.invoiceit_s__Payment_Type__c = 'Cash';
            payment.invoiceit_s__Status__c = 'Completed';
           
            insert payment;
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
            
            invoiceit_s__Batch_Jobs__c invbatch = new invoiceit_s__Batch_Jobs__c();
            invbatch.Amount__c = 1000;
            invbatch.Card_Type__c = 'Master';
            invbatch.Gateway_Date__c = Date.today();
            invbatch.Exception_Message__c = 'Test Exception';
            invbatch.invoiceit_s__Exception_Log__c = 'Test Exception Log';
            invbatch.invoiceit_s__Start_Date_and_Time__c = system.now();
            invbatch.Invoice__c = invoice.ID;
            invbatch.Status__c = 'pending';
            invbatch.Payment_Method__c = PM.ID;
            invbatch.Payment_GatewayID__c = gateway.ID;
            insert invbatch;
            
            invoiceit_s__Transaction__c trans = new invoiceit_s__Transaction__c();
            trans.invoiceit_s__Payment_Method__c =PM.ID ;
            trans.invoiceit_s__Payment_Gateway__c= gateway.ID;
            trans.invoiceit_s__Response_Status__c = 'Approved';
            insert trans;
            
            
            
            IIT_CIDConnector.getCustomerBalance('10045');
            
            IIT_PID_CID_check.PID_noCID_noOFFC_AccID(10084, null, null,account.id);
            
            IIT_PID_CID_check.noPID_CID_noOFFC_AccID(10084,null,1,account.id);
            IIT_PID_CID_check.PID_CID_OFFC_AccID(10084,10045,1,account.id);
            IIT_PID_CID_check.PID_CID_newOFFC_AccID(10084,10045,2,account.id);
            
            IIT_SpeedTaxConnector.calculateTaxForInvoice(invoice.id,'Posted');
            IIT_SpeedTaxConnector.postInvoiceTax(invoice.id,'Posted');
            //IIT_SpeedTaxConnector.voidTax(invoice.id);
            Test.StartTest();
            system.currentPageReference().getParameters().put('Id', account.id);
            
            IIT_ControllerPaymentSiteProcess  site = new IIT_ControllerPaymentSiteProcess ();
            site.processPayment();
            //site.currentpageReference.getParameters().put(invoice.ID); 
            site.selectedValue = PM.id;
            for(IIT_ControllerPaymentSiteProcess.InvoiceWrapperClass invoiceWrapperClassLocal :site.listOfInvoiceWrapperClass){
                invoiceWrapperClassLocal.isSelected = true;
                break;
            }
            site.processPayment();
            //site.createPM();
            //site.returnPageURL();
            site.updatePM();
            site.openinvc();
            system.currentPageReference().getParameters().put('Payment',invoice.ID);
            site.PaymentAllocation();
            
            //site.createCCPM();
            
                 IIT_BatchCalculateTaxOnInv batch = new IIT_BatchCalculateTaxOnInv();
                 ID batchprocessid = Database.executeBatch(batch, 1);
                
            Test.StopTest(); 
            
     
     }
     
     static testMethod void InsertingSpeedTaxInvoice2() {
         IIT_TestClassForUassage.insertCustomSetting();
        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD',invoiceit_s__Symbol__c = '$');      
        insert currency1;
        
        Product2 prod = new Product2();
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
        
        //Speed tax 
        
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
                    invoiceit_s__CurrencyL__c = currency1.Id,invoiceit_s__Invoice_Status__c = 'NULL',invoiceit_s__Order__c = job.Id, invoiceit_s__Target_Date__c = Date.today());
                
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
            payment.invoiceit_s__Payment_Date__c = system.today();
            payment.invoiceit_s__Payment_Type__c = 'Cash';
            payment.invoiceit_s__Status__c = 'Completed';
           
            insert payment;
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
            
            /*invoiceit_s__Batch_Jobs__c invbatch = new invoiceit_s__Batch_Jobs__c();
            invbatch.Amount__c = 1000;
            invbatch.Card_Type__c = 'Master';
            invbatch.Gateway_Date__c = Date.today();
            invbatch.Exception_Message__c = 'Test Exception';
            invbatch.invoiceit_s__Exception_Log__c = 'Test Exception Log';
            invbatch.invoiceit_s__Start_Date_and_Time__c = system.now();
            invbatch.Invoice__c = invoice.ID;
            invbatch.Status__c = 'pending';
            invbatch.Payment_Method__c = PM.ID;
            invbatch.Payment_GatewayID__c = gateway.ID;
            insert invbatch;
            
            invoiceit_s__Transaction__c trans = new invoiceit_s__Transaction__c();
            trans.invoiceit_s__Payment_Method__c =PM.ID ;
            trans.invoiceit_s__Payment_Gateway__c= gateway.ID;
            trans.invoiceit_s__Response_Status__c = 'Approved';
            insert trans;*/
        
            
            IIT_CIDConnector.getCustomerBalance('10045');
            
            IIT_PID_CID_check.PID_noCID_noOFFC_AccID(10084, null, null,account.id);
            
            IIT_PID_CID_check.noPID_CID_noOFFC_AccID(10084,null,1,account.id);
            IIT_PID_CID_check.PID_CID_OFFC_AccID(10084,10045,1,account.id);
            IIT_PID_CID_check.PID_CID_newOFFC_AccID(10084,10045,2,account.id);
            
            IIT_SpeedTaxConnector.calculateTaxForInvoice(invoice.id,'Posted');
            IIT_SpeedTaxConnector.postInvoiceTax(invoice.id,'Posted');
            //IIT_SpeedTaxConnector.voidTax(invoice.id);
            Test.StartTest();
            system.currentPageReference().getParameters().put('Id', account.id);
            
            IIT_ControllerPaymentSiteProcess  site = new IIT_ControllerPaymentSiteProcess ();
            
            site.selectedValue = null;
            
            for(IIT_ControllerPaymentSiteProcess.InvoiceWrapperClass invoiceWrapperClassLocal :site.listOfInvoiceWrapperClass){
                invoiceWrapperClassLocal.isSelected = false;
                
                break;
            }
            //Site.ischeck=true;
            site.processPayment();
            
            
                
            Test.StopTest(); 
            
     
     }
     }