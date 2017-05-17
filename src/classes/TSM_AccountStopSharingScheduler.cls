/*
 * Batch process to stop sharing the accounts and contacts which are being shared thru Salesforce2Salesforce (TAA->SFS)
 * It will only stop sharing accounts and contacts which were successfully replicated in SFS
 * Batch class: TSM_AccountStopSharingBatch
 * Batch Scheduler: TSM_AccountStopSharingScheduler
 * Frequency: every 10 seconds (can be changed by using below custom settings)
 * Custom Settings: TSM_Custom_Settings.ScheduleSecondFrequency__c (1)
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/30/2016 Raj				1.0			Initial draft
 * ------------------------------------------------------------------------- */
/* Instructions to enable the batch scheduling time using TSM_Custom_Settings.ScheduleSecondFrequency__c
 * Need to set the value or change the frequency by seconds example: 10 
 * SET/CHANGE Batch frequency: Setup -> Develop -> Custom Settings -> TSM_Custom_Settings__c -> Manage -> enter
 *							ScheduleSecondFrequency__c = 10
 * START Batch: using Developer Console - Execute anonymous: 
 * 						Database.executeBatch(new TSM_AccountStopSharingBatch());
 * STOP Batch: Scheduled Jobs : Delete the batch with the name 'TSM_AccountStopSharingBatch - %' 
 * 				which is scheduled to run in future time.
 */
public class TSM_AccountStopSharingScheduler implements Schedulable{
    public void execute(SchedulableContext sc) {
        TSM_AccountStopSharingBatch osb = new TSM_AccountStopSharingBatch();
        Database.executeBatch(osb, 200);    
        // for purging the completed scheduled job
        System.abortJob(sc.getTriggerId());
    }        
}