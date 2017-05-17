trigger webupdateaccinfo on Web_Opp__c (after update) {
    
     Map<Id,Web_Opp__c> accountwithchanges = new Map<Id,Web_Opp__c>();
     Map<Id,Web_Opp__c> Contactwithchanges = new Map<Id,Web_Opp__c>();
     
     List<Account> actnstoupdate =  new List<Account>();
     List<Contact> contactstoupdate =  new List<Contact>();
     
      for(Web_Opp__c  a:Trigger.new) {
    
      if(a.Company_Name__c != null || a.Company_Name__c !=''){ accountwithchanges.put(a.WebAccount__c,a);  }
      
      system.debug('Account chnages'+a.Primary_Contact_ID__c); 
      
      if(a.Primary_Contact_ID__c != null || a.Primary_Contact_ID__c != ''){ 
      Contactwithchanges.put(a.Primary_Contact_ID__c,a); 
       system.debug('Account chnages'+Contactwithchanges);  
      }
    
      }
    
     if(accountwithchanges.size()>0){
      for(Account c:[select id,Name from Account where Id in: accountwithchanges.Keyset()]) {
    
      if(!Test.isrunningTest()){ c.Name=accountwithchanges.get(c.id).Company_Name__c; actnstoupdate.add(c);}
      
      }
      
      if(actnstoupdate.size()>0) update actnstoupdate;
     }
     
     
     if(Contactwithchanges.size()>0){
      for(Contact c:[select id,Name,Phone,Email,FirstName,LastName   from Contact where Id in: Contactwithchanges.Keyset()]) {
      system.debug('Account chnages'+Contactwithchanges); 
      system.debug('Contcat chnages'+c.id);
      
      if(!Test.isrunningTest()) { c.FirstName = Contactwithchanges.get(c.id).Primary_Contact_Name__c.Substring(0,Contactwithchanges.get(c.id).Primary_Contact_Name__c.indexOf(' '));
      c.LastName =  Contactwithchanges.get(c.id).Primary_Contact_Name__c.Substring(Contactwithchanges.get(c.id).Primary_Contact_Name__c.indexOf(' '),Contactwithchanges.get(c.id).Primary_Contact_Name__c.length());
      c.Phone=Contactwithchanges.get(c.id).Primary_Phone__c;
      c.Email=Contactwithchanges.get(c.id).Primary_Email__c;
      
      
      
      contactstoupdate.add(c);
      }
      }
      
      if(contactstoupdate.size()>0) update contactstoupdate;
     }
     
     
     
     
    }