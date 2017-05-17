/**********************************************************************
Name: bfInsUpdAfDelAccountCheck250
Copyright © 2012 WK
======================================================
======================================================
Purpose: This trigger will be called when a new account is created or Updating the existing account.
         The purpose of this trigger is to check only 350 prospect accounts and open leads assigned to an user for "AM/FS/NS" record type.
         To copy Standard phone field value to custom phone field.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR            DATE           DETAIL 
1.0       Natesh            31/07/2012     INITIAL DEVELOPMENT
2.0       Natesh            23/08/2012     To copy Standard phone field value to custom phone field
3.0       Rajesh S Meti     29/08/2012     Added logic to copy Standard Fax field value to custom Fax field.
4.0       Rajesh S Meti     18/09/2012     Review changes and code refinement
5.0       Shirish D         21/02/2013     Increased the Lead assignment number to 350 from 250
***********************************************************************/
trigger bfInsUpdAfDelAccountCheck250 on Account (after delete, before insert, before update) {
    Id AMNSFSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Account'].Id;
    
    Set<Id> assignToUserSet = new set<Id>();
    Map<Id,Account> newAccountMap = new Map<Id,Account>();
    Map<Id,Account> oldAccountMap = new Map<Id,Account>();
    
    //2.0
    String phoneStandard = '';
    String phoneCustom = '';
    //3.0
    String faxStandard = '';
    String faxCustom = '';
        
    if((Trigger.isAfter && Trigger.isDelete) || (Trigger.isBefore && Trigger.isUpdate)){
        for(Account AccountItem : Trigger.old){
            assignToUserSet.add(AccountItem.OwnerId);
        }
        oldAccountMap = Trigger.oldMap;
    }
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        for(Account AccountItem : Trigger.new){
            System.debug('-----------AccountItem - ' + AccountItem);
            assignToUserSet.add(AccountItem.OwnerId);
        }
        newAccountMap = Trigger.newMap;
    }
    
    //Retrieve RR Member Records
    Map<Id,RR_Member__c> RRMemberMap = new Map<Id,RR_Member__c>();
    for(RR_Member__c MemberItem :[SELECT Id, Member__c, No_of_Other_Leads_Assigned__c, 
                                  Total_Leads_Assigned__c
                                  FROM RR_Member__c
                                  WHERE Member__c IN :assignToUserSet]){
        MemberItem.Total_Leads_Dummy__c = MemberItem.Total_Leads_Assigned__c;
        RRMemberMap.put(MemberItem.Member__c,MemberItem);
    }
    
    //Decrement Lead Count in Queue Member Object if Prospect Account is deleted
    if(Trigger.isAfter && Trigger.isDelete){
        RR_Member__c RRMemberRecord = new RR_Member__c();
        List<RR_Member__c> RRMemberList = new List<RR_Member__c>();
        for(Account AccountItem : Trigger.old){
            if(AccountItem.RecordTypeId == AMNSFSRecordTypeId && AccountItem.Type == 'Prospect'){
                if(RRMemberMap.containsKey(AccountItem.OwnerId)){
                    RRMemberRecord = new RR_Member__c();
                    RRMemberRecord = RRMemberMap.get(AccountItem.OwnerId);
                    if(RRMemberRecord.No_of_Other_Leads_Assigned__c > 0){
                        RRMemberRecord.No_of_Other_Leads_Assigned__c = RRMemberRecord.No_of_Other_Leads_Assigned__c - 1;
                        RRMemberRecord.Total_Leads_Dummy__c = RRMemberRecord.Total_Leads_Dummy__c - 1;
                        RRMemberMap.put(AccountItem.OwnerId,RRMemberRecord);
                    }
                }
            }
        }
        
        RRMemberList = RRMemberMap.values();
        if(RRMemberList <> null && RRMemberList.size() > 0){
            update RRMemberList;
        }
    }
    
    //If An Prospect Account is Created or Existing Account is Updated with new Owner or to Prospect then Check for 350 count before assign and update the count
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        RR_Member__c RRMemberRecord = new RR_Member__c();
        RR_Member__c oldRRMemberRecord = new RR_Member__c();
        
        Account oldAccountItem = new Account();
        List<RR_Member__c> RRMemberList = new List<RR_Member__c>();
        for(Account AccountItem : Trigger.new){
            if(AccountItem.RecordTypeId == AMNSFSRecordTypeId){
                if(RRMemberMap.containsKey(AccountItem.OwnerId)){
                    RRMemberRecord = new RR_Member__c();
                    RRMemberRecord = RRMemberMap.get(AccountItem.OwnerId);
                    if((AccountItem.Type == 'Prospect') && (Trigger.isInsert || 
                       (Trigger.isUpdate && (oldAccountMap.get(AccountItem.Id).Type <> 'Prospect' || 
                       AccountItem.OwnerId <> oldAccountMap.get(AccountItem.Id).OwnerId)))){
                        if(RRMemberRecord.Total_Leads_Dummy__c < 350){
                            RRMemberRecord.No_of_Other_Leads_Assigned__c = RRMemberRecord.No_of_Other_Leads_Assigned__c + 1;
                            RRMemberRecord.Total_Leads_Dummy__c = RRMemberRecord.Total_Leads_Dummy__c + 1;
                            RRMemberMap.put(AccountItem.OwnerId,RRMemberRecord);
                        }
                        else{
                            AccountItem.addError('This Owner Already Assigned with 350 Open Leads and Prospect Accounts.');
                        }
                    }
                    
                    if(Trigger.isUpdate && oldAccountMap.get(AccountItem.Id).Type == 'Prospect' && AccountItem.Type <> 'Prospect'){
                        if(RRMemberRecord.Total_Leads_Dummy__c > 0){
                            RRMemberRecord.No_of_Other_Leads_Assigned__c = RRMemberRecord.No_of_Other_Leads_Assigned__c - 1;
                            RRMemberRecord.Total_Leads_Dummy__c = RRMemberRecord.Total_Leads_Dummy__c - 1;
                            RRMemberMap.put(AccountItem.OwnerId,RRMemberRecord);
                        }
                    }
                }
                
                if(Trigger.isUpdate && AccountItem.OwnerId <> oldAccountMap.get(AccountItem.Id).OwnerId){
                    oldAccountItem = oldAccountMap.get(AccountItem.Id);
                    if(oldAccountItem.Type == 'Prospect'){
                        if(RRMemberMap.containsKey(oldAccountItem.OwnerId)){
                            oldRRMemberRecord = new RR_Member__c();
                            oldRRMemberRecord = RRMemberMap.get(oldAccountItem.OwnerId);
                            if(oldRRMemberRecord.Total_Leads_Dummy__c > 0){
                                oldRRMemberRecord.No_of_Other_Leads_Assigned__c = oldRRMemberRecord.No_of_Other_Leads_Assigned__c - 1;
                                oldRRMemberRecord.Total_Leads_Dummy__c = oldRRMemberRecord.Total_Leads_Dummy__c - 1;
                                RRMemberMap.put(oldAccountItem.OwnerId,oldRRMemberRecord);
                            }
                        }
                    }
                }
                
                //2.0
                if(AccountItem.Phone <> null && AccountItem.Phone <> ''){
                    phoneStandard = AccountItem.Phone;
                    phoneStandard = phoneStandard.replace('(','');
                    phoneStandard = phoneStandard.replace(')','');
                    phoneStandard = phoneStandard.replace('-','');
                    phoneStandard = phoneStandard.replace(' ','');                
                    phoneCustom = phoneStandard; 
                    if(phoneCustom.length() == 10){
                        AccountItem.Phone__c = phoneCustom;
                    }
                }
                
                //3.0
                if(AccountItem.Fax <> null && AccountItem.Fax <> ''){
                    faxStandard = AccountItem.Fax;
                    faxStandard = faxStandard.replace('(','');
                    faxStandard = faxStandard.replace(')','');
                    faxStandard = faxStandard.replace('-','');
                    faxStandard = faxStandard.replace(' ','');                
                    faxCustom= faxStandard; 
                    if(faxCustom.length() == 10){
                        AccountItem.Custom_Fax__c = faxCustom;
                    }
                }
            }
        }
        RRMemberList = RRMemberMap.values();
        if(RRMemberList <> null && RRMemberList.size() > 0){
            update RRMemberList;
        }
    }
}