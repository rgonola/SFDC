@isTest
global class IcareSiteUpdateTest {

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
        
        IcareSiteUpdate updafte = new IcareSiteUpdate();
        updafte.UpdateIfirmdetails(opp.id);
        
       
         test.stoptest();
      
    }
    
    
    static testMethod void mocktest() {
    // Set mock callout class 
        
        Configuration__c  config= new Configuration__c(Name='Icare configuration',Domain_Name__c= 'India',End_Point_URL__c= 'http://api.salesforce.com/foo/bar',Password__c='abciln',UserName__c = 'US');
        insert config;
        
     
        
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        
        test.starttest();
        
       
        
        HttpResponse res = IcareSiteUpdate.sendRequestWithJson('http://api.salesforce.com/foo/bar','GET','internal');
        system.debug('Response***'+res);
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
         test.stoptest();
    }
    
    
    static testMethod void exceptiontest() {
        // Set mock callout class 
        
        Configuration__c  config= new Configuration__c(Name='Icare configuration',Domain_Name__c= 'India',End_Point_URL__c= 'http://api.salesforce.com/foo/bar',Password__c='abciln',UserName__c = 'US');
       // insert config;
        
         //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',Email__c='Test@gmail.com',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
        Provisioning__c opp=new Provisioning__c (Account__c=account.id,IFirm_URL__c='Test',Site_Id__c='gahdha-cdshd-advdhd-dfaf',Status__c='Provisioned');
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
        
        IcareSiteUpdate updafte = new IcareSiteUpdate();
        updafte.UpdateIfirmdetails(opp.id);
        
       
         test.stoptest();
      
    }
}