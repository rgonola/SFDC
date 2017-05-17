@isTest
public class WebClassLinkopptoqTest {
    static testMethod void m1() {
    
    WebClassLinkopptoq.LogInfo obj1 = new WebClassLinkopptoq.LogInfo ();
    
    WebClassLinkopptoq.LogInfo obj4 = new WebClassLinkopptoq.LogInfo ();
    WebClassLinkopptoq.DebuggingInfo_element obj2 = new WebClassLinkopptoq.DebuggingInfo_element ();
    WebClassLinkopptoq.address obj3 = new WebClassLinkopptoq.address ();
    WebClassLinkopptoq.SessionHeader_element obj5 = new WebClassLinkopptoq.SessionHeader_element ();
    WebClassLinkopptoq.qutidResponse_element obj6 = new WebClassLinkopptoq.qutidResponse_element ();
    WebClassLinkopptoq.CallOptions_element obj7 = new WebClassLinkopptoq.CallOptions_element ();
    WebClassLinkopptoq.DebuggingHeader_element obj8 = new WebClassLinkopptoq.DebuggingHeader_element ();
    WebClassLinkopptoq.AllowFieldTruncationHeader_element obj12 = new WebClassLinkopptoq.AllowFieldTruncationHeader_element ();
    WebClassLinkopptoq.qutid_element obj9 = new WebClassLinkopptoq.qutid_element ();
    WebClassLinkopptoq.Linkopptoquoteweb obj10= new WebClassLinkopptoq.Linkopptoquoteweb();
    WebClassLinkopptoq.location obj11 = new WebClassLinkopptoq.location (); 
        

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

     opportunity p=new opportunity();
    p.Type='NEW';
    p.Name='tstop';
    p.StageName='Negotiation';
    p.CloseDate=system.today();
    insert p;

    SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        insert cpqQuote;
    
     test.starttest();           
     Linkopptoquoteweb.qutid(cpqQuote.id,p.id);
     test.stoptest();     
    
    }
    }