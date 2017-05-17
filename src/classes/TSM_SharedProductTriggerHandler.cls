/*
 * Helper class for TSM_SharedProductTrigger on custom object TSM_Shared_Product__c
 * This will create the opportunity product records in TAA org based on TSM_Shared_Product__c records
 * */
public class TSM_SharedProductTriggerHandler {
    // method for processing new records
    public static void onAfterInsert(List<TSM_Shared_Product__c> newRecords) {
        // get the connectionname
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        Id networkId = TSM_Util.getNetworkId(tsmCS.connectionName__c);  
        List<PartnerNetworkRecordConnection> newShrList = new List<PartnerNetworkRecordConnection>();
        for(TSM_Shared_Product__c tsp: newRecords) {
            if(tsp.ConnectionReceivedId == null) {
                if(tsp.X1Force_Product__c != null && tsp.Oppty_Record_ID__c != null && 
                tsp.Oppty_Product_Record_Id__c != null) {
                    newShrList.add(TSM_Util.prepareShare(tsp.Id, networkId, null));
                }
            }
        }
        // insert the new TSM_Shared_Product__c sharing records to replicate from SFS to TAA
        TSM_Util.insertShares(newShrList, 'TSM_SharedProductTrigger','Trigger');
    }
}