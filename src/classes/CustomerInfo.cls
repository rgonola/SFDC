@RestResource(urlMapping='/CustInfo/*')

global with sharing class CustomerInfo{


@HttpPost
global static JsonResponse.result doPost(){
    RestRequest req = RestContext.request;
    RestResponse res = Restcontext.response;
    Blob body = req.requestBody;
    JsonResponse jsonResponse=new JsonResponse();
    
    try{
       
        Map<String, Object> m1= 
        (Map<String, Object>)JSON.deserializeUntyped(body.toString());
       
        LogFiles__c logFile=new LogFiles__c();
        logFile.Info__c='Recieved Json - ' +'  '+body.toString();
      
        for (String key : m1.keySet()) {
           
            if(key.equals('UPDATE_CUSTOMER')){
              jsonResponse.result=generateJsonReponse(m1,key);
             }
             
             else if(key.equals('GET_ACCOUNT_BALANCE')){
               jsonResponse.result=generateJsonReponse(m1,key);
            }
            
            else if(key.equals('EFINupdateInfo')){
               jsonResponse.result=generateJsonReponse(m1,key);
            }
             
            logFile.Log_Type__c=key;
            logFile.Info__c=logFile.Info__c+'\n'+ 'Json response - '+jsonResponse.result;
        }
          
          insert logFile;
         
     }catch(Exception ex){
        system.debug('exception'+ ex);
    }
      
    return jsonResponse.result;
    
 }
   
   
   global static Account getAccountInfo(Map<String,Object> m1, String key){
     Account acc= new Account();
     String Phonenumber;
     String MobilePhone;
     String firstnme;
     String lastnme;
     String Fax;
     Boolean contactupdate;
     
     try{
         Map<String, Object> customerAttributes = (Map<String, Object>)m1.get(key);
       
         for (String attributeName : customerAttributes.keyset()) {
               
                Map<String, Object> customerAttributes2 = (Map<String, Object>)customerAttributes.get(attributeName); 
               
                for(String attributeName2: customerAttributes2.keyset()){
                 
                    if(key.equals('GET_ACCOUNT_BALANCE')){
                        if(String.isNotBlank((String)customerAttributes2.get(attributeName2)) && attributeName2.equals('CID')){
                            acc.CID__c=(String)customerAttributes2.get(attributeName2);
                        }
                    }
                    
                   else if(key.equals('EFINupdateInfo')){
                        if(String.isNotBlank((String)customerAttributes2.get(attributeName2)) && attributeName2.equals('CID')){
                            acc.CID__c=(String)customerAttributes2.get(attributeName2);
                        }
                        
                        if(String.isNotBlank((String)customerAttributes2.get(attributeName2)) && attributeName2.equals('SF_AccountId')){
                            acc.Id=(String)customerAttributes2.get(attributeName2);
                        }
                        
                        if(String.isNotBlank((String)customerAttributes2.get(attributeName2)) && attributeName2.equals('EFIN')){
                            acc.EFIN__c=(String)customerAttributes2.get(attributeName2);
                        }
                    }
                    
                    
                    else if(key.equals('UPDATE_CUSTOMER')){
                        if(attributeName2.equals('ClientID') && String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                           acc.CID__c=(String)customerAttributes2.get(attributeName2);
                        }
                        
                   
                        if(attributeName2.equals('SF_Account_ID') && String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                          acc.Id=(String)customerAttributes2.get(attributeName2);
                         
                        }
                        
                        if(attributeName2.equals('PID') && String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                          acc.PID__c=(String)customerAttributes2.get(attributeName2);
                        }
                        
                        if(attributeName2.equals('Office') && String.isNotBlank((String)customerAttributes2.get(attributeName2)) ){
                           
                         acc.OFFC__c=decimal.valueOf((String)customerAttributes2.get(attributeName2));
                        }
                        
                        if(attributeName2.equals('PrimaryContactFirstName') && String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            
                            acc.Primary_Contact_Name__c=(String)customerAttributes2.get(attributeName2);
                            firstnme=(String)customerAttributes2.get(attributeName2);
                        }
                        
                         if(attributeName2.equals('PrimaryContactLastName')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            
                            acc.Primary_Contact_Name__c=acc.Primary_Contact_Name__c+' '+(String)customerAttributes2.get(attributeName2);
                            lastnme=(String)customerAttributes2.get(attributeName2);
                        }
                        
                         if(attributeName2.equals('SecondaryContactFirstName')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                          
                            acc.Shipping_Contact_Name__c=(String)customerAttributes2.get(attributeName2);
                          
                        }
                        
                         if(attributeName2.equals('SecondaryContactLastName')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.Shipping_Contact_Name__c=acc.Shipping_Contact_Name__c+' '+(String)customerAttributes2.get(attributeName2);
                        }
                       
                        if(attributeName2.equals('CompanyName')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                         acc.Name=(String)customerAttributes2.get(attributeName2);
                           
                        }
                        
                        if(attributeName2.equals('BillingAddress1') && String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.BillingStreet=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                         if(attributeName2.equals('BillingAddress2')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.Billing_Address_2__c=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                         if(attributeName2.equals('BillingCity')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.BillingCity=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                        if(attributeName2.equals('BillingZip')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.BillingPostalCode=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                        if(attributeName2.equals('BillingCountry')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.BillingCountry=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                        if(attributeName2.equals('BillingState')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.BillingState=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                        if(attributeName2.equals('Phone')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            Phonenumber=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Phone_Number__c=false;
                        }
                        
                        if(attributeName2.equals('ContactEmailAddress')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.Billing_Contact_Email__c=(String)customerAttributes2.get(attributeName2);
                            acc.Shipping_Contact_Email__c=(String)customerAttributes2.get(attributeName2);
                            //acc.Email__c=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Email__c=false;
                            
                        }
                        
                        if(attributeName2.equals('ShippingAddress1')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.ShippingStreet=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                         if(attributeName2.equals('ShippingAddress2')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.Shipping_Address_2__c=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                        if(attributeName2.equals('ShippingCity')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.ShippingCity=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                         if(attributeName2.equals('ShippingState')&& String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.ShippingState=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                       
                         if(attributeName2.equals('ShippingZip') && String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.ShippingPostalCode=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                         if(attributeName2.equals('ShippingCountry') && String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            acc.ShippingCountry=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Address__c=false;
                        }
                        
                         if(attributeName2.equals('Fax') && String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            Fax=(String)customerAttributes2.get(attributeName2);
                        }
                        
                        if(attributeName2.equals('MobilePhone') && String.isNotBlank((String)customerAttributes2.get(attributeName2))){
                            MobilePhone=(String)customerAttributes2.get(attributeName2);
                            acc.Bad_Phone_Number__c=false;
                        }                        
                        
                    }
                }
             }
          
          
          List<Contact> c=[Select Id,Email,Phone,MobilePhone,Fax From Contact Where AccountId =:acc.id AND Is_Primary__c=TRUE];
          
          if(acc.Billing_Contact_Email__c != null || acc.Billing_Contact_Email__c !=''){
          c[0].Email =acc.Billing_Contact_Email__c;
          contactupdate=true;
          }
          
          if(Phonenumber!=null || Phonenumber!=''){
          
          c[0].Phone=Phonenumber;
          contactupdate=true;
          }
          
          if(MobilePhone!=null || MobilePhone!=''){
          
          c[0].MobilePhone=MobilePhone;
          contactupdate=true;
          }
          
          if(Fax!=null || Fax!=''){
          
          c[0].Fax=Fax;
          contactupdate=true;
          }
          
          if(firstnme!=null || firstnme !=''|| lastnme!=null || lastnme !=''){
          
          c[0].FirstName=firstnme;
          c[0].LastName=lastnme;
          contactupdate=true;
          }
          
          
          if(contactupdate==true)
           update c[0];
           
       } catch(Exception ex){
           system.debug('Exception'+ ex);
       } 
        return acc;
   }
    
    global static JsonResponse.result generateJsonReponse(Map<String,Object> m1, String key){
            JsonResponse jsonResponse=new JsonResponse();
            List<Account> listAccount= new List<Account>();
            JsonResponse.Result result= new JsonResponse.Result();
            Account objAcc;
            try{
            
                if(key.equals('GET_ACCOUNT_BALANCE')){ 
                   objAcc=getAccountInfo(m1,key);
                   result.requestRecievedFor=key;
                   result.CID=objAcc.CID__c;
                   result.Balance= [SELECT Outstanding_Balance__c FROM Account 
                   WHERE CID__c =:objAcc.CID__c].Outstanding_Balance__c;
                   result.Status='Success';
                   jsonResponse.result=result;
              
                  
               }
               else if(key.equals('UPDATE_CUSTOMER') || key.equals('UPDATE_TRAINING_ATTENDED')){
                   objAcc=getAccountInfo(m1,key); 
                   listAccount.add(objAcc);
                   if(listAccount.size()>0){
                      upsert listAccount objAcc.Id;
                      result.requestRecievedFor=key;
                      result.CID=objAcc.CID__c;
                      result.Status='Success';
                   }
                
               }
               
              else if(key.equals('EFINupdateInfo')){
                   objAcc=getAccountInfo(m1,key);
                   listAccount.add(objAcc);
                    if(listAccount.size()>0){
                      update listAccount;
                      result.requestRecievedFor=key;
                      result.CID=objAcc.CID__c;
                      result.Status='Success';
                   }
                
                   
              }
          }catch(Exception ex){
               
               result.Status='failure';
               result.requestRecievedFor=key;
               result.Message=ex.getMessage();
               result.ErrorCode='400';
               
               
           }
           return result;
    }
}