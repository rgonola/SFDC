/* @Description: Test class for 'bfInsUpdValidateSeqNum'
   @Modified By: Vaibhav Kulkarni
   @Date: 28.May.2013
*/ 

@isTest
private class TestbfInsUpdValidateSeqNum {

  //Test method to check whether the sequence number already exists on RR_Queue_Member__c
  static testMethod void myUnitTest() {
   
      List<Group> GroupLst = new List<Group>();
      Group newGroup1 = new Group();
          newGroup1.Name = 'Group Queue1';
          newGroup1.Type = 'Queue';
          GroupLst.add(newGroup1);
          
      Group newGroup2 = new Group();
          newGroup2.Name = 'Group Queue2';
          newGroup2.Type = 'Queue';
          GroupLst.add(newGroup2);
          
          insert GroupLst;
      
      //Creating Records of RR_Queue__c
      List<RR_Queue__c> RRQueueLst = new List<RR_Queue__c>();
          RR_Queue__c rrQueue1 = new RR_Queue__c();
          rrQueue1.Queue_Name__c = 'Group Queue1';
          RRQueueLst.add(rrQueue1);
          
          RR_Queue__c rrQueue2 = new RR_Queue__c();
          rrQueue2.Queue_Name__c = 'Group Queue2';
          RRQueueLst.add(rrQueue2);
          
          insert RRQueueLst;
          
      //Creating User Record  
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
          
      //Creating Records of RR_Member__c
      List<RR_Member__c> RRMemberLst = new List<RR_Member__c>();
      RR_Member__c rrMem1 = new RR_Member__c();
          rrMem1 .Member__c = UserLst[0].id;
          RRMemberLst.add(rrMem1 );
      
      RR_Member__c rrMem2 = new RR_Member__c();
          rrMem2.Member__c = UserLst[1].id;
          RRMemberLst.add(rrMem2);
          
          insert RRMemberLst;
      
      //Creating Records of RR_Queue_Member__c
      List<RR_Queue_Member__c>  RRQueueMemberLst = new List<RR_Queue_Member__c>();
      RR_Queue_Member__c rrQueueMem ;
 
      for(integer i=0;i<10;i++){
              rrQueueMem = new RR_Queue_Member__c();
              rrQueueMem.Queue_Name__c = RRQueueLst[0].id;
              rrQueueMem.Sequence_Number__c = 5 ; 
              rrQueueMem.RR_Member__c = RRMemberLst[0].id;
              RRQueueMemberLst.add(rrQueueMem);
      }
      
      for(integer i=0;i<10;i++){
              rrQueueMem = new RR_Queue_Member__c();
              rrQueueMem.Queue_Name__c = RRQueueLst[0].id;
              rrQueueMem.Sequence_Number__c = 6 ; 
              rrQueueMem.RR_Member__c = RRMemberLst[1].id;
              RRQueueMemberLst.add(rrQueueMem);
      }
      
      for(integer i=0;i<10;i++){
              rrQueueMem = new RR_Queue_Member__c();
              rrQueueMem.Queue_Name__c = RRQueueLst[1].id;
              rrQueueMem.Sequence_Number__c = 6 ; 
              rrQueueMem.RR_Member__c = RRMemberLst[1].id;
              RRQueueMemberLst.add(rrQueueMem);
      }
      
      for(integer i=0;i<10;i++){
              rrQueueMem = new RR_Queue_Member__c();
              rrQueueMem.Queue_Name__c = RRQueueLst[1].id;
              rrQueueMem.Sequence_Number__c = 5 ; 
              rrQueueMem.RR_Member__c = RRMemberLst[0].id;
              RRQueueMemberLst.add(rrQueueMem);
      }
      
      insert RRQueueMemberLst;
      System.debug('RRQueueMemberLstRRQueueMemberLstRRQueueMemberLst'+RRQueueMemberLst);
      for(RR_Queue_Member__c rrqm: RRQueueMemberLst){
          System.debug('Travelling Through list '+rrqm);
      }
      
      List<RR_Queue_Member__c> RRQueMemLstUpdate = new List<RR_Queue_Member__c>();
      for(RR_Queue_Member__c rrqm:[Select id,Sequence_Number__c,RR_Member__c,Queue_Name__c From RR_Queue_Member__c Where id IN:RRQueueMemberLst]){
             System.debug('rrqmrrqmrrqmrrqmrrqmSequence_Number__c'+rrqm.Sequence_Number__c);
             if(rrqm.Sequence_Number__c == 5){
                System.debug('Sequence_Number__c value is 5');
                rrqm.Sequence_Number__c = 6;
                RRQueMemLstUpdate.add(rrqm);
             }  
             else if(rrqm.Sequence_Number__c == 6){
                System.debug('Sequence_Number__c value is 6');
                rrqm.Sequence_Number__c = 5;
                RRQueMemLstUpdate.add(rrqm);
             }      
             
      } 
      
      try{
          update RRQueMemLstUpdate;
      }
      catch(Exception e){
          
      }
      System.debug('RRQueMemLstUpdateRRQueMemLstUpdateRRQueMemLstUpdate'+RRQueMemLstUpdate);
  }
}