@isTest()
public class Revenue_Recognition_Status_ChangeTest{
 static testMethod void testsnapshotcheckbox(){
 
       
           
        Test.StartTest();
        Revenue_Recognition_Status_Change  checkbox=new Revenue_Recognition_Status_Change ();
        String sch = '0 0 20 * * ?'; 
        system.schedule('Test Revenue_Recognition_Snapshot_Line', sch, checkbox); 
        Test.stopTest(); 
    }
    }