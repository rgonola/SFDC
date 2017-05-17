/*
 * trigger to perform the S2S records replication for TAA <-> SFS orgs  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/05/2016 RP				1.0			Initial draft
 * ------------------------------------------------------------------------- */
trigger TSM_AccountTrigger on Account (before insert) {
    // this is to turn off the trigger based on the flag by using custom settings TSM_Trigger_Control__c
    Boolean isTriggerOff = TSM_Util.fetchTriggerOffFlag('Account');
    if(!isTriggerOff) {
    	// processing the new S2S replicated records to set the ownership
        if(Trigger.isBefore && Trigger.isInsert) {
            TSM_AccountTriggerHandler.onBeforeInsert(Trigger.new);
        }
    }    
}