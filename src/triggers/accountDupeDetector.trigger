trigger accountDupeDetector on Account (before insert, before update) {
    
    Map<String, Account> accMap = new Map<String, Account>();
   
    
    List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    String currentProflieName = profile[0].Name;
    
    
    for (Account acc : System.Trigger.new) {

        if ((acc.Primary_MobilePhone__c != null) && (System.Trigger.isInsert || (acc.Primary_MobilePhone__c != System.Trigger.oldMap.get(acc.Id).Primary_MobilePhone__c))) {

            if (accMap.containsKey(acc.Primary_MobilePhone__c)) {

                acc.Primary_MobilePhone__c.addError('Another new account has the same Primary mobile phone.');

            } 
            else 
            {

                accMap.put(acc.Primary_MobilePhone__c, acc);

            }

        }
        
        
        
        

        if ((acc.Name != null) && (System.Trigger.isInsert || (acc.Name != System.Trigger.oldMap.get(acc.Id).Name))) {

            if (accMap.containsKey(acc.Name)) {

                acc.Name.addError('Another new account has the same Primary mobile phone.');

            } 
            else 
            {

                accMap.put(acc.Name, acc);

            }

        }
        
        if ((acc.Primary_Contact_Phone__c != null) && (System.Trigger.isInsert || (acc.Primary_Contact_Phone__c != System.Trigger.oldMap.get(acc.Id).Primary_Contact_Phone__c))) {

            if (accMap.containsKey(acc.Primary_Contact_Phone__c)) {

                acc.Primary_Contact_Phone__c.addError('Another new account has the same Primary mobile phone.');

            } 
            else 
            {

                accMap.put(acc.Primary_Contact_Phone__c, acc);

            }

        }
        
        
        if ((acc.Email__c != null) && (System.Trigger.isInsert || (acc.Email__c != System.Trigger.oldMap.get(acc.Id).Email__c))) {

            if (accMap.containsKey(acc.Email__c)) {

                acc.Email__c.addError('Another new account has the same Primary mobile phone.');

            } 
            else 
            {

                accMap.put(acc.Email__c, acc);

            }

        }
        
        
        if ((acc.Billing_Zip_Postal_Code__c != null) && (System.Trigger.isInsert || (acc.Billing_Zip_Postal_Code__c != System.Trigger.oldMap.get(acc.Id).Billing_Zip_Postal_Code__c))) {

            if (accMap.containsKey(acc.Billing_Zip_Postal_Code__c)) {

                acc.Billing_Zip_Postal_Code__c.addError('Another new account has the same Primary mobile phone.');

            } 
            else 
            {

                accMap.put(acc.Billing_Zip_Postal_Code__c, acc);

            }

        }
        
        
        if ((acc.RecordTypeId!= null) &&
                (System.Trigger.isInsert)) { 
                
            accMap.put(acc.RecordTypeId, acc); 
            
        }
            
        
    }
    
    
    if(currentProflieName == 'System Administrator') {
    
    
    
        for (Account accQ1 : [SELECT Primary_MobilePhone__c, RecordTypeId FROM Account where Primary_MobilePhone__c IN :accMap.KeySet() AND RecordTypeId IN :accMap.KeySet()] ) {
        
            Account acc1 = accMap.get(accQ1.Primary_MobilePhone__c);
            
            Account rec1 = accMap.get(accQ1.RecordTypeId);
            
            if (rec1.RecordTypeId == accQ1.RecordTypeId && acc1.Primary_MobilePhone__c == accQ1.Primary_MobilePhone__c) {
            
                acc1.Primary_MobilePhone__c.addError('An account with this Primary Mobile Phone already exists.');
            
            }
               
        }

       /* for (Account accQ2 : [SELECT Name, RecordTypeId FROM Account where Name IN :accMap.KeySet() AND RecordTypeId IN :accMap.KeySet()] ) {
        
            Account acc2 = accMap.get(accQ2.Name);
            
            Account rec2 = accMap.get(accQ2.RecordTypeId);
            
            if (rec2.RecordTypeId == accQ2.RecordTypeId) {
            
                acc2.Name.addError('An account with this Account name already exists.');
            } 
        }  */
        
        for (Account accQ3 : [SELECT Primary_Contact_Phone__c, RecordTypeId FROM Account where Primary_Contact_Phone__c IN :accMap.KeySet() AND RecordTypeId IN :accMap.KeySet()] ) {
        
            Account acc3 = accMap.get(accQ3.Primary_Contact_Phone__c);
            
            Account rec3 = accMap.get(accQ3.RecordTypeId);
            
            if (rec3.RecordTypeId == accQ3.RecordTypeId) {
            
                acc3.Primary_Contact_Phone__c.addError('An account with this Primary contact Phone already exists.');
                
            }
        }
        
        
        for (Account accQ4 : [SELECT Email__c, RecordTypeId FROM Account where Email__c IN :accMap.KeySet() AND RecordTypeId IN :accMap.KeySet()] ) {
        
            Account acc4 = accMap.get(accQ4.Email__c);
            
            Account rec4 = accMap.get(accQ4.RecordTypeId);
            
            if (rec4.RecordTypeId == accQ4.RecordTypeId) {
            
                acc4.Email__c.addError('An account with this Contact Email already exists.');
        
            }
        }
        
        for (Account accQ5 : [SELECT Name, Billing_Zip_Postal_Code__c, RecordTypeId FROM Account where Name IN :accMap.KeySet() AND Billing_Zip_Postal_Code__c IN :accMap.KeySet() AND RecordTypeId IN :accMap.KeySet()] ) {
             
            Account accname = accMap.get(accQ5.Name);
            
            Account acc5 = accMap.get(accQ5.Billing_Zip_Postal_Code__c);
            
            Account rec5 = accMap.get(accQ5.RecordTypeId);
            
            if (rec5.RecordTypeId == accQ5.RecordTypeId && (acc5.Billing_Zip_Postal_Code__c == accQ5.Billing_Zip_Postal_Code__c  &&  accname.Name == accQ5.Name)  ) {
                accname.name.addError('An account with Account Name and Billing Zip test already exists.');
                acc5.Billing_Zip_Postal_Code__c.addError('An account with Account Name and Billing Zip test already exists.');
            }
            
        }
        
    }   

}