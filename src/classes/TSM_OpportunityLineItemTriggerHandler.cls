/*
 * Helper class to replicate the opportunitylineitems (opportunity products) from SFS to TAA
 * */
public class TSM_OpportunityLineItemTriggerHandler {
	
    // processing logic to replicate the TSM_Shared_Product__c from SFS to TAA
    public static void onAfterInsert(List<OpportunityLineItem> newRecords) {
    	// get the connectionname
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
	   	Id networkId = TSM_Util.getNetworkId(tsmCS.connectionName__c);  
        Set<String> oppIds = new Set<String>();
        List<TSM_Shared_Product__c> newShrProducts= new List<TSM_Shared_Product__c>();
        List<OpportunityLineItem> oppItemsList = new List<OpportunityLineItem>();
        // identify the records that meet the criteria
        for(OpportunityLineItem item: newRecords) {
            if(item.ConnectionReceivedId == null) {
                // for identifying the steelbrick opportunities which must be sent to TAA
                if(item.X1Force_Product__c != null && item.Oppty_Record_ID__c != null && item.OpportunityId != null) {
                	oppIds.add(item.OpportunityId);  
                    oppItemsList.add(item);
                }                    
            }
        }  
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        // identify the opptys which are related to steelbrick opportunities
        // 
        If(Test.isRunningTest()) {
            oppMap = new Map<Id, Opportunity>([SELECT Id, TAA_Opportunity_Record_Id__c FROM Opportunity WHERE Id IN :oppIds AND TAA_Opportunity_Record_Id__c != null]);
        } else {
        	oppMap = new Map<Id, Opportunity>([SELECT Id, ConnectionReceivedId FROM Opportunity WHERE Id IN :oppIds AND ConnectionReceivedId != null]);            
        }
        
        // process the identified / selected records which meets the criteria 
        for(OpportunityLineItem item: oppItemsList) {
            // if the opportunity is shared between SFS and TAA
            if(oppMap.containsKey(item.OpportunityId)) {
                newShrProducts.add(new TSM_Shared_Product__c(Oppty_Record_Id__c=item.Oppty_Record_Id__c,
                                                            X1Force_Product__c=item.X1Force_Product__c,
                                                            Quantity__c=item.Quantity,
                                                            Oppty_Product_Record_Id__c=item.Id,
                                                            Unit_Price__c=item.UnitPrice));
            }
        }
        // insert the TSM_Shared_Product sharing records to replicate from SFS to TAA
        if(!newShrProducts.isEmpty())
        	Database.insert(newShrProducts, false);   
    }
    
    // processing logic for after update
    public static void onAfterUpdate(Map<Id, OpportunityLineItem> newRecordsMap, Map<Id, OpportunityLineItem> oldRecordsMap) {
    	// get the connectionname
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
	   	Id networkId = TSM_Util.getNetworkId(tsmCS.connectionName__c);  
        Set<String> oppItemIds = new Set<String>();
        Map<String, OpportunityLineItem> processMap = new Map<String, OpportunityLineItem>();
        List<TSM_Shared_Product__c> updShrProducts= new List<TSM_Shared_Product__c>();
        List<OpportunityLineItem> oppItemsList = new List<OpportunityLineItem>();
        // identify the records that meet the criteria of changes
        for(OpportunityLineItem item: newRecordsMap.values()) {
            if(item.ConnectionReceivedId == null) {
                // identify the changes of quantity and unit price
                if((item.UnitPrice !=  null && item.UnitPrice != oldRecordsMap.get(item.Id).UnitPrice) ||
                  (item.Quantity != null && item.Quantity != oldRecordsMap.get(item.Id).Quantity)) {
                    // for identifying the steelbrick opportunities which must be sent to TAA
                	if(item.X1Force_Product__c != null && item.Oppty_Record_ID__c != null 
                       && item.OpportunityId != null) {
                		oppItemIds.add(item.Id);  
                    	processMap.put(item.Id, item);
                	}
                }                                    
            }
        }  
        // identify the respective TSM_Shared_Product__c records
       	for(TSM_Shared_Product__c tsp: [SELECT Id, Oppty_Product_Record_Id__c, Unit_Price__c, Quantity__c,
                                       X1Force_Product__c FROM TSM_Shared_Product__c 
                                        WHERE Oppty_Product_Record_Id__c IN :oppItemIds]) {
        	tsp.Unit_Price__c = processMap.get(tsp.Oppty_Product_Record_Id__c.substring(0,18)).UnitPrice;
            tsp.Quantity__c = processMap.get(tsp.Oppty_Product_Record_Id__c.substring(0,18)).Quantity;
            updShrProducts.add(tsp);		                                    
        }
        // update the TSM_Shared_Product sharing records to replicate the changes from SFS to TAA
        if(!updShrProducts.isEmpty())
        	Database.update(updShrProducts, false);   
    }
    
     // processing logic for after delete
    public static void onAfterDelete(List<OpportunityLineItem> oldRecords) {
    	System.debug('Inside TSM_OpportunityLineItemTriggerHandler.onAfterDelete: Param='+oldRecords);
    	// get the connectionname
    	TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        Id networkId = TSM_Util.getNetworkId(tsmCS.ConnectionName__c);        
        
        List<PartnerNetworkRecordConnection> existingShrList = new List<PartnerNetworkRecordConnection>();
        Map<Id, PartnerNetworkRecordConnection> oldProdShrMap = new Map<Id, PartnerNetworkRecordConnection>();
    	Set<String> oppItemIds = new Set<String>();
    	Set<Id> shrProdIds = new Set<Id>();

        // identify the records that meet the criteria of changes
        for(OpportunityLineItem item: oldRecords) {
            // for identifying the steelbrick oppty line items which must be deleted in TAA
            if(item.X1Force_Product__c != null && item.Oppty_Record_ID__c != null 
                    && item.OpportunityId != null) {
                    oppItemIds.add(item.Id);
            }                            
        } 
         // identify the respective TSM_Shared_Product__c records
       	for(TSM_Shared_Product__c tsp: [SELECT Id FROM TSM_Shared_Product__c 
                                        WHERE Oppty_Product_Record_Id__c IN :oppItemIds]) {
            shrProdIds.add(tsp.Id);		                                    
        }
        
        oldProdShrMap = TSM_Util.fetchExistingShares(shrProdIds, networkId);
        // delete the Shared Product sharing records so that it will change the status to Inactive
        TSM_Util.deleteShares(oldProdShrMap.values(), 'TSM_OpportunityLineItemTriggerHandler', 'onAfterDelete');
         
    }
}