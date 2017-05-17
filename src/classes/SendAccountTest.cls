@IsTest
Public class SendAccountTest{

static testMethod void account(){

    Account acctToUpdate = new Account(Brand__c='ATX',Name = 'Test Account88', OFFC__c=0,Type = 'Customer8',Prior_Software_Vendor__c='abc',
        CC_on_File__c=true,Cutoff__c=true,Primary_Contact_Name__c='Primary Contact', Email__c='usha1.mp@gmail.com',Phone='978899403',Fax='4335642',
        Primary_MobilePhone__c='5227686',Billing_Contact_Email__c='Billing2.Contact@gmail.com',BillingStreet='Billing street',Billing_Address_2__c='Billling Address',
        BillingCity='BillingCity',BillingState='BillingState',BillingPostalCode='344566',BillingCountry='Country',Shipping_Contact_Email__c='fdfsd1@gmail.com',ShippingStreet='ShippingStreet',
        Shipping_Address_2__c='ShippingAddress',ShippingCity='ShippingCity',ShippingState='ShippingState',ShippingPostalCode='78999',ShippingCountry='Country',
        CID__c='908654',PID__c='908654');
        insert acctToUpdate;
        
        Test.startTest();
        
        acctToUpdate.ShippingState='GA';
        Update acctToUpdate; 
        
        Test.stopTest(); 
}




}