/*
 * Trigger for Opportunty products replication from SFS org -> TAA org
 * */
trigger TSM_OpportunityLineItemTrigger on OpportunityLineItem (after insert, after update, after delete) {
    // this is to turn off the trigger based on the flag by using custom settings TSM_Trigger_Control__c
    Boolean isTriggerOff = TSM_Util.fetchTriggerOffFlag('OpportunityLineItem');
    if(!isTriggerOff) {
        // processing logic for new records 
        if(Trigger.isAfter && Trigger.isInsert) {
            TSM_OpportunityLineItemTriggerHandler.onAfterInsert(Trigger.new);
        }
        // processing logic for updated records
        if(Trigger.isAfter && Trigger.isUpdate) {
            TSM_OpportunityLineItemTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
        // processing logic for deleted records
        if(Trigger.isAfter && Trigger.isDelete) {
            TSM_OpportunityLineItemTriggerHandler.onAfterDelete(Trigger.old);
        }
    }    
}