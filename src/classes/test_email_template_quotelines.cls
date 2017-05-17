@isTest
private class test_email_template_quotelines {
    

    @isTest static void test_method_fail_one() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='ATX', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
        /*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        */
        update lines1;
        //update quote1;

        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        String failquote=quote1.id;
        failquote=failquote.left(failquote.length()-4) + 'abxy';
        etql.myQuoteId=failquote;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        etql.getTandC();
        //etql.getmyQuoteDetails();
        //etql.gethasFees();
        //etql.getvisibility();
        //etql.emailorattach='email';
        //etql.accountOrderNumber='1234';
        //etql.firstname='fname';
        //etql.lastname='lname';
        //etql.phone='111-111-1111';
        //etql.email='test@test.com';
        //String testString=etql.myLogoPath;

    }
     @isTest static void test_method_one() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='ATX', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
        /*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        */
        update lines1;
        //update quote1;

        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        etql.getmyFeeLines();
        etql.getmyPaymentDetails();
        //etql.getmyQuoteLines();
        //etql.getmyQuoteDetails();
        //etql.gethasFees();
        //etql.getvisibility();
        etql.emailorattach='email';
        etql.accountOrderNumber='1234';
        etql.firstname='fname';
        etql.lastname='lname';
        etql.phone='111-111-1111';
        etql.email='test@test.com';
        //String testString=etql.myLogoPath;

    }
    
    	@isTest static void test_method_one_b() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='ATX', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
        /*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        */
        update lines1;
        //update quote1;

        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        etql.getmyQuoteLines();
        etql.getmyQuoteDetails();
        //etql.gethasFees();
        //etql.getvisibility();
        etql.emailorattach='email';
        etql.accountOrderNumber='1234';
        etql.firstname='fname';
        etql.lastname='lname';
        etql.phone='111-111-1111';
        etql.email='test@test.com';
        //String testString=etql.myLogoPath;

    }
    
        	@isTest static void test_method_one_c() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='ATX', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
        /*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        */
        update lines1;
        //update quote1;

        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        //etql.getmyQuoteLines();
        //etql.getmyQuoteDetails();
        etql.gethasFees();
        etql.getvisibility();
        etql.emailorattach='email';
        etql.accountOrderNumber='1234';
        etql.firstname='fname';
        etql.lastname='lname';
        etql.phone='111-111-1111';
        etql.email='test@test.com';
        //String testString=etql.myLogoPath;

    }
    
       @isTest static void test_method_two() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='TW', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
        /*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        update quote1;
*/
        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        etql.getmyFeeLines();
        etql.getmyPaymentDetails();
        //etql.getmyQuoteLines();
        //etql.getmyQuoteDetails();
        //etql.gethasFees();
        //etql.getvisibility();
        //String testString=etql.myLogoPath;

    }
    	@isTest static void test_method_two_a() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='TW', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
        /*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        update quote1;
*/
        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        etql.getmyQuoteLines();
        etql.getmyQuoteDetails();
        //etql.gethasFees();
        //etql.getvisibility();
        //String testString=etql.myLogoPath;

    }
    @isTest static void test_method_two_b() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='TW', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
        /*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        update quote1;
*/
        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        //etql.myQuoteId=quote1.id;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        //etql.getmyQuoteLines();
        //etql.getmyQuoteDetails();
        etql.gethasFees();
        etql.getvisibility();
        //String testString=etql.myLogoPath;

    }
    
     @isTest static void test_method_three() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='CSIFIRM', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
/*
        //invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        //invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        //ord.invoiceit_s__Account__c=acc.id;
        //ord.invoiceit_s__CurrencyL__c=myusd.id;

        //insert ord;

        //quote1.QTC__Order__c=ord.id;
        update quote1;
*/
        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        etql.getmyFeeLines();
        etql.getmyPaymentDetails();
        //etql.getmyQuoteLines();
        //etql.getmyQuoteDetails();
        //etql.gethasFees();
        //etql.getvisibility();
        //String testString=etql.myLogoPath;

    }
    @isTest static void test_method_three_a() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='CSIFIRM', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
/*
        //invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        //invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        //ord.invoiceit_s__Account__c=acc.id;
        //ord.invoiceit_s__CurrencyL__c=myusd.id;

        //insert ord;

        //quote1.QTC__Order__c=ord.id;
        update quote1;
*/
        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        etql.getmyQuoteLines();
        etql.getmyQuoteDetails();
        //etql.gethasFees();
        //etql.getvisibility();
        //String testString=etql.myLogoPath;

    }
    @isTest static void test_method_three_b() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='CSIFIRM', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
/*
        //invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        //invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        //ord.invoiceit_s__Account__c=acc.id;
        //ord.invoiceit_s__CurrencyL__c=myusd.id;

        //insert ord;

        //quote1.QTC__Order__c=ord.id;
        update quote1;
*/
        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        //etql.getmyQuoteLines();
        //etql.getmyQuoteDetails();
        etql.gethasFees();
        etql.getvisibility();
        //String testString=etql.myLogoPath;

    }
     @isTest static void test_method_four() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='PROD1', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
/*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        update quote1;
*/
        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        etql.getmyQuoteLines();
        etql.getmyQuoteDetails();
        //etql.gethasFees();
        //etql.getvisibility();
        //String testString=etql.myLogoPath;

    }
    @isTest static void test_method_four_a() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='PROD1', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
/*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        update quote1;
*/
        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        etql.getmyQuoteLines();
        etql.getmyQuoteDetails();
        //etql.gethasFees();
        //etql.getvisibility();
        //String testString=etql.myLogoPath;

    }
    @isTest static void test_method_four_b() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='PROD1', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
/*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        update quote1;
*/
        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        //etql.getmyQuoteLines();
        //etql.getmyQuoteDetails();
        etql.gethasFees();
        etql.getvisibility();
        //String testString=etql.myLogoPath;

    }
    
        @isTest static void test_method_four_c() {



        //Created Dummy Document
        Document doc=new Document();
        doc.Name='Wolters_Kluwer_Logo';
        doc.DeveloperName='Wolters_Kluwer_Logo';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = UserInfo.getUserId();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        doc.body=bodyBlob;
        insert doc;

        //Creating Account
          Account acc = new Account();
          acc.name = 'Test Account';
          insert acc;

        Contact con=new Contact();
        con.Accountid=acc.id;
        con.FirstName='Test';
        con.LastName='contact';
        con.Email='test@test.com';
        insert con;

          //Creating Opportunity
          Opportunity opp = new Opportunity();
          opp.name = 'Test Opp';
          opp.Invoiced_Amount__c = 2000;
          opp.AccountId = acc.id;
          opp.StageName = 'Present Solution';
          opp.CloseDate = System.Today()+5;
          
          insert opp;

           SBQQ__Quote__c quote1=new SBQQ__Quote__c();
           quote1.SBQQ__Account__c = acc.Id;
           quote1.SBQQ__Status__c='Draft';
           quote1.SBQQ__Opportunity2__c=opp.id;
           quote1.SBQQ__PrimaryContact__c=con.id;

           insert quote1;

           //Pricebook2 standardPB = Test.getStandardPricebookId();



           


        Product2[] products = new Product2[0];
        Product2 p1 = new Product2(Name='Prod1',ProductCode='PROD1', IsActive=true);
        Product2 p2 = new Product2(Name='Prod2',ProductCode='PROD2', IsActive=true);
        Product2 p3 = new Product2(Name='Prod3',ProductCode='PROD3', IsActive=true);
       
        
        products.add(p1);
        products.add(p2);
        products.add(p3);

        insert products;

        SBQQ__ProductFeature__c feat= new SBQQ__ProductFeature__c();
        feat.Name='Fees';
        feat.SBQQ__ConfiguredSKU__c=p3.id;
        feat.SBQQ__MinOptionCount__c=0;
        feat.SBQQ__Number__c=1;
        insert feat;
/*         [Select id from SBQQ__ProductFeature__c where Name='Fees' LIMIT 1];
           feat.SBQQ__ConfiguredSKU__c=p3.id;
           update feat;
*/
           SBQQ__ProductOption__c opt=new SBQQ__ProductOption__c();
           opt.SBQQ__OptionalSKU__c=p3.id;
           opt.SBQQ__ConfiguredSKU__c=p3.id;
           opt.SBQQ__Feature__c=feat.id;
           opt.SBQQ__Number__c=1;
           insert opt;


        //List<PricebookEntry> priceEntires=new List<PricebookEntry>();

        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p1.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //priceEntires.add(new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = p3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false,StandardPrice=0));
        //insert priceEntires;


        SBQQ__QuoteLine__c[] lines1 = new SBQQ__QuoteLine__c[0];
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p1.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=1);
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p2.Id , SBQQ__ListPrice__c = 100, SBQQ__Quantity__c=10);
        SBQQ__QuoteLine__c line3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote1.Id, SBQQ__Product__c=p3.Id , SBQQ__ListPrice__c = 0, SBQQ__Quantity__c=1);
        
        lines1.add(line1);
        lines1.add(line2);
        lines1.add(line3);

        insert lines1;
/*
        invoiceit_s__Currency__c myusd=[Select id from invoiceit_s__Currency__c where Name='USD' LIMIT 1];

        invoiceit_s__Job__c ord=new invoiceit_s__Job__c();
        ord.invoiceit_s__Account__c=acc.id;
        ord.invoiceit_s__CurrencyL__c=myusd.id;

        insert ord;

        quote1.QTC__Order__c=ord.id;
        update quote1;
*/
        cls_email_template_quotelines etql=new cls_email_template_quotelines();
        etql.myQuoteId=quote1.id;
        //etql.getmyFeeLines();
        //etql.getmyPaymentDetails();
        //etql.getmyQuoteLines();
        //etql.getmyQuoteDetails();
        //etql.gethasFees();
        //etql.getvisibility();
        String testString=etql.myLogoPath;

    }
}