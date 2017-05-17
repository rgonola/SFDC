@istest
public class ConcurrencyTest {

	@istest 
	private static void SimulateDMLError()
	{
		List<Lead> newleads = new List<Lead>
			{ 	new Lead(LastName = 'b', Company = 'b', email='b@b.com'),
				new Lead(LastName = 'c', Company = 'c', email='c@c.com')
			};
		
		insert newleads;
		for(Lead ld: newleads)
		{
			ld.City = 'somewhere';
		}
		concurrency.UpdateLeads(newleads);
		List<Lead> leadtest1 = [Select ID, City from Lead];
		for(Lead ld: leadtest1) {
			system.AssertEquals('somewhere', ld.City);
			ld.City = 'somewhere else';
		}
		concurrency.SimulateDMLError = new List<Boolean> { true, true};
		concurrency.UpdateLeads(leadtest1);
		List<Diagnostic_Entry__c> entries = [Select ID from Diagnostic_Entry__c];
		// Make sure there's a diagnostic entry
		system.assertequals(1, entries.size());
		

		
	}
	

}