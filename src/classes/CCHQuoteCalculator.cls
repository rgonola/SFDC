global class CCHQuoteCalculator implements SBQQ.QuoteCalculatorPlugin {

    global void onInit(SObject[] lines) {

        //Query Quote to Return Type(New, Amendment, etc...)
        
        String quoteid;
        for(SObject line : lines) {
            quoteid = (String)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Quote__c));
            break;
        }

        quoteid=(quoteid==NULL) ? '' : quoteid;
        
        String quoteType;
        try{
            quoteType=[Select SBQQ__Type__c from SBQQ__Quote__c where id=:quoteid].SBQQ__Type__c ;
        }catch(QueryException q){
            system.debug(q);
        }
        

         //Check if its an Amendment
        //String quoteType = (String)quote.get(String.valueOf(SBQQ__Quote__c.SBQQ__Type__c));
        quoteType=(quoteType==NULL) ? '' : quoteType;
        Set<String> subscriptionSet=new Set<String>();
        Map<String,String> sub_to_promo=new Map<String,String>();
        Map<String,String> ql_to_sub=new Map<String,String>();
        Map<String,String> ql_to_promo=new Map<String,String>();


        if(quoteType=='Amendment'){
            //Create List of Updated Subscriptions
            for(SObject line : lines) {
                String upgradedSub = (String)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__UpgradedSubscription__c));
                if(upgradedSub!=NULL){
                    subscriptionSet.add(upgradedSub);
                }
            }

            if(!subscriptionSet.isEmpty()){
                        //Create Quote Line to Subscription Map
                        for(SBQQ__Subscription__c sub:[Select id, SBQQ__QuoteLine__c from SBQQ__Subscription__c where ID IN:subscriptionSet]){
                            ql_to_sub.put(sub.SBQQ__QuoteLine__c, sub.id);
                        }

                        //Create Quoteline to Promotion Map for Old Promotion Values
                        for(SBQQ__QuoteLine__c quoLine:[Select id, Promotion__c from SBQQ__QuoteLine__c where id IN:ql_to_sub.keyset()]){
                            ql_to_promo.put(quoLine.id, quoLine.Promotion__c);
                        }

                        //Creates Subscription to Promotion Map
                        for(String s:ql_to_promo.keySet()){
                            if(ql_to_sub.containsKey(s)){
                                sub_to_promo.put(ql_to_sub.get(s), ql_to_promo.get(s));
                            }
                        }

                        //Loop Lines again, if Subscription is in Map, Retrieve Promotion and Update Promotion Field
                        for(SObject line : lines) {
                            String upgradedSub = (String)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__UpgradedSubscription__c));
                            if(upgradedSub!=NULL){
                                if(sub_to_promo.containsKey(upgradedSub)){
                                    line.put(SBQQ__QuoteLine__c.Promotion__c, sub_to_promo.get(upgradedSub));
                                }
                            }
                        }

            }

        }

    }
    
    
    global void onBeforeCalculate(SObject quote, SObject[] lines) {


        
    }
    
    global void onBeforePriceRules(SObject quote, SObject[] lines) {
        
    }
    
    global void onAfterPriceRules(SObject quote, SObject[] lines) {
    
    }
    
    global void onAfterCalculate(SObject quote, SObject[] lines) {
    
    }
    


}