global with sharing class IIT_CreditCardPaymentMethod {
    public invoiceit_s__Payment_Method__c paymentMethod {get; set;}
    public account acc;
    

    public IIT_CreditCardPaymentMethod(ApexPages.StandardController controller) {
        paymentMethod = new invoiceit_s__Payment_Method__c(invoiceit_s__Payment_Method__c = 'Credit Card');
        paymentMethod.invoiceit_s__Account__c = apexpages.currentpage().getparameters().get('aid');
        
        acc = [SELECT BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet, (SELECT Email,FirstName,Is_Primary__c,LastName FROM Contacts WHERE Is_Primary__c = true) FROM Account WHERE Id = :paymentMethod.invoiceit_s__Account__c];
        paymentMethod.invoiceit_s__Billing_Address__c = acc.BillingStreet;
        System.debug(''+acc);
        paymentMethod.invoiceit_s__Billing_City__c = acc.BillingCity;
        paymentMethod.invoiceit_s__Billing_State_Province__c = acc.BillingState;
        paymentMethod.invoiceit_s__Billing_Zip_Postal__c = acc.BillingPostalCode;
        paymentMethod.invoiceit_s__Billing_Country__c = acc.BillingCountry;
        if(acc.Contacts.size() > 0){
            paymentMethod.invoiceit_s__Billing_First_Name__c = acc.Contacts[0].FirstName;
            paymentMethod.invoiceit_s__Billing_Last_Name__c = acc.Contacts[0].LastName;
            paymentMethod.invoiceit_s__Billing_Email__c = acc.Contacts[0].Email;
        }
        
        
    }
    public string smessege{get;set;}
    public pageReference saveCC() {
    //invoiceit_s.ControllerForGenerateTokenForCyberSource generateToken = new invoiceit_s.ControllerForGenerateTokenForCyberSource(acc.id);
        ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(acc);
        invoiceit_s.ControllerForGenerateTokenForCyberSource createTokenController = new invoiceit_s.ControllerForGenerateTokenForCyberSource(controller);
        createTokenController.paymentMethod  = paymentMethod;
        createTokenController.generateToken();
        
        smessege = createTokenController.sMessege; 
        if(smessege == 'Success'){
            PageReference pr = new PageReference('/'+apexpages.currentpage().getparameters().get('qid'));
            return pr;
        }
        
        return null;
        
        //insert paymentMethod;
        
    }
    public pageReference cancelQuote() {
        PageReference pr = new PageReference('/'+apexpages.currentpage().getparameters().get('qid'));
        return pr;
    }
    
    

}