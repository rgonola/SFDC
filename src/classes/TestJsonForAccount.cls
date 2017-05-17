@isTest

/* Test class for Json request*/


(SeeAllData=false)
global class TestJsonForAccount{

     static testMethod void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = UpdateAccountInfoInDM.sendRequest('http://api.salesforce.com/foo/bar','GET');
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }

     static testMethod void testOutboundCalls(){
        
         Account acctToUpdate = new Account(Name = 'Test Account88', Type = 'Customer8',Prior_Software_Vendor__c='abc',
         CC_on_File__c=true,Cutoff__c=true,Primary_Contact_Name__c='Primary Contact', Email__c='usha.mp@gmail.com',Phone='978899403',Fax='4335643',
         Primary_MobilePhone__c='5227689',Billing_Contact_Email__c='Billing.Contact@gmail.com',BillingStreet='Billing street',Billing_Address_2__c='Billling Address',
         BillingCity='BillingCity',BillingState='BillingState',BillingPostalCode='344566',BillingCountry='Country',Shipping_Contact_Email__c='fdfsdf@gmail.com',ShippingStreet='ShippingStreet',
         Shipping_Address_2__c='ShippingAddress',ShippingCity='ShippingCity',ShippingState='ShippingState',ShippingPostalCode='78999',ShippingCountry='Country');
         insert acctToUpdate;
         UpdateAccountInfoInDM.replicateCustomer(acctToUpdate.Id);
         UpdateAccountInfoInDM.sendCCOnFileAndCutOffData(acctToUpdate.Id,'ccOnFile');
         UpdateAccountInfoInDM.sendCCOnFileAndCutOffData(acctToUpdate.Id,'cutoffData');
        
     }
   
    static testMethod void testJsonForAccount() {
        String json=        '{'+
        '  "ReplicateCustomer": {'+
        '    "Sfdc": { "SF_Account_ID": "12345678" },'+
        '    "Customer": {'+
        '      "PID": "3",'+
        '      "ClientID": "19448",'+
        '      "Office": "0",'+
        '      "Brand_Type": "ATX",'+
        '      "First_Name": "Dilan",'+
        '      "Last_Name": "Viloria",'+
        '      "Company": "JW",'+
        '      "Email": "dilan@cchsfs.com"'+
        '    },'+
        '    "Contacts":  '+
        '    ['+
        '        {'+
        '          "Cnt_Type": "Shipping",'+
        '          "Phone": "678-125-9658",'+
        '          "Fax": "678-741-9222",'+
        '          "Mobile": "678-741-9223",'+
        '          "Email": "myshipping@cchsfs.com",'+
        '          "Addr1": "2025 Barrett Pkwy",'+
        '          "Addr2": "Apt 2145",'+
        '          "City": "Kennesaw",'+
        '          "State": "GA",'+
        '          "Zip": "30144-4785",'+
        '          "Country": "USA"'+
        '        },'+
        '        {'+
        '          "Cnt_Type": "Mailing",'+
        '          "Phone": "678-125-9655",'+
        '          "Fax": "678-741-9211",'+
        '          "Mobile": "678-747-9229",'+
        '          "Email": "mymailing@cchsfs.com",'+
        '          "Addr1": "8964 Barrett Pkwy",'+
        '          "Addr2": "Suite 300",'+
        '          "City": "Kennesaw",'+
        '          "State": "GA",'+
        '          "Zip": "30144-4785",'+
        '          "Country": "USA"'+
        '        }'+
        '      ]'+
        '  }'+
        '}'+
        '';
        System.assert(JsonForAccount.parse(json)!= null);
    }
    
    static testMethod void testInvoice() {
        String json=        '{'+
        '  "Staging": {'+
        '    "Sfdc": {'+
        '      "SF_Account_ID": "7421587",'+
        '      "SF_Invoice_ID": "965874",'+
        '      "SF_Opportunity_ID": "213654",'+
        '      "SF_Order_ID": "321456",'+
        '      "SF_Quote_ID": "632541"'+
        '    },'+
        '    "Customer": {'+
        '      "PID": "9",'+
        '      "ClientID": "63254",'+
        '      "Office": "0",'+
        '      "Brand_Type": "TW",'+
        '      "First_Name": "Dilan",'+
        '      "Last_Name": "Viloria",'+
        '      "Company": "CCH",'+
        '      "Email": "dilan@cchsfs.com"'+
        '    },'+
        '    "Contacts": ['+
        '        {'+
        '          "Cnt_Type": "Shipping",'+
        '          "Phone": "678-125-9658",'+
        '          "Fax": "678-741-9222",'+
        '          "Mobile": "678-741-9223",'+
        '          "Email": "myshipping@cchsfs.com",'+
        '          "Addr1": "2025 Barrett Pkwy",'+
        '          "Addr2": "Apt 2145",'+
        '          "City": "Kennesaw",'+
        '          "State": "GA",'+
        '          "Zip": "30144-4785",'+
        '          "Country": "USA"'+
        '        },'+
        '        {'+
        '          "Cnt_Type": "Mailing",'+
        '          "Phone": "678-125-9655",'+
        '          "Fax": "678-741-9211",'+
        '          "Mobile": "678-747-9229",'+
        '          "Email": "mymailing@cchsfs.com",'+
        '          "Addr1": "8964 Barrett Pkwy",'+
        '          "Addr2": "Suite 300",'+
        '          "City": "Kennesaw",'+
        '          "State": "GA",'+
        '          "Zip": "30144-4785",'+
        '          "Country": "USA"'+
        '        }'+
        '      ],'+
        '    "Order": {'+
        '      "STX_Invoice_Number": "321456",'+
        '      "STX_Invoice_Sent": "6523874",'+
        '      "Description": "Initial Order",'+
        '      "Addl_SLS_CD": "02",'+
        '      "QuoteNum": "9863274",'+
        '      "QuoteType": "Regular",'+
        '      "STX_Order_Number": "369852",'+
        '      "STX_Order_Sent": "21457",'+
        '      "SLS_CD": "01",'+
        '      "STOL_Total_Tax": "10.52",'+
        '      "Payment_Type": "CC",'+
        '      "Ord_Val": "978.00",'+
        '      "Total_Shipping": "10.00",'+
        '      "Ord_Source": "WEB",'+
        '      "Web_Source": "CART",'+
        '      "Train_Email": "mytraining@cchsfs.com",'+
        '      "OrderType": "Regular"'+
        '    },'+
        '    "Products": ['+
        '        {'+
        '          "LineSequence": "1",'+
        '          "ItemID": "ATX-1040",'+
        '          "ItemDescription": "ATX 1040 Package",'+
        '          "Quantity": "1",'+
        '          "PriceList": "850.00",'+
        '          "PriceNet": "850.00",'+
        '          "PriceExtended": "850.00",'+
        '          "Revision_Number": "2016",'+
        '          "STOL_Tax": "10.52",'+
        '          "Sub_Start_Date": "01-01-2016",'+
        '          "Sub_End_Date": "12-31-2016",'+
        '          "TRT_ID": "874524587",'+
        '          "Up_Down_Grade": "N",'+
        '          "Taxable": "Y",'+
        '          "ItemClass": "TRG",'+
        '          "Assemblies": ['+
        '              {'+
        '                "AssmSeq": "1",'+
        '                "SKU": "IRSPUB",'+
        '                "RevNo": "2016",'+
        '                "DR_Template_CD": "CDA",'+
        '                "DRTemplateCD": "01-01-2016"'+
        '              },'+
        '              {'+
        '                "AssmSeq": "2",'+
        '                "SKU": "ATX-FED1040",'+
        '                "RevNo": "2016",'+
        '                "DR_Template_CD": "CDA",'+
        '                "DRTemplateCD": "01-01-2016"'+
        '              }'+
        '            ]'+
        '        },'+
        '        {'+
        '          "LineSequence": "2",'+
        '          "ItemID": "ATX-MAX",'+
        '          "ItemDescription": "ATX-MAX Package",'+
        '          "Quantity": "1",'+
        '          "PriceList": "950.00",'+
        '          "PriceNet": "950.00",'+
        '          "PriceExtended": "950.00",'+
        '          "Revision_Number": "2016",'+
        '          "STOL_Tax": "12.52",'+
        '          "Sub_Start_Date": "01-01-2016",'+
        '          "Sub_End_Date": "12-31-2016",'+
        '          "TRT_ID": "874556324",'+
        '          "Up_Down_Grade": "N",'+
        '          "Taxable": "Y",'+
        '          "ItemClass": "TRG",'+
        '          "Assemblies": ['+
        '              {'+
        '                "AssmSeq": "1",'+
        '                "SKU": "ATX-1040EA",'+
        '                "RevNo": "2016",'+
        '                "DR_Template_CD": "CDA",'+
        '                "DRTemplateCD": "01-01-2016"'+
        '              },'+
        '              {'+
        '                "AssmSeq": "2",'+
        '                "SKU": "ATX-MTG",'+
        '                "RevNo": "2016",'+
        '                "DR_Template_CD": "CDA",'+
        '                "DRTemplateCD": "01-01-2016"'+
        '              }'+
        '            ]'+
        '        }'+
        '      ]'+
        '  }'+
        '}'+
        '';
        System.assert(CreateOrder.parse(json)!= null);
    }
 
    static testMethod void testBalance(){
        
         Account acctToUpdate = new Account(Name = 'Test Account88', Type = 'Customer8',Prior_Software_Vendor__c='abc',
         CC_on_File__c=true,Cutoff__c=true,Primary_Contact_Name__c='Primary Contact', Email__c='usha.mp@gmail.com',Phone='978899403',Fax='4335643',
         Primary_MobilePhone__c='5227689',Billing_Contact_Email__c='Billing.Contact@gmail.com',BillingStreet='Billing street',Billing_Address_2__c='Billling Address',
         BillingCity='BillingCity',BillingState='BillingState',BillingPostalCode='344566',BillingCountry='Country',Shipping_Contact_Email__c='fdfsdf@gmail.com',ShippingStreet='ShippingStreet',
         Shipping_Address_2__c='ShippingAddress',ShippingCity='ShippingCity',ShippingState='ShippingState',ShippingPostalCode='78999',ShippingCountry='Country');
         
         insert acctToUpdate;
         
         Map<String,Account> m1=new Map<String,Account>();
         m1.put('GET_ACCOUNT_BALANCE',acctToUpdate);
         
         String balance=       '{'+
        '                "GET_ACCOUNT_BALANCE": {'+
        '                                "Account": {'+
        '                                                "CID": "2131243"'+
        '                                }'+
        '                }'+
        '}';
      
         JsonResponse jsonResponse=new JsonResponse();
         
         RestRequest req = new RestRequest();
         RestResponse res = new RestResponse();
         
         req.requestURI = '/services/apexrest/Lead';  //Request URL
         req.httpMethod = 'POST';//HTTP Request Type
         
         req.requestBody=Blob.valueof(balance);
  
         RestContext.request = req;
         RestContext.response= res;

         JsonResponse.result stas=CustomerInfo.dopost();
         CustomerInfo.getAccountInfo(m1, 'GET_ACCOUNT_BALANCE');
         CustomerInfo.generateJsonReponse(m1,'GET_ACCOUNT_BALANCE');
        
         
     }
   
   static testMethod void testUpdateCustomer(){
        
         Account acctToUpdate = new Account(Name = 'Test Account88', Type = 'Customer8',Prior_Software_Vendor__c='abc',
         CC_on_File__c=true,Cutoff__c=true,Primary_Contact_Name__c='Primary Contact', Email__c='usha.mp@gmail.com',Phone='978899403',Fax='4335643',
         Primary_MobilePhone__c='5227689',Billing_Contact_Email__c='Billing.Contact@gmail.com',BillingStreet='Billing street',Billing_Address_2__c='Billling Address',
         BillingCity='BillingCity',BillingState='BillingState',BillingPostalCode='344566',BillingCountry='Country',Shipping_Contact_Email__c='fdfsdf@gmail.com',ShippingStreet='ShippingStreet',
         Shipping_Address_2__c='ShippingAddress',ShippingCity='ShippingCity',ShippingState='ShippingState',ShippingPostalCode='78999',ShippingCountry='Country');
         
         insert acctToUpdate;
         
         Map<String,Account> m1=new Map<String,Account>();
         m1.put('UPDATE_CUSTOMER',acctToUpdate);
         
         String updateCustomer=        '{'+
        '"UPDATE_CUSTOMER": {'+
        '"Account": {'+
        //'"SF_Account_ID": "",'+
        '"PID": "178658",'+
        '"ClientID": "176756",'+
        '"Office": "0",'+
        '"Phone": "7065551212",'+
        '"Fax": "7065551212",'+
        '"MobilePhone": "3333333333",'+
        '"ContactEmailAddress": "joe.herrin@cchsfs.com",'+
        '"PrimaryContactFirstName": "PAUL X",'+
        '"PrimaryContactLastName": "TEST5",'+
        '"SecondaryContactFirstName": "SUR",'+
        '"SecondaryContactLastName": "TEST6",'+
        '"CompanyName": "TEST",'+
        '"BillingAddress1": "3456 Testing Avenue 10",'+
        '"BillingAddress2": "Apt. Testing 1234577",'+
        '"BillingCity": "ROME",'+
        '"BillingState": "GA",'+
        '"BillingZip": "30164",'+
        '"BillingCountry": "USA",'+
        '"ShippingAddress1": "Joiner and Son Accounting",'+
        '"ShippingAddress2": "ship line 963",'+
        '"ShippingCity": "ROME",'+
        '"ShippingState": "GA",'+
        '"ShippingZip": "30165",'+
        '"ShippingCountry": "USA"'+
        '}'+
        '}'+
        '}';
         JsonResponse jsonResponse=new JsonResponse();
         
         RestRequest req = new RestRequest();
         RestResponse res = new RestResponse();
         
         req.requestURI = '/services/apexrest/Lead';  //Request URL
         req.httpMethod = 'POST';//HTTP Request Type
         
         req.requestBody=Blob.valueof(updateCustomer);
  
         RestContext.request = req;
         RestContext.response= res;

         JsonResponse.result stas=CustomerInfo.dopost();
         CustomerInfo.getAccountInfo(m1, 'UPDATE_CUSTOMER');
         CustomerInfo.generateJsonReponse(m1,'UPDATE_CUSTOMER');
        
         
     }
   
   static testMethod void testSendCustInfo(){
        
         Account acctToUpdate = new Account(Name = 'Test Account88', Type = 'Customer8',Prior_Software_Vendor__c='abc',
         CC_on_File__c=true,Cutoff__c=true,Primary_Contact_Name__c='Primary Contact', Email__c='usha.mp@gmail.com',Phone='978899403',Fax='4335643',
         Primary_MobilePhone__c='5227689',Billing_Contact_Email__c='Billing.Contact@gmail.com',BillingStreet='Billing street',Billing_Address_2__c='Billling Address',
         BillingCity='BillingCity',BillingState='BillingState',BillingPostalCode='344566',BillingCountry='Country',Shipping_Contact_Email__c='fdfsdf@gmail.com',ShippingStreet='ShippingStreet',
         Shipping_Address_2__c='ShippingAddress',ShippingCity='ShippingCity',ShippingState='ShippingState',ShippingPostalCode='78999',ShippingCountry='Country',Shipping_Contact_Name__c='Second Name');
         
         insert acctToUpdate;
         
         Map<String,Account> m1=new Map<String,Account>();
         m1.put('RETURN_CUST_INFO_WEB',acctToUpdate);
         
         String returnCustInfo=       '{'+
        '                "RETURN_CUST_INFO_WEB": {'+
        '                                "Account": {'+
        '                                                "SF_Account_ID":' +'"'+acctToUpdate.Id +'"'+
        '                                }'+
        '                }'+
        '}';
        system.debug('returnCustInfo ****'+returnCustInfo);
        
         JsonResponse jsonResponse=new JsonResponse();
         
         RestRequest req = new RestRequest();
         RestResponse res = new RestResponse();
         
         req.requestURI = '/services/apexrest/Lead';  //Request URL
         req.httpMethod = 'POST';//HTTP Request Type
         
         req.requestBody=Blob.valueof(returnCustInfo);
  
         RestContext.request = req;
         RestContext.response= res;

         ReturnCustInfoJson.result stas=SendCustomerInfo.dopost();
         //SendCustomerInfo.getAccountInfo(m1, 'RETURN_CUST_INFO_WEB');
         SendCustomerInfo.generateJsonReponse(m1,'RETURN_CUST_INFO_WEB');
        
     }
    static testMethod void testParse2() {
       
        String json=        '{'+
        '  "Status" : "Success",'+
        '  "requestRecievedFor" : "UPDATE_CUSTOMER",'+
        '  "Message" : null,'+
        '  "ErrorCode" : null,'+
        '  "CID" : "0987789",'+
        '  "Balance" : null'+
        '}';
        
        System.assert(JsonResponse.parse(json)!= null);
    }
    
    static testMethod void myUpdateRegCode() {
        Test.startTest();
        
        
        UpdateRegCode batchApex = new UpdateRegCode();
        batchApex.query = 'SELECT Name,id,Fulfilment_Date__c,Reg_Code__c,Product_Year__c,RegCode_Required__c,invoiceit_s__Order__c,Product_Code__c from invoiceit_s__Job_Rate_Plan_Charge__c where Reg_Code__c=null and Fulfilment_Date__c <=Today limit 50';
        Id batchID = database.executebatch(batchApex,50);
        
        //batchApex.start(batchApex.query);
        
        Test.stopTest();
    }

     static testMethod void testReturnCustInfoJson() {
       
        String json=        '{'+
        '"Status" : "Success",'+
        '"requestRecievedFor" : "RETURN_CUST_INFO_WEB",'+
        '"Message" : null,'+
        '"ErrorCode" : null,'+
        '"SF_Account_ID": "001E000000N7r6YIAR",'+
        '"PID": "10060",'+
        '"ClientID": "1430198",'+
        '"Office": "0",'+
        '"Phone": "7065551212",'+
        '"Fax": "7065551212",'+
        '"MobilePhone": "3333333333",'+
        '"ContactEmailAddress": "joe.herrin@cchsfs.com<mailto:joe.herrin@cchsfs.com>",'+
        '"PrimaryContactFirstName": "PAUL X",'+
        '"PrimaryContactLastName": "TEST5",'+
        '"SecondaryContactFirstName": "SUR",'+
        '"SecondaryContactLastName": "TEST6",'+
        '"CompanyName": "TEST COMPANY 997",'+
        '"BillingAddress1": "3456 Testing Avenue 10",'+
        '"BillingAddress2": "Apt. Testing 1234577",'+
        '"BillingCity": "ROME",'+
        '"BillingState": "GA",'+
        '"BillingZip": "30165",'+
        '"BillingCountry": "USA",'+
        '"ShippingAddress1": "Joiner and Son Accounting",'+
        '"ShippingAddress2": "ship line 963",'+
        '"ShippingCity": "ROME",'+
        '"ShippingState": "GA",'+
        '"ShippingZip": "30165",'+
        '"ShippingCountry": "USA"'+
        '}';
        System.assert(ReturnCustInfoJson.parse(json)!= null);
    } 
  
     static testMethod void testIIT_PID_CID_check(){
        Test.startTest();
        
        
        PID_GROUP__c groupPID=new PID_GROUP__c(Name='PIDGroup');
        insert groupPID;
        
        Account acctToUpdate = new Account(Brand__c='ATX',Name = 'Test Account88', OFFC__c=0,Type = 'Customer8',Prior_Software_Vendor__c='abc',
        CC_on_File__c=true,Cutoff__c=true,Primary_Contact_Name__c='Primary Contact', Email__c='usha.mp@gmail.com',Phone='978899403',Fax='4335643',
        Primary_MobilePhone__c='5227689',Billing_Contact_Email__c='Billing.Contact@gmail.com',BillingStreet='Billing street',Billing_Address_2__c='Billling Address',
        BillingCity='BillingCity',BillingState='BillingState',BillingPostalCode='344566',BillingCountry='Country',Shipping_Contact_Email__c='fdfsdf@gmail.com',ShippingStreet='ShippingStreet',
        Shipping_Address_2__c='ShippingAddress',ShippingCity='ShippingCity',ShippingState='ShippingState',ShippingPostalCode='78999',ShippingCountry='Country',PID_GROUP__c=groupPID.Id,PID__C='4566',
        CID__c='8899',Active__c='No',Originl_CID_Number__c=String.ValueOf(Account.CID__c));
        insert acctToUpdate;
        
        PID_GROUP__c PIDdata=[Select Account_Record__r.PID__c,PID_Number__c  from PID_GROUP__c where Id=:acctToUpdate.PID_GROUP__c];
        
        System.assertNotEquals('76879', PIDdata.PID_Number__c);
        
        String officeNumber=String.ValueOf(acctToUpdate.OFFC__c);
        
        
        Integer intCID=Integer.ValueOf(acctToUpdate.CID__c);
        Integer intOFC=Integer.ValueOf(acctToUpdate.OFFC__c);
        String acc=String.ValueOf(acctToUpdate.Id);
        
        IIT_PID_CID_checkHandler.SavenoPID_CID_OFFC_AccID(null,acctToUpdate.CID__c,'2',acctToUpdate.Id);
        IIT_PID_CID_checkHandler.noPID_CID_OFFC_AccID(null,intCID,intOFC,acc);
        
        PageReference pageRef = Page.moveoffice0;
        Test.setCurrentPage(pageRef);
         
        ApexPages.StandardController sc = new ApexPages.standardController(acctToUpdate);
        apexpages.currentpage().getparameters().put('id',acctToUpdate.Id);
        system.debug('groupPID.Id****'+groupPID.Id);
        
        apexpages.currentpage().getparameters().put('PID_GROUP__c',groupPID.Id);
        
       
        apexpages.currentpage().getparameters().put('accId',acctToUpdate.Id);
      

        IIT_PID_CID_checkHandler controller = new IIT_PID_CID_checkHandler(sc);
        controller.a.PID_GROUP__c=acctToUpdate.PID_GROUP__c;
        
        controller.save();
        controller.cloneRecord();
        Test.stopTest();
     }
     
     static testmethod void logInfoTest(){
     LogFiles__c  infoLog=new LogFiles__c(name='LogIfo');
     insert infoLog;
     
     LogJson logJson=new LogJson();
     RestRequest req = new RestRequest();
     RestResponse res = new RestResponse();
         
     req.requestURI = '/services/apexrest/Log';  //Request URL
     req.httpMethod = 'GET';//HTTP Request Type
     RestContext.request = req;
     RestContext.response= res;

     LogJson log=LogInfo.doGet();
     }
     
     

    static testMethod void testLogJson() {
       //String json='{ "LogInfo": {  "Id": "10250","CreateDate": "2016-04-04"}}';
       
        String json=       '{'+
        '                "RETURN_CUST_INFO_WEB": {'+
        '                                "Account": {'+
        '                                                "SF_Account_ID":"3242342"'+
        '                                }'+
        '                }'+
        '}';
       system.debug('LogJson****'+json);
       System.assert(LogJson.parse(json)!= null);
     
    }
    
    
      
}