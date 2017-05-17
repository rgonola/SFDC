trigger TriggeronPPIDelete on invoiceit_s__Payment_Plan_Installment__c (before delete) 
 {
ID ProfileId = UserInfo.getProfileId();  
ID AdminProfile = Label.Sys_admin_Profileid;
ID ArProfile =  Label.AR_Manager_ProfileID;
 system.debug('ProfileId'+ProfileId );
 
    for (invoiceit_s__Payment_Plan_Installment__c  a : Trigger.old){    
                
             IF((a.PPI_Status__c =='Posted' && a.invoiceit_s__Invoice__c != null && a.invoiceit_s__Order__c != null &&  (ProfileId!=ArProfile ) &&  (ProfileId!=AdminProfile )) ){ a.addError('You can\'t delete this record!.Please reach AR Manager'); system.debug('*****'+ProfileId +AdminProfile ); }
      }          
 }