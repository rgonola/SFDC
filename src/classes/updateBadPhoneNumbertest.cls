@isTest()
Public class updateBadPhoneNumbertest{


  static testMethod void badphone(){
  
  
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
        
   String userId = UserInfo.getUserId();
               Task t = new Task();
                t.OwnerId = userId;
                t.Subject = 'Duplicate Url found Process Error For iFirm Provisioning';
                t.Status = 'Open';
                t.Priority = 'High';
                t.WhatId = account.id;
                t.WhoId= cont.id;
                
                t.Call_Result__c ='Bad Phone Number';
                
                
             Test.starttest();   
                insert t;
  
  
             Test.StopTest();
  
  
  
  
  }







}