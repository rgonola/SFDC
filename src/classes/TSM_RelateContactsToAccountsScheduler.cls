/*
 * Batch apex process to perform the S2S records by relating the orphan contacts to respective accounts  
 * It will only process the contacts which were successfully replicated from TAA -> SFS
 * Batch class: TSM_RelateContactsToAccountsBatch
 * Batch Scheduler: TSM_RelateContactsToAccountsScheduler
 * Frequency: every 10 seconds (can be changed by using below custom settings)
 * Custom Settings: TSM_Custom_Settings.ScheduleSecondFrequency__c (10)  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/08/2016 Raj				1.0			Initial draft
 * ------------------------------------------------------------------------- */
/* Instructions to enable the batch scheduling time using TSM_Custom_Settings.ScheduleSecondFrequency__c
 * Need to set the value or change the frequency by seconds example: 10 
 * SET/CHANGE Batch frequency: Setup -> Develop -> Custom Settings -> TSM_Custom_Settings__c -> Manage -> enter
 *							ScheduleSecondFrequency__c = 10
 * START Batch: using Developer Console - Execute anonymous: 
 * 						Database.executeBatch(new TSM_RelateContactsToAccountsBatch());
 * STOP Batch: Scheduled Jobs : Delete the batch with the name 'TSM_RelateContactsToAccountsBatchh - %' 
 * 				which is scheduled to run in future time.
 */
public class TSM_RelateContactsToAccountsScheduler implements Schedulable{
    public void execute(SchedulableContext sc) {
        TSM_RelateContactsToAccountsBatch rcb = new TSM_RelateContactsToAccountsBatch();
        Database.executeBatch(rcb, 200);  
        // for purging the completed scheduled job
        System.abortJob(sc.getTriggerId());
    }        
}