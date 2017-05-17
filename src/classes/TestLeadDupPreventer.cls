/**********************************************************************
Name: TestLeadDupPreventer
Copyright © 2012 WK
======================================================
======================================================
Purpose: This test class is to do test coverage for the Trigger "leadDuplicatePreventer" 
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR      DATE       DETAIL 
1.0       Aditya      10/03/2012 INITIAL DEVELOPMENT
2.0       Vaibhav     12/06/2013 Test class for class 'leadDuplicatePreventer'
3.0       Rajesh Wani 12/06/2013 Test class for class 'leadDuplicatePreventer'
***********************************************************************/
@isTest
public class TestLeadDupPreventer{
    static testMethod void TestLeadDupPreventer() {
        
        
        
        // Get Lead  Recordtype id by dynamic apex
        schema.describesobjectresult leadDescribe      = Lead.sobjecttype.getdescribe();
        map<string,schema.recordtypeinfo> leadRecTypeInfo   = leadDescribe.getrecordtypeinfosbyname();
        Id AMFSNSRecordTypeId = leadRecTypeInfo.get('AM/FS/NS Lead').getrecordtypeid();
        Id RefundsTodayRecordTypeId =leadRecTypeInfo.get('Leads Refunds Today').getrecordtypeid();
        
         
        // Get Account Recordtype id by dynamic apex
        schema.describesobjectresult accDescribe      = Account.sobjecttype.getdescribe();
        map<string,schema.recordtypeinfo> recTypeInfo = accDescribe.getrecordtypeinfosbyname();
        
        Id AMFSNSAccountRecordTypeId       = recTypeInfo.get('AM/FS/NS Account').getrecordtypeid();
        Id RefundsTodayAccountRecordTypeId = recTypeInfo.get('Refunds Today Account').getrecordtypeid();
        
       
        
    List<Lead> newLeadListAMFSNSRecordTypeId = new List<Lead>();
    
        //Creating the Lead Data for Comparing with the newly adding Data of AMFSNSRecordTypeId record type
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            //newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest'+cnt;
            newLead.Email='EmailTest'+cnt+'@test.com';
            newLead.Phone='117654320'+cnt;
            newLead.Fax='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            if(cnt<>4 && cnt<>5){
                newLead.Street__c = 'Test Street'+cnt;
                newLead.City__c = 'Test City'+cnt;
                newLead.State_Province__c = 'Test State'+cnt;
                newLead.Country__c = 'Test Country'+cnt;
                newLead.Zip_Postal_Code__c = '00000'+cnt;
            }
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            newLeadListAMFSNSRecordTypeId.add(newLead);
        }
        
        Test.StartTest();
        try{
            insert newLeadListAMFSNSRecordTypeId;
        }
        catch(DmlException e){}
        
        //Creating the Lead Data for Comparing with the newly adding Data of RefundsTodayRecordTypeId record type
        List<Lead> newLeadListRefundsTodayRecordTypeId = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTestRefund'+cnt;
            newLead.Email='EmailTestGeneric'+cnt+'@test.com';
            newLead.Phone='458963256'+cnt;
            newLead.Fax='117654320'+cnt;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Zip_Postal_Code__c = '12563'+cnt;
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            newLeadListRefundsTodayRecordTypeId.add(newLead);
        }
            
            try{
                insert newLeadListRefundsTodayRecordTypeId;
            }
            catch(Exception e){}
            
        Test.StopTest();
        
        //Creating Lead Record with the Primary_Contact_Name__c not null and Process__c is 'Sign and Close a Prospect'
        List<Lead> newLeadListPrimaryContact = new List<Lead>();
        for(Integer cnt=1; cnt<=3; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest';
            newLead.Email='EmailTest@test.com';
            newLead.Phone='1176543202';
            newLead.Fax='117654320'+cnt;
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Primary_Contact_Name__c='Test Primary Contact';
            newLead.Zip_Postal_Code__c = '000001';
            newLead.Process__c='Sign and Close a Prospect';
            
            newLead.Contract_Expiration_Date__c='2012';
            newLeadListPrimaryContact.add(newLead);
            }
            
           for(Integer cnt=4; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest';
            newLead.Email='EmailTest@test.com';
            newLead.Phone='1176543202';
            newLead.Fax='117654320'+cnt;
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Primary_Contact_Name__c='Test Primary Contact';
            newLead.Zip_Postal_Code__c = '000001';
            newLead.Process__c='Sign and Close a Prospect';
            
            newLead.Contract_Expiration_Date__c='';
            newLeadListPrimaryContact.add(newLead);
            }

        try{
            insert newLeadListPrimaryContact;
        }
        catch(DmlException e){}
        
        List<Lead> LeadLstUpdateForProcess = new List<Lead>();
        for(Lead ld:newLeadListAMFSNSRecordTypeId){
            ld.Process__c='Request UTS Release';
            LeadLstUpdateForProcess.add(ld);
        }
        update LeadLstUpdateForProcess;
        
       List<Lead> LeadLstUpdateForProcessup = new List<Lead>();
        for(Lead ld:newLeadListAMFSNSRecordTypeId){
            ld.Process__c='Sign and Close a Prospect';
            LeadLstUpdateForProcessup.add(ld);
        }
        update LeadLstUpdateForProcessup;
                
        //Creating Account Records With the Record Type AMFSNSRecordTypeId
        integer recordcount=104;
        List<Account> AccountAMFSNSRecordTypeIdList = new List<Account>();
        for(integer cnt=0;cnt<5;cnt++){
            Account acc = new Account();
            acc.RecordTypeId = AMFSNSAccountRecordTypeId;
            acc.name='TestAccountInsert'+cnt+recordcount;
            //acc.Email__c='EmailTest'+cnt+'@testCCH.com';
           // acc.Phone__c='117654320'+cnt;
            
            //Appending the Company Name and Zipcode for comparison of Lead Address(Company name and Zipcode)
            String companyName = 'CompanyTest'+cnt;
            companyName = companyName.toLowerCase();
            String zipcode = '00000'+cnt;
            acc.Account_Name_Address_Merge__c = companyName+zipcode;
            System.debug('----------------------'+companyName+zipcode);
            AccountAMFSNSRecordTypeIdList.add(acc);
        }
        insert AccountAMFSNSRecordTypeIdList;
        
        
        //Creating new Data which will compare with the existing data of Record Type AMFSNSRecordType
        List<Lead> leadListAMFSNSRecordType = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest'+cnt;
            newLead.Email='EmailTest'+cnt+'@test.com';
            newLead.Phone='117654320'+cnt;
            newLead.Fax='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Zip_Postal_Code__c = '00000'+cnt;
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            leadListAMFSNSRecordType.add(newLead);
        }
        try{
            insert leadListAMFSNSRecordType;
        }
        catch(DmlException e){}

        //Creating new Data which will compare with the existing data of Record Type RefundsTodayRecordTypeId
        //For Making the Duplication for Company and Zipcode
        List<Lead> leadListRefundsTodayRecordTypeId = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            if(cnt == 2){
                newLead.Company='CompanyTestRefund'+(cnt-1);
                newLead.Zip_Postal_Code__c = '12563'+(cnt-1);
                newLead.IsWebToLead__c = true;
            }
            newLead.Email='EmailTest'+cnt+'@test.com';
            newLead.Phone='117654320'+cnt;
            newLead.Fax='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            leadListRefundsTodayRecordTypeId.add(newLead);
        }
        try{
            insert leadListRefundsTodayRecordTypeId;
        }
        catch(DmlException e){}
        
        //Creating new Data which will compare with the existing data of Record Type RefundsTodayRecordTypeId
        //For Making the Duplication for Phone and Email
        List<Lead> leadListRefundsTodayRecordTypeIdPhoneEmail = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTestExist'+cnt;
            newLead.Email='EmailTestGeneric'+cnt+'@test.com';
            newLead.Phone='458963256'+cnt;
            newLead.Fax='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Zip_Postal_Code__c = '000011'+cnt;
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            leadListRefundsTodayRecordTypeIdPhoneEmail.add(newLead);
        }
        
        try{
            
                insert leadListRefundsTodayRecordTypeIdPhoneEmail;

            }
        
        catch(DmlException e){}
    }   
    
    static testMethod void TestPrimaryContactName() {

        Id AMFSNSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
        Id RefundsTodayRecordTypeId=[select Id from RecordType where Name='Leads Refunds Today'].Id;
     
        //Creating records with Primary_Contact_Name__c as null and First name has some value
        List<Lead> newLeadListWithFirstName = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest';
            newLead.LastName='LastNameTest';
            newLead.Company='CompanyTestFORAMLD'+cnt;
            newLead.Email='EmailTestAM'+cnt+'@test.com';
            newLead.Phone='859689628'+cnt;
            newLead.Fax='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Primary_Contact_Name__c ='';
            newLead.Zip_Postal_Code__c = '56896'+cnt;
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            newLead.Contract_Expiration_Date__c='2012';
            newLead.Process__c='Send Demo to Prospect';
            newLeadListWithFirstName.add(newLead);
        }
        
        Test.StartTest();
        try{
            insert newLeadListWithFirstName;
        }
        catch(Exception e){}
        
        List<Lead> updateListForExp = new List<Lead>();
        for(Lead ld:newLeadListWithFirstName){
            ld.Contract_Expiration_Date__c='2012';
            ld.Process__c='Sign and Close a Prospect';
            updateListForExp.add(ld);
        }
        update updateListForExp;
        
        /*
        for(Lead ldd:[Select id,Primary_Contact_Name__c From Lead Where id =:newLeadListWithFirstName[0].id]){
            System.assertEquals(ldd.Primary_Contact_Name__c,'FirstNameTest'+' '+'LastNameTest');
        }
        */
        
        //Creating records with Primary_Contact_Name__c as null and First name does not have some value
        List<Lead> newLeadListWithoutFirstName = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            //newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTestAMSF'+cnt;
            newLead.Email='EmailTestAMRec'+cnt+'@test.com';
            newLead.Phone='895689625'+cnt;
            newLead.Fax='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Zip_Postal_Code__c = '78569'+cnt;
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            newLeadListWithoutFirstName.add(newLead);
        }
          
            insert newLeadListWithoutFirstName;
            Test.StopTest();
      }
      
      
      static testmethod void testpreventDuplicationOfLead(){
      
        Id AMFSNSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
        Id RefundsTodayRecordTypeId=[select Id from RecordType where Name='Leads Refunds Today'].Id;
        
        //Creating a Lead of RecordType 'Refund' 
        Lead newLeadA = new Lead();
            newLeadA.FirstName='FirstNameTest';
            newLeadA.LastName='LastNameTest';
            newLeadA.Company='CompanyTest';
            newLeadA.Email='EmailTest@test.com';
            newLeadA.Phone='1234567';
            newLeadA.Fax='1234567';
            newLeadA.Source_Code__c='Additional Office';
            newLeadA.recordTypeId = RefundsTodayRecordTypeId;
            newLeadA.SALES_REP_CODE__c = '1234567'; 
            newLeadA.IsWebToLead__c=True;
            newLeadA.Contract_Expiration_Date__c = '';
            insert newLeadA;
            
         //Creating another Lead of RecordType 'Refund' to simulate duplication
         // Result : insertion causes custom validation exception
         Lead newLeadB = new Lead();
            newLeadB.FirstName='FirstNameTest';
            newLeadB.LastName='LastNameTest';
            newLeadB.Company='CompanyTest';
            newLeadB.Email='EmailTest@test.com';
            newLeadB.Phone='1234567';
            newLeadB.Fax='1234567';
            newLeadB.Source_Code__c='Advertisement';
            newLeadB.recordTypeId = RefundsTodayRecordTypeId;
            newLeadB.SALES_REP_CODE__c = '1234567'; 
            newLeadB.IsWebToLead__c=True;
            newLeadB.Contract_Expiration_Date__c = '';
            
        //Creating another Lead of RecordType 'AM/FS/NS' to simulate duplication with sameemail id but different recordtype
        // Result : insert is allowed/passes
        
         Lead newLeadC = new Lead();
            newLeadC.FirstName='FirstNameTest';
            newLeadC.LastName='LastNameTest';
            newLeadC.Company='CompanyTest';
            newLeadC.Email='EmailTest@test.com';
            newLeadC.Phone='12345670';
            newLeadC.Fax='1234567';
            newLeadC.Source_Code__c='Advertisement';
            newLeadC.recordTypeId = AMFSNSRecordTypeId;
            newLeadC.SALES_REP_CODE__c = '1234567';
            newLeadC.IsWebToLead__c=True; 
            newLeadC.Contract_Expiration_Date__c = '';
        
        //inserting lead with null email hence skips any kind of validation
        Lead newLeadD = new Lead();
            newLeadD.FirstName='FirstNameTest';
            newLeadD.LastName='LastNameTest';
            newLeadD.Company='CompanyTest';
            newLeadD.Email=NULL;
            newLeadD.Phone='1234567';
            newLeadD.Fax='1234567';
            newLeadD.Source_Code__c='Advertisement';
            newLeadD.recordTypeId = AMFSNSRecordTypeId;
            newLeadD.SALES_REP_CODE__c = '1234567';
            newLeadD.IsWebToLead__c=True; 
            newLeadD.Contract_Expiration_Date__c = '';
        
                
            //Creating user record 
            Profile p = [select id from profile where name='Standard User'];
            User u = new User(alias = 'standt', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='TestingCCH', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,Isactive=True,
            timezonesidkey='America/Los_Angeles', username='standarduserCCH@testCCHorg.com');  
            u.SALES_REP_CODE__c='1234567';
            
            insert u;
        Test.StartTest();
        
        insert  newLeadC;
        //insert newLeadD;
        try{
            insert newLeadB;
        }
        catch(DmlException e){
          //system.assert(e.getmessage().contains('A lead with this email address already exists'));
          //system.assertequals('A lead with this email address already exists: []',e.getmessage().split(',',2).get(1).trim());
          system.debug('****' + e.getmessage());
       
       
       
       Test.StopTest();    
        }
      }
      /*
        List<Lead> newLeadList = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest'+cnt;
            newLead.Email='EmailTest'+cnt+'@test.com';
            newLead.Phone='117654320'+cnt;
            newLead.Fax='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            if(cnt<>4 && cnt<>5){
                newLead.Street__c = 'Test Street'+cnt;
                newLead.City__c = 'Test City'+cnt;
                newLead.State_Province__c = 'Test State'+cnt;
                newLead.Country__c = 'Test Country'+cnt;
                newLead.Zip_Postal_Code__c = '00000'+cnt;
            }
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            newLeadList.add(newLead);
        }
        try{
            insert newLeadList;
        }
        catch(DmlException e){}
        
        //Added by aditya on 18/06/2012
        List<Lead> newLeadList6 = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            //newLead.FirstName='FirstNameTest'+cnt;
            //newLead.LastName='LastNameTest'+cnt;
            newLead.FirstName='';
            newLead.LastName='';
            newLead.Company='CompanyTest'+cnt;
            newLead.Email='EmailTest'+cnt+'@test.com';
            newLead.Phone='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            if(cnt<>4 && cnt<>5){
                newLead.Street__c = 'Test Street'+cnt;
                newLead.City__c = 'Test City'+cnt;
                newLead.State_Province__c = 'Test State'+cnt;
                newLead.Country__c = 'Test Country'+cnt;
                newLead.Zip_Postal_Code__c = '00000'+cnt;
            }
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            newLeadList6.add(newLead);
        }
        try{
            insert newLeadList6;
        }
        catch(DmlException e){}
        //Aditya code ends here
        
        List<Lead> newLeadList1 = new List<Lead>();
        for(Integer cnt=1; cnt<=2; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest'+cnt;
            newLead.Email='EmailTest'+cnt+'@test.com';
            newLead.Phone='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Street__c = 'Test Street'+cnt;
            newLead.City__c = 'Test City'+cnt;
            newLead.State_Province__c = 'Test State'+cnt;
            newLead.Country__c = 'Test Country'+cnt;
            newLead.Zip_Postal_Code__c = '00000'+cnt;
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            newLeadList1.add(newLead);
        }
        try{
            insert newLeadList1;
        }
        catch(DmlException e){}
        
        List<Lead> newLeadList2 = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest';
            newLead.LastName='LastNameTest';
            newLead.Company='CompanyTest';
            newLead.Email='EmailTest@test.com';
            newLead.Phone='1176543201';
            newLead.EFIN__c = 'TestEFIN1';
            newLead.Street__c = 'Test Street';
            newLead.City__c = 'Test City';
            newLead.State_Province__c = 'Test State';
            newLead.Country__c = 'Test Country';
            newLead.Zip_Postal_Code__c = '000001';
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            newLeadList2.add(newLead);
        }
        try{
            insert newLeadList2;
        }
        catch(DmlException e){}
        
        Lead updateLead = [SELECT FirstName,Email,Phone FROM Lead WHERE Id=:newLeadList[0].id];
        updateLead.FirstName='FirstNameTest1';
        updateLead.LastName='LastNameTest1';
        updateLead.Company='CompanyTest1';
        updateLead.Email='EmailTest1@test.com';
        updateLead.Phone='1176543201';
        updateLead.EFIN__c = 'TestEFIN1';
        updateLead.Street__c = 'Test Street1';
        updateLead.City__c = 'Test City1';
        updateLead.State_Province__c = 'Test State1';
        updateLead.Country__c = 'Test Country1';
        updateLead.Zip_Postal_Code__c = '000001';
        try{
            update updateLead;
        }
        catch(DmlException e){}
        
        Lead webToLead = new Lead();
        webToLead.FirstName='FirstNameTest11';
        webToLead.LastName='LastNameTest11';
        webToLead.Company='CompanyTest11';
        webToLead.Email='EmailTest11@test.com';
        webToLead.Phone='1176542211';
        webToLead.EFIN__c = 'TestEFIN11';
        webToLead.Street__c = 'Test Street11';
        webToLead.City__c = 'Test City11';
        webToLead.State_Province__c = 'Test State11';
        webToLead.Country__c = 'Test Country11';
        webToLead.Zip_Postal_Code__c = '000011';
        webToLead.IsWebToLead__c = true;
        webToLead.RecordTypeId = AMFSNSRecordTypeId;
        try{
            insert webToLead;
        }
        catch(DmlException e){}
        
        webToLead = new Lead();
        webToLead.FirstName='FirstNameTest11';
        webToLead.LastName='LastNameTest11';
        webToLead.Company='CompanyTest11';
        webToLead.Email='EmailTest11@test.com';
        webToLead.Phone='1176542211';
        webToLead.EFIN__c = 'TestEFIN11';
        webToLead.Street__c = 'Test Street11';
        webToLead.City__c = 'Test City11';
        webToLead.State_Province__c = 'Test State11';
        webToLead.Country__c = 'Test Country11';
        webToLead.Zip_Postal_Code__c = '000011';
        webToLead.IsWebToLead__c = true;
        webToLead.RecordTypeId = AMFSNSRecordTypeId;
        try{
            insert webToLead;
        }
        catch(DmlException e){}
        
        
        //Creating the Lead records with the Record Type 'Leads Refunds Today'
        List<Lead> newLeadListForRefundsTodayRecordTypeIdExistingRecord = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest';
            newLead.LastName='LastNameTest';
            newLead.Company='CompanyTest';
            newLead.Email='EmailTest@test.com';
            newLead.Phone='1176543201';
            newLead.EFIN__c = 'TestEFIN1';
            newLead.Street__c = 'Test Street';
            newLead.City__c = 'Test City';
            newLead.State_Province__c = 'Test State';
            newLead.Country__c = 'Test Country';
            newLead.Zip_Postal_Code__c = '000001';
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            newLead.Contract_Expiration_Date__c='6/12/2015';
            newLead.Process__c='Sign and Close a Prospect';
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            newLeadListForRefundsTodayRecordTypeIdExistingRecord .add(newLead);
            
            try{
                insert newLeadListForRefundsTodayRecordTypeIdExistingRecord ;
            }
            catch(Exception e){}
        }
        
        List<Lead> newLeadListForRefundsTodayRecordTypeId = new List<Lead>();
        for(Integer cnt=1; cnt<=5; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest';
            newLead.LastName='LastNameTest';
            newLead.Company='CompanyTestDemo'+cnt;
            newLead.Email='TestingEmailForLead'+cnt+'@test.com';
            newLead.Phone='745896325'+cnt;
            newLead.EFIN__c = 'TestEFIN1';
            newLead.Street__c = 'Test Street';
            newLead.City__c = 'Test City';
            newLead.State_Province__c = 'Test State';
            newLead.Country__c = 'Test Country';
            newLead.Zip_Postal_Code__c = '12563'+cnt;
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            newLead.Process__c='Send Demo to Prospect';
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            newLeadListForRefundsTodayRecordTypeId.add(newLead);
            
            //try{
                //insert newLeadListForRefundsTodayRecordTypeId;
           // }
            //catch(Exception e){}
            
            List<Lead> LeadUpdate = new List<Lead>();
            for(Lead ld:newLeadListForRefundsTodayRecordTypeId){
            
                ld.Process__c='Send Email to Prospect';
                LeadUpdate.add(ld);
            }
            
            //update LeadUpdate ;
        }
    
    */
    /* Method added @ 11/9/2013 by Rajesh Wani
       
    */
    static testmethod void  LeadPreventerWithSameRecordTypePhoneValidation(){
         // Get Lead  Recordtype id by dynamic apex
        schema.describesobjectresult leadDescribe      = Lead.sobjecttype.getdescribe();
        map<string,schema.recordtypeinfo> leadRecTypeInfo   = leadDescribe.getrecordtypeinfosbyname();
        Id AMFSNSRecordTypeId = leadRecTypeInfo.get('AM/FS/NS Lead').getrecordtypeid();
        Id RefundsTodayRecordTypeId =leadRecTypeInfo.get('Leads Refunds Today').getrecordtypeid();
        
         
        // Get Account Recordtype id by dynamic apex
        schema.describesobjectresult accDescribe      = Account.sobjecttype.getdescribe();
        map<string,schema.recordtypeinfo> recTypeInfo = accDescribe.getrecordtypeinfosbyname();
        
        Id AMFSNSAccountRecordTypeId       = recTypeInfo.get('AM/FS/NS Account').getrecordtypeid();
        Id RefundsTodayAccountRecordTypeId = recTypeInfo.get('Refunds Today Account').getrecordtypeid();
         
          List<Lead> newLeadListAMFSNSRecordTypeId = new List<Lead>();
    
        //Creating the Lead Data for Comparing with the newly adding Data of AMFSNSRecordTypeId record type
        for(Integer cnt=1; cnt<=200; cnt++){
            Lead newLead = new Lead();
            //newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest'+cnt;
            newLead.Email='EmailTest'+cnt+'@test.com';
            newLead.Phone__c='458963'+cnt;
            newLead.Fax='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            if(cnt<>4 && cnt<>5){
                newLead.Street__c = 'Test Street'+cnt;
                newLead.City__c = 'Test City'+cnt;
                newLead.State_Province__c = 'Test State'+cnt;
                newLead.Country__c = 'Test Country'+cnt;
                newLead.Zip_Postal_Code__c = '00000'+cnt;
            }
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            newLeadListAMFSNSRecordTypeId.add(newLead);
        }
        
       
        try{
            insert newLeadListAMFSNSRecordTypeId;
        }
        catch(DmlException e){}
        
        
           //Creating the Lead Data for Comparing with the newly adding Data of AMFSNSRecordTypeId record type 
           // Testing phone validation
        List<Lead> dupNewLeadListAMFSNSRecordTypeId = new List<Lead>();
        for(Integer cnt=1; cnt<=200; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTestRefund'+cnt;
            newLead.Email='EmailTestGenericTest'+cnt+'@test.com';
            newLead.Phone__c='458963'+cnt;
            newLead.Fax='117654320'+cnt;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Zip_Postal_Code__c = '12563'+cnt;
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            dupNewLeadListAMFSNSRecordTypeId.add(newLead);
        }
         
         Test.StartTest();
            try{
                insert dupNewLeadListAMFSNSRecordTypeId;
            }
            catch(Exception e){
                
              system.assert(e.getmessage().contains('A lead with this phone number already exists'));  
            }
            
            integer recordcount=105;
         //Creating Account Records With the Record Type AMFSNSRecordTypeId
        List<Account> AccountAMFSNSRecordTypeIdList = new List<Account>();
        for(integer cnt=0;cnt<200;cnt++){
            Account acc = new Account();
            acc.RecordTypeId = AMFSNSAccountRecordTypeId;
            acc.name='TestAccountInsert'+cnt+recordcount;
            acc.Phone__c ='45896'+cnt;
            String companyName = 'CompanyTest'+cnt;
            companyName = companyName.toLowerCase();
            String zipcode = '00000'+cnt;
            acc.Account_Name_Address_Merge__c = companyName+zipcode;
            System.debug('----------------------'+companyName+zipcode);
            AccountAMFSNSRecordTypeIdList.add(acc);
        }
        insert AccountAMFSNSRecordTypeIdList;
        
         //Creating the Lead Data for Comparing with the newly adding Data of AMFSNSRecordTypeId record type 
           // Testing phone validation with Account
        List<Lead> dupNewLeadListAMFSNS = new List<Lead>();
        for(Integer cnt=0; cnt<200; cnt++){
            Lead newLead = newLeadListAMFSNSRecordTypeId[cnt];
            
            newLead.Phone__c='45896'+cnt;
            newLead.Fax='117654320'+cnt;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Zip_Postal_Code__c = '12563'+cnt;
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            dupNewLeadListAMFSNS.add(newLead);
        }
         
        
            try{
                update dupNewLeadListAMFSNS;
            }
            catch(Exception e){
              system.assert(e.getmessage().contains('An Account with this phone number already exists'));  
            }
            
         Test.stopTest();   
    }// End of method LeadPreventerWithSameRecordType ()
    
    
    /* Method added @ 11/9/2013 by Rajesh Wani
       
    */
    static testmethod void  LeadPreventerWithSameRecordTypeEmailValidation(){
         // Get Lead  Recordtype id by dynamic apex
        schema.describesobjectresult leadDescribe      = Lead.sobjecttype.getdescribe();
        map<string,schema.recordtypeinfo> leadRecTypeInfo   = leadDescribe.getrecordtypeinfosbyname();
        Id AMFSNSRecordTypeId = leadRecTypeInfo.get('AM/FS/NS Lead').getrecordtypeid();
        Id RefundsTodayRecordTypeId =leadRecTypeInfo.get('Leads Refunds Today').getrecordtypeid();
        
         
        // Get Account Recordtype id by dynamic apex
        schema.describesobjectresult accDescribe      = Account.sobjecttype.getdescribe();
        map<string,schema.recordtypeinfo> recTypeInfo = accDescribe.getrecordtypeinfosbyname();
        
        Id AMFSNSAccountRecordTypeId       = recTypeInfo.get('AM/FS/NS Account').getrecordtypeid();
        Id RefundsTodayAccountRecordTypeId = recTypeInfo.get('Refunds Today Account').getrecordtypeid();
         
          List<Lead> newLeadListRefundsToday = new List<Lead>();
    
        //Creating the Lead Data for Comparing with the newly adding Data of RefundsTodayRecordTypeId record type
        for(Integer cnt=1; cnt<=200; cnt++){
            Lead newLead = new Lead();
            //newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTest'+cnt;
            newLead.Email='EmailTest'+cnt+'@test.com';
            
            newLead.Fax='117654320'+cnt;
            newLead.EFIN__c = 'TestEFIN'+cnt;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            if(cnt<>4 && cnt<>5){
                newLead.Street__c = 'Test Street'+cnt;
                newLead.City__c = 'Test City'+cnt;
                newLead.State_Province__c = 'Test State'+cnt;
                newLead.Country__c = 'Test Country'+cnt;
                newLead.Zip_Postal_Code__c = '00000'+cnt;
            }
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            newLeadListRefundsToday.add(newLead);
        }
        
       
        try{
            insert newLeadListRefundsToday;
        }
        catch(DmlException e){}
        
        
           //Creating the Lead Data for Comparing with the newly adding Data of RefundsTodayRecordTypeId record type 
           // Testing phone validation
        List<Lead> dupNewLeadListRefundsTodayRecordTypeId = new List<Lead>();
        for(Integer cnt=1; cnt<=200; cnt++){
            Lead newLead = new Lead();
            newLead.FirstName='FirstNameTest'+cnt;
            newLead.LastName='LastNameTest'+cnt;
            newLead.Company='CompanyTestRefund'+cnt;
            newLead.Email='EmailTest'+cnt+'@test.com';
            newLead.Phone__c='458963'+cnt;
            newLead.Fax='117654320'+cnt;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Zip_Postal_Code__c = '12563'+cnt;
            newLead.RecordTypeId = RefundsTodayRecordTypeId;
            dupNewLeadListRefundsTodayRecordTypeId.add(newLead);
        }
         
         Test.StartTest();
            try{
                insert dupNewLeadListRefundsTodayRecordTypeId;
            }
            catch(Exception e){
                
              system.assert(e.getmessage().contains('A lead with this email address already exists'));  
            }
            
            integer recordcount=106;
         //Creating Account Records With the Record Type RefundsTodayAccountRecordTypeId
        List<Account> AccountEmailRefundsToday = new List<Account>();
        for(integer cnt=0;cnt<200;cnt++){
            Account acc = new Account();
            acc.RecordTypeId = RefundsTodayAccountRecordTypeId;
            acc.name='TestAccountInsert'+cnt+recordcount;
            acc.Email__c ='AccEmailValidationTest'+cnt+'@test.com'; 
            String companyName = 'CompanyTest'+cnt;
            companyName = companyName.toLowerCase();
            String zipcode = '0000'+cnt;
            acc.Primary_Contact_Name__c= 'Test Primary Contact'+cnt;
            acc.Account_Name_Address_Merge__c = companyName+zipcode;
            System.debug('----------------------'+companyName+zipcode);
            AccountEmailRefundsToday.add(acc);
        }
        insert AccountEmailRefundsToday;
        
         //Creating the Lead Data for Comparing with the newly adding Data of RefundsTodayRecordTypeId record type 
           // Testing phone validation with Account
        List<Lead> dupNewLeadListRefundsToday = new List<Lead>();
        for(Integer cnt=0; cnt<200; cnt++){
            Lead newLead = newLeadListRefundsToday[cnt];
            
            newLead.Email = 'AccEmailValidationTest'+cnt+'@test.com';
            newLead.Fax='117654320'+cnt;
            if(cnt==2){
                newLead.IsWebToLead__c = true;
            }
            newLead.EFIN__c = 'TestEFIN'+cnt;
            newLead.Zip_Postal_Code__c = '12563'+cnt;
            newLead.RecordTypeId = AMFSNSRecordTypeId;
            dupNewLeadListRefundsToday.add(newLead);
        }
         
        
            try{
                update dupNewLeadListRefundsToday;
            }
            catch(Exception e){
                system.assert(e.getmessage().contains('A lead with this email address already exists'));
            }
            
         Test.stopTest();   
    }// End of method LeadPreventerWithSameRecordType ()
}