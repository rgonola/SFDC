@isTest


(seeAllData=true)
global class TestInvoiceData{
      static testMethod void testBatchClass() {
        
        String query='SELECT Name,id,Fulfilment_Date__c,Reg_Code__c,Product_Yearx__c,RegCode_Required__c,invoiceit_s__Order__c,Product_Code__c'+ 
        'from invoiceit_s__Job_Rate_Plan_Charge__c where Reg_Code__c=null and Fulfilment_Date__c <=Today limit 50';
        
        
        Account acctToUpdate = new Account(Name = 'Test Account88', Type = 'Customer8',CID__c='12345');
        insert acctToUpdate;
        
        invoiceit_s__Currency__c curr=new invoiceit_s__Currency__c(Name='Currency',invoiceit_s__Currency_Name__c='USD',invoiceit_s__Currency_Symbol__c='$');
        insert curr;
       
        invoiceit_s__Job__c invoiceOrder= new invoiceit_s__Job__c(Name=acctToUpdate.Name,invoiceit_s__Account__c=acctToUpdate.Id,
        invoiceit_s__CurrencyL__c=curr.Id);
        insert invoiceOrder; 
        
        invoiceit_s__Job_Product__c product=new invoiceit_s__Job_Product__c(Name='Product1',invoiceit_s__Job__c=invoiceOrder.Id);
        insert product;
        
        invoiceit_s__Job_Rate_Plan__c ratePlan= new invoiceit_s__Job_Rate_Plan__c(Name='768cczxc',invoiceit_s__Job_Product__c=product.Id);
        insert ratePlan;
        
        List<invoiceit_s__Job_Rate_Plan_Charge__c> ratePlanCharges=new List<invoiceit_s__Job_Rate_Plan_Charge__c>();
        
        //for(integer i=0; i<=50;i++){
            invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge=new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
            invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Status__c='IN-Progress',
            invoiceit_s__Order__c=invoiceOrder.Id);
            ratePlanCharges.add(ratePlanCharge);
        //}
        
        
        insert ratePlanCharges; 
        
       //Database.executeBatch(regCode,ratePlanCharges.size());
        
        Test.startTest();
        UpdateRegCode regCode= new UpdateRegCode();
        Database.executeBatch(regCode);
        regCode.start(null);
        regCode.execute(null,ratePlanCharges); 
        for(invoiceit_s__Job_Rate_Plan_Charge__c rtPlanCharge:ratePlanCharges){
        System.assertEquals(invoiceOrder.Id,rtPlanCharge.invoiceit_s__Order__c);
        }
        regCode.finish(null);
        Test.stopTest();
        
      
        
      
      // Integer i = [SELECT COUNT() FROM invoiceit_s__Job_Rate_Plan_Charge__c ];
       //System.assertEquals(i, 0);
        
    }
    
    static testMethod void priorregtest() {
        
        String query='SELECT Name,id,Fulfilment_Date__c,Reg_Code__c,Product_Yearx__c,RegCode_Required__c,invoiceit_s__Order__c,Product_Code__c'+ 
        'from invoiceit_s__Job_Rate_Plan_Charge__c where Reg_Code__c=null and Fulfilment_Date__c <=Today limit 50';
        
        
        Account acctToUpdate = new Account(Name = 'Test Account88', Type = 'Customer8',CID__c='12345');
        insert acctToUpdate;
        
        invoiceit_s__Currency__c curr=new invoiceit_s__Currency__c(Name='Currency',invoiceit_s__Currency_Name__c='USD',invoiceit_s__Currency_Symbol__c='$');
        insert curr;
       
        invoiceit_s__Job__c invoiceOrder= new invoiceit_s__Job__c(Name=acctToUpdate.Name,invoiceit_s__Account__c=acctToUpdate.Id,
        invoiceit_s__CurrencyL__c=curr.Id);
        insert invoiceOrder; 
        
        invoiceit_s__Job_Product__c product=new invoiceit_s__Job_Product__c(Name='Product1',invoiceit_s__Job__c=invoiceOrder.Id);
        insert product;
        
        invoiceit_s__Job_Rate_Plan__c ratePlan= new invoiceit_s__Job_Rate_Plan__c(Name='768cczxc',invoiceit_s__Job_Product__c=product.Id);
        insert ratePlan;
        
        List<invoiceit_s__Job_Rate_Plan_Charge__c> ratePlanCharges=new List<invoiceit_s__Job_Rate_Plan_Charge__c>();
        
        //for(integer i=0; i<=50;i++){
            invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge=new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
            invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Status__c='IN-Progress',
            invoiceit_s__Order__c=invoiceOrder.Id);
            ratePlanCharges.add(ratePlanCharge);
        //}
        
        
        insert ratePlanCharges; 
        
       //Database.executeBatch(regCode,ratePlanCharges.size());
        
        Test.startTest();
        UpdatePriorRegCode regCode= new UpdatePriorRegCode();
        Database.executeBatch(regCode);
        regCode.start(null);
        regCode.execute(null,ratePlanCharges); 
        for(invoiceit_s__Job_Rate_Plan_Charge__c rtPlanCharge:ratePlanCharges){
        System.assertEquals(invoiceOrder.Id,rtPlanCharge.invoiceit_s__Order__c);
        }
        regCode.finish(null);
        Test.stopTest();
        
      
        
      
      // Integer i = [SELECT COUNT() FROM invoiceit_s__Job_Rate_Plan_Charge__c ];
       //System.assertEquals(i, 0);
        
    }
    
  /*  static testMethod void testInvoiceBatchReport() {
        
        String query='Select id,invoiceit_s__Account__c ,invoiceit_s__Invoice_Date__c,Invoice_Sent_Formatted__c,Account_CID__c,Account_PID__c,invoiceit_s__Order__c,'+
            'Name,invoiceit_s__Paid_Amount__c,invoiceit_s__Tax__c,Last_Payment_Type__c,Order_Value__c from invoiceit_s__Invoice__c where invoiceit_s__Invoice_Date__c >=2016-04-06 and '
            +'invoiceit_s__Invoice_Status__c= \''
            + String.escapeSingleQuotes('Posted') + '\' limit 50' ;
            
      
        Test.startTest();
        InvoiceReportBatch icrBatch= new InvoiceReportBatch();
        icrBatch.query=query;
        Database.executeBatch(icrBatch,20);
         
       Test.stopTest();
     
    }
    
    static testMethod void testCreditNoteBatchReport() {
        
        String query='Select CreatedDate,Id,Name,invoiceit_s__Account__c from invoiceit_s__Credit_Note__c where CreatedDate>=2016-04-01T23:59:59Z limit 50';
      
        Test.startTest();
         CreditNoteReportBatch CRBatch= new CreditNoteReportBatch();
         CRBatch.query=query;
         Database.executeBatch(CRBatch,50);
         
       Test.stopTest();
     
    }*/
       
      
     static testMethod void testHandleStaging() { 
         
         
        
         Test.startTest();
        system.debug('Inside test method Handle staging');
        
        Account acctToUpdate = new Account(Brand__c='ATX',Name = 'Test Account88', OFFC__c=0,Type = 'Customer8',Prior_Software_Vendor__c='abc',
        CC_on_File__c=true,Cutoff__c=true,Primary_Contact_Name__c='Primary Contact', Email__c='usha1.mp@gmail.com',Phone='978899403',Fax='4335642',
        Primary_MobilePhone__c='5227686',Billing_Contact_Email__c='Billing2.Contact@gmail.com',BillingStreet='Billing street',Billing_Address_2__c='Billling Address',
        BillingCity='BillingCity',BillingState='BillingState',BillingPostalCode='344566',BillingCountry='Country',Shipping_Contact_Email__c='fdfsd1@gmail.com',ShippingStreet='ShippingStreet',
        Shipping_Address_2__c='ShippingAddress',ShippingCity='ShippingCity',ShippingState='ShippingState',ShippingPostalCode='78999',ShippingCountry='Country',
        CID__c='908654');
        insert acctToUpdate;
        
        system.debug(' acctToUpdate **'+acctToUpdate );
        
       
       invoiceit_s__Currency__c curr=new invoiceit_s__Currency__c(Name='AUS',invoiceit_s__Currency_Name__c='AUS',invoiceit_s__Currency_Symbol__c='$');
       insert curr;
   
        Contract contract =new Contract(name='Contract',AccountId=acctToUpdate.Id); 
        insert contract;
         
        Opportunity oppItem = new Opportunity(Name = 'Test Opp222', AccountId = acctToUpdate.Id, CloseDate = System.today()-7, StageName = 'Active', 
        Refund_Customer_type__c = 'Prospect',Which_other_products_considered__c='Drake',What_was_the_previously_used_product__c='Lacerte');
        insert oppItem;
       
        invoiceit_s__Job__c invoiceOrder= new invoiceit_s__Job__c(Name='Name',invoiceit_s__CurrencyL__c=curr.Id,invoiceit_s__Account__c=acctToUpdate.Id,invoiceit_s__Total_Contract_Value__c=8);
        
        //invoiceit_s__Job__c invoiceOrder= new invoiceit_s__Job__c(invoiceit_s__CurrencyL__c=curr.Id,invoiceit_s__Account__c=oppItem.AccountId); 
        
        insert invoiceOrder; 
      
        invoiceit_s__Job_Product__c product=new invoiceit_s__Job_Product__c(Name='Product1',invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Product_Code__c ='PYSUBFEE');
        insert product;
        
        invoiceit_s__Job_Rate_Plan__c ratePlan= new invoiceit_s__Job_Rate_Plan__c(Name='768cczxc',invoiceit_s__Job_Product__c=product.Id);
        insert ratePlan;
        
        
        invoiceit_s__Invoice__c invoice=new invoiceit_s__Invoice__c(invoiceit_s__Order__c=invoiceOrder.Id,invoiceit_s__Account__c=acctToUpdate.Id,RePost_Tax__c=false);
        insert invoice;
        
        
        
        invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge=new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
        invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Net_Total__c=100,invoiceit_s__Tax__c=50,invoiceit_s__Product_Charge_Category__c='Catogory',
        Product_Purchase_Type__c='TX',Training_Contact_Email__c='xx@gmail.com',invoiceit_s__Bundle__c=false,invoiceit_s__Package__c=false,invoiceit_s__Service_Activation_Date__c=System.Today(),
        invoiceit_s__Service_End_Date__c=System.Today(),invoiceit_s__Order__c=invoiceOrder.Id);
        
        insert ratePlanCharge;
        
        product2 prod=new product2(Name='product1',ProductCode='PYSUBFEE');
        insert prod;
        
        SBQQ__Quote__c quote=new SBQQ__Quote__c(SBQQ__Primary__c=true,SBQQ__Type__c='Type',Is_PFX_Promotion__c=true,QTC__Order__c=invoiceOrder.Id,SBQQ__Opportunity2__c=oppItem.Id,Do_It__c=true);
        insert quote;
        
        SBQQ__QuoteLine__c QuoteLine=new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,QTC__Order_Rate_Plan_Charge__c=ratePlanCharge.Id,
        SBQQ__MarkupAmount__c=100,SBQQ__MarkupRate__c=50,SBQQ__Discount__c=5,SBQQ__AdditionalDiscountAmount__c=10,SBQQ__Incomplete__c=true);
        insert QuoteLine;
        
        
        invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge2=new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
        invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Net_Total__c=100,invoiceit_s__Tax__c=50,invoiceit_s__Product_Charge_Category__c='Catogory',
        Product_Purchase_Type__c='TX',Training_Contact_Email__c='xx@gmail.com',invoiceit_s__Bundle__c=true,invoiceit_s__Package__c=false,invoiceit_s__Service_Activation_Date__c=System.Today(),
        invoiceit_s__Service_End_Date__c=System.Today(),invoiceit_s__Order__c=invoiceOrder.Id,invoiceit_s__Required_By__c=ratePlanCharge.Id);
        
        insert ratePlanCharge2;
        
        invoiceit_s__Invoice_Lines__c invoiceLine=new invoiceit_s__Invoice_Lines__c(
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Line_Name__c='xyz',
        invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge.Id);
        
        insert invoiceLine;
        
        invoiceit_s__Product__c prodInfo=new invoiceit_s__Product__c(invoiceit_s__Product_Family__c='Fees');
        insert prodInfo;
        
        invoiceit_s__Invoice_Lines__c fees=new invoiceit_s__Invoice_Lines__c(invoiceit_s__Unit_Price__c=2,invoiceit_s__Sequence_No__c=2,
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Quantity__c=2,
        invoiceit_s__Product_Name__c='PYSUBFEE_2016',invoiceit_s__Line_Name__c='xyz',invoiceit_s__Tax__c=15,invoiceit_s__Product__c=prodInfo.id);
        insert fees;
        
        invoiceit_s__Job_Rate_Plan_Charge_Tier__c tier=new invoiceit_s__Job_Rate_Plan_Charge_Tier__c(invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge2.Id);
        insert tier;
        
        
        
        invoiceit_s__Invoice_Lines__c assemblies=new invoiceit_s__Invoice_Lines__c(
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,
        invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge2.Id);
        insert assemblies;
        
          
        
          
       /* invoiceit_s__Credit_Note__c creditNote=new invoiceit_s__Credit_Note__c
        (invoiceit_s__Related_Invoice__c=invoice.Id,invoiceit_s__Account__c=acctToUpdate.id);
        insert creditNote; */
       
        Id AMFSNSOpportunityRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Opportunity'].Id;
       
       
        
        system.debug('Invoice Id&&'+invoice.Id);
        
        RepostInvoiceTax.Repost(invoice.Id,'Posted');
        
        
       
        
        Test.stopTest(); 
      
     }
  
   static testMethod void pfxHandleStaging() { 
         
         
        
        
        system.debug('Inside test method Handle staging');
        
        Account acctToUpdate = new Account(Brand__c='ATX',Name = 'Test Account88', OFFC__c=0,Type = 'Customer8',Prior_Software_Vendor__c='abc',
        CC_on_File__c=true,Cutoff__c=true,Primary_Contact_Name__c='Primary Contact', Email__c='usha1.mp@gmail.com',Phone='978899403',Fax='4335642',
        Primary_MobilePhone__c='5227686',Billing_Contact_Email__c='Billing2.Contact@gmail.com',BillingStreet='Billing street',Billing_Address_2__c='Billling Address',
        BillingCity='BillingCity',BillingState='BillingState',BillingPostalCode='344566',BillingCountry='Country',Shipping_Contact_Email__c='fdfsd1@gmail.com',ShippingStreet='ShippingStreet',
        Shipping_Address_2__c='ShippingAddress',ShippingCity='ShippingCity',ShippingState='ShippingState',ShippingPostalCode='78999',ShippingCountry='Country',
        CID__c='908654');
        insert acctToUpdate;
        
        system.debug(' acctToUpdate **'+acctToUpdate );
        
       
       invoiceit_s__Currency__c curr=new invoiceit_s__Currency__c(Name='AUS',invoiceit_s__Currency_Name__c='AUS',invoiceit_s__Currency_Symbol__c='$');
       insert curr;
   
        Contract contract =new Contract(name='Contract',AccountId=acctToUpdate.Id); 
        insert contract;
         
        Opportunity oppItem = new Opportunity(Name = 'Test Opp222', AccountId = acctToUpdate.Id, CloseDate = System.today()-7, StageName = 'Active', 
        Refund_Customer_type__c = 'Prospect',Which_other_products_considered__c='Drake',What_was_the_previously_used_product__c='Lacerte');
        insert oppItem;
       
        invoiceit_s__Job__c invoiceOrder= new invoiceit_s__Job__c(Name='Name',invoiceit_s__CurrencyL__c=curr.Id,invoiceit_s__Account__c=acctToUpdate.Id,invoiceit_s__Total_Contract_Value__c=8);
        
        //invoiceit_s__Job__c invoiceOrder= new invoiceit_s__Job__c(invoiceit_s__CurrencyL__c=curr.Id,invoiceit_s__Account__c=oppItem.AccountId); 
        
        insert invoiceOrder; 
      
        invoiceit_s__Job_Product__c product=new invoiceit_s__Job_Product__c(Name='Product1',invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Product_Code__c ='PYSUBFEE');
        insert product;
        
        invoiceit_s__Job_Rate_Plan__c ratePlan= new invoiceit_s__Job_Rate_Plan__c(Name='768cczxc',invoiceit_s__Job_Product__c=product.Id);
        insert ratePlan;
        
        List<invoiceit_s__Invoice__c > Listadv = new List<invoiceit_s__Invoice__c >();

        invoiceit_s__Invoice__c invoice=new invoiceit_s__Invoice__c(invoiceit_s__Order__c=invoiceOrder.Id,invoiceit_s__Account__c=acctToUpdate.Id,RePost_Tax__c=false);
        insert invoice;
        
        Listadv.add(invoice);
        
        invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge=new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
        invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Net_Total__c=100,invoiceit_s__Tax__c=50,invoiceit_s__Product_Charge_Category__c='Catogory',
        Product_Purchase_Type__c='TX',Training_Contact_Email__c='xx@gmail.com',invoiceit_s__Bundle__c=false,invoiceit_s__Package__c=false,invoiceit_s__Service_Activation_Date__c=System.Today(),
        invoiceit_s__Service_End_Date__c=System.Today(),invoiceit_s__Order__c=invoiceOrder.Id);
        
        insert ratePlanCharge;
        
        product2 prod=new product2(Name='product1',ProductCode='PYSUBFEE');
        insert prod;
        
        SBQQ__Quote__c quote=new SBQQ__Quote__c(SBQQ__Primary__c=true,SBQQ__Type__c='Type',Is_PFX_Promotion__c=true,QTC__Order__c=invoiceOrder.Id,SBQQ__Opportunity2__c=oppItem.Id);
        insert quote;
        
        SBQQ__QuoteLine__c QuoteLine=new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,QTC__Order_Rate_Plan_Charge__c=ratePlanCharge.Id,
        SBQQ__MarkupAmount__c=100,SBQQ__MarkupRate__c=50,SBQQ__Discount__c=5,SBQQ__AdditionalDiscountAmount__c=10,SBQQ__Incomplete__c=true);
        insert QuoteLine;
        
        
        invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge2=new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
        invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Net_Total__c=100,invoiceit_s__Tax__c=50,invoiceit_s__Product_Charge_Category__c='Catogory',
        Product_Purchase_Type__c='TX',Training_Contact_Email__c='xx@gmail.com',invoiceit_s__Bundle__c=true,invoiceit_s__Package__c=false,invoiceit_s__Service_Activation_Date__c=System.Today(),
        invoiceit_s__Service_End_Date__c=System.Today(),invoiceit_s__Order__c=invoiceOrder.Id,invoiceit_s__Required_By__c=ratePlanCharge.Id);
        
        insert ratePlanCharge2;
        
        invoiceit_s__Invoice_Lines__c invoiceLine=new invoiceit_s__Invoice_Lines__c(
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Line_Name__c='xyz',
        invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge.Id);
        
        insert invoiceLine;
        
        invoiceit_s__Product__c prodInfo=new invoiceit_s__Product__c(invoiceit_s__Product_Family__c='Fees');
        insert prodInfo;
        
        invoiceit_s__Invoice_Lines__c fees=new invoiceit_s__Invoice_Lines__c(invoiceit_s__Unit_Price__c=2,invoiceit_s__Sequence_No__c=2,
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Quantity__c=2,
        invoiceit_s__Product_Name__c='PYSUBFEE_2016',invoiceit_s__Line_Name__c='xyz',invoiceit_s__Tax__c=15,invoiceit_s__Product__c=prodInfo.id);
        insert fees;
        
        invoiceit_s__Job_Rate_Plan_Charge_Tier__c tier=new invoiceit_s__Job_Rate_Plan_Charge_Tier__c(invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge2.Id);
        insert tier;
        
        
        
        invoiceit_s__Invoice_Lines__c assemblies=new invoiceit_s__Invoice_Lines__c(
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,
        invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge2.Id);
        insert assemblies;
        
          
        
          
       /* invoiceit_s__Credit_Note__c creditNote=new invoiceit_s__Credit_Note__c
        (invoiceit_s__Related_Invoice__c=invoice.Id,invoiceit_s__Account__c=acctToUpdate.id);
        insert creditNote; */
       
        Id AMFSNSOpportunityRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Opportunity'].Id;
       
       
         Test.startTest();
        
        //StagingCallforPfxorder regCode= new StagingCallforPfxorder();
       // Database.executeBatch(new StagingCallforPfxorder(),1);
       
        StagingCallforPfxorder regCode= new StagingCallforPfxorder();
        Database.executeBatch(regCode);
        regCode.start(null);
        regCode.execute(null,Listadv); 
        for(invoiceit_s__Invoice__c rtPlanCharge : Listadv){
        System.assertEquals(false,rtPlanCharge.Is_PFX_Promotion__c);
        }
        regCode.finish(null);
        
        invoice.invoiceit_s__Invoice_Status__c ='Cancelled';
        invoice.invoiceit_s__Cancellation_Reason__c = 'Cancel order';
        update invoice;
        
        
        
        Test.stopTest(); 
      
     }
     
      static testMethod void Cancelinvoice() { 
         
         
        
        
        system.debug('Inside test method Handle staging');
        
        Account acctToUpdate = new Account(Brand__c='ATX',Name = 'Test Account88', OFFC__c=0,Type = 'Customer8',Prior_Software_Vendor__c='abc',
        CC_on_File__c=true,Cutoff__c=true,Primary_Contact_Name__c='Primary Contact', Email__c='usha1.mp@gmail.com',Phone='978899403',Fax='4335642',
        Primary_MobilePhone__c='5227686',Billing_Contact_Email__c='Billing2.Contact@gmail.com',BillingStreet='Billing street',Billing_Address_2__c='Billling Address',
        BillingCity='BillingCity',BillingState='BillingState',BillingPostalCode='344566',BillingCountry='Country',Shipping_Contact_Email__c='fdfsd1@gmail.com',ShippingStreet='ShippingStreet',
        Shipping_Address_2__c='ShippingAddress',ShippingCity='ShippingCity',ShippingState='ShippingState',ShippingPostalCode='78999',ShippingCountry='Country',
        CID__c='908654');
        insert acctToUpdate;
        
        system.debug(' acctToUpdate **'+acctToUpdate );
        
       
       invoiceit_s__Currency__c curr=new invoiceit_s__Currency__c(Name='AUS',invoiceit_s__Currency_Name__c='AUS',invoiceit_s__Currency_Symbol__c='$');
       insert curr;
   
        Contract contract =new Contract(name='Contract',AccountId=acctToUpdate.Id); 
        insert contract;
         
        Opportunity oppItem = new Opportunity(Name = 'Test Opp222', AccountId = acctToUpdate.Id, CloseDate = System.today()-7, StageName = 'Active', 
        Refund_Customer_type__c = 'Prospect',Which_other_products_considered__c='Drake',What_was_the_previously_used_product__c='Lacerte');
        insert oppItem;
       
        invoiceit_s__Job__c invoiceOrder= new invoiceit_s__Job__c(Name='Name',invoiceit_s__CurrencyL__c=curr.Id,invoiceit_s__Account__c=acctToUpdate.Id,invoiceit_s__Total_Contract_Value__c=8);
        
        //invoiceit_s__Job__c invoiceOrder= new invoiceit_s__Job__c(invoiceit_s__CurrencyL__c=curr.Id,invoiceit_s__Account__c=oppItem.AccountId); 
        
        insert invoiceOrder; 
      
        invoiceit_s__Job_Product__c product=new invoiceit_s__Job_Product__c(Name='Product1',invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Product_Code__c ='PYSUBFEE');
        insert product;
        
        invoiceit_s__Job_Rate_Plan__c ratePlan= new invoiceit_s__Job_Rate_Plan__c(Name='768cczxc',invoiceit_s__Job_Product__c=product.Id);
        insert ratePlan;
        
        List<invoiceit_s__Invoice__c > Listadv = new List<invoiceit_s__Invoice__c >();

        invoiceit_s__Invoice__c invoice=new invoiceit_s__Invoice__c(invoiceit_s__Order__c=invoiceOrder.Id,invoiceit_s__Account__c=acctToUpdate.Id,RePost_Tax__c=false);
        insert invoice;
        
        Listadv.add(invoice);
        
        invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge=new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
        invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Net_Total__c=100,invoiceit_s__Tax__c=50,invoiceit_s__Product_Charge_Category__c='Catogory',
        Product_Purchase_Type__c='TX',Training_Contact_Email__c='xx@gmail.com',invoiceit_s__Bundle__c=false,invoiceit_s__Package__c=false,invoiceit_s__Service_Activation_Date__c=System.Today(),
        invoiceit_s__Service_End_Date__c=System.Today(),invoiceit_s__Order__c=invoiceOrder.Id);
        
        insert ratePlanCharge;
        
        product2 prod=new product2(Name='product1',ProductCode='PYSUBFEE');
        insert prod;
        
        SBQQ__Quote__c quote=new SBQQ__Quote__c(SBQQ__Primary__c=true,SBQQ__Type__c='Type',Is_PFX_Promotion__c=true,QTC__Order__c=invoiceOrder.Id,SBQQ__Opportunity2__c=oppItem.Id);
        insert quote;
        
        SBQQ__QuoteLine__c QuoteLine=new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,QTC__Order_Rate_Plan_Charge__c=ratePlanCharge.Id,
        SBQQ__MarkupAmount__c=100,SBQQ__MarkupRate__c=50,SBQQ__Discount__c=5,SBQQ__AdditionalDiscountAmount__c=10,SBQQ__Incomplete__c=true);
        insert QuoteLine;
        
        
        invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge2=new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
        invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Net_Total__c=100,invoiceit_s__Tax__c=50,invoiceit_s__Product_Charge_Category__c='Catogory',
        Product_Purchase_Type__c='TX',Training_Contact_Email__c='xx@gmail.com',invoiceit_s__Bundle__c=true,invoiceit_s__Package__c=false,invoiceit_s__Service_Activation_Date__c=System.Today(),
        invoiceit_s__Service_End_Date__c=System.Today(),invoiceit_s__Order__c=invoiceOrder.Id,invoiceit_s__Required_By__c=ratePlanCharge.Id);
        
        insert ratePlanCharge2;
        
        invoiceit_s__Invoice_Lines__c invoiceLine=new invoiceit_s__Invoice_Lines__c(
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Line_Name__c='xyz',
        invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge.Id);
        
        insert invoiceLine;
        
        invoiceit_s__Product__c prodInfo=new invoiceit_s__Product__c(invoiceit_s__Product_Family__c='Fees');
        insert prodInfo;
        
        invoiceit_s__Invoice_Lines__c fees=new invoiceit_s__Invoice_Lines__c(invoiceit_s__Unit_Price__c=2,invoiceit_s__Sequence_No__c=2,
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Quantity__c=2,
        invoiceit_s__Product_Name__c='PYSUBFEE_2016',invoiceit_s__Line_Name__c='xyz',invoiceit_s__Tax__c=15,invoiceit_s__Product__c=prodInfo.id);
        insert fees;
        
        invoiceit_s__Job_Rate_Plan_Charge_Tier__c tier=new invoiceit_s__Job_Rate_Plan_Charge_Tier__c(invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge2.Id);
        insert tier;
        
        
        
        invoiceit_s__Invoice_Lines__c assemblies=new invoiceit_s__Invoice_Lines__c(
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,
        invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge2.Id);
        insert assemblies;
        
          
        
          
       /* invoiceit_s__Credit_Note__c creditNote=new invoiceit_s__Credit_Note__c
        (invoiceit_s__Related_Invoice__c=invoice.Id,invoiceit_s__Account__c=acctToUpdate.id);
        insert creditNote; */
       
        Id AMFSNSOpportunityRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Opportunity'].Id;
       
       
         Test.startTest();
        
        Triggerflag.firstRun=false;
        
        invoice.invoiceit_s__Invoice_Status__c ='Cancelled';
        invoice.invoiceit_s__Cancellation_Reason__c = 'Cancel order';
        update invoice;
        
        ratePlanCharge.invoiceit_s__Status__c ='Cancelled';
        update ratePlanCharge;
        
        UpdateInvoiceInfoInDM.CancelInvoice(invoice.Id);
        
        Test.stopTest(); 
      
     }
     
     static testMethod void testCallout() {
        // Set mock callout class 
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = HandleStaging.sendRequest('http://api.salesforce.com/foo/bar','GET','','internal',UserInfo.getSessionId());
        system.debug('Response***'+res);
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
      
    }
    
    /*static testMethod void testUpdateRegScheduler(){
        Test.StartTest();
        UpdateRegCodeScheduler updateScheduler=new UpdateRegCodeScheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Update Regcode', sch, updateScheduler); 
        Test.stopTest(); 
    }*/
    
    static testMethod void testCallUpdateRegScheduler(){
        Test.StartTest();
        CallUpdateRegScheduler callRegCode=new CallUpdateRegScheduler();
        String sch = '0 0 22 * * ?'; 
        system.schedule('Test callUpdateReg', sch, callRegCode); 
        Test.stopTest(); 
    }
    
    static testMethod void testCallUpdatepriorRegScheduler(){
        Test.StartTest();
        UpdatePriorRegCodeScheduler  callRegCode=new UpdatePriorRegCodeScheduler ();
        String sch = '0 0 22 * * ?'; 
        system.schedule('Test callUpdateReg', sch, callRegCode); 
        Test.stopTest(); 
    }
    
    static testMethod void testStagingCallforPfxorderScheduler(){
        Test.StartTest();
        StagingCallforPfxorderScheduler callRegCode=new StagingCallforPfxorderScheduler();
        String sch = '0 0 22 * * ?'; 
        system.schedule('Test callUpdateReg', sch, callRegCode); 
        Test.stopTest(); 
    }
    
    static testMethod void testDeleteLogFiles(){
        Test.StartTest();
        DeleteLogFiles deleteLogFiles=new DeleteLogFiles ();
        String sch = '0 0 22 * * ?'; 
        system.schedule('Test Delete flag', sch, deleteLogFiles); 
        Test.stopTest(); 
    }
    
   /* static testMethod void testInvoiceCreditNoteReport(){
        Test.StartTest();
        InvoiceCreditNoteReportScheduler Icr=new InvoiceCreditNoteReportScheduler();
        String sch = '0 0 22 * * ?'; 
        system.schedule('Test ICR', sch, Icr); 
        Test.stopTest(); 
    }*/
   
}