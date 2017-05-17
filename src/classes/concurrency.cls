public class concurrency {

    public static void Delay(Integer seconds)
    {
        List<Integer> largearray = new List<Integer>();
        for(Integer x =0; x<10000; x++) largearray.add(x);
        for(Integer counter = 0; counter<seconds * 4; counter++)
        {
            String s = json.serialize(largearray);
        }
    }

    // Create this opportunity by hand
	private static String OpportunityName = 'Concurrency1';
    
    @future
    public static void IncrementOptimistic(double amount, Integer DelayBefore, Integer DelayFromQuery, Integer DelayAfter)
    {
        if(DelayBefore>0) Delay(DelayBefore);
        List<Opportunity> ops = [Select ID, Amount From Opportunity where Name = :OpportunityName];
        for(Opportunity op: ops)
        	op.Amount = (op.Amount==null)? amount: op.Amount + Amount;
        if(DelayFromQuery>0) Delay(DelayFromQuery);
        update ops;
        if(DelayAfter>0) Delay(DelayAfter);
    }

    @future
    public static void IncrementPessimistic(double amount, Integer DelayBefore, Integer DelayFromQuery, Integer DelayAfter)
    {
        if(DelayBefore>0) Delay(DelayBefore);
        List<Opportunity> ops = [Select ID, Amount From Opportunity where Name = :OpportunityName For Update];
        for(Opportunity op: ops)
        	op.Amount = (op.Amount==null)? amount: op.Amount + Amount;
        if(DelayFromQuery>0) Delay(DelayFromQuery);
        update ops;
        if(DelayAfter>0) Delay(DelayAfter);
    }
    
    @testvisible private static List<Boolean> SimulateDMLError = null;
    
    public static void UpdateLeads(List<Lead> leads)
    {
        List<Database.Saveresult> dmlresults = Database.Update(leads, false);
		List<Lead> FailedUpdates = new List<Lead>(); 
		for(Integer x = 0; x< leads.size(); x++)
		{
			Database.Saveresult sr = dmlresults[x];
			if(!sr.isSuccess() || (SimulateDMLError!=null && SimulateDMLError[x]))
			{
				for(Database.Error err: sr.getErrors())
				{
					if(err.getStatusCode() == StatusCode.UNABLE_TO_LOCK_ROW)
					{
						FailedUpdates.add(leads[x]);
						break;
					}
				}
				if(SimulateDMLError!=null && SimulateDMLError[x]) FailedUpdates.add(leads[x]);
			}
		}			
    	if(FailedUpdates.size()>0)
    	{
    		Map<ID, Lead> failedLeadMap = new Map<ID, Lead>(FailedUpdates);
    		String errormessage = 'Failed DML on leads ' + String.Join(new List<ID>(failedLeadMap.keyset()),',');
    		// You aren't limited to saving IDs - you can save any update info
    		// for later update - you can even serialize objects and store all of
    		// their data
    		diagnostics.RecordDebugEntry(errormessage);
    	}
    	
    }
    
}