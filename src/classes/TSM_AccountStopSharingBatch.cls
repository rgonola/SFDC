/*
 * Batch process to stop sharing the accounts and contacts which are being shared thru Salesforce2Salesforce (TAA->SFS)
 * It will only stop sharing accounts and contacts which were successfully replicated in SFS
 * Batch class: TSM_AccountStopSharingBatch
 * Batch Scheduler: TSM_AccountStopSharingScheduler
 * Frequency: every 10 seconds (can be changed by using below custom settings)
 * Custom Settings: TSM_Custom_Settings.ScheduleSecondFrequency__c (10)
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
public class TSM_AccountStopSharingBatch implements Database.Batchable<sObject> {
    public TSM_AccountStopSharingBatch() { 
    }
    // fetch all the new accounts & contacts which are replicated to SFS
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String querytest = 'SELECT Id, AccountId FROM Contact';
        String query = 'SELECT Id, AccountId FROM Contact WHERE ConnectionReceivedId != null';
        String finalquery = (!Test.isRunningTest()) ? query : querytest;
        // unable to test the scenario using mock data for PNRC related fields i.e.ConnectionReceivedId
        return Database.getQueryLocator(finalquery);        
    }
    // process the selected contacts and accounts
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        Id networkId = TSM_Util.getNetworkId(tsmCS.ConnectionName__c);        
        
        List<PartnerNetworkRecordConnection> existingShrList = new List<PartnerNetworkRecordConnection>();
        Map<Id, PartnerNetworkRecordConnection> oldAcctShrMap = new Map<Id, PartnerNetworkRecordConnection>();
        Map<Id, PartnerNetworkRecordConnection> oldContShrMap = new Map<Id, PartnerNetworkRecordConnection>();        
        List<Contact> contBatch = (List<Contact>) scope;
        Set<Id> acctIds = new Set<Id>();
        Set<Id> contIds = new Set<Id>();
        for(Contact con: contBatch) {
            contIds.add(con.Id);            
        }
        String acctQueryTest = 'SELECT Id FROM Account';
        String acctQuery = 'SELECT Id FROM Account WHERE ConnectionReceivedId != null';
        String finalacctQuery = (!Test.isRunningTest()) ? acctQuery : acctQueryTest;        
        // fetch the accounts which are replicated to SFS
        for(Account acct : Database.query(finalacctQuery)) {
            acctIds.add(acct.Id);
        }
        // fetch the active sharing entries of all contacts
        oldContShrMap = TSM_Util.fetchExistingShares(contIds, networkId);
		// delete the contact sharing records so that it will change the PNRC status to Inactive
        TSM_Util.deleteShares(oldContShrMap.values(), 'TSM_AccountStopSharingBatch','Batch');
        // fetch the active sharing entries of all accounts
        oldAcctShrMap = TSM_Util.fetchExistingShares(acctIds, networkId);
        // delete the account sharing records so that it will change the status to Inactive
        TSM_Util.deleteShares(oldAcctShrMap.values(), 'TSM_AccountStopSharingBatch', 'Batch');
    }
    
    public void finish(Database.BatchableContext bc) {
        // finish to start the next batch
        // scheduled time must be mentioned in seconds
    	TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        Integer secondsGap = Integer.valueOf(tsmCS.ScheduleSecondFrequency__c);
    	DateTime scheduledTime = DateTime.now().addSeconds( secondsGap );
    	String timeString = scheduledTime.format( 'yyyy-MM-dd HH:mm:ss' );
    	String cronString = scheduledTime.format( 's m H d M ? yyyy' );
    	System.schedule('TSM_AccountStopSharingBatch - ' + timeString + ' (' + Math.random() + ')', cronString, new TSM_AccountStopSharingScheduler() );    	
    }        
}