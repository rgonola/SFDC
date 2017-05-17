public class IIT_CreateOrderBussinessClass {
    // perform validations, this method will retun error message or null
    public static string validateQuoteDetails(SBQQ__Quote__c myQuote) {
        String ErrorMsg = null;
        if (myQuote.Tax__c == null ) {
            ErrorMsg = 'Tax has not been calculated on Quote, please click Calculate Tax button on Quote';
            return ErrorMsg;
        }

        if (myQuote.SBQQ__Primary__c == false) {
            ErrorMsg = 'Order can only be created on quotes marked as primary. Please mark Primary checkbox on quote and click Create Order button again';
            return ErrorMsg;
        }

        if(myQuote.Tax_Time_Stamp__c == null || myQuote.Tax_Grand_Total__c == null) {
            ErrorMsg = 'Quote total has been updated since last time tax was calculated. Please click Calculate tax button again before trying to create order';  
            return ErrorMsg;
        }

        if(myQuote.Tax_Time_Stamp__c.addHours(24) < system.now()){
            ErrorMsg = 'It has been over 24 hours since tax has been calculated. To ensure correct tax rates are applied, please click Calculate Tax button again before creating order';
            return ErrorMsg;
        }
        
        if(myQuote.SBQQ__NetAmount__c != myQuote.Tax_Grand_Total__c){
            ErrorMsg = 'Quote total has been updated since last time tax was calculated. Please click Calculate tax button again before trying to create order';
            return ErrorMsg;
        }
        
        if(myQuote.SBQQ__Opportunity2__c == null){
            ErrorMsg = 'Opportunity field is blank on the quote. Please make sure an opportunity is associated with the quote before order creation';   
            return ErrorMsg;
        }
        
        if(myQuote.SBQQ__Account__c == null){
            ErrorMsg = 'Account field is blank on the quote. Please make sure an account is associated with the quote before order creation';   
            return ErrorMsg;
        }
        
        if(myQuote.SBQQ__Opportunity2__r.SBQQ__PrimaryQuote__c == null){
            ErrorMsg = 'There is no primary quote associated with the referenced opportunity. Please make sure opportunity references the correct quote as the Primary quote (see opportunity page) and click Create Order button again';   
            return ErrorMsg;
        }
        
        if(myQuote.SBQQ__Opportunity2__r.QTC__Create_Order__c == true){
            ErrorMsg = 'On the referenced opportunity, please make the Create Order checkbox as false(see opportunity page) and click Create Order button again';   
            return ErrorMsg;
        }
        
        return ErrorMsg;
    }
    
    public static string validateOpportunityDetails(SBQQ__Quote__c myQuote) {
        String ErrorMsg = null;
        
        if(myQuote.SBQQ__Opportunity2__r.SBQQ__PrimaryQuote__c == null){
            ErrorMsg = 'There is no primary quote associated with the referenced opportunity. Please make sure opportunity references the correct quote as the Primary quote (see opportunity page) and click Create Order button again';   
        }
        
        if(myQuote.SBQQ__Opportunity2__r.QTC__Create_Order__c == true){
            ErrorMsg = 'On the referenced opportunity, please make the Create Order checkbox as false(see opportunity page) and click Create Order button again';   
        }
        
        return ErrorMsg;    
    }
    
    // exception handling
    public static string populateExceptionMessage(Exception ex, String customMessage) {
        string exceptionMessage = customMessage + '<br>'
                                + ' Exception Message is : ' + ex.getMessage() + '<br>'
                                + ' Line No : ' + ex.getLineNumber() + '<br>'
                                + ' Stack Trace : ' + ex.getStackTraceString() + '<br>'
                                + ' TypeName : ' + ex.getTypeName() + '<br>'
                                + ' Cause : ' + ex.getCause();    
        return exceptionMessage;    
    }
    
    // exception handling
    public static void createFullfilmentSteps(Id orderId) {
        set<Id> setOfOrderIds = new set<Id>();
        setOfOrderIds.add(orderId);
        IIT_CreateOrderchargefulfillment createFulfillment = new IIT_CreateOrderchargefulfillment();
        createFulfillment.createOrderfulfilment(setOfOrderIds);    
    }
}