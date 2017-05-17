/**********************************************************************
Name: bfInsUpdLead
Copyright © 2012 WK
======================================================
======================================================
Purpose: This Trigger is to prevent User to claim Leads of the Owner with same Role in the Hierarchy and 
         To copy Standard phone field value to custom fax field.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR            DATE           DETAIL 
1.0       Natesh            21/08/2012     INITIAL DEVELOPMENT 
2.0       Rajesh S Meti     29/08/2012     Added logic to copy Standard Fax field value to custom Fax field.
3.0       Rajesh S Meti     18/09/2012     Review changes and code refinement
***********************************************************************/
trigger bfInsUpdLead on Lead (before update, before insert) {
    Id AMFSNSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
    Id currentUserId;
    String newRoleName = '';
    String newOwnerName = '';
    String oldRoleName = '';
    String oldOwnerName = '';    
    
    String faxStandard = '';
    String faxCustom = '';    
    
    Map<Id,String> OwnerIdRoleMap = new Map<Id,String>();
    Map<Id,String> OwnerIdNameMap = new Map<Id,String>();
    Id unAssignedQueueId = [SELECT Id,Name FROM Group WHERE Type = 'Queue' AND Name = 'UN ASSIGNED'].Id;
    
    for(User userItem : [SELECT Id,UserRole.Name,Name FROM User]){
        OwnerIdRoleMap.put(userItem.Id, userItem.UserRole.Name);
        OwnerIdNameMap.put(userItem.Id, userItem.Name.toLowerCase());
    }
    
    for(Lead lead : Trigger.new){
        if(Trigger.isUpdate && lead.RecordTypeId == AMFSNSRecordTypeId && lead.OwnerId <> Trigger.oldMap.get(lead.Id).OwnerId){
            currentUserId = System.Userinfo.getUserId();
            
            newRoleName = OwnerIdRoleMap.get(System.Userinfo.getUserId());
            oldRoleName = OwnerIdRoleMap.get(Trigger.oldMap.get(lead.Id).OwnerId);
            oldOwnerName = OwnerIdNameMap.get(Trigger.oldMap.get(lead.Id).OwnerId);
            if(oldOwnerName <> null && !oldOwnerName.contains('integration')){
                if(OwnerIdNameMap.containsKey(lead.OwnerId)){
                    newOwnerName = OwnerIdNameMap.get(lead.OwnerId);
                }
                if(!newOwnerName.contains('integration') && lead.OwnerId != unAssignedQueueId){
                   if(newRoleName!=null && newRoleName!='' && oldRoleName!=null && oldRoleName!=''){
                        //If Old Owner is User
                        if(newRoleName.contains('User') && oldRoleName.contains('User') && currentUserId <> lead.OwnerId){
                            lead.addError('Do not have privilege to change Owner. Please contact System Administrator.');
                        }
                        //If Old Owner is Manager or Administrator
                        if(newRoleName.contains('User') && (oldRoleName.contains('Manager') || oldRoleName.contains('Administrator'))){
                            lead.addError('Do not have privilege to change Owner. Please contact System Administrator.');
                        }
                    }
                }
            }
            else{
                if(newRoleName <> null && newRoleName.contains('User') && currentUserId <> lead.OwnerId){
                    lead.addError('Lead cannot be claimed for other Sales Reps. Please assign to yourself or contact System Administrator.');
                }
            }
        } 
        
        // logic to copy Standard Fax field value to custom Fax field
        if(lead.RecordTypeId == AMFSNSRecordTypeId && lead.Fax <> null && lead.Fax <> ''){
            faxStandard = lead.Fax;
                faxStandard = faxStandard.replace('(','');
                faxStandard = faxStandard.replace(')','');
                faxStandard = faxStandard.replace('-','');
                faxStandard = faxStandard.replace(' ','');                
                faxCustom= faxStandard; 
            if(faxCustom.length() == 10){
                lead.Custom_Fax__c = faxCustom;
            }
        }
    }
}