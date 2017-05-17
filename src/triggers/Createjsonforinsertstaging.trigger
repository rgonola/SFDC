/* The trigger is created for sending Payment related information to DM system*/

trigger Createjsonforinsertstaging on invoiceit_s__Invoice__c (after update) {
     
     for(invoiceit_s__Invoice__c pm:Trigger.new)
    {
     invoiceit_s__Invoice__c oldinv= Trigger.oldMap.get(pm.ID);
    string prcbkid;
    if(!Test.isRunningTest()){
     PDF_Quote_Ids__c batchno = PDF_Quote_Ids__c.getInstance('Batch'); 
      prcbkid = batchno.Batch_No__c;
        }else{
         prcbkid = 'Batch1';
        }
    if(pm.Create_Json__c== true && pm.Batch_Designation__c == prcbkid && oldinv.Create_Json__c==False){
    
     Insertnewstagingtable stageHandle = new Insertnewstagingtable();
          stageHandle.sendStagingData(pm.Id);
        }
        }
}