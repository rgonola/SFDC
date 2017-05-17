/* @Description: Test class for 'afInsUpdBigMachinesQuote '
   @Modified By: Vaibhav Kulkarni
   @Date: 29.May.2013
*/ 

@isTest
private class TestafInsUpdBigMachinesQuote {

  //Test method to cover the nsertion and Deletion scenario of SFDCQuote_BMQuote_Sync__c
  static testMethod void myUnitTest() {
  
      //Creating Account
      Account acc = new Account();
      acc.name = 'Test Account';
      insert acc;

      //Creating Opportunity
      Opportunity opp = new Opportunity();
      opp.name = 'Test Opp';
      opp.Invoiced_Amount__c = 2000;
      opp.AccountId = acc.id;
      opp.StageName = 'Present Solution';
      opp.CloseDate = System.Today()+5;
      
      insert opp;
      
      List<BigMachines__Quote__c> BigMachinesQuoteLst = new List<BigMachines__Quote__c>();
      BigMachines__Quote__c BigMachinesQuote;
      for(integer i= 0 ;i<20 ;i++){
          BigMachinesQuote = new BigMachines__Quote__c();
          BigMachinesQuote.BigMachines__Transaction_Id__c = 'abcdefghihjkdsf14'+i;
          BigMachinesQuote.BigMachines__Opportunity__c = opp.id;
          BigMachinesQuote.BigMachines__Status__c = 'Invoiced';
          BigMachinesQuoteLst.add(BigMachinesQuote);
      }
      
      insert BigMachinesQuoteLst;
      
      Map<Id,BigMachines__Quote__c> BigMachinesQuoteIdAndObjectMap = new Map<Id,BigMachines__Quote__c> ();
      for(BigMachines__Quote__c bmq : [Select id,OwnerId,BigMachines__Opportunity__c,BigMachines__Transaction_Id__c From BigMachines__Quote__c Where id IN :BigMachinesQuoteLst]){
          BigMachinesQuoteIdAndObjectMap.put(bmq.id,bmq);
      }
      
      BigMachines__Quote_Product__c BigMachinesQuoteProduct;
      List<BigMachines__Quote_Product__c> BigMachinesQuoteProductLst = new List<BigMachines__Quote_Product__c>();
      for(integer i=0;i<10;i++){
          BigMachinesQuoteProduct = new BigMachines__Quote_Product__c();
          BigMachinesQuoteProduct.BigMachines__Sales_Price__c = 100;
          BigMachinesQuoteProduct.BigMachines__Quantity__c = 2;
          BigMachinesQuoteProduct.BigMachines__Quote__c = BigMachinesQuoteLst[i].id;
          BigMachinesQuoteProductLst.add(BigMachinesQuoteProduct);
      }
      
      insert BigMachinesQuoteProductLst;
      
            
      for(SFDCQuote_BMQuote_Sync__c sfdcQuoteBMSync : [Select id,Opportunity_Id__c,Quote_Owner_Id__c,Quote_Id__c,Quote_Transaction_Number__c,Account_Id__c From SFDCQuote_BMQuote_Sync__c Where Opportunity_Id__c =: opp.id]){
          System.assertEquals(sfdcQuoteBMSync.Opportunity_Id__c,opp.id);
          System.assertEquals(sfdcQuoteBMSync.Account_Id__c,acc.id);
          System.assertEquals(sfdcQuoteBMSync.Quote_Id__c,BigMachinesQuoteIdAndObjectMap.get(sfdcQuoteBMSync.Quote_Id__c).id);
          System.assertEquals(sfdcQuoteBMSync.Quote_Transaction_Number__c,BigMachinesQuoteIdAndObjectMap.get(sfdcQuoteBMSync.Quote_Id__c).BigMachines__Transaction_Id__c);
          System.assertEquals(sfdcQuoteBMSync.Quote_Owner_Id__c,BigMachinesQuoteIdAndObjectMap.get(sfdcQuoteBMSync.Quote_Id__c).OwnerId);
      }
      //Deleting BigMachines__Quote__c
      delete  BigMachinesQuoteLst;
      
  }
  
  //Test method to cover the Updation scenario of BigMachines__Quote__c
  static testMethod void myUnitTests() {
  
      //Creating Account
      Account acc = new Account();
      acc.name = 'Test Account';
      insert acc;

      //Creating Opportunity
      Opportunity opp = new Opportunity();
      opp.name = 'Test Opp';
      opp.Invoiced_Amount__c = 2000;
      opp.AccountId = acc.id;
      opp.StageName = 'Present Solution';
      opp.CloseDate = System.Today()+5;
      
      insert opp;
      
      List<BigMachines__Quote__c> BigMachinesQuoteLst = new List<BigMachines__Quote__c>();
      BigMachines__Quote__c BigMachinesQuote;
      for(integer i= 0 ;i<20 ;i++){
          BigMachinesQuote = new BigMachines__Quote__c();
          BigMachinesQuote.BigMachines__Transaction_Id__c = 'abcdefghihjkdsf14'+i;
          BigMachinesQuote.BigMachines__Opportunity__c = opp.id;
          BigMachinesQuote.BigMachines__Status__c = 'Invoiced';
          BigMachinesQuoteLst.add(BigMachinesQuote);
      }
      
      insert BigMachinesQuoteLst;
      
      BigMachines__Quote_Product__c BigMachinesQuoteProduct;
      List<BigMachines__Quote_Product__c> BigMachinesQuoteProductLst = new List<BigMachines__Quote_Product__c>();
      for(integer i=0;i<10;i++){
          BigMachinesQuoteProduct = new BigMachines__Quote_Product__c();
          BigMachinesQuoteProduct.BigMachines__Sales_Price__c = 100;
          BigMachinesQuoteProduct.BigMachines__Quantity__c = 2;
          BigMachinesQuoteProduct.BigMachines__Quote__c = BigMachinesQuoteLst[i].id;
          BigMachinesQuoteProductLst.add(BigMachinesQuoteProduct);
      }
      
      insert BigMachinesQuoteProductLst;
      
      List<BigMachines__Quote__c> BigMachinesQuoteLstUpdate = new List<BigMachines__Quote__c>();
      //Updating BigMachines__Quote__c
      for(BigMachines__Quote__c bmq :BigMachinesQuoteLst){
          bmq.BigMachines__Status__c = 'Other';
          BigMachinesQuoteLstUpdate.add(bmq);
      }
      update BigMachinesQuoteLstUpdate; 
      
      for(BigMachines__Quote__c bmq: BigMachinesQuoteLstUpdate){
          System.assertEquals(bmq.BigMachines__Status__c ,'Other');
         
      } 
  }
}