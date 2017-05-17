trigger bfAfInsertSFDCBMSyncInsertOpportunityBMQuote on SFDC_BM_Sync__c (before insert, after Insert) {   
    
    Set<String> setPIDs = new Set<String>();    
    Set<string> setSalesRepCodes = new Set<String>();
    
    Map<String, Id> mapAccountId = new Map<String, Id>();     
    Map<String, Id> mapOpportunityId = new Map<String, Id>();
    Map<String, Id> mapUserId = new Map<String, Id>();    
    
    List<Opportunity> listOpportunity = new List<Opportunity>();
    List<BigMachines__Quote__c> listBMQuote = new List<BigMachines__Quote__c>();
        
    //before insert    
    if(Trigger.isBefore && Trigger.isInsert) {
        Id acctAMFSNSRecordTypeId =[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Account'].Id;            
        Id oppAMFSNSRecordTypeId =[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Opportunity'].Id; 
        
        for(SFDC_BM_Sync__c sfdcbm : Trigger.new) {
            if(sfdcbm.PID__c != null && sfdcbm.PID__c != '')  {
                setPIDs.add(sfdcbm.PID__c);
            }            
            if(sfdcbm.SALES_REP_CODE__c != null && sfdcbm.SALES_REP_CODE__c != '') {
                setSalesRepCodes.add(sfdcbm.SALES_REP_CODE__c);
            }
        }
        
        // Fetching Accounts for setPID        
        if(setPIDs.size() > 0) {
            for(Account account :[SELECT Id, PID__c FROM Account WHERE RecordTypeId = :acctAMFSNSRecordTypeId 
                                  AND (OFFC__c != null AND OFFC__c = 0) AND PID__c IN :setPIDs AND 
                                  (PID__c != '' AND PID__c != null)])   {
                mapAccountId.put(account.PID__c, account.Id);
            }
        }       
        
        // Fetching Users for setSalesRepCodes        
        if(setSalesRepCodes.size() > 0) {
            for(User usr :[SELECT Id, SALES_REP_CODE__c FROM User WHERE 
                           SALES_REP_CODE__c IN :setSalesRepCodes AND IsActive = true])   {
                mapUserId.put(usr.SALES_REP_CODE__c, usr.Id);
            } 
        }       
        
        // list of new opportunities   
        for(SFDC_BM_Sync__c sfdcbm : Trigger.new)  {
            if((sfdcbm.Opportunity_Name__c != null && sfdcbm.Opportunity_Name__c != '') && 
               (sfdcbm.Closed_Date__c != null) && (sfdcbm.PID__c != null && sfdcbm.PID__c != '') &&
               (sfdcbm.Stage__c != null && sfdcbm.Stage__c != '')) {
                Opportunity opportunity = new Opportunity();
                opportunity.Name = sfdcbm.Opportunity_Name__c;
                opportunity.StageName = sfdcbm.Stage__c;            
                opportunity.CloseDate = sfdcbm.Closed_Date__c;
                opportunity.Type = sfdcbm.Type__c;
                //Commented as PID is formula field.
                //opportunity.PID__c = sfdcbm.PID__c;
                opportunity.RecordTypeId = oppAMFSNSRecordTypeId;
                opportunity.SFDC_BM_Sync_Id__c = sfdcbm.Id;
                //opportunity.AccountId = sfdcbm.Account_Name__c;
                if(mapAccountId.containskey(sfdcbm.PID__c))                
                    opportunity.AccountId = mapAccountId.get(sfdcbm.PID__c); 
                           
                listOpportunity.add(opportunity);
                sfdcbm.Account_Name__c = mapAccountId.get(sfdcbm.PID__c);
            }
            else {
                sfdcbm.addError('Required fields are missing for Opportunity'); 
            }
        }       
                
        // insertion of opportunity
        if(listOpportunity!= null && listOpportunity.size() > 0)  {            
            insert listOpportunity;
            for(Opportunity opp : listOpportunity) {
                mapOpportunityId.put(opp.Name,opp.Id);
            }            
        }
        
        // list of BigMachine Quotes
        for(SFDC_BM_Sync__c sfdcbm : Trigger.new)  { 
            if(mapOpportunityId.containskey(sfdcbm.Opportunity_Name__c)) {        
                BigMachines__Quote__c bmQuote = new BigMachines__Quote__c();
                bmQuote.Name = sfdcbm.Quote_Number__c;
                //bmQuote.BigMachines__Account__c = sfdcbm.Account_Name__c;
                bmQuote.BigMachines__Transaction_Id__c = sfdcbm.Quote_Number__c;
                if(mapAccountId.containskey(sfdcbm.PID__c))           
                    bmQuote.BigMachines__Account__c = mapAccountId.get(sfdcbm.PID__c); 
                if(mapOpportunityId.containskey(sfdcbm.Opportunity_Name__c))
                    bmQuote.BigMachines__Opportunity__c = mapOpportunityId.get(sfdcbm.Opportunity_Name__c);
                if(mapUserId.containskey(sfdcbm.SALES_REP_CODE__c))           
                    bmQuote.OwnerId = mapUserId.get(sfdcbm.SALES_REP_CODE__c); 
                
                listBMQuote.add(bmQuote);
            }           
        }    
            
        // insertion of BigMachine Quotes
        if(listBMQuote!= null && listBMQuote.size() > 0) { 
            upsert listBMQuote BigMachines__Transaction_Id__c;            
        }          
    }
}