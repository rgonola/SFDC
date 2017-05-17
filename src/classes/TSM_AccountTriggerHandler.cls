/*
 * apex class to perform the S2S records replication for TAA <-> SFS orgs  
 * this is to make the ownership changes for shared/replicated records in SFS org.
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/05/2016 RP				1.0			Initial draft
 * ------------------------------------------------------------------------- */
public class TSM_AccountTriggerHandler {
	// method to process the new records
    public static void onBeforeInsert(List<Account> newRecords) {
       TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
	   Id sfsHouseAdminUserId = TSM_Util.getUserId(tsmCS.HouseAdminUserName__c);
       for(Account acct : newRecords) {
       	// this is only for new records which are being shared by SFS
       		Boolean isS2SShared = (!Test.isRunningTest()) ? (acct.ConnectionReceivedId != null) : true;
			if(isS2SShared && acct.TAA_Account_Record_ID__c != null && sfsHouseAdminUserId != null) {
       				acct.OwnerId = sfsHouseAdminUserId;
       		}                
       }
    }
}