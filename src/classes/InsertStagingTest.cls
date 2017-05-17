@isTest


(seeAllData=true)
global class InsertStagingTest{


 static testMethod void Handle() { 
         
         
       
        
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
        
        
        invoiceit_s__Invoice__c invoice=new invoiceit_s__Invoice__c(invoiceit_s__Order__c=invoiceOrder.Id,invoiceit_s__Account__c=acctToUpdate.Id,Batch_Designation__c='Batch1');
        insert invoice;
        
        
        
        invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge=new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
        invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Net_Total__c=100,invoiceit_s__Tax__c=50,invoiceit_s__Product_Charge_Category__c='Catogory',
        Product_Purchase_Type__c='TX',Training_Contact_Email__c='xx@gmail.com',invoiceit_s__Bundle__c=false,invoiceit_s__Package__c=false,invoiceit_s__Service_Activation_Date__c=System.Today(),
        invoiceit_s__Service_End_Date__c=System.Today(),invoiceit_s__Order__c=invoiceOrder.Id);
        
        insert ratePlanCharge;
        
        product2 prod=new product2(Name='product1',ProductCode='PYSUBFEE');
        insert prod;
        
        SBQQ__Quote__c quote=new SBQQ__Quote__c(SBQQ__Primary__c=true,SBQQ__Type__c='Type',QTC__Order__c=invoiceOrder.Id,SBQQ__Opportunity2__c=oppItem.Id,Do_It__c=true);
        insert quote;
        
        SBQQ__QuoteLine__c QuoteLine=new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,QTC__Order_Rate_Plan_Charge__c=ratePlanCharge.Id,
        SBQQ__MarkupAmount__c=100,SBQQ__MarkupRate__c=50,SBQQ__Discount__c=5,SBQQ__AdditionalDiscountAmount__c=10,SBQQ__Incomplete__c=true);
        insert QuoteLine;
        
        
        invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge2=new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
        invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Net_Total__c=100,invoiceit_s__Tax__c=50,invoiceit_s__Product_Charge_Category__c='Catogory',
        Product_Purchase_Type__c='TX',Training_Contact_Email__c='xx@gmail.com',invoiceit_s__Bundle__c=true,invoiceit_s__Package__c=false,invoiceit_s__Service_Activation_Date__c=System.Today(),
        invoiceit_s__Service_End_Date__c=System.Today(),invoiceit_s__Order__c=invoiceOrder.Id,invoiceit_s__Required_By__c=ratePlanCharge.Id);
        
        insert ratePlanCharge2;
        
        SBQQ__QuoteLine__c QuoteLined=new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,QTC__Order_Rate_Plan_Charge__c=ratePlanCharge2.Id,
        SBQQ__MarkupAmount__c=100,SBQQ__MarkupRate__c=50,SBQQ__Discount__c=5,SBQQ__AdditionalDiscountAmount__c=10,SBQQ__Incomplete__c=true);
        insert QuoteLined;
        
        invoiceit_s__Invoice_Lines__c invoiceLine=new invoiceit_s__Invoice_Lines__c(
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Line_Name__c='xyz',
        invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge.Id);
        
        insert invoiceLine;
        
        invoiceit_s__Invoice_Lines__c invoiceLind=new invoiceit_s__Invoice_Lines__c(
        invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Line_Name__c='xyz',
        invoiceit_s__Job_Rate_Plan_Charge__c=ratePlanCharge2.Id);
        
        insert invoiceLind;
        
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
        
          Test.startTest();
          
          invoice.Create_Json__c=TRUE;
          update invoice;
        //Insertnewstagingtable handleStaging=new Insertnewstagingtable();
        //handleStaging.sendStagingData(invoice.Id);
        
        Test.stopTest(); 
      
     }




}