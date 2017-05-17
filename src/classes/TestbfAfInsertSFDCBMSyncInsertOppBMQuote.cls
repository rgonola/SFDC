/**********************************************************************
Name: TestbfAfInsertSFDCBMSyncInsertOppBMQuote 
Copyright © 2012 WK
======================================================
======================================================
Purpose: This test class is to do test coverage for the Trigger "bfAfInsertSFDCBMSyncInsertOpportunityBMQuote" 
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION    AUTHOR            DATE           DETAIL 
1.0        Rajesh Meti       13/Sep/2012   INITIAL DEVELOPMENT    
1.1        Vaibhav Kulkarni  24/May/2013   Test Coverage Updated
***********************************************************************/

/* @Description: Test class for 'bfAfInsertSFDCBMSyncInsertOpportunitybmq'
   @Modified By: Vaibhav Kulkarni
   @Date: 24.May.2013
*/ 
 
@isTest
private class TestbfAfInsertSFDCBMSyncInsertOppBMQuote  {
    static testMethod void myUnitTest() {
     integer testcount=101;
      
      //Commented @Vaibhav
      /*
        Test.startTest();
        
        Id AMFSNSAccountRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Account'].Id;
        
        Account accountItem = new Account(Name = 'Test Account111', 
                                          RecordTypeId = AMFSNSAccountRecordTypeId, 
                                          Type = 'New Customer', 
                                          PID__c = '11111111', 
                                          OFFC__c = 0);
        try{
            insert accountItem;
        }
        catch(Exception e){
            System.debug('Exception Occured: insert accountItem - ' + e);
        }
        
        SFDC_BM_Sync__c sfdcBMSyncItem = new SFDC_BM_Sync__c(OPPORTUNITY_NAME__c = 'TEST OPPORTUNITY111',   
                                                             STAGE__c = 'Needs Assessment',   
                                                             CLOSED_DATE__c = System.Today()+5,   
                                                             PID__c = '11111111',  
                                                             TYPE__c = 'Renewal',
                                                             QUOTE_NUMBER__c = '22222201');           
                                                          
        SFDC_BM_Sync__c sfdcBMSyncItem1 = new SFDC_BM_Sync__c(OPPORTUNITY_NAME__c = '',   
                                                             STAGE__c = 'Needs Assessment',   
                                                             CLOSED_DATE__c = System.Today()+5,   
                                                             PID__c = '11111111',  
                                                             TYPE__c = 'Renewal',
                                                             QUOTE_NUMBER__c = ''); 
        try{
            insert sfdcBMSyncItem;
            insert sfdcBMSyncItem1;            
        }
        catch(Exception e){
            System.debug('Exception Occured: insert sfdcBMSyncItem - ' + e);
        }                
        Test.stopTest();
    }
    */
    //Commented @Vaibhav
          
        Id AMFSNSAccountRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Account'].Id;

        List<Account> AccountLst = new List<Account>();
 
        Account acc1 = new Account(Name = 'Test Account111'+testcount, 
                                          RecordTypeId = AMFSNSAccountRecordTypeId, 
                                          Type = 'New Customer'+testcount, 
                                          PID__c = '11111'+testcount, 
                                          OFFC__c = 0);
        AccountLst.add(acc1);
        testcount++;
        Account acc2 = new Account(Name = 'Test Account1112'+testcount, 
                                          RecordTypeId = AMFSNSAccountRecordTypeId, 
                                          Type = 'New Customer'+testcount, 
                                          PID__c = '22222'+testcount, 
                                          OFFC__c = 0);
        AccountLst.add(acc2);
        insert AccountLst;
        
        Profile profiledata = [select Id FROM profile where name='System Administrator'];
        List<User> UserLst = new List<User>();
        //Creating User Record
        User objUser1 = new User();
            objUser1.FirstName ='testFirst1'+testcount;
            objUser1.LastName = 'testLast1'+testcount;
            objUser1.Email = 'test'+testcount+'@gmail.com';
            objUser1.Alias = 'tesF1'+testcount;
            objUser1.CommunityNickname='aTest1';
            objUser1.emailencodingkey='UTF-8';
            objUser1.Username = 'test124589sa6@gmail.com';
            objUser1.LocaleSidKey='en_US';
            objUser1.LanguageLocaleKey = 'en_US';    //Language
            objUser1.TimeZoneSidKey = 'America/New_York';    // Timezone
            objUser1.IsActive=true;
            objUser1.ProfileId =   profiledata.id; 
            objUser1.SALES_REP_CODE__c='33332'+testcount;  
            UserLst.add(objUser1);  
      
      User objUser2 = new User();
            objUser2.FirstName ='testFirst2'+testcount;
            objUser2.LastName = 'testLasst2'+testcount;
            objUser2.Email = 'test2'+testcount+'@gmail.com';
            objUser2.Alias = 'tesF2'+testcount;
            objUser2.CommunityNickname='aTest2'+testcount;
            objUser2.emailencodingkey='UTF-8';
            objUser2.Username = 'test84546789@gmail.com';
            objUser2.LocaleSidKey='en_US';
            objUser2.LanguageLocaleKey = 'en_US';    //Language
            objUser2.TimeZoneSidKey = 'America/New_York';    // Timezone
            objUser2.IsActive=true;
            objUser2.SALES_REP_CODE__c='444444';
            objUser2.ProfileId =   profiledata.id;                                              
            
            UserLst.add(objUser2);
 
       insert UserLst;

       List<SFDC_BM_Sync__c> SFDCBMSyncLst = new List<SFDC_BM_Sync__c>();
       Map<id,SFDC_BM_Sync__c> SFDCBMSyncMap = new Map<id,SFDC_BM_Sync__c>();
       SFDC_BM_Sync__c sfdcBMSyncItem;
       for(integer i=0;i<100;i++){
            sfdcBMSyncItem = new SFDC_BM_Sync__c(OPPORTUNITY_NAME__c = 'TEST OPPORTUNITY'+i,   
                                                             STAGE__c = 'Needs Assessment',   
                                                             CLOSED_DATE__c = System.Today()+5,   
                                                             PID__c = '1111111'+i,  
                                                             TYPE__c = 'Renewal',
                                                             SALES_REP_CODE__c = '333333'+i,
                                                             QUOTE_NUMBER__c = '88888'+i);
            SFDCBMSyncLst.add(sfdcBMSyncItem);   
        }       
        
        for(integer i=0;i<100;i++){
            sfdcBMSyncItem = new SFDC_BM_Sync__c(OPPORTUNITY_NAME__c = 'TEST OPPORTUNITY'+i,   
                                                             STAGE__c = 'Needs Assessment',   
                                                             CLOSED_DATE__c = System.Today()+5,   
                                                             PID__c = '2222222'+i,  
                                                             TYPE__c = 'Renewal',
                                                             SALES_REP_CODE__c = '444444'+i,
                                                             QUOTE_NUMBER__c = '99999'+i);
            SFDCBMSyncLst.add(sfdcBMSyncItem);    
        }    
        
       Test.startTest();                                                
        
       insert SFDCBMSyncLst;
       
       Test.stopTest();
       
       for(SFDC_BM_Sync__c sfdcBMSync:SFDCBMSyncLst){
           SFDCBMSyncMap.put((String)sfdcBMSync.id,sfdcBMSync);
       }
       
       List<Opportunity> oppLst = [Select id,Name,SFDC_BM_Sync_Id__c,StageName,CloseDate,Type From Opportunity];
       
       List<BigMachines__Quote__c> bigMachineQuoteLst = [Select id From BigMachines__Quote__c];
       
       System.assertEquals(SFDCBMSyncLst.size(),oppLst.size());
       System.assertEquals(SFDCBMSyncLst.size(),bigMachineQuoteLst.size());
    }
    
    //Creating SFDC_BM_Sync__c  Without Opportunity name so that Exception could also cover
    static testMethod void myUnitTests() {
    
       integer testcount=103;
        Id AMFSNSAccountRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Account'].Id;

        List<Account> AccountLst = new List<Account>();
 
        Account acc1 = new Account(Name = 'Test Account111'+testcount, 
                                          RecordTypeId = AMFSNSAccountRecordTypeId, 
                                          Type = 'New Customer', 
                                          PID__c = '11111'+testcount, 
                                          OFFC__c = 0);
        AccountLst.add(acc1);
 
        insert AccountLst;
        
        Profile profiledata = [select Id FROM profile where name='System Administrator'];
        List<User> UserLst = new List<User>();
        //Creating User Record
        User objUser1 = new User();
            objUser1.FirstName ='testFirst1'+testcount;
            objUser1.LastName = 'testLast1'+testcount;
            objUser1.Email = 'test'+testcount+'@gmail.com';
            objUser1.Alias = 'tesF1';
            objUser1.CommunityNickname='aTest1'+testcount;
            objUser1.emailencodingkey='UTF-8';
            objUser1.Username = 'test1245893436@gmail.com';
            objUser1.LocaleSidKey='en_US';
            objUser1.LanguageLocaleKey = 'en_US';    //Language
            objUser1.TimeZoneSidKey = 'America/New_York';    // Timezone
            objUser1.IsActive=true;
            objUser1.ProfileId =   profiledata.id; 
            objUser1.SALES_REP_CODE__c='33332223';  
            UserLst.add(objUser1);  
  
       insert UserLst;

       List<SFDC_BM_Sync__c> SFDCBMSyncLst = new List<SFDC_BM_Sync__c>();
       Map<id,SFDC_BM_Sync__c> SFDCBMSyncMap = new Map<id,SFDC_BM_Sync__c>();
       SFDC_BM_Sync__c sfdcBMSyncItem;
       for(integer i=200;i<300;i++){
            sfdcBMSyncItem = new SFDC_BM_Sync__c(STAGE__c = 'Needs Assessment',   
                                                             CLOSED_DATE__c = System.Today()+5,   
                                                             PID__c = '11111111'+i,  
                                                             TYPE__c = 'Renewal',
                                                             SALES_REP_CODE__c = '3333333'+i,
                                                             QUOTE_NUMBER__c = '88888'+i);
            SFDCBMSyncLst.add(sfdcBMSyncItem);   
        }       
       
       try{
           insert SFDCBMSyncLst;
       }
       catch(Exception e){}

    }
}