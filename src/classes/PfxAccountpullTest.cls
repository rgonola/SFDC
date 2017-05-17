@isTest
public class PfxAccountpullTest
{
  static testMethod void postest()
  {
  
     //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
        
      Product2 prod = new Product2();
        prod.Name = 'Sales Tax';
        prod.Family = 'Hardware';
        prod.ProductCode = 'ATX-MAX_2017';
        prod.IsActive=true;
        insert prod;
    
    // Create Required data here    
    
        Test.startTest();

            RestResponse res = new RestResponse();
            RestRequest req = new RestRequest(); 

                      
         String   Body='{'+
        '   \"Customer\": {'+
        '       \"subsegment\": \"2-4 Total Employees\",'+
        '       \"ShippingZip\": \"75251\",'+
        '       \"ShippingState\": \"TX\",'+
        '       \"Shippingcountry\": \"US\",'+
        '       \"ShippingCity\": \"DALLAS\",'+
        '       \"ShippingAdress\": \"12222 MERIT DRIVE SUITE 1070\",'+
        '       \"Segment\": \"Accounting Firms\",'+
        '       \"Phone\": \"(214) 442-0090\",'+
        '       \"Name\": \"OSBORN KOSANDA & COMPANY\",'+
        '       \"BillingZip\": \"75251\",'+
        '       \"BillingState\": \"TX\",'+
        '       \"Billingcountry\": \"US\",'+
        '       \"BillingCity\": \"DALLAS\",'+
        '       \"BillingAdress\": \"12222 MERIT DRIVE SUITE 1070\",'+
        '       \"AcctOwner\": null,'+
        '       \"AccoutNumber\": \"0000116697\",'+
        '       \"AccountRecordId\": \"001i000000QOogPAAT\"'+
        '   },'+
        '   \"Contacts\": {'+
        '       \"Phone\": \"(214) 691-0900\",'+
        '       \"Mobile\": null,'+
        '       \"LastName\": \"Osborn\",'+
        '       \"FirstName\": \"John\",'+
        '       \"Fax\": null,'+
        '       \"Email\": \"joe@kofsanda-cpa.com\",'+
        '       \"ContactRecordId\": \"003i000000NmUrxAAF\",'+
        '       \"ContactNumber\": \"0000412809\"'+
        '   }'+
        '}';
        
            req.requestBody = Blob.valueOf(Body);

            req.httpMethod = 'post';
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated 
            req.requestURI = '/services/apexrest/PFXPromotion' ;  
            RestContext.request = req;
            RestContext.response = res;

            //List<Wrapper> lstWrapper = myController.getMeListOfProducts(); // Use this line if wrapper class is outside
            PfxAccountpullResponse.Result result= PfxAccountpull.doPost(); 
            
        Test.stopTest();   
  }

  static testMethod void postest2()
  {
     
      //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',X1Force_Account__c='0000116697');
        insert account;
       
       //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
        
     //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
        
      Product2 prod = new Product2();
        prod.Name = 'Sales Tax';
        prod.Family = 'Hardware';
        prod.ProductCode = 'ATX-MAX_2017';
        prod.IsActive=true;
        insert prod;
    
    // Create Required data here    
    
        Test.startTest();

            RestResponse res = new RestResponse();
            RestRequest req = new RestRequest(); 

                      
         String   Body='{'+
        '   \"Customer\": {'+
        '       \"subsegment\": \"2-4 Total Employees\",'+
        '       \"ShippingZip\": \"75251\",'+
        '       \"ShippingState\": \"TX\",'+
        '       \"Shippingcountry\": \"US\",'+
        '       \"ShippingCity\": \"DALLAS\",'+
        '       \"ShippingAdress\": \"12222 MERIT DRIVE SUITE 1070\",'+
        '       \"Segment\": \"Accounting Firms\",'+
        '       \"Phone\": \"(214) 442-0090\",'+
        '       \"Name\": \"OSBORN KOSANDA & COMPANY\",'+
        '       \"BillingZip\": \"75251\",'+
        '       \"BillingState\": \"TX\",'+
        '       \"Billingcountry\": \"US\",'+
        '       \"BillingCity\": \"DALLAS\",'+
        '       \"BillingAdress\": \"12222 MERIT DRIVE SUITE 1070\",'+
        '       \"AcctOwner\": null,'+
        '       \"AccoutNumber\": \"0000116697\",'+
        '       \"AccountRecordId\": \"001i000000QOogPAAT\"'+
        '   },'+
        '   \"Contacts\": {'+
        '       \"Phone\": \"(214) 691-0900\",'+
        '       \"Mobile\": null,'+
        '       \"LastName\": \"Osborn\",'+
        '       \"FirstName\": \"John\",'+
        '       \"Fax\": null,'+
        '       \"Email\": \"joe@kofsanda-cpa.com\",'+
        '       \"ContactRecordId\": \"003i000000NmUrxAAF\",'+
        '       \"ContactNumber\": \"0000412809\"'+
        '   }'+
        '}';
        
            req.requestBody = Blob.valueOf(Body);

            req.httpMethod = 'post';
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated 
            req.requestURI = '/services/apexrest/PFXPromotion' ;  
            RestContext.request = req;
            RestContext.response = res;

            //List<Wrapper> lstWrapper = myController.getMeListOfProducts(); // Use this line if wrapper class is outside
            PfxAccountpullResponse.Result result= PfxAccountpull.doPost(); 
            
        Test.stopTest();   
  }
}