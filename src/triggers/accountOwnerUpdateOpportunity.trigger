trigger accountOwnerUpdateOpportunity on Account (after update) {

    Map<id,Account> accMap = new  Map<id,Account>();
    Set<Id> oppids= new  Set<Id>();
    
    for(Account acc : Trigger.New){
    
    if (Trigger.isupdate){
     Account oldAcct = Trigger.oldMap.get(acc.ID); if(acc.OwnerId != oldAcct.OwnerId ) accMap.put(acc.Id,acc); }
     else{ if(acc.Owner!= null) accMap.put(acc.Id,acc); }
        
        
    }
    List<Opportunity> oppLisToUpdate = new List<Opportunity>(); 
    List<SBQQ__Quote__c> quttoupdate= new List<SBQQ__Quote__c>(); 
    
    if(accMap.size() >0)
    {
        List<Opportunity> opplist= [select id,Name,AccountId from Opportunity where AccountId IN : accMap.keyset() AND (StageName <> 'Closed Won' AND StageName <> 'Commitment' AND StageName <> 'Active'  AND StageName <> 'Onboard' AND StageName <> 'Closed Lost') AND SBQQ__PrimaryQuote__c <> null ];
        if(opplist.size() > 0)
        {
            
        for(Opportunity opprec : opplist){  
             if(opprec.AccountId !=null || opprec.AccountId !='' ){ Account acc = accMap.get(opprec.AccountId); opprec.OwnerId = acc.ownerId ; 
                oppLisToUpdate.add(opprec);  oppids.add(opprec.id); 
                
                }
                }
           
        }
        if(oppLisToUpdate.size() >0){ update oppLisToUpdate;}
        
        
         List<SBQQ__Quote__c> quotelist= [select id,Name,SBQQ__Account__c,OwnerId,SBQQ__SalesRep__c  from SBQQ__Quote__c where SBQQ__Opportunity2__c IN : oppids  ];
        if(quotelist.size() > 0)
        {
            
        for(SBQQ__Quote__c qutrec : quotelist){  
             
          if(qutrec.SBQQ__Account__c!=null){      Account acc = accMap.get(qutrec.SBQQ__Account__c); qutrec.OwnerId = acc.ownerId ;
                qutrec.SBQQ__SalesRep__c = acc.ownerId ; quttoupdate.add(qutrec);   }
               
               
                }
           
        }
        if(quttoupdate.size() >0){ update quttoupdate;}
        
        
        
        
    }

}