public class IIT_createOrder_extension1 {

    private SBQQ__Quote__c myQuote;
    string exceptionMessage;
    list<invoiceit_s__Job__c> createdOrder;
    
    public string ErrorMsg {get;set;}
    public string invoiceID  {get;set;}
    public string OrderID  {get;set;}
    public string TransactionOK  {get;set;}    
    public string IncrementStatus  {get;set;}
    public string showProcessPayment {get;set;}
    public string showCreateOrder {get;set;}
    
    public boolean showGreen{get;set;}

    public IIT_createOrder_extension1(ApexPages.StandardController stdController) { 
        // get the quote details
        myQuote = IIT_CreateOrderUtilClass.getQuote(stdController.getId()); 
        
        showbuttons = true;
        if(myQuote.QTC__Order__c != null) {
            // verify invoice & order is created or not
            OrderID = myQuote.QTC__Order__c;
            list<invoiceit_s__Invoice__c> invoices = IIT_CreateOrderUtilClass.getInvoiceList(myQuote.QTC__Order__c);
            if(invoices.size() > 0){
                invoiceID =  invoices[0].Id;
            }
            showGreen = true;
            ErrorMsg = 'Order is already for the Quote';     
        } else {            
            // call the validations if it's a bill later or Subscription.
            if(myQuote.QTC__Payment_Plan__r.Name == 'Bill Later Payment Plan' || myquote.Subscription__c == true)
            {                
                //this util method will return error message or null
                ErrorMsg = IIT_CreateOrderBussinessClass.validateQuoteDetails(myQuote);
                
                //make the allPaymentPlansPaid as true if it's a bill later or subscription
                allPaymentPlansPaid = true;
            }
            else 
            {        
                // call the validations only if the payments are not processed. If the payments are processed then don't call the validation rules
                allPaymentPlansPaid = checkAllPaymentPlansPaid(); 
                
                if(allPaymentPlansPaid == false)
                {
                    //this util method will return error message or null
                    ErrorMsg = IIT_CreateOrderBussinessClass.validateQuoteDetails(myQuote);
                }
            }                     
        }          
    } 
    
    public void onPageLoad() {  
        // verify it has a error message, if it has then update the Create Order status of Quote to blank
        // if it has a error don't show the create order and process buttons
        if(ErrorMsg != null) {
            showbuttons = false;
            IIT_CreateOrderUtilClass.updateQuote(myQuote, myQuote.SBQQ__Status__c, '');    
        }    
    }  
    
    public boolean showbuttons {get; set; }
    public boolean allPaymentPlansPaid {get; set; }
    public string sPaymentPlansPaid {get; set;}
    
    public boolean checkAllPaymentPlansPaid() {
        list< invoiceit_s__Payment_Plan_Installment__c > trans;
        list<invoiceit_s__Payment_Plan_Installment__c> updateInstallment = new list <invoiceit_s__Payment_Plan_Installment__c > ();
        
        updateInstallment = [SELECT Id 
                             FROM invoiceit_s__Payment_Plan_Installment__c 
                             WHERE QTC__Quote__c =:myQuote.Id 
                             AND 
                             Min_Down_Payment__c = true 
                             AND 
                             invoiceit_s__Payment_Type__c != 'COA'];
        
        trans = [SELECT invoiceit_s__Payment__c 
                 FROM invoiceit_s__Payment_Plan_Installment__c 
                 WHERE Id IN :updateInstallment
                 AND
                 invoiceit_s__Payment__c != null
                 ];
        
        sPaymentPlansPaid = ' install size is ' + updateInstallment.size() + ' Transcation size is ' + Trans.size() ;
        
        if(myQuote.QTC__Payment_Plan__r.Name == 'Bill Later Payment Plan' || myquote.Subscription__c == true)
        {
            return true;
        }
        else if(updateInstallment.size() == Trans.size()) 
        {
            showGreen = true;
            ErrorMsg = 'All the payments have been processed, please click on Process Order button';
            return true;
        } 
        return false;
    }
    
    public PageReference processOrder() { 
        if(myQuote.QTC__Payment_Plan__r.Name == 'Bill Later Payment Plan' || myQuote.Subscription__c == true){
            createDirectOrder();    
        } else {
            createOrderForDownPayment();
        } 
        return null;
    }
    
    // used for processing the payments
    public PageReference processPayments() {   
        //create a list of Transactions, then populate in the payment plan installment loop below
        list<invoiceit_s__Payment__c> listOfExistingPayments = new list<invoiceit_s__Payment__c>();
        list<invoiceit_s__Payment__c> listOfPaymentsInProcessPayments = new list<invoiceit_s__Payment__c>();
        map<Id,invoiceit_s__Transaction__c> PPIwTrans = new map<Id,invoiceit_s__Transaction__c>();
        list<invoiceit_s__Transaction__c> Trans = new list <invoiceit_s__Transaction__c>();
        list<invoiceit_s__Payment_Plan_Installment__c> updateInstallment = new list <invoiceit_s__Payment_Plan_Installment__c>(); 
        list<invoiceit_s__Payment_Plan_Installment__c> paymentPlanDeclinedList = new list <invoiceit_s__Payment_Plan_Installment__c>();
        set<id> setOfPaymentMethodIdsInProcessPayment = new set<id>();
        set<id> setOFinstallmentIds = new set<id>();
        
        integer allprocessed = 0;
        boolean updateQuote = false;
        invoiceit_s__Transaction__c localTrans;
               
        // query the installments at run time since they may click this button twice. So get the latest values
        list<invoiceit_s__Payment_Plan_Installment__c> installmentsInProcessPayments = IIT_CreateOrderUtilClass.queryInstallments(myQuote);
                  
        // loop over the installments
        for(invoiceit_s__Payment_Plan_Installment__c PPIgetPaymethod : installmentsInProcessPayments) {
            
            /*if((PPIgetPaymethod.invoiceit_s__Payment_Type__c == 'Credit Card' || PPIgetPaymethod.invoiceit_s__Payment_Type__c == 'ACH'))
               
            {
                ErrorMsg = 'For the Payment Plan Installment # : ' + PPIgetPaymethod.Name + ' Payment Method field is blank. Please select the Payment Method on the installment';  
                IIT_CreateOrderUtilClass.updateQuote(myQuote, myQuote.SBQQ__Status__c, ErrorMsg);                  
                return null;   
            }*/
            
            if(PPIgetPaymethod.transacted__c == false && PPIgetPaymethod.invoiceit_s__Payment_Method__c != null) {
                setOfPaymentMethodIdsInProcessPayment.add(PPIgetPaymethod.invoiceit_s__Payment_Method__c);
            }
            
            if(PPIgetPaymethod.Min_Down_Payment__c == true && PPIgetPaymethod.transacted__c == false
                && PPIgetPaymethod.invoiceit_s__Payment_Type__c == 'COA')
            {
                if(myquote.SBQQ__Account__r.invoiceit_s__Total_Unallocated_Payment__c < PPIgetPaymethod.invoiceit_s__Payment_Amount__c){
                    ErrorMsg = 'Payment Amount is less than the account outstanding balance';  
                    IIT_CreateOrderUtilClass.updateQuote(myQuote, myQuote.SBQQ__Status__c, ErrorMsg);                  
                    return null;
                } 
            }
        }
        
        // Laxman to write code for populating the payment method
        Map<Id, invoiceit_s__Payment_Method__c> map_id_paymentid = IIT_CreateOrderUtilClass.getPaymentMethods(setOfPaymentMethodIdsInProcessPayment);
        
        // get the currency before we use to prevent the Row Lock issues
        list<invoiceit_s__Currency__c> currencies = IIT_CreateOrderUtilClass.getCurrency();
        
        // get the payment gateways
        map<String,invoiceit_s__Gateway__c> map_type_gatewayId = IIT_CreateOrderUtilClass.getGatewayByType();
                    
         //loop through installments with downpayments
        for (invoiceit_s__Payment_Plan_Installment__c PPIwithDownpayment : installmentsInProcessPayments) { 
            System.debug('Looping Installments');
            setOFinstallmentIds.add(PPIwithDownpayment.id);
            // check if any existing transactions are present where Payment may or may not be created
            if(PPIwithDownpayment.Transactions__r.size() == 0 && PPIwithDownpayment.transacted__c == false) {
            
                if(PPIwithDownpayment.Tra_Type__c != null) 
                {
                    System.debug('Inside Type Not null');
                    localTrans = new invoiceit_s__Transaction__c();
                    localTrans.invoiceit_s__Amount__c = PPIwithDownpayment.invoiceit_s__Payment_Amount__c;
                    localTrans.invoiceit_s__Payment_Gateway__c = PPIwithDownpayment.Tra_Payment_Gateway__c;
                    localTrans.invoiceit_s__Payment_Method__c =  PPIwithDownpayment.invoiceit_s__Payment_Method__c;
                    localTrans.invoiceit_s__Currency__c = PPIwithDownpayment.Tra_Currency__c;
                    localTrans.invoiceit_s__Type__c = PPIwithDownpayment.Tra_Type__c;
                    localTrans.invoiceit_s__Response_Status__c  = PPIwithDownpayment.Tra_Response_Status__c;
                    localTrans.invoiceit_s__Gateway_ID__c = PPIwithDownpayment.Tra_Response_Gateway_ID__c;
                    localTrans.invoiceit_s__Is_Payment_Processed_Successfully__c= true;
                    localTrans.payment_plan_installment__c = PPIwithDownpayment.id;
                    localTrans.invoiceit_s__Request_Transaction_Type__c =  PPIwithDownpayment.Tra_Type__c;
                    localTrans.invoiceit_s__Request_Type_Of_Payment__c =  PPIwithDownpayment.invoiceit_s__Payment_Method__r.invoiceit_s__Payment_Method__c;
                    localTrans.invoiceit_s__Request_Credit_Card_Number__c= PPIwithDownpayment.Tra_Credit_Card_Number__c;
                    localTrans.invoiceit_s__Card_Expiration_Month__c = PPIwithDownpayment.invoiceit_s__Payment_Method__r.invoiceit_s__Card_Expiration_Month__c;
                    localTrans.invoiceit_s__Card_Expiration_Year__c = PPIwithDownpayment.invoiceit_s__Payment_Method__r.invoiceit_s__Card_Expiration_Year__c;
                    localTrans.invoiceit_s__Card_Type__c = PPIwithDownpayment.invoiceit_s__Payment_Method__r.invoiceit_s__Card_Type__c;
                    localTrans.Re_Processed_By__c = 'Create Order';
                    localTrans.invoiceit_s__Authorization__c = 'ACCEPT';
                    PPIwTrans.put(PPIwithDownpayment.id, localTrans);
                }
                
                if (    map_id_paymentid.containskey(PPIwithDownpayment.invoiceit_s__Payment_Method__c)  
                        && PPIwithDownpayment.Min_Down_Payment__c == true 
                        && PPIwithDownpayment.transacted__c == false
                        && PPIwithDownpayment.Tra_Type__c == null
                   )  
                {
                    
                    System.debug('Type is null');
                    invoiceit_s.PaymentSiteOperation site = new invoiceit_s.PaymentSiteOperation();
                    invoiceit_s.PaymentSiteOperation.GenericPaymentParameters genericPaymentParameters = new invoiceit_s.PaymentSiteOperation.GenericPaymentParameters();
                    if(map_type_gatewayId.containskey(PPIwithDownpayment.invoiceit_s__Payment_Type__c))
                    {
                        genericPaymentParameters.gateway = map_type_gatewayId.get(PPIwithDownpayment.invoiceit_s__Payment_Type__c); 
                    }
                    else
                    {
                        ErrorMsg = 'Payment gateway is not configured.';
                        // call the update Quote method to update the QUote.Create Order Status to blank
                        IIT_CreateOrderUtilClass.updateQuote(myQuote, myQuote.SBQQ__Status__c, ErrorMsg);
                        return null;
                    }

                    genericPaymentParameters.amountToProcess = PPIwithDownpayment.invoiceit_s__Payment_Amount__c;
                    genericPaymentParameters.currencyISOCode = 'USD'; 
                    genericPaymentParameters.paymentMethod = map_id_paymentid.get(PPIwithDownpayment.invoiceit_s__Payment_Method__c);//paymentMethodActive[0]; 
                    genericPaymentParameters.shouldTokenizeCard = false; 

                    invoiceit_s.PaymentSiteOperation.GenericPaymentResult genericPaymentResult = new invoiceit_s.PaymentSiteOperation.GenericPaymentResult();        
                    genericPaymentResult = site.processGenericPayment(genericPaymentParameters); 
                    system.debug('ErrorMsg 123==>>'+ErrorMsg);
                    genericPaymentResult.transactionObj.payment_plan_installment__c = PPIwithDownpayment.id;
                    genericPaymentResult.transactionObj.invoiceit_s__Payment_Method__c = PPIwithDownpayment.invoiceit_s__Payment_Method__c;
                    genericPaymentResult.transactionObj.invoiceit_s__Payment_Gateway__c = genericPaymentParameters.gateway.id; 
                    genericPaymentResult.transactionObj.invoiceit_s__Currency__c = currencies[0].id;
                    if (genericPaymentResult.isSuccess == True) 
                    {         
                        // CC/ACH process payment is success
                        allprocessed = allprocessed + 1;  
                        genericPaymentResult.transactionObj.invoiceit_s__Is_Payment_Processed_Successfully__c = true;
                    }
                    else 
                    {                        
                        // CC/ACH process payment is declined by Cybersource
                        updateQuote = true;
                        if(ErrorMsg == null) {
                            ErrorMsg = '';
                        }
                        ErrorMsg += 'Payment has not been processed for Payment Plan Installment # :  ' + PPIwithDownpayment.Name  + ', payment is declined by Cybersource and Please see error message from Cybersource : "' + genericPaymentResult.message + '". Possible reasons are Card is Expired or Token is Invalid or No funds on Credit Card. Please validate payment method or create a new Payment Method. Once validated, hit Create Order button again<br><br>'; 
                        PPIwithDownpayment.Cybersource_Error_Status__c = 'Payment Declined';
                        paymentPlanDeclinedList.add(PPIwithDownpayment);
                    }
                    PPIwTrans.put(PPIwithDownpayment.id, genericPaymentResult.transactionObj);
                }
            } 
            else 
            {
                // there is a existing approved transactions so we should not process again and transactions may or may not have payment.
                PPIwTrans.put(PPIwithDownpayment.id, PPIwithDownpayment.Transactions__r[0]);
            }
        }  
        TransactionOK = allprocessed + '  transactions succeeded'; 
        String statusOfTrans;
        try 
        {
            System.debug(' Error Message ' + ErrorMsg);
            statusOfTrans = 'Before Transactions Insert';
            // upsert transaction regardless of failure or success
            upsert PPIwTrans.values();
                            
            statusOfTrans = 'Before Payment Insert';
            
            //This query for the to avoid the create duplicate payment 
            map<Id,invoiceit_s__Transaction__c> mapOfTransaction = new map<Id,invoiceit_s__Transaction__c>([SELECT invoiceit_s__Response_Status__c,invoiceit_s__Amount__c,invoiceit_s__Currency__c,invoiceit_s__Is_Payment_Processed_Successfully__c,invoiceit_s__Payment_Method__c,
                                                                    invoiceit_s__Request_Invoice__c,invoiceit_s__Request_Transaction_Type__c,invoiceit_s__Request_Type_Of_Payment__c,
                                                                    (SELECT invoiceit_s__Status__c,id,invoiceit_s__Currency__c,invoiceit_s__Account__c,invoiceit_s__Allocated_Amount__c,
                                                                    invoiceit_s__Amount__c,invoiceit_s__Unallocated_Amount__c,invoiceit_s__Transaction__c
                                                                    FROM invoiceit_s__Payments__r)
                                                                    FROM 
                                                                    invoiceit_s__Transaction__c WHERE Id =: PPIwTrans.values()]);
            
            list<invoiceit_s__Payment_Plan_Installment__c > listOfInsUpdate = new list <invoiceit_s__Payment_Plan_Installment__c > ();
            map<id,id> map_transid_paymentInsID = new map<id,id>();
            
            
            for(invoiceit_s__Transaction__c transObj : PPIwTrans.values()){
                // get the transaction from the map and verify existing payment is present or not
                invoiceit_s__Transaction__c existingTransaction = mapOfTransaction.get(transObj.Id);
                if(transObj.invoiceit_s__Is_Payment_Processed_Successfully__c == true && existingTransaction.invoiceit_s__Payments__r.size() == 0){
                    invoiceit_s__Payment__c createPay = new invoiceit_s__Payment__c(); 
                    createPay.invoiceit_s__Account__c =  myQuote.SBQQ__Account__c  ;
                    createpay.invoiceit_s__Payment_Date__c=system.today();
                    createPay.invoiceit_s__Transaction__c = transObj.id ;
                    if(transObj.invoiceit_s__Request_Type_Of_Payment__c == 'eCheck'){
                        createPay.invoiceit_s__Payment_Type__c = 'ACH'; 
                    }else{
                        createPay.invoiceit_s__Payment_Type__c = transObj.invoiceit_s__Request_Type_Of_Payment__c ; 
                    }

                    createPay.invoiceit_s__Amount__c = transObj.invoiceit_s__Amount__c <>null ? transObj.invoiceit_s__Amount__c : 0;
                    createPay.invoiceit_s__Currency__c = currencies[0].id; 
                    listOfPaymentsInProcessPayments.add(createPay);
                } else if(transObj.invoiceit_s__Is_Payment_Processed_Successfully__c == true) {
                    listOfExistingPayments.add(existingTransaction.invoiceit_s__Payments__r[0]);    
                }
                
                // populate the map, it's used for populating the payment on payment plan installment
                map_transid_paymentInsID.put(transObj.id,transObj.Payment_Plan_Installment__c);
            }
            insert listOfPaymentsInProcessPayments;
            
            // add the existing payments
            listOfPaymentsInProcessPayments.addAll(listOfExistingPayments);
            
            statusOfTrans = 'Before PPI Update';
            System.debug('Payments processed = '+listOfPaymentsInProcessPayments);
            for(invoiceit_s__Payment__c payment : listOfPaymentsInProcessPayments){
                if(payment.invoiceit_s__Transaction__c != null && map_transid_paymentInsID.containskey(payment.invoiceit_s__Transaction__c)){
                    invoiceit_s__Payment_Plan_Installment__c insPayment = new invoiceit_s__Payment_Plan_Installment__c();
                    insPayment.id =  map_transid_paymentInsID.get(payment.invoiceit_s__Transaction__c);
                    insPayment.transacted__c = true;  
                    insPayment.invoiceit_s__Payment__c = payment.Id; 
                    insPayment.invoiceit_s__Transaction__c = payment.invoiceit_s__Transaction__c;
                    insPayment.Cybersource_Error_Status__c = null;
                    updateInstallment.add(insPayment); 
                }
            }
            update updateInstallment;
            allPaymentPlansPaid = checkAllPaymentPlansPaid();
   
            // if updateQuote is true which means one of the payment is declined by Cybersource, so show the error message and update the Quote
            if(updateQuote == true) {
                IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Submitted', ErrorMsg); 
                
                // update the failed installment records
                update paymentPlanDeclinedList;
            } else {  
                showGreen = true;
                ErrorMsg = 'All the payments have been processed, please click on Process Order button';
                IIT_CreateOrderUtilClass.updateQuote(myQuote, myQuote.SBQQ__Status__c, ErrorMsg);                 
            }
        }
        catch (exception ex) {
            ErrorMsg = null;
            if(statusOfTrans == 'Before Transactions Insert') {                
                // populate the error message
                ErrorMsg = IIT_CreateOrderBussinessClass.populateExceptionMessage(ex, 'Transaction is processed & approved in Cybersource but response is not captured in Salesforce. Please click on Process Payment button again to capture data in Salesforce.<br>');
                
                system.debug('ErrorMsg ' + ErrorMsg);
                // Transactions were processed in Cybersource but transaction response is not created in Salesforce.
                // Update the respective Payment Plan Installment, saying Transaction is not created & Update Quote saying same message.         
                list<invoiceit_s__Payment_Plan_Installment__c> installmentsToUpdate = new list<invoiceit_s__Payment_Plan_Installment__c>();
                for(Id paymentPlanId : PPIwTrans.KeySet()) {
                    invoiceit_s__Transaction__c trans1 = PPIwTrans.get(paymentPlanId);    
                    if(trans1.invoiceit_s__Response_Status__c == 'Approved') {
                        // Naveen to write the logic 
                        System.debug('Naveen Exception');
                        invoiceit_s__Payment_Plan_Installment__c installmentToUpdate = new invoiceit_s__Payment_Plan_Installment__c(id = paymentPlanId);                             
                        //populate all the required fields
                        installmentToUpdate.Cybersource_Error_Status__c = ErrorMsg;
                        installmentToUpdate.Tra_Type__c = trans1.invoiceit_s__Type__c;
                        installmentToUpdate.Tra_Response_Status__c = trans1.invoiceit_s__Response_Status__c ;
                        installmentToUpdate.Tra_Response_Gateway_ID__c = trans1.invoiceit_s__Gateway_ID__c  ;
                        installmentToUpdate.Tra_Payment_Gateway__c = trans1.invoiceit_s__Payment_Gateway__c   ;
                        installmentToUpdate.Tra_Currency__c = trans1.invoiceit_s__Currency__c;
                        installmentToUpdate.Tra_Credit_Card_Number__c = trans1.invoiceit_s__Request_Credit_Card_Number__c;
                        // Naveen to add one field One field Created From? Create Order, Force.com
                        // second field Transaction Reprocessed?
                        installmentsToUpdate.add(installmentToUpdate);
                    }
                }
                update installmentsToUpdate;
                allPaymentPlansPaid = checkAllPaymentPlansPaid();
                
                // populate the exception message in Quote.
                IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Submitted', ErrorMsg); 
            }
            
            if(statusOfTrans == 'Before Payment Insert') {
                // populate the error message, Transactions are inserted but, Payments are not insert
                ErrorMsg = IIT_CreateOrderBussinessClass.populateExceptionMessage(ex, 'Cybersource Transaction has been processed successfully. However, only transaction record has been created in SalesForce. Please click on Process Payment button again.<br>');
                
                // populate the exception message
                IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Submitted', ErrorMsg);         
            }
            
            if(statusOfTrans == 'Before PPI Update') {
                // populate the error message
                ErrorMsg = IIT_CreateOrderBussinessClass.populateExceptionMessage(ex, 'Cybersource Transaction has been processed successfully. However, Payment Plan Installment details cannot be updated in Salesforce. Please click on Process Payment button again to date Salesforce payment plan installment records.<br>');
                // Payments are inserted but, PPI are not updated
                // Update the respective Transactions, saying PPI is not updated & Update Quote saying same message. 
                
                // populate the exception message
                IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Submitted', ErrorMsg);    
            }
            
            if(ErrorMsg == null) {
                // update the Quote with exception
                // populate the error message
                ErrorMsg = IIT_CreateOrderBussinessClass.populateExceptionMessage(ex, '');
                
                // populate the exception message
                IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Submitted', ErrorMsg);
            }
        }
        
        allPaymentPlansPaid = checkAllPaymentPlansPaid();
        
        //ErrorMsg = '';    
        return null;
    } 
    
    // universal method for updating the Opp and creating order
    public void updateOppToCreateOrderInvoice() {
        // verify on the Opp if create order = true, if it's true then throw an error
        // verify on the Opp if Primary Quote field is not blank
        ErrorMsg = IIT_CreateOrderBussinessClass.validateOpportunityDetails(myQuote);
        system.debug('Error message : ' + ErrorMsg);
        
        if(ErrorMsg == null) {
            //Here, If you check the subscription check box on the Quote we are creating the order and invoice directly.Below is the logic for that
            //front end will indicate which scenario. If blank or any error just assume scenario 1  
            //Until CCH provides the indicator we will always assume scenario1 and always assume success
            IIT_PID_CID_check.output op =  IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(null, null, null, myQuote.SBQQ__Account__c)  ;
             
            if (op.oStatus != 'Success') {
                IncrementStatus = ' ' + op.oErrorMsg;   //according to Doug if CID/PID parts fail just make it scenario1 and force it through
            } 
    
            //according to Doug  just force the flow to continue  --  
            op.oStatus='Success'; 
            if (IncrementStatus=='') IncrementStatus = 'CID and PID assigned successfully';
                
            opportunity opp = new opportunity(Id = myQuote.SBQQ__Opportunity2__c);
            opp.QTC__Create_Order__c = true;
            opp.StageName = 'Commitment';
            update opp;
            System.debug('Opportuntiy updated ===');
            Id oppId;
            if(myQuote.SBQQ__MasterContract__c != null) {
                oppId = myQuote.SBQQ__MasterContract__r.SBQQ__Quote__r.SBQQ__Opportunity2__c;
            } else {
                oppId = myQuote.SBQQ__Opportunity2__c;
            }
            
            createdOrder = [SELECT invoiceit_s__Create_Invoice_Automatically__c,invoiceit_s__Start_Date__c
                            FROM invoiceit_s__Job__c 
                            WHERE QTC__Opportunity__c = : oppId];
            System.debug('createdOrdercreatedOrder --->'+createdOrder);
            
            if (createdOrder.size() > 0) {
                // order is created
                OrderID = createdOrder[0].Id; 
                
                // Laxman to add logic, for the where clause
                list<invoiceit_s__Invoice__c> createdInvoice;
                createdInvoice = [SELECT Id,invoiceit_s__Order__c,Name,invoiceit_s__CurrencyL__c, invoiceit_s__Total_Invoice_Value__c
                                  FROM invoiceit_s__Invoice__c 
                                  WHERE invoiceit_s__Order__c = : OrderID 
                                  ORDER BY Name DESC NULLS LAST];
        
                if (createdInvoice.size() > 0) {
                    invoiceID = createdInvoice[0].id ;
                } else {
                    // invoice is not created
                    // Laxman to add logic
                    showGreen = false;
                    ErrorMsg = 'Invoice is not being created, may be Order do not have products to invoice. Please click on Process Order';
                    
                    // call the util method to update the Quote with error message
                    IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Submitted', ErrorMsg);
                } 
            
            } else {
                // order is not created
                // Laxman to add logic
                /*8Opportunity oppUpdate = [SELECT QTC__Exception_Message__c
                                         FROM Opportunity
                                         WHERE Id =: oppId
                                         ];
                
                if(oppUpdate.QTC__Exception_Message__c != null) {
                    ErrorMsg = 'There was an error while creating the Order & Invoice, Please click on Process Order. <br><br> Error details : ' + oppUpdate.QTC__Exception_Message__c;
                } else {
                    ErrorMsg = 'Order is not being created, may be Quote do not have any products or Quote/Quote Products data is incorrect. Please click on Process Order';
                } */
                ErrorMsg = 'Order is not being created, may be Quote do not have any products or Quote/Quote Products data is incorrect. Please click on Process Order';
                showGreen = false;
                
                // call the util method to update the Quote with error message
                IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Submitted', ErrorMsg);
            }
        }    
    }
    
    // method called when the Quote is a non subscription
    //Create Order Normal process after payment Sucess 

    public pagereference createOrderForDownPayment() {
        Savepoint sp;
        set<id> setOfDownPaymentIds = new set<id>();
        decimal originalAmount ;
        
        try {
        if(myQuote.QTC__Order__c == null){                         
            list<invoiceit_s__Payment__c> listOfPayments = [SELECT name,invoiceit_s__Amount__c,invoiceit_s__Unallocated_Amount__c 
                                                            FROM invoiceit_s__Payment__c
                                                            WHERE invoiceit_s__Account__c =:  myQuote.SBQQ__Account__c
                                                            AND invoiceit_s__Unallocated_Amount__c > 0 
                                                            AND  
                                                            invoiceit_s__Status__c = 'Completed'
                                                            ORDER BY CreatedDate
                                                            ];
            sp = Database.setSavepoint();
            
            // below method will update the Opportunity to create the order & Invoice.
            ErrorMsg = '';
            updateOppToCreateOrderInvoice();
            
            // some times SB package will populate the error message in Opportunity where we call Create Order = true
            if(ErrorMsg != null && ErrorMsg != '' && !Test.isRunningTest()) {
                return null;
            }
            
            // get the installments
            list<invoiceit_s__Payment_Plan_Installment__c> PPI = IIT_CreateOrderUtilClass.queryInstallments(myQuote);
                    
            // loop over the installments to populate the invoice id
            // if there is any COA we are initilaizing the COA installment
            invoiceit_s__Payment_Plan_Installment__c instalmentPPICOA;
            for(invoiceit_s__Payment_Plan_Installment__c  instalmentPPI : PPI){
                instalmentPPI.invoiceit_s__Invoice__c = invoiceID;
                if(instalmentPPI.Min_Down_Payment__c == true) {
                    setOfDownPaymentIds.add(instalmentPPI.Id);
                }
                if(instalmentPPI.invoiceit_s__Payment_Type__c == 'COA'){
                    instalmentPPICOA = new invoiceit_s__Payment_Plan_Installment__c();
                    instalmentPPICOA = instalmentPPI;
                }  
            }
            update PPI;

            list<invoiceit_s__Transaction__c> allTxns = [SELECT id,invoiceit_s__Exception_Message__c,
                                                          invoiceit_s__Amount__c,payment_plan_installment__c,
                                                          invoiceit_s__Request_Invoice__c,payment_plan_installment__r.invoiceit_s__Payment__c,
                                                          payment_plan_installment__r.invoiceit_s__Payment__r.invoiceit_s__Amount__c
                                                          FROM invoiceit_s__Transaction__c 
                                                          WHERE invoiceit_s__Is_Payment_Processed_Successfully__c = true 
                                                          AND
                                                          payment_plan_installment__c in: setOfDownPaymentIds]; 
            
            System.debug('All the Tranaction '+allTxns);                                                         
            Decimal paidAmount = 0; 
            list<invoiceit_s__Payment_Allocation__c> listAllocationToUpdate = new list<invoiceit_s__Payment_Allocation__c>();
            for (invoiceit_s__Transaction__c txnToPayment : allTxns)  {
                txnToPayment.invoiceit_s__Request_Invoice__c = invoiceID;   
                if(txnToPayment.payment_plan_installment__r.invoiceit_s__Payment__c != null){
                    invoiceit_s__Payment_Allocation__c paymentAllocation = new invoiceit_s__Payment_Allocation__c();
                    paymentAllocation.invoiceit_s__Amount__c = txnToPayment.invoiceit_s__Amount__c <>null ? txnToPayment.invoiceit_s__Amount__c : 0 ;
                    paymentAllocation.invoiceit_s__Invoice__c = invoiceID;
                    paymentAllocation.invoiceit_s__Payment__c = txnToPayment.payment_plan_installment__r.invoiceit_s__Payment__c;
                    paymentAllocation.invoiceit_s__Status__c = 'Completed';
                    listAllocationToUpdate.add(paymentAllocation);

                    paidAmount += paymentAllocation.invoiceit_s__Amount__c;
                }
            }
            
            // populate & update the invoiceId on the transaction
            update allTxns; 
            
            // insert the payment allocations
            insert listAllocationToUpdate; 

            System.debug('instalmentPPICOAinstalmentPPICOA-->'+instalmentPPICOA);
            if(instalmentPPICOA != null) {
                originalAmount = instalmentPPICOA.invoiceit_s__Payment_Amount__c;
                list<invoiceit_s__Payment_Allocation__c> listOfPaymentAllocations = new list<invoiceit_s__Payment_Allocation__c>();
                invoiceit_s__Payment_Allocation__c paymentAllocation;
                for(invoiceit_s__Payment__c payment : listOfPayments){
                    payment.invoiceit_s__Amount__c = payment.invoiceit_s__Unallocated_Amount__c;
                    if(originalAmount > 0){
                        if(payment.invoiceit_s__Amount__c > 0) {
                            if(payment.invoiceit_s__Unallocated_Amount__c >= originalAmount) {
                                paymentAllocation = new invoiceit_s__Payment_Allocation__c(invoiceit_s__Payment__c = payment.Id,
                                                                                           invoiceit_s__Amount__c = originalAmount,
                                                                                           invoiceit_s__Invoice__c = invoiceID
                                                                                           //invoiceit_s__Payment_Plan_Installment__c = instalmentPPICOA.Id
                                                                                           ); 
                                listOfPaymentAllocations.add(paymentAllocation);  
                                payment.invoiceit_s__Amount__c = payment.invoiceit_s__Amount__c - originalAmount;
                                originalAmount = 0;                               
                            } else {
                                paymentAllocation = new invoiceit_s__Payment_Allocation__c(invoiceit_s__Payment__c = payment.Id,
                                                                                           invoiceit_s__Amount__c = payment.invoiceit_s__Amount__c,
                                                                                           invoiceit_s__Invoice__c = invoiceID 
                                                                                           //invoiceit_s__Payment_Plan_Installment__c = instalmentPPICOA.Id
                                                                                           );
                                                    
                                listOfPaymentAllocations.add(paymentAllocation);  
                                originalAmount = originalAmount - payment.invoiceit_s__Amount__c;  
                                payment.invoiceit_s__Amount__c = 0;                            
                            }
                        }
                    }else {
                        break;
                    }
                } 

                insert listOfPaymentAllocations;
            }
        
            // To create Fullfilment Steps
            IIT_CreateOrderBussinessClass.createFullfilmentSteps(orderId);
            
            //Calling Stage API as requested doug
            handlstg(invoiceID,UserInfo.getSessionID());
            
            //Updating the Quote Status to Invoiced,Once the order and invoice            
            // call the util method to update the Quote with error message
            IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Invoiced', null); 
            showGreen = true;
            
           }/*else {
               OrderID = myQuote.QTC__Order__c;
               list<invoiceit_s__Invoice__c> listofInvocie = [SELECT Id,invoiceit_s__Order__c,Name,invoiceit_s__CurrencyL__c, invoiceit_s__Total_Invoice_Value__c
                          FROM invoiceit_s__Invoice__c 
                          WHERE invoiceit_s__Order__c = : OrderID 
                          ORDER BY Name DESC NULLS LAST];
               invoiceID = listofInvocie[0].id;
            }*/
        }catch(exception ex){
            // roll back the database operations
            Database.rollback(sp);          
            
            // popualte the exception message
            ErrorMsg = IIT_CreateOrderBussinessClass.populateExceptionMessage(ex, 'An exception has occurred, there was an exception while creating the Order and Invoice. Please click on Process Order button again.<br>');
            
            // call the util method to update the Quote with error message
            IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Submitted', ErrorMsg);
        }
        return null;
    }
    
    //Create Direct Order(no need to collect the payments) to Bill Later OR Subscription 
    Public pagereference createDirectOrder(){
        Savepoint sp; 
        try {
            // check if there is any error message
            if(ErrorMsg != null || ErrorMsg == '') {
                return null;
            }
            
            sp = Database.setSavepoint(); 
            
            // below method will update the Opportunity to create the order & Invoice.
            ErrorMsg = '';
            updateOppToCreateOrderInvoice();
            
            // some times SB package will populate the error message in Opportunity where we call Create Order = true 
            if(ErrorMsg != null && ErrorMsg != '') {
                return null;
            }
            
            list<invoiceit_s__Payment_Plan_Installment__c> PPI = IIT_CreateOrderUtilClass.queryInstallments(myQuote);
            
            // populate & update the installments with invoiceId.
            for(invoiceit_s__Payment_Plan_Installment__c  instalmentPPI : PPI){
                instalmentPPI.invoiceit_s__Invoice__c = invoiceID;
            }
            update PPI;
            
            // call the fullfillment steps
            IIT_CreateOrderBussinessClass.createFullfilmentSteps(orderId);
            
            //Calling Stage API as requested doug
            handlstg(invoiceID,UserInfo.getSessionID());
            
            // call the util method to update the Quote with error message
            IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Invoiced', null);
            showGreen = true;
        } catch(exception ex) {
            // roll back the database operations
            Database.rollback(sp);          
            
            // popualte the exception message
            ErrorMsg = IIT_CreateOrderBussinessClass.populateExceptionMessage(ex, 'An exception has occurred, there was an exception while creating the Order and Invoice. Please click on Process Order button again.<br>');
            
            // call the util method to update the Quote with error message
            IIT_CreateOrderUtilClass.updateQuote(myQuote, 'Submitted', ErrorMsg);
        }
        return null;
    }
    
    Public pagereference backToQuote(){
        myQuote.Create_Order_Status__c = null;
        update myQuote;
        return new pagereference('/' + myQuote.Id);
    }


    @future(callout=true)
    public static void handlstg(String invoiceID, String sessionId) {
          System.debug('Session Id in future method====>'+UserInfo.getSessionID());
          System.debug('New Session Id In future'+sessionId);
          System.debug('Future Method and Invoice Id is ===>'+invoiceID);
          HandleStaging stageHandle = new HandleStaging();
          stageHandle.sendStagingData(invoiceID,sessionId);
        
    }
    
    public PageReference processDataToOracle() {
        string smessege = IIT_ProcessDataToExternalSystem.pushDataToExternalform();
        Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, smessege);
        Apexpages.addMessage(infoMessage);
        return null;
    }
}