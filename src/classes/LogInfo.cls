/* The class is created for creating the Log Id for Staging*/

@RestResource(urlMapping='/LogInfo/*')
global with sharing class LogInfo{
    
    @HttpGet
    global static LogJson doGet(){
        LogJson logJson=new LogJson(); 
        LogJson.LogInfo logInfo=new LogJson.LogInfo();
        LogFiles__c log=new LogFiles__c ();
        insert log;
        
        logInfo.id=log.Id;
        Datetime createdDate=[Select CreatedDate from LogFiles__c  where Id=:logInfo.id].CreatedDate;
        String createdDateFormat =createdDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        String eventSource=[Select Event_Source__c from LogFiles__c  where Id=:logInfo.id].Event_Source__c;
        
        logInfo.eventSource=eventSource;
        logInfo.CreateDate=String.ValueOf(createdDateFormat);
        logJson.LogInfo=logInfo;
        return logJson;
        
    }

}