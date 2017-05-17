/*Trigger is used for creation of Renewal Quote 
  from the previous year Quote */
  
  trigger triggertoRenewalQuoteCreation on Account(after update) {
    
    
    for(Account q:trigger.new){
                Account oldAccount= Trigger.oldMap.get(q.ID);
     if(Triggerflag.firstRun){ 
          if( ( (q.Generate_Renewal_Quote__c==TRUE && oldAccount.Generate_Renewal_Quote__c==FALSE))){ RenewalQuoteCreation.createquote(q.id); }     
          
           Triggerflag.firstRun=false;       
    
      }
      
      }
    
    
      
    }