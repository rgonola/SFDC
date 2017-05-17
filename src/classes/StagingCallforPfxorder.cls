global class StagingCallforPfxorder Implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public String query;
   
   global Database.QueryLocator start(Database.BatchableContext BC)
    {
    try{
       
        if(!Test.isRunningTest()){
            query = 'SELECT id,Is_PFX_Promotion__c from invoiceit_s__Invoice__c where Is_PFX_Promotion__c =TRUE and Log_File__c =null  order by  CreatedDate ASC Limit 50';
  }else{
  
     query = 'SELECT id,Is_PFX_Promotion__c from invoiceit_s__Invoice__c where Is_PFX_Promotion__c =TRUE and Log_File__c =null  order by  CreatedDate ASC Limit 50'; 
  }
        
    }catch(Exception Ex){
        system.debug('Exception'+Ex);
    }
    return Database.getQueryLocator(query);
    
    }
      
       
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Invoice__c> scope) {
        try{
            
           
             
          
          
            for(invoiceit_s__Invoice__c rtPlanCharge : scope) {
               
               handlstg(rtPlanCharge.id);
               
            }
            
           
            
         
       }catch(Exception Ex){
           system.debug('Exception'+Ex);
       }
     
   }   
   
   
  
    public static void handlstg(String invoiceID) {
          
          system.debug('session id is here'+UserInfo.getSessionID());
          
                  partnerSoapforceCom.Soap myPartnerSoap = new partnerSoapforceCom.Soap();  
                  partnerSoapforceCom.LoginResult partnerLoginResult = myPartnerSoap.login(Label.WebUser_Username, Label.WebUser_Pswd); 
                  WebupdateOppyGenerated.SessionHeader_element webserviceSessionHeader = new WebupdateOppyGenerated.SessionHeader_element(); 
                  webserviceSessionHeader.sessionId = partnerLoginResult.sessionId;//UserInfo.getsessionId(); 
                  
           HandleStaging stageHandle = new HandleStaging();
          stageHandle.sendStagingData(invoiceID,webserviceSessionHeader.sessionId);
        
    }
   global void finish(Database.BatchableContext BC){} 
}