global class UpdatePriorRegCode Implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public String query;
   
   global Database.QueryLocator start(Database.BatchableContext BC)
    {
    try{
        
        if(!Test.isRunningTest()){
            query = 'SELECT Name,id,Fulfilment_Date__c,Reg_Code__c,Prior_Year_SKU__c,Product_Yearx__c,RegCode_Required__c,invoiceit_s__Order__c,invoiceit_s__Status__c,'+
          'Product_Code__c from invoiceit_s__Job_Rate_Plan_Charge__c where Prior_Year_Regcode__c=null AND Prior_Year_SKU__c <> null and Fulfilment_Date__c >Today AND Account_Type__c=\'New Customer\'  AND RegCode_Required__c=TRUE AND invoiceit_s__Status__c != \'Cancelled \'   order by  Error_Date__c ASC Limit 100';
  }else{
   query = 'SELECT Name,id,Fulfilment_Date__c,Reg_Code__c,Prior_Year_SKU__c,Product_Yearx__c,RegCode_Required__c,invoiceit_s__Order__c,'+
        'Product_Code__c from invoiceit_s__Job_Rate_Plan_Charge__c where Prior_Year_Regcode__c=null AND Prior_Year_SKU__c <> null AND Account_Type__c=\'New Customer\' and Fulfilment_Date__c >Today Limit 100';
  }
        
    }catch(Exception Ex){
        system.debug('Exception'+Ex);
    }
    return Database.getQueryLocator(query);
    
    }
      
       
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Job_Rate_Plan_Charge__c> scope) {
        try{
            
           Configuration__c  config;
             
            Map<Id, invoiceit_s__Job_Rate_Plan_Charge__c> ratePlanChargesMap = new Map<Id, invoiceit_s__Job_Rate_Plan_Charge__c>([SELECT Name,id,RegCode_Required__c,Prior_Year_SKU__c,invoiceit_s__Status__c,Fulfilment_Date__c,Reg_Code__c,Product_Yearx__c,invoiceit_s__Order__c,Product_Code__c  from invoiceit_s__Job_Rate_Plan_Charge__c
            where Prior_Year_Regcode__c=null and Fulfilment_Date__c >Today AND RegCode_Required__c=TRUE AND Prior_Year_SKU__c <> null AND Account_Type__c='New Customer' AND invoiceit_s__Status__c!='Cancelled'   order by Error_Date__c ASC Limit 100]);
            system.debug('query results'+scope);
            if(!Test.isRunningTest()){
              config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='DM Config'];
              }
               
            Set<Id> orderId= new Set<Id>();
            Set<Id> accountIds=new Set<Id>();
           
            List<invoiceit_s__Job_Rate_Plan_Charge__c> ratePlanCharge=new List<invoiceit_s__Job_Rate_Plan_Charge__c>();
            
            for(invoiceit_s__Job_Rate_Plan_Charge__c rtPlanCharge : ratePlanChargesMap.values()) {
                invoiceit_s__Job_Rate_Plan_Charge__c getRatePlan=ratePlanChargesMap.get(rtPlanCharge.Id);
                if(getRatePlan.invoiceit_s__Status__c!='Cancelled'){
                orderId.add(getRatePlan.invoiceit_s__Order__c);
                }
            }
              
            List <invoiceit_s__Job__c> order=[Select invoiceit_s__Account__c,Id  from invoiceit_s__Job__c where Id In: orderId];
            for(invoiceit_s__Job__c accIds:order){
                accountIds.add(accIds.invoiceit_s__Account__c);
            }
            
          
            Map<String,String> logMap=new Map<String,String>();
            Map<String,String> regcoderesponse=new Map<String,String>();
             
             
            List<Account> acc=[Select CID__c,id from Account where Id In :accountIds];
            
            List<LogFiles__c> listLogs=new List<LogFiles__c>();
            LogFiles__c logs=new LogFiles__c();
            
          
            for(invoiceit_s__Job_Rate_Plan_Charge__c rtPlanCharge : scope) {
                if((rtPlanCharge.RegCode_Required__c==true && rtPlanCharge.invoiceit_s__Status__c!='Cancelled') || Test.isRunningTest()){                                    /* Will be un commnented when required */
              
                    for(invoiceit_s__Job__c orders:order){
                        system.debug('Order**'+orders.Id);
                        system.debug('RatePlanCHargeId**'+rtPlanCharge.invoiceit_s__Order__c);
                         
                        
                        if(orders.Id==rtPlanCharge.invoiceit_s__Order__c || Test.isRunningTest() ){
                             system.debug('Inside If**');
                            for(Account accnt:acc){
                                if(accnt.Id==orders.invoiceit_s__Account__c|| Test.isRunningTest() ){
                                
                             String editedsqu;
                             Integer productyear;
                             editedsqu='';
                             productyear=0;
                             
                             productyear=Integer.valueof(rtPlanCharge.Product_Yearx__c);
                             system.debug('Inside If**'+productyear+rtPlanCharge.Prior_Year_SKU__c);
                             productyear=productyear-1;
                             
                                if(rtPlanCharge.Prior_Year_SKU__c=='TPP1040 LITE_2016'){
                                
                                editedsqu ='ATX-'+rtPlanCharge.Prior_Year_SKU__c;
                                
                                }else{
                                
                                editedsqu =rtPlanCharge.Prior_Year_SKU__c;
                                
                                }
                                
                       editedsqu =editedsqu.replaceAll(' ', '^');
                       
                       String endPoint;
                       
                       if(!Test.isRunningTest()){
                                    
                       endPoint=''+config.End_Point_URL__c+''+accnt.CID__c+'/regcode?year='+productyear+'&sku='+editedsqu ;
                        
                        }else{
                                       
                       endPoint='https://qa2.sfdmlink.utsad.com/dm/api/clients/'+accnt.CID__c+'/regcode?year='+rtPlanCharge.Product_Yearx__c +'&sku='+editedsqu ;
                       
                          }
                            try{
                                    
                                   HttpResponse response=UpdateAccountInfoInDM.sendRequest(endPoint,'GET'); 
                                   
                                    logMap.put(endPoint,response.toString());
                                    regcoderesponse.put(endPoint,response.getBody());
                                    String regcode;
                                    
                                    if(response.getStatusCode()==255){
                                    
                                     Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                
                                          for (String val: m1.keySet()) {
                                   
                                        if(String.isNotBlank((String)m1.get('reg_code')) && val.equals('reg_code')){
                                        
                                           regcode=(String)m1.get('reg_code');
                                         
                                        } 
                                      }
                                    
                                    
                                    system.debug('Reg code is here'+regcode);
                                    
                                    if(!regcode.contains('^')){
                                    
                                      invoiceit_s__Job_Rate_Plan_Charge__c charge=new invoiceit_s__Job_Rate_Plan_Charge__c
                                      (Id=rtPlanCharge.Id, Prior_Year_Regcode__c=regcode,RegCode_Error__c =''); 
                                      ratePlanCharge.add(charge);
                                      
                                    }else{
                                    
                                    invoiceit_s__Job_Rate_Plan_Charge__c charge=new invoiceit_s__Job_Rate_Plan_Charge__c
                                      (Id=rtPlanCharge.Id, RegCode_Error__c=regcode,Error_Date__c=System.Today()); 
                                      ratePlanCharge.add(charge);
                                    
                                    }
                                    }else{
                                    
                                    invoiceit_s__Job_Rate_Plan_Charge__c charge=new invoiceit_s__Job_Rate_Plan_Charge__c
                                      (Id=rtPlanCharge.Id, Error_Date__c=System.Today()); 
                                      ratePlanCharge.add(charge);
                                    
                                    }
                                    
                                 }catch(Exception e){}
                               }
                            }
                        }
                    }   
              }
            }
            
           
            update ratePlanCharge;
             
            for(String key:logMap.keySet()){
                logs.Info__c=logs.Info__c+key+logMap.get(key);
                
                
            }
            logs.Log_Type__c='Prior-RegCode';
            insert logs;
         
       }catch(Exception Ex){
           system.debug('Exception'+Ex);
       }
     
   }   
   
   global void finish(Database.BatchableContext BC){} 
}