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
public class TSM_RelateContactsToAccountsBatch implements Database.Batchable<sObject> {
    public TSM_RelateContactsToAccountsBatch() { 
    }
    // fetch all the new accounts are created in TAA which are replicated to SFS
    public Database.QueryLocator start(Database.BatchableContext bc) {
        //if(Test.isRunningTest()) {
        	return Database.getQueryLocator([SELECT Id, TAA_Account_Record_Id__c, AccountId FROM Contact 
                                         WHERE AccountId = null 
                                         AND TAA_Account_Record_Id__c != null]);
        //} else {
        //    return Database.getQueryLocator([SELECT Id, TAA_Account_Record_Id__c, AccountId FROM Contact 
        //                                WHERE AccountId = null AND ConnectionReceivedId != null 
        //                                 AND TAA_Account_Record_Id__c != null]);
        //}
        
    }
    // process the selected accounts
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        Map<Id, Account> acctMap = new Map<Id, Account>();
        List<Contact> contBatch = (List<Contact>) scope;
        Set<String> acctIds = new Set<String>();
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Contact cont: contBatch) {
            acctIds.add(cont.TAA_Account_Record_Id__c.substring(0,cont.TAA_Account_Record_Id__c.length()));
        }
        // fetch the accounts of respective taa account record ids
        for(Account acct: [SELECT Id, TAA_Account_Record_Id__c FROM Account 
                           WHERE TAA_Account_Record_Id__c IN :acctIds]) {
            acctMap.put(acct.TAA_Account_Record_Id__c.substring(0,acct.TAA_Account_Record_Id__c.length()), acct);
        }
        // relate the contacts to accounts 
        for(Contact cont: contBatch) {
            if(acctMap.containsKey(cont.TAA_Account_Record_Id__c.substring(0,cont.TAA_Account_Record_Id__c.length()))) {
                cont.AccountId = acctMap.get(cont.TAA_Account_Record_Id__c.substring(0,cont.TAA_Account_Record_Id__c.length())).Id;
                contactsToUpdate.add(cont);
            }
        }
        // update the records
        if(!contactsToUpdate.isEmpty())
               Database.update(contactsToUpdate, false);
    }
    
    public void finish(Database.BatchableContext bc) {
        // finish to start the next batch
        // scheduled time must be mentioned in minutes
    	TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        Integer secondsGap = Integer.valueOf(tsmCS.ScheduleSecondFrequency__c);
    	DateTime scheduledTime = DateTime.now().addSeconds( secondsGap );
    	String timeString = scheduledTime.format( 'yyyy-MM-dd HH:mm:ss' );
    	String cronString = scheduledTime.format( 's m H d M ? yyyy' );
    	System.schedule('TSM_RelateContactsToAccountsBatch - ' + timeString + ' (' + Math.random() + ')', cronString, new TSM_RelateContactsToAccountsScheduler() );
	}        
}