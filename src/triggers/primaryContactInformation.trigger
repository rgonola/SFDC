trigger primaryContactInformation on Contact (after insert,after update) {
   Map<Id,Contact> conRecMap = new  Map<Id,Contact>();  
    set<String> conPhone = new set<String>();
    for(Contact con : Trigger.New ){
       if(con.Is_Primary__c == TRUE)
       {
           conRecMap.put(con.AccountId,con);
         /*  if(con.Phone <> NULL)
           {
               conPhone.add(con.Phone);
           }    
           */
       }    
    }
  
    Map<Id,Account> AccRecMap = new Map<Id,Account>();
    if(conRecMap.size() >0)
    {
        List<Account> acclist = [select Id,Name,Email__c,Primary_MobilePhone__c,Primary_Contact_Name__c,Primary_Contact_Phone__c from Account where Id IN : conRecMap.keyset()];
        if(acclist.size() > 0)
        {
            for(Account acc : acclist){
                AccRecMap.put(acc.Id,acc);
            }
        }    
    }
    List<Account> accToUpdate = new List<Account>();
    if(AccRecMap.size() >0)
    {
        for(Account acc : AccRecMap.Values()){
        
            Contact con = conRecMap.get(acc.Id);
            acc.Email__c = con.Email; 
            acc.Primary_Contact_Name__c = con.FirstName+' '+con.LastName ;
            acc.Primary_Contact_Phone__c = con.Phone ;
            acc.Primary_MobilePhone__c = con.MobilePhone ;
            acc.Primary_Contact_Fax__c=con.Fax;
            acc.Acct_Primary_Contact__c=con.id;
            accToUpdate.add(acc);  
        }
    }
 
    if(accToUpdate.size() > 0)
    {
        update accToUpdate;
    }
    if(conRecMap.size()>0)
    {
        List<contact> conList = [select id,Name,Is_Primary__c from contact where AccountId IN :conRecMap.keyset() AND ID NOT IN :Trigger.new];
       List<contact> contactToUpdate = new List<contact>(); 
        if(conList.size() >0)
        {
            for(contact contactOldRec : conList){
                contact oldcon= new contact(); 
                oldcon.Id = contactOldRec.Id ;
                oldcon.Is_Primary__c = FALSE ;
                contactToUpdate.add(oldcon);
            }
            if(contactToUpdate.size() >0)
            {
                update contactToUpdate;
            }
        }
     }   
     
     
    
   
    /* if(conPhone.size()>0)
    {
       
        for (List<Contact> ConDupChk  : [SELECT Phone,Id  FROM Contact
                            WHERE Phone IN : conPhone limit 1]) {
             if(ConDupChk.size()>0)
             {
                 Trigger.New[0].Phone.addError('Overlap Session');    
             }
            
        }
       
        Contact ConDupChk = [select Phone from Contact where Phone IN : conPhone limit 1];  
        if(ConDupChk <> NULL)
        {
              Trigger.New[0].Phone.addError('Overlap Session');
        }
     */   
    }