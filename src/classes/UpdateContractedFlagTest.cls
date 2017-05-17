@isTest()
public class UpdateContractedFlagTest{
 Static testMethod void checkcontractedflag(){
        
         
         //Account insert
        Account account = new Account(Name = 'India',ShippingCity = 'annapolis',ShippingCountry = 'US',Email__c='Test@gmail.com',ShippingPostalCode = '21401',ShippingState = 'MD',ShippingStreet='Test',CID__C='6000672');
        insert account;
        
         //Contact Insert 
        Contact cont = new Contact();
       cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
        //insert Opportunity 
        Opportunity opptn = new Opportunity();  
        opptn.AccountId = account.id;
        opptn.CloseDate = System.today();
        opptn.StageName ='Onboard';
        opptn.Onboard_Time__c=system.now();
        opptn.Onboard_Time__c=opptn.Onboard_Time__c.addMinutes(5) ;
        
        opptn.Name = 'Opportunity Test';
        opptn.ForecastCategoryName = 'Medium Probability';
        opptn.Product__c ='Web-Order';
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
        opptn.SBQQ__Contracted__c =false;
        update opptn;
 
        Test.StartTest();
        UpdateContractedFlag checkbox1=new UpdateContractedFlag();
        String sch = '0 0 20 * * ?'; 
        system.schedule('Test RupdateContractedFlag', sch, checkbox1); 
        List<Opportunity> opptiesToUpdate = new List<Opportunity>();
        Test.stopTest(); 
        
        }
   }