/* @Description: Test class for 'bfInsUpdValidateQueueName'
   @Modified By: Vaibhav Kulkarni
   @Date: 28.May.2013
*/ 

@isTest
private class TestbfInsUpdValidateQueueName {

  //Group Name exists alreday for all 'RR_Queue__c' records
  static testMethod void myUnitTest() {

      List<Group> GroupLst = new List<Group>();
      Map<String,Group> GroupMap = new Map<String,Group>();
      Group newGroup;
      for(integer i=0;i<200;i++){
          newGroup = new Group();
          newGroup.Name = 'Group Queue'+i;
          newGroup.Type = 'Queue';
          GroupLst.add(newGroup);
          GroupMap.put(newGroup.Name ,newGroup );
      }
      
      insert GroupLst;
      
      List<RR_Queue__c> RRQueueLst = new List<RR_Queue__c>();
      for(integer i=0;i<200;i++){
          RR_Queue__c rr = new RR_Queue__c();
          rr.Queue_Name__c = 'Group Queue'+i;
          RRQueueLst.add(rr);
      }
      
      insert RRQueueLst;
      
      for(RR_Queue__c rrq:RRQueueLst){
          System.assert(GroupMap.containsKey(rrq.Queue_Name__c));
      }
   }
   
   //Group Name does not exist alreday for all 'RR_Queue__c' records
  static testMethod void myUnitTests() {

      List<Group> GroupLst = new List<Group>();
      Map<String,Group> GroupMap = new Map<String,Group>();
      Group newGroup;
      for(integer i=0;i<200;i++){
          newGroup = new Group();
          newGroup.Name = 'Group Queuess'+i;
          newGroup.Type = 'Queue';
          GroupLst.add(newGroup);
          GroupMap.put(newGroup.Name ,newGroup );
      }
      
      insert GroupLst;
      
      List<RR_Queue__c> RRQueueLst = new List<RR_Queue__c>();
      for(integer i=0;i<200;i++){
          RR_Queue__c rr = new RR_Queue__c();
          rr.Queue_Name__c = 'Group Queuesss'+i;
          RRQueueLst.add(rr);
      }
      
      try{
      insert RRQueueLst;
      }
      catch(Exception e){
      }
      
      for(RR_Queue__c rrq:RRQueueLst){
          System.assert(!GroupMap.containsKey(rrq.Queue_Name__c));
      }
        
  }
}