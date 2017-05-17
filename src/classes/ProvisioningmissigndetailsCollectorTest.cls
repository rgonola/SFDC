@isTest
global class ProvisioningmissigndetailsCollectorTest {

     static testMethod void testCallout() {
        // Set mock callout class 
        
        Configuration__c  config= new Configuration__c(Name='Icare configuration',Domain_Name__c= 'India',End_Point_URL__c= 'http://api.salesforce.com/foo/bar',Password__c='abciln',UserName__c = 'US');
        insert config;
        
         //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',Email__c='Test@gmail.com',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
        Provisioning__c opp=new Provisioning__c (Account__c=account.id,Total_iFirm_User__c=3,IFirm_URL__c='Test',Site_Id__c='gahdha-cdshd-advdhd-dfaf',Status__c='Provisioned');
        insert opp;
        
         List<Organization> org = [SELECT IsSandbox FROM Organization Where IsSandbox =TRUE  LIMIT 1];
         
        if(org.size()>0){
        opp.Profile__c='Portal (Test)';
        update opp;
        }else{
        opp.Profile__c='Portal';
        update opp;
        }
       // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        
        test.starttest();
        
        opp.Get_Missing_Fields__c =True;
        update opp;
        
       
         test.stoptest();
      
    }
    
    
    static TestMethod void contctetst(){
 
 
    
        Configuration__c  config= new Configuration__c(Name='Icare configuration',Domain_Name__c= 'India',End_Point_URL__c= 'http://api.salesforce.com/foo/bar',Password__c='abciln',UserName__c = 'US');
        insert config;
        
         //Account insert
        Account account = new Account(Name = 'test',ShippingCity = 'annapolis',ShippingCountry = 'US',Email__c='Test@gmail.com',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
        Provisioning__c opp=new Provisioning__c (Account__c=account.id,Total_iFirm_User__c=3,IFirm_URL__c='Test',Site_Id__c='gahdha-cdshd-advdhd-dfaf',Status__c='Provisioned');
        insert opp;
        
         List<Organization> org = [SELECT IsSandbox FROM Organization Where IsSandbox =TRUE  LIMIT 1];
         
        if(org.size()>0){
        opp.Profile__c='Portal (Test)';
        update opp;
        }else{
        opp.Profile__c='Portal';
        update opp;
        }
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        
        test.starttest();
        
        
         HttpResponse response =ProvisioningmissigndetailsCollector.getdata('');
        
       
         test.stoptest();
 
 
 
 
 
 
 }
 }