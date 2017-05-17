@isTest  
class WebAuthenticationTest
{
    static testMethod void myTest() {
       
       //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        prod.IsActive=true;
        insert prod;
        
       Account account = new Account(Name = 'India',CID__c='12345',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test');
        insert account;
        
          //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
    opportunity p=new opportunity();
    p.Type='NEW';
    p.Name='tstop';
    p.StageName='Negotiation';
    p.CloseDate=system.today();
    insert p;
    
    cart__c c =new cart__C();
    c.cart_Account__c=account.id;
    c.Total_Price__c=2000;
    insert c;
    
    //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
         insert new Pricebook__c(Name = 'Pricebook2016',Pricebookid__c= priceBook.id);

    //Insert CPQ Quote 
        SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        //cpqQuote.SBQQ__Opportunity2__c = opp.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        cpqQuote.Web_Renewal__c=true;
        cpqQuote.SBQQ__Primary__c=true;
        insert cpqQuote;
        
         //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine.SBQQ__Product__c= prod.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        
        insert cpqQuoteLine;
        
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
    
        Test.startTest();
        WebAuthentication.CID(account.CID__C,c.id,null);
        WebAuthentication.CID(account.CID__C,null,'Existing');
        WebAuthentication.CID(null,null,'Existing');
        Test.StopTest();
        
      }
}