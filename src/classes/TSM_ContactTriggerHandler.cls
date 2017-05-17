/*
 * apex class to perform the S2S records replication for TAA <-> SFS orgs  
 * this is to make the ownership changes for shared/replicated records in SFS org.
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/05/2016 RP				1.0			Initial draft
 * ------------------------------------------------------------------------- */
public class TSM_ContactTriggerHandler {
	// method to process the new records
    public static void onBeforeInsert(List<Contact> newRecords) {
    	TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
		Id sfsHouseAdminUserId = TSM_Util.getUserId(tsmCS.HouseAdminUserName__c);
        Set<String> acctTextIds = new Set<String>();
        Map<String, Id> acctMap = new Map<String, Id>();
        // to identify the respective accounttextids
        for(Contact con : newRecords) {
            //Boolean isS2SShared = (!Test.isRunningTest()) ? (con.ConnectionReceivedId != null) : true;
            //if(isS2SShared && con.TAA_Account_Record_Id__c != null && con.AccountId == null) {            
            if(con.TAA_Account_Record_Id__c != null && con.AccountId == null) {
                acctTextIds.add(con.TAA_Account_Record_ID__c.substring(0,con.TAA_Account_Record_ID__c.length()));
            }                
        }
        // to identify the respective accounts in SFS org
        if(!acctTextIds.isEmpty()) {
            for(Account acct: [SELECT Id, TAA_Account_Record_Id__c FROM Account 
                               WHERE TAA_Account_Record_Id__c IN :acctTextIds]) {
                acctMap.put(acct.TAA_Account_Record_Id__c.substring(0,acct.TAA_Account_Record_Id__c.length()), acct.Id);      
            }
        }
        // to assign the respective relationship fields like ownerId, accountId
        for(Contact con : newRecords) {
    		Boolean isS2SShared = (!Test.isRunningTest()) ? (con.ConnectionReceivedId != null) : true;            
            if(isS2SShared) {
                // this is only for new records which are being shared by SFS - set the ownerId       		
            	if(con.TAA_Contact_Record_ID__c != null && sfsHouseAdminUserId != null) {
       				con.OwnerId = sfsHouseAdminUserId;
       			}
            }    
            // this is only for new records which are being shared by SFS - set the accountId
            if(con.AccountId == null && con.TAA_Account_Record_Id__c != null && acctMap.containsKey(con.TAA_Account_Record_Id__c.substring(0,con.TAA_Account_Record_Id__c.length()))) {
                con.AccountId = acctMap.get(con.TAA_Account_Record_Id__c.substring(0,con.TAA_Account_Record_Id__c.length()));
            }            
        }
    }
}