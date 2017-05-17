trigger UpdatedefaultPMonAccount on invoiceit_s__Payment_Method__c (after insert, after update) {
     
     Map<Id,Id> pmtoupdate = new Map<Id,Id>();
     List<Account> accountstoupdate =new List<Account>();
     
     
     for(invoiceit_s__Payment_Method__c  pm:Trigger.new)
    {
    if(pm.invoiceit_s__Default__c == true && pm.invoiceit_s__Account__c != null)
        pmtoupdate.put(pm.invoiceit_s__Account__c,pm.id);
      
    }
    
    
    List<Account> acunts = [Select id,invoiceit_s__Payment_Method__c From Account Where id IN: pmtoupdate.keyset() ];
    
    
    
    for(Account a:acunts ){
    
    
    a.invoiceit_s__Payment_Method__c = pmtoupdate.get(a.id);
    accountstoupdate.add(a);
    }
    
    if(accountstoupdate.size()>0)
    update accountstoupdate;
    
    
}