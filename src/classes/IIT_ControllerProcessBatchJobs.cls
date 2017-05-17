/*
    Written by Laxman Rao M(Salesforce)
    This page is used to initiate the batch jobs
*/
public with sharing class IIT_ControllerProcessBatchJobs {
      public invoiceit_s__Invoice__c invoiceObj{get;set;}
      public invoiceit_s__Invoice__c invoiceObjForRevRef{get;set;}
      public invoiceit_s__Invoice__c invoiceObjRebates{get;set;}
      public invoiceit_s__Invoice__c invoiceObjPayments{get;set;}

      public string sInvoiceJobName{get;set;}
      public string sRevenueJobName{get;set;}
      
      public id jobID{get;set;}
      public IIT_ControllerProcessBatchJobs(){
         invoiceObj = new invoiceit_s__Invoice__c();
         invoiceObjForRevRef = new invoiceit_s__Invoice__c();
         invoiceObjRebates = new invoiceit_s__Invoice__c();
         invoiceObjPayments = new invoiceit_s__Invoice__c();
      } 
     
     // make a redirect to the SAP Invoices Report
     public PageReference redirectInvoiceReport(){  
         if(invoiceObj.invoiceit_s__Invoice_Date__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Please select the Invoice Date to generate report'));
            return null;   
         }
        
         string invoiceFormattedDate = invoiceObj.invoiceit_s__Invoice_Date__c.month() + '/' + invoiceObj.invoiceit_s__Invoice_Date__c.day() + '/' + invoiceObj.invoiceit_s__Invoice_Date__c.year();
         // UAT Report LINK
         //PageReference newPage = new PageReference('/00O29000000Gfpm?pv0=' + invoiceFormattedDate);
         
         // Prod Report Link
         PageReference newPage = new PageReference('/00OE0000002rpz7?pv0=' + invoiceFormattedDate);
         newPage.setRedirect(true);
         return newPage;   
     } 
     
     // make a redirect to the SAP Revenue Report
     public PageReference redirectInvoiceRevRecReport(){  
         if(invoiceObjForRevRef.invoiceit_s__Invoice_Date__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Please select the Revenue Start Date to generate report'));
            return null;   
         }
         
         string invoiceFormattedDate = invoiceObjForRevRef.invoiceit_s__Invoice_Date__c.month() + '/' + invoiceObjForRevRef.invoiceit_s__Invoice_Date__c.day() + '/' + invoiceObjForRevRef.invoiceit_s__Invoice_Date__c.year();
         // UAT Report LINK
         //PageReference newPage = new PageReference('/00O29000000Gfph?pv0=' + invoiceFormattedDate);
         
         // Prod Report LINK
         PageReference newPage = new PageReference('/00OE0000002rpz1?pv0=' + invoiceFormattedDate);
         newPage.setRedirect(true);
         return newPage;   
     }
     
     // make a redirect to the SAP Rebates/Refunds Report
     public PageReference redirectRebatesReport(){  
         if(invoiceObjRebates.invoiceit_s__Invoice_Date__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Please select the Invoice Date to generate report'));
            return null;   
         }
         
         string invoiceFormattedDate = invoiceObjRebates.invoiceit_s__Invoice_Date__c.month() + '/' + invoiceObjRebates.invoiceit_s__Invoice_Date__c.day() + '/' + invoiceObjRebates.invoiceit_s__Invoice_Date__c.year();
         // UAT Report LINK
         //PageReference newPage = new PageReference('/00O29000000Ghbh?pv0=' + invoiceFormattedDate);
         
         // Prod Report LINK
         PageReference newPage = new PageReference('/00OE0000002rpz8?pv0=' + invoiceFormattedDate);
         newPage.setRedirect(true);
         return newPage;   
     }
     
     // make a redirect to the SAP Payments Report
     public PageReference redirectPaymentsReport(){  
         if(invoiceObjPayments.invoiceit_s__Invoice_Date__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Please select the Payment Date to generate report'));
            return null;   
         }
         
         string invoiceFormattedDate = invoiceObjPayments.invoiceit_s__Invoice_Date__c.month() + '/' + invoiceObjPayments.invoiceit_s__Invoice_Date__c.day() + '/' + invoiceObjPayments.invoiceit_s__Invoice_Date__c.year();
         //UAT Report LINK
         //PageReference newPage = new PageReference('/00O29000000Gj1l?pv0=' + invoiceFormattedDate);
         
         // Prod Report LINK
         PageReference newPage = new PageReference('/00OE0000002rstf?pv0=' + invoiceFormattedDate);
         newPage.setRedirect(true);
         return newPage;   
     }
     
     
     public PageReference processInvoiceToSAP(){  
        if(invoiceObj.invoiceit_s__Invoice_Date__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Please select the Invoice Date to process'));
            return null;   
        }
        
        sInvoiceJobName = '';
        sInvoiceJobName = 'SAP_InvoiceBATCH' + system.now();
        
        // verify is any existing IIT_SAP_InvoiceBATCH1 is running. This is to stop the mutiple process
        list<AsyncApexJob> jobs = [SELECT ApexClass.Name,Id,JobType,MethodName,Status 
                                   FROM AsyncApexJob 
                                   WHERE (ApexClass.Name = 'IIT_SAP_InvoiceBATCH1' OR ApexClass.Name = 'IIT_SAP_CreditNoteBATCH') AND (Status = 'Holding' OR Status = 'Queued' OR Status = 'Preparing' OR Status = 'Processing')];
        if(jobs.size() > 0) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'There is an existing SAP Invoice process running, please wait for some time and try again'));
            return null;    
        }
        
        IIT_SAP_InvoiceBATCH1 IB = new IIT_SAP_InvoiceBATCH1(invoiceObj.invoiceit_s__Invoice_Date__c,sInvoiceJobName);
        Id batchId = Database.executeBatch(IB);
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'Batch process has been initiated'));
            
        return null;        
      }
      
      public PageReference processRevenueRecToSAP(){   

        if(invoiceObjForRevRef.invoiceit_s__Invoice_Date__c == null || invoiceObjForRevRef.invoiceit_s__Due_Date__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Revenue Start and End dates are required to process'));
            return null;   
        }
        
        sRevenueJobName = '';
        sRevenueJobName = 'SAP_MonthlyRevenueBATCH' + system.now();
        
        // verify is any existing IIT_SAP_InvoiceRevBATCH1 is running. This is to stop the mutiple process
        list<AsyncApexJob> jobs = [SELECT ApexClass.Name,Id,JobType,MethodName,Status 
                                   FROM AsyncApexJob 
                                   WHERE ApexClass.Name = 'IIT_SAP_InvoiceRevBATCH1' AND (Status = 'Holding' OR Status = 'Queued' OR Status = 'Preparing' OR Status = 'Processing')];
        if(jobs.size() > 0) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'There is an existing SAP Revenue process running, please wait for some time and try again'));
            return null;    
        }

        IIT_SAP_InvoiceRevBATCH1 IB = new IIT_SAP_InvoiceRevBATCH1(invoiceObjForRevRef.invoiceit_s__Invoice_Date__c, invoiceObjForRevRef.invoiceit_s__Due_Date__c,sRevenueJobName);
        Id batchId = database.executebatch(IB);
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'Batch process has been initiated'));
            
        return null;        
      }
      
       public PageReference UpdateSAPInvoices() {  
        list<SAP_Integration__c> sapRecords = [Select Status__c
                                               FROM SAP_Integration__c
                                               WHERE SAP_Processed_Date__c =: invoiceObj.invoiceit_s__Invoice_Date__c 
                                               AND
                                               Status__c = 'Processed'
                                               AND
                                               Document_Type__c = 'Sales Invoices'
                                               ];
        
        if(sapRecords.size() == 0) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'No records fetched to update'));
            return null;   
        }
        
        for(SAP_Integration__c sap : sapRecords) {
            sap.Status__c = 'Completed';   
        }
        
        update sapRecords;
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'SAP records have been updated successfully'));
            
        return null;        
       }
      
       public PageReference UpdateSAPRevenueRec() {  
        list<SAP_Integration__c> sapRecords = [Select Status__c
                                               FROM SAP_Integration__c
                                               WHERE SAP_Processed_Date__c =: invoiceObjForRevRef.invoiceit_s__Invoice_Date__c 
                                               AND
                                               Status__c = 'Processed'
                                               AND
                                               Document_Type__c = 'Monthly Deferred Revenue Posting'
                                               ];
        
        if(sapRecords.size() == 0) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'No records fetched to update'));
            return null;   
        }
        
        for(SAP_Integration__c sap : sapRecords) {
            sap.Status__c = 'Completed';   
        }
        
        update sapRecords;
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'SAP records have been updated successfully'));
            
        return null;        
      }
      
      public PageReference UpdateSAPRebates() {  
        list<invoiceit_s__Refund__c> refunds = [Select invoiceit_s__Status__c
                                               FROM invoiceit_s__Refund__c
                                               WHERE invoiceit_s__Refund_Date__c =: invoiceObjRebates.invoiceit_s__Invoice_Date__c 
                                               AND
                                               invoiceit_s__Status__c = 'Approved'
                                               AND
                                               SAP_Status__c != 'Completed'
                                               AND
                                               (Document_Type__c = 'Refund' OR Document_Type__c = 'Rebate')
                                               ];
        
        if(refunds.size() == 0) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'No records fetched to update'));
            return null;   
        }
        
        for(invoiceit_s__Refund__c refund : refunds) {
            refund.SAP_Status__c = 'Completed';   
        }
        
        update refunds;
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'SAP records have been updated successfully'));
            
        return null;        
      }
      
      public PageReference UpdateSAPPayments() {  
        list<invoiceit_s__Payment__c> payments = [Select invoiceit_s__Status__c
                                                   FROM invoiceit_s__Payment__c
                                                   WHERE invoiceit_s__Payment_Date__c =: invoiceObjRebates.invoiceit_s__Invoice_Date__c 
                                                   AND
                                                   invoiceit_s__Status__c = 'Completed'
                                                   AND
                                                   SAP_Status__c != 'Completed'
                                                   AND
                                                   (invoiceit_s__Payment_Type__c != 'ACH' AND invoiceit_s__Payment_Type__c != 'Bank Transfer' AND invoiceit_s__Payment_Type__c != 'Cash' AND invoiceit_s__Payment_Type__c != 'Check' AND invoiceit_s__Payment_Type__c != 'Cheque' AND invoiceit_s__Payment_Type__c != 'Credit Card' AND invoiceit_s__Payment_Type__c != 'COA-Legacy Balance' AND invoiceit_s__Payment_Type__c != 'Refund')
                                                   ];
        
        if(payments.size() == 0) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'No records fetched to update'));
            return null;   
        }
        
        for(invoiceit_s__Payment__c payment : payments) {
            payment.invoiceit_s__Status__c = 'Completed';   
        }
        
        update payments;
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'SAP records have been updated successfully'));
            
        return null;        
      }
}