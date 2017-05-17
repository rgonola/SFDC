trigger IIT_TriggerOnInvoiceTocreatePayment on invoiceit_s__Invoice__c (before insert, before update) {
    // populate the invoice as today.
    // populate the due date as invoice date and they wanted to change the due date after invoice creation if needed.
    // the reason we are doing for before n after update is because invoice date is getting overriden after the creation. So we have written before update trigger also
    for(invoiceit_s__Invoice__c inv : trigger.new) {
        if(inv.invoiceit_s__Invoice_State__c == 'Regular' && trigger.isInsert) {
            inv.invoiceit_s__Invoice_Date__c = System.today();
            inv.invoiceit_s__Due_Date__c = inv.invoiceit_s__Invoice_Date__c; 
        } else if(inv.invoiceit_s__Invoice_State__c == 'Regular' && inv.invoiceit_s__Invoice_Date__c != inv.CreatedDate.Date()) {
            inv.invoiceit_s__Invoice_Date__c = inv.CreatedDate.Date();  
            inv.invoiceit_s__Due_Date__c = inv.invoiceit_s__Invoice_Date__c; 
        }
    }
}