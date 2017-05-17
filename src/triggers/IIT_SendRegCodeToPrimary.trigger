trigger IIT_SendRegCodeToPrimary on invoiceit_s__Job_Rate_Plan_Charge__c (before update, after update) {
    if(trigger.isBefore) {
        IIT_SendREGEmail regcodeEmail = new IIT_SendREGEmail();
        regcodeEmail.handleBeforeOnORPC(Trigger.newMap, Trigger.oldMap);
        
        // Laxman added below code
        Map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> chargesOfInt = new Map<Id,invoiceit_s__Job_Rate_Plan_Charge__c>();
        Map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> newCharges = Trigger.newMap;
        Map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> oldCharges = Trigger.oldMap;
        
        for(invoiceit_s__Job_Rate_Plan_Charge__c newCharge : newCharges.values()) {
            if(newCharge.invoiceit_s__Price_Type__c == 'Usage') {
                invoiceit_s__Job_Rate_Plan_Charge__c oldCharge = oldCharges.get(newCharge.Id);    
                
                if(newCharge.invoiceit_s__Next_Charge_Date__c == null) {
                    chargesOfInt.put(newCharge.Id, newCharge);   
                }
            }   
        }
        
        if(chargesOfInt.size() > 0) {
            list<AggregateResult> aggRes = [Select Max(invoiceit_s__End_Date__c) endDate, invoiceit_s__Order_Rate_Plan_Charge__c chargeId
                                            FROM invoiceit_s__Usage_Charge__c
                                            WHERE invoiceit_s__Order_Rate_Plan_Charge__c In: chargesOfInt.keySet()
                                            AND
                                            invoiceit_s__Status__c = 'Un-billed'
                                            GROUP BY invoiceit_s__Order_Rate_Plan_Charge__c];
        
            for(AggregateResult agg : aggRes) {
                date endDate = (date) agg.get('endDate');  
                Id chargeId = (Id) agg.get('chargeId');   
                
                invoiceit_s__Job_Rate_Plan_Charge__c charge = chargesOfInt.get(chargeId);
                charge.invoiceit_s__Next_Charge_Date__c = endDate;
            }
        }
    
    } else {
        IIT_SendREGEmail regcodeEmail = new IIT_SendREGEmail();
        regcodeEmail.handleAfterOnORPC(Trigger.newMap, Trigger.oldMap);
    }
}