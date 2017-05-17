/**********************************************************************
Name: bfInsUpdShippingHistory
Copyright © 2012 WK
======================================================
======================================================
Purpose: This trigger will be called when a new Shipping History Record is created or 
         when existing Shipping History Record is updated.
         This will update the Shipping History Owner as corresponding Lead Owner.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION    AUTHOR        DATE           DETAIL 
1.0        Natesh        07/13/2012     INITIAL DEVELOPMENT 
1.1        Shirish       01/31/2013     Added Account Field mapping to the Shipping History object
1.2        Ted Shevlin   03/30/2013     Refactoring
                                        Code commenting
                                        Rewriting the logic so it's clearer
***********************************************************************/
trigger bfInsUpdShippingHistory on Shipping_History__c (before insert, before update) {
    Set<Id> setLeadIds = new Set<Id>();
    Set<Id> setAccountIds = new Set<Id>();
    Map<Id, Lead> mapLeadOwners;
    Map<Id, Account> mapAccountOwners;

    // Setup sets of lead and account IDs for map building step, next
    for(Shipping_History__c sh : Trigger.new) {
        if(sh.Lead_del__c <> null) {
            setLeadIds.add(sh.Lead_del__c);
        }
        if(sh.Account__c <> null) {
            setAccountIds.add(sh.Account__c);
        }
    }

    // Setup maps of lead and account owners for use in loop
    mapLeadOwners = new Map<Id, Lead>([SELECT Id, OwnerId FROM Lead WHERE Id IN :setLeadIds]);
    mapAccountOwners = new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN :setAccountIds]);

    for(Shipping_History__c sh : Trigger.new) {

        // Set the shipping record owner to the associated account owner, if it exists.  Or if there is no
        // associated account, set the shipping record owner to the associated lead owner, if it exists.
        if(sh.Account__c <> null && mapAccountOwners.containsKey(sh.Account__c)) {
            sh.OwnerId = mapAccountOwners.get(sh.Account__c).OwnerId;
        } else if(sh.Lead_del__c <> null && mapLeadOwners.containsKey(sh.Lead_del__c)) {
            sh.OwnerId = mapLeadOwners.get(sh.Lead_del__c).OwnerId;
        }
    }
}