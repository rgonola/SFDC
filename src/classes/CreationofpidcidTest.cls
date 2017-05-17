@isTest    
class CreationofpidcidTest
{
    static testMethod void myTest() {
    
     //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;
        
        
        
        Test.startTest();
        Creationofpidcid.call(account.id);
        Test.StopTest();
        
      }
}