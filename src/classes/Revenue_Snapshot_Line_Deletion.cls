public class Revenue_Snapshot_Line_Deletion implements Schedulable {
public void execute(SchedulableContext sc) {


   
  List<Revenue_Recognition_Snapshot_Line__c> deletion = [select Id,Name,Account__c,Credit_Line__c,Credit_Note__c,Deferred_Revenue__c,Invoice__c,Invoice_Line__c,Last_5_days__c,
                                                        Last_day_of_the_month__c,Material__c,Month_1__c,Month_10__c,Month_11__c,Month_12__c,Month_13__c,Month_14__c,Month_15__c,
                                                        Month_16__c,Month_17__c,Month_18__c,Month_19__c,Month_2__c,Month_20__c,Month_21__c,Month_22__c,Month_23__c,Month_24__c,
                                                        Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Order__c,Order_Rate_Plan_Charge__c,Recognize_Revenue__c,
                                                        Revenue_Recognition_Snapshot__c,VSOE__c from Revenue_Recognition_Snapshot_Line__c where Last_5_days__c =False AND Last_day_of_the_month__c = FALSE AND DoNot_DeleteSnapshot__c = FALSE Limit 2500];
                                                    
                                                        if(deletion.size()>0)
                                                      
                                                        delete deletion;
                                                        



}
}