trigger LastInvoiceDate on invoiceit_s__Invoice__c (after insert) { //inserts 
  Map<ID, Account> parentAcct = new Map<ID, Account>(); //Making it a map instead of list for easier lookup
  Map<ID, Date> listIds = new Map<ID, Date>();

  for (invoiceit_s__Invoice__c childObj : Trigger.new) {
  
  Date stdt= date.newinstance(childObj.CreatedDate.year(), childObj.CreatedDate.month(), childObj.CreatedDate.day());
    listIds.put(childObj.invoiceit_s__Account__c,stdt);
  }

  //Populate the map. Select the field you want to update, Last_Invoice_Date__c
  //The child relationship is called invoiceit_s__Invoice__r
  //Checking whether the invoice in the trigger is the latest
  parentAcct = new Map<Id, Account>([SELECT id,Last_Invoice_Date__c  FROM Account WHERE ID IN :listIds.keyset()]);

  for (Account a: parentAcct.values()){
     
    a.Last_Invoice_Date__c = listIds.get(a.id);
  }

  update parentAcct.values();
}