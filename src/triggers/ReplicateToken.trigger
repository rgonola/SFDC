/* The trigge is created for sending Payment related information to DM system*/

trigger ReplicateToken on invoiceit_s__Payment_Method__c (after insert, after update) {
     
     for(invoiceit_s__Payment_Method__c  pm:Trigger.new)
    {
    if(pm.invoiceit_s__Default__c == true && pm.Account_PID__c != null)
        UpdateAccountInfoInDM.replicateToken(pm.Id);
      
    }
}