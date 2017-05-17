global class UpdateAccountInfoInDM
{
   
    
   @Future(callout=true)  
   public static void sendCCOnFileAndCutOffData(Id accountId, String RequestType){
      
      Configuration__c  config;
      
       try{
       
       if(!Test.isRunningTest()){
       config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='DM Config'];
       }
       
       Account acc= [Select CID__c,PID__c,CC_on_File__c,Financial_Status__c,FS_Reason__c,Account_Cut_Off_Cut_On_Date__c,Active__c,Cutoff__c from Account where Id =:accountId];
       String endPoint;
       
       HttpResponse response= new HttpResponse();
       
       if(RequestType=='ccOnFile'){
       
           LogFiles__c log=new LogFiles__c();
           log.Log_Type__c='CCOnFile';
           
           if(!Test.isRunningTest()){
           endPoint=''+config.End_Point_URL__c+''+acc.CID__c+'/cconfile?flag='+acc.CC_on_File__c;
          }else{
           endPoint = 'https://qa2.sfdmlink.utsad.com/dm/api/clients/'+acc.CID__c+'/cconfile?flag='+acc.CC_on_File__c;
           }
           
           log.Info__c='EndPointUrl '+'  '+ endPoint;
           
           log.Related_Account__c=acc.Id;
           
           response=UpdateAccountInfoInDM.sendRequest(endPoint,'PUT');  
           log.Info__c=log.Info__c+'\n'+'Response of CConFile - '+response;
           log.Error_Code__c=response.getStatusCode();
           log.Response__c=response.getbody();
           
            Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                
                  for (String key : m1.keySet()) {
           
                if(String.isNotBlank((String)m1.get('error_code')) && key.equals('error_code')){
                
                   log.DM_Error_Code__c=(String)m1.get('error_code');
                 
                } else if(String.isNotBlank((String)m1.get('error_message')) && key.equals('error_message')){
                
                   log.DM_Error_Message__c=(String)m1.get('error_message');
                }
            
                }
           insert log;
           
           system.debug('Log Id of CC on file - '+log.Id);
           
           
           
       }
       
       if(RequestType=='cutoffData'){
           
           system.debug('Cut off date**'+acc.Account_Cut_Off_Cut_On_Date__c);
           
           DateTime cutOffDate = Date.Valueof(acc.Account_Cut_Off_Cut_On_Date__c);  
           //DateTime cutOffDate =DateTime.Now();
           
           system.debug('cutOffDate **'+cutOffDate);
          
          
           String cutoffformattedDate=cutOffDate.format('dd-MMM-YY');
           
           system.debug('cutoffformattedDate**'+cutoffformattedDate);
          
          if(!Test.isRunningTest()){
           endPoint=''+config.End_Point_URL__c+''+acc.CID__c+'/activate?status='+acc.Cutoff__c+'&reason='+acc.FS_Reason__c.replaceAll( '\\s+', '')+'&date='+cutoffformattedDate;
           }else{
           endPoint='https://qa2.sfdmlink.utsad.com/dm/api/clients/'+acc.CID__c+'/activate?status='+acc.Cutoff__c+'&reason='+acc.FS_Reason__c.replaceAll( '\\s+', '')+'&date='+cutoffformattedDate;
           }
           
           LogFiles__c log=new LogFiles__c ();
           
           log.Related_Account__c=acc.Id;
           log.Log_Type__c='Cut off/Cut on Customer';
           log.Info__c='EndPointUrl of CutOffFile - '+'  '+ endPoint;
           
           response=UpdateAccountInfoInDM.sendRequest(endPoint,'PUT');  
           log.Info__c=log.Info__c+'\n'+'Response of Cut Off File - '+response;
           log.Error_Code__c=response.getStatusCode();
           log.Response__c=response.getbody();
           
            Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                
                  for (String key : m1.keySet()) {
           
                if(String.isNotBlank((String)m1.get('error_code')) && key.equals('error_code')){
                
                   log.DM_Error_Code__c=(String)m1.get('error_code');
                 
                } else if(String.isNotBlank((String)m1.get('error_message')) && key.equals('error_message')){
                
                   log.DM_Error_Message__c=(String)m1.get('error_message');
                }
            
                }
                
           insert log;
           
           system.debug('Log Id of Cut off and On data - '+log.Id);
       }
       
       } catch(Exception Ex){
           system.debug('Exception'+Ex);
       }
                     
   }
   
      @Future(callout=true)
      public static void replicateCustomer(Id AccountId){
         
         Configuration__c  config;
         system.debug('Inside Replicate customer');
         
         if(!Test.isRunningTest()){
          config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='DM Config'];
         }
         
         Account acc= [ Select Id,PID__c, CID__c,OFFC__c, Brand__c, Type,Primary_Contact_Phone__c,Primary_Contact_Fax__c , Fax,Email__c, Primary_Contact_Name__c,Billing_Address_2__c, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Phone, 
         Billing_Contact_Email__c,Shipping_Contact_Name__c,ShippingStreet,Shipping_Address_2__c,Primary_MobilePhone__c,Shipping_Contact_Email__c,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from Account where Id=:AccountId AND Has_PFX_Promotion__c=false ];
         
         List<Contact> cnts=[SELECT name,FirstName,LastName FROM Contact Where Account.id=:acc.id and Is_Primary__c=true];
             try{
                 HttpResponse response= new HttpResponse();
                 
                 JsonForAccount accInfo=new JsonForAccount();
                 JsonForAccount.ReplicateCustomer replicate=new JsonForAccount.ReplicateCustomer (); 
                 
                 JsonForAccount.Sfdc sfdc=new JsonForAccount.Sfdc();
                 sfdc.SF_Account_ID=acc.Id;
                 replicate.Sfdc=sfdc;
                 
                 JsonForAccount.Customer custInfo=new JsonForAccount.Customer();
                 custInfo.ClientID=acc.CID__c;
                 custInfo.PID=acc.PID__c;
                 custInfo.Office=String.valueOf(acc.OFFC__c);
                 custInfo.Brand_Type=acc.Brand__c;
                 
                 if(cnts.size()>0){
                  
                  custInfo.First_Name=cnts[0].FirstName;                                           
                  custInfo.Last_Name=cnts[0].LastName;
                 }
                
                 custInfo.Company=acc.Name;
                 custInfo.Email=acc.Email__c;
                 replicate.Customer=custInfo;
                 
                List<JsonForAccount.Contacts> Contacts = new List<JsonForAccount.Contacts> ();
                
                
                JsonForAccount.Contacts contact1=new JsonForAccount.Contacts();
                JsonForAccount.Contacts contact2=new JsonForAccount.Contacts();
                
                 contact1.Cnt_Type='Mailing';
                 contact1.Phone=acc.Primary_Contact_Phone__c;
                 contact1.Fax=acc.Primary_Contact_Fax__c;
                 
                 system.debug('Primary Mobile**'+acc.Primary_MobilePhone__c);
                 
                 contact1.Mobile=acc.Primary_MobilePhone__c;
                 contact1.Email=acc.Billing_Contact_Email__c;
                 contact1.Addr1=acc.BillingStreet;
                 contact1.Addr2=acc.Billing_Address_2__c;
                 contact1.City=acc.BillingCity;
                 contact1.State=acc.BillingState;
                 contact1.Zip=acc.BillingPostalCode ;
                 contact1.Country=acc.BillingCountry;
                 
                 contact2.Cnt_Type='Shipping';
                 contact2.Phone=acc.Primary_Contact_Phone__c;
                 contact2.Fax=acc.Primary_Contact_Fax__c;
                 contact2.Mobile=acc.Primary_MobilePhone__c;
                 contact2.Email=acc.Shipping_Contact_Email__c;
                 contact2.Addr1=acc.ShippingStreet;
                 contact2.Addr2=acc.Shipping_Address_2__c;
                 contact2.City=acc.ShippingCity;
                 contact2.State=acc.ShippingState;
                 contact2.Zip=acc.ShippingPostalCode;
                 contact2.Country=acc.ShippingCountry;
                 
                 Contacts.add(contact1);
                 Contacts.add(contact2);
                
                 replicate.Contacts=Contacts;
                 
                 accInfo.replicateCustomer=replicate;
                 
                 //Create request in JSon format    
                String strRequestParam = JSON.serialize(accInfo);
                system.debug('strRequestParam****'+strRequestParam);
                
               LogFiles__c log=new LogFiles__c ();
               log.Related_Account__c=acc.Id;
               log.Log_Type__c='Replicate Customer';
               log.Info__c='Json - '+'  '+ strRequestParam;
               
               String endPoint;
               
               if(!Test.isRunningTest()){
               endPoint = ''+config.End_Point_URL__c+'replicatecustomer/'+acc.CID__c;
               }else{
               endPoint = 'https://qa2.sfdmlink.utsad.com/dm/api/clients/replicatecustomer';
               }
               
               log.Info__c=log.Info__c+'\n '+ 'endPoint url -  '+endPoint; 
               
                response=sendRequestWithJson(endPoint,'POST',strRequestParam);
              
                log.Info__c=log.Info__c+'\n' +'Response - '+response;
                log.Error_Code__c=response.getStatusCode();
                log.Response__c=response.getbody();
                
                
             
               Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                
                  for (String key : m1.keySet()) {
           
                if(String.isNotBlank((String)m1.get('error_code')) && key.equals('error_code')){
                
                   log.DM_Error_Code__c=(String)m1.get('error_code');
                 
                } else if(String.isNotBlank((String)m1.get('error_message')) && key.equals('error_message')){
                
                   log.DM_Error_Message__c=(String)m1.get('error_message');
                }
            
                }
                
                
                insert log;
                
                system.debug('Log Id of Replicate customer'+log.Id);
             
             }catch(Exception e){
                 System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber());  
             }
         
     }
     
      @Future(callout=true)
      public static void replicateToken(Id pmId){
        
        Configuration__c  config;
        
        if(!Test.isRunningTest()){
         config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='DM Config'];
        }
        
        invoiceit_s__Payment_Method__c paymentMethod=[Select Id, invoiceit_s__Billing_First_Name__c,invoiceit_s__Billing_Last_Name__c,invoiceit_s__Default__c,invoiceit_s__Card_Number__c,
        invoiceit_s__Billing_Email__c,invoiceit_s__Account__c,invoiceit_s__Active__c,invoiceit_s__Payment_Method__c,invoiceit_s__Payment_Profile_ID__c,invoiceit_s__Card_Expiration_Month__c,invoiceit_s__Card_Expiration_Year__c,
        Last_4_Digits__c,invoiceit_s__CVV__c,invoiceit_s__Bank_Account_Number__c,invoiceit_s__Bank_Account_Name__c,invoiceit_s__Bank_Account_Type__c,
        invoiceit_s__Bank_Name__c,invoiceit_s__Name_on_Card__c,invoiceit_s__Bank_Routing_Code__c,invoiceit_s__Card_Type__c,invoiceit_s__Billing_Address__c,invoiceit_s__Billing_City__c,invoiceit_s__Billing_State_Province__c,
        invoiceit_s__Billing_Country__c,invoiceit_s__Billing_Zip_Postal__c,CC_OnFile_Check__c from invoiceit_s__Payment_Method__c  where Id=:pmId];
        
        Account acc=[Select Id,Name,CID__c,PID__c from Account where Id=:paymentMethod.invoiceit_s__Account__c];
        
        try{
            HttpResponse response= new HttpResponse();
            
            ReplicateTokenJson replicateTokenJson=new ReplicateTokenJson();
            ReplicateTokenJson.ReplicateToken replicateToken=new ReplicateTokenJson.ReplicateToken(); 
            ReplicateTokenJson.Sfdc sfdc=new ReplicateTokenJson.Sfdc();
            ReplicateTokenJson.Information info=new ReplicateTokenJson.Information(); 
            ReplicateTokenJson.Credit_Card_Details cardDetails=new ReplicateTokenJson.Credit_Card_Details();
            ReplicateTokenJson.Bank_Details bankDetails=new ReplicateTokenJson.Bank_Details(); 
            ReplicateTokenJson.Address address=new ReplicateTokenJson.Address();
            
            sfdc.SF_Account_ID=paymentMethod.invoiceit_s__Account__c;
            sfdc.SF_PaymentMethod_ID=paymentMethod.Id;
            
            info.Billing_FirstName=paymentMethod.invoiceit_s__Billing_First_Name__c;
            info.Billing_LastName=paymentMethod.invoiceit_s__Billing_Last_Name__c;
            info.Billing_Email=paymentMethod.invoiceit_s__Billing_Email__c;
            info.Account_Name=acc.Name;
            info.Active=String.ValueOf(paymentMethod.invoiceit_s__Active__c);
            info.Default_Check=String.ValueOf(paymentMethod.invoiceit_s__Default__c);
            info.Payment_Method=paymentMethod.invoiceit_s__Payment_Method__c;
            info.Payment_Profile_ID=paymentMethod.invoiceit_s__Payment_Profile_ID__c;
            info.PID=acc.PID__c;
            info.CID=acc.CID__c;
            
            cardDetails.Four_Digit_Card_Number=paymentMethod.invoiceit_s__Card_Number__c;
            cardDetails.Name_On_The_Card=paymentMethod.invoiceit_s__Name_on_Card__c;
            if(paymentMethod.invoiceit_s__Card_Type__c =='Mastercard'){
            cardDetails.Card_Type='Master Card';
            }else if(paymentMethod.invoiceit_s__Card_Type__c =='American Express'){
            cardDetails.Card_Type='Amex';
            }else{
            cardDetails.Card_Type=paymentMethod.invoiceit_s__Card_Type__c;
            
            }
            cardDetails.Card_Expiration_Month=paymentMethod.invoiceit_s__Card_Expiration_Month__c;
            cardDetails.Card_Expiration_Year=paymentMethod.invoiceit_s__Card_Expiration_Year__c;
            cardDetails.CVV=paymentMethod.invoiceit_s__CVV__c;
        
            bankDetails.Bank_Account_number=paymentMethod.invoiceit_s__Bank_Account_Number__c;
            bankDetails.Bank_Account_name=paymentMethod.invoiceit_s__Bank_Account_Name__c;
            bankDetails.Bank_Account_Type=paymentMethod.invoiceit_s__Bank_Account_Type__c;
            bankDetails.Bank_Name=paymentMethod.invoiceit_s__Bank_Name__c;
            bankDetails.Bank_Routing_Code=paymentMethod.invoiceit_s__Bank_Routing_Code__c;
            
            address.Billing_Address=paymentMethod.invoiceit_s__Billing_Address__c;
            address.Billing_City=paymentMethod.invoiceit_s__Billing_City__c;
            address.Billing_State=paymentMethod.invoiceit_s__Billing_State_Province__c;
            address.Billing_Zip=paymentMethod.invoiceit_s__Billing_Zip_Postal__c;
            address.Billing_Country=paymentMethod.invoiceit_s__Billing_Country__c;
            
            replicateToken.Sfdc=sfdc;
            replicateToken.Information=info;
            replicateToken.Credit_Card_Details=cardDetails;
            replicateToken.Bank_Details=bankDetails;
            replicateToken.Address=address;
            
            replicateTokenJson.ReplicateToken=replicateToken;
            
            String strRequestParam = JSON.serialize(replicateTokenJson);
            
            LogFiles__c log=new LogFiles__c ();
            log.Related_Account__c=acc.Id;
            log.Log_Type__c='Replicate Token';
            log.Info__c='Json - '+'  '+ strRequestParam;
            
            String endPoint;
            
            if(!Test.isRunningTest()){   
            endPoint = ''+config.End_Point_URL__c+'replicatetoken/'+acc.Id;
            }else{
            endPoint = 'https://qa2.sfdmlink.utsad.com/dm/api/clients/replicatetoken';
            }
               
            log.Info__c=log.Info__c+'\n '+ 'endPoint url -  '+endPoint; 
               
            response=sendRequestWithJson(endPoint,'POST',strRequestParam);
            
            
            log.Info__c=log.Info__c+'\n' +'Response - '+response;
            log.Error_Code__c=response.getStatusCode();
            log.Response__c=response.getbody();
            
             
             
               Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                
                  for (String key : m1.keySet()) {
           
                if(String.isNotBlank((String)m1.get('error_code')) && key.equals('error_code')){
                
                   log.DM_Error_Code__c=(String)m1.get('error_code');
                 
                } else if(String.isNotBlank((String)m1.get('error_message')) && key.equals('error_message')){
                
                   log.DM_Error_Message__c=(String)m1.get('error_message');
                }
            
                }
              
                
            insert log;
            
            
            system.debug('Log Id of Replicate Token'+log.Id);
            
            system.debug('response Status**'+response.getStatus());
            
            if(response.getStatus()=='Success' && paymentMethod.CC_OnFile_Check__c==false ){
                Account account=new Account(id=acc.Id,CC_on_File__c=True);
                update account;
                
                invoiceit_s__Payment_Method__c pm=new invoiceit_s__Payment_Method__c(Id=paymentMethod.id,CC_OnFile_Check__c=true);
                update pm;
            }
            
             
            
        }
        catch(Exception ex){
             System.debug('Error:' + ex.getMessage() + 'LN:' + ex.getLineNumber());  
        }
      }
     
   /*  @Future(callout=true)
      public static void replicateIfirmUrl(Id oppId){
      Opportunity opp=[Select AccountId, Id,IFirm_URL_Create_Date__c,Suggested_iFirm_URL_v__c,of_iFirm_Users__c,iFirm_URL__c from Opportunity where Id=:oppId];
      
          try{
               HttpResponse response= new HttpResponse();
               iFirmUrlJson iFirmJson=new iFirmUrlJson();
               iFirmUrlJson.ReplicateIfirmUrl replicateIfirmurl=new iFirmUrlJson.ReplicateIfirmUrl();
               iFirmUrlJson.Sfdc sfdc=new iFirmUrlJson.Sfdc();
               iFirmUrlJson.Opportunity opportunity=new iFirmUrlJson.Opportunity();
               
               sfdc.SF_Opportunity_Id=opp.Id;
               sfdc.SF_Account_ID=opp.AccountId;
               
               opportunity.ifirm_Url=opp.iFirm_URL__c;
               opportunity.ifirm_url_create_Date=String.ValueOf(opp.IFirm_URL_Create_Date__c);
               opportunity.Suggested_ifirm_url=opp.Suggested_iFirm_URL_v__c;
               opportunity.numberOfUsers=opp.of_iFirm_Users__c;
               
               replicateIfirmurl.SFDC=sfdc;
               replicateIfirmurl.Opportunity=opportunity;
               
               iFirmJson.ReplicateIfirmUrl=replicateIfirmurl;
               
               String strRequestParam =JSON.serialize(iFirmJson);
               
               String endPoint = 'https://qa-sfdmlink.utsad.com/dm/api/clients/replicateiFirmUrl';
               // String endPoint = 'https://sfdmlink.utsad.com/dm/api/clients/replicateiFirmUrl';
               response=sendRequestWithJson(endPoint,'POST',strRequestParam);
            
               LogFiles__c log=new LogFiles__c ();
               log.Related_Account__c=opp.AccountId;
               log.Related_Opportunity__c=opp.Id;
               log.Log_Type__c='Replicate iFirm Url';
               log.Info__c='Json - '+'  '+ strRequestParam;
               
               log.Info__c=log.Info__c+'\n' +'Response - '+response;
               log.Error_Code__c=response.getStatusCode();
               insert log;
               system.debug('Log Id of Replicate IfirmUrl'+log.Id);
            
         
          
          }catch(Exception ex){
              System.debug('Error:' + ex.getMessage() + 'LN:' + ex.getLineNumber()); 
          }
      }*/
      
     
     public static HttpResponse sendRequest(String EndPointUrl, String method ){
              HttpRequest req = new HttpRequest();
              Http http = new Http();
              req.setMethod(method);
              req.setEndpoint(EndPointUrl);
              req.setHeader('Content-Type', 'application/json');
              req.setHeader('Content-Length','0'); 
              req.setTimeout(120000);
              HttpResponse res = http.send(req);
          
          return res;    
      
      }
      
      public static HttpResponse sendRequestWithJson(String EndPointUrl, String method,String Json){
              HttpRequest req = new HttpRequest();
                Http http = new Http();
                req.setMethod('POST');
                req.setEndpoint(EndPointUrl);
                req.setbody(Json);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Content-Length','1024');
                req.setTimeout(120000);
                HttpResponse res = http.send(req);
          
          return res;    
      
      }
      
}