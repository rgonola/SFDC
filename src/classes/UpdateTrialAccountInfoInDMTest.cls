@isTest
public class UpdateTrialAccountInfoInDMTest{
    static testMethod void trialAccount() {
    
    
    //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;
        
         test.starttest();
         
        
         UpdateTrialAccountInfoInDM.trialAccount(account.id,'TWONLINETRIAL_2016');
         
          test.stoptest();
    
    }
    }