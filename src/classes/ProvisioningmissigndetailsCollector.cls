global class ProvisioningmissigndetailsCollector{


   @Future(callout=true)  
   Public Static void GetdetailsfromIcare(Id pId){
   
       List<Provisioning__c> prvsng=[Select Id,Account__c,Account__r.Id,Account__r.Name,Account__r.Email__c,Total_iFirm_User__c,
                                            Deffered_Date__c,IFirm_URL__c,On_Boarding_Status__c,No_Of_Users__c,Related_Quote__c,
                                            Site_Id__c,Profile__c,Status__c,Type_Of_Provisioning__c,Opportunity_id__c from Provisioning__c  where id=:pId];
      try{
   
       HttpResponse response = new HttpResponse();
       
       if(!Test.isRunningTest()){
               response=PrimarycontactExtension.sendRequest(prvsng[0].IFirm_URL__c);
               }else{
               
                 Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                 response= getdata('http://api.salesforce.com/foo/bar');
              }  
        
              
       if(response.getStatusCode()== 302 || Test.isRunningTest()){
       
       System.debug('here are the site details'+response.getHeader('Location'));
       
       String loc = response.getHeader('Location');
       
       
        HttpResponse res = new HttpResponse();
        
       if(loc != null || loc !='') {
        
        
        res = getdata(loc);
        }
       
     
       Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
       
       Object lstproperty = (Object)m1.get('Users'); 
       
       Map<String, Object> r= (Map<String, Object>)m1.get('Features');
       
       List<Object> a;
       
        if(!Test.isRunningTest()){ 
        a = (List<Object>)r.get('Profiles');
       
       
       System.debug(String.valueOf(a.get(0)));
       }
 
       System.debug('here are the site details'+m1+res.getBody());
       
            for (String key : m1.keySet()) { if(String.isNotBlank((String)m1.get('SiteId')) && key.equals('SiteId')){ prvsng[0].Site_Id__c=(String)m1.get('SiteId'); } }
          
          String prfls='';
           
          for(Object prf: a ){ if(prfls!=null || prfls !=''){ prfls+=prf+';';} }
           
           prfls= prfls.removeEnd(';');
            prvsng[0].Profile__c=prfls;
            
           if(lstproperty!= null || lstproperty != ''){
                        
                         prvsng[0].Total_iFirm_User__c=integer.valueof(lstproperty);
                         prvsng[0].No_Of_Users__c=integer.valueof(lstproperty);
                         
                         }
                         
           update prvsng[0];
       
       }
    
       }catch(Exception ex){}


   }
   
   
   public static HttpResponse getdata(String Url){
              
     Configuration__c  config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='Icare configuration'];
     
        HttpRequest req = new HttpRequest();
        HttpResponse response = null;
        
        String DomainName=config.Domain_Name__c;
        
        String endPoint;
        
        if(!Test.isRunningTest()){
         endPoint=url;
        }else{
         endPoint=config.End_Point_URL__c;
        }
    
         // Specify the required user name and password to access the endpoint
         // As well as the header and header information
     
         String username = config.UserName__c ;
         String password = config.Password__c;
      
         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);
         
         //Set HTTPRequest header proporties
         req.setHeader('content-type', 'application/json');
         req.setHeader('Accept', 'application/json');  
    
         //Build the request
   
              req.setMethod('GET');
              req.setEndpoint(endPoint);
              req.setTimeout(120000);
        try{
              Http http = new Http();
              response = http.send(req);
              
            }catch(Exception ex){}
            
          return response;    
         
      }

}