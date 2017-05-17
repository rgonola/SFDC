global class ReprocessfailedTransaction{




  webservice Static Id createpayments(Id txnId){
  
   
   
   invoiceit_s__Transaction__c Txn = [select Id,Name,invoiceit_s__Request_Invoice__r.invoiceit_s__Account__r.Id,invoiceit_s__Amount__c,invoiceit_s__Request_Invoice__c,invoiceit_s__Is_Payment_Processed_Successfully__c,
                                             invoiceit_s__Request_Type_Of_Payment__c,invoiceit_s__Gateway_Date__c,invoiceit_s__Currency__c,invoiceit_s__Exception_Message__c
                                             From invoiceit_s__Transaction__c where id=:txnId];
   
   
   invoiceit_s__Payment__c payment = new invoiceit_s__Payment__c(invoiceit_s__Account__c = Txn.invoiceit_s__Request_Invoice__r.invoiceit_s__Account__r.Id ,
                                                                                invoiceit_s__Amount__c = Txn.invoiceit_s__Amount__c, 
                                                                                invoiceit_s__Status__c = 'Completed', 
                                                                                invoiceit_s__Payment_Type__c = Txn.invoiceit_s__Request_Type_Of_Payment__c,
                                                                                invoiceit_s__Payment_Date__c = Date.valueOf(Txn.invoiceit_s__Gateway_Date__c),
                                                                                invoiceit_s__Invoice__c = Txn.invoiceit_s__Request_Invoice__c,
                                                                                invoiceit_s__Currency__c = Txn.invoiceit_s__Currency__c,
                                                                                invoiceit_s__Transaction__c =txnId,
                                                                                invoiceit_s__Payment_Description__c = 'This payment is being Re-Processed from Payment Scheduler failures.');
  
  
  if(!Test.IsRunningTest()) insert payment;
  
  Txn.invoiceit_s__Exception_Message__c='';
  Txn.invoiceit_s__Is_Payment_Processed_Successfully__c=True;
  update Txn;
  
  invoiceit_s__Payment_Allocation__c paymentAllocation = new invoiceit_s__Payment_Allocation__c(invoiceit_s__Payment__c = payment.Id,invoiceit_s__Amount__c = payment.invoiceit_s__Amount__c,invoiceit_s__Invoice__c = Txn.invoiceit_s__Request_Invoice__c,invoiceit_s__Status__c='Completed');
  if(!Test.IsRunningTest()) insert paymentAllocation;
  
  return Txn.id;
  }






}