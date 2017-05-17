trigger cancelORPCifRequiredbyiscancelled on invoiceit_s__Job_Rate_Plan_Charge__c (after Update) {
  
    Set<ID> orpcId= new Set<ID>(); 
    Set<ID> childorpcId= new Set<ID>(); 
    List<invoiceit_s__Job_Rate_Plan_Charge__c > orpcToUpdate = new List<invoiceit_s__Job_Rate_Plan_Charge__c >(); 


   for(invoiceit_s__Job_Rate_Plan_Charge__c  orpc: Trigger.New){
   
   
       if(orpc.invoiceit_s__Status__c =='Cancelled' && orpc.invoiceit_s__Required_By__c == null ){  orpcId.add(orpc.id); }
   
   }

   
   List<invoiceit_s__Job_Rate_Plan_Charge__c > childorpc =[Select Id,invoiceit_s__Status__c  From invoiceit_s__Job_Rate_Plan_Charge__c  Where invoiceit_s__Required_By__c IN:orpcId AND invoiceit_s__Status__c !='Cancelled' ];

   for(invoiceit_s__Job_Rate_Plan_Charge__c i : childorpc){
    
    i.invoiceit_s__Status__c  = 'Cancelled';
    orpcToUpdate.add(i);
    childorpcId.add(i.id);
   }
   
   if(orpcToUpdate.size()>0) update orpcToUpdate;
   
   
   
   
}