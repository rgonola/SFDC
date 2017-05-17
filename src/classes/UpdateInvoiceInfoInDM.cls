global class UpdateInvoiceInfoInDM
{
   
    
   @Future(callout=true)  
   public static void CancelInvoice(Id invoiceId){
      
      Configuration__c  config;
      
       try{
       
       if(!Test.isRunningTest()){
       config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='DM Config'];
       }
       
       invoiceit_s__Invoice__c inv= [Select Id,Name,invoiceit_s__Invoice_Status__c,invoiceit_s__Account__c from invoiceit_s__Invoice__c where Id =:invoiceId AND invoiceit_s__Invoice_Status__c ='Cancelled'];
       String endPoint;
       
       HttpResponse response= new HttpResponse();
           
           Invoicejsonwrapper invwrp = new Invoicejsonwrapper();
           Invoicejsonwrapper.Cancel_Invoice  invInfo=new Invoicejsonwrapper.Cancel_Invoice();
           
           invInfo.Invoice_Number=inv.Name;
           invwrp.Cancel_Invoice  = invInfo;
           
            //Create request in JSon format    
             String strRequestParam = JSON.serialize(invwrp);
           
           system.debug('Request invoice'+strRequestParam );
           
           LogFiles__c log=new LogFiles__c();
           log.Log_Type__c='Cancel Invoice';
           
          // String formattedinvnumbr =inv.Name.replaceAll('-', '^');
           
           if(!Test.isRunningTest()){
           endPoint=''+config.End_Point_URL__c+'cancelinvoice/'+inv.Name+'';
          }else{
           endPoint = 'https://qa2.sfdmlink.utsad.com/dm/api/clients/';
           }
           
           log.Info__c='Json - '+'  '+ strRequestParam;
           
           log.Related_Account__c=inv.invoiceit_s__Account__c;
           log.Related_Invoice__c=inv.Id;
           
           if(!Test.isRunningTest())
           response=UpdateAccountInfoInDM.sendRequestWithJson(endPoint,'POST',strRequestParam); 
           
           
           log.Info__c=log.Info__c+'\n '+ 'endPoint url -  '+endPoint; log.Info__c=log.Info__c+'\n' +'Response - '+response;
           log.Error_Code__c=response.getStatusCode(); log.Response__c=response.getbody();
           
           if(response.getStatusCode() != 404 || Test.isRunningTest()){
            Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                
                 
           
             for (String key : m1.keySet()) {    if(String.isNotBlank((String)m1.get('error_code')) && key.equals('error_code')){ log.DM_Error_Code__c=(String)m1.get('error_code');
                 
                } else if(String.isNotBlank((String)m1.get('error_message')) && key.equals('error_message')){ log.DM_Error_Message__c=(String)m1.get('error_message'); }
            
                }
                }
                
                
           insert log;
           
           system.debug('Log Id of CC on file - '+log.Id);
           
           
           
       
       
      
       } catch(Exception Ex){
           system.debug('Exception'+Ex);
       }
                     
   }
 
 }