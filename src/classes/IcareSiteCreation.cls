global class IcareSiteCreation
{

      webservice Static Id replicateIfirmUrlbutn(Id provid,boolean isnew){
      Provisioning__c opp;
      try{
       opp=[Select Account__c,Account__r.Id,Account__r.Name,Profile__c,Account__r.Email__c,Total_iFirm_User__c,Id,Deffered_Date__c,IFirm_URL__c,On_Boarding_Status__c,No_Of_Users__c,Related_Quote__c,Site_Id__c,
                                  Status__c,Type_Of_Provisioning__c,Opportunity_id__c from Provisioning__c  where id=:provid ORDER BY Createddate DESC Limit 1];
     
          
              
              HttpResponse resp= new HttpResponse();
              
              if(!Test.isRunningTest()){
                resp=PrimarycontactExtension.sendRequest(opp.IFirm_URL__c);
               }else{
               
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                resp= sendRequestWithJson('http://api.salesforce.com/foo/bar','GET','internal');
              }
             
            
             if(resp.getStatusCode()==404 || isnew ==False){
                 
         
            
               HttpResponse response= new HttpResponse();
               
               iFirmUrlJson icarejson=new iFirmUrlJson();
              
               iFirmUrlJson.Features feature=new iFirmUrlJson.Features();
               
               
               
               icarejson.Sitename=opp.IFirm_URL__c;
               //icarejson.WebCluster='us-test';
               icarejson.WebCluster='us-prod01';
               icarejson.SiteDataType='SFMBLANK';
               icarejson.Stream='LIVE';
               icarejson.DomainName='cchifirm.us';
               
               icarejson.LicenceName=opp.Account__r.Name;
               icarejson.Users=String.ValueOf(opp.Total_iFirm_User__c);
               icarejson.CountryCode='US';
               icarejson.Timezone='America/New_York';
               icarejson.ResetUserEmail=opp.Account__r.Email__c;
               //icarejson.ResetUserPassword='Password12';
               icarejson.SiteType='iFirm';
               
              List<string> Strng = new List<string>();
               
               //Strng.add('Default (Test)');
              Strng  = opp.Profile__c.split(';');
               
               feature.Profiles =Strng ;
               
               icarejson.Features=feature;
                
               system.debug('Json file here'+icarejson);
               
               String strRequestParam =JSON.serialize(icarejson);
               
               
               
               if(!Test.isRunningTest()){
                response=sendRequestWithJson(null,'POST',strRequestParam);
               }else{
               
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                resp= sendRequestWithJson('http://api.salesforce.com/foo/bar','GET','internal');
              }
               
              
              if(response.getStatusCode()==201 || response.getStatusCode()==200){
               
              Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                
                  for (String key : m1.keySet()) {
           
                if(String.isNotBlank((String)m1.get('SiteId')) && key.equals('SiteId')){
                
                 opp.Site_Id__c=(String)m1.get('SiteId');
                 opp.Status__c='Provisioned';
                 opp.Send_Email__c=true;
                 
                 
                  System.debug('Site id here from the response'+(String)m1.get('SiteId'));
                 }
                 
                 else if(String.isNotBlank((String)m1.get('InitialPassword')) && key.equals('InitialPassword')){
                   System.debug('Site password for the response'+(String)m1.get('InitialPassword'));
                   opp.Temporary_Password__c=(String)m1.get('InitialPassword');
                }
            
                }
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
            
          
          }else{
          
           Provisioning__c   p=[Select Account__c,Account__r.Id,Account__r.Name,Profile__c,Account__r.Email__c,Total_iFirm_User__c,Id,Deffered_Date__c,IFirm_URL__c,On_Boarding_Status__c,No_Of_Users__c,Related_Quote__c,Site_Id__c,
                                  Status__c,Type_Of_Provisioning__c,Opportunity_id__c from Provisioning__c  where id=:provid ORDER BY Createddate DESC Limit 1];
      
                p.Status__c='Process Error';
                update p;
                
                String userId = UserInfo.getUserId();
                
                Task t = new Task();
                t.OwnerId = userId;
                t.Subject = 'Duplicate Url found Process Error For iFirm Provisioning';
                t.Status = 'Open';
                t.Priority = 'High';
                t.WhatId = p.id;
                insert t;
          
          
          }
          
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
          
          Return opp.id;
      }
    
      public void replicateIfirmUrl(Id quteid,Id Accuntid){
        
        Provisioning__c opp;
        
        try{
      opp=[Select Account__c,Account__r.Id,Account__r.Name,Account__r.Email__c,Profile__c,Total_iFirm_User__c,Id,Deffered_Date__c,IFirm_URL__c,On_Boarding_Status__c,No_Of_Users__c,Related_Quote__c,Site_Id__c,
                                  Status__c,Type_Of_Provisioning__c,Opportunity_id__c from Provisioning__c  where Related_Quote__c=:quteid AND Account__c=:Accuntid AND Status__c='Order Pending' ORDER BY Createddate DESC Limit 1];
      
      
               HttpResponse response= new HttpResponse();
               
               iFirmUrlJson icarejson=new iFirmUrlJson();
              
               iFirmUrlJson.Features feature=new iFirmUrlJson.Features();
              
               icarejson.Sitename=opp.IFirm_URL__c;
               //icarejson.WebCluster='us-test';
               icarejson.WebCluster='us-prod01';
               icarejson.SiteDataType='SFMBLANK';
               icarejson.Stream='LIVE';
               icarejson.DomainName='cchifirm.us';
               
               icarejson.LicenceName=opp.Account__r.Name;
               icarejson.Users=String.ValueOf(opp.Total_iFirm_User__c);
               icarejson.CountryCode='US';
               icarejson.Timezone='America/New_York';
               icarejson.ResetUserEmail=opp.Account__r.Email__c;
               //icarejson.ResetUserPassword='Password12';
               icarejson.SiteType='iFirm';
               
                List<string> Strng = new List<string>();
               
               //Strng.add('Default (Test)');
               Strng  = opp.Profile__c.split(';');
               feature.Profiles=Strng ;
               
               icarejson.Features=feature;
               
               system.debug('Json file here'+icarejson);
               
               String strRequestParam =JSON.serialize(icarejson);
               
             
              
              if(!Test.isRunningTest()){
                response=sendRequestWithJson(null,'POST',strRequestParam);
               }else{
               
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                response= sendRequestWithJson('http://api.salesforce.com/foo/bar','GET','internal');
              }
               
               
               if(response.getStatusCode()==201){
                
                
                  Map<String, Object> m= (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                
                  for (String key : m.keySet()) {
           
                if(String.isNotBlank((String)m.get('SiteId')) && key.equals('SiteId')){
                
                 opp.Site_Id__c=(String)m.get('SiteId');
                 opp.Status__c='Provisioned';
                  opp.Send_Email__c=true;
                 
                  System.debug('Site id here from the response'+(String)m.get('SiteId'));
                 }
                 
                 else if(String.isNotBlank((String)m.get('InitialPassword')) && key.equals('InitialPassword')){
                   System.debug('Site password for the response'+(String)m.get('InitialPassword'));
                   opp.Temporary_Password__c=(String)m.get('InitialPassword');
                }
            
                }
                update opp;
               }else {
               
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
          
         List<Provisioning__c>   p=[Select Account__c,Account__r.Id,Account__r.Name,Account__r.Email__c,Profile__c,Total_iFirm_User__c,Id,Deffered_Date__c,IFirm_URL__c,On_Boarding_Status__c,No_Of_Users__c,Related_Quote__c,Site_Id__c,
                                  Status__c,Type_Of_Provisioning__c,Opportunity_id__c from Provisioning__c  where Related_Quote__c=:quteid AND Account__c=:Accuntid AND Status__c='Order Pending' ORDER BY Createddate DESC Limit 1];
                
                if(p.size()>0){
                p[0].Status__c='Process Error';
                update p[0];
                }
                
                String userId = UserInfo.getUserId();
                
                Task t = new Task();
                t.OwnerId = userId;
                t.Subject = 'Process Error For iFirm Provisioning';
                t.Status = 'Open';
                t.Priority = 'High';
                if(p.size()>0){
                t.WhatId = p[0].id;
                }
                insert t;
                
              System.debug('Error:' + ex.getMessage() + 'LN:' + ex.getLineNumber()); 
          }
          
          
      }
      
      public static HttpResponse sendRequestWithJson(String EndPointUrl,String method,String Json){
           
            Configuration__c  config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='Icare configuration'];
     
                HttpRequest req = new HttpRequest();
                Http http = new Http();
               
        
        String EndUrl=config.End_Point_URL__c;
                // Specify the required user name and password to access the endpoint
         // As well as the header and header information
     
         String username = config.UserName__c ;
         String password = config.Password__c;
      
         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);
         
                req.setMethod(method);
                req.setEndpoint(EndUrl);
                req.setbody(Json);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Content-Length','1024');
                req.setTimeout(120000);
                HttpResponse res = http.send(req);
          
          return res;    
      
      }

}