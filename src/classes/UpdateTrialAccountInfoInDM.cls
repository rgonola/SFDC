global class UpdateTrialAccountInfoInDM
{
   
      @Future(callout=true)
      public static void trialAccount(Id AccountId,String skuid){
         
         system.debug('Inside Replicate customer');
        Configuration__c  config;
        
         Account acc= [ Select Id,PID__c, CID__c,OFFC__c, Brand__c, Type ,Primary_Contact_Phone__c, Fax,Email__c, Primary_Contact_Name__c,Billing_Address_2__c, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Phone, 
         Billing_Contact_Email__c,Shipping_Contact_Name__c,ShippingStreet,Shipping_Address_2__c,Primary_MobilePhone__c,Shipping_Contact_Email__c,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from Account where Id=:AccountId ];
         
         if(!Test.isRunningTest()){
          config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='DM Config'];
         }    
             try{
                 HttpResponse response= new HttpResponse();
                 
                 
                 JsonForAccount.tworeq TWO=new JsonForAccount.tworeq();
                 JsonForAccount.TWO replicate=new JsonForAccount.TWO(); 
                 
                
                 replicate.CID=acc.CID__c;
                 replicate.PID=acc.PID__c;
                 replicate.Office=String.valueOf(acc.OFFC__c);
          
                 replicate.CompanyName=acc.Name;
                 replicate.Email=acc.Email__c;
                 replicate.SFDC_AccountID=acc.id;
                 replicate.PhoneNumber=acc.Primary_Contact_Phone__c;
                 replicate.year=Label.Two_demo_year;
                 replicate.SKU =skuid;
                 
                 if(acc.Primary_Contact_Name__c!=null){
                   List<String>  contaName=acc.Primary_Contact_Name__c.split('\\s+');
                   if(contaName.size() > 1){
                       replicate.FirstName=contaName[0];                                           
                       replicate.LastName=contaName[1];      
                    }
                    
                    else{
                        replicate.FirstName=contaName[0];
                    }  
                 }
                 
                 
                  TWO.TWO =replicate;
                 
                 //Create request in JSon format    
                String strRequestParam = JSON.serialize(TWO);
                system.debug('strRequestParam****'+strRequestParam);
                
               LogFiles__c log=new LogFiles__c ();
               log.Related_Account__c=acc.Id;
               log.Log_Type__c='Trial Account';
               log.Info__c='Json - '+'  '+ strRequestParam;
               
               String endPoint;
               
               if(!Test.isRunningTest()){
                endPoint = ''+config.End_Point_URL__c+'twonlinedemo/'+acc.CID__c;
               }else{
                endPoint = 'https://qa2.sfdmlink.utsad.com/dm/api/clients/twonlinedemo';
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