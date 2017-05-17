public with sharing class IIT_createPaymentMethod {

    public invoiceit_s__Payment_Method__c paymentMethod {get; set;}
    static transactionError trxError;

    public IIT_createPaymentMethod(ApexPages.StandardController controller) {

        paymentMethod = new invoiceit_s__Payment_Method__c(invoiceit_s__Payment_Method__c = 'ACH');
        paymentMethod.invoiceit_s__Account__c = apexpages.currentpage().getparameters().get('aid');
        
        account acc = [SELECT BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet, (SELECT Email,FirstName,Is_Primary__c,LastName FROM Contacts WHERE Is_Primary__c = true) FROM Account WHERE Id = :paymentMethod.invoiceit_s__Account__c];
        paymentMethod.invoiceit_s__Billing_Address__c = acc.BillingStreet;
        System.debug(''+acc);
        
        paymentMethod.invoiceit_s__Billing_City__c = acc.BillingCity;
        paymentMethod.invoiceit_s__Billing_State_Province__c = acc.BillingState;
        paymentMethod.invoiceit_s__Billing_Zip_Postal__c = acc.BillingPostalCode;
        paymentMethod.invoiceit_s__Billing_Country__c = acc.BillingCountry;
        if(acc.Contacts.size()>0){
            paymentMethod.invoiceit_s__Billing_First_Name__c = acc.Contacts[0].FirstName;
            paymentMethod.invoiceit_s__Billing_Last_Name__c = acc.Contacts[0].LastName;
            paymentMethod.invoiceit_s__Billing_Email__c = acc.Contacts[0].Email;
            //paymentMethod.invoiceit_s__Billing_Email__c = acc.Contacts[0].Email;
        }
        
    }
    
    public pageReference save() {
    
        if(paymentMethod.invoiceit_s__Payment_Method__c == 'Credit Card'){
        VFUtil.AddErrorMessage ( 'Payment Method type should be ACH.');
        return null;
        
        }
        
       
        String tokenId=CyberSourceConnection.getTokenFromACH(paymentMethod);
        
        //Store only last four from Account Number
        
        if(paymentMethod.invoiceit_s__Bank_Account_Number__c.length() >4){
        Integer len= paymentMethod.invoiceit_s__Bank_Account_Number__c.length();
        Integer substringval;
        
        substringval = len-4;
        
        paymentMethod.invoiceit_s__Bank_Account_Number__c= paymentMethod.invoiceit_s__Bank_Account_Number__c.substring(substringval,len);
        }
        
        //Store only last four from Routing Number
       /* if(paymentMethod.invoiceit_s__Bank_Routing_Code__c.length() >4){
        Integer routlen= paymentMethod.invoiceit_s__Bank_Routing_Code__c.length();
        Integer routsubstringval;
        
        routsubstringval = routlen-4;
        
        paymentMethod.invoiceit_s__Bank_Routing_Code__c= paymentMethod.invoiceit_s__Bank_Routing_Code__c.substring(routsubstringval,routlen);
        
        }*/
        
        trxError = transactionError.instance;

        if (trxError.errorFound) {
        VFUtil.AddErrorMessage ( trxError.errorMessage);
        return null;
        
        } 

        if(!String.isBlank(tokenId)){
        paymentMethod.invoiceit_s__Payment_Profile_ID__c=tokenId;
        }else{
       
       VFUtil.AddErrorMessage ('Remote Server was busy.Please retry the request again.');
        return null;
        

        }
        insert paymentMethod;
        
        PageReference pr = new PageReference('/'+apexpages.currentpage().getparameters().get('qid'));
        return pr;
    }
    public pageReference cancelPaymentOption() {
        PageReference pr = new PageReference('/'+apexpages.currentpage().getparameters().get('qid'));
        return pr;
    }
    
}