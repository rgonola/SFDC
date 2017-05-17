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
public class TSM_RelateOpportunitytoAccountBatch implements Database.Batchable<sObject> {
    public TSM_RelateOpportunitytoAccountBatch() { 
    }
    // fetch all the new opportunities are replicated from TAA to SFS
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, TAA_Account_Record_Id__c, AccountId, 
                                         TAA_Primary_Contact_for_Proposal__c, Contact__c, X1Force_Account__c 
                                         FROM Opportunity 
                                         WHERE (AccountId = null OR Contact__c = null)
                                         AND TAA_Opportunity_Record_ID__c != null]);        
    }
    // process the selected opportunities
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        Map<Id, Id> acctMap = new Map<Id, Id>();
        Map<Id, Id> contMap = new Map<Id, Id>();
        Map<Id, Id> contAcctMap = new Map<Id, Id>();        
        Set<String> acctIds = new Set<String>();
        Set<String> contIds = new Set<String>();
        List<Opportunity> oppBatch = (List<Opportunity>) scope;
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        Map<String, Account> X1ForceAccountMap = new Map<String, Account>();
        Set<String> X1ForceAccounts = new Set<String>();
        
        for(Opportunity opp: oppBatch) {
            if(opp.AccountId == null) {
                if(opp.TAA_Account_Record_Id__c != null) {
            		acctIds.add(opp.TAA_Account_Record_Id__c.substring(0,opp.TAA_Account_Record_Id__c.length()));
            	}
            	if(opp.X1Force_Account__c != null) {
            		X1ForceAccounts.add(opp.X1Force_Account__c);
            	}
            }
            if(opp.Contact__c == null && opp.TAA_Primary_Contact_for_Proposal__c != null) {
            	contIds.add(opp.TAA_Primary_Contact_for_Proposal__c.substring(0,opp.TAA_Primary_Contact_for_Proposal__c.length()));
            }    
        }
        // Map of non-S2S shared Accounts
    	for(Account acct : [Select Id, X1Force_Account__c  From Account 
                            where X1Force_Account__c in : X1ForceAccounts and ConnectionReceivedId = null]) {
        	X1ForceAccountMap.put(acct.X1Force_Account__c, acct);
    	}
        // fetch the accounts of respective opportunities using taa account record ids
        for(Account acct: [SELECT Id, TAA_Account_Record_Id__c FROM Account 
                           WHERE TAA_Account_Record_Id__c IN :acctIds]) {
            acctMap.put(acct.TAA_Account_Record_Id__c.substring(0,acct.TAA_Account_Record_Id__c.length()), acct.Id);
        }
        // fetch the contacts of respective opportunities using taa contact record ids
        for(Contact cont: [SELECT Id, AccountId, TAA_Account_Record_Id__c, TAA_Contact_Record_Id__c 
                           FROM Contact WHERE TAA_Contact_Record_Id__c IN :contIds]) {
            contMap.put(cont.TAA_Contact_Record_Id__c.substring(0,cont.TAA_Contact_Record_Id__c.length()), cont.Id);
        	if(cont.TAA_Account_Record_Id__c != null && cont.AccountId != null) {
            	contAcctMap.put(cont.TAA_Account_Record_Id__c.substring(0,cont.TAA_Account_Record_Id__c.length()),cont.AccountId);                       
            }	
        }
        // relate the opportunities to accounts 
        for(Opportunity opp: oppBatch) {
            // set the accountid to opportunity
            if(opp.AccountId == null && opp.TAA_Account_Record_Id__c != null) {
            	if(acctMap.containsKey(opp.TAA_Account_Record_Id__c.substring(0,opp.TAA_Account_Record_Id__c.length()))) {
                	opp.AccountId = acctMap.get(opp.TAA_Account_Record_Id__c.substring(0,opp.TAA_Account_Record_Id__c.length()));                
                } else {
                    if(contAcctMap.containsKey(opp.TAA_Account_Record_Id__c.substring(0,opp.TAA_Account_Record_Id__c.length())))
                    	opp.AccountId = contAcctMap.get(opp.TAA_Account_Record_Id__c.substring(0,opp.TAA_Account_Record_Id__c.length()));
                }  
            }
            // Relate Opportunity to a non-S2S shared parent Account
            if(opp.X1Force_Account__c != null && opp.AccountId == null && X1ForceAccountMap.keySet().contains(opp.X1Force_Account__c)) { 
                opp.AccountId = X1ForceAccountMap.get(opp.X1Force_Account__c).Id;
            }
            // set the contact to opportunity
            if(opp.Contact__c == null && opp.TAA_Primary_Contact_for_Proposal__c != null && 
               contMap.containsKey(opp.TAA_Primary_Contact_for_Proposal__c.substring(0,opp.TAA_Primary_Contact_for_Proposal__c.length()))) {
                opp.Contact__c = contMap.get(opp.TAA_Primary_Contact_for_Proposal__c.substring(0,opp.TAA_Primary_Contact_for_Proposal__c.length()));                
            }
            oppsToUpdate.add(opp);
        }
        // update the opportunity records
        if(!oppsToUpdate.isEmpty())
               Database.update(oppsToUpdate, false);
    }
    
    public void finish(Database.BatchableContext bc) {
        // finish to start the next batch
        // scheduled time must be mentioned in seconds
    	TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        //Integer minutesGap = Integer.valueOf(tsmCS.ScheduleMinuteFrequency__c);
    	Integer secondsGap = Integer.valueOf(tsmCS.ScheduleSecondFrequency__c); 
    	DateTime scheduledTime = DateTime.now().addSeconds(secondsGap);
    	String timeString = scheduledTime.format( 'yyyy-MM-dd HH:mm:ss' );
    	String cronString = scheduledTime.format( 's m H d M ? yyyy' );
    	System.schedule('TSM_RelateOpportunityToAccountBatch - ' + timeString + ' (' + Math.random() + ')', cronString, new TSM_RelateOpportunityToAccountScheduler() );
    }        
}