@isTest
private class WebUpdateaddrestoaccountTest {
static testMethod void updateaddress(){
  
  
  account a = new account( type='Prospect',Name = 'abcd',Brand__c='ATX',shippingCountry = 'USA', BillingStreet='123 new street'
                                 ,ShippingStreet='123 new street',Billingcity='some city', shippingcity='some city',BillingState='TX' ,
                                 shippingState='TX',Billingpostalcode='94538',shippingpostalcode='94538',BillingCountry='USA' ,
                                 Primary_Contact_Name__c = 'new name');
  insert a;
  
    //insert objects;
        
         //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.IsActive=true;
        insert prod;
  
   //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
  
        //insert Opportunity 
        Opportunity opp = new Opportunity();
        opp.AccountId = a.id;
        opp.CloseDate = System.today();
        opp.StageName = 'Validation';
        opp.Name = 'Opportunity Test';
        opp.type='Renewal';
        opp.Amount =340;
        opp.ForecastCategoryName = 'Medium Probability';
        opp.Product__c = 'ATX';
        insert opp;    
              
  //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = a.id;
        cpqQuote.SBQQ__Opportunity2__c = opp.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        //cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        cpqQuote.Web_Renewal__c=true;
        //cpqQuote.SBQQ__Primary__c=true;
        insert cpqQuote;
    
    //Insert Payment Method
        invoiceit_s__Payment_Method__c PM = new invoiceit_s__Payment_Method__c();
        PM.invoiceit_s__Account__c = a.id;
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
        PM.invoiceit_s__Default__c  = true;
        
        insert PM;
        
        
          
        
    SBQQ__Quote__c  c = new SBQQ__Quote__c (); 
    c.SBQQ__OriginalQuote__c = cpqQuote.id;
    c.SBQQ__Type__c ='Quote';
    c.SBQQ__Status__c='Invoiced';
    c.SBQQ__Primary__c = true;
    c.SBQQ__LineItemsGrouped__c =true;
    c.SBQQ__BillingName__c='new name';
    c.SBQQ__BillingStreet__c='123 new street';
    c.SBQQ__BillingCity__c='some city';
    c.SBQQ__BillingState__c='TX';
    c.SBQQ__BillingPostalCode__c='94538';
    c.SBQQ__BillingCountry__c = 'USA';
    c.Origin_Source__c = 'WEB';
    c.SBQQ__Account__c=a.id;
    c.SBQQ__Opportunity2__c = opp.id;
    c.SBQQ__ShippingName__c=c.SBQQ__BillingName__c;
    c.SBQQ__ShippingStreet__c=c.SBQQ__BillingStreet__c;
    c.SBQQ__ShippingCity__c=c.SBQQ__BillingCity__c;
    c.SBQQ__ShippingState__c=c.SBQQ__BillingState__c;
    c.SBQQ__ShippingPostalCode__c=c.SBQQ__BillingPostalCode__c;
    c.SBQQ__ShippingCountry__c = c.SBQQ__BillingCountry__c ;

  insert c;
   
   //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = c.id;
        cpqQuoteLine.SBQQ__Product__c= prod.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        cpqQuoteLine.Is_New_Business__c=true;
        
        insert cpqQuoteLine;
        
 Test.startTest();   
    c.SBQQ__BillingStreet__c='232 choc road';
    c.SBQQ__BillingCity__c='chicago';
    c.SBQQ__BillingState__c='TX';
    c.SBQQ__BillingPostalCode__c='34562';
    c.SBQQ__BillingCountry__c = 'bgu';
    c.Do_It__c=true;
  update c;

  Test.StopTest();
  
  
}



}