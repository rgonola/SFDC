@RestResource(urlMapping='/Replicateaccount/*')  
 global with sharing class N2SAccount{  
  /*  
   HttpPost method is used to capture a HttpPost request has been sent to our rest apex class.  
   Used to retrieve data coming in the request body and performing corressponding actions  
  */  
  @HttpPost  
   global static S2SResponse.Result doPost() {  
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
     
      System.debug('Request here is'+body.toString());
      
      Account a= new Account(); 
      Contact c = new Contact();
      Opportunity op= new Opportunity();
      c.Is_Primary__c=true;
     //Deserializes the input JSON string into an Account object  
     try{
     Map<String, Object> r = (Map<String, Object>)JSON.deserializeUntyped(body.toString());
                
                Map<String, Object> accObj= (Map<String, Object>)r.get('Customer');
                Map<String, Object> cntst= (Map<String, Object>)r.get('Contacts');
                Map<String, Object> opp= (Map<String, Object>)r.get('Opportunity');
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
                   
                }else if(String.isNotBlank((String)accObj.get('ShippingCity')) && key.equals('ShippingCity')){
                   
                   a.ShippingCity=(String)accObj.get('ShippingCity');
                   
                }else if(String.isNotBlank((String)accObj.get('ShippingState')) && key.equals('ShippingState')){
                   
                   a.ShippingState=(String)accObj.get('ShippingState');
                   
                }else if(String.isNotBlank((String)accObj.get('ShippingZip')) && key.equals('ShippingZip')){
                   
                   a.ShippingPostalcode=(String)accObj.get('ShippingZip');
                   
                }else if(String.isNotBlank((String)accObj.get('Shippingcountry')) && key.equals('Shippingcountry')){
                   
                   a.Shippingcountry=(String)accObj.get('Shippingcountry');
                   
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
            
            for (String p : opp.keySet()) {
                  
                  
           
                if(String.isNotBlank((String)opp.get('OppRecordId')) && p.equals('OppRecordId')){
                
                  op.TAA_Opportunity_Record_ID__c=(String)opp.get('OppRecordId');
                 
                  
                 }else if(String.isNotBlank((String)opp.get('AccountID')) && p.equals('AccountID')){
                
                  op.TAA_Account_Record_ID__c=(String)opp.get('AccountID');
                  
                  
                 }else if(String.isNotBlank((String)opp.get('PrimaryContact')) && p.equals('PrimaryContact')){
                   
                   op.TAA_Primary_Contact_for_Proposal__c =(String)opp.get('PrimaryContact');
                   
                }else if(String.isNotBlank((String)opp.get('Type')) && p.equals('Type')){
                   
                   op.Type=(String)opp.get('Type');
                   
                }else if(String.isNotBlank((String)opp.get('Amount')) && p.equals('Amount')){
                   
                   op.Amount=integer.valueof((String)opp.get('Amount'));
                   
                }else if(String.isNotBlank((String)opp.get('StageName')) && p.equals('StageName')){
                   
                   op.StageName=(String)opp.get('StageName');
                   
                }else if(String.isNotBlank((String)opp.get('ProductCategory')) && p.equals('ProductCategory')){
                   
                   op.Product_Category__c=(String)opp.get('ProductCategory');
                   
                }else if(String.isNotBlank((String)opp.get('ProductSubCategory')) && p.equals('ProductSubCategory')){
                   
                   op.Product_Sub_Category__c=(String)opp.get('ProductSubCategory');
                   
                }else if(String.isNotBlank((String)opp.get('ForecastType')) && p.equals('ForecastType')){
                   
                   op.Forecast_Type__c=(String)opp.get('ForecastType');
                   
                }else if(String.isNotBlank((String)opp.get('CloseDate')) && p.equals('CloseDate')){
                   
                   op.CloseDate=Date.valueof((String)opp.get('CloseDate'));
                   
                }else if(String.isNotBlank((String)opp.get('Name')) && p.equals('Name')){
                   
                   op.Name=(String)opp.get('Name');
                   
                }else if(String.isNotBlank((String)opp.get('SFDCOpportunity')) && p.equals('SFDCOpportunity')){
                   
                   op.X1Force_Opportunity__c=(String)opp.get('SFDCOpportunity ');
                   
                }else if(String.isNotBlank((String)opp.get('OppOwner')) && p.equals('OppOwner')){
                   
                   op.TAA_Opportunity_Owner_ID__c=(String)opp.get('OppOwner');
                   
                }
                   
                   
                   op.AccountId=a.id;
                   
                
                   
                   op.Contact__c=c.id;
                   
                
                
             } 
             insert op;
     
      S2SResponse jsonResponse=new S2SResponse();
             S2SResponse.Result result= new S2SResponse.Result();
                result.AccountId=a.id;
                result.ContactID=c.id;
                result.OppId=op.id;
                result.Response_Message='Success';
                  
              jsonResponse.Result=result;
             
           return jsonResponse.Result;
        }else{
        
        
        
         for (String p : opp.keySet()) {
                  
                  
           
                if(String.isNotBlank((String)opp.get('OppRecordId')) && p.equals('OppRecordId')){
                
                  op.TAA_Opportunity_Record_ID__c=(String)opp.get('OppRecordId');
                 
                  
                 }else if(String.isNotBlank((String)opp.get('AccountID')) && p.equals('AccountID')){
                
                  op.TAA_Account_Record_ID__c=(String)opp.get('AccountID');
                  
                  
                 }else if(String.isNotBlank((String)opp.get('PrimaryContact')) && p.equals('PrimaryContact')){
                   
                   op.TAA_Primary_Contact_for_Proposal__c =(String)opp.get('PrimaryContact');
                   
                }else if(String.isNotBlank((String)opp.get('Type')) && p.equals('Type')){
                   
                   op.Type=(String)opp.get('Type');
                   
                }else if(String.isNotBlank((String)opp.get('Amount')) && p.equals('Amount')){
                   
                   op.Amount=integer.valueof((String)opp.get('Amount'));
                   
                }else if(String.isNotBlank((String)opp.get('StageName')) && p.equals('StageName')){
                   
                   op.StageName=(String)opp.get('StageName');
                   
                }else if(String.isNotBlank((String)opp.get('ProductCategory')) && p.equals('ProductCategory')){
                   
                   op.Product_Category__c=(String)opp.get('ProductCategory');
                   
                }else if(String.isNotBlank((String)opp.get('ProductSubCategory')) && p.equals('ProductSubCategory')){
                   
                   op.Product_Sub_Category__c=(String)opp.get('ProductSubCategory');
                   
                }else if(String.isNotBlank((String)opp.get('ForecastType')) && p.equals('ForecastType')){
                   
                   op.Forecast_Type__c=(String)opp.get('ForecastType');
                   
                }else if(String.isNotBlank((String)opp.get('CloseDate')) && p.equals('CloseDate')){
                   
                   op.CloseDate=Date.valueof((String)opp.get('CloseDate'));
                   
                }else if(String.isNotBlank((String)opp.get('Name')) && p.equals('Name')){
                   
                   op.Name=(String)opp.get('Name');
                   
                }else if(String.isNotBlank((String)opp.get('SFDCOpportunity')) && p.equals('SFDCOpportunity')){
                   
                   op.X1Force_Opportunity__c=(String)opp.get('SFDCOpportunity ');
                   
                }else if(String.isNotBlank((String)opp.get('OppOwner')) && p.equals('OppOwner')){
                   
                   op.TAA_Opportunity_Owner_ID__c=(String)opp.get('OppOwner');
                   
                }
                   
                   
                   op.AccountId=acc[0].id;
                   
                
                   
                   op.Contact__c=ct[0].id;
                   
                
                
             } 
             insert op;
     
      S2SResponse jsonResponse=new S2SResponse();
             S2SResponse.Result result= new S2SResponse.Result();
                result.AccountId=a.id;
                result.ContactID=c.id;
                result.OppId=op.id;
                result.Response_Message='Success';
                  
              jsonResponse.Result=result;
             
           return jsonResponse.Result;
        
        
        
        
        
        
        }
    
   }catch(Exception ex){
   
    String Msg='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
    
     S2SResponse jsonResponse=new S2SResponse ();
             S2SResponse.Result result= new S2SResponse.Result();
                result.AccountId='';
                result.ContactID='';
                result.Response_Message=Msg;
                  
              jsonResponse.Result=result;
             
           return jsonResponse.Result;
   }
   
   
 }
 
 }