trigger IITTriggerOnInvoiceLine on invoiceit_s__Invoice_Lines__c (after update) {
    
    // some times CCH will amend the contracts as result they will remove the existing products and add the new products. So when they cancel the invoice we need to mark the status as cancelled so that it will not invoice again and it's true only for one time charges.
    // For CCH one time charges are annual charges where Subscription field on the Product is false. If the subsciption field is true then it's consider as a true subsciption.
    // when an invoice is cancelled, update the invoice line.ORPC to cancelled so that if you generate the invoice again it will not create
    // this code will update the ORPC,  invoiceit_s__Job_Rate_Plan_Charge__r.QTC__Quote_Line__r.Subscription2__c 
    map<Id, invoiceit_s__Invoice_Lines__c> newMap = trigger.newMap;
    map<Id, invoiceit_s__Invoice_Lines__c> oldMap = trigger.oldMap;
    list<invoiceit_s__Job_Rate_Plan_Charge__c> chargesToUpdate = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
    invoiceit_s__Job_Rate_Plan_Charge__c charge;
    
    list<invoiceit_s__Invoice_Lines__c> invLinesOfInterest = new list<invoiceit_s__Invoice_Lines__c>();
    set<Id> chargeIds = new set<Id>();
    
    for(invoiceit_s__Invoice_Lines__c newInvoiceLine : newMap.values()) {
        
        invoiceit_s__Invoice_Lines__c oldInvoiceLine = oldMap.get(newInvoiceLine.Id);
        if(newInvoiceLine.invoiceit_s__Status__c == 'Cancelled' && oldInvoiceLine.invoiceit_s__Status__c == 'Active'
           && newInvoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c != null
           && newInvoiceLine.invoiceit_s__Price_Type__c != 'Usage'
           ) 
        {
            if(newInvoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c != null) {              
                invLinesOfInterest.add(newInvoiceLine);
                chargeIds.add(newInvoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c);
            }
        }   
    }
    
    map<Id, invoiceit_s__Job_Rate_Plan_Charge__c> nonSubsciptions = new map<Id, invoiceit_s__Job_Rate_Plan_Charge__c>
                       ([SELECT Id
                       FROM invoiceit_s__Job_Rate_Plan_Charge__c
                       WHERE Id IN: chargeIds
                       AND
                       QTC__Quote_Line__r.Subscription2__c = false]
                       );
    
    for(invoiceit_s__Invoice_Lines__c newInvoiceLine : invLinesOfInterest) {
        // you need to ignore the true subsriptions
        if(nonSubsciptions.containsKey(newInvoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c)) {
            charge = new invoiceit_s__Job_Rate_Plan_Charge__c(Id = newInvoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c);
            charge.invoiceit_s__Charge_Date__c = system.today();
            charge.invoiceit_s__Next_Charge_Date__c = null;
            charge.invoiceit_s__Status__c = 'Cancelled';
            
            chargesToUpdate.add(charge);   
        }
    }
    
    if(chargesToUpdate.size() > 0) {
        update chargesToUpdate;
    }
}