/**********************************************************************
Name: TestLeadContractExpirationDate
Copyright © 2012 WK
======================================================
======================================================
Purpose: This test class is to do test coverage for the Trigger "leadDuplicatePreventer" for Contract Expiration Date Update
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Natesh   24/07/2012 INITIAL DEVELOPMENT
***********************************************************************/
@isTest
private class TestLeadContractExpirationDate {

    static testMethod void myUnitTest() {
        Id RefundsTodayRecordTypeId=[select Id from RecordType where Name='Leads Refunds Today'].Id;
        //Id AMFSNSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;    
        
        //Update Contract Expiration Date
        List<Lead> newLeadList = new List<Lead>();
        Lead newLead1 = new Lead();
        newLead1.FirstName='FirstNameTestContract1';
        newLead1.LastName='LastNameTestContract1';
        newLead1.Company='MIUnitTest1';
        newLead1.IsWebToLead__c= true;
        newLead1.Email='EmailTestContract1@test.com';
        newLead1.Phone='1212121111';
        newLead1.Process__c = 'Send Email to Prospect';
        newLead1.RecordTypeId = RefundsTodayRecordTypeId;
        newLeadList.add(newLead1);
        
        Lead newLead2 = new Lead();
        newLead2.FirstName='FirstNameTestContract2';
        newLead2.LastName='LastNameTestContract2';
        newLead2.Company='GE';
        newLead2.Email='EmailTestContract2@test.com';
        newLead2.Phone='9897458965';
        newLead2.Process__c = 'Sign and Close a Prospect';
        newLead2.RecordTypeId = RefundsTodayRecordTypeId;
        newLead2.Contract_Expiration_Date__c = '2011 EXP';
        newLeadList.add(newLead2);
        
        Lead newLead3 = new Lead();
        newLead3.FirstName='FirstNameTestContract3';
        newLead3.LastName='LastNameTestContract3';
        newLead3.Company='EI';
        newLead3.Email='EmailTestContract3@test.com';
        newLead3.Phone='9845789635';
        newLead3.Process__c = 'Send Email to Prospect';
        newLead3.RecordTypeId = RefundsTodayRecordTypeId;
        newLead3.Contract_Expiration_Date__c = '2013 EXP';
        newLeadList.add(newLead3);
        
        Lead newLead4 = new Lead();
        newLead4.FirstName='FirstNameTestContract4';
        newLead4.LastName='LastNameTestContract4';
        newLead4.Company='MSC';
        newLead4.Email='EmailTestContract4@test.com';
        newLead4.Phone='989657894';
        newLead4.Process__c = 'Sign and Close a Prospect';
        newLead4.RecordTypeId = RefundsTodayRecordTypeId;
        newLeadList.add(newLead4);
        
        insert newLeadList;
        
        List<Lead> updateLeadList = [SELECT Id,FirstName,Process__c,Contract_Expiration_Date__c 
                          FROM Lead
                          WHERE Id IN (:newLeadList[0].Id,:newLeadList[1].Id,:newLeadList[2].Id,:newLeadList[3].Id)];
        for(Lead ld : updateLeadList ){
            if(ld.FirstName == 'FirstNameTestContract2'){
                System.assertEquals(ld.Contract_Expiration_Date__c,'2012 EXP');
            }
          
        }                      
    //System.assertEquals(updateLeadList[3].Contract_Expiration_Date__c, '2014 EXP');
    //System.assertEquals(updateLeadList[1].Contract_Expiration_Date__c, '2012 EXP');
    updateLeadList[0].Process__c = 'Sign and Close a Prospect';
    updateLeadList[2].Process__c = 'Sign and Close a Prospect';
    updateLeadList[2].Contract_Expiration_Date__c = '';
    update updateLeadList;
    }
}