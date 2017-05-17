trigger contactDupeDetector on Contact (before insert, before update) {

 

    Map<String, Contact> conMap = new Map<String, Contact>();
    Set<Id> recTypeIds = new Set<Id>();
 

    for (Contact con : System.Trigger.new) {

        // Make sure we don't treat an email address that  
    
        // isn't changing during an update as a duplicate.  
    
        if ((con.Email != null) &&
                (System.Trigger.isInsert ||
                (con.Email != 
                    System.Trigger.oldMap.get(con.Id).Email))) {
        
            // Make sure another new contact isn't also a duplicate  
    
            if (conMap.containsKey(con.Email)) {
                con.Email.addError('Another new contact has the '
                                    + 'same email address.');
            } else {
                conMap.put(con.Email, con);
            }
            }
           /////////////MobilePhone ///////////////
        if ((con.MobilePhone != null) &&
                (System.Trigger.isInsert ||
                (con.MobilePhone != 
                    System.Trigger.oldMap.get(con.Id).MobilePhone ))) {
        
            // Make sure another new contact isn't also a duplicate  
    
            if (conMap.containsKey(con.MobilePhone )) {
                con.MobilePhone.addError('Another new contact has the '
                                    + 'same MobilePhone .');
            } else {
                conMap.put(con.MobilePhone , con);
            }
            }
            ////////////Phone///////////
            if ((con.Phone!= null) &&
                (System.Trigger.isInsert ||
                (con.Phone!= 
                    System.Trigger.oldMap.get(con.Id).Phone))) {
        
            // Make sure another new phone isn't also a duplicate  
    
            if (conMap.containsKey(con.Phone)) {
                con.Phone.addError('Another new contact has the '
                                    + 'same Phone.');
            } else {
                conMap.put(con.Phone, con);
            }
            }
            
            
            if ((con.Account_Billing_Zip__c!= null) &&
                (System.Trigger.isInsert ||
                (con.Account_Billing_Zip__c!= 
                    System.Trigger.oldMap.get(con.Id).Account_Billing_Zip__c))) {
        
            // Make sure another new contact isn't also a duplicate  
    
            if (conMap.containsKey(con.Account_Billing_Zip__c)) {
                con.Account_Billing_Zip__c.addError('Another new contact has the '
                                    + 'same Billing Zip.');
            } else {
                conMap.put(con.Account_Billing_Zip__c, con);
            }
            }
            
            
            
            if ((con.Account.Name!= null) &&
                (System.Trigger.isInsert ||
                (con.Account.Name!= 
                    System.Trigger.oldMap.get(con.Id).Account.Name))) {
        
            // Make sure another new account isn't also a duplicate  
    
            if (conMap.containsKey(con.Account.Name)) {
                con.Account.Name.addError('Another new contact has the '
                                    + 'same Billing Zip.');
            } else {
                conMap.put(con.Account.Name, con);
            }
            }
            
            if ((con.RecordTypeId!= null) &&
                (System.Trigger.isInsert)) {  
                conMap.put(con.RecordTypeId, con);           
            }  
    
    
    }
    
    
    
    
    for (contact conT : [SELECT Email, RecordTypeId FROM contact
                      WHERE Email IN :conMap.KeySet() AND RecordTypeId IN :conMap.KeySet()]) {
        contact con1 = conMap.get(conT.Email);
        contact rec1 = conMap.get(conT.RecordTypeId);
        
        
        if (rec1.RecordTypeId == conT.RecordTypeId) {
            
            con1.Email.addError('A contact with this email '
                               + 'address already exists.');
                    
        }
        
    }
                               
   for (contact conT2 : [SELECT MobilePhone, RecordTypeId FROM contact
                      WHERE MobilePhone IN :conMap.KeySet() AND RecordTypeId IN :conMap.KeySet()]) {
        contact con2 = conMap.get(conT2.MobilePhone);
        contact rec2 = conMap.get(conT2.RecordTypeId);
        
        
        if (rec2.RecordTypeId == conT2.RecordTypeId) {
            
            con2.MobilePhone.addError('A contact with this Mobilephone '
                               + 'address already exists.');
                    
        }
        
    } 
                               
                               
                               
   for (contact conT3 : [SELECT Phone, RecordTypeId FROM contact
                      WHERE Phone IN :conMap.KeySet() AND RecordTypeId IN :conMap.KeySet()]) {
        contact con3 = conMap.get(conT3.Phone);
        contact rec3 = conMap.get(conT3.RecordTypeId);
        
        
        if (rec3.RecordTypeId == conT3.RecordTypeId) {
            
            con3.Phone.addError('A contact with this phone '
                               + 'address already exists.');
                    
        }
        
    }
                               
   /* for (contact conT4 : [SELECT Account_Billing_Zip__c, RecordTypeId FROM contact
                      WHERE Account_Billing_Zip__c IN :conMap.KeySet() AND RecordTypeId IN :conMap.KeySet()]) {
        contact con4 = conMap.get(conT4.Account_Billing_Zip__c);
        con4.Account_Billing_Zip__c.addError('A contact with this Billing Zip'
                               + 'address already exists.');
                               }                               */
                               
      for (contact conT5 : [SELECT Contact.Account.Name, RecordTypeId FROM contact
                      WHERE Contact.Account.Name IN :conMap.KeySet() AND RecordTypeId IN :conMap.KeySet() ]) {
        contact con5 = conMap.get(conT5.Account.Name);
        con5.Account.Name.addError('A contact with this Account name'
                               + 'address already exists.');
                               }
                              
}