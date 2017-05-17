@isTest
private class SettingsTest {

/* Commented out to allow installation

   	@istest (seealldata=true)
    static void BadTest1() {
        Settings.badcode();
    }

    
	@istest (seealldata=false)
    static void BadTest2() {
        CustomerSetting__c c = new CustomerSetting__c(Name='default', SomeInfo__c = 'test data');
        insert c;
        Settings.badcode();

		// The problem is - you can't insert a test object!!!
    }
*/
    
	@istest (seealldata=false)
    static void GoodTest() {
        Settings.goodcode();
    }
    
    
}