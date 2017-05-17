@isTest
public with sharing class IIT_TestControllerProcessBatchJobs{

    static testMethod void test_SAPProcess(){
        
        IIT_TestClassForUassage.insertCustomSetting();
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
        
         invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD',invoiceit_s__Symbol__c = '$');      
         insert currency1;
             
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
             
         invoiceit_s__Revenue_Recognition_Rule__c revenuerules = new invoiceit_s__Revenue_Recognition_Rule__c ();
         revenuerules.invoiceit_s__Recognition_Date__c = 'Service Activation Date';
         revenuerules.invoiceit_s__Recognition_Type__c ='Monthly Recognition Over Time';
         insert revenuerules;
            
            /*invoiceit_s__Revenue_Period__c revenueperiod =  new invoiceit_s__Revenue_Period__c();
            revenueperiod.invoiceit_s__Revenue_Period_End_Date__c = system.today().addmonths(1);
            revenueperiod.invoiceit_s__Revenue_Period_Start_Date__c = system.today();
            insert revenueperiod;*/
            
         list<invoiceit_s__Revenue_Period__c> revenuePeriods = new list<invoiceit_s__Revenue_Period__c>();
         invoiceit_s__Revenue_Period__c revenuePeriod;
         Date myDateTime; 
         map<integer, string> mapDate = new map<integer, string>();
         mapDate.put(1, 'January');
         mapDate.put(2, 'February');
         mapDate.put(3, 'March');
         mapDate.put(4, 'April');
         mapDate.put(5, 'May');
         mapDate.put(6, 'June');
         mapDate.put(7, 'July');
         mapDate.put(8, 'August');
         mapDate.put(9, 'September');
         mapDate.put(10, 'October');
         mapDate.put(11, 'November');
         mapDate.put(12, 'December');

         // for 2016 revenue periods
         for(integer i=1; i<=12; i++) {
            myDateTime = Date.newInstance(2016, i, 1);    
            revenuePeriod = new  invoiceit_s__Revenue_Period__c(invoiceit_s__Revenue_Period_Start_Date__c = myDateTime);
            revenuePeriod.invoiceit_s__Revenue_Period_End_Date__c = myDateTime.addMonths(1);
            revenuePeriod.invoiceit_s__Revenue_Period_End_Date__c = revenuePeriod.invoiceit_s__Revenue_Period_End_Date__c.addDays(-1);
            revenuePeriod.Name = mapDate.get(i) + '-' + string.valueOf(myDateTime.year());
            revenuePeriods.add(revenuePeriod);

            system.debug(revenuePeriod);
         }
         
         // for 2017 revenue periods
         for(integer i=1; i<=12; i++) {
            myDateTime = Date.newInstance(2017, i, 1);    
            revenuePeriod = new  invoiceit_s__Revenue_Period__c(invoiceit_s__Revenue_Period_Start_Date__c = myDateTime);
            revenuePeriod.invoiceit_s__Revenue_Period_End_Date__c = myDateTime.addMonths(1);
            revenuePeriod.invoiceit_s__Revenue_Period_End_Date__c = revenuePeriod.invoiceit_s__Revenue_Period_End_Date__c.addDays(-1);
            revenuePeriod.Name = mapDate.get(i) + '-' + string.valueOf(myDateTime.year());
            revenuePeriods.add(revenuePeriod);

            system.debug(revenuePeriod);
         }
         insert revenuePeriods;
           invoiceit_s__Revenue_Period__c revPeriods = new invoiceit_s__Revenue_Period__c(invoiceit_s__Revenue_Period_Start_Date__c = system.today().adddays(4),invoiceit_s__Revenue_Period_End_Date__c = system.today().addMonths(1));
           insert revPeriods ; 
            
            invoiceit_s__Invoice__c invoice = new invoiceit_s__Invoice__c(invoiceit_s__Account__c = account.id,invoiceit_s__Billing_Contact__c = cont.Id,invoiceit_s__Shipping_Contact__c = cont.Id,
            invoiceit_s__CurrencyL__c = currency1.Id,invoiceit_s__Invoice_Status__c = 'POSTED',invoiceit_s__Order__c = job.Id, invoiceit_s__Target_Date__c = Date.today(),invoiceit_s__Invoice_Date__c = system.today().adddays(4),invoiceit_s__Due_Date__c =system.today().addMonths(1));
                
            insert invoice;
            list<invoiceit_s__Invoice_Lines__c> listInvoiceLines = new list<invoiceit_s__Invoice_Lines__c>();
            listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id,invoiceit_s__Status__c='Active',invoiceit_s__Job_Rate_Plan_Charge__c = charge.ID,invoiceit_s__Line_Name__c = 'Broadband Installation For L',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__Line_Amount__c = 40,invoiceit_s__Job__c = job.Id, invoiceit_s__Product_Name__c = 'EFile Fee',invoiceit_s__Revenue_Recognition_Rule__c=revenuerules.id,invoiceit_s__Price_Type__c  = 'One Time'));
            listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id,invoiceit_s__Status__c='POSTED',invoiceit_s__Job_Rate_Plan_Charge__c = charge1.ID,invoiceit_s__Line_Name__c = 'Broadband Installation For X',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__Line_Amount__c = 40,invoiceit_s__Job__c = job.Id ,invoiceit_s__Product_Name__c = 'EFile Fee',invoiceit_s__Revenue_Recognition_Rule__c=revenuerules.id));
            listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id,invoiceit_s__Status__c='POSTED',invoiceit_s__Job_Rate_Plan_Charge__c = charge2.ID,invoiceit_s__Line_Name__c = 'Broadband Installation For M',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__Line_Amount__c = 40,invoiceit_s__Job__c = job.Id ,invoiceit_s__Product_Name__c = 'EFile Fee',invoiceit_s__Revenue_Recognition_Rule__c=revenuerules.id));
            insert listInvoiceLines;
                  
            invoiceit_s__Credit_Note__c creditnote=new invoiceit_s__Credit_Note__c(invoiceit_s__Account__c=account.id,invoiceit_s__Billing_Contact__c=cont.id,invoiceit_s__Credit_Note_Date__c=system.today(),invoiceit_s__Credit_Note_Status__c='Posted',invoiceit_s__CurrencyL__c=currency1.id,invoiceit_s__Order__c=job.id,invoiceit_s__Related_Invoice__c=invoice.id);
            insert creditnote;
   
            invoiceit_s__Credit_Line__c creditline=new invoiceit_s__Credit_Line__c(invoiceit_s__Calculated_Quantity__c=10,invoiceit_s__Charge_Start_Date__c=system.today(),invoiceit_s__Charge_End_Date__c=system.today()+30,invoiceit_s__Credit_Note__c=creditnote.id,invoiceit_s__CurrencyL__c=currency1.id,invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Invoice_Line__c=listInvoiceLines.get(0).id,invoiceit_s__Order__c=job.id,invoiceit_s__Order_Rate_Plan_Charge__c=charge.id,invoiceit_s__Quantity__c=10,invoiceit_s__Line_Amount__c=100, invoiceit_s__Credit_Type_Applied__c = 'Date');
            insert creditline;
            listInvoiceLines[0].invoiceit_s__Status__c = 'Cancelled';
            update listInvoiceLines[0];
            
            list<invoiceit_s__Revenue_Transaction__c> rts = new list<invoiceit_s__Revenue_Transaction__c>();
            
            for(integer i = 0; i <24; i++) {
                // for invoice lines
                invoiceit_s__Revenue_Transaction__c revTrans = new invoiceit_s__Revenue_Transaction__c();
                revTrans.invoiceit_s__Account__c = account.id;
                revTrans.invoiceit_s__Applied_Revenue_Recognition_Rule__c = revenuerules.id; 
                revTrans.invoiceit_s__CurrencyL__c = currency1.Id;
                revTrans.invoiceit_s__Invoice__c = invoice.id;
                revTrans.invoiceit_s__Invoice_Line__c = listInvoiceLines[0].id;
                //revTrans.invoiceit_s__Revenue_Period__c = revenuePeriods[i].Id;
                revTrans.invoiceit_s__Revenue_Period__c = revPeriods.id;
                revTrans.invoiceit_s__Revenue_Amount__c = 10;
                revTrans.invoiceit_s__Deferred_Balance__c = 10;
                rts.add(revTrans);
                
                // for credit lines
                revTrans = new invoiceit_s__Revenue_Transaction__c();
                revTrans.invoiceit_s__Account__c = account.id;
                revTrans.invoiceit_s__Applied_Revenue_Recognition_Rule__c = revenuerules.id; 
                revTrans.invoiceit_s__CurrencyL__c = currency1.Id;
                revTrans.invoiceit_s__Invoice__c = invoice.id;
                revTrans.invoiceit_s__Invoice_Line__c = listInvoiceLines[0].id;
                //revTrans.invoiceit_s__Revenue_Period__c = revenuePeriods[i].Id;
                revTrans.invoiceit_s__Revenue_Period__c = revPeriods.id;
                revTrans.invoiceit_s__Revenue_Amount__c = 10;
                revTrans.invoiceit_s__Deferred_Balance__c = 10;
                revTrans.invoiceit_s__Credit_Line__c = creditLine.Id;
                revTrans.invoiceit_s__Credit_Note__c = creditnote.Id;
                rts.add(revTrans);
            }
            insert rts;
            invoiceit_s__Refund__c refund = new invoiceit_s__Refund__c(invoiceit_s__Refund_Date__c = system.today(),invoiceit_s__Account__c = account.id ,invoiceit_s__Currency__c = currency1.id  , invoiceit_s__Status__c = 'Approved',Document_Type__c = 'Refund',SAP_Status__c = 'Processed');
            insert refund;
            invoiceit_s__Payment__c payment = new invoiceit_s__Payment__c();
            payment.invoiceit_s__Account__c =account.id;
            payment.invoiceit_s__Amount__c =1000;
            payment.invoiceit_s__Currency__c = currency1.Id;
            payment.invoiceit_s__Payment_Date__c = system.today();
            payment.invoiceit_s__Payment_Type__c = 'Credit Card';
            payment.invoiceit_s__Status__c = 'Completed';
            payment.SAP_Status__c = 'Processing';
            insert payment;
            list<SAP_Integration__c> listOfSAPIntegration = new list<SAP_Integration__c>();
            listOfSAPIntegration.add(new SAP_Integration__c(Status__c = 'Processed', Document_Type__c = 'Sales Invoices',SAP_Processed_Date__c=system.today()));
            listOfSAPIntegration.add(new SAP_Integration__c(Status__c = 'Processed', Document_Type__c = 'Monthly Deferred Revenue Posting',SAP_Processed_Date__c=system.today()));
            
            insert listOfSAPIntegration; 
            IIT_ControllerProcessBatchJobs sapprocess = new IIT_ControllerProcessBatchJobs();
            sapprocess.invoiceObj.invoiceit_s__Invoice_Date__c = system.today();
            sapprocess.invoiceObjForRevRef.invoiceit_s__Invoice_Date__c = system.today();
            sapprocess.invoiceObjForRevRef.invoiceit_s__Due_Date__c = system.today();
            sapprocess.invoiceObjRebates.invoiceit_s__Invoice_Date__c = system.today();
            sapprocess.invoiceObjPayments.invoiceit_s__Invoice_Date__c = system.today();
            sapprocess.redirectInvoiceReport();
            sapprocess.redirectInvoiceRevRecReport();
            sapprocess.redirectRebatesReport();
            sapprocess.redirectPaymentsReport();
            sapprocess.processInvoiceToSAP();
            sapprocess.processRevenueRecToSAP();
            sapprocess.UpdateSAPInvoices();
            sapprocess.UpdateSAPRevenueRec();
            sapprocess.UpdateSAPRebates();
            sapprocess.UpdateSAPPayments();
        
    }
    static testMethod void test_SAPProcess12(){
        IIT_ControllerProcessBatchJobs sapprocess = new IIT_ControllerProcessBatchJobs();
        sapprocess.redirectInvoiceReport();
        sapprocess.redirectInvoiceRevRecReport();
        sapprocess.redirectRebatesReport();
        sapprocess.redirectPaymentsReport();
        sapprocess.processInvoiceToSAP();
        sapprocess.processRevenueRecToSAP();
        sapprocess.UpdateSAPInvoices();
        sapprocess.UpdateSAPRevenueRec();
        sapprocess.UpdateSAPRebates();
        sapprocess.UpdateSAPPayments();
    }
}