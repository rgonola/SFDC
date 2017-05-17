/**********************************************************************
Name: bfInsUpdSFSShipping
Copyright © 2012 WK
======================================================
======================================================
Purpose: This trigger will be called when a new SFS Shipping Record is created or when the existing SFS shipping
         record is updated.
         This will update the SFS Shipping Owner as the associated account owner, if it exists, or lead owner,
         if it exists.  It will try to set the owner as the account owner first and only set the owner as the
         lead owner if there is no associated account owner.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION    AUTHOR        DATE           DETAIL 
1.0        Natesh        08/30/2012     INITIAL DEVELOPMENT
1.1        Ted Shevlin   03/31/2013     Minor refactoring
                                        Code commenting
                                        Rewriting the logic so it's clearer
***********************************************************************/
trigger bfInsUpdSFSShipping on SFS_Shipping__c (before insert, before update) {
    Set<Id> setLeadIds = new Set<Id>();
    Set<Id> setAccountIds = new Set<Id>();
    Map<Id, Lead> mapLeadOwners;
    Map<Id, Account> mapAccountOwners;

    // Setup sets of lead and account IDs for map building step, next
    for(SFS_Shipping__c sfss : Trigger.new) {
        if(sfss.Lead__c <> null) {
            setLeadIds.add(sfss.Lead__c);
        }
        if(sfss.Account__c <> null) {
            setAccountIds.add(sfss.Account__c);
        }
    }

    // Setup maps of lead and account owners for use in loop
    mapLeadOwners = new Map<Id, Lead>([SELECT Id, OwnerId FROM Lead WHERE Id IN :setLeadIds]);
    mapAccountOwners = new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN :setAccountIds]);

    for(SFS_Shipping__c sfss : Trigger.new) {

        // Set the shipping record owner to the associated account owner, if it exists.  Or if there is no
        // associated account, set the shipping record owner to the associated lead owner, if it exists.
        if(sfss.Account__c <> null && mapAccountOwners.containsKey(sfss.Account__c)) {
            sfss.OwnerId = mapAccountOwners.get(sfss.Account__c).OwnerId;
        } else if(sfss.Lead__c <> null && mapLeadOwners.containsKey(sfss.Lead__c)) {
            sfss.OwnerId = mapLeadOwners.get(sfss.Lead__c).OwnerId;
        }
    }
}