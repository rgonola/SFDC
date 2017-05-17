global class IcareSiteUpdate
{
      
      public void UpdateIfirmdetails(Id provid){
      
      Provisioning__c opp=[Select Account__c,Account__r.Id,Account__r.Name,Account__r.Email__c,Total_iFirm_User__c,Id,Deffered_Date__c,IFirm_URL__c,On_Boarding_Status__c,No_Of_Users__c,Related_Quote__c,Site_Id__c,
                                  Status__c,Type_Of_Provisioning__c,Opportunity_id__c,Profile__c
                                  from Provisioning__c  where id=:provid ORDER BY Createddate DESC Limit 1];
          try{
                                  
       Configuration__c  config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='Icare configuration'];
          
               HttpResponse response= new HttpResponse();
               
               iFirmUpdateUrlJson icarejson=new iFirmUpdateUrlJson();
              
               iFirmUpdateUrlJson.Features feature=new iFirmUpdateUrlJson.Features();
               
               icarejson.LicenceName=opp.Account__r.Name;
               icarejson.Users=String.ValueOf(opp.Total_iFirm_User__c);
               icarejson.CountryCode='US';
               icarejson.Timezone='America/New_York';
               icarejson.ResetUserEmail=opp.Account__r.Email__c;
              
               
              List<string> Strng = new List<string>();
               
              // Strng.add('Default (Test)');
              // feature.Profiles.add('Default');
               Strng  = opp.Profile__c.split(';');
               
               feature.Profiles =Strng ;
               
               icarejson.Features=feature;
                
               system.debug('Json file here'+icarejson);
               
               String strRequestParam =JSON.serialize(icarejson);
               
                String endPoint=''+config.End_Point_URL__c+''+opp.Site_Id__c+'';
               
              if(!Test.isRunningTest()){
               response=sendRequestWithJson(endPoint,'PUT',strRequestParam);
               }else{
               
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                response = sendRequestWithJson('http://api.salesforce.com/foo/bar','GET','internal');
              }
              
              if(response.getStatusCode()==201 || response.getStatusCode()==200){
               
              
                opp.Status__c='Provisioned';
                opp.Type_Of_Provisioning__c='Update';
                opp.Update_Email__c=true;
                update opp;
                }else{
                
                opp.Status__c='Process Error';
                update opp;
                 
                String userId = UserInfo.getUserId();
                
                Task t = new Task();
                t.OwnerId = userId;
                t.Subject = 'Process Error For iFirm Provisioning';
                t.Status = 'Open';
                t.Priority = 'High';
                t.WhatId = opp.id;
                insert t;
               
                }
               
             
               
               LogFiles__c log=new LogFiles__c ();
               log.Related_Account__c=opp.Account__r.Id;
               log.Log_Type__c='Replicate iFirm Url';
               log.Info__c='Json - '+'  '+ strRequestParam;
               log.Response__c=response.getbody();
               log.Info__c=log.Info__c+'\n' +'Response - '+response;
               log.Error_Code__c=response.getStatusCode();
               insert log;
               system.debug('Log Id of Replicate IfirmUrl'+log.Id);
            
         
          
          }catch(Exception ex){
          
                opp.Status__c='Process Error';
                update opp;
                
                String userId = UserInfo.getUserId();
                
                Task t = new Task();
                t.OwnerId = userId;
                t.Subject = 'Process Error For iFirm Provisioning';
                t.Status = 'Open';
                t.Priority = 'High';
                t.WhatId = opp.id;
                insert t;
                
              System.debug('Error:' + ex.getMessage() + 'LN:' + ex.getLineNumber()); 
          }
          
          
      }
    

      
      public static HttpResponse sendRequestWithJson(String EndPointUrl, String method,String Json){
      
       Configuration__c  config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='Icare configuration'];
              HttpRequest req = new HttpRequest();
                Http http = new Http();
                
          
                // Specify the required user name and password to access the endpoint
         // As well as the header and header information
     
         String username = config.UserName__c ;
         String password = config.Password__c;
      
         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);
         
                req.setMethod(method);
                req.setEndpoint(EndPointUrl);
                req.setbody(Json);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Content-Length','1024');
                req.setTimeout(120000);
                HttpResponse res = http.send(req);
          
          return res;    
      
      }
      
     
}