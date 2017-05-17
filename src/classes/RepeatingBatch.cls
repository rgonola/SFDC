global class RepeatingBatch implements Database.Batchable<sObject>, Database.Stateful {

    public Integer Remaining;
    
    global RepeatingBatch(Integer count)
    {
        remaining = count;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select ID, Params__c from AsyncRequest__c');
    }
    
        
    global void execute(Database.BatchableContext BC, List<AsyncRequest__c> scope){
        delete scope;
    }

    
    global void finish(Database.BatchableContext BC){
        remaining --;
        if(remaining>0)
        {
            List<AsyncRequest__c> newrequests = new List<AsyncRequest__c> {
                new AsyncRequest__c(Params__c = String.ValueOf(remaining)),
                new AsyncRequest__c(Params__c = String.ValueOf(remaining)),
                new AsyncRequest__c(Params__c = String.ValueOf(remaining)) 
            };
            insert newrequests;
            StartTheBatch(remaining);
        }
        // Be careful - you can get infinitely repeating batches if you aren't careful
    }
    
    public static void StartTheBatch(Integer repeats)
    {
        List<AsyncRequest__c> newrequests = new List<AsyncRequest__c> {
            new AsyncRequest__c(Params__c = String.ValueOf(repeats)),
            new AsyncRequest__c(Params__c = String.ValueOf(repeats)),
            new AsyncRequest__c(Params__c = String.ValueOf(repeats)) 
        };
        if(Test.isRunningTest()) insert newrequests[0];	// Only one pass on test code
        else insert newrequests;
        RepeatingBatch rb = new RepeatingBatch(repeats);
        Database.executeBatch(rb, 1);
    }

}