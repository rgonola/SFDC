public class Revenue_Recognition_Status_Change implements Schedulable {


     public void execute(SchedulableContext sc) {
     
     
            List<invoiceit_s__Invoice_Lines__c> updatesnapshotline = new List<invoiceit_s__Invoice_Lines__c>();
            
           
           for(invoiceit_s__Invoice_Lines__c snapshotline : [select Id,invoiceit_s__Revenue_Recognition_Status__c,CreatedDate from invoiceit_s__Invoice_Lines__c where invoiceit_s__Revenue_Recognition_Status__c='ERROR'  AND invoiceit_s__Revenue_Recognition_Rule__c!= NULL AND Product_Family__c !='Fees' AND Product_Family__c!= 'Training' Limit 99]){ snapshotline.invoiceit_s__Revenue_Recognition_Status__c= 'Queued'; updatesnapshotline.add(snapshotline ); }
            
            update updatesnapshotline ;
            }
     }