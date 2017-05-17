@isTest
global class IcareSiteCreationTest {

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
        
        //IcareSiteCreation updafte = new IcareSiteCreation();
        String x =IcareSiteCreation.replicateIfirmUrlbutn(opp.id,False);
        String x3 =IcareSiteCreation.replicateIfirmUrlbutn(opp.id,True);
       
         test.stoptest();
      
    }
    
    
    static testMethod void creation() {
        // Set mock callout class 
        
        Configuration__c  config= new Configuration__c(Name='Icare configuration',Domain_Name__c= 'India',End_Point_URL__c= 'http://api.salesforce.com/foo/bar',Password__c='abciln',UserName__c = 'US');
        insert config;
        
         //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',Email__c='Test@gmail.com',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
         //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
        //insert Opportunity 
        Opportunity opptn = new Opportunity();
        opptn.AccountId = account.id;
        opptn.CloseDate = System.today();
        opptn.StageName = 'Validation';
        opptn.Name = 'Opportunity Test';
        opptn.ForecastCategoryName = 'Medium Probability';
        opptn.Product__c = 'ATX';
        insert opptn ; 
       
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Opportunity2__c = opptn.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__Primary__c =true;
        cpqQuote.SBQQ__StartDate__c = System.today();
        //cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote;
        
        Provisioning__c opp=new Provisioning__c (Account__c=account.id,Total_iFirm_User__c=3,IFirm_URL__c='Test',Site_Id__c='gahdha-cdshd-advdhd-dfaf',Status__c='Order Pending',Related_Quote__c=cpqQuote.id);
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
        
        IcareSiteCreation updafte = new IcareSiteCreation();
        updafte.replicateIfirmUrl(cpqQuote.id,account.id);
        
        IcareSiteCreation updafte1 = new IcareSiteCreation();
        updafte1.replicateIfirmUrl(cpqQuote.id,account.id);
       
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
        
       
        
        HttpResponse res = IcareSiteCreation.sendRequestWithJson('http://api.salesforce.com/foo/bar','GET','internal');
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
  }