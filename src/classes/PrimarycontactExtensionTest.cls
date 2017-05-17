@isTest()

 Public class PrimarycontactExtensionTest {
 
 
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
        
        
         HttpResponse response =PrimarycontactExtension.sendRequest('');
        
       
         test.stoptest();
 
 
 
 
 
 
 }
 
 
 
  static testMethod void creation() {
        // Set mock callout class 
        
        Configuration__c  config= new Configuration__c(Name='Icare configuration',Domain_Name__c= 'India',End_Point_URL__c= 'http://api.salesforce.com/foo/bar',Password__c='abciln',UserName__c = 'US');
        insert config;
        
        
          //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        //prod.Profile__c='Portal';
        prod.IsActive=true;
        insert prod;
        
          Product2 prod1 = new Product2();
        prod1.Name = 'Sales Tax';
        prod1.Family = 'Hardware';
       // prod1.Profile__c='Portal';
        prod1.ProductCode = '2016EFILEFEE';
        prod1.IsActive=true;
        insert prod1;
        
          //  Feature        
        SBQQ__ProductFeature__c feature = new SBQQ__ProductFeature__c();        
        feature.Name = 'Test Feature';      
        feature.SBQQ__Number__c = 1;        
        feature.SBQQ__MinOptionCount__c = 1;        
        feature.SBQQ__ConfiguredSKU__c = prod.Id;       
        insert feature;     
                
            
         //  Product Options        
        SBQQ__ProductOption__c po = new SBQQ__ProductOption__c();       
        po.SBQQ__Number__c = 1;     
        po.SBQQ__ConfiguredSKU__c = prod.Id;        
        po.SBQQ__OptionalSKU__c = prod.Id;      
        po.SBQQ__Feature__c = feature.Id;       
        po.Display_Type__c = 'Checkbox';  
        po.SBQQ__Bundled__c=True;  
        po.SBQQ__Required__c=True;    
        insert po;   
        
         //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',Email__c='Test@gmail.com',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
         //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.Phone='521-521-2155';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
        //insert Opportunity 
        Opportunity opptn = new Opportunity();
        opptn.AccountId = account.id;
        opptn.CloseDate = System.today();
        opptn.type='New Sale To New Customer';
        opptn.StageName = 'Time to Buy';
        opptn.Name = 'Opportunity Test';
        opptn.Probability=80;
        opptn.Competitor__c='atx';
        opptn.ForecastCategoryName = 'Medium Probability';
        opptn.Forecast_Type__c='Medium (50-90%)';
        opptn.Product__c = 'ATX';
        insert opptn ; 
       
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Opportunity2__c = opptn.id;
        cpqQuote.SBQQ__Status__c = 'Approved';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.Primary_Factor_for_Purchase__c='Test';
        cpqQuote.What_was_the_previously_used_product__c='doTest';
        cpqQuote.Which_other_products_considered__c='dart';
        cpqQuote.SBQQ__Primary__c =true;
        cpqQuote.SBQQ__StartDate__c = System.today();
        //cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote;
        
         //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine.SBQQ__Product__c= prod.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.is_iFirm__c=true;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine;
        
        
     
        
          //Insert QuoteLine
       SBQQ__QuoteLine__c cpqQuoteLine1 =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine1.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine1.SBQQ__Product__c= prod1.id;
        cpqQuoteLine1.SBQQ__RequiredBy__c=cpqQuoteLine.id;
        cpqQuoteLine1.SBQQ__Quantity__c = 1;
        cpqQuoteLine1.SBQQ__ProductOption__c=po.id;
        cpqQuoteLine1.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.is_iFirm__c=true;
        cpqQuoteLine1.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine1.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine1;
        Provisioning__c opp=new Provisioning__c (Account__c=account.id,Total_iFirm_User__c=3,Active__c =TRUE,IFirm_URL__c='Test',Site_Id__c='gahdha-cdshd-advdhd-dfaf',Status__c='Order Pending',Profile__c='Portal (Test)',Related_Quote__c=cpqQuote.id);
       // insert opp;
        
       // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        
        test.starttest();
        
        PageReference pageRef1 = Page.Primary_Contact_on_Quote;
           
        pageRef1.getParameters().put('qut', String.valueOf(cpqQuote.id));
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(cpqQuote);
        PrimarycontactExtension updafte = new PrimarycontactExtension(sc1);
        updafte.ifirmprvsng.IFirm_URL__c ='testurl';
        updafte.ifirmprvsng.On_Boarding_Status__c='onboard';
        updafte.onsave();
        
        updafte.qute.Primary_Factor_for_Purchase__c = '';
        updafte.onsave();
        updafte.qute.Primary_Factor_for_Purchase__c = 'Item Need';
        updafte.qute.Which_other_products_considered__c = '';
        updafte.onsave();
        updafte.qute.Which_other_products_considered__c = 'SFS Product';
        updafte.qute.What_was_the_previously_used_product__c = '';
        updafte.onsave();
        updafte.qute.What_was_the_previously_used_product__c = 'SFS Product';
        ApexPages.StandardController sc = new ApexPages.StandardController(cpqQuote);
        PrimarycontactExtension updaftes = new PrimarycontactExtension(sc);
        updaftes.ifirmprvsng.IFirm_URL__c ='testurl';
        updaftes.ifirmprvsng.On_Boarding_Status__c='Deferred';
        updaftes.ifirmprvsng.Not_Ready_For_URL__c=true;
        updaftes.ifirmprvsng.Deffered_Date__c = system.today();
        updaftes.onsave();
        
       
         test.stoptest();
      
    }
    
    
     static testMethod void creation1() {
        // Set mock callout class 
        
        Configuration__c  config= new Configuration__c(Name='Icare configuration',Domain_Name__c= 'India',End_Point_URL__c= 'http://api.salesforce.com/foo/bar',Password__c='abciln',UserName__c = 'US');
        insert config;
        
         //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        //prod.Profile__c='Portal';
        prod.IsActive=true;
        insert prod;
        
         //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',Email__c='Test@gmail.com',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
         //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Phone='521-521-2155';
        cont.Is_Primary__c = true;
        insert cont;
        
        //insert Opportunity 
        Opportunity opptn = new Opportunity();
        opptn.AccountId = account.id;
        opptn.CloseDate = System.today();
        opptn.StageName = 'Validation';
        opptn.Name = 'Opportunity Test';
        opptn.Competitor__c='atx';
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
        
         //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine.SBQQ__Product__c= prod.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.is_iFirm__c=true;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine;
        
        Provisioning__c opp=new Provisioning__c (Account__c=account.id,Total_iFirm_User__c=3,On_Boarding_Status__c='Deferred',Deffered_Date__c=system.today(),Active__c =TRUE,IFirm_URL__c='Test',Site_Id__c='gahdha-cdshd-advdhd-dfaf',Status__c='Order Pending',Related_Quote__c=cpqQuote.id);
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
        
        PageReference pageRef1 = Page.Primary_Contact_on_Quote;
           
        pageRef1.getParameters().put('qut', String.valueOf(cpqQuote.id));
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(cpqQuote);
        PrimarycontactExtension updafte = new PrimarycontactExtension(sc1);
        updafte.ifirmprvsng.IFirm_URL__c ='testurl';
        updafte.ifirmprvsng.On_Boarding_Status__c='onboard';
        updafte.onsave();
       
         test.stoptest();
      
    }
 }