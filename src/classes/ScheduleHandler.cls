public class ScheduleHandler implements ScheduledDispatcher.IScheduleDispatched {
	
	public void execute(SchedulableContext sc)
    {
        system.abortJob(sc.getTriggerID());	// Always abort the job on completion
        RepeatingBatch2.StartTheBatch();
    } 

    public static String GetSchedulerExpression(Datetime dt) {
        return ('' + dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
    }

	private static Boolean ScheduledInContext = false;

    public static void StartScheduler(Integer AsyncCount)
    {
		if(AsyncCount>0)
		{
			List<AsyncRequest__c> newrequests = new List<AsyncRequest__c>();
	       	for(Integer x = 0; x< AsyncCount; x++) {
				newrequests.add(new AsyncRequest__c(Params__c = 'some parameters'));
	       	}
	       	insert newrequests;
		}
		else
		{
			List<AsyncRequest__c> requests = [Select ID, Params__c from AsyncRequest__c Limit 1];
			if(requests.size()==0) return;
		}
    	if(ScheduledInContext) return;

		ScheduledInContext = true;
    	
        List<CronTrigger> jobs = [SELECT Id, CronJobDetail.Name, State, NextFireTime
                                  FROM CronTrigger where CronJobDetail.Name='async_example_schedule'];
    	if(jobs.size()>0 && jobs[0].state!='COMPLETED' && 
           jobs[0].state!='ERROR' && jobs[0].state!='DELETED') return;	// Already running

        Set<String> activejobstates = new Set<String>{'Queued','Processing','Preparing'};
		List<AsyncApexJob> apexjobs = [Select ID, ApexClass.Name from AsyncApexJob 
                                           where ApexClass.Name = 'RepeatingBatch2' And Status in :activejobstates];
		if(apexjobs.size()>0) return;  // The batch is running
    	
		System.schedule('async_example_schedule', 
	          GetSchedulerExpression(DateTime.Now().addSeconds(10)), 
	          new ScheduledDispatcher());
    	
    }

}