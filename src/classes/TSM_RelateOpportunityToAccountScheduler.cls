/*
 * Batch apex process to perform the S2S records by relating the orphan opportunities to respective accounts & contacts  
 * It will only process the opportunities which were successfully replicated from TAA -> SFS
 * Batch class: TSM_RelateOpportunityToAccountBatch
 * Batch Scheduler: TSM_RelateOpportunityToAccountScheduler
 * Frequency: every 10 seconds (can be changed by using below custom settings)
 * Custom Settings: TSM_Custom_Settings.ScheduleSecondFrequency__c (10)  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/15/2016 Raj				1.0			Initial draft
 * ------------------------------------------------------------------------- */
/* Instructions to enable the batch scheduling time using TSM_Custom_Settings.ScheduleSecondFrequency__c
 * Need to set the value or change the frequency by seconds example: 10 
 * SET/CHANGE Batch frequency: Setup -> Develop -> Custom Settings -> TSM_Custom_Settings__c -> Manage -> enter
 *							ScheduleSecondFrequency__c = 10
 * START Batch: using Developer Console - Execute anonymous: 
 * 						Database.executeBatch(new TSM_RelateOpportunityToAccountBatch());
 * STOP Batch: Scheduled Jobs : Delete the batch with the name 'TSM_RelateOpportunityToAccountBatch - %' 
 * 				which is scheduled to run in future time.
 */
public class TSM_RelateOpportunityToAccountScheduler implements Schedulable{
    public void execute(SchedulableContext sc) {
        TSM_RelateOpportunityToAccountBatch rob = new TSM_RelateOpportunityToAccountBatch();
        Id jobId = Database.executeBatch(rob, 200);
        //Moves the specified job to the front of the flex queue, to index position 0        
        if(jobId != null)
        	Boolean success = (!Test.isRunningTest()) ? (FlexQueue.moveJobToFront(jobId)) : true;
        // for purging the completed scheduled job
        System.abortJob(sc.getTriggerId());
    }        
}