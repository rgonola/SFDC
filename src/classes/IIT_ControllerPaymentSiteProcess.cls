public with sharing class IIT_ControllerPaymentSiteProcess {
      Id invoiceId;
      public invoiceit_s__Invoice__c invoice {get;set;}
      public invoiceit_s__Payment_Method__c paymentMethod {get;set;}
       
      public boolean isTransactionCreated {get;set;}
      public String sMessege {get;set;}
      public boolean processToken {get;set;}
      public invoiceit_s__Transaction__c transactionObj{get;set;}
      Public string accountID{get;set;}
      public list<InvoiceWrapperClass> listOfInvoiceWrapperClass{get;set;}

      public invoiceit_s__Gateway__c gateway;
      public boolean isRender {get;set;}
      list<invoiceit_s__Invoice__c>  listOfInvoices;
      
      public string isselectedvalue{get;set;}
      public String selectedValue { get; set; }
      public String recordId { get; set; }
      
      public list<invoiceit_s__Payment_Method__c> listPaymentMethod{get;set;}
      
      public boolean isDisplayblock{get;set;}
      public string invoiceIDToProcess {get;set;}
      public boolean dontShowMessage {get;set;}
      public boolean isTrasDispaly {get;set;}
    
      public IIT_ControllerPaymentSiteProcess(){
      
          listOfInvoiceWrapperClass = new list<InvoiceWrapperClass> ();
          recordId = system.currentPageReference().getParameters().get('Id');
          transactionObj = new invoiceit_s__Transaction__c();
          String gatewayID;
          paymentMethod = new invoiceit_s__Payment_Method__c();
          processToken = false;
          isTrasDispaly = true;
          listPaymentMethod = new list<invoiceit_s__Payment_Method__c>();
          isDisplayblock = true; 
           if(recordId.startsWith('001')) {
                isRender = false;
                accountID = recordId;
                InvoiceWrapperClass InvoiceWrapperClassLocal;
                listOfInvoices = getInvoices(recordId,null);
                
                List<Account> invcd = [Select id,Cutoff__c From Account Where id=:recordId Limit 1];
                
                if(invcd.size()>0){
                     
                if(invcd[0].Cutoff__c == TRUE){
                
                String x ='Your account has currently been suspended.In order to reactivate your account, you must pay your entire account balance due.If you are unable to pay the balance in full,please contact the Accounts Receivable Department at 770-857-5100,Opt 1 during normal business hours (M-F, 8:30 am – 5:30 pm).';
              
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning, x));
                
                }
                    } 
                
                
                if(listOfInvoices.size() > 0){
                    for(invoiceit_s__Invoice__c inv : listOfInvoices){
                      InvoiceWrapperClassLocal = new InvoiceWrapperClass();
                      InvoiceWrapperClassLocal.invoiceObj = inv;
                      InvoiceWrapperClassLocal.unpaidAmount = inv.invoiceit_s__Unpaid_Amount__c;
                      InvoiceWrapperClassLocal.invoiceObj.invoiceit_s__Payment_Request_Amount__c = inv.invoiceit_s__Unpaid_Amount__c;
                      system.debug('inv.Invoice_IT_Batch_Jobs__r.size() == ' + inv.Invoice_IT_Batch_Jobs__r.size());
                      system.debug('inv.Name == ' + inv.Name);
                      if(inv.Invoice_IT_Batch_Jobs__r.size() > 0)
                         InvoiceWrapperClassLocal.isHide = true;
                      listOfInvoiceWrapperClass.add(InvoiceWrapperClassLocal);

                      gatewayID = inv.invoiceit_s__Account__r.invoiceit_s__Gateway__c;
                  } 
                }else{
                  isDisplayblock = false;
                  Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'No Invoice(s) to Pay.'));
                }
                  
              }else{
                   isRender = true;
                   listOfInvoices = getInvoices(null, recordId);
                   if(listOfInvoices.size() > 0){   Invoice = listOfInvoices[0];
                      if(Invoice.invoiceit_s__Payment_Request_Amount__c == 0){
                          Invoice.invoiceit_s__Payment_Request_Amount__c = Invoice.invoiceit_s__Unpaid_Amount__c;
                      }
                   }                    
                   accountID = invoice.invoiceit_s__Account__c;
                   gatewayID = invoice.invoiceit_s__Account__r.invoiceit_s__Gateway__c;
              }

              list<invoiceit_s__Gateway__c> listOfGateway = getMerchantGateway(gatewayID);                                          
              if(listOfGateway.size() == 0){  Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Payment Gateway is not configured. Please contact CCH team to get it resloved.'));
              } else{  gateway = listOfGateway[0];
                  
              }
              
              //listPaymentMethod = getDefaultPaymentMethod(accountID);
              map_paymentmethodIds = getDefaultPaymentMethod(accountID);
              for(invoiceit_s__Payment_Method__c pm : map_paymentmethodIds.Values()){
                  if(pm.invoiceit_s__Default__c){
                      selectedValue = pm.id;
                      break;
                  }
              }
              
              listPaymentMethod.addall(map_paymentmethodIds.Values());
              listOftransactionToinsert = new list<invoiceit_s__Transaction__c>();
      }
      
      map<id,invoiceit_s__Payment_Method__c> map_paymentmethodIds;

       public list<invoiceit_s__Transaction__c> listOftransactionToinsert{get;set;}
       public PageReference processPayment() { 
          Savepoint sp;
          try {        
           system.debug('selectedvalue==>>'+selectedvalue);
           if(selectedvalue == null || selectedvalue == ''){
             Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Please select a payment method to process the payment.'));
             return null;
           }
           
           boolean ischeck = false;
           for(InvoiceWrapperClass invoiceWrapperClassLocal: listOfInvoiceWrapperClass){
               if(invoiceWrapperClassLocal.isSelected){
                   if(invoiceWrapperClassLocal.invoiceobj.invoiceit_s__Payment_Request_Amount__c > invoiceWrapperClassLocal.invoiceobj.invoiceit_s__Unpaid_Amount__c){
                      Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Amount to be paid should be equal or less than the unpaid amount for the invoice ' + invoiceWrapperClassLocal.invoiceobj.Name));
                      
                      return null;
                   }
                   ischeck = true;
                }     
           }     
           
           if(ischeck == false){
              selectedvalue = null;
              Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Please select atleast one invoice to pay.'));
              return null;
           }
           

             if(selectedvalue != null){
                  isRender = true; 
                  paymentmethod = map_paymentmethodIds.get(selectedvalue);
                  list<invoiceit_s__Payment__c> listOfPayment = new list<invoiceit_s__Payment__c>();
                  list<invoiceit_s__Payment_Allocation__c> listOfPaymentallocation = new list<invoiceit_s__Payment_Allocation__c>();
                  map<id,id> map_invID_tranId = new map<id,id>();
                  for(InvoiceWrapperClass invoiceWrapperClassLocal: listOfInvoiceWrapperClass){
                   if(invoiceWrapperClassLocal.isSelected){
                      invoiceit_s.PaymentSiteOperation.GenericPaymentParameters genericPaymentParameters = new invoiceit_s.PaymentSiteOperation.GenericPaymentParameters();
                      genericPaymentParameters.gateway = gateway;
                      genericPaymentParameters.amountToProcess = invoiceWrapperClassLocal.invoiceobj.invoiceit_s__Payment_Request_Amount__c;
                      genericPaymentParameters.currencyISOCode = invoiceWrapperClassLocal.invoiceobj.invoiceit_s__CurrencyL__r.Name;
                      genericPaymentParameters.paymentMethod = paymentMethod;
                      genericPaymentParameters.shouldTokenizeCard = processToken;
                      invoiceit_s.PaymentSiteOperation.GenericPaymentResult genericPaymentResult = new invoiceit_s.PaymentSiteOperation.GenericPaymentResult();
                      invoiceit_s.PaymentSiteOperation site = new invoiceit_s.PaymentSiteOperation();
                      genericPaymentResult = site.processGenericPayment(genericPaymentParameters);
                      
                      system.debug('response from PG : ' + genericPaymentResult);                     
                      if(genericPaymentResult.isSuccess == true){
                          transactionObj = genericPaymentResult.transactionObj;
                          sMessege = genericPaymentResult.message;
                          
                          transactionObj.invoiceit_s__Response_Status__c = 'Approved';
                          transactionObj.invoiceit_s__Payment_Method__c = paymentMethod.id;
                          transactionObj.invoiceit_s__Payment_Gateway__c = gateway.id;
                          transactionObj.invoiceit_s__Request_Invoice__c = invoiceWrapperClassLocal.invoiceobj.id;
                          transactionObj.invoiceit_s__Is_Payment_Processed_Successfully__c = true;      
                          transactionObj.invoiceit_s__Currency__c = invoiceWrapperClassLocal.invoiceobj.invoiceit_s__CurrencyL__c;                    
                          listOftransactionToinsert.add(transactionObj);
                          system.debug('Request Invoice:: ' +transactionObj.invoiceit_s__Request_Invoice__c );  
                          invoiceit_s__Payment__c payment = new invoiceit_s__Payment__c(invoiceit_s__Account__c = invoiceWrapperClassLocal.invoiceobj.invoiceit_s__Account__c, 
                                                                                        invoiceit_s__Amount__c = transactionObj.invoiceit_s__Amount__c, 
                                                                                        invoiceit_s__Status__c = 'Completed', 
                                                                                        invoiceit_s__Payment_Type__c = paymentMethod.invoiceit_s__Payment_Method__c,
                                                                                        invoiceit_s__Payment_Date__c = system.today(),
                                                                                        invoiceit_s__Currency__c = invoiceWrapperClassLocal.invoiceobj.invoiceit_s__CurrencyL__c,
                                                                                        invoiceit_s__Invoice__c = invoiceWrapperClassLocal.invoiceobj.Id);

                        listOfPayment.add(payment);
                        }else{
                          transactionObj = genericPaymentResult.transactionObj;
                          sMessege = genericPaymentResult.message;
      
                          transactionObj.invoiceit_s__Payment_Method__c = paymentMethod.id;
                          transactionObj.invoiceit_s__Payment_Gateway__c = gateway.id;
                          transactionObj.invoiceit_s__Request_Invoice__c = invoiceWrapperClassLocal.invoiceobj.id;
                          transactionObj.invoiceit_s__Exception_Message__c = sMessege;

                          listOftransactionToinsert.add(transactionObj);
                        }
                   }
                }
               
               // keep the save point after processing the payments in Cybersource
               sp = Database.setSavepoint(); 
               
               // insert the transactions
               insert listOftransactionToinsert;

               listOftransactionToinsert = [SELECT Id, invoiceit_s__Request_Invoice__r.invoiceit_s__CurrencyL__r.name , invoiceit_s__Request_Invoice__r.invoiceit_s__CurrencyL__r.invoiceit_s__Currency_Symbol__c, invoiceit_s__Request_Invoice__r.Name,invoiceit_s__Amount__c,invoiceit_s__Authorization__c,invoiceit_s__AVS_Response_Code__c,invoiceit_s__AVS_Zip__c,invoiceit_s__Card_Code_Response__c,invoiceit_s__Card_Expiration_Month__c,invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Card_Type__c,invoiceit_s__Currency__c,invoiceit_s__Exception_Message__c,invoiceit_s__Gateway_Date__c,invoiceit_s__Gateway_ID__c,invoiceit_s__Is_Payment_Processed_Successfully__c,invoiceit_s__Payment_Gateway__c,invoiceit_s__Payment_Method__c,invoiceit_s__Payment_Run__c,invoiceit_s__Reason_Code__c,invoiceit_s__Request_Credit_Card_Number__c,invoiceit_s__Request_Invoice__c,invoiceit_s__Request_Transaction_Type__c,invoiceit_s__Request_Type_Of_Payment__c,invoiceit_s__Response_Code__c,invoiceit_s__Response_Message__c,invoiceit_s__Response_Status__c,invoiceit_s__Response__c,invoiceit_s__Transaction__c,invoiceit_s__Type__c,Name,payment_plan_installment__c 
                                            FROM invoiceit_s__Transaction__c where 
                                            ID IN: listOftransactionToinsert];
               for(invoiceit_s__Transaction__c trans :  listOftransactionToinsert){
                  map_invID_tranId.put(trans.invoiceit_s__Request_Invoice__c,trans.id);
               } 
               
               // insert the payments
               insert listOfPayment; 
               
               for(invoiceit_s__Payment__c payment : listOfPayment){
                  if(map_invID_tranId.containskey(payment.invoiceit_s__Invoice__c)){
                      payment.invoiceit_s__Transaction__c = map_invID_tranId.get(payment.invoiceit_s__Invoice__c);
                  }
               }
               update listOfPayment;   
               
               system.debug('listOftransactionToinsert==>>'+listOftransactionToinsert);
               system.debug('listOfPayment==>>'+listOfPayment);
               return null;

              }else{
                  Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Sorry for inconvenience, internal problem occured please reload the page and try again.'));
              }
          }catch(System.Exception e){
              Database.rollback(sp);
              isTrasDispaly = false;
              // log the exception to re process the error ones
              list<invoiceit_s__Batch_Jobs__c> listofBatchJobs = new list<invoiceit_s__Batch_Jobs__c>();
              invoiceit_s__Batch_Jobs__c  batchJobsObj ;
              string exceptionMessage = 'An exception has occurred, Please contact your system Admin. ExMessage : ' + e.getMessage() + ' Line No : ' + e.getLineNumber() + ' Stack Trace : ' + e.getStackTraceString() + ' TypeName : ' + e.getTypeName() + ' Cause : ' + e.getCause();
              exceptionMessage = 'Transaction is processed & approved in Cybersource but response is not captured in Salesforce.' + exceptionMessage; 
              
              batchJobsObj = new invoiceit_s__Batch_Jobs__c(Name = 'Force Site Error : Before Payment', Exception_Message__c = exceptionMessage, CurrencyID__c = accountID);
              listofBatchJobs.add(batchJobsObj);
              
              for(invoiceit_s__Transaction__c tras :  listOftransactionToinsert){
                  system.debug('tras after exception : ' + tras); 
                  // log only the approved transactions
                  if(tras.invoiceit_s__Response_Status__c == 'Approved') {
                      batchJobsObj = new invoiceit_s__Batch_Jobs__c(
                                          Name = 'Force Site Error', invoiceit_s__Type__c = 'Force.com Site',Amount__c = tras.invoiceit_s__Amount__c , Authorization__c = tras.invoiceit_s__Authorization__c,Card_Type__c = tras.invoiceit_s__Card_Type__c,Exception_Message__c = exceptionMessage,Invoice__c = tras.invoiceit_s__Request_Invoice__c,
     Payment_GatewayId__c = tras.invoiceit_s__Payment_Gateway__c,Payment_Method__c = tras.invoiceit_s__Payment_Method__c,Payment_Process_Successful__c = tras.invoiceit_s__Is_Payment_Processed_Successfully__c, Request_Credit_Card_Number__c = tras.invoiceit_s__Request_Credit_Card_Number__c, 
     Request_Transaction_Type__c = tras.invoiceit_s__Request_Transaction_Type__c,Response__c = tras.invoiceit_s__Response__c,Gateway_Date__c=tras.invoiceit_s__Gateway_Date__c,Request_Type_Of_Payment__c=tras.invoiceit_s__Request_Type_Of_Payment__c,
     Response_Code__c = tras.invoiceit_s__Response_Code__c,Response_Gateway_ID__c = tras.invoiceit_s__Gateway_ID__c, Response_Status__c = tras.invoiceit_s__Response_Status__c,Status__c = 'Pending',CurrencyID__c = tras.invoiceit_s__Currency__c);
                      listofBatchJobs.add(batchJobsObj);
                  }
              }
              System.debug('batchJobsObj  Size===>'+listofBatchJobs);
              insert listofBatchJobs;              
              
              dontShowMessage = true;
                                     
             //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Thank you for your payment'));
          }
        
          return null;
      }  
      
      public PageReference updatePM(){
          PageReference pf = new PageReference('/apex/IIT_PaymentMethodProcess?id='+accountID+'&redirectURL=null');
          pf.setredirect(true);
          return pf;
      }
      
       public PageReference openinvc(){
          PageReference pf = new PageReference('/apex/IIT_PaymentSiteProcess?id='+recordId);
          pf.setredirect(true);
          return pf;
      }
      
      public PageReference PaymentAllocation(){
          Savepoint sp;
          try {
              sp = Database.setSavepoint();
              isRender = false; 
              string sParamCount = system.currentPageReference().getParameters().get('Payment');
              System.debug('sParamCountsParamCount >=='+sParamCount);
              // transactionObj ; 
              list<invoiceit_s__Payment__c> listOfPayment = new list<invoiceit_s__Payment__c>();
              list<invoiceit_s__Transaction__c> listOftransactionToinsertLocal = new list<invoiceit_s__Transaction__c>();
              
              
              list<invoiceit_s__Batch_Jobs__c> listOfBatchJobs = [SELECT Amount__c,Authorization__c,Card_Type__c,Gateway_Date__c,Exception_Message__c,Id,invoiceit_s__Completed_Date_and_Time__c,invoiceit_s__Exception_Log__c,invoiceit_s__Start_Date_and_Time__c,
                                                                  invoiceit_s__Status__c,invoiceit_s__Type__c,Invoice__c,Name,Payment_GatewayID__c,Payment_Method__c,Payment_Process_Successful__c,Request_Credit_Card_Number__c,Request_Transaction_Type__c,
                                                                  Payment_Method__r.invoiceit_s__Card_Expiration_Year__c ,Payment_Method__r.invoiceit_s__Card_Expiration_Month__c ,Payment_Method__r.invoiceit_s__Card_Type__c ,Payment_Method__r.invoiceit_s__Account__c ,
                                                                  Response_Code__c,Response_Gateway_ID__c,Response_Status__c,Response__c,Status__c,CurrencyID__c,Request_Type_Of_Payment__c ,
                                                                  Payment_Method__r.invoiceit_s__Payment_Method__c
                                                                  FROM invoiceit_s__Batch_Jobs__c                                                                  
                                                                  WHERE Invoice__c =:sParamCount AND Status__c = 'Pending'];
                                                                  
              if(listOfBatchJobs.size() == 0) {
                  Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'There are no failed records to re-process for this invoice, please refresh the page.'));
                  return null;
              }
              
              System.debug('listOfBatchJobslistOfBatchJobs Size ===='+listOfBatchJobs);
              System.debug('listOfBatchJobslistOfBatchJobs Size ===='+listOfBatchJobs.size());
              for(invoiceit_s__Batch_Jobs__c  batchJob : listOfBatchJobs){
                  invoiceit_s__Transaction__c transactionObj = new invoiceit_s__Transaction__c();
                  transactionObj.invoiceit_s__Payment_Method__c = batchJob.Payment_Method__c;
                  transactionObj.invoiceit_s__Payment_Gateway__c = batchJob.Payment_GatewayId__c;
                  transactionObj.invoiceit_s__Request_Invoice__c = batchJob.Invoice__c;
                  transactionObj.invoiceit_s__Gateway_Date__c=batchJob.Gateway_Date__c;
                  transactionObj.invoiceit_s__Request_Type_Of_Payment__c=batchJob.Request_Type_Of_Payment__c;
                  transactionObj.invoiceit_s__Is_Payment_Processed_Successfully__c = true;
                  transactionObj.invoiceit_s__Currency__c = batchJob.CurrencyId__c ; 
                  transactionObj.invoiceit_s__Amount__c = batchJob.Amount__c ;
                  transactionObj.invoiceit_s__Gateway_ID__c = batchJob.Response_Gateway_ID__c ;
                  transactionObj.invoiceit_s__Authorization__c = batchJob.Authorization__c;
                  transactionObj.invoiceit_s__Response_Status__c = batchJob.Response_Status__c;
                  transactionObj.invoiceit_s__Response__c= batchJob.Response__c;
                  transactionObj.invoiceit_s__Response_Code__c= batchJob.Response_Code__c;
                  transactionObj.invoiceit_s__Request_Credit_Card_Number__c = batchJob.Request_Credit_Card_Number__c;
                  transactionObj.invoiceit_s__Card_Expiration_Month__c = batchJob.Payment_Method__r.invoiceit_s__Card_Expiration_Month__c;
                  transactionObj.invoiceit_s__Card_Expiration_Year__c = batchJob.Payment_Method__r.invoiceit_s__Card_Expiration_Year__c;
                  transactionObj.invoiceit_s__Card_Type__c = batchJob.Payment_Method__r.invoiceit_s__Card_Type__c;
                  transactionObj.Re_Processed_By__c = 'Force.com Site';
                  transactionObj.invoiceit_s__Type__c = 'Charge';
                  transactionObj.invoiceit_s__Request_Transaction_Type__c = 'Charge';
                              
                  invoiceit_s__Payment__c payment = new invoiceit_s__Payment__c(invoiceit_s__Account__c = batchJob.Payment_Method__r.invoiceit_s__Account__c ,
                                                                                invoiceit_s__Amount__c = batchJob.Amount__c, 
                                                                                invoiceit_s__Status__c = 'Completed', 
                                                                                invoiceit_s__Payment_Type__c = batchJob.Payment_Method__r.invoiceit_s__Payment_Method__c,
                                                                                invoiceit_s__Payment_Date__c = system.today(),
                                                                                invoiceit_s__Invoice__c = batchJob.Invoice__c,
                                                                                invoiceit_s__Currency__c = batchJob.CurrencyId__c,
                                                                                invoiceit_s__Payment_Description__c = 'This payment is being Re-Processed from force.com site.');
                                      
                  listOftransactionToinsertLocal.add(transactionObj);
                  listOfPayment.add(payment);
                  
              }
              System.debug('Transaction and payment ');
              
              // insert the transactions
              insert listOftransactionToinsertLocal;
              
              // insert the payments
              insert listOfPayment ;
              
              // populate the inserted transaction Id & update the payments
              for(integer i = 0; i < listOfPayment.size(); i++) {
                  invoiceit_s__Payment__c payment = listOfPayment[i];
                  payment.invoiceit_s__Transaction__c = listOftransactionToinsertLocal[i].Id;         
              }
              update listOfPayment;
              
              
              // loop over the failed payment to mark as completed so that it will be never picked up again 
              System.debug('After Transaction and payment ');
              for(invoiceit_s__Batch_Jobs__c invBatchJob : listOfBatchJobs){
                  invBatchJob.Status__c = 'Completed';
              }
              update listOfBatchJobs;
              
              Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Success, Payment is recorded in Salesforce. Please refresh the page.'));
           } catch(Exception e){
               Database.rollback(sp);
               string exceptionMessage = 'An exception has occurred, Nothing has been processed & Operation is reverted back. Please click on Process Button again. ExMessage : ' + e.getMessage()
                                        + ' Line No : ' + e.getLineNumber()
                                        + ' Stack Trace : ' + e.getStackTraceString()
                                        + ' TypeName : ' + e.getTypeName()
                                        + ' Cause : ' + e.getCause();
               System.debug('exceptionMessage'+exceptionMessage);
               Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, exceptionMessage));
           }
           
           return null;
      }


      public class InvoiceWrapperClass{
          public invoiceit_s__Invoice__c invoiceObj {get;set;}
          public decimal unpaidAmount{get;set;}
          public boolean isSelected{get;set;}
          public boolean isHide{get;set;}
          public InvoiceWrapperClass(){
              invoiceObj = new invoiceit_s__Invoice__c();
              unpaidAmount = 0;
              isSelected = false;
              isHide = false;
          }
      }
     

     /*=============== query section started ========================== */

      public static list<invoiceit_s__Invoice__c> getInvoices(Id accountID,ID InvoiceID) {
          list<invoiceit_s__Invoice__c> listOfinvoice;
          if(accountID != null){
            listOfinvoice = [SELECT Account_CID__c,Account_PID__c,invoiceit_s__Account__c, Name, invoiceit_s__Paid_Amount__c,invoiceit_s__Invoice_Date__c,invoiceit_s__Account__r.id,invoiceit_s__Total_Invoice_Value__c, invoiceit_s__Unpaid_Amount__c,invoiceit_s__Payment_Status__c,  
                                invoiceit_s__CurrencyL__c, invoiceit_s__CurrencyL__r.Name, invoiceit_s__CurrencyL__r.invoiceit_s__Currency_Symbol__c,invoiceit_s__Invoice_Reference__c, 
                                invoiceit_s__Account__r.invoiceit_s__Gateway__c, invoiceit_s__Account__r.invoiceit_s__VAT_No__c, invoiceit_s__Account__r.Name, invoiceit_s__Account__r.BillingStreet, invoiceit_s__Account__r.BillingCity, invoiceit_s__Account__r.BillingState , invoiceit_s__Account__r.BillingCountry, invoiceit_s__Account__r.BillingPostalCode,
                                invoiceit_s__Account__r.ShippingStreet, invoiceit_s__Account__r.ShippingCity, invoiceit_s__Account__r.ShippingCountry, invoiceit_s__Account__r.ShippingState,invoiceit_s__Account__r.ShippingPostalCode,
                                invoiceit_s__Billing_Contact__r.Name, invoiceit_s__Billing_Contact__r.MailingStreet, invoiceit_s__Billing_Contact__r.MailingCity, invoiceit_s__Billing_Contact__r.MailingState , invoiceit_s__Billing_Contact__r.MailingCountry, invoiceit_s__Billing_Contact__r.MailingPostalCode, invoiceit_s__Billing_Contact__r.Salutation,
                                invoiceit_s__Billing_Contact__r.FirstName, invoiceit_s__Billing_Contact__r.LastName,invoiceit_s__Order__r.Name,invoiceit_s__Invoice_Status__c, invoiceit_s__Payment_Request_Amount__c,invoiceit_s__Invoice_State__c,
                                invoiceit_s__Shipping_Contact__r.FirstName,invoiceit_s__Billing_Contact__r.Email, invoiceit_s__Shipping_Contact__r.LastName, invoiceit_s__Shipping_Contact__r.Account.Name, invoiceit_s__Shipping_Contact__r.MailingStreet,
                                invoiceit_s__Shipping_Contact__r.MailingCity, invoiceit_s__Shipping_Contact__r.MailingState, invoiceit_s__Shipping_Contact__r.MailingPostalCode, invoiceit_s__Shipping_Contact__r.MailingCountry,invoiceit_s__Shipping_Contact__r.Phone,
                                (SELECT Amount__c,Authorization__c,Card_Type__c,Exception_Message__c,Id,invoiceit_s__Completed_Date_and_Time__c,invoiceit_s__Exception_Log__c,invoiceit_s__Start_Date_and_Time__c,invoiceit_s__Status__c,invoiceit_s__Type__c,Invoice__c,Name,Payment_GatewayId__c,Payment_Method__c,Payment_Process_Successful__c,Request_Credit_Card_Number__c,Request_Transaction_Type__c,Response_Code__c,Response_Gateway_ID__c,Response_Status__c,Response__c,Status__c 
                                FROM Invoice_IT_Batch_Jobs__r 
                                WHERE Status__c = 'Pending'
                                )                               
                                FROM invoiceit_s__Invoice__c
                                WHERE invoiceit_s__Account__c =: accountID
                                AND invoiceit_s__Invoice_Status__c = 'Posted'
                                AND invoiceit_s__Unpaid_Amount__c > 0
                                LIMIT 400];
          }else{
            listOfinvoice = [SELECT Account_CID__c,Account_PID__c,invoiceit_s__Account__c, invoiceit_s__Paid_Amount__c,invoiceit_s__Invoice_Date__c,Name, invoiceit_s__Account__r.id,invoiceit_s__Total_Invoice_Value__c, invoiceit_s__Unpaid_Amount__c,invoiceit_s__Payment_Status__c,  
                                invoiceit_s__CurrencyL__c, invoiceit_s__CurrencyL__r.Name, invoiceit_s__CurrencyL__r.invoiceit_s__Currency_Symbol__c,invoiceit_s__Invoice_Reference__c, 
                                invoiceit_s__Account__r.invoiceit_s__Gateway__c, invoiceit_s__Account__r.invoiceit_s__VAT_No__c, invoiceit_s__Account__r.Name, invoiceit_s__Account__r.BillingStreet, invoiceit_s__Account__r.BillingCity, invoiceit_s__Account__r.BillingState , invoiceit_s__Account__r.BillingCountry, invoiceit_s__Account__r.BillingPostalCode,
                                invoiceit_s__Account__r.ShippingStreet, invoiceit_s__Account__r.ShippingCity, invoiceit_s__Account__r.ShippingCountry, invoiceit_s__Account__r.ShippingState,invoiceit_s__Account__r.ShippingPostalCode,
                                invoiceit_s__Billing_Contact__r.Name, invoiceit_s__Billing_Contact__r.MailingStreet, invoiceit_s__Billing_Contact__r.MailingCity, invoiceit_s__Billing_Contact__r.MailingState , invoiceit_s__Billing_Contact__r.MailingCountry, invoiceit_s__Billing_Contact__r.MailingPostalCode, invoiceit_s__Billing_Contact__r.Salutation,
                                invoiceit_s__Billing_Contact__r.FirstName, invoiceit_s__Billing_Contact__r.LastName,invoiceit_s__Order__r.Name,invoiceit_s__Invoice_Status__c, invoiceit_s__Payment_Request_Amount__c,invoiceit_s__Invoice_State__c,
                                invoiceit_s__Shipping_Contact__r.FirstName,invoiceit_s__Billing_Contact__r.Email, invoiceit_s__Shipping_Contact__r.LastName, invoiceit_s__Shipping_Contact__r.Account.Name, invoiceit_s__Shipping_Contact__r.MailingStreet,
                                invoiceit_s__Shipping_Contact__r.MailingCity, invoiceit_s__Shipping_Contact__r.MailingState, invoiceit_s__Shipping_Contact__r.MailingPostalCode, invoiceit_s__Shipping_Contact__r.MailingCountry,invoiceit_s__Shipping_Contact__r.Phone,
                                (SELECT Amount__c,Authorization__c,Card_Type__c,Exception_Message__c,Id,invoiceit_s__Completed_Date_and_Time__c,invoiceit_s__Exception_Log__c,invoiceit_s__Start_Date_and_Time__c,invoiceit_s__Status__c,invoiceit_s__Type__c,Invoice__c,Name,Payment_GatewayId__c,Payment_Method__c,Payment_Process_Successful__c,Request_Credit_Card_Number__c,Request_Transaction_Type__c,Response_Code__c,Response_Gateway_ID__c,Response_Status__c,Response__c,Status__c 
                                FROM Invoice_IT_Batch_Jobs__r 
                                WHERE Status__c = 'Pending'
                                )                            
                                FROM invoiceit_s__Invoice__c
                                WHERE Id =: InvoiceID
                                AND invoiceit_s__Invoice_Status__c = 'Posted'
                                AND invoiceit_s__Unpaid_Amount__c > 0 
                                LIMIT 400];
          }                   
          return listOfinvoice;                   
      } 
   
     
     public static map<id,invoiceit_s__Payment_Method__c> getDefaultPaymentMethod(Id AccountID) {
          map<id,invoiceit_s__Payment_Method__c> paymentMethodActive = new map<id,invoiceit_s__Payment_Method__c>([SELECT invoiceit_s__Account__r.CID__c,invoiceit_s__Account__r.PID__c,Name ,invoiceit_s__Card_Number__c, invoiceit_s__Card_Type__c, invoiceit_s__Card_Expiration_Month__c, invoiceit_s__Card_Expiration_Year__c, invoiceit_s__CVV__c, invoiceit_s__Name_on_Card__c, invoiceit_s__Billing_Country__c,
                  invoiceit_s__Bank_Routing_Code__c, invoiceit_s__Bank_Account_Number__c, invoiceit_s__Bank_Account_Type__c, invoiceit_s__Bank_Name__c, invoiceit_s__Bank_Account_Name__c,
                  invoiceit_s__Billing_First_Name__c, invoiceit_s__Billing_Last_Name__c, invoiceit_s__Billing_Address__c, invoiceit_s__Billing_City__c, invoiceit_s__Billing_State_Province__c, invoiceit_s__Billing_Zip_Postal__c ,
                  invoiceit_s__Account__c, invoiceit_s__Account__r.Name, invoiceit_s__Billing_Phone__c, invoiceit_s__Billing_Fax__c, invoiceit_s__Billing_Email__c,invoiceit_s__Account__r.invoiceit_s__Customer_Profile_ID__c,invoiceit_s__Payment_Profile_ID__c,
                  Last_4_Digits__c,invoiceit_s__Encrypted_CVV__c,invoiceit_s__Payment_Method__c,invoiceit_s__Encrypted_Card_Number__c,invoiceit_s__Token__c, invoiceit_s__Default__c 
                  FROM invoiceit_s__Payment_Method__c
                  WHERE invoiceit_s__Account__c =: AccountID
                  AND invoiceit_s__Active__c = true   AND Customer_Deletion__c =FALSE                
                  ]);
                                
          return paymentMethodActive;                   
      } 

      public static list<invoiceit_s__Gateway__c> getMerchantGateway(Id gatewayID) {
          list<invoiceit_s__Gateway__c> listOfGateway;
          if(gatewayID != null){
                     listOfGateway = [SELECT Name, invoiceit_s__Merchant_Reference__c, invoiceit_s__Exact_ID_Security_Key__c, invoiceit_s__Exact_ID__c, invoiceit_s__Gateway_Type__c, 
                                      invoiceit_s__Merchant_ID__c, invoiceit_s__Security_Key__c, invoiceit_s__Test_Mode__c, 
                                      invoiceit_s__Merchant_Seal_User_Id__c,invoiceit_s__Email_Customer__c,invoiceit_s__Transaction_Security_Key__c
                                      FROM invoiceit_s__Gateway__c
                                      WHERE id =: gatewayID
                                    ];
          }else{
              listOfGateway = [SELECT Name, invoiceit_s__Merchant_Reference__c, invoiceit_s__Exact_ID_Security_Key__c, invoiceit_s__Exact_ID__c, invoiceit_s__Gateway_Type__c, 
                              invoiceit_s__Merchant_ID__c, invoiceit_s__Security_Key__c, invoiceit_s__Test_Mode__c, 
                              invoiceit_s__Merchant_Seal_User_Id__c,invoiceit_s__Email_Customer__c,invoiceit_s__Transaction_Security_Key__c
                               FROM invoiceit_s__Gateway__c
                               WHERE invoiceit_s__Active__c = true and invoiceit_s__Default__c = true Limit 1
                               ];
          }
                                
          return listOfGateway;                   
      } 

     /* =============== query section ended ========================== */

  }