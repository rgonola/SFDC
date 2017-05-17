public class Revenue_Recognition_Snapshotlinecheckbox implements Schedulable {


     public void execute(SchedulableContext sc) {
     
     
            List<Revenue_Recognition_Snapshot_Line__c> updatesnapshotline = new List<Revenue_Recognition_Snapshot_Line__c>();
            
            DateTime CreatedOn = System.Now().addDays(-5);
            
           for(Revenue_Recognition_Snapshot_Line__c snapshotline : [select Id,Last_5_days__c,Last_day_of_the_month__c,CreatedDate from Revenue_Recognition_Snapshot_Line__c where createdDate<:CreatedOn  AND Last_5_days__c = TRUE LIMIT 2500]){
           
            snapshotline.Last_5_days__c = False;
            updatesnapshotline.add(snapshotline );
       
          }
            

            update updatesnapshotline ;
            }
     }