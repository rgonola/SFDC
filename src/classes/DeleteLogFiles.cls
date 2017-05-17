global class DeleteLogFiles Implements Schedulable {

    global void execute(SchedulableContext sc)
    {
      if(!Test.isRunningTest())
        clearLogs();
    }
    
    public void clearLogs(){
        date d = system.today().addDays(-7);
        List<LogFiles__c> logFiles=[Select Id,name from LogFiles__c where createdDate <:d limit 100];
        delete logFiles;
        system.debug('Successfully deleted');
    }
}