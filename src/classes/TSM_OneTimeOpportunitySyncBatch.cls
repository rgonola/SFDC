/*
 * one time batch process to sync the opportunities from SFS to TAA
 * Prerequisite: None
 * START Batch: using Developer Console - Execute anonymous: 
 * 						Database.executeBatch(new TSM_OneTimeOpportunitySyncBatch());
 * Once it is completed in SFS, need to run the lookup relationship fields mapping batch on TAA side too.
 * */
public class TSM_OneTimeOpportunitySyncBatch implements Database.Batchable<sObject> {
    public TSM_OneTimeOpportunitySyncBatch() {
        
    }
    // need to fetch the respective opportunities which must be replicated from SFS to TAA
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // fetch the opportunities with the matching criteria
        return Database.getQueryLocator([SELECT Id FROM Opportunity 
                                             WHERE ConnectionReceivedId = null AND
                                            Migrate_Oppty__c=true]);        
    }   

    // process the selected opportunities
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        Set<Id> oppIds = new Set<Id>();
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        Id networkId = TSM_Util.getNetworkId(tsmCS.ConnectionName__c);        
        Map<Id, PartnerNetworkRecordConnection> oldOpptyShrMap = new Map<Id, PartnerNetworkRecordConnection>();        
        List<PartnerNetworkRecordConnection> newOpptyShrList = new List<PartnerNetworkRecordConnection>();
		List<Opportunity> oppBatch = (List<Opportunity>) scope;
        // identify the opportunities ids
        for(Opportunity opp: oppBatch) {
            oppIds.add(opp.Id);
        }
        // fetch the active sharing entries of all opportunities
        oldOpptyShrMap = TSM_Util.fetchExistingShares(oppIds, networkId);  
        for(Opportunity opp: oppBatch) {
            // ensuring that there are no existing PNRC shares for the opportunities
            if(!oldOpptyShrMap.containsKey(opp.Id))
        		newOpptyShrList.add(TSM_Util.prepareShare(opp.Id, networkId, null));
        }
        // insert the new opportunity sharing records
        TSM_Util.insertShares(newOpptyShrList, 'TSM_OneTimeOpportunitySyncBatch','Batch');  
    }
    
    public void finish(Database.BatchableContext bc) {
        // no action required            	
    }        
}