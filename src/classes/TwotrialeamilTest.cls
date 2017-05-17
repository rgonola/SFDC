@isTest
public class TwotrialeamilTest 
{
static testMethod void emailtest() 
    {
    
    //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
    //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
        account.Acct_Primary_Contact__c =cont.id;
        update account;    
        
                Test.startTest();
                
                  account.TwoTrial_Regcode__c = '123456-123456-123456';
                  update account;
        
                 Test.stopTest();
    }
}