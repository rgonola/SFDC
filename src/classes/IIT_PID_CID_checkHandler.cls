global class IIT_PID_CID_checkHandler{

    public Account a {get;set;}
    public String currentRecordId {get;set;}
    public String currentRecordPID {get;set;}
    public String previousRecordId  {get;set;}
    public String AccountId{get;set;}
    
    
   
    public IIT_PID_CID_checkHandler(ApexPages.StandardController controller) {
        a = (Account)controller.getRecord();
        system.debug('AccountId**'+a);
        previousRecordId= ApexPages.currentPage().getParameters().get('accId');
        system.debug('Previuos Id**'+previousRecordId);
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('Current Id**'+currentRecordId);
        currentRecordPID=ApexPages.CurrentPage().getParameters().get('PID_GROUP__c');
        
    }
    
   
    webservice static void
    SavenoPID_CID_OFFC_AccID(String PID, String CID, String OFFC, Id acct){
      try{         
           Integer intCID=null;
           Integer intPID=null;
           Integer intOFC=null;
           
           if(String.isNotBlank(CID)){
               intCID=integer.valueof(CID);
           }
            
           if(String.isNotBlank(PID)){
               intPID=integer.valueof(PID);
           }
          
           if(String.isNotBlank(OFFC)){
              intOFC=integer.valueof(OFFC);
           }
         
           String acc= String.valueOf(acct);
           
           system.debug('intCID'+intCID +''+'intPID'+intPID);
         
           if(intCID!=null && intPID==null){
             IIT_PID_CID_checkHandler.noPID_CID_OFFC_AccID(intPID,intCID,intOFC,acc);
           } 
             
         
      }catch(Exception Ex){
          system.debug('Exception'+Ex);
      }   
     }
     
    
   public static IIT_PID_CID_check.output noPID_CID_OFFC_AccID(integer PID, integer CID, integer OFFC, String acct) {
   
      list <account> acc = [SELECT id, name, CID__c,PID_GROUP__c,PID__c,OFFC__c FROM account WHERE id = :acct For Update];
      IIT_PID_CID_check.output returnedOP=new IIT_PID_CID_check.output();
      try{
        if (acc.size()>0 && PID==null && CID<>null)  {
            string error='';
            String [] errorMsg;
            
            //check if SFDC account already has values
            if ( acc[0].pid__c <> null && acc[0].pid__c <> '') error='PID already populated in SFDC'; 
            if ( acc[0].OFFC__c ==0) error='Please Move to Office 0';
            
     
            
            //check for and get output from the correct scenario
            if (pid==null && cid!=null && acc[0].OFFC__c > 0 )  {  
                    returnedOP = IIT_PID_CID_check.Scenario4(acc, acct, string.valueof(cid)) ; 
            }
            else {
                returnedOP.oPID=null;
                returnedOP.oCID=null;
                returnedOP.oOFFC=null;
                returnedOP.oGroupId =null;
                returnedOP.oStatus ='Failed';
                returnedOP.oErrorMsg='Ensure CID is provided, provide null for PID. ' + error ;
            } 
        }
        else {
            returnedOP.oPID=string.valueof(pid);
            returnedOP.oCID=string.valueof(cid );
            returnedOP.oOFFC=offc;
            returnedOP.oGroupId =null;
            returnedOP.oStatus ='Failed';
            returnedOP.oErrorMsg='No Account Found or Ensure CID is provided, provide null for PID ';
        } system.debug ('xxxxxxxxxx SCENARIO FOUR'   + returnedOP);
       
      } catch(Exception Ex){
          system.debug('Exception'+Ex);
      }
       
        return returnedOP;      
     }
     
     public PageReference save() {
     PageReference page;
     try{
     
         String pidNo= [Select PID_Number__c from PID_GROUP__c where Id=:a.PID_GROUP__c].PID_Number__c;
         Integer pidNumb;
         
         String cid=[Select CID__c from Account where Id=:previousRecordId].CID__c;
         system.debug('CID__c ****'+cid);

         Integer cidNumb;
      
         Decimal offc= [Select OFFC__c from Account where Id=:previousRecordId].OFFC__c;
         system.debug('OFFC__c ****'+offc);

         Integer offcNumb;
     
         String accId = String.valueOf(previousRecordId);
      
         if(String.isNotBlank(cid))  
         {  
            cidNumb=integer.valueof(cid);
         }
           
         if(String.isNotBlank(pidNo)){
           pidNumb=integer.valueof(pidNo);
         }
           
           
         if(offc!=null){
            offcNumb=integer.valueof(offc); 
         }   
      
       IIT_PID_CID_check.PID_CID_OFFC_AccID(pidNumb,cidNumb,offcNumb,accId);
       page = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/'+accId);
       page.setRedirect(true); 
       
         
       } catch(Exception Ex){
          system.debug('Exception'+Ex);
       }
       return page;
    }
    
   public PageReference cloneRecord() {
     system.debug('clone record a.Id**'+a.Id);
      PageReference page;
     List<Account> accountUpdate=new List<Account>(); 
     try{
         String cid=[Select CID__c from Account where Id=:previousRecordId].CID__c;
         Integer cidNumb=null;
          
         Decimal offcNumber= [Select OFFC__c from Account where Id=:previousRecordId].OFFC__c;
         Integer offcNumb=null;
          
         String PIDNumber= [Select PID__C from Account where Id=:previousRecordId].PID__C;
          
         String accId = String.valueOf(previousRecordId);
          
           
         if(String.isNotBlank(cid))  
          {  
            cidNumb=integer.valueof(cid);
          }
              
               
         if(offcNumber!=null){
            offcNumb=integer.valueof(offcNumber);
         }
         
         String pidNo= [Select PID_Number__c from PID_GROUP__c where Id=:a.PID_GROUP__c].PID_Number__c;
         Integer pidNumb=null;
      
          if(String.isNotBlank(pidNo)){
             pidNumb=integer.valueof(pidNo);
          }
         
         if(cidNumb!=null && PIDNumber!=null && offcNumb==0 ){
           
          
          Account accnt=new Account(id=previousRecordId, Active__c='No',CID__c='',Originl_CID_Number__c=String.valueOf(cid));
          accountUpdate.add(accnt);
          update accountUpdate;
          
           Account acc = [SELECT ID, Name,Email__c FROM Account WHERE Id =:previousRecordId];
           Account accCopy = acc.clone(false,false);
            
           AggregateResult[]  aggResults =[SELECT MAX(OFFC__c)offcMax  FROM Account WHERE PID__c= :pidNo]; 
                for (AggregateResult ar : aggResults)  {
                   system.debug (  'vvvvvvvvvvvvvvvvvv   ' +  ar.get('offcMax')) ;
                }
            integer offc=0;
            if (aggResults[0].get('offcMax') ==null  )  offc=0 ;
            else offc=  integer.valueof(aggResults[0].get('offcMax')) +1 ; 
            accCopy.OFFC__c=offc;
            accCopy.PID__c=pidNo;
            accCopy.CID__c=String.valueOf(cid);
            accCopy.PID_GROUP__c=a.PID_GROUP__c;
            accCopy.Email__c='';
            
            insert accCopy;
            page = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/'+accCopy.Id);
            page.setRedirect(true); 
            
          }
      }catch(Exception Ex){
          system.debug('Exception'+Ex);
      }
      
      return page;
    }
    
}