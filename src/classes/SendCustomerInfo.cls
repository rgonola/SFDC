@RestResource(urlMapping='/getCustInfo/*')

global with sharing class SendCustomerInfo{
    @HttpPost 
    global static ReturnCustInfoJson.result doPost(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        Blob body = req.requestBody;
        
        ReturnCustInfoJson returnCustInfoJson=new ReturnCustInfoJson();
       try{
        Map<String, Object> m1= 
        (Map<String, Object>)JSON.deserializeUntyped(body.toString());
        
        LogFiles__c logFile=new LogFiles__c();
        logFile.Info__c='Recieved Json - ' +'  '+body.toString();
        
        for (String key : m1.keySet()) {
            
            if(key.equals('RETURN_CUST_INFO_WEB')){
             system.debug('Key is'+key);
             returnCustInfoJson.result=generateJsonReponse(m1,key);
            }
            logFile.Log_Type__c=key;
            logFile.Info__c=logFile.Info__c+'\n'+ 'Json response - '+returnCustInfoJson.result;
        }
        
            insert logFile;
            system.debug('Log file****'+logFile.Id);
       }
       catch(Exception e){
           system.debug('Exception'+e);
       }
        
        return ReturnCustInfoJson.result;
  }
     
    global static ReturnCustInfoJson.result generateJsonReponse(Map<String,Object> m1, String key){
            ReturnCustInfoJson jsonResponse=new ReturnCustInfoJson();
            List<Account> listAccount= new List<Account>();
            ReturnCustInfoJson.Result result= new ReturnCustInfoJson.Result();
            Account objAcc;
            String accountId;
            try{
                    
                Map<String, Object> customerAttributes = (Map<String, Object>)m1.get(key);
                system.debug('customerAttrbutes'+customerAttributes);
                for (String attributeName : customerAttributes.keyset()) {
                   Map<String, Object> customerAttributes2 = (Map<String, Object>)customerAttributes.get(attributeName);
                   system.debug('customerAttributes2 ****'+customerAttributes2); 
                    for(String attributeName2: customerAttributes2.keyset()){
                        if(String.isNotBlank((String)customerAttributes2.get(attributeName2)) && attributeName2.equals('SF_Account_ID')){
                          system.debug('attributeName2****'+attributeName2); 
                          accountId=(String)customerAttributes2.get(attributeName2);
                          system.debug('accountId****'+accountId);
                        }
                    
                                          
                   objAcc=[Select Id,PID__c, CID__c,OFFC__c, Brand__c, Type , Fax,Email__c, Primary_Contact_Name__c,Billing_Address_2__c,Phone__c, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Phone, 
                   Billing_Contact_Email__c,Primary_Contact_Fax__c,Primary_Contact_Phone__c,Shipping_Contact_Name__c,ShippingStreet,Shipping_Address_2__c,Primary_MobilePhone__c,Shipping_Contact_Email__c,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from Account where Id=:accountId];
                   
                   system.debug('Account details****'+objAcc);
                   
                   result.requestRecievedFor=key;
                   result.ClientID=objAcc.CID__c;
                   result.Status='Success';
                   result.Message='Details successfully retrieved';
                   result.SF_Account_ID=objAcc.id;
                   result.PID=objAcc.PID__c;
                   result.Office=String.ValueOf(objAcc.OFFC__c);
                   result.Phone=objAcc.Primary_Contact_Phone__c;
                   result.Fax=objAcc.Primary_Contact_Fax__c;
                   result.MobilePhone=objAcc.Primary_MobilePhone__c;
                   result.ContactEmailAddress=objAcc.Billing_Contact_Email__c;
                   result.CompanyName=objAcc.Name;
                   result.BillingAddress1=objAcc.BillingStreet;
                   result.BillingAddress2=objAcc.Billing_Address_2__c;
                   result.BillingCity=objAcc.BillingCity;
                   result.BillingState=objAcc.BillingState;
                   result.BillingZip=objAcc.BillingPostalCode;
                   result.BillingCountry=objAcc.BillingCountry;
                   result.ShippingAddress1=objAcc.ShippingStreet;
                   result.ShippingAddress2=objAcc.Shipping_Address_2__c;
                   result.ShippingCity=objAcc.ShippingCity;
                   result.ShippingState=objAcc.ShippingState;
                   result.ShippingZip=objAcc.ShippingPostalCode;
                   result.ShippingCountry=objAcc.ShippingCountry;
                   
                   system.debug('Primary Contact Name'+objAcc.Primary_Contact_Name__c);
                   if(objAcc.Primary_Contact_Name__c!=null){
                   
                       List<String> primaryContactName=objAcc.Primary_Contact_Name__c.split('\\s+');
                       system.debug('Size of Primary Contact Name'+primaryContactName.size());
                      
                       if(primaryContactName.size()==1){ 
                         result.PrimaryContactFirstName=primaryContactName[0];
                        } 
                  
                      else if(primaryContactName.size()==2){ 
                         result.PrimaryContactFirstName=primaryContactName[0];
                         result.PrimaryContactLastName=primaryContactName[1];
                       
                      }
                      else if(primaryContactName.size()==3){
                         result.PrimaryContactFirstName=primaryContactName[0]+'  '+primaryContactName[1];
                         result.PrimaryContactLastName=primaryContactName[2];
                      }
                }
                if(objAcc.Shipping_Contact_Name__c!=null){
                   List<String> secondaryContactName=objAcc.Shipping_Contact_Name__c.split('\\s+');
                   
                   if(secondaryContactName.size()==1){ 
                     result.secondaryContactFirstName=secondaryContactName[0]; 
                  } 
                  
                  else if(secondaryContactName.size()==2){ 
                     result.secondaryContactFirstName=secondaryContactName[0];
                     result.secondaryContactLastName=secondaryContactName[1];
                       
                  }
                  else if(secondaryContactName.size()==3){
                     result.secondaryContactFirstName=secondaryContactName[0]+'  '+secondaryContactName[1];
                     result.secondaryContactLastName=secondaryContactName[2];
                  }
                   
                   result.Status='Success';
                   jsonResponse.result=result;
                 }
                }
               }
             }catch(Exception ex){
               system.debug('Exception'+ex);
               result.Status='failure';
               result.requestRecievedFor=key;
               result.Message=ex.getMessage();
               result.ErrorCode='400';
               
               
           }
           return result;
    }                
}