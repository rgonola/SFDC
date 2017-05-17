public without sharing class diagnostics {

	// Simple logging

	public static void RecordCrash(Exception ex)
	{
		Diagnostic_Entry__c de = new Diagnostic_Entry__c(LineNumber__c = ex.getLineNumber(), 
									Body__c = ex.getMessage(), StackTrace__c = ex.getStackTraceString() );
		insert de;
	}
	
	public static void RecordDebugEntry(String message)
	{
		Diagnostic_Entry__c de = new Diagnostic_Entry__c(Body__c = message);
		insert de;
	}
	// Note - real code should test against DML limits, either stop when you're close,
	// or limit to N debug entries in an execution context



	public static void SendDiagnosticLog()
	{
		List<Diagnostic_Entry__c> entries = [Select ID, CreatedDate, Body__c, StackTrace__c, LineNumber__c from Diagnostic_Entry__c Order By CreatedDate Desc limit 500];
		if(entries.size()==0) return;
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<String> toAddresses = new List<String> {'yoursupportemail@email.com'};
		mail.setToAddresses(toAddresses);
		mail.setSenderDisplayName('Our application calling home');
		mail.setSubject('Diagnostic Logs');
		mail.setUseSignature(false);
		String outputtext;
		outputtext = 'Org: ' + userinfo.getOrganizationName() + ' ID: ' + userinfo.getOrganizationId() + '\r\n';
		List<string> currentdata;
		Boolean foundone = false;
		
		for(Diagnostic_Entry__c entry: entries)
		{
			outputtext += String.ValueOf(entry.CreatedDate) + ':';
			outputtext += entry.Body__c;
			if(entry.linenumber__c != null) outputtext += '\r\nError on line: ' + String.ValueOf(entry.linenumber__c);
			if(entry.stacktrace__c !=null) outputtext += '\r\nStackTrace: ' + entry.StackTrace__c;
			outputtext += '\r\n';
		}

		mail.setPlainTextBody(outputtext);
		List<Messaging.SendEmailResult> results = Messaging.SendEmail(new List<Messaging.Email>{mail});

		delete entries;	

		// Note - in real code be sure to ask permission
		// Consider not deleting after - but instead doing cleanup of older than N hours and recording 
		// in a custom setting the earliest date to send
		// Consider emptying the recycling bin
		
	}
	

}