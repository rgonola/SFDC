trigger updateBadPhoneNumber on Task (after insert,after update) {
    
    Set<Id> conleadIds = new Set<Id>();
    Set<Id> accIds = new Set<Id>();
    
    
    for(Task t : Trigger.New){
        if(t.Call_Result__c == 'Bad Phone Number')
        {
            conleadIds.add(t.WhoId);
            System.debug('****i am in************'+t.WhoId);
        }
    }
    
    
    for(Task t : Trigger.New){
        if(t.Call_Result__c == 'Bad Phone Number')
        {
            accIds.add(t.WhatId);
            System.debug('****i am in************'+t.WhoId);
        }
    }
    
    
    
    
    if(conleadIds.size() >0)
    {
        List<Lead> leadToUpdate = new  List<Lead>();
        
        System.debug('*****************'+conleadIds.size() );
        List<Lead> leadlst = [select id,Name,Bad_Phone_Number__c from
         Lead where Id IN:conleadIds ];
        if(leadlst.size() >0)
        {
            for(Lead l : leadlst ){
               l.Bad_Phone_Number__c  = True;
               leadToUpdate.add(l);     
            }
        }
        System.debug('*****to update************'+leadToUpdate.size());
        if(leadToUpdate.size() > 0){
            update leadToUpdate;
        }
         
    }
    
    
    if(conleadIds.size() >0)
    {
        List<Contact> conToUpdate = new  List<Contact>();
        
        System.debug('*****************'+conleadIds.size() );
        List<Contact> conlst = [select id,Name,Bad_Phone_Number__c from
         Contact where Id IN:conleadIds ];
        if(conlst.size() >0)
        {
            for(Contact c : conlst ){
               c.Bad_Phone_Number__c  = True;
               conToUpdate.add(c);     
            }
        }
        System.debug('*****to update************'+conToUpdate.size());
        if(conToUpdate.size() > 0){
            update conToUpdate;
        }
         
    }
    
    
    if(accIds.size() >0)
    {
        List<Account> accToUpdate = new  List<Account>();
        
        System.debug('*****************'+accIds.size() );
        List<Account> acclst = [select id,Name,Bad_Phone_Number__c from
         Account where Id IN:accIds ];
        if(acclst.size() >0)
        {
            for(Account a : acclst ){
               a.Bad_Phone_Number__c  = True;
               accToUpdate.add(a);     
            }
        }
        System.debug('*****to update************'+accToUpdate.size());
        if(accToUpdate.size() > 0){
            update accToUpdate;
        }
         
    }
    
  /*  if(accIds.size() >0)
    {
        List<Lead> leadToUpdate = new  List<Lead>();
        List<Id> tskno = new List<Id>{};
        
       for(Task tsk : [Select t.Who.FirstName, t.Who.LastName, t.Who.Id, t.WhoId, t.Who.Type, t.Status, t.Id, t.Description, t.ActivityDate From Task t
        Where t.Who.Type = 'Lead' LIMIT 100]) 
            {
            tskno.add(tsk.Who.Id);
            }
       
        System.debug('*****************'+accIds.size() );
       // List<Task> task =  [Select t.Who.FirstName, t.Who.LastName, t.Who.Id, t.WhoId, t.Who.Type, t.Status, t.Id, t.Description, t.ActivityDate From Task t
       //  Where t.Who.Type = 'Lead'];
        List<Lead> leadlst = [select id,Name,FirstName,LastName,Bad_Phone_Number__c from Lead where LastName IN :tskno];
        if(leadlst.size() >0)
        {
        
        System.debug('testVi' );
            for(Lead l : leadlst){
               l.Bad_Phone_Number__c  = True;
               leadToUpdate.add(l);     
            }
        }
        System.debug('*****to update************'+leadToUpdate.size());
        if(leadToUpdate.size() > 0){
            update leadToUpdate;
        }  
         
    }  */
    

}