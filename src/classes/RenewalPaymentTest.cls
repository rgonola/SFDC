@isTest
public with sharing class RenewalPaymentTest{
    static testMethod void RenewalPayment() {
         IIT_TestClassForUassage.insertCustomSetting();

         list<Invoiceit_s__Configuration__c> objects = new list<Invoiceit_s__Configuration__c>();
        
        Invoiceit_s__Configuration__c c1 =  new Invoiceit_s__Configuration__c(Name = 'PID_last', invoiceit_s__Number_Value__c= 1000); 
         objects.add((Invoiceit_s__Configuration__c) c1);
         
         Invoiceit_s__Configuration__c c2 =  new Invoiceit_s__Configuration__c(Name = 'CID_last', invoiceit_s__Number_Value__c= 1000); 
         objects.add((Invoiceit_s__Configuration__c) c2);
         
         //insert objects;
        
         //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.IsActive=true;
        insert prod;
        
          Product2 prod1 = new Product2();
        prod1.Name = 'Sales Tax';
        prod1.Family = 'Hardware';
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
        po.SBQQ__Bundled__c = true;
        po.SBQQ__Required__c = true;
        insert po;
        
        //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
        
        insert new Pricebook__c(Name = 'Pricebook2016',Pricebookid__c= priceBook.id);
        
        //Insert PriceBook Entry
        PricebookEntry priceBookEtry= new PricebookEntry();
        priceBookEtry.Pricebook2Id = priceBook.Id;
        priceBookEtry.Product2Id = prod.Id;
        priceBookEtry.UnitPrice = 12000; 
        priceBookEtry.IsActive = true;
        insert priceBookEtry;
        
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
        
        //insert Opportunity 
        Opportunity opp = new Opportunity();
        opp.AccountId = account.id;
        opp.CloseDate = System.today();
        opp.Renewal_Quote__c=true;
        opp.StageName = 'Validation';
        opp.Name = 'Opportunity Test';
        opp.ForecastCategoryName = 'Medium Probability';
        opp.Product__c = 'ATX';
        insert opp;    
        
        
        
        
        
        //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Opportunity2__c = opp.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.Web_Renewal__c=true;
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote;
        //insert cart
        cart__c cc =new cart__C();
        cc.cart_Account__c=account.id;
        cc.Total_Price__c=2000;
        insert cc;
        
        
            
        //insert cartlines
        Cart_Line__c cl =new Cart_Line__c();
        cl.Cart__c=cc.id;
        cl.Product__c=prod.id;
        cl.Quantity__c=1;
       // cl.Option_Id__c= ;
        insert cl;
        
        //cookie 
        Cookie cooky = new Cookie('rcid', cc.Id, null, 1209600, false); 
            ApexPages.currentPage().setCookies(new Cookie[]{cooky }); 
        //Create Opportunity
        Web_Opp__c op =new Web_Opp__c ();
        op.Name= 'weborder'+''+datetime.now();
        op.WebAccount__c= account.id;
        op.Amount__c = 1000;
        op.CloseDate__c = Date.today();
        op.StageName__c= 'Negotiation';
        op.Product_c__c ='Web-Order';
        op.web_quote__c =cpqQuote.id;
        op.Type__c='New to New';
         insert op;
        //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine.SBQQ__Product__c= prod.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine;
        
        
          
        SBQQ__ProductOption__c ml=new SBQQ__ProductOption__c (SBQQ__ConfiguredSKU__c=prod.id,SBQQ__OptionalSKU__c=prod.id
                                    ,SBQQ__Feature__c =prod1.id ,Display_Type__c='Radio', SBQQ__Bundled__c =TRUE,SBQQ__Required__c = true);
        
          //Insert QuoteLine
       SBQQ__QuoteLine__c cpqQuoteLine1 =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine1.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine1.SBQQ__Product__c= prod1.id;
        cpqQuoteLine1.SBQQ__Quantity__c = 1;
        cpqQuoteLine1.SBQQ__ListPrice__c = 100;
        cpqQuoteLine1.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine1.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine1;
        
        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD',invoiceit_s__Symbol__c = '$');    
        insert currency1;
        
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
        
            
            //opp.QTC__Create_Order__c = true;
           // update opp;
        
        //Insert Payment Method
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
        
         //Insert Payment Method
        invoiceit_s__Payment_Method__c PM1 = new invoiceit_s__Payment_Method__c();
        PM1.invoiceit_s__Account__c = account.id;
        PM1.invoiceit_s__Active__c = true;
        
        PM1.invoiceit_s__Billing_Address__c = 'Bangalore';
        PM1.invoiceit_s__Billing_Country__c = 'US';
        PM1.invoiceit_s__Billing_Email__c = 'test@gmail.com';
        PM1.invoiceit_s__Billing_First_Name__c= 'Invoice';
        PM1.invoiceit_s__Billing_Last_Name__c = 'IT';
        PM1.invoiceit_s__Billing_State_Province__c= 'CA';
        PM1.invoiceit_s__Billing_Zip_Postal__c= '56009';
        PM1.invoiceit_s__Card_Expiration_Month__c  = '11';
        PM1.invoiceit_s__Card_Expiration_Year__c= '2019';
        PM1.invoiceit_s__Card_Number__c= '4111111111111111';
        PM1.invoiceit_s__Card_Type__c= 'Visa';
        PM1.invoiceit_s__Name_on_Card__c='Naveen';
        PM1.invoiceit_s__Payment_Method__c = 'Credit Card';
        
        insert PM1;
        
        
        
        //Insert Pyament plan
        invoiceit_s__Payment_Plan__c paymentPlan = new invoiceit_s__Payment_Plan__c();
        paymentPlan.Name = 'Test PaymentPlan';
        //paymentPlan.invoiceit_s__Down_Payment__c = 5;
        paymentPlan.invoiceit_s__Down_Payment_Amount__c =6;
        paymentPlan.Down_Payment_Criteria__c ='Sales Tax;Down Payment Amount';
        paymentPlan.Payment_Methods__c = 'Credit Card;COA;ACH';
        paymentPlan.invoiceit_s__Minimum_Installments__c = 2;
        paymentPlan.invoiceit_s__Maximum_Installments__c =6;
        paymentPlan.Payments_Date_Range__c= system.today();
        paymentPlan.End_Date__c = system.today().addYears(2);
        paymentPlan.Max_Number_of_Payment_Methods__c = 3;
        Insert paymentPlan;
        
        //Insert Pyament plan
        invoiceit_s__Payment_Plan__c paymentPlan1 = new invoiceit_s__Payment_Plan__c();
        paymentPlan1.Name = 'Test PaymentPlan';
        //paymentPlan1.invoiceit_s__Down_Payment__c = 5;
        paymentPlan1.invoiceit_s__Down_Payment_Amount__c =6;
        paymentPlan1.Down_Payment_Criteria__c ='Sales Tax;Down Payment Amount';
        paymentPlan1.Payment_Methods__c = 'Credit Card;COA;ACH';
        paymentPlan1.invoiceit_s__Minimum_Installments__c = 2;
        paymentPlan1.invoiceit_s__Maximum_Installments__c =6;
        //paymentPlan1.Payments_Date_Range__c= system.today();
        paymentPlan1.End_Date__c = system.today().addYears(-1);
        paymentPlan1.Max_Number_of_Payment_Methods__c = 3;
        Insert paymentPlan1;
        
        
        cpqQuote.QTC__Payment_Plan__c= paymentPlan.id;
        cpqQuote.Tax_Grand_Total__c = 100;
        cpqQuote.Tax__c=10;
        cpqQuote.SBQQ__Primary__c=true;
        cpqQuote.Tax_Time_Stamp__c =  system.now().addHours(-2);
        update cpqQuote;
        //insert payment paln installment 
        invoiceit_s__Payment_Plan_Installment__c paymentPlanInstallment =  new invoiceit_s__Payment_Plan_Installment__c();
        paymentPlanInstallment.invoiceit_s__Account__c = account.id;
        paymentPlanInstallment.invoiceit_s__Payment_Date__c = system.today();
        paymentPlanInstallment.QTC__Quote__c = cpqQuote.id;
        paymentPlanInstallment.invoiceit_s__Payment_Type__c = 'Credit Card';
        paymentPlanInstallment.Payment_Method1__c = PM.id;
        paymentPlanInstallment.Min_Down_Payment__c =true;
        paymentPlanInstallment.invoiceit_s__Payment_Amount__c = 50;
        
        insert paymentPlanInstallment;
        
        invoiceit_s__Payment_Plan_Installment__c paymentPlanInstallment1 =  new invoiceit_s__Payment_Plan_Installment__c();
        paymentPlanInstallment1.invoiceit_s__Account__c = account.id;
        paymentPlanInstallment1.invoiceit_s__Payment_Date__c = system.today();
        paymentPlanInstallment1.QTC__Quote__c = cpqQuote.id;
        paymentPlanInstallment1.invoiceit_s__Payment_Type__c = 'Credit Card';
        paymentPlanInstallment1.Payment_Method1__c = PM.id;
        paymentPlanInstallment1.Min_Down_Payment__c =true;
        paymentPlanInstallment1.invoiceit_s__Payment_Amount__c = 50;
        
        insert paymentPlanInstallment1;
       
      
                            
                 Test.StartTest(); 
                
                 PageReference pageRef1 = Page.RenewalPaymentPage;
           
                pageRef1.getParameters().put('SFDCCartID', String.valueOf(cc.id));
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController sc1 = new ApexPages.StandardController(account);
 
                RenewalPaymentExtension testAccPlan1 = new RenewalPaymentExtension(sc1);
                testAccPlan1.ccpm.invoiceit_s__Account__c = account.id;
                testAccPlan1.ccpm.invoiceit_s__Card_Number__c = '';
                testAccPlan1.savecc();

                testAccPlan1.ccpm.invoiceit_s__Card_Number__c = '4111111111111111';
                testAccPlan1.ccpm.invoiceit_s__Billing_First_Name__c= '';
                testAccPlan1.savecc();

                testAccPlan1.ccpm.invoiceit_s__Billing_First_Name__c= 'Invoice';
                testAccPlan1.ccpm.invoiceit_s__Billing_Last_Name__c = '';
                testAccPlan1.savecc();

                testAccPlan1.ccpm.invoiceit_s__Billing_Last_Name__c = 'IT';
                testAccPlan1.ccpm.invoiceit_s__Card_Expiration_Month__c = null;
                testAccPlan1.savecc();
                
                testAccPlan1.ccpm.invoiceit_s__Card_Number__c = '4111111111111111';
                testAccPlan1.ccpm.invoiceit_s__Card_Expiration_Month__c = '11';
                testAccPlan1.ccpm.invoiceit_s__Card_Expiration_Year__c= '';
                testAccPlan1.savecc();
                
                testAccPlan1.ccpm.invoiceit_s__Card_Number__c = '4111111111111111';
                testAccPlan1.ccpm.invoiceit_s__Card_Expiration_Year__c = '2020';
                testAccPlan1.ccpm.invoiceit_s__Card_Type__c = null;
                testAccPlan1.savecc();
                
                testAccPlan1.ccpm.invoiceit_s__Card_Number__c = '4111111111111111';
                testAccPlan1.ccpm.invoiceit_s__Card_Type__c = 'VISA';
                testAccPlan1.ccpm.invoiceit_s__CVV__c = null;
                testAccPlan1.savecc();
                
                testAccPlan1.ccpm.invoiceit_s__Card_Number__c = '4111111111111111';
                testAccPlan1.ccpm.invoiceit_s__CVV__c = '12';
                testAccPlan1.savecc();
                
                testAccPlan1.ccpm.invoiceit_s__Card_Number__c = '4111111111111111';
                testAccPlan1.ccpm.invoiceit_s__CVV__c = '125';
                testAccPlan1.savecc();

                testAccPlan1.ccpm.invoiceit_s__Active__c = true; 
                testAccPlan1.ccpm.Same_as_Shipping_Add__c=false;
                testAccPlan1.ccpm.invoiceit_s__Billing_Address__c = '';
                testAccPlan1.savecc();  

                testAccPlan1.ccpm.invoiceit_s__Billing_Address__c = 'Bangalore';
                testAccPlan1.ccpm.invoiceit_s__Billing_City__c = '';
                testAccPlan1.savecc();
                
                testAccPlan1.ccpm.invoiceit_s__Billing_City__c = 'city';
                testAccPlan1.ccpm.invoiceit_s__Billing_Country__c = '';
                testAccPlan1.savecc();
                
                testAccPlan1.ccpm.invoiceit_s__Billing_State_Province__c= 'CA';
                testAccPlan1.ccpm.invoiceit_s__Billing_Zip_Postal__c= '';
                testAccPlan1.savecc();

                testAccPlan1.ccpm.invoiceit_s__Billing_Zip_Postal__c= '56009';
                testAccPlan1.savecc();

               
                
                
                
                
                
                
                
               
                RenewalPaymentExtension testAccPlan2 = new RenewalPaymentExtension(sc1);
                testAccPlan2.achpm.invoiceit_s__Billing_First_Name__c = '';
                testAccPlan2.saveAch();
                testAccPlan2.achpm.invoiceit_s__Billing_First_Name__c = 'TestName1';
                testAccPlan2.achpm.invoiceit_s__Billing_Last_Name__c = '';
                testAccPlan2.saveAch();
                testAccPlan2.achpm.invoiceit_s__Billing_Last_Name__c = 'TestName2';
                testAccPlan2.achpm.invoiceit_s__Bank_Routing_Code__c = '';
                testAccPlan2.saveAch();
                testAccPlan2.achpm.invoiceit_s__Bank_Routing_Code__c = '111000256';
                testAccPlan2.achpm.invoiceit_s__Bank_Account_Number__c = '';
                testAccPlan2.saveAch();
                testAccPlan2.achpm.invoiceit_s__Bank_Account_Number__c = '2019123456789654';
                testAccPlan2.achpm.invoiceit_s__Bank_Account_Type__c = '';
                testAccPlan2.saveAch();
                testAccPlan2.achpm.invoiceit_s__Bank_Account_Type__c = 'Checking';
                testAccPlan2.achpm.invoiceit_s__Bank_Name__c = '';
                testAccPlan2.saveAch();
                testAccPlan2.achpm.invoiceit_s__Bank_Name__c = 'Chase';
                testAccPlan2.saveAch();
                
                testAccPlan2.achpm.invoiceit_s__Active__c = true; 
                testAccPlan2.achpm.Same_as_Shipping_Add__c=false;
                testAccPlan2.achpm.invoiceit_s__Billing_Address__c = '';
                testAccPlan2.saveAch();  

                testAccPlan2.achpm.invoiceit_s__Billing_Address__c = 'Bangalore';
                testAccPlan2.achpm.invoiceit_s__Billing_City__c = '';
                testAccPlan2.saveAch();
                
                testAccPlan2.achpm.invoiceit_s__Billing_City__c = 'city';
                testAccPlan2.achpm.invoiceit_s__Billing_Country__c = '';
                testAccPlan2.saveAch();
                
                testAccPlan2.achpm.invoiceit_s__Billing_State_Province__c= 'CA';
                testAccPlan2.achpm.invoiceit_s__Billing_Zip_Postal__c= '';
                testAccPlan2.saveAch();

                testAccPlan2.achpm.invoiceit_s__Billing_Zip_Postal__c= '56009';
                testAccPlan2.saveAch();

                RenewalPaymentExtension testAccPlan3 = new RenewalPaymentExtension(sc1);
                testAccPlan3.qute.SBQQ__ShippingName__c = '';
                testAccPlan3.editShippingaddress();
                testAccPlan3.qute.SBQQ__ShippingName__c = 'new Shipping';     
                testAccPlan3.qute.SBQQ__ShippingCity__c = '';
                testAccPlan3.editShippingaddress();
                testAccPlan3.qute.SBQQ__ShippingCity__c ='TestCity';
                testAccPlan3.qute.SBQQ__ShippingState__c = '';
                testAccPlan3.editShippingaddress();
                testAccPlan3.qute.SBQQ__ShippingState__c ='CA';
                testAccPlan3.qute.SBQQ__ShippingPostalCode__c = '';
                testAccPlan3.editShippingaddress();
                testAccPlan3.qute.SBQQ__ShippingPostalCode__c = '94538';
                testAccPlan1.editShippingaddress();
                
                RenewalPaymentExtension testAccPlan4 = new RenewalPaymentExtension(sc1);
                testAccPlan4.qute.Primay_Phone__c = '';
                testAccPlan4.editaccinfo();
                
                testAccPlan4.qute.Primay_Phone__c = '5107179958';     
                testAccPlan4.qute.Primary_Email__c = '';
                testAccPlan4.editaccinfo();
                
                testAccPlan4.qute.Primay_Phone__c ='5107179958';
                testAccPlan4.qute.Primary_Email__c = 'abcdtest@gmail.com';
                testAccPlan4.editaccinfo();

                
                //testAccPlan1.displymnt=PM;
                testAccPlan1.pid=testAccPlan1.ccpm.id;       
                testAccPlan1.createCase();
                pageRef1.getParameters().put('pymnhg', String.valueOf(testAccPlan1.ccpm.id));
                testAccPlan1.editrenewalcart();
                testAccPlan1.onSubmit();
                testAccPlan1.CreatePayment();
                testAccPlan1.createorder();
                
                
                testAccPlan1.qute.Tax_Time_Stamp__c = system.now().addhours(-25);
                testAccPlan1.salestx(); 
                //testAccPlan1.qute.Tax_Time_Stamp__c = true;
                testAccPlan1.renewallog();
                //testAccPlan1.deletePymnt();
                testAccPlan1.displymnt.invoiceit_s__Billing_First_Name__c = '';  
                testAccPlan1.editCard(); 
                testAccPlan1.displymnt.invoiceit_s__Billing_First_Name__c = 'Test1'; 
                testAccPlan1.displymnt.invoiceit_s__Billing_Last_Name__c = ''; 
                testAccPlan1.editCard(); 
                testAccPlan1.displymnt.invoiceit_s__Billing_Last_Name__c = 'test2'; 
                testAccPlan1.displymnt.invoiceit_s__Card_Expiration_Month__c  = '';
                testAccPlan1.editCard();
                testAccPlan1.displymnt.invoiceit_s__Card_Expiration_Month__c  = '11';    
                testAccPlan1.displymnt.invoiceit_s__Card_Expiration_Year__c = '';
                testAccPlan1.editCard();
                testAccPlan1.displymnt.invoiceit_s__Card_Expiration_Year__c = '2019';
                testAccPlan1.displymnt.invoiceit_s__CVV__c = '368';
                testAccPlan1.editCard();
                testAccPlan1.displymnt.invoiceit_s__Card_Type__c ='';  
                testAccPlan1.editCard();
                testAccPlan1.displymnt.invoiceit_s__Card_Type__c ='American Express';  
                
                //testAccPlan1.displymnt.invoiceit_s__CVV__c = '368';
                testAccPlan1.displymnt.invoiceit_s__CVV__c  = '4587';
                testAccPlan1.displymnt.Same_as_Shipping_Add__c  = True;
                testAccPlan1.editCard();


                testAccPlan1.displymnt.invoiceit_s__Active__c = true; 
                testAccPlan1.displymnt.Same_as_Shipping_Add__c=false;
                testAccPlan1.displymnt.invoiceit_s__Billing_Address__c = '';
                testAccPlan1.editcard();  

                testAccPlan1.displymnt.invoiceit_s__Billing_Address__c = 'Bangalore';
                testAccPlan1.displymnt.invoiceit_s__Billing_City__c = '';
                testAccPlan1.editcard();
                
                testAccPlan1.displymnt.invoiceit_s__Billing_City__c = 'city';
                testAccPlan1.displymnt.invoiceit_s__Billing_Country__c = '';
                testAccPlan1.editcard();
                
                testAccPlan1.displymnt.invoiceit_s__Billing_State_Province__c= 'CA';
                testAccPlan1.displymnt.invoiceit_s__Billing_Zip_Postal__c= '';
                testAccPlan1.editcard();

                testAccPlan1.displymnt.invoiceit_s__Billing_Zip_Postal__c= '56009';
                testAccPlan1.editcard();

               // testAccPlan1.displymnt.invoiceit_s__CVV__c ='567';
                
               
                
                testAccPlan1.displymnt.invoiceit_s__Billing_First_Name__c = '';
                testAccPlan1.editAch();
                testAccPlan1.displymnt.invoiceit_s__Billing_First_Name__c = 'Editedtest1';
                testAccPlan1.displymnt.invoiceit_s__Billing_Last_Name__c = '';
                testAccPlan1.editAch();
                testAccPlan1.displymnt.invoiceit_s__Billing_Last_Name__c = 'Editedtest2';
                testAccPlan1.displymnt.invoiceit_s__Bank_Routing_Code__c = '';
                testAccPlan1.editAch();
                testAccPlan1.displymnt.invoiceit_s__Bank_Routing_Code__c = '111000256';
                testAccPlan1.displymnt.invoiceit_s__Bank_Account_Number__c = '';
                testAccPlan1.editAch();
                testAccPlan1.displymnt.invoiceit_s__Bank_Account_Number__c = '2019123456789654';
                testAccPlan1.displymnt.invoiceit_s__Bank_Account_Type__c = '';
                testAccPlan1.editAch();
                testAccPlan1.displymnt.invoiceit_s__Bank_Account_Type__c = 'Checking';
                testAccPlan1.displymnt.invoiceit_s__Bank_Name__c = '';
                testAccPlan1.editAch();
                testAccPlan1.displymnt.invoiceit_s__Bank_Name__c = 'CitiBank';
                testAccPlan1.displymnt.Same_as_Shipping_Add__c  = True;
                testAccPlan1.editAch();


                testAccPlan1.displymnt.invoiceit_s__Active__c = true; 
                testAccPlan1.displymnt.Same_as_Shipping_Add__c=false;
                testAccPlan1.displymnt.invoiceit_s__Billing_Address__c = '';
                testAccPlan1.editAch();  

                testAccPlan1.displymnt.invoiceit_s__Billing_Address__c = 'Bangalore';
                testAccPlan1.displymnt.invoiceit_s__Billing_City__c = '';
                testAccPlan1.editAch();
                
                testAccPlan1.displymnt.invoiceit_s__Billing_City__c = 'city';
                testAccPlan1.displymnt.invoiceit_s__Billing_Country__c = '';
                testAccPlan1.editAch();
                
                testAccPlan1.displymnt.invoiceit_s__Billing_State_Province__c= 'CA';
                testAccPlan1.displymnt.invoiceit_s__Billing_Zip_Postal__c= '';
                testAccPlan1.editAch();

                testAccPlan1.displymnt.invoiceit_s__Billing_Zip_Postal__c= '56009';
                testAccPlan1.editAch();
                
                testAccPlan1.salestx();
                
                //testAccPlan1.savecc();
                 Test.StopTest(); 
                  
         
          }
          
        
          }