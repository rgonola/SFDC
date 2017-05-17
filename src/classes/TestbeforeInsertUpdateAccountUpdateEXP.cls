@isTest
public class TestbeforeInsertUpdateAccountUpdateEXP {

/*

static testMethod void TestbeforeInsertUpdateAccountUpdateEXP() {

 string acctRecNameRefund = 'Refunds Today Account';
 string RECORD_TYPE_ACCT_AMFSNS = 'AM/FS/NS Account';
    
    CS_TestData_Utility testUtility = new CS_TestData_Utility();//common utility class which is used to create the dumy data over the current org
    
    Id RefundsTodayRecordTypeId=[select Id from RecordType where Name=:acctRecNameRefund].Id;
    Id AMFSNSRecordTypeId = [SELECT Id FROM RecordType WHERE Name = :RECORD_TYPE_ACCT_AMFSNS].Id; 
    
    Account newAccount1 = testUtility.createAccountData(AMFSNSRecordTypeId,0, 'PID_001Test');

    newAccount1.Email__c = 'test1245896@gmail.com';

    Profile profiledata = [select Id FROM profile where name='System Administrator'];
        List<User> UserLst = new List<User>();
        //Creating User Record
    User objUser1 = new User();
        objUser1.FirstName ='testFirst1';
        objUser1.LastName = 'testLast1';
        objUser1.Email = 'test@gmail.com';
        objUser1.Alias = 'tesF1';
        objUser1.CommunityNickname='aTest1';
        objUser1.emailencodingkey='UTF-8';
        objUser1.Username = 'test1245896@gmail.com';
        objUser1.LocaleSidKey='en_US';
        objUser1.LanguageLocaleKey = 'en_US';    //Language
        objUser1.TimeZoneSidKey = 'America/New_York';    // Timezone
        objUser1.IsActive=true;
        objUser1.ProfileId =   profiledata.id; 
        objUser1.SALES_REP_CODE__c='3333333';  
        UserLst.add(objUser1);  
      
     User objUser2 = new User();
        objUser2.FirstName ='testFirst2';
        objUser2.LastName = 'testLasst2';
        objUser2.Email = 'test2@gmail.com';
        objUser2.Alias = 'tesF2';
        objUser2.CommunityNickname='aTest2';
        objUser2.emailencodingkey='UTF-8';
        objUser2.Username = 'test8956789@gmail.com';
        objUser2.LocaleSidKey='en_US';
        objUser2.LanguageLocaleKey = 'en_US';    //Language
        objUser2.TimeZoneSidKey = 'America/New_York';    // Timezone
        objUser2.IsActive=true;
        objUser2.SALES_REP_CODE__c='444444';
        objUser2.ProfileId =   profiledata.id;                                              
         
        UserLst.add(objUser2);
 
      insert UserLst;
      
      System.runAs(UserLst[0]){
          insert newAccount1;
      }
    
    list<Account> childAcctsLst = testUtility.createAccountDataLst(AMFSNSRecordTypeId,1, 'PID_001Test');
    
    insert childAcctsLst;
    
    
    for(Account accRec: [select id, ParentId from Account where id IN: childAcctsLst])
    {
        system.assertEquals(accRec.ParentId, newAccount1.Id);
    }

    
    
}



Commented by : Vivek Suryawanshi
Details: Commented since it test the trigger for older functionality, so creating a new method which will test the trigger for new functinality
    static testMethod void TestbeforeInsertUpdateAccountUpdateEXP() {
        
        Id RefundsTodayRecordTypeId=[select Id from RecordType where Name='Refunds Today Account'].Id;
        
        Account newAccount1 = new Account(Name = 'Test Account1 for Update EXP', RecordTypeId = RefundsTodayRecordTypeId, 
                                        Primary_Contact_Name__c = 'Test Contact', Email__c ='testcontact@test.com',
                                        Process__c = 'Sign & Close a Customer' );
        Account newAccount2 = new Account(Name = 'Test Account2 for Update EXP', RecordTypeId = RefundsTodayRecordTypeId, 
                                        Primary_Contact_Name__c = 'Test Contact', Email__c ='testcontact@test.com',
                                        Process__c = 'Sign & Close a prospect', Contract_Expiration_Date__c = '2011 EXP' );
        insert newAccount1;
        insert newAccount2;
        
        Account updateAccount1 = [SELECT Id,Process__c,Contract_Expiration_Date__c 
                                  FROM Account
                                  WHERE Id =:newAccount1.Id];
        //System.assertEquals(updateAccount1.Contract_Expiration_Date__c, '2013 EXP');
        Account updateAccount2 = [SELECT Id,Process__c,Contract_Expiration_Date__c 
                                  FROM Account
                                  WHERE Id =:newAccount2.Id];
        //System.assertEquals(updateAccount2.Contract_Expiration_Date__c, '2012 EXP');
        
        updateAccount1.Process__c = 'Sign & Close a prospect';
        update updateAccount1;
        updateAccount2.Process__c = 'Sign & Close a Customer';
        updateAccount2.Contract_Expiration_Date__c = '';
        update updateAccount2;
        
        Id AMFSNSaccountRecordTypeId=[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Account'].Id;
        Account account = new Account(Name = 'Test Account1 for Renewal Quote', RecordTypeId = AMFSNSaccountRecordTypeId, 
                                         Primary_Contact_Name__c = 'Test Contact', Email__c ='testcontact@test.com',
                                         CID__c = '444444', PID__c = '333333', OFFC__c = 0); 
        insert account;   
        
        Account account1 = new Account(Name = 'Test Account1 for Renewal Quote1', RecordTypeId = AMFSNSaccountRecordTypeId, 
                                         Primary_Contact_Name__c = 'Test Contact', Email__c ='testcontact@test.com',
                                         CID__c = '555555', PID__c = '333333', OFFC__c = 1); 
        insert account1;      
    }
    */
}