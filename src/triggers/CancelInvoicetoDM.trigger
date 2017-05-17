trigger CancelInvoicetoDM on invoiceit_s__Invoice__c (after update) {
         
         if(trigger.size==1){
         
         for(invoiceit_s__Invoice__c pm:Trigger.new)
        {
        if((pm.invoiceit_s__Invoice_Status__c =='Cancelled' && pm.Tax_call_Error__c == false && Triggerflag.firstRun && pm.invoiceit_s__Cancellation_Reason__c != null )  ){
        
         UpdateInvoiceInfoInDM.CancelInvoice(pm.Id);  Triggerflag.firstRun=false; } }
       }     
    }