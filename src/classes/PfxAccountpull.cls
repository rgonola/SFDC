@RestResource(urlMapping='/PFXPromotion/*')  
 global with sharing class PfxAccountpull{  
  /*  
   HttpPost method is used to capture a HttpPost request has been sent to our rest apex class.  
   Used to retrieve data coming in the request body and performing corressponding actions  
  */  
  @HttpPost  
   global static PfxAccountpullResponse.Result  doPost() {  
     /*  
       RestContext Class - Allows us to access the RestRequest and RestResponse objects in your Apex REST methods.   
       RestRequest class - Allows us to pass request data into our Apex RESTful Web service method.  
       RestResponse class - Allows us to pass or send back response data from our Apex RESTful web service method  
     */  
     //Returns the RestRequest object for our Apex REST method.  
     RestRequest request = RestContext.request;  
     //Returns the RestResponse for our Apex REST method.  
     RestResponse response = RestContext.response;  
     
     //Access the request body with input data coming in the JSON format  
     Blob body = request .requestBody;  
     
      //System.debug('Request here is'+body.toString());
      
      Account a= new Account(); 
      Contact c = new Contact();
      opportunity   opp;
      SBQQ__Quote__c newquote;
      
      a.Has_PFX_Promotion__c=true;
      c.Is_Primary__c=true;
     //Deserializes the input JSON string into an Account object  
     try{
     Map<String, Object> r = (Map<String, Object>)JSON.deserializeUntyped(body.toString());
                
                Map<String, Object> accObj= (Map<String, Object>)r.get('Customer');
                Map<String, Object> cntst= (Map<String, Object>)r.get('Contacts');
                Set<String> oneforce= new Set<String>();
                 
                 for (String key1 : accObj.keySet()) {
                 
                 if(String.isNotBlank((String)accObj.get('AccoutNumber')) && key1.equals('AccoutNumber')){
                   
                   oneforce.add((String)accObj.get('AccoutNumber'));
                   
                   
                }
                 
                 }
                
                List<Contact> ct;
                
                List<Account> acc =[Select Id,Primary_Contact_Name__c,BillingStreet,BillingCity,BillingState,Billingpostalcode,BillingCountry,ShippingStreet,ShippingCity,ShippingState,Shippingpostalcode,ShippingCountry From Account Where X1Force_Account__c IN:oneforce];
                if(acc.size()>0){
                 ct =[Select Id,Name From Contact Where AccountID=:acc[0].id];
                }
                 if(acc.Size()==0){
                  for (String key : accObj.keySet()) {
                  
                   System.debug(String.valueOf(key));
           
                if(String.isNotBlank((String)accObj.get('Name')) && key.equals('Name')){
                
                  a.Name=(String)accObj.get('Name');
                  
                 }else if(String.isNotBlank((String)accObj.get('Phone')) && key.equals('Phone')){
                   
                   a.Phone =(String)accObj.get('Phone');
                   
                }else if(String.isNotBlank((String)accObj.get('AccoutNumber')) && key.equals('AccoutNumber')){
                   
                   a.X1Force_Account__c=(String)accObj.get('AccoutNumber');
                   
                   
                }else if(String.isNotBlank((String)accObj.get('AccountRecordId')) && key.equals('AccountRecordId')){
                   
                   a.TAA_Account_Record_ID__c=(String)accObj.get('AccountRecordId');
                   c.TAA_Account_Record_ID__c=(String)accObj.get('AccountRecordId');
                   
                }else if(String.isNotBlank((String)accObj.get('Segment')) && key.equals('Segment')){
                   
                   a.Segment__c=(String)accObj.get('Segment');
                   
                }else if(String.isNotBlank((String)accObj.get('subsegment')) && key.equals('subsegment')){
                   
                   a.Subsegment__c=(String)accObj.get('subsegment');
                   
                }else if(String.isNotBlank((String)accObj.get('ShippingAdress')) && key.equals('ShippingAdress')){
                   
                   a.ShippingStreet=(String)accObj.get('ShippingAdress');
                   c.MailingStreet=(String)accObj.get('ShippingAdress');
                }else if(String.isNotBlank((String)accObj.get('ShippingCity')) && key.equals('ShippingCity')){
                   
                   a.ShippingCity=(String)accObj.get('ShippingCity');
                   c.MailingCity=(String)accObj.get('ShippingCity');
                   
                }else if(String.isNotBlank((String)accObj.get('ShippingState')) && key.equals('ShippingState')){
                   
                   a.ShippingState=(String)accObj.get('ShippingState');
                   c.MailingState=(String)accObj.get('ShippingState');
                   
                }else if(String.isNotBlank((String)accObj.get('ShippingZip')) && key.equals('ShippingZip')){
                   
                   a.ShippingPostalcode=(String)accObj.get('ShippingZip');
                   c.MailingPostalcode=(String)accObj.get('ShippingZip');
                   
                }else if(String.isNotBlank((String)accObj.get('Shippingcountry')) && key.equals('Shippingcountry')){
                   
                   a.Shippingcountry=(String)accObj.get('Shippingcountry');
                   c.Mailingcountry=(String)accObj.get('Shippingcountry');
                   
                }else if(String.isNotBlank((String)accObj.get('BillingAdress')) && key.equals('BillingAdress')){
                   
                   a.BillingStreet=(String)accObj.get('BillingAdress');
                   
                }else if(String.isNotBlank((String)accObj.get('BillingCity')) && key.equals('BillingCity')){
                   
                   a.BillingCity=(String)accObj.get('BillingCity');
                   
                }else if(String.isNotBlank((String)accObj.get('BillingState')) && key.equals('BillingState')){
                   
                   a.BillingState=(String)accObj.get('BillingState');
                   
                }else if(String.isNotBlank((String)accObj.get('BillingZip')) && key.equals('BillingZip')){
                   
                   a.BillingPostalcode=(String)accObj.get('BillingZip');
                   
                }else if(String.isNotBlank((String)accObj.get('Billingcountry')) && key.equals('Billingcountry')){
                   
                   a.Billingcountry=(String)accObj.get('Billingcountry');
                   
                }
            
                }
      
      system.debug('Account info'+a);
      
     insert a;
     
     String id = a.id;
            
            
            for (String cnt : cntst.keySet()) {
                  
                  
           
                if(String.isNotBlank((String)cntst.get('FirstName')) && cnt.equals('FirstName')){
                
                  c.FirstName=(String)cntst.get('FirstName');
                 
                  
                 }else if(String.isNotBlank((String)cntst.get('LastName')) && cnt.equals('LastName')){
                
                  c.LastName=(String)cntst.get('LastName');
                  
                  
                 }else if(String.isNotBlank((String)cntst.get('Phone')) && cnt.equals('Phone')){
                   
                   c.Phone =(String)cntst.get('Phone');
                   
                }else if(String.isNotBlank((String)cntst.get('Email')) && cnt.equals('Email')){
                   
                   c.Email=(String)cntst.get('Email');
                   
                }else if(String.isNotBlank((String)cntst.get('ContactNumber')) && cnt.equals('ContactNumber')){
                   
                   c.X1Force_Contact__c=(String)cntst.get('ContactNumber');
                   
                }else if(String.isNotBlank((String)cntst.get('ContactRecordId')) && cnt.equals('ContactRecordId')){
                   
                   c.TAA_Contact_Record_ID__c=(String)cntst.get('ContactRecordId');
                   
                }
                
             }   
             
             c.AccountId=a.id;
             insert c;
            List<PriceBook2>  pbk;
           if(!Test.IsRunningTest()){
              pbk =[Select Id,Name,IsActive From PriceBook2 Where Name=:Label.Renewal_Pricebook];
           
              
             }else{
             
              pbk =[Select Id,Name,IsActive From PriceBook2 ];
           
             
             
             }
             
             opp = new Opportunity(Name='PFX Promotion',AccountID = a.id,CloseDate = Date.today().addmonths(12),
                              StageName ='Onboard', Contact__c=c.id,Product_Category__c='Small Firm Software',SBQQ__QuotePricebookId__c=pbk[0].id,Type = 'New Sale To New Customer',Forecast_Type__c='Closed',Product_Sub_Category__c='Tax'); 
                             
             insert opp; 
    
    
    
            //Create Quote 
            
            newquote = new SBQQ__Quote__c (SBQQ__Type__c ='Quote',SBQQ__Status__c='Invoiced',Is_PFX_Promotion__c=true,SBQQ__PrimaryContact__c=c.id,SBQQ__Primary__c = true,SBQQ__Opportunity2__c=opp.id,
                                                          SBQQ__StartDate__c=date.ValueOf(Label.Batch_Quotes_Start_Date), SBQQ__BillingName__c=a.Primary_Contact_Name__c,SBQQ__BillingStreet__c=a.BillingStreet,SBQQ__BillingCity__c=a.BillingCity,
                                                          SBQQ__BillingState__c=a.BillingState,SBQQ__BillingPostalCode__c=a.Billingpostalcode,SBQQ__BillingCountry__c = a.BillingCountry,Origin_Source__c = 'REP',SBQQ__Account__c=a.id,
                                                          SBQQ__ShippingName__c=a.Primary_Contact_Name__c,SBQQ__ShippingStreet__c=a.ShippingStreet,SBQQ__ShippingCity__c=a.ShippingCity,SBQQ__ShippingState__c=a.ShippingState,
                                                          SBQQ__ShippingPostalCode__c=a.Shippingpostalcode,SBQQ__ShippingCountry__c = a.ShippingCountry,SBQQ__PricebookId__c =pbk[0].id,SBQQ__PriceBook__c =pbk[0].id);
                
        
                insert newquote ;
                
                
               PfxOrderUtil.createorder(a.id,opp.id,newquote.id);
             
             PfxAccountpullResponse jsonResponse=new PfxAccountpullResponse();
             PfxAccountpullResponse.Result result= new PfxAccountpullResponse.Result();
                result.AccountId=a.id;
                result.ContactID=c.id;
                result.Response_Message='Success';
                  
              jsonResponse.Result=result;
             
           return jsonResponse.Result;
              
             }else{
             
               List<PriceBook2>  pbk;
           if(!Test.IsRunningTest()){
              pbk =[Select Id,Name,IsActive From PriceBook2 Where Name=:Label.Renewal_Pricebook];
           
              
             }else{
             
              pbk =[Select Id,Name,IsActive From PriceBook2 ];
           
             
             
             }
            opp = new Opportunity(Name='PFX Promotion',AccountID = acc[0].id,CloseDate = Date.today().addmonths(12),
                              StageName ='Onboard', Contact__c=ct[0].id,Product_Category__c='Small Firm Software',SBQQ__QuotePricebookId__c=pbk[0].id,Type = 'New Sale To New Customer',Forecast_Type__c='Closed',Product_Sub_Category__c='Tax'); 
                             
             insert opp; 
    
    
    
            //Create Quote 
            
            newquote = new SBQQ__Quote__c (SBQQ__Type__c ='Quote',SBQQ__Status__c='Invoiced',Is_PFX_Promotion__c=true,SBQQ__PrimaryContact__c=ct[0].id,SBQQ__Primary__c = true,SBQQ__Opportunity2__c=opp.id,
                                                          SBQQ__StartDate__c=date.ValueOf(Label.Batch_Quotes_Start_Date), SBQQ__BillingName__c=acc[0].Primary_Contact_Name__c,SBQQ__BillingStreet__c=acc[0].BillingStreet,SBQQ__BillingCity__c=acc[0].BillingCity,
                                                          SBQQ__BillingState__c=acc[0].BillingState,SBQQ__BillingPostalCode__c=acc[0].Billingpostalcode,SBQQ__BillingCountry__c = acc[0].BillingCountry,Origin_Source__c = 'REP',SBQQ__Account__c=acc[0].id,
                                                          SBQQ__ShippingName__c=acc[0].Primary_Contact_Name__c,SBQQ__ShippingStreet__c=acc[0].ShippingStreet,SBQQ__ShippingCity__c=acc[0].ShippingCity,SBQQ__ShippingState__c=acc[0].ShippingState,
                                                          SBQQ__ShippingPostalCode__c=acc[0].Shippingpostalcode,SBQQ__ShippingCountry__c = acc[0].ShippingCountry,SBQQ__PricebookId__c =pbk[0].id,SBQQ__PriceBook__c =pbk[0].id);
                
        
                insert newquote ;
             
             
               PfxOrderUtil.createorder(acc[0].id,opp.id,newquote.id);
             
             PfxAccountpullResponse jsonResponse=new PfxAccountpullResponse();
             PfxAccountpullResponse.Result result= new PfxAccountpullResponse.Result();
                result.AccountId=acc[0].id;
                result.ContactID=ct[0].id;
                result.Response_Message='Success';
                  
              jsonResponse.Result=result;
             
           return jsonResponse.Result;
           
             }  
             
           
    
   }catch(Exception ex){
   
    String Msg='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
    
     PfxAccountpullResponse jsonResponse=new PfxAccountpullResponse();
             PfxAccountpullResponse.Result result= new PfxAccountpullResponse.Result();
                result.AccountId='';
                result.ContactID='';
                result.Response_Message=Msg;
                  
              jsonResponse.Result=result;
             
           return jsonResponse.Result;
   }
   
   
 }
 
 }