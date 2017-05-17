public with sharing class Settings {

	public static void badcode()
	{
		String s = CustomerSetting__c.getInstance('default').SomeInfo__c;
		// Code assumes that setting exists - exception otherwise
		
		// Will fail on SeeAllData false test unless intialized
	}


	public static void goodcode()
	{
		CustomerSetting__c c = CustomerSetting__c.getInstance('default');
		if(c==null)
		{
			// Exit, or create a default object
	        c = new CustomerSetting__c(Name='default', SomeInfo__c = 'test data');
	        // You don't have to insert the object!
		}
		String s = c.SomeInfo__c;
		// Code will succeed on SeeAllData false or true
	}


}