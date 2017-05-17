public with sharing class IIT_SendREGEmail {
    
    // 1. Before trigger is used to populate the Reg COde time once the Reg code is populated, It should wait for 15 mins and send an email about reg code
    public void handleBeforeOnORPC(map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> newMap, map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> oldMap)
    {
        for(invoiceit_s__Job_Rate_Plan_Charge__c newCharge : newMap.values()) 
        {
            invoiceit_s__Job_Rate_Plan_Charge__c oldCharge = oldMap.get(newCharge.Id);    
            
            if(newCharge.Reg_Code__c != null && oldCharge.Reg_Code__c == null)
            {
                newCharge.Reg_Code_Time__c =  system.now().addMinutes(62);
            }
        }
    }
    
    
    set<id> setofORPCIds = new set<id>();
    list<invoiceit_s__Job_Rate_Plan_Charge__c> listOfOrpc ;
    map<id,list<invoiceit_s__Job_Rate_Plan_Charge__c>> mapOfORPC = new map<id,list<invoiceit_s__Job_Rate_Plan_Charge__c>>();
    
    
    public void handleAfterOnORPC(map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> newMap, map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> oldMap){
    
    
    set<id> setofORPCIdsForEfiles = new set<id>();
    map<String,invoiceit_s__Job_Rate_Plan_Charge__c> setofaccounts= new map<String,invoiceit_s__Job_Rate_Plan_Charge__c>();
    map<String,String> regcodelist= new map<String,String>();
    map<String,String> mapaccountowner= new map<String,String>();
    map<String,User> mapuserdetails= new map<String,User>();
    String Acuntowner;
        
         EmailTemplate et=[SELECT id,Body,name, subject,HtmlValue FROM EmailTemplate where name='IIT_RegCodeTemplate'];
         
        for(invoiceit_s__Job_Rate_Plan_Charge__c orpc: newMap.values()){
            if((orpc.Reg_Code__c != '' && orpc.Reg_Code_Email_Status__c != oldMap.get(orpc.id).Reg_Code_Email_Status__c && orpc.Reg_Code_Email_Status__c == 'Send Reg Code') || (orpc.Prior_Year_Regcode__c !='' && orpc.Prior_Year_Reg_Code_Sent__c == false && oldMap.get(orpc.id).Prior_Year_Reg_Code_Sent__c == false )){
                 setofORPCIds.add(orpc.invoiceit_s__Order__c);           
            }   
            
            if(orpc.Free_EFiles__c == null && !setofORPCIds.contains(orpc.invoiceit_s__Order__c)) {
                setofORPCIdsForEfiles.add(orpc.Id);
            }
        }
        System.debug('setofORPCIdssetofORPCIds'+setofORPCIds.size());
        if(setofORPCIds.size() > 0){
            listOfOrpc = [SELECT Product_Name__c,Account_owner__c,Prior_Year_Regcode__c,Prior_Year_Reg_Code_Sent__c,invoiceit_s__Order__r.invoiceit_s__Account__r.Id,QTC__Quote_Line__r.Free_EFiles__c,Id,Name,invoiceit_s__Order__r.QTC__Opportunity__r.SBQQ__PrimaryQuote__r.SBQQ__PrimaryContact__r.Email,invoiceit_s__Order__c,Reg_Code_Email_Status__c,Reg_Code_Time__c,Reg_Code__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE invoiceit_s__Order__c =:setofORPCIds AND ((Reg_Code__c != null AND Reg_Code_Sent__c = false )OR (Prior_Year_Regcode__c !='' AND Prior_Year_Reg_Code_Sent__c = false))];
  
        
        system.debug('listOfOrpc--->'+listOfOrpc);
        string strRegcode = '';
        
        for(invoiceit_s__Job_Rate_Plan_Charge__c  charge : listOfOrpc){
        
        if(charge.invoiceit_s__Order__r.invoiceit_s__Account__r.Id != null || charge.invoiceit_s__Order__r.invoiceit_s__Account__r.Id != ''){
        
          setofaccounts.put(charge.invoiceit_s__Order__r.invoiceit_s__Account__r.Id,charge);
          
          if(!regcodelist.containskey(charge.invoiceit_s__Order__r.invoiceit_s__Account__r.Id)){
            
                if(charge.Prior_Year_Regcode__c !='' && charge.Prior_Year_Reg_Code_Sent__c == false){
                strRegcode = '';
                strRegcode += 'Product Name / Reg Code:   ' + charge.Product_Name__c+ ' ' + '/' + '  '+ charge.Prior_Year_Regcode__c + '<br/>' ;
                
                system.debug('Set of account here '+regcodelist);
                }else{
                
                strRegcode = '';
                strRegcode += 'Product Name / Reg Code:   ' + charge.Product_Name__c+ ' ' + '/' + '  '+ charge.Reg_Code__c + '<br/>' ;
                

                }
            }else{
            

                if(charge.Prior_Year_Regcode__c !='' && charge.Prior_Year_Reg_Code_Sent__c == false){

                String stng=regcodelist.get(charge.invoiceit_s__Order__r.invoiceit_s__Account__r.Id);
                strRegcode =stng += 'Product Name / Reg Code:   ' + charge.Product_Name__c+ ' ' + '/' + '  '+ charge.Prior_Year_Regcode__c + '<br/>' ;
                system.debug('Set of account here '+regcodelist);
                
                }else{
                String stng=regcodelist.get(charge.invoiceit_s__Order__r.invoiceit_s__Account__r.Id);
                strRegcode =stng += 'Product Name / Reg Code:   ' + charge.Product_Name__c+ ' ' + '/' + '  '+ charge.Reg_Code__c + '<br/>' ;
                }
            
            }
            
       if( (strRegcode!= null||strRegcode!='')){
            regcodelist.put(charge.invoiceit_s__Order__r.invoiceit_s__Account__r.Id,strRegcode);
             system.debug('regcode set value here '+regcodelist);
            }
            
            }
            
            if(charge.Account_owner__c!= null && charge.Account_owner__c !=''){
            mapaccountowner.put(charge.invoiceit_s__Order__r.invoiceit_s__Account__r.Id,charge.Account_owner__c);
             system.debug('Account owner to act id '+mapaccountowner);
            }
        }
        
        
        for(String s: mapaccountowner.keyset()){
       for(User u : [SELECT Id,username,Name,Email,Phone,IsActive FROM User WHERE id =:mapaccountowner.get(s)]){
       
       
       mapuserdetails.put(s,u);
       
       system.debug('usermap here '+mapuserdetails);
       
       }
       }
       
       system.debug('regcode set value here '+regcodelist);
       system.debug('Account owner to act id '+mapaccountowner);
       system.debug('usermap here '+mapuserdetails);
        
        LIST<Messaging.SingleEMailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(String s: mapuserdetails.keyset()){  
        
        string emailBody = et.Body.replace('dynamicData', regcodelist.get(s));
        
        string emailBodyName;
        string emailBodyPhone;
        string emailBodyEmail;
        
        if(mapuserdetails.get(s).Name!= null && mapuserdetails.get(s).Name!=''){
        emailBodyName = emailBody.replace('RepName', mapuserdetails.get(s).Name);
        }else{
        emailBodyName =emailBody;
        }
        
        if(mapuserdetails.get(s).Phone!= null && mapuserdetails.get(s).Phone!=''){
        emailBodyPhone = emailBodyName.replace('RepPhone', mapuserdetails.get(s).Phone);
        }else{
        emailBodyPhone =emailBodyName ;
        }
        
        if(mapuserdetails.get(s).Email!= null && mapuserdetails.get(s).Email!=''){
        emailBodyEmail = emailBodyPhone.replace('RepEmail', mapuserdetails.get(s).Email);
        }else{
        emailBodyEmail =emailBodyPhone ;
        }

        List<String> sendTo = new List<String>();
        sendTo.add(setofaccounts.get(s).invoiceit_s__Order__r.QTC__Opportunity__r.SBQQ__PrimaryQuote__r.SBQQ__PrimaryContact__r.Email);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTargetObjectId(setofaccounts.get(s).invoiceit_s__Order__r.QTC__Opportunity__r.SBQQ__PrimaryQuote__r.SBQQ__PrimaryContact__r.id);
        email.setWhatId(setofaccounts.get(s).invoiceit_s__Order__r.QTC__Opportunity__r.SBQQ__PrimaryQuote__r.id);
        email.setSaveAsActivity(true);      
        email.setToAddresses(sendTo);
        email.setSubject('REG Code Notification');
        
        email.setTemplateId(et.id);
        email.setHtmlBody(emailBodyEmail);
        mails.add(email);
        
        
        }
        
        Messaging.sendEmail ( mails);

        list<invoiceit_s__Job_Rate_Plan_Charge__c> listToUpdate = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
        for(invoiceit_s__Job_Rate_Plan_Charge__c  charge1 : listOfOrpc){
            if(charge1.Prior_Year_Regcode__c !='' && charge1.Prior_Year_Reg_Code_Sent__c == false){
            
            charge1.Prior_Year_Reg_Code_Sent__c=true;
            }else{
            charge1.Reg_Code_Sent__c = true;
            charge1.Free_EFiles__c = charge1.QTC__Quote_Line__r.Free_EFiles__c ;
            }
            listToUpdate.add(charge1);           
        }
        update listToUpdate;
      }  
      
      //and QTC__Quote_Line__r.Free_EFiles__c != null
      
      if(!setofORPCIdsForEfiles.isEmpty()) {
          list<invoiceit_s__Job_Rate_Plan_Charge__c> listToUpdate = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
            list<invoiceit_s__Job_Rate_Plan_Charge__c> listOfOrpc = [SELECT Id,QTC__Quote_Line__r.Free_EFiles__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE Id in: setofORPCIdsForEfiles and QTC__Quote_Line__r.Free_EFiles__c != null];
            if(!listOfOrpc.isEmpty()) {
                for(invoiceit_s__Job_Rate_Plan_Charge__c  charge1 : listOfOrpc){
                    charge1.Free_EFiles__c = charge1.QTC__Quote_Line__r.Free_EFiles__c ;
                    listToUpdate.add(charge1);           
                }
                update listToUpdate;
          }
      }
    }
    
    
}