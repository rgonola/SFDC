trigger IIT_TriggerOnOrder on invoiceit_s__Job__c (before insert, before update) {
    
    for(invoiceit_s__Job__c order : trigger.new) {
        if(order.invoiceit_s__Payment_Plan__c != null) {
            order.invoiceit_s__Payment_Plan__c = null;    
        }
    }
}