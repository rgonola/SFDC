/*
 * trigger handler class to perform the S2S records replication for TAA <-> SFS org  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/01/2016 AA				1.0			Initial draft
 * ------------------------------------------------------------------------- */
public class TSM_OpportunityTriggerHandler {
    
    // processing logic for insert operation
    public static void onBeforeInsert(List<Opportunity> newRecords) {
        List<Opportunity> oppList = new List<Opportunity>();
        List<String> X1ForceAccounts = new List<String>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        Map<String, Account> X1ForceAccountMap = new Map<String, Account>();
        Map<Id, Id> contactMap = new Map<Id, Id>();
        Map<String, Id> acctMap = new Map<String, Id>();
        Map<String, Contact> TAAContactMap = new Map<String, Contact>();
        Set<String> contactTextIds = new Set<String>();
        Set<String> acctTextIds = new Set<String>();
        Set<String> ownerEmails = new Set<String>();
        Map<String, Id> userEmailMap = new Map<String, Id>();
        // List of SFDC Account #
        for(Opportunity opp: newRecords) {
            if(opp.X1Force_Account__c != null) {
              X1ForceAccounts.add(opp.X1Force_Account__c);
            }
            if(opp.TAA_Primary_Contact_for_Proposal__c != null) {
                contactTextIds.add(opp.TAA_Primary_Contact_for_Proposal__c.substring(0,opp.TAA_Primary_Contact_for_Proposal__c.length()));
            }
            // this is to prepare the set of email address of the owners
            if(opp.TAA_Opportunity_Record_ID__c != null && opp.TAA_Opportunity_Owner_ID__c != null) {
            	ownerEmails.add(opp.TAA_Opportunity_Owner_Id__c);
            }
            // this is to capture the TAAaccttext ids
            if(opp.TAA_Account_Record_ID__c != null && opp.AccountId == null) {
                acctTextIds.add(opp.TAA_Account_Record_ID__c.substring(0,opp.TAA_Account_Record_ID__c.length()));
            }
        }
        /*
        // map the respective contactids thru PNRC list
        for(PartnerNetworkRecordConnection pnc: [SELECT Id, LocalRecordId, PartnerRecordId FROM
                                            PartnerNetworkRecordConnection 
                                             WHERE PartnerRecordId IN :contactTextIds]) {
                                                 contactMap.put(pnc.PartnerRecordId, pnc.LocalRecordId);
                                             }
        System.debug('display:contactMap:'+contactMap);
        */
		// to identify the respective accounts in SFS org
        for(Account acct: [SELECT Id, TAA_Account_Record_Id__c FROM Account 
                           WHERE TAA_Account_Record_Id__c IN :acctTextIds]) {
			acctMap.put(acct.TAA_Account_Record_Id__c.substring(0,acct.TAA_Account_Record_Id__c.length()), acct.Id);      
        }
        
        //Map<ID, Contact> TAAContactMap = new Map<ID, Contact>( [Select Id, TAA_Contact_Record_ID__c from Contact where TAA_Contact_Record_ID__c in : contactTextIds]);
        
        // Map of TAA & SFS Contact Ids
    	for(Contact contact : [Select Id, TAA_Contact_Record_ID__c from Contact where 
                               TAA_Contact_Record_ID__c in : contactTextIds]) {
        	TAAContactMap.put(contact.TAA_Contact_Record_ID__c.substring(0,contact.TAA_Contact_Record_ID__c.length()), contact);
    	}
        System.debug('display:TAAContactMap:'+TAAContactMap);
        
        // Map of non-S2S shared Accounts
    	for(Account acct : [Select Id, X1Force_Account__c  From Account where X1Force_Account__c in : X1ForceAccounts and ConnectionReceivedId = null]) {
        	X1ForceAccountMap.put(acct.X1Force_Account__c, acct);
    	}
        System.debug('display:X1ForceAccountMap:'+X1ForceAccountMap);
        // map the owner ids to respective owners in SFS 
        for(User usr : [SELECT Id, Email, FederationIdentifier FROM User WHERE Email IN :ownerEmails AND
        				IsActive = true AND UserType ='Standard']) {
        					userEmailMap.put(usr.Email, usr.Id);
        }
        for(Opportunity opp: newRecords) {
           // Relate Opportunity to a non-S2S shared parent Account
           if(opp.X1Force_Account__c != null && opp.AccountId == null && X1ForceAccountMap.keySet().contains(opp.X1Force_Account__c)) { 
              opp.AccountId = X1ForceAccountMap.get(opp.X1Force_Account__c).Id;
           }
           
           // Relate the respective contact to primary contact
           if(opp.TAA_Primary_Contact_for_Proposal__c != null && TAAContactMap.containsKey(opp.TAA_Primary_Contact_for_Proposal__c.substring(0,opp.TAA_Primary_Contact_for_Proposal__c.length()))) {
               System.debug('display:opp.contact__c'+opp.contact__c);
               opp.Contact__c = TAAContactMap.get(opp.TAA_Primary_Contact_for_Proposal__c.substring(0,opp.TAA_Primary_Contact_for_Proposal__c.length())).Id;
           } 
            /*
            else if (opp.TAA_Primary_Contact_for_Proposal__c != null && contactMap.containsKey(opp.TAA_Primary_Contact_for_Proposal__c)) {
               opp.Contact__c = contactMap.get(opp.TAA_Primary_Contact_for_Proposal__c);
           } */
           // set the owner ids to respective TAA opportunity owners
           if(opp.TAA_Opportunity_Record_ID__c != null && opp.TAA_Opportunity_Owner_ID__c != null && userEmailMap.containsKey(opp.TAA_Opportunity_Owner_ID__c)) {
           		opp.OwnerId = userEmailMap.get(opp.TAA_Opportunity_Owner_ID__c);
           }
           // relate the account id with respective TAA account (SFS)
           if(opp.TAA_Account_Record_ID__c != null && opp.AccountId == null
              && acctMap.containsKey(opp.TAA_Account_Record_ID__c.substring(0,opp.TAA_Account_Record_ID__c.length()))) {
           		opp.AccountId = acctMap.get(opp.TAA_Account_Record_ID__c.substring(0,opp.TAA_Account_Record_ID__c.length()));       
           }
        }
    } 
    
    // processing logic for after insert operation
    public static void onAfterInsert(List<Opportunity> newRecords) {
    	  try { 
        		TSM_Util util = new TSM_Util(); 
        		TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
	   			Id connectionId = TSM_Util.getNetworkId(tsmCS.connectionName__c);      
    
        		// for opportunities coming from TAA org - need to push the opportunity Id 
        		// do a fake touch 
        		Set<Id> newOpptyIds = new Set<Id>(); 
        
        		for (Opportunity newOppty : newRecords) { 
            		Boolean isShared = (!Test.isRunningTest()) ? (newOppty.ConnectionReceivedId != null && newOppty.ConnectionReceivedId == connectionId) : true;
                    //if (newOppty.ConnectionReceivedId != null && newOppty.ConnectionReceivedId == connectionId) { 
                    if(isShared) {
                    	newOpptyIds.add(newOppty.Id); 
            		} 
        		} 
        		if (newOpptyIds.size() > 0) { 
            		TSM_Util.touchOpportunities(newOpptyIds); 
            		//updateOpportunities(newOpptyIds);
        		} 
    		} catch (System.Exception ex) { 
        		// do nothing for now 
        		System.debug(LoggingLevel.Error, 'opportunity share trigger failed -' + ex.getMessage()); 
   		 } 
    } 
    /* commented the logic
    // processing logic for before update 
    @future
    public static void updateOpportunities(Set<Id> oppIds) {
        Map<Id, Id> acctMap = new Map<Id, Id>();
        Map<Id, Id> contMap = new Map<Id, Id>();
        Map<Id, Id> contAcctMap = new Map<Id, Id>();        
        Set<String> acctIds = new Set<String>();
        Set<String> contIds = new Set<String>();
        Map<String, Account> X1ForceAccountMap = new Map<String, Account>();
        Set<String> X1ForceAccounts = new Set<String>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        List<Opportunity> newRecords = [SELECT Id, TAA_Account_Record_Id__c, TAA_Primary_Contact_for_Proposal__c,
                                       X1Force_Account__c, AccountId, Contact__c FROM Opportunity WHERE Id IN :oppIds AND 
                                       TAA_Opportunity_Record_ID__c != null];
        for(Opportunity opp: newRecords) {
            if(opp.AccountId == null && opp.TAA_Account_Record_Id__c != null) {
            	acctIds.add(opp.TAA_Account_Record_Id__c.substring(0,18));
            }    
            if(opp.Contact__c == null && opp.TAA_Primary_Contact_for_Proposal__c != null) {
            	contIds.add(opp.TAA_Primary_Contact_for_Proposal__c.substring(0,18));
            }
            if(opp.AccountId == null && opp.X1Force_Account__c != null) {
            	X1ForceAccounts.add(opp.X1Force_Account__c);
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
            acctMap.put(acct.TAA_Account_Record_Id__c.substring(0,18), acct.Id);
        }
        // fetch the contacts of respective opportunities using taa contact record ids
        for(Contact cont: [SELECT Id, AccountId, TAA_Account_Record_Id__c, TAA_Contact_Record_Id__c 
                           FROM Contact WHERE TAA_Contact_Record_Id__c IN :contIds]) {
            contMap.put(cont.TAA_Contact_Record_Id__c.substring(0,18), cont.Id);
        	if(cont.TAA_Account_Record_Id__c != null && cont.AccountId != null) {
            	contAcctMap.put(cont.TAA_Account_Record_Id__c.substring(0,18),cont.AccountId);                       
            }	
        }
        // relate the opportunities to accounts 
        for(Opportunity opp: newRecords) {
            // set the accountid to opportunity
            if(opp.AccountId == null && opp.TAA_Account_Record_Id__c != null) {
            	if(acctMap.containsKey(opp.TAA_Account_Record_Id__c.substring(0,18))) {
                	opp.AccountId = acctMap.get(opp.TAA_Account_Record_Id__c.substring(0,18));                
                } else {
                    if(contAcctMap.containsKey(opp.TAA_Account_Record_Id__c.substring(0,18)))
                    	opp.AccountId = contAcctMap.get(opp.TAA_Account_Record_Id__c.substring(0,18));
                }  
            } 
            // set the contact to opportunity
            if(opp.Contact__c == null && opp.TAA_Primary_Contact_for_Proposal__c != null && 
               contMap.containsKey(opp.TAA_Primary_Contact_for_Proposal__c.substring(0,18))) {
                opp.Contact__c = contMap.get(opp.TAA_Primary_Contact_for_Proposal__c.substring(0,18));                
            }
            // Relate Opportunity to a non-S2S shared parent Account
           if(opp.X1Force_Account__c != null && opp.AccountId == null && X1ForceAccountMap.keySet().contains(opp.X1Force_Account__c)) { 
              opp.AccountId = X1ForceAccountMap.get(opp.X1Force_Account__c).Id;
           }
           oppsToUpdate.add(opp);
        }
        if(!oppsToUpdate.isEmpty()) 
            Database.update(oppsToUpdate, false);
    }
	*/
}