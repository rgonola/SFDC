@isTest(seealldata=false)
public with sharing class Accountownerchangetest{
    static testMethod void oppowner() {


     //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;

           //Contact Insert
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;

        account.Name='';

        //insert Opportunity
        Opportunity opp = new Opportunity();
        opp.AccountId = account.id;
        opp.CloseDate = System.today();
        opp.StageName = 'Validation';
        opp.Name = 'Opportunity Test';
        opp.ForecastCategoryName = 'Medium Probability';
        opp.Product__c = 'ATX';
        insert opp;


        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User usr = new User(LastName = 'LIVE',
                           FirstName='JASN',
                           Alias = 'jliv',
                           Email = 'jasonlhhn@asdf.com',
                           Username = 'jaseston@asdf.com.uat',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
                insert usr;

         Test.Starttest();

         account.ownerID= usr.id;
         update account;

         Test.Stoptest();

    }

 }