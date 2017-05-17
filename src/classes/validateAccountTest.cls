@isTest()
public class validateAccountTest{
 Static testMethod void validateaccountmethod(){
  
   Account account = new Account(Name = 'India',EBR_GTD__c=null,ShippingCity = 'annapolis',ShippingCountry = 'US',Email__c='Test@gmail.com',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
         //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'Validating';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        cont.phone = '999999999';
        cont.DoNotCall = true;
        
        insert cont;
     
     Test.StartTest();
      ApexPages.StandardController sc1 = new ApexPages.StandardController(account);
     validateAccount vt = new validateAccount(sc1);
     vt.id=account.id;
     
     Test.StopTest();
     
  }
  }