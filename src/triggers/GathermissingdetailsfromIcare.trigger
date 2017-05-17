trigger GathermissingdetailsfromIcare on Provisioning__c (After update) {

 if(trigger.size==1){
  for(Provisioning__c p:trigger.new){
            Provisioning__c oldprvsng = Trigger.oldMap.get(p.ID);

    if(p.Get_Missing_Fields__c == TRUE  && oldprvsng.Get_Missing_Fields__c == FALSE ){
                  
      
      ProvisioningmissigndetailsCollector.GetdetailsfromIcare(p.id);    
 
    }
  }
}

}