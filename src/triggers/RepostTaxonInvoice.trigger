/* The trigger is created for sending Tax information again to Speed Tax*/

trigger RepostTaxonInvoice on invoiceit_s__Invoice__c (after update) {
     
     if(trigger.size==1){
     
     for(invoiceit_s__Invoice__c pm:Trigger.new)
    {
     invoiceit_s__Invoice__c oldinv= Trigger.oldMap.get(pm.ID);
    
    if((pm.RePost_Tax__c== true && Triggerflag.firstRun && oldinv.RePost_Tax__c==False) ){
    
     
          RepostInvoiceTax.Repost(pm.Id,pm.invoiceit_s__Invoice_Status__c);
          
          Triggerflag.firstRun=false; 
        }
        }
   }     
}