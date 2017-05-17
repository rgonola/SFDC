/**********************************************************************
Name: afInsUpdOpportunity
Copyright © 2012 WK
======================================================
======================================================
Purpose: This trigger will be called when a new Opportunity is created or existing Opportunity is updated.
         This will update the Type field in Account object based on the Refunds Customer Type in Opportunity.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR            DATE           DETAIL 
1.0       Natesh Alagiri    08/14/2012     Initial Development
2.0       Rajesh S. Meti    08/23/2012     When an Opportunity is been created by anyone it should always take 
                                           the Opportunity Owner as Account Owner
3.0       Natesh Alagiri    10/04/2012     When an Opportunity is been created then, Current Provider will be
                                           assigned as Account's Prior Software Vendor.
3.1       Ted Shevlin       03/29/2013     Code refactoring
                                           Code commenting
                                           Removed code that sets the parent account type based on the opportunity
                                           Refund Customer Type
***********************************************************************/
trigger afInsUpdOpportunity on Opportunity (before insert, after insert, after update) {

    // Constants

    // Record type for Account Management, Field Sales, New Sales
    final String RECORD_TYPE_OPPTY_AMFSNS = 'AM/FS/NS Opportunity';
    final Id RECORD_TYPE_ID_OPPTY_AMFSNS = [SELECT Id FROM RecordType WHERE Name = :RECORD_TYPE_OPPTY_AMFSNS].Id;

/*TED:  DISABLED.  Added to cross-object workflow.
 *    Set<Id> accountIdSet = new Set<Id>();
 */
    Set<Id> setAMNSFSAccountId = new Set<Id>();
    Map<Id, User> mapUsers = new Map<Id,User>([SELECT Id FROM User WHERE IsActive = true]);    

    for(Opportunity opp :Trigger.new) {
/*TED:  DISABLED.  Added to cross-object workflow.
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate &&
                                                   opp.Refund_Customer_type__c <>
                                                   Trigger.oldMap.get(opp.Id).Refund_Customer_type__c) && 
           opp.RecordTypeId == RECORD_TYPE_ID_OPPTY_AMFSNS) {
            accountIdSet.add(opp.AccountId);
        }
TED*/

        // Set of Acctount Ids to get Account Owner Ids to update Opportunity Owner when an Opportunity is created
        if(Trigger.isBefore && Trigger.isInsert && opp.RecordTypeId == RECORD_TYPE_ID_OPPTY_AMFSNS) 
            setAMNSFSAccountId.add(opp.AccountId);
    }

/*TED:  DISABLED.  Added to cross-object workflow.
    Map<Id,Account> accountMap = new Map<Id,Account>();
    if(accountIdSet <> null && accountIdSet.size() > 0) {
        accountMap = new Map<Id,Account>([SELECT Id, Type FROM Account WHERE Id IN :accountIdSet]);
    }
TED*/
    Map<Id,Account> mapAMNSFSAccount = new Map<Id,Account>();

    // Retrieve accounts and OwnerIds
    if(setAMNSFSAccountId <> null && setAMNSFSAccountId.size() > 0) {
        mapAMNSFSAccount = new Map<Id,Account>([SELECT Id, OwnerId, Prior_Software_Vendor__c
                                                FROM Account
                                                WHERE Id IN :setAMNSFSAccountId]);
    }

    for(Opportunity opp :Trigger.new) {
/*TED:  DISABLED.  Added to cross-object workflow.
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate &&
                                                   opp.Refund_Customer_type__c <>
                                                   Trigger.oldMap.get(opp.Id).Refund_Customer_type__c) && 
           accountMap.containsKey(opp.AccountId) && opp.RecordTypeId == RECORD_TYPE_ID_OPPTY_AMFSNS) {
            Account newAccount = accountMap.get(opp.AccountId);
            if(opp.Refund_Customer_type__c == 'Prospect')
                newAccount.Type = 'Prospect';
            if(opp.Refund_Customer_type__c == 'Non Renewed')
                newAccount.Type = 'Non-renewed customer';
            if(opp.Refund_Customer_type__c == 'Prior Customer')
                newAccount.Type = 'Prior Customer';
            if(opp.Refund_Customer_type__c == 'First Year Non Renewed')
                newAccount.Type = 'First Year Non Renewed';
            
            accountMap.put(opp.AccountId,newAccount);
        }
TED*/
        // When inserting opportunities of record type 'AM/FS/NS Opportunity',
        //     Set opportunity owner to associated account owner
        //     Set opportunity current provider to account prior software vendor
        if(Trigger.isBefore && Trigger.isInsert &&
           opp.RecordTypeId == RECORD_TYPE_ID_OPPTY_AMFSNS && mapAMNSFSAccount.containsKey(opp.AccountId)) {

            // Set opportunity owner to the associated account owner
            if(mapUsers.containsKey(mapAMNSFSAccount.get(opp.AccountId).OwnerId)) {
                opp.OwnerId = mapAMNSFSAccount.get(opp.AccountId).OwnerId;
            }

            // Set opportunity current provider to account prior software vendor
            // While copying the current provider from the account to the opportunity could be done
            // through workflow, the number of picklist values makes that prohibitive.
            opp.Current_Provider__c = mapAMNSFSAccount.get(opp.AccountId).Prior_Software_Vendor__c;
        }
    }

/*TED:  DISABLED.  Added to cross-object workflow.
    List<Account> accountList = accountMap.values();
    if(accountList <> NULL && accountList.size() > 0)
        update accountList;
TED*/
}