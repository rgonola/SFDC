@isTest()
public class UpdateRegCodeSchedulerTest{

static testMethod void testcallupdateRegcode(){

        Test.StartTest();
        UpdateRegCodeScheduler updatesc=new UpdateRegCodeScheduler();
        String sch = '0 0 22 * * ?'; 
        system.schedule('Test RervenueSnapshot_Lines', sch, updatesc); 
        Test.stopTest(); 
    }

  
        


}