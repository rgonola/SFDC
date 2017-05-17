@isTest
public with sharing class TwoTrialTest{
    static testMethod void Trialaccount() {
        IIT_TestClassForUassage.insertCustomSetting();

        list<Invoiceit_s__Configuration__c> objects = new list<Invoiceit_s__Configuration__c>();
        
        Invoiceit_s__Configuration__c c1 =  new Invoiceit_s__Configuration__c(Name = 'PID_last', invoiceit_s__Number_Value__c= 1000); 
        objects.add((Invoiceit_s__Configuration__c) c1);
         
        Invoiceit_s__Configuration__c c2 =  new Invoiceit_s__Configuration__c(Name = 'CID_last', invoiceit_s__Number_Value__c= 1000); 
        objects.add((Invoiceit_s__Configuration__c) c2);
         
        //insert objects;
        
        //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;
        IIT_PID_CID_check.PID_CID_OFFC_AccID(10084,10045,1,account.id);
        
        //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
        test.starttest();
           
        //ApexPages.StandardController sc2 = new ApexPages.StandardController();
        
        ApexPages.currentPage().getParameters().put('recaptcha_challenge_field', 'Test Field');
        ApexPages.currentPage().getParameters().put('recaptcha_response_field', 'Test Response');
        Twodemoextn pg2 = new Twodemoextn();
        pg2.acc.Name='GATM';
        String pKey = pg2.publicKey;
        pg2.cnt.FirstName='p';
        pg2.cnt.LastName='1';
        pg2.save();
        pg2.cnt.FirstName='123';
        pg2.save();
        pg2.cnt.FirstName='Primary';
        pg2.save();
        pg2.cnt.LastName='123';
        pg2.save();
        pg2.cnt.LastName='last';
        pg2.save();
        pg2.acc.Name='G';
        pg2.save();
        pg2.acc.Name='123';
        pg2.save();
        pg2.acc.Name='GATM&';
        pg2.cnt.Email = 'test@gmail.com';
        pg2.save();
        pg2.acc.Name='GATM';
        pg2.save();
        pg2.cnt.Phone = '510-717-9958';
        pg2.save();
        pg2.verify();
        pg2.save();
        
        test.stoptest();
    }
}