public class IIT_createOrder_extension {

    private SBQQ__Quote__c myQuote;

    //public variables used on the VF
    public integer PPIcount {get;set;}
    public boolean IncrementOK {get;set;}
    public string TransactionOK  {get;set;}
    public string IncrementStatus  {get;set;}
    public string OrderID  {get;set;}
    public string invoiceID  {get;set;}
    public string ErrorMsg  {get;set;}

    //class var
    string OppID {get;set;}
    string AccID {get;set;}
    string currencyId {get;set;}
    date QuoteStartdate {get;set;}
    date QuoteEnddate {get;set;}
    public boolean isrender{set;get;}
    list <invoiceit_s__Transaction__c> Trans {get;set;}
    list <invoiceit_s__Payment_Plan_Installment__c> PPI {get;set;}
    map <string, string> trxWithPayMethod {get;set;}
    Map<Id, invoiceit_s__Payment_Method__c > map_id_paymentid = new Map<Id, invoiceit_s__Payment_Method__c >();  
    list <string> ppiIDs   {get;set;}
    integer counterWDownpayment {get;set;}

    list<invoiceit_s__Currency__c> lstcurrency;
    public IIT_createOrder_extension(ApexPages.StandardController stdController) { 
        PPIcount=0;
        counterWDownpayment=0;
        isrender = true;

        lstcurrency = [Select Name FROM invoiceit_s__Currency__c where Name = 'USD']; 

        this.myQuote = (SBQQ__Quote__c)stdController.getRecord(); 

        myquote = [select Create_Order_Status__c, Name,Tax_Grand_Total__c,Tax_Time_Stamp__c,Related_Provisioning__r.id,SBQQ__NetAmount__c, SBQQ__Primary__c,SBQQ__Account__c,SBQQ__Account__r.invoiceit_s__Gateway__c,SBQQ__Account__r.invoiceit_s__Gateway__r.invoiceit_s__Gateway_Type__c,
                   SBQQ__Opportunity2__c,SBQQ__EndDate__c,SBQQ__StartDate__c,SBQQ__Account__r.invoiceit_s__Total_Unallocated_Payment__c,iFirm_Product_Included__c 
                   ,tax__c, QTC__Payment_Plan__c, SBQQ__Status__c ,QTC__Payment_Plan__r.Name,SBQQ__MasterContract__r.SBQQ__Quote__r.SBQQ__Opportunity2__c,SBQQ__MasterContract__c, Subscription__c
                   FROM  SBQQ__Quote__c where id=: myQuote.id];         

        AccID = myQuote.SBQQ__Account__c;
        OppID = myQuote.SBQQ__Opportunity2__c;
        QuoteStartdate= myQuote.SBQQ__StartDate__c ;
        QuoteEnddate=myQuote.SBQQ__EndDate__c ;

        if(myquote.Subscription__c!=true){
            //retrieve list of payment plan installments that have downpayment true        
            PPI= [SELECT id,Name  ,invoiceit_s__Payment_Method__c ,invoiceit_s__Payment_Amount__c ,transacted__c,Transaction_Authorization__c,Transaction_Response__c,Trans_Gateway_Date__c,Response_Code__c
                  ,invoiceit_s__Payment_Method__r.invoiceit_s__Payment_Method__c ,Min_Down_Payment__c
                  ,invoiceit_s__Payment_Type__c,QTC__Quote__r.QTC__Payment_Plan__r.Name,invoiceit_s__Payment_Method__r.invoiceit_s__Card_Type__c,invoiceit_s__Payment_Method__r.invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Payment_Method__r.invoiceit_s__Card_Expiration_Month__c,
                  Tra_Type__c,Tra_Response_Status__c,Tra_Response_Gateway_ID__c,Tra_Payment_Gateway__c,Tra_Currency__c,Tra_Credit_Card_Number__c,
                  (SELECT invoiceit_s__Request_Type_Of_Payment__c, invoiceit_s__Amount__c, invoiceit_s__Is_Payment_Processed_Successfully__c, payment_plan_installment__c
                  FROM Transactions__r 
                  WHERE invoiceit_s__Response_Status__c = 'Approved' AND invoiceit_s__Request_Transaction_Type__c = 'Charge')
                  FROM invoiceit_s__Payment_Plan_Installment__c 
                  WHERE  
                  QTC__Quote__c=:myQuote.id];

            //put id and paymentmethod details in here for use later.

            trxWithPayMethod = new  map <string, string> ();     
            PPIcount=PPI.size();
            Trans = new list <invoiceit_s__Transaction__c>();
            
            //put id and paymentmethod details in here for use later.
            set<id> setOfPaymetnMethodids =new set<id>();
            trxWithPayMethod = new  map <string, string> ();
            ppiIDs=new list<string>(); 

            for ( invoiceit_s__Payment_Plan_Installment__c PPIgetPaymethod : PPI ) {
                ppiIDs.add(string.valueof (PPIgetPaymethod.id));  //all installments including those with no downpayment
                if (PPIgetPaymethod.transacted__c ==false) {
                    counterWDownpayment ++;

                    setOfPaymetnMethodids.add(PPIgetPaymethod.invoiceit_s__Payment_Method__c)  ;
                    trxWithPayMethod.put(PPIgetPaymethod.invoiceit_s__Payment_Method__c, PPIgetPaymethod.invoiceit_s__Payment_Method__r.invoiceit_s__Payment_Method__c );
                }       
            } 

            map_id_paymentid = 
                    new Map<Id, invoiceit_s__Payment_Method__c >([SELECT invoiceit_s__Card_Number__c, invoiceit_s__Card_Type__c, invoiceit_s__Card_Expiration_Month__c, invoiceit_s__Card_Expiration_Year__c, invoiceit_s__CVV__c, invoiceit_s__Name_on_Card__c, invoiceit_s__Billing_Country__c,
                                                                  invoiceit_s__Bank_Routing_Code__c, invoiceit_s__Bank_Account_Number__c, invoiceit_s__Bank_Account_Type__c, invoiceit_s__Bank_Name__c, invoiceit_s__Bank_Account_Name__c,
                                                                  invoiceit_s__Billing_First_Name__c, invoiceit_s__Billing_Last_Name__c, invoiceit_s__Billing_Address__c, invoiceit_s__Billing_City__c, invoiceit_s__Billing_State_Province__c, invoiceit_s__Billing_Zip_Postal__c ,
                                                                  invoiceit_s__Account__c, invoiceit_s__Account__r.Name, invoiceit_s__Billing_Phone__c, invoiceit_s__Billing_Fax__c, invoiceit_s__Billing_Email__c,invoiceit_s__Account__r.invoiceit_s__Customer_Profile_ID__c,invoiceit_s__Payment_Profile_ID__c,
                                                                  invoiceit_s__Encrypted_CVV__c,invoiceit_s__Encrypted_Card_Number__c,invoiceit_s__Token__c, invoiceit_s__Payment_Method__c  
                                                                  FROM invoiceit_s__Payment_Method__c 
                                                                  WHERE id in : setOfPaymetnMethodids]); 
        }                
    } 

    public map<String,invoiceit_s__Gateway__c> getGatewayByType(){
        map<String,invoiceit_s__Gateway__c>  map_type_gateway = new map<String,invoiceit_s__Gateway__c> ();

        for(invoiceit_s__Gateway__c gateway : [SELECT Name, invoiceit_s__Merchant_Reference__c, invoiceit_s__Transaction_Security_Key__c,
                                               invoiceit_s__Exact_ID_Security_Key__c, invoiceit_s__Exact_ID__c, 
                                               invoiceit_s__Gateway_Type__c, invoiceit_s__Merchant_ID__c, 
                                               invoiceit_s__Security_Key__c, invoiceit_s__Test_Mode__c, invoiceit_s__Merchant_Seal_User_Id__c,
                                               invoiceit_s__Email_Customer__c
                                               FROM invoiceit_s__Gateway__c
                                               where invoiceit_s__Active__c = true
                                               AND 
                                               invoiceit_s__Default__c = true]){

            map_type_gateway.put('Credit Card',gateway);
            map_type_gateway.put('ACH',gateway);

        }
        return map_type_gateway;
    }

    public PageReference processOrder(){
    
        System.debug('Session Id ====>'+UserInfo.getSessionID());
        list<SBQQ__Quote__c> isorder = [SELECT Create_Order_Status__c,Id,Name,QTC__Order__c,SBQQ__Opportunity2__c 
                                        FROM SBQQ__Quote__c 
                                        WHERE QTC__Order__c != null AND Id = :myQuote.id];
            
        if(isorder.size() > 0 ) {
            isRender = false;
            OrderID = isorder[0].QTC__Order__c; 

            list <invoiceit_s__Invoice__c > createdInvoice = [SELECT id,invoiceit_s__Order__c ,invoiceit_s__CurrencyL__c, invoiceit_s__Total_Invoice_Value__c 
                                                              FROM invoiceit_s__Invoice__c 
                                                              WHERE invoiceit_s__Order__c =: OrderID
                                                              ];
            if(createdInvoice.size() > 0){
                invoiceID =  createdInvoice[0].id;
            }
            
            // call the update Quote method to update the QUote.Create Order Status to blank
            updateQuote();
            return null; 
        } 


        if (myQuote.Tax__c==null ) {
            ErrorMsg = '   Ensure Tax has been calculated.';
            // call the update Quote method to update the QUote.Create Order Status to blank
            updateQuote();
            
            return null;
        }

        if (myQuote.SBQQ__Primary__c == false) {
            ErrorMsg = '   You can create Order only for primary Quote.';
            // call the update Quote method to update the QUote.Create Order Status to blank
            updateQuote();
            
            return null;
        }

        if(myQuote.Tax_Time_Stamp__c == null || myQuote.Tax_Grand_Total__c == null) {
            ErrorMsg = 'Please click on calculate tax button on Quote';
            // call the update Quote method to update the QUote.Create Order Status to blank
            updateQuote();
            
            return null;   
        }

        if(myQuote.Tax_Time_Stamp__c.addHours(24) < system.now()){
            ErrorMsg = 'Order needs to be created with in 24 hours once tax is calculated, please click on calculate tax';
            // call the update Quote method to update the QUote.Create Order Status to blank
            updateQuote();
            
            return null;
        }
        if(myQuote.SBQQ__NetAmount__c != myQuote.Tax_Grand_Total__c){
            ErrorMsg = 'Net Total is not matched Could you please calculate Tax';
            // call the update Quote method to update the QUote.Create Order Status to blank
            updateQuote();
            
            return null;

        }
        if(myQuote.SBQQ__Opportunity2__c == null){
            ErrorMsg = 'Opportunity is not selected on the Quote, please select the Opportunity';
            // call the update Quote method to update the QUote.Create Order Status to blank
            updateQuote();
            
            return null;    
        }
        if(myquote.Subscription__c!=true){
            if (counterWDownpayment == 0) {
                transactionOK = '';
                ErrorMsg = 'There are no Payment Plan Installments with Minimum Down Payment/Minumum Down Payment Plan Installment have already processed';
                // call the update Quote method to update the QUote.Create Order Status to blank
                updateQuote();
            
                return null;
            }   


            /* start direct order creation plan */
            
            
            boolean isExecute = false;
            decimal dCOAmount = 0;
            
             for (invoiceit_s__Payment_Plan_Installment__c PPIs : PPI) {   
            
                if(PPIs.invoiceit_s__Payment_Method__c == null  && PPIs.invoiceit_s__Payment_Type__c != 'COA' && PPIs.invoiceit_s__Payment_Type__c != 'Bill Later' && PPIs.invoiceit_s__Payment_Type__c != 'PO' && PPIs.transacted__c == false){
                        ErrorMsg = 'Payment method is not present on the instalment(s)';
                        // call the update Quote method to update the QUote.Create Order Status to blank
                        updateQuote();
            
                        return null;
                    }
                    
                    }
            for (invoiceit_s__Payment_Plan_Installment__c PPIwithDownpayment : PPI) {   
                if(PPIwithDownpayment.Min_Down_Payment__c == true && PPIwithDownpayment.transacted__c == false
                        && PPIwithDownpayment.invoiceit_s__Payment_Type__c == 'COA'
                       ){
                    if(myquote.SBQQ__Account__r.invoiceit_s__Total_Unallocated_Payment__c >= PPIwithDownpayment.invoiceit_s__Payment_Amount__c){
                        isExecute = true;
                        dCOAmount = PPIwithDownpayment.invoiceit_s__Payment_Amount__c;
                        break;
                    } else{
                        ErrorMsg = 'Amount is less than the account outstanding balance';
                        // call the update Quote method to update the QUote.Create Order Status to blank
                        updateQuote();
            
                        return null;
                    }

                } 
            }  

            /* end of bill later plan */

            /* start direct order creation plan */

            if(isExecute || myQuote.QTC__Payment_Plan__r.Name == 'Bill Later Payment Plan' ){
                //front end will indicate which scenario. If blank or any error just assume scenario 1  
                //Until CCH provides the indicator we will always assume scenario1 and always assume success
                IIT_PID_CID_check.output op =  IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(null, null, null,AccID)  ;
                IncrementStatus=''; 
                if (op.oStatus != 'Success') {
                    IncrementStatus = ' ' + op.oErrorMsg;   //according to Doug if CID/PID parts fail just make it scenario1 and force it through
                } 

                //according to Doug  just force the flow to continue  --  
                op.oStatus='Success'; 
                if (IncrementStatus=='') IncrementStatus = 'CID and PID assigned successfully';
                if (myQuote.SBQQ__Opportunity2__c != null) {
                    Savepoint sp; 
                    try {
                        sp = Database.setSavepoint(); 
                        opportunity opp = new opportunity();
                        opp.id = myQuote.SBQQ__Opportunity2__c;
                        opp.QTC__Create_Order__c = true;
                        opp.CloseDate = System.today();
                        opp.StageName = 'Commitment';
                        update opp;

                        id oppId;
                        if(myQuote.SBQQ__MasterContract__c != null){
                            oppId = myQuote.SBQQ__MasterContract__r.SBQQ__Quote__r.SBQQ__Opportunity2__c;
                        }else{
                            oppId = myQuote.SBQQ__Opportunity2__c;
                        }

                        list <invoiceit_s__Job__c> createdOrder = [SELECT id,invoiceit_s__Create_Invoice_Automatically__c,invoiceit_s__Start_Date__c
                                                                   FROM invoiceit_s__Job__c 
                                                                   WHERE QTC__Opportunity__c = : oppId ] ;

                        if (createdOrder.size() > 0) {
                            OrderID = createdOrder[0].id; 

                            invoiceit_s.CustomInvoiceGenerator invoiceGenerator = new invoiceit_s.CustomInvoiceGenerator();
                            invoiceGenerator.generateInvoiceForOrder(OrderID, myQuote.SBQQ__StartDate__c, myQuote.SBQQ__StartDate__c, false, false, true);
                        }   

                        list <invoiceit_s__Invoice__c > createdInvoice = [SELECT id ,invoiceit_s__CurrencyL__c, invoiceit_s__Total_Invoice_Value__c 
                                                                          FROM invoiceit_s__Invoice__c 
                                                                          WHERE invoiceit_s__Order__c =  : OrderID
                                                                          ];

                        if (createdInvoice.size() > 0) {
                            invoiceID =  createdInvoice[0].id ;
                            currencyId = createdInvoice[0].invoiceit_s__CurrencyL__c  ;
                        }  
                        id paymentisnid;  
                        if(isExecute){
                            list<invoiceit_s__Payment__c> listOfPayments = [select name,invoiceit_s__Amount__c,invoiceit_s__Unallocated_Amount__c from invoiceit_s__Payment__c
                                                                            where invoiceit_s__Account__c =:  myQuote.SBQQ__Account__c
                                                                            AND invoiceit_s__Unallocated_Amount__c > 0 
                                                                            AND  
                                                                            invoiceit_s__Status__c = 'Completed'
                                                                            ORDER BY CreatedDate
                                                                            ];


                            decimal originalAmount = dCOAmount;  

                            list<invoiceit_s__Payment_Allocation__c> listOfPaymentAllocations = new list<invoiceit_s__Payment_Allocation__c>();
                            invoiceit_s__Payment_Allocation__c paymentAllocation;
                            for(invoiceit_s__Payment__c payment : listOfPayments){
                                payment.invoiceit_s__Amount__c = payment.invoiceit_s__Unallocated_Amount__c;
                                if(originalAmount > 0){
                                    if(payment.invoiceit_s__Amount__c > 0) {
                                        if(payment.invoiceit_s__Unallocated_Amount__c >= originalAmount) {
                                            paymentAllocation = new invoiceit_s__Payment_Allocation__c(invoiceit_s__Payment__c = payment.Id,
                                                    invoiceit_s__Amount__c = originalAmount,
                                                    invoiceit_s__Invoice__c = invoiceID); 
                                            listOfPaymentAllocations.add(paymentAllocation);  
                                            payment.invoiceit_s__Amount__c = payment.invoiceit_s__Amount__c - originalAmount;
                                            originalAmount = 0;
                                            paymentisnid = payment.id;
                                        } else {
                                            paymentAllocation = new invoiceit_s__Payment_Allocation__c(invoiceit_s__Payment__c = payment.Id,
                                                    invoiceit_s__Amount__c = payment.invoiceit_s__Amount__c,
                                                    invoiceit_s__Invoice__c = invoiceID
                                                    );

                                            listOfPaymentAllocations.add(paymentAllocation);  
                                            originalAmount = originalAmount - payment.invoiceit_s__Amount__c;  
                                            payment.invoiceit_s__Amount__c = 0;
                                            paymentisnid = payment.id;
                                        }
                                    }
                                }else {
                                    break;
                                }
                            } 

                            insert listOfPaymentAllocations;
                            TransactionOK = 'Success';
                        }

                        //UPDATE all PPInstallments with the Invoice, Order
                        for (invoiceit_s__Payment_Plan_Installment__c paymentToUpdate : PPI){   
                            paymentToUpdate.invoiceit_s__Invoice__c =  createdInvoice[0].id ;
                            paymentToUpdate.invoiceit_s__Order__c = OrderID;
                            if(isExecute && dCOAmount > 0 && paymentisnid != null &&
                                    paymentToUpdate.Min_Down_Payment__c == true 
                                    && paymentToUpdate.transacted__c == false
                                    && paymentToUpdate.invoiceit_s__Payment_Type__c == 'COA'){
                                paymentToUpdate.invoiceit_s__Payment__c= paymentisnid;
                                paymentToUpdate.transacted__c = true;
                            }
                        }
                        update PPI;

                        set<Id> setOfOrderIds = new set<Id>();
                        setOfOrderIds.add(createdOrder[0].id);
                        IIT_CreateOrderchargefulfillment createFulfillment = new IIT_CreateOrderchargefulfillment();
                        createFulfillment.createOrderfulfilment(setOfOrderIds);
                        //below code is called to create the order in staging tables
                       // HandleStaging stageHandle = new HandleStaging();
                        //stageHandle.sendStagingData(invoiceID);
                        handlstg(invoiceID,UserInfo.getSessionID());
                        myQuote.SBQQ__Status__c = 'Approved';
                        myQuote.Exception_Message__c = '';
                        myQuote.Create_Order_Status__c = '';
                        update myQuote;

                        return null;  
                    }catch (exception e) {
                        // Naveen to write the code, write proper exception
                        Database.rollback(sp);
                        system.debug ('ERRORrrrrrrrrr  ' + e);
                        //ErrorMsg = e.getMessage();
                        string exceptionMessage = 'An exception has occurred, Please click on Create Order button again to create the Order & Invoice. ' + e.getMessage()
                                        + ' Line No : ' + e.getLineNumber()
                                        + ' Stack Trace : ' + e.getStackTraceString()
                                        + ' TypeName : ' + e.getTypeName()
                                        + ' Cause : ' + e.getCause();
                        myQuote.SBQQ__Status__c = 'Accepted';
                        myQuote.Create_Order_Status__c = '';
                        myQuote.Exception_Message__c = exceptionMessage;
                        update myQuote;
                        orderID='';
                        invoiceID='';
                        
                        
                        ErrorMsg = exceptionMessage;
                        return null;
                    }  
                }  
            }

            /* end of bill later plan */


            set<id> setOfBillLaterID = new set<id>();

            for (invoiceit_s__Payment_Plan_Installment__c PPIwithDownpayment : PPI) {   
            
               
                if(PPIwithDownpayment.Min_Down_Payment__c == true && PPIwithDownpayment.transacted__c == false){
                    if(PPIwithDownpayment.QTC__Quote__r.QTC__Payment_Plan__r.Name== 'Bill Later Payment Plan'){
                        setOfBillLaterID.add(PPIwithDownpayment.id);
                    }
                    

                    if(PPIwithDownpayment.invoiceit_s__Payment_Type__c != PPIwithDownpayment.invoiceit_s__Payment_Method__r.invoiceit_s__Payment_Method__c && PPIwithDownpayment.invoiceit_s__Payment_Method__c != null){
                        ErrorMsg = 'Payment method and Instalment type is mismatched on the instalment(s)';
                        // call the update Quote method to update the QUote.Create Order Status to blank
                        updateQuote();
            
                        return null;
                    }
                }
            } 

            //create a list of Transactions, then populate in the payment plan installment loop below
            list <invoiceit_s__Transaction__c> Trans = new list <invoiceit_s__Transaction__c>();
            list <invoiceit_s__Payment_Plan_Installment__c > updateInstallment = new list <invoiceit_s__Payment_Plan_Installment__c > ();
            integer allprocessed = 0;

            map <id, invoiceit_s__Transaction__c > PPIwTrans =   new  map <id, invoiceit_s__Transaction__c > ();
            //list <invoiceit_s__Gateway__c> listOfGateway = getlistGateway(AccId);

            map<String,invoiceit_s__Gateway__c> map_type_gatewayId = getGatewayByType();
            set<id> setOFinstallmentIds= new set<id>();
            boolean updateQuote = false;
            //loop through installments with downpayments
            invoiceit_s__Transaction__c localTrans;
            for (invoiceit_s__Payment_Plan_Installment__c PPIwithDownpayment : PPI) { 
                setOFinstallmentIds.add(PPIwithDownpayment.id);
                
                // Naveen to write the logic
                
                
                // check if any existing transactions are present where Payment may or may not be created
                if(PPIwithDownpayment.Transactions__r.size() == 0 && PPIwithDownpayment.transacted__c == false) {
                
                    if(PPIwithDownpayment.Tra_Type__c != null) {
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
                        localTrans.invoiceit_s__Request_Type_Of_Payment__c =  PPIwithDownpayment.invoiceit_s__Payment_Method__r.invoiceit_s__Payment_Method__c ;
                        localTrans.invoiceit_s__Request_Credit_Card_Number__c= PPIwithDownpayment.Tra_Credit_Card_Number__c ;
                        localTrans.invoiceit_s__Card_Expiration_Month__c = PPIwithDownpayment.invoiceit_s__Payment_Method__r.invoiceit_s__Card_Expiration_Month__c;
                        localTrans.invoiceit_s__Card_Expiration_Year__c = PPIwithDownpayment.invoiceit_s__Payment_Method__r.invoiceit_s__Card_Expiration_Year__c;
                        localTrans.invoiceit_s__Card_Type__c = PPIwithDownpayment.invoiceit_s__Payment_Method__r.invoiceit_s__Card_Type__c ;
                        
                        localTrans.invoiceit_s__Gateway_Date__c=PPIwithDownpayment.Trans_Gateway_Date__c;
                        localTrans.invoiceit_s__Authorization__c =PPIwithDownpayment.Transaction_Authorization__c;
                        localTrans.invoiceit_s__Response__c=PPIwithDownpayment.Transaction_Response__c;
                        localTrans.invoiceit_s__Response_Code__c= PPIwithDownpayment.Response_Code__c;

                        PPIwTrans.put(PPIwithDownpayment.id, localTrans);
                    }
                    
                    if (map_id_paymentid.containskey(PPIwithDownpayment.invoiceit_s__Payment_Method__c)  
                            &&   PPIwithDownpayment.Min_Down_Payment__c == true && PPIwithDownpayment.transacted__c == false
                            && PPIwithDownpayment.Tra_Type__c == null)  {
                            System.debug('Type is null');
                        invoiceit_s.PaymentSiteOperation site = new invoiceit_s.PaymentSiteOperation();
                        invoiceit_s.PaymentSiteOperation.GenericPaymentParameters genericPaymentParameters = new invoiceit_s.PaymentSiteOperation.GenericPaymentParameters();
                        if(map_type_gatewayId.containskey(PPIwithDownpayment.invoiceit_s__Payment_Type__c)){
                            genericPaymentParameters.gateway = map_type_gatewayId.get(PPIwithDownpayment.invoiceit_s__Payment_Type__c); 
                        }else{
                            ErrorMsg = ' Payment gateway is not configured.';
                            // call the update Quote method to update the QUote.Create Order Status to blank
                            updateQuote();
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
                        genericPaymentResult.transactionObj.invoiceit_s__Currency__c = lstcurrency[0].id;
                        if (genericPaymentResult.isSuccess == True) {         
                            //PPIwithDownpayment.transacted__c = true;   
                            //updateInstallment.add(PPIwithDownpayment);
                            allprocessed = allprocessed + 1;  
                            genericPaymentResult.transactionObj.invoiceit_s__Is_Payment_Processed_Successfully__c = true;
                        }
                        else {
                            //myQuote.SBQQ__Status__c = 'Submitted';
                            //update myQuote;
                            updateQuote = true;
                            ErrorMsg = allprocessed + ' processed. Error on '  + map_id_paymentid.get(PPIwithDownpayment.invoiceit_s__Payment_Method__c).invoiceit_s__Billing_First_Name__c + map_id_paymentid.get(PPIwithDownpayment.invoiceit_s__Payment_Method__c).invoiceit_s__Billing_Last_Name__c   + ' , '+ genericPaymentResult.message; 
                            TransactionOK =allprocessed + ' processed. Error on '  + map_id_paymentid.get(PPIwithDownpayment.invoiceit_s__Payment_Method__c).invoiceit_s__Billing_First_Name__c + map_id_paymentid.get(PPIwithDownpayment.invoiceit_s__Payment_Method__c).invoiceit_s__Billing_Last_Name__c   + ' , '+ genericPaymentResult.message + ' , Please also ensure tax is present.'; 
                        }
                        PPIwTrans.put(PPIwithDownpayment.id, genericPaymentResult.transactionObj);
                    }
                } else {
                    // there is a existing approved transactions so we should not process again and transactions may or may not have payment.
                    PPIwTrans.put(PPIwithDownpayment.id, PPIwithDownpayment.Transactions__r[0]);
                }
            }  
            system.debug('ErrorMsg==>>'+ErrorMsg);
            TransactionOK = allprocessed + '  transactions succeeded'; 
            String statusOfTrans;
            try {
                System.debug('Transaction are ===>'+PPIwTrans.size());
                statusOfTrans = 'Before Transactions Insert';
                // insert transaction regardless of failure or success
                upsert PPIwTrans.values();
                //Database.upsert(PPIwTrans.values(), false);
                
                if(updateQuote == true) {
                    myQuote.SBQQ__Status__c = 'Submitted';
                    myQuote.Create_Order_Status__c = '';
                    update myQuote;
                }       
                statusOfTrans = 'Before Payment Insert';
                //decimal d = 1100/0;
                //This query for the to avoide the create duplicate payment 
                map<Id,invoiceit_s__Transaction__c> mapOfTransaction = new map<Id,invoiceit_s__Transaction__c>([SELECT Id,invoiceit_s__Amount__c,invoiceit_s__Currency__c,invoiceit_s__Is_Payment_Processed_Successfully__c,invoiceit_s__Payment_Method__c,
                                                                        invoiceit_s__Request_Invoice__c,invoiceit_s__Request_Transaction_Type__c,invoiceit_s__Request_Type_Of_Payment__c,
                                                                        (SELECT invoiceit_s__Status__c,id,invoiceit_s__Currency__c,invoiceit_s__Account__c,invoiceit_s__Allocated_Amount__c,
                                                                        invoiceit_s__Amount__c,invoiceit_s__Unallocated_Amount__c,invoiceit_s__Transaction__c
                                                                        FROM invoiceit_s__Payments__r)
                                                                        FROM 
                                                                        invoiceit_s__Transaction__c WHERE Id =: PPIwTrans.values()]);
                
                list <invoiceit_s__Payment_Plan_Installment__c > listOfInsUpdate = new list <invoiceit_s__Payment_Plan_Installment__c > ();
                map<id,id> map_transid_paymentInsID = new map<id,id>();
                list<invoiceit_s__Payment__c> listOfPayments = new list<invoiceit_s__Payment__c>();
                list<invoiceit_s__Payment__c> listOfExistingPayments = new list<invoiceit_s__Payment__c>();
                
                for(invoiceit_s__Transaction__c transObj : PPIwTrans.values()){
                    // get the transaction from the map and verify existing payment is present or not
                    invoiceit_s__Transaction__c existingTransaction = mapOfTransaction.get(transObj.Id);
                    if(transObj.invoiceit_s__Is_Payment_Processed_Successfully__c == true && existingTransaction.invoiceit_s__Payments__r.size() == 0){
                        invoiceit_s__Payment__c createPay = new invoiceit_s__Payment__c(); 
                        createPay.invoiceit_s__Account__c =  myQuote.SBQQ__Account__c  ;
                        createPay.invoiceit_s__Transaction__c = transObj.id ;
                        createpay.invoiceit_s__Payment_Date__c=system.today();
                        if(transObj.invoiceit_s__Request_Type_Of_Payment__c == 'eCheck'){
                            createPay.invoiceit_s__Payment_Type__c = 'ACH'; 
                        }else{
                            createPay.invoiceit_s__Payment_Type__c = transObj.invoiceit_s__Request_Type_Of_Payment__c ; 
                        }

                        createPay.invoiceit_s__Amount__c = transObj.invoiceit_s__Amount__c <>null ? transObj.invoiceit_s__Amount__c : 0;
                        if(lstcurrency.size() > 0)
                            createPay.invoiceit_s__Currency__c = lstcurrency[0].id; 
                        listOfPayments.add(createPay);
                        map_transid_paymentInsID.put(transObj.id,transObj.Payment_Plan_Installment__c);
                    } else if(transObj.invoiceit_s__Is_Payment_Processed_Successfully__c == true) {
                        listOfExistingPayments.add(existingTransaction.invoiceit_s__Payments__r[0]);    
                    }
                }
                insert listOfPayments;
                
                // add the existing payments
                listOfPayments.addAll(listOfExistingPayments);
                
                statusOfTrans = 'Before PPI Update';
                System.debug('Payemtnts ===>443'+listOfPayments);
                for(invoiceit_s__Payment__c payment : listOfPayments){
                    if(payment.invoiceit_s__Transaction__c != null && map_transid_paymentInsID.containskey(payment.invoiceit_s__Transaction__c)){
                        invoiceit_s__Payment_Plan_Installment__c insPayment = new invoiceit_s__Payment_Plan_Installment__c();
                        insPayment.id =  map_transid_paymentInsID.get(payment.invoiceit_s__Transaction__c);
                        insPayment.transacted__c = true;  
                        insPayment.invoiceit_s__Payment__c = payment.id; 
                        updateInstallment.add(insPayment); 
                    }
                }
                update updateInstallment;
            }
            catch (exception e) {
                System.debug('Exception Block===>443');
                string exceptionMessage = 'An exception has occurred, Please contact your system Admin. ExMessage : ' + e.getMessage()
                                        + ' /n Line No : ' + e.getLineNumber()
                                        + ' /n Stack Trace : ' + e.getStackTraceString()
                                        + ' /n TypeName : ' + e.getTypeName()
                                        + ' /n Cause : ' + e.getCause();
                
                // set the default exception
                myQuote.Exception_Message__c =  Errormsg + exceptionMessage;
                
                if(statusOfTrans == 'Before Transactions Insert') {
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
                            installmentToUpdate.Cybersource_Error_Status__c = 'Transaction is processed & approved in Cybersource but response is not captures in Salesforce. Please click on Create Order button again to create the Order & Invoice. /n' + exceptionMessage;
                            installmentToUpdate.Tra_Type__c = trans1.invoiceit_s__Type__c;
                            installmentToUpdate.Tra_Response_Status__c = trans1.invoiceit_s__Response_Status__c ;
                            installmentToUpdate.Tra_Response_Gateway_ID__c = trans1.invoiceit_s__Gateway_ID__c  ;
                            installmentToUpdate.Tra_Payment_Gateway__c = trans1.invoiceit_s__Payment_Gateway__c   ;
                            installmentToUpdate.Tra_Currency__c= trans1.invoiceit_s__Currency__c;
                            installmentToUpdate.Tra_Credit_Card_Number__c = trans1.invoiceit_s__Request_Credit_Card_Number__c;
                            
                            installmentToUpdate.Transaction_Authorization__c=trans1.invoiceit_s__Authorization__c;
                            installmentToUpdate.Transaction_Response__c= trans1.invoiceit_s__Response__c;
                            installmentToUpdate.Trans_Gateway_Date__c=trans1.invoiceit_s__Gateway_Date__c;
                            installmentToUpdate.Response_Code__c=trans1.invoiceit_s__Response_Code__c;
                            
                            installmentsToUpdate.add(installmentToUpdate);
                        }
                    }
                    update installmentsToUpdate;
                    
                    // populate the exception message in Quote.
                    myQuote.Exception_Message__c = 'Transaction is processed & approved in Cybersource but response is not captures in Salesforce. Please click on Create Order button again to create the Order & Invoice.' + exceptionMessage;
                    myQuote.Create_Order_Status__c = '';
                    update myQuote;
                    
                    exceptionMessage = 'Transaction is processed & approved in Cybersource but response is not captures in Salesforce. Please click on Create Order button again to create the Order & Invoice.' + exceptionMessage;
                    ErrorMsg = exceptionMessage;
                }
                
                if(statusOfTrans == 'Before Payment Insert') {
                    // Transactions are inserted but, Payments are not insert
                    // Update the respective Transactions, saying Payment is not created & Update Quote saying same message.
                    list<invoiceit_s__Transaction__c> listOfTrans = new list<invoiceit_s__Transaction__c>();
                    for(invoiceit_s__Transaction__c transObj : PPIwTrans.values()){
                        exceptionMessage = 'Transaction is processed & created in Salesforce and there was an error while creating the Payment in Salesforce, Please click on Create Order button again to create the Order & Invoice.' + exceptionMessage;
                        transObj.invoiceit_s__Exception_Message__c  = exceptionMessage;
                        listOfTrans.add(transObj);
                    }
                    update listOfTrans;
                    myQuote.Exception_Message__c = exceptionMessage;
                    myQuote.Create_Order_Status__c = '';
                    update myQuote;
                    ErrorMsg = exceptionMessage;
                }
                
                if(statusOfTrans == 'Before PPI Update') {
                    // Payments are inserted but, PPI are not updated
                    // Update the respective Transactions, saying PPI is not updated & Update Quote saying same message. 
                    list<invoiceit_s__Transaction__c> listOfTrans = new list<invoiceit_s__Transaction__c>();
                    for(invoiceit_s__Transaction__c transObj : PPIwTrans.values()){
                        exceptionMessage = 'Transaction and Payment has been created but the Payment reference is missing on the Payment Plan Installment, Please click on Create Order button again to create the Order & Invoice.' + exceptionMessage;
                        transObj.invoiceit_s__Exception_Message__c  = exceptionMessage;
                        listOfTrans.add(transObj);
                    }
                    update listOfTrans;
                    myQuote.Exception_Message__c = exceptionMessage;
                    myQuote.Create_Order_Status__c = '';
                    update myQuote;
                    ErrorMsg = exceptionMessage;
                }
                
                // update the Quote with exception
                update myQuote;
                ErrorMsg = exceptionMessage;

                return null;
            }



            //-----------Update Opp here ------------------------------------------------ 
            // if (op.oStatus=='Success')  {
            // this is to get the successfully processed payment
            system.debug('myQuote.id==>>'+myQuote.id);
            integer iCountCheck1 = [select count() from invoiceit_s__Payment_Plan_Installment__c
                                    Where 
                                    Min_Down_Payment__c = true
                                    AND QTC__Quote__c=:myQuote.id];
            // get all successful trans
             integer iTotalCountIns1 = [select count() from invoiceit_s__Transaction__c
                                       Where invoiceit_s__Is_Payment_Processed_Successfully__c = true
                                       AND payment_plan_installment__c IN: PPIwTrans.KeySet()
                                       AND payment_plan_installment__r.Min_Down_Payment__c = true
                                       ]; 
            // Naveen to write the logic
            if (iTotalCountIns1 <> iCountCheck1){
                ErrorMsg = ErrorMsg + ' Some payments failed to process. Please check the Payment Methods. The Order and Invoice will not be created until all payments succeed.';
                system.debug('inside check==>>');
                // call the update Quote method to update the QUote.Create Order Status to blank
                updateQuote();
                return null;
            }

            //----------------PID--CID---------------------------                     

            //front end will indicate which scenario. If blank or any error just assume scenario 1  
            //Until CCH provides the indicator we will always assume scenario1 and always assume success
            IIT_PID_CID_check.output op =  IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(null, null, null,AccID)  ;
            IncrementStatus=''; 
            if (op.oStatus != 'Success') {
                IncrementStatus = ' ' + op.oErrorMsg;   //according to Doug if CID/PID parts fail just make it scenario1 and force it through
            } 

            //according to Doug  just force the flow to continue  --  
            op.oStatus='Success'; 

            System.debug('Line Number 488');
            if (IncrementStatus=='') IncrementStatus = 'CID and PID assigned successfully';
            if (myQuote.SBQQ__Opportunity2__c != null) {
                Savepoint sp; 
                try {
                    sp = Database.setSavepoint(); 
                    opportunity opp = new opportunity();
                    opp.id = myQuote.SBQQ__Opportunity2__c;
                    opp.QTC__Create_Order__c = true;
                    opp.CloseDate = System.today();
                    opp.StageName = 'Commitment';
                    update opp;

                    System.debug('Before Order is ====>505'+myQuote.SBQQ__Opportunity2__c);  
                    System.debug('Before Order is ====>505'+myQuote.SBQQ__MasterContract__r.SBQQ__Quote__r.SBQQ__Opportunity2__c);

                    id oppId;
                    if(myQuote.SBQQ__MasterContract__c != null){
                        oppId = myQuote.SBQQ__MasterContract__r.SBQQ__Quote__r.SBQQ__Opportunity2__c;
                    }else{
                        oppId = myQuote.SBQQ__Opportunity2__c;
                    }


                    list <invoiceit_s__Job__c> createdOrder = [SELECT id,invoiceit_s__Create_Invoice_Automatically__c,invoiceit_s__Start_Date__c
                                                               FROM invoiceit_s__Job__c 
                                                               WHERE 
                                                               QTC__Opportunity__c = : oppId] ;
                    System.debug('Order is ====>505'+createdOrder.size());       
                    if (createdOrder.size() > 0) {
                        OrderID = createdOrder[0].id; 

                        //   Need to get the id of INVOICE CREATED by trigger.  default status=posted which is fine.

                        invoiceit_s.CustomInvoiceGenerator invoiceGenerator = new invoiceit_s.CustomInvoiceGenerator();
                        invoiceGenerator.generateInvoiceForOrder(OrderID, myquote.SBQQ__StartDate__c, myquote.SBQQ__StartDate__c, false, false, true);

                        //createdOrder[0].invoiceit_s__Create_Invoice_Automatically__c = true;
                        //update createdOrder;
                        System.debug('Line Number 512');
                        list <invoiceit_s__Invoice__c > createdInvoice =[SELECT Id,invoiceit_s__Order__c,Name,invoiceit_s__CurrencyL__c, invoiceit_s__Total_Invoice_Value__c
                                                                         FROM invoiceit_s__Invoice__c 
                                                                         WHERE invoiceit_s__Order__c = : OrderID 
                                                                         AND invoiceit_s__Total_Invoice_Value__c != 0
                                                                         ORDER BY Name DESC NULLS LAST];

                             

                        if (createdInvoice.size() > 0) {
                        
                         System.debug('Invoice Is========>'+createdInvoice[0].Name);
                        System.debug('Invoice Is========>'+createdInvoice[0].invoiceit_s__Total_Invoice_Value__c); 
                        
                            invoiceID =  createdInvoice[0].id ;
                            currencyId = createdInvoice[0].invoiceit_s__CurrencyL__c  ;
                        }   

                        //update trans invoiceit_s__Request_Invoice__c with the invoice id
                        //need to RE-grab all transactions, including those that failed.
                        list< invoiceit_s__Transaction__c> allTxns = [SELECT id,invoiceit_s__Exception_Message__c,
                                                                      invoiceit_s__Amount__c,payment_plan_installment__c,
                                                                      invoiceit_s__Request_Invoice__c,payment_plan_installment__r.invoiceit_s__Payment__c,
                                                                      payment_plan_installment__r.invoiceit_s__Payment__r.invoiceit_s__Amount__c
                                                                      FROM invoiceit_s__Transaction__c 
                                                                      WHERE 
                                                                      invoiceit_s__Is_Payment_Processed_Successfully__c = true AND
                                                                      payment_plan_installment__c in: setOFinstallmentIds]; //Laxman Changed
                                                                      //invoiceit_s__payment_plan_installment__c in: setOFinstallmentIds];
                        System.debug('All Transaction  =====>543'+allTxns);
                        //UPDATE all PPInstallments with the Invoice, Order
                        for (invoiceit_s__Payment_Plan_Installment__c paymentToUpdate : PPI){  
                            
                            if (createdInvoice.size() > 0) {  
                            paymentToUpdate.invoiceit_s__Invoice__c =  createdInvoice[0].id ;
                            }
                            paymentToUpdate.invoiceit_s__Order__c = OrderID;
                            if(paymentToUpdate.Min_Down_Payment__c == true && createdOrder.size() > 0 ){
                                paymentToUpdate.invoiceit_s__Payment_Date__c = createdOrder[0].invoiceit_s__Start_Date__c;
                            }
                        }
                        update PPI;
                        System.debug('Payment Installment  =====>543'+PPI);
                        Decimal paidAmount = 0; 
                        list<invoiceit_s__Payment_Allocation__c> listAllocationToUpdate = new list<invoiceit_s__Payment_Allocation__c>();
                        for (invoiceit_s__Transaction__c txnToPayment : allTxns)  {
                            txnToPayment.invoiceit_s__Request_Invoice__c = invoiceID;   
                            if(txnToPayment.payment_plan_installment__r.invoiceit_s__Payment__c != null){
                                invoiceit_s__Payment_Allocation__c PA = new invoiceit_s__Payment_Allocation__c();
                                PA.invoiceit_s__Amount__c = txnToPayment.invoiceit_s__Amount__c <>null ? txnToPayment.invoiceit_s__Amount__c : 0 ;
                                PA.invoiceit_s__Invoice__c= invoiceID  ;
                                PA.invoiceit_s__Payment__c= txnToPayment.payment_plan_installment__r.invoiceit_s__Payment__c;
                                PA.invoiceit_s__Status__c='Completed';
                                listAllocationToUpdate.add(PA);

                                paidAmount += PA.invoiceit_s__Amount__c;
                            }
                        }

                        update allTxns; 
                        insert listAllocationToUpdate; 
                        System.debug('Payment Allocation =====>562'+listAllocationToUpdate);
                        // added below if condition, to update the opportunity stage, if Opportunity stage is updated to âActiveâ if < 90% of the total amount paid; > 90% is going to be âOn-boardâ
                        // always update the stage of the Quote.Opp
                        if(myQuote.SBQQ__Opportunity2__c != null){
                            opportunity updateStageOPP = new opportunity(id = myQuote.SBQQ__Opportunity2__c);
                            if (createdInvoice.size() > 0) {
                            System.debug('Invoice Total Value--->'+createdInvoice[0].invoiceit_s__Total_Invoice_Value__c);
                            }
                            System.debug('Paid Amount is====>'+paidAmount);

                            if(createdInvoice.size() > 0 &&  (paidAmount * 100) /createdInvoice[0].invoiceit_s__Total_Invoice_Value__c < 90){
                                updateStageOPP.StageName = 'Active';
                            }else{
                                updateStageOPP.StageName = 'Onboard';
                            }
                            updateStageOPP.SBQQ__Contracted__c = true;
                            update updateStageOPP; 
                        }
                        set<Id> setOfOrderIds = new set<Id>();
                        if (createdOrder.size() > 0) {
                        setOfOrderIds.add(createdOrder[0].id);
                        }
                        IIT_CreateOrderchargefulfillment createFulfillment = new IIT_CreateOrderchargefulfillment();
                        createFulfillment.createOrderfulfilment(setOfOrderIds);
                        //below code is called to create the order in staging tables
                        System.debug('Cretae Order Page Handleing Stage');
                        //HandleStaging stageHandle = new HandleStaging();
                        //stageHandle.sendStagingData(invoiceID);
                        System.debug('Naveen M=='+UserInfo.getSessionID());
                        handlstg(invoiceID,UserInfo.getSessionID());
                        myQuote.SBQQ__Status__c = 'Invoiced';
                        myQuote.Exception_Message__c = '';
                    }  
                    // update the Quote.OrderStatus to blank so that order can created again
                    // some times order is not created due an exception on the order where the process will terminate without updating the Quote.
                    myQuote.Create_Order_Status__c = '';
                    update myQuote;
                }
                catch (exception e) {
                    // Naveen to write the code, write proper exception
                    Database.rollback(sp);
                    system.debug ('ERRORrrrrrrrrr  ' + e.getlinenumber());
                    string exceptionMessage = 'An exception has occurred, Please Note Payment has been processed in CyberSource and Salesforce ,there was an exception while creating the order and invoice. Exception Message is:' + e.getMessage()
                                        + ' Line No : ' + e.getLineNumber()
                                        + ' Stack Trace : ' + e.getStackTraceString()
                                        + ' TypeName : ' + e.getTypeName()
                                        + ' Cause : ' + e.getCause();
                    myQuote.SBQQ__Status__c = 'Submitted';
                    myQuote.Create_Order_Status__c = '';
                    myQuote.Exception_Message__c = exceptionMessage ;
                    update myQuote;
                    orderID='';
                    invoiceID='';
                    
                    ErrorMsg = exceptionMessage;
                    return null;
                } 

            }
        } else{
            if(myQuote.SBQQ__Opportunity2__c != null){
                Savepoint sp;
                try {
                    
                    // Naveen to write the code, write proper exception
                    //Here, If you check the subscription check box on the Quote we are creating the order and invoice directly.Below is the logic for that
                    //front end will indicate which scenario. If blank or any error just assume scenario 1  
                    //Until CCH provides the indicator we will always assume scenario1 and always assume success
                    IIT_PID_CID_check.output op =  IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(null, null, null,AccID)  ;
                    IncrementStatus=''; 
                    if (op.oStatus != 'Success') {
                        IncrementStatus = ' ' + op.oErrorMsg;   //according to Doug if CID/PID parts fail just make it scenario1 and force it through
                    } 
    
                    //according to Doug  just force the flow to continue  --  
                    op.oStatus='Success'; 
                    if (IncrementStatus=='') IncrementStatus = 'CID and PID assigned successfully';
                    
                    sp = Database.setSavepoint(); 
                    opportunity opp = new opportunity();
                    opp.id = myQuote.SBQQ__Opportunity2__c;
                    opp.QTC__Create_Order__c = true;
                    opp.CloseDate = System.today();
                    opp.StageName = 'Commitment';
                    update opp;

                    System.debug('Before Order is ====>505'+myQuote.SBQQ__Opportunity2__c);  
                    System.debug('Before Order is ====>505'+myQuote.SBQQ__MasterContract__r.SBQQ__Quote__r.SBQQ__Opportunity2__c);

                    id oppId;
                    if(myQuote.SBQQ__MasterContract__c != null){
                        oppId = myQuote.SBQQ__MasterContract__r.SBQQ__Quote__r.SBQQ__Opportunity2__c;
                    }else{
                        oppId = myQuote.SBQQ__Opportunity2__c;
                    }


                    list <invoiceit_s__Job__c> createdOrder = [SELECT id,invoiceit_s__Create_Invoice_Automatically__c,invoiceit_s__Start_Date__c
                                                               FROM invoiceit_s__Job__c 
                                                               WHERE 
                                                               QTC__Opportunity__c = : oppId] ;
                    System.debug('Order is ====>505'+createdOrder.size());       
                    if (createdOrder.size() > 0) {
                        OrderID = createdOrder[0].id; 

                        //   Need to get the id of INVOICE CREATED by trigger.  default status=posted which is fine.
                        //createdOrder[0].invoiceit_s__Create_Invoice_Automatically__c = true;
                        update createdOrder;
                        System.debug('Line Number 512');
           
                        list <invoiceit_s__Invoice__c > createdInvoice =[SELECT Id,invoiceit_s__Order__c,Name,invoiceit_s__CurrencyL__c, invoiceit_s__Total_Invoice_Value__c
                                                                         FROM invoiceit_s__Invoice__c 
                                                                         WHERE invoiceit_s__Order__c = : OrderID 
                                                                         ORDER BY Name DESC NULLS LAST];
                        System.debug(''+createdInvoice[0].Name);       

                        if (createdInvoice.size() > 0) {
                            invoiceID =  createdInvoice[0].id ;
                            currencyId = createdInvoice[0].invoiceit_s__CurrencyL__c  ;
                        }  
                        set<Id> setOfOrderIds = new set<Id>();
                        setOfOrderIds.add(createdOrder[0].id);
                        IIT_CreateOrderchargefulfillment createFulfillment = new IIT_CreateOrderchargefulfillment();
                        createFulfillment.createOrderfulfilment(setOfOrderIds);
                        //HandleStaging stageHandle = new HandleStaging();
                        //stageHandle.sendStagingData(invoiceID);
                        handlstg(invoiceID,UserInfo.getSessionID());
                        if(myQuote.iFirm_Product_Included__c  >0){
                        icareprocision(myQuote.id,myQuote.SBQQ__Account__C,myQuote.Related_Provisioning__r.id);
                        }
                        myQuote.SBQQ__Status__c = 'Invoiced';
                        myQuote.Exception_Message__c = '';                           
                    }
                    // update the Quote.OrderStatus to blank so that order can created again
                    // some times order is not created due an exception on the order where the process will terminate without updating the Quote.
                    myQuote.Create_Order_Status__c = '';
                    update myQuote;                     
                }catch(exception e){
                    // Naveen to write the code, write proper exception
                    Database.rollback(sp);
                    system.debug ('ERRORrrrrrrrrr  ' + e);
                    //ErrorMsg = e.getMessage();
                    string exceptionMessage = 'An exception has occurred, Please Note Payment has been processed in CyberSource and Salesforce ,there was an exception while creating the order and invoice. Exception Message is: ' + e.getMessage()
                                        + ' Line No : ' + e.getLineNumber()
                                        + ' Stack Trace : ' + e.getStackTraceString()
                                        + ' TypeName : ' + e.getTypeName()
                                        + ' Cause : ' + e.getCause();
                    myQuote.SBQQ__Status__c = 'Submitted';
                    myQuote.Create_Order_Status__c = '';
                    myQuote.Exception_Message__c = exceptionMessage ;
                    update myQuote;                    
                    orderID='';
                    invoiceID='';
                    
                    ErrorMsg = exceptionMessage;
                    return null;
                }
            }

        }
        return null;
    } 
    
    // this method is being called from various places, to update the QUote status to blank.
    public void updateQuote() {
        myQuote.Create_Order_Status__c = '';
        update myQuote;
    }
    
    @future(callout=true)
    public static void handlstg(String invoiceID, String sessionId) {
          System.debug('Session Id in future method====>'+UserInfo.getSessionID());
          System.debug('New Session Id In future'+sessionId);
          System.debug('Future Method and Invoice Id is ===>'+invoiceID);
          HandleStaging stageHandle = new HandleStaging();
          stageHandle.sendStagingData(invoiceID,sessionId);
        
    }
    
    @future(callout=true)
    public static void icareprocision(Id qid, Id acid,String relatedprvsng) {
        
      
      if(relatedprvsng==null || relatedprvsng ==''){
         
         IcareSiteCreation icare = new IcareSiteCreation();
          icare.replicateIfirmUrl(qid,acid);
         

         }else{
          
         IcareSiteUpdate icareupdate = new IcareSiteUpdate();
         icareupdate.UpdateIfirmdetails(relatedprvsng);
         }
    }
    
    public PageReference processDataToOracle() {
        string smessege = IIT_ProcessDataToExternalSystem.pushDataToExternalform();
        Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, smessege);
        Apexpages.addMessage(infoMessage);
        return null;
    }
}