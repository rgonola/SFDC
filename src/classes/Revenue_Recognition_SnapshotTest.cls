@isTest()
public class Revenue_Recognition_SnapshotTest{


 static testMethod void testCallUpdateSnapshot(){
        Test.StartTest();
        Revenue_Snapshot_Line_Deletion Snapshot_Line_Deletion =new Revenue_Snapshot_Line_Deletion();
        String sch = '0 0 22 * * ?'; 
        system.schedule('Test RervenueSnapshot_Lines', sch, Snapshot_Line_Deletion ); 
        Test.stopTest(); 
    }
    
 static testMethod void testCallUpdatesnapshot1(){
    
        Test.StartTest();
        Revenue_Recognition_Snapshot Snapshot =new Revenue_Recognition_Snapshot();
        String sch = '0 0 22 * * ?'; 
        system.schedule('Test RervenueSnapshot', sch, Snapshot); 
        Test.stopTest(); 
    }
}