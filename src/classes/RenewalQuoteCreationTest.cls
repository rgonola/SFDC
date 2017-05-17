@isTest(seeAllData=true)
public class RenewalQuoteCreationTest{

    static testMethod void createquoteTest(){
                 
            Account acctToUpdate = new Account(Brand__c='ATX',Name = 'Test Account88', OFFC__c=0,Type = 'Customer8',Prior_Software_Vendor__c='abc',
            CC_on_File__c=true,Cutoff__c=true,Primary_Contact_Name__c='Primary Contact', Email__c='usha1.mp@gmail.com',Phone='978899403',Fax='4335642',
            Primary_MobilePhone__c='5227686',Billing_Contact_Email__c='Billing2.Contact@gmail.com',BillingStreet='Billing street',Billing_Address_2__c='Billling Address',
            BillingCity='BillingCity',BillingState='BillingState',BillingPostalCode='344566',BillingCountry='Country',Shipping_Contact_Email__c='fdfsd1@gmail.com',ShippingStreet='ShippingStreet',
            Shipping_Address_2__c='ShippingAddress',ShippingCity='ShippingCity',ShippingState='ShippingState',ShippingPostalCode='78999',ShippingCountry='Country',
            CID__c='908654');
                 
            insert acctToUpdate;

            Contact contact1 = new Contact(FirstName='Luis',  LastName='Viloria', Phone='678.327.0000', AccountId=acctToUpdate.Id,
            Is_Primary__c =True ); 
            insert contact1; 
            
            Contract contract1 =new Contract(name='Contract One',AccountId=acctToUpdate.Id); 
            insert contract1;
        
            Contract contract2 =new Contract(name='Contract Two',AccountId=acctToUpdate.Id); 
            insert contract2;

            invoiceit_s__Currency__c curr=new invoiceit_s__Currency__c(Name='AUS',invoiceit_s__Currency_Name__c='AUS',invoiceit_s__Currency_Symbol__c='$');
            insert curr;
   
            Opportunity oppItem = new Opportunity(Name = 'Test Opp222', AccountId = acctToUpdate.Id, CloseDate = System.today()-7, StageName = 'Active', 
            Refund_Customer_type__c = 'Prospect',Which_other_products_considered__c='Drake',What_was_the_previously_used_product__c='Lacerte',LeadSource = 'Web',Description ='Opportunity Description');
          
            insert oppItem;
         
            invoiceit_s__Job__c invoiceOrder= new invoiceit_s__Job__c(Name='Name',invoiceit_s__CurrencyL__c=curr.Id,invoiceit_s__Account__c=acctToUpdate.Id,invoiceit_s__Total_Contract_Value__c=8);
            insert invoiceOrder; 
             
            invoiceit_s__Job_Product__c product=new invoiceit_s__Job_Product__c(Name='Product1',invoiceit_s__Job__c=invoiceOrder.Id,invoiceit_s__Product_Code__c ='PYSUBFEE');
            insert product;
            
            product2 prod0=new product2(Name='Sales Tax',ProductCode='PYSUBFEE',Family='Tax',Description='Desc Cero',IsActive=True);
            insert prod0;

            product2 prod1=new product2(Name='product1',ProductCode='SUBFEE',Family='Tax',Description='Desc One');
            insert prod1;

            product2 prod2=new product2(Name='product2',ProductCode='PSFEE',Family='Tax',SBQQ__RenewalProduct__c=prod1.Id,Description='Desc Two');
            insert prod2;
        

            SBQQ__Quote__c quote=new SBQQ__Quote__c(SBQQ__Primary__c=True,Origin_Source__c = 'WEB',SBQQ__Type__c='Quote',QTC__Order__c=invoiceOrder.Id,SBQQ__Opportunity2__c=oppItem.Id,Do_It__c=true);
            insert quote;

            invoiceit_s__Job_Rate_Plan__c ratePlan= new invoiceit_s__Job_Rate_Plan__c(Name='768cczxc',invoiceit_s__Job_Product__c=product.Id);
            insert ratePlan;

            invoiceit_s__Job_Rate_Plan_Charge__c ratePlanCharge = new invoiceit_s__Job_Rate_Plan_Charge__c(Name='ratePlanCHarge',Product_Year__c='2016',
            invoiceit_s__Quantity__c=2,invoiceit_s__Job_Rate_Plan__c=ratePlan.Id,invoiceit_s__Net_Total__c=100,invoiceit_s__Tax__c=50,invoiceit_s__Product_Charge_Category__c='Catogory',
            Product_Purchase_Type__c='TX',Training_Contact_Email__c='xx@gmail.com',invoiceit_s__Bundle__c=false,invoiceit_s__Package__c=false,invoiceit_s__Service_Activation_Date__c=System.Today(),
            invoiceit_s__Service_End_Date__c=System.Today(),invoiceit_s__Order__c=invoiceOrder.Id);
            insert ratePlanCharge;
            
            
            SBQQ__QuoteLine__c QuoteLine1=new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,QTC__Order_Rate_Plan_Charge__c=ratePlanCharge.Id,
            SBQQ__Product__c=prod2.id,SBQQ__Quantity__c=1,SBQQ__CustomerPrice__c=100,
            SBQQ__MarkupAmount__c=100,SBQQ__MarkupRate__c=50,SBQQ__Discount__c=5,SBQQ__AdditionalDiscountAmount__c=10,SBQQ__Incomplete__c=true,SBQQ__RequiredBy__c=null);
            insert QuoteLine1;

            SBQQ__QuoteLine__c QuoteLine2=new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,QTC__Order_Rate_Plan_Charge__c=ratePlanCharge.Id,
            SBQQ__Product__c=prod2.id,SBQQ__Quantity__c=1,SBQQ__CustomerPrice__c=100,
            SBQQ__MarkupAmount__c=100,SBQQ__MarkupRate__c=50,SBQQ__Discount__c=5,SBQQ__AdditionalDiscountAmount__c=10,SBQQ__Incomplete__c=true);
            insert QuoteLine2;

            SBQQ__Subscription__c subcription1 = new SBQQ__Subscription__c(
            SBQQ__Contract__c=contract1.Id,SBQQ__QuoteLine__c=QuoteLine1.Id,
            SBQQ__Product__c=prod2.Id,QTC__Order_Rate_Plan_Charge__c=ratePlanCharge.Id,SBQQ__Quantity__c=1);
            insert subcription1;

            SBQQ__Subscription__c subcription2 = new SBQQ__Subscription__c(
            SBQQ__Contract__c=contract2.Id,SBQQ__QuoteLine__c=QuoteLine2.Id,
            SBQQ__Product__c=prod2.Id,QTC__Order_Rate_Plan_Charge__c=ratePlanCharge.Id,SBQQ__Quantity__c=1);
            insert subcription2;

            


            Pricebook2 priceBook= new Pricebook2();
            priceBook.Name='2017 Pricebook';
            priceBook.isActive=true ;
            insert priceBook;
          
            PricebookEntry priceBookEtry= new PricebookEntry();
            priceBookEtry.Pricebook2Id = priceBook.Id;
            priceBookEtry.Product2Id = prod2.Id;
            priceBookEtry.UnitPrice = 12000; 
            priceBookEtry.IsActive = true;
            insert priceBookEtry;

            SBQQ__ProductFeature__c feature1 = new SBQQ__ProductFeature__c();
            feature1.Name = 'Fees';
            feature1.SBQQ__Number__c = 1; 
            feature1.SBQQ__MinOptionCount__c = 1;
            feature1.SBQQ__ConfiguredSKU__c = prod1.Id;
            insert feature1;

            SBQQ__ProductOption__c po1 = new SBQQ__ProductOption__c();
            po1.SBQQ__Number__c = 1;
            po1.SBQQ__ConfiguredSKU__c = prod1.Id;
            po1.SBQQ__OptionalSKU__c = prod2.Id;
            po1.SBQQ__Feature__c = feature1.Id;
            po1.Display_Type__c = 'Checkbox';
            po1.SBQQ__Bundled__c = True;
            po1.SBQQ__Selected__c =True;
            
            insert po1;
            
            Test.StartTest(); 
            
            RenewalQuoteCreation.createquote(acctToUpdate.Id);
            
            
            Test.stopTest(); 
    }
    
     
    
}