global with sharing class IIT_RunSchedulerAccountARSnapShot implements Schedulable {
     global void execute(SchedulableContext context) {
        IIT_Batch_CreateARSnapShotForAccount batch_CreateARSnapShotForAccount = new IIT_Batch_CreateARSnapShotForAccount();  
        Id batchId = database.executebatch(batch_CreateARSnapShotForAccount);
     }
}