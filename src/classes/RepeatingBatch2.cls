global class RepeatingBatch2 implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select ID, Params__c from AsyncRequest__c');
    }
        
    global void execute(Database.BatchableContext BC, List<AsyncRequest__c> scope){
        delete scope;
    }
    
    global void finish(Database.BatchableContext BC){
    	ScheduleHandler.StartScheduler(0);
    }
    
    public static void StartTheBatch()
    {
        RepeatingBatch2 rb = new RepeatingBatch2();
        Database.executeBatch(rb, 1);
    }
}