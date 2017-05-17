@isTest()
public class Revenue_Snapshot_checkboxTest{
 static testMethod void testsnapshotcheckbox(){
 
         invoiceit_s__Currency__c curr=new invoiceit_s__Currency__c(Name='Currency',invoiceit_s__Currency_Name__c='USD',invoiceit_s__Currency_Symbol__c='$');
        insert curr;
        
        Revenue_Recognition_Snapshot__c snapshot = new Revenue_Recognition_Snapshot__c();
        
         
         snapshot.Start_Date__c= system.today();
         snapshot.End_Date__c=system.today().addyears(2);
         snapshot.Currency__c = curr.Id;
         
         insert snapshot;
        
        
        
        Revenue_Recognition_Snapshot_Line__c line = new Revenue_Recognition_Snapshot_Line__c();
        
        line.Revenue_Recognition_Snapshot__c = snapshot.Id;
            line.Last_5_days__c = true;
            line.Last_day_of_the_month__c = false;
            
           insert line;
           
        Test.StartTest();
        Revenue_Recognition_Snapshotlinecheckbox checkbox=new Revenue_Recognition_Snapshotlinecheckbox();
        String sch = '0 0 20 * * ?'; 
        system.schedule('Test Revenue_Recognition_Snapshot_Line', sch, checkbox); 
        Test.stopTest(); 
    }
    }