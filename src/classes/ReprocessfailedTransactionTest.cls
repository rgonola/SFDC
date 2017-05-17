@isTest
public with sharing class ReprocessfailedTransactionTest{

         static testMethod void createpayments() {
          
          
          Account account = new Account(Cutoff__c = true,Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__c = '10045',PID__c = '10084');
        insert account;
        
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'nmallela@steelbricl.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        cont.MailingStreet = 'Test';
        cont.MailingState  = 'MD';
        cont.MailingPostalCode = '21401';
        cont.MailingCity = 'annapolis';
        cont.MailingCountry = 'US';
        
        insert cont;
        invoiceit_s__Gateway__c gateway = new invoiceit_s__Gateway__c();
        gateway.Name = 'Test';
        gateway.invoiceit_s__Merchant_ID__c = 'naveen';
        gateway.invoiceit_s__Merchant_Reference__c = 'naveen';
        gateway.invoiceit_s__Security_Key__c = 'dsdqew32wdwd32de323ddsd' ;
        gateway.invoiceit_s__Gateway_Type__c = 'CyberSource_CC_Token';
        gateway.invoiceit_s__Active__c = true ;
        gateway.invoiceit_s__Default__c = true;
        gateway.invoiceit_s__Test_Mode__c = true;
        insert gateway; 
        
          invoiceit_s__Payment_Method__c PM = new invoiceit_s__Payment_Method__c();
                    PM.invoiceit_s__Account__c = account.id;
                    PM.invoiceit_s__Active__c = true;
                    PM.invoiceit_s__Default__c= true;
                    PM.invoiceit_s__Billing_Address__c = 'Bangalore';
                    PM.invoiceit_s__Billing_Country__c = 'US';
                    PM.invoiceit_s__Billing_Email__c = 'test@gmail.com';
                    PM.invoiceit_s__Billing_First_Name__c= 'Invoice';
                    PM.invoiceit_s__Billing_Last_Name__c = 'IT';
                    PM.invoiceit_s__Billing_State_Province__c= 'CA';
                    PM.invoiceit_s__Billing_Zip_Postal__c= '56009';
                    PM.invoiceit_s__Card_Expiration_Month__c  = '11';
                    PM.invoiceit_s__Card_Expiration_Year__c= '2019';
                    PM.invoiceit_s__Card_Number__c= '4111111111111111';
                    PM.invoiceit_s__Card_Type__c= 'Visa';
                    PM.invoiceit_s__Name_on_Card__c='Naveen';
                    PM.invoiceit_s__Payment_Method__c = 'Credit Card';
                
                    insert PM;
         
         
           invoiceit_s__Transaction__c trans = new invoiceit_s__Transaction__c();
                    trans.invoiceit_s__Payment_Method__c =PM.ID ;
                    trans.invoiceit_s__Payment_Gateway__c= gateway.ID;
                    //trans.invoiceit_s__Account__c=account.id;
                    //trans.invoiceit_s__Amount__c=25;
                    trans.invoiceit_s__Response_Status__c = 'Approved';
                    insert trans;
                    
             
              Test.StartTest();       
              ReprocessfailedTransaction.createpayments(trans.id);
               Test.StopTest(); 
         }
}