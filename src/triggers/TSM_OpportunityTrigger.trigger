/*
 * trigger to perform the S2S records replication for TAA <-> SFS orgs  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/01/2016 AA				1.0			Initial draft
 * ------------------------------------------------------------------------- */
trigger TSM_OpportunityTrigger on Opportunity (before insert, after insert) {
    // this is to turn off the trigger based on the flag by using custom settings TSM_Trigger_Control__c
    Boolean isTriggerOff = TSM_Util.fetchTriggerOffFlag('Opportunity');
    if(!isTriggerOff) {    
        // for before insert
        if(Trigger.isBefore && Trigger.isInsert) {
           TSM_OpportunityTriggerHandler.onBeforeInsert(trigger.new);        
        }
        // for after insert
        if(Trigger.isAfter && Trigger.isInsert) {
            TSM_OpportunityTriggerHandler.onAfterInsert(trigger.new);        
        }
    }    
}