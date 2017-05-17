/**********************************************************************
Name: beforeInsertUpdateAccountUpdateEXP
Copyright © 2012 WK
======================================================
======================================================
Purpose: This trigger will be called when a new Account is created or when existing Account is updated.
         This will update the Contract Expiration Date when process is updated to 'Sign & Close a Customer' 
         or 'Sign & Close a prospect'.
         This will update Parent Account based on OFFC and PID
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION    AUTHOR        DATE           DETAIL 
1.0        Natesh        04/24/2012     INITIAL DEVELOPMENT 
2.0        Rajesh Meti   05/30/2012     Added logic to update Parent AccountId on child Account 
3.0        Ted Shevlin   03/30/2013     Code refactoring
                                        Code commenting
                                        Variable renaming for consistency
                                        Removed owner extension code; made formula field off Account Owner Hidden
4.0       Vaibhav        6/6/2013       Removed the 'isInsert' condition from Line no 142,as it should work on Insert and Update    
                                        
                                        PID and OFFC conditions matching 
                                        While Inserting Records
                                        a) If newly inserting Account's field 'PID' matched with existing Account's 'PID' and 'OFFC' is not zero then we are associating that Account's record id as Parent to newly created Account.
                                        b) If we found multiple matching of 'PID' with existing Account's PID and 'OFFC' is not zero on newly inserted Account record then which matched Account
                                        
                                        While Updating Records
                                        a) If the 'OFFC' of newly created record is zero and PID match is not found with existing Accounts PID then reset the Parent Account as null.
                                        b) If the 'OFFC' of newly created record is zero and PID match is found then set the Parent Account as null                     
                                        
***********************************************************************/
trigger beforeInsertUpdateAccountUpdateEXP on Account (before insert, before update) {

    // Constants
    final String RECORD_TYPE_ACCT_AMFSNS = 'AM/FS/NS Account';
    final String RECORD_TYPE_ACCT_REFTOD = 'Refunds Today Account';
    final Id AMFSNSRecordTypeId = [SELECT Id FROM RecordType WHERE Name = :RECORD_TYPE_ACCT_AMFSNS].Id;
    final Id RefundsTodayRecordTypeId = [SELECT  Id FROM RecordType WHERE Name = :RECORD_TYPE_ACCT_REFTOD].Id;

/* TED: Pre-existing workflow already handles this
    Date currentDate = System.today();
    Integer currentEXPYear, nextYear = currentDate.year() + 1;
    String currentEXPValue, nextContractEXP, nextContractEXPnull = nextYear + ' EXP';
TED*/

    Set<Id> setOwnerIds = new Set<Id>();
    Set<String> setAccountPIDs = new Set<String>();
    Map<Id, String> mapOwnerIdNames = new Map<Id, String>();
    Map<String, Account> mapAccountPIDs = new Map<String, Account>();

    // Build setAccountPIDs
    for(Account AccountRecord : Trigger.new) {
/* TED: Pre-existing workflow already handles this
 *        setOwnerIds.add(AccountRecord.OwnerId);
 */
        if(AccountRecord.RecordTypeId == AMFSNSRecordTypeId && 
           (AccountRecord.OFFC__c != 0 && AccountRecord.OFFC__c != null) &&
           (AccountRecord.PID__c != '' && AccountRecord.PID__c != null))  {
            setAccountPIDs.add(AccountRecord.PID__c);
        }
    }
/*TED: Remove and turn to formula field
*    Map<Id, User> ownerExtensionMap=new Map<Id,User>([select id,Extension from user where Id in :setOwnerIds]);
*/

    // Build the mapOwnerIdNames and mapAccountPIDs maps
    for(User UserRecord : [SELECT Id, Name FROM User WHERE Id in :setOwnerIds]) {
        mapOwnerIdNames.put(UserRecord.Id, UserRecord.Name);
    }
    if(setAccountPIDs.size() > 0) {
        for(Account account : [SELECT Id, PID__c,LastModifiedDate FROM Account WHERE PID__c IN :setAccountPIDs AND  
                               RecordTypeId = :AMFSNSRecordTypeId AND OFFC__c = 0 ]) {
            if(mapAccountPIDs.containsKey(account.PID__c )){
                if(mapAccountPIDs.get(account.PID__c).LastModifiedDate < account.LastModifiedDate){                   
                    mapAccountPIDs.put(account.PID__c, account);
                }
            }
            else{
                 mapAccountPIDs.put(account.PID__c, account);
            }
        }
    } 

/* TED: Pre-existing workflow already handles this
    // Update Contract Expiration Date When a new Account is created
    if(Trigger.isBefore && Trigger.isInsert) {
        for(Account AccountRecord : Trigger.new) {
            if(AccountRecord.RecordTypeId == RefundsTodayRecordTypeId) {
                if((AccountRecord.Process__c == 'Sign & Close a Customer' || 
                    AccountRecord.Process__c == 'Sign & Close a prospect')) { 
                    
                    if(AccountRecord.Contract_Expiration_Date__c <> null && 
                    AccountRecord.Contract_Expiration_Date__c <> '') {
                        currentEXPValue = AccountRecord.Contract_Expiration_Date__c;
                        currentEXPYear = Integer.valueOf(currentEXPValue.substring(0, 4));
                        nextContractEXP = currentEXPYear + 1 + ' EXP';
                        AccountRecord.Contract_Expiration_Date__c = nextContractEXP;
                    }
                    if((AccountRecord.Contract_Expiration_Date__c == null || 
                    AccountRecord.Contract_Expiration_Date__c == '')) {
                        AccountRecord.Contract_Expiration_Date__c = nextContractEXPnull;
                    }
                }
            }
        }
    }

    //Update Contract Expiration Date When an existing Account is updated
    if(Trigger.isBefore && Trigger.isUpdate) {
        for(Account AccountRecord : Trigger.new) {
            if(AccountRecord.RecordTypeId == RefundsTodayRecordTypeId) {
                if(AccountRecord.Process__c <> Trigger.oldMap.get(AccountRecord.Id).Process__c &&
                    (AccountRecord.Process__c == 'Sign & Close a Customer' || 
                    AccountRecord.Process__c == 'Sign & Close a prospect')) { 

                    if((AccountRecord.Contract_Expiration_Date__c <> null && 
                    AccountRecord.Contract_Expiration_Date__c <> '') &&
                    AccountRecord.Contract_Expiration_Date__c == Trigger.oldMap.get(AccountRecord.Id).Contract_Expiration_Date__c) {
                        currentEXPValue = AccountRecord.Contract_Expiration_Date__c;
                        System.debug('Update-------currentEXPValue--------' + currentEXPValue);
                        currentEXPYear = Integer.valueOf(currentEXPValue.substring(0,4));
                        System.debug('-------currentEXPYear--------' + currentEXPYear);
                        nextContractEXP = currentEXPYear + 1 + ' EXP';
                        System.debug('-------nextContractEXP--------' + nextContractEXP);
                        AccountRecord.Contract_Expiration_Date__c = nextContractEXP;
                    }
                    if(AccountRecord.Contract_Expiration_Date__c == null || 
                    AccountRecord.Contract_Expiration_Date__c == '') {
                        AccountRecord.Contract_Expiration_Date__c = nextContractEXPnull;
                    }
                }
            }
        }
    }
TED*/

    for(Account a : Trigger.new) {

        // For Refunds Today accounts,
        //     If Premier Account Manager is empty, set the picklist value to the account owner's name
        if(a.RecordTypeId == RefundsTodayRecordTypeId) {
            if(a.Premier_Account_Manager__c == '' || a.Premier_Account_Manager__c == null) {
                a.Premier_Account_Manager__c = mapOwnerIdNames.get(a.OwnerId);
            }
        }

        // For Am/FS/NS accounts,
        //     Set the Account Owner Hidden field to the Owner field
        //     The Account Owner Hidden field allows workflows and formula fields to retrieve owner fields
        //     At implementation time, workflows and formulas did not allow access to owner fields
        if(a.RecordTypeId == AMFSNSRecordTypeId) {
            a.Account_Owner_Hidden__c = a.OwnerId;
/*TED:  Remove and turn to formula field
 *           a.Account_Owner_Extension__c = ownerExtensionMap.get(a.OwnerId).Extension;
 */
            /*Commented @ Vaibhav for removing 'isInsert', As we want Trigger should work on insert and update scenario */
            //if(Trigger.isInsert && a.OFFC__c != 0 && mapAccountPIDs.containskey(a.PID__c)) {
              if(a.OFFC__c != 0 && mapAccountPIDs.containskey(a.PID__c)) {
                  a.ParentId = mapAccountPIDs.get(a.PID__c).id;
              } 

              //Added by Vaibhav 
              //Logic to Update the a.ParentId to null if OFFC__c is 0 and PID__c doesnot match with parent Account's 
              else if(Trigger.isUpdate && !mapAccountPIDs.containskey(a.PID__c)){
                  a.ParentId = null;
              }
        }
    }
}