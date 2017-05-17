public class IIT_CreateOrderUtilClass {
    
    public static list<invoiceit_s__Payment_Plan_Installment__c> queryInstallments(SBQQ__Quote__c myQuote) {
        return [SELECT id,Name  ,invoiceit_s__Payment_Method__c ,invoiceit_s__Payment_Amount__c ,transacted__c
                  ,invoiceit_s__Payment_Method__r.invoiceit_s__Payment_Method__c ,Min_Down_Payment__c
                  ,invoiceit_s__Payment_Type__c,QTC__Quote__r.QTC__Payment_Plan__r.Name,invoiceit_s__Payment_Method__r.invoiceit_s__Card_Type__c,invoiceit_s__Payment_Method__r.invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Payment_Method__r.invoiceit_s__Card_Expiration_Month__c,
                  Tra_Type__c,Tra_Response_Status__c,Tra_Response_Gateway_ID__c,Tra_Payment_Gateway__c,Tra_Currency__c,Tra_Credit_Card_Number__c,
                  (SELECT invoiceit_s__Request_Type_Of_Payment__c, invoiceit_s__Amount__c, invoiceit_s__Is_Payment_Processed_Successfully__c, payment_plan_installment__c
                  FROM Transactions__r 
                  WHERE invoiceit_s__Response_Status__c = 'Approved' AND invoiceit_s__Request_Transaction_Type__c = 'Charge')
                  FROM invoiceit_s__Payment_Plan_Installment__c 
                  WHERE QTC__Quote__c = :myQuote.id
                  ];
    }
    // this method is being called from various places, to update the QUote status to blank.
    public static void updateQuote(SBQQ__Quote__c myQuote, string status, string ErrorMsg) {
        // update the quote with the exception message
        myQuote.SBQQ__Status__c = status;
        myQuote.Create_Order_Status__c = '';
        myQuote.Exception_Message__c = ErrorMsg;
        update myQuote; 
    }
    
    // get the quote detials
    public static SBQQ__Quote__c getQuote(Id quoteId) {
        return [SELECT QTC__Order__c, Create_Order_Status__c, Name,Tax_Grand_Total__c,Tax_Time_Stamp__c,SBQQ__NetAmount__c, SBQQ__Primary__c,SBQQ__Account__c,SBQQ__Account__r.invoiceit_s__Gateway__c,SBQQ__Account__r.invoiceit_s__Gateway__r.invoiceit_s__Gateway_Type__c,
                SBQQ__Opportunity2__c,SBQQ__EndDate__c,SBQQ__StartDate__c,SBQQ__Account__r.invoiceit_s__Total_Unallocated_Payment__c
                ,Tax__c, QTC__Payment_Plan__c, SBQQ__Status__c ,QTC__Payment_Plan__r.Name,SBQQ__MasterContract__r.SBQQ__Quote__r.SBQQ__Opportunity2__c,SBQQ__MasterContract__c, Subscription__c
                ,SBQQ__Opportunity2__r.QTC__Create_Order__c
                ,SBQQ__Opportunity2__r.SBQQ__PrimaryQuote__c
                FROM SBQQ__Quote__c 
                WHERE Id =: quoteId];    
    }  
    
    // get the payment gateway details
    public static map<String,invoiceit_s__Gateway__c> getGatewayByType(){
        map<String,invoiceit_s__Gateway__c> map_type_gateway = new map<String,invoiceit_s__Gateway__c> ();

        for(invoiceit_s__Gateway__c gateway : [SELECT Name, invoiceit_s__Merchant_Reference__c, invoiceit_s__Transaction_Security_Key__c,
                                               invoiceit_s__Exact_ID_Security_Key__c, invoiceit_s__Exact_ID__c, 
                                               invoiceit_s__Gateway_Type__c, invoiceit_s__Merchant_ID__c, 
                                               invoiceit_s__Security_Key__c, invoiceit_s__Test_Mode__c, invoiceit_s__Merchant_Seal_User_Id__c,
                                               invoiceit_s__Email_Customer__c
                                               FROM invoiceit_s__Gateway__c
                                               WHERE invoiceit_s__Active__c = true
                                               AND 
                                               invoiceit_s__Default__c = true])
        {
            map_type_gateway.put('Credit Card',gateway);
            map_type_gateway.put('ACH',gateway);

        }
        return map_type_gateway;
    }
    
    // get the currency record
    public static list<invoiceit_s__Currency__c> getCurrency() {
         return [SELECT Name 
                 FROM invoiceit_s__Currency__c 
                 WHERE Name = 'USD']; 
    }
    
    // get the invoices
    public static list<invoiceit_s__Invoice__c> getInvoiceList(Id OrderID) {
        return [SELECT id,invoiceit_s__Order__c ,invoiceit_s__CurrencyL__c, invoiceit_s__Total_Invoice_Value__c 
                FROM invoiceit_s__Invoice__c 
                WHERE invoiceit_s__Order__c =: OrderID];
    }
    
    public static Map<Id, invoiceit_s__Payment_Method__c> getPaymentMethods(set<Id> setOfPaymentMethodids) {
        Map<Id, invoiceit_s__Payment_Method__c> map_id_paymentid;
        map_id_paymentid = new Map<Id, invoiceit_s__Payment_Method__c >([SELECT invoiceit_s__Card_Number__c, invoiceit_s__Card_Type__c, invoiceit_s__Card_Expiration_Month__c, invoiceit_s__Card_Expiration_Year__c, invoiceit_s__CVV__c, invoiceit_s__Name_on_Card__c, invoiceit_s__Billing_Country__c,
                                                                          invoiceit_s__Bank_Routing_Code__c, invoiceit_s__Bank_Account_Number__c, invoiceit_s__Bank_Account_Type__c, invoiceit_s__Bank_Name__c, invoiceit_s__Bank_Account_Name__c,
                                                                          invoiceit_s__Billing_First_Name__c, invoiceit_s__Billing_Last_Name__c, invoiceit_s__Billing_Address__c, invoiceit_s__Billing_City__c, invoiceit_s__Billing_State_Province__c, invoiceit_s__Billing_Zip_Postal__c ,
                                                                          invoiceit_s__Account__c, invoiceit_s__Account__r.Name, invoiceit_s__Billing_Phone__c, invoiceit_s__Billing_Fax__c, invoiceit_s__Billing_Email__c,invoiceit_s__Account__r.invoiceit_s__Customer_Profile_ID__c,invoiceit_s__Payment_Profile_ID__c,
                                                                          invoiceit_s__Encrypted_CVV__c,invoiceit_s__Encrypted_Card_Number__c,invoiceit_s__Token__c, invoiceit_s__Payment_Method__c  
                                                                          FROM invoiceit_s__Payment_Method__c 
                                                                          WHERE id in : setOfPaymentMethodids
                                                                         ]); 
        return map_id_paymentid;
    }
    
}