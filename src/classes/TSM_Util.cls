/*
 * helper utility class for reusable methods
 */
public class TSM_Util {
    public static Id getUserId(String userEmail) {
        List<User> usersList = new List<User>();
        usersList = [SELECT Id FROM User WHERE email = :userEmail AND UserType='Standard' AND IsActive=true LIMIT 1];
        Id userId = (!usersList.isEmpty()) ? usersList[0].Id : null;
        return userId;
    }
    
    @future 
    public static void touchOpportunities(Set<Id> opptyIds) { 
        List<Opportunity> opptyList = [SELECT Id FROM Opportunity Where Id in :opptyIds]; 
        database.update(opptyList,false);
    }
    
    // return the network id of the accepted/active connection for PNC object
    public static Id getNetworkId(String connectionName) {
        List<PartnerNetworkConnection> connList = new List<PartnerNetworkConnection>();
        connList = [SELECT Id FROM PartnerNetworkConnection
                    WHERE connectionStatus = 'Accepted' 
                    AND connectionName = :connectionName LIMIT 1];
        return (!connList.isEmpty() ? connList[0].Id : null);        
    }   
    // for iteration 2
    // find the existing PNRC records of previously shared records
    public static Map<Id, PartnerNetworkRecordConnection> fetchExistingShares(Set<Id> recordIdSet, Id networkId) {
        Map<Id, PartnerNetworkRecordConnection> recordShrMap = new Map<Id, PartnerNetworkRecordConnection>();
        // find the respective PNRC records of existing shared accounts
        if(recordIdSet.size() > 0) {
            for(PartnerNetworkRecordConnection recordShrRec : 
                        [SELECT Id, LocalRecordId, PartnerRecordId                                                             
                           FROM PartnerNetworkRecordConnection                                                              
                          WHERE LocalRecordId IN :recordIdSet                                                              
                            AND PartnerRecordId != null AND ConnectionId = :networkId]) {
                recordShrMap.put(recordShrRec.LocalRecordId, recordShrRec);        
            }            
        }
        return recordShrMap;
    }
    // this is to create the new sharing records (bulk) - generic
    public static void insertShares(List<PartnerNetworkRecordConnection> pnrcList, String clsName, String procType) {
        if(!pnrcList.isEmpty()) {
            Database.SaveResult[] results = Database.insert(pnrcList, false);
            List<TSM_App_Log__c> logList = new List<TSM_App_Log__c>();                    
            for(Database.SaveResult sr: results) {
                if(!sr.isSuccess()) {
                    for(Database.Error err: sr.getErrors()) {
                        logList.add(prepareLogEntry(err.getMessage(), String.valueOf(err.getStatusCode()), err.getMessage(), 
                                                    clsName, procType));
                        //System.debug(err.getStatusCode(), err.getMessage(), err.getFields())
                        //to capture them in custom object TSM_App_Log__c for reference
                    }
                }
            }
            if(!logList.isEmpty())
                Database.insert(logList, false);
        }
    }
    // this is to invoke the stop sharing records (bulk) - generic
    public static void deleteShares(List<PartnerNetworkRecordConnection> pnrcList, String clsName, String procType) {
        if(!pnrcList.isEmpty()) {
            Database.DeleteResult[] results = Database.delete(pnrcList, false);
            List<TSM_App_Log__c> logList = new List<TSM_App_Log__c>();                    
            for(Database.DeleteResult sr: results) {
                if(!sr.isSuccess()) {
                    for(Database.Error err: sr.getErrors()) {
                        logList.add(prepareLogEntry(err.getMessage(), String.valueOf(err.getStatusCode()), err.getMessage(), 
                                                    clsName, procType));
                        //System.debug(err.getStatusCode(), err.getMessage(), err.getFields())
                        //to capture them in custom object TSM_App_Log__c for reference
                    }
                }
            }
            if(!logList.isEmpty())
                Database.insert(logList, false);
        }
    }    
    // this is to prepare the sharing record - generic
    public static PartnerNetworkRecordConnection prepareShare(Id recordId, Id connectionId, Id parentRecordId) {
        PartnerNetworkRecordConnection newShare = new PartnerNetworkRecordConnection();
        newShare.ConnectionId = connectionId;
        newShare.LocalRecordId = recordId;
        newShare.SendEmails = false;
        newShare.SendClosedTasks = false;
        newShare.SendOpenTasks = false;
        newShare.ParentRecordId = parentRecordId;
        return newShare;
    }    
    // prepare the app log record
    public static TSM_App_Log__c prepareLogEntry(String errMsg, String recId, String errDesc, String clsName, String procType) {
        TSM_App_Log__c logEntry = new TSM_App_Log__c();
        logEntry.Error_Message__c = errMsg;
        logEntry.Error_Description__c = errDesc;
        logEntry.Process_Type__c = procType;
        logEntry.Name = errMsg;
        logEntry.Record_Id__c = recId;
        logEntry.Stack_Trace__c = clsName;
        return logEntry;
    }
    // utility method for fetching the trigger off flag for each object
    public static Boolean fetchTriggerOffFlag(String objName) {
        Map<String, TSM_Trigger_Control__c> controlMap = TSM_Trigger_Control__c.getAll();
        Boolean isTriggerOff = false;
        if(!controlMap.isEmpty() && controlMap.containsKey(objName)) {
            isTriggerOff = controlMap.get(objName).TriggerOff__c;
        }
        return isTriggerOff;
    }
}