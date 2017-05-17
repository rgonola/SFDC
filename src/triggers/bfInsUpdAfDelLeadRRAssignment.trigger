/**********************************************************************
Name: bfInsUpdAfDelLeadRRAssignment
Copyright © 2012 WK
======================================================
======================================================
Purpose: This trigger will be called when a new lead is created or Updating the existing lead.
         The purpose of this trigger is to check only 350 open leads assigned to an user for "AM/FS/NS" record type. 
         Also to assign Users for Web Leads in Round Robin manner for "AM/FS/NS" record type.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR            DATE       DETAIL 
1.0       Natesh            17/05/2012 INITIAL DEVELOPMENT
2.0       Venkata.Penneti   25/05/2012 Round Robin Assignment
3.0       Shirish D         21/02/2013 Increased the Lead assignment number to 350 from 250
4.0       Shirish D         05/05/2014 Removed the Lead Assignment 350 Number Rule. 
4.1       Shirish D         05/05/2014 Setting the max size to 500 before it can be moved to a queue. 
***********************************************************************/

trigger bfInsUpdAfDelLeadRRAssignment on Lead (after delete, before insert, before update) {
    Id AMNSFSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;
    
    Map<String,Map<Id,RR_Queue_Member__c>> queueToMemberLeadCountMap = new Map<String,Map<Id,RR_Queue_Member__c>>();
    Map<Id,RR_Queue_Member__c> MemberLeadCountMap = new Map<Id,RR_Queue_Member__c>();
    
    Set<Id> assignToUserSet = new set<Id>();
    Map<Id,Lead> newLeadMap = new Map<Id,Lead>();
    Map<Id,Lead> oldLeadMap = new Map<Id,Lead>();
    
    Integer SpanishLeadCount = 0;
    
    if((Trigger.isAfter && Trigger.isDelete) || (Trigger.isBefore && Trigger.isUpdate)){
        for(Lead LeadItem : Trigger.old){
            assignToUserSet.add(LeadItem.OwnerId);
        }
        oldLeadMap = Trigger.oldMap;
    }
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        for(Lead LeadItem : Trigger.new){
            System.debug('-----------LeadItem - ' + LeadItem);
            assignToUserSet.add(LeadItem.OwnerId);
            if((Trigger.isInsert || (Trigger.isUpdate && LeadItem.WebToLeadCheckBox__c)) && 
              LeadItem.RecordTypeId == AMNSFSRecordTypeId && LeadItem.IsWebToLead__c == true){
                SpanishLeadCount ++;
            }
            
        }
        newLeadMap = Trigger.newMap;
    }
    system.debug('Spanish Lead Count:'+SpanishLeadCount );
    String oldQueueName = null;
    String newQueueName = null;
    for(RR_Queue_Member__c QMItem :[SELECT Id, Queue_Name__r.Queue_Name__c, RR_Member__r.Member__c, No_of_Leads_Assigned__c
                                    FROM RR_Queue_Member__c 
                                    WHERE RR_Member__r.Member__c IN :assignToUserSet AND IsActive__c = 'Yes'
                                    order by Queue_Name__r.Queue_Name__c]){
        
        newQueueName = QMItem.Queue_Name__r.Queue_Name__c;
        if(oldQueueName <> null && oldQueueName <> newQueueName){
            queueToMemberLeadCountMap.put(oldQueueName,MemberLeadCountMap);
            MemberLeadCountMap = new Map<Id,RR_Queue_Member__c>();
        }
        oldQueueName = QMItem.Queue_Name__r.Queue_Name__c;
        MemberLeadCountMap.put(QMItem.RR_Member__r.Member__c,QMItem);
        
    }
    if(MemberLeadCountMap.size() <> 0){
        queueToMemberLeadCountMap.put(oldQueueName,MemberLeadCountMap);
    }
    System.debug('-------queueToMemberLeadCountMap-------' + queueToMemberLeadCountMap);
    
    //Retrieve RR Member Records
    Map<Id,RR_Member__c> memberMap = new Map<Id,RR_Member__c>();
    for(RR_Member__c MemberItem :[SELECT Id, Member__c, No_of_Other_Leads_Assigned__c, 
                                  Total_Leads_Assigned__c
                                  FROM RR_Member__c
                                  WHERE Member__c IN :assignToUserSet]){
        MemberItem.Total_Leads_Dummy__c = MemberItem.Total_Leads_Assigned__c;
        memberMap.put(MemberItem.Member__c,MemberItem);
    }
    
    //Retrieve Queue Group Records
    Map<String,Id> groupMemberQueueMap = new Map<String,Id>();
    for(Group groupItem: [SELECT Id,Name FROM Group WHERE Type = 'Queue']){
        groupMemberQueueMap.put(groupItem.Name,groupItem.Id);
    }
    System.debug('---------groupMemberQueueMap-------- '+groupMemberQueueMap);
    
    //Decrement Lead Count in Queue Member Object if Lead is deleted
    if(Trigger.isAfter && Trigger.isDelete){
        
        Map<Id,RR_Queue_Member__c> QueueMemberMap = new Map<Id,RR_Queue_Member__c>();
        RR_Queue_Member__c QueueMemberRecord = new RR_Queue_Member__c();
        List<RR_Queue_Member__c> QueueMemberList = new List<RR_Queue_Member__c>();
        RR_Member__c MemberRecord = new RR_Member__c();
        List<RR_Member__c> MemberList = new List<RR_Member__c>();
        Boolean nonQueueMember = false;
        
        String queueName = null;
        
        for(Lead LeadItem : Trigger.old){
            if(LeadItem.RecordTypeId == AMNSFSRecordTypeId){
                nonQueueMember = false;
                if(LeadItem.Language__c == 'Spanish'){
                    queueName = 'Spanish Queue';
                }
                if(LeadItem.Language__c <> 'Spanish'){
                    queueName = 'Non-Spanish Queue';
                }
                if(queueToMemberLeadCountMap <> null && queueToMemberLeadCountMap.size() > 0){
                    if(queueToMemberLeadCountMap.containsKey(queueName)){
                        QueueMemberMap = new Map<Id,RR_Queue_Member__c>();
                        QueueMemberMap = queueToMemberLeadCountMap.get(queueName);
                        if(QueueMemberMap.containsKey(LeadItem.OwnerId)){
                            QueueMemberRecord = new RR_Queue_Member__c();
                            QueueMemberRecord = QueueMemberMap.get(LeadItem.OwnerId);
                            if(QueueMemberRecord.No_of_Leads_Assigned__c > 0){
                                QueueMemberRecord.No_of_Leads_Assigned__c = QueueMemberRecord.No_of_Leads_Assigned__c - 1;
                                queueToMemberLeadCountMap.get(queueName).put(LeadItem.OwnerId,QueueMemberRecord);
                                
                                if(memberMap.containsKey(LeadItem.OwnerId)){
                                    MemberRecord = new RR_Member__c();
                                    MemberRecord = memberMap.get(LeadItem.OwnerId);
                                    if(MemberRecord.Total_Leads_Dummy__c > 0){
                                        MemberRecord.Total_Leads_Dummy__c = MemberRecord.Total_Leads_Dummy__c - 1;
                                        memberMap.put(LeadItem.OwnerId,MemberRecord);
                                    }
                                }
                            }
                        }
                        else{
                            nonQueueMember = true;
                        }
                    }
                    else{
                        nonQueueMember = true;
                    }
                }
                else{
                    nonQueueMember = true;
                }
                if(nonQueueMember == true){
                    if(memberMap.containsKey(LeadItem.OwnerId)){
                        MemberRecord = new RR_Member__c();
                        MemberRecord = memberMap.get(LeadItem.OwnerId);
                        if(MemberRecord.No_of_Other_Leads_Assigned__c > 0){
                            MemberRecord.No_of_Other_Leads_Assigned__c = MemberRecord.No_of_Other_Leads_Assigned__c - 1;
                            MemberRecord.Total_Leads_Dummy__c = MemberRecord.Total_Leads_Dummy__c - 1;
                            memberMap.put(LeadItem.OwnerId,MemberRecord);
                        }
                    }
                }
            }
        }
        for(Map<Id,RR_Queue_Member__c> QueueMemberItemMap : queueToMemberLeadCountMap.values()){
            for(RR_Queue_Member__c QueueMemberItem : QueueMemberItemMap.values()){
                QueueMemberList.add(QueueMemberItem);
            }
        }
        if(QueueMemberList <> null && QueueMemberList.size() > 0){
            update QueueMemberList;
        }
        
        MemberList = memberMap.values();
        if(MemberList <> null && MemberList.size() > 0){
            update MemberList;
        }
    }
    
    //If A Lead is Created or Existing Lead is Updated with new Owner then Check for 500 count before assign and update the count
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        
        System.debug('-----------1');
        Map<Id,RR_Queue_Member__c> QueueMemberMap = new Map<Id,RR_Queue_Member__c>();
        RR_Queue_Member__c QueueMemberRecord = new RR_Queue_Member__c();
        List<RR_Queue_Member__c> QueueMemberList = new List<RR_Queue_Member__c>();
        
        RR_Member__c MemberRecord = new RR_Member__c();
        RR_Member__c oldMemberRecord = new RR_Member__c();
        List<RR_Member__c> MemberList = new List<RR_Member__c>();
        Boolean oldnonQueueMember = false;
        Boolean newnonQueueMember = false;
        
        String queueName = null;
        String queueGroupName = null;
        
        Lead oldLeadItem = new Lead();
        RR_Queue_Member__c oldQueueMemberRecord = new RR_Queue_Member__c();
        Map<Id,RR_Queue_Member__c> oldQueueMemberMap = new Map<Id,RR_Queue_Member__c>();
        oldQueueName = null;
        
        for(Lead LeadItem : Trigger.new){
            System.debug('-----------1aaaaaaaa');
            if(LeadItem.Language__c == 'Spanish'){
                queueName = 'Spanish Queue';
                queueGroupName = 'Spanish Queue';
            }
            if(LeadItem.Language__c <> 'Spanish'){
                queueName = 'Non-Spanish Queue';
                queueGroupName = 'Non-Spanish Queue';
            }
            //Only if Lead is not Web To Lead
            if(LeadItem.RecordTypeId == AMNSFSRecordTypeId && LeadItem.Assign_using_active_assignment_rule__c <> true){
                
                oldnonQueueMember = false;
                newnonQueueMember = false;
            
                System.debug('-----------2');
                if(queueToMemberLeadCountMap <> null && queueToMemberLeadCountMap.size() > 0){
                    if(queueToMemberLeadCountMap.containsKey(queueName)){
                        
                        QueueMemberMap = new Map<Id,RR_Queue_Member__c>();
                        QueueMemberMap = queueToMemberLeadCountMap.get(queueName);
                        System.debug('-----------3 ' + QueueMemberMap);
                        if(QueueMemberMap.containsKey(LeadItem.OwnerId)){
                            QueueMemberRecord = new RR_Queue_Member__c();
                            QueueMemberRecord = QueueMemberMap.get(LeadItem.OwnerId);
                            System.debug('-----------4 ' + QueueMemberRecord);
                            
                            if(memberMap.containsKey(LeadItem.OwnerId)){
                                MemberRecord = new RR_Member__c();
                                MemberRecord = memberMap.get(LeadItem.OwnerId);
                            }
                            
                            if((LeadItem.Status == 'Open' || LeadItem.Status == 'Contacted') &&
                              ((Trigger.isInsert && LeadItem.IsWebToLead__c == false) || (Trigger.isUpdate &&
                              LeadItem.WebToLeadCheckBox__c == false && 
                              oldLeadMap.get(LeadItem.Id).Status <> 'Open' && 
                              oldLeadMap.get(LeadItem.Id).Status <> 'Contacted') ||
                              (Trigger.isUpdate && LeadItem.OwnerId <> oldLeadMap.get(LeadItem.Id).OwnerId))){
                                //if(QueueMemberRecord.No_of_Leads_Assigned__c < 350){   
                                //if(MemberRecord.Total_Leads_Dummy__c < 350){ //Change 4.0 - Removed the check. SD
                                    QueueMemberRecord.No_of_Leads_Assigned__c = QueueMemberRecord.No_of_Leads_Assigned__c + 1;
                                    queueToMemberLeadCountMap.get(queueName).put(LeadItem.OwnerId,QueueMemberRecord);
                                    System.debug('-----------5 ' + QueueMemberRecord);
                                    
                                    MemberRecord.Total_Leads_Dummy__c = MemberRecord.Total_Leads_Dummy__c + 1;
                                    memberMap.put(LeadItem.OwnerId,MemberRecord);
                                //}//Change 4.0 - Removed the check. SD
                                //else{
                                //    LeadItem.addError('This Owner Already Assigned with 350 Open Leads. Please Assign it to Queue');
                                //}
                              }
    
                            if(Trigger.isUpdate && LeadItem.WebToLeadCheckBox__c == false){
                                if((oldLeadMap.get(LeadItem.Id).Status == 'Open' || oldLeadMap.get(LeadItem.Id).Status == 'Contacted') &&
                                  (LeadItem.Status <> 'Open' && LeadItem.Status <> 'Contacted')){
                                    
                                    System.debug('-----------6 ' + LeadItem.Status + oldLeadMap.get(LeadItem.Id).Status);
                                    if(QueueMemberRecord.No_of_Leads_Assigned__c > 0){
                                        QueueMemberRecord.No_of_Leads_Assigned__c = QueueMemberRecord.No_of_Leads_Assigned__c - 1;
                                        queueToMemberLeadCountMap.get(queueName).put(LeadItem.OwnerId,QueueMemberRecord);
                                    }
                                    if(MemberRecord.Total_Leads_Dummy__c > 0){
                                        MemberRecord.Total_Leads_Dummy__c = MemberRecord.Total_Leads_Dummy__c - 1;
                                        memberMap.put(LeadItem.OwnerId,MemberRecord);
                                    }
                                }
                            }
                        }
                        else{
                            newnonQueueMember = true;
                        }
                    }
                    else{
                        newnonQueueMember = true;
                    }
                }
                else{
                    newnonQueueMember = true;
                }
                
                if(newnonQueueMember == true){
                    System.debug('------1------'+LeadItem.OwnerId);
                    if(memberMap.containsKey(LeadItem.OwnerId)){
                        MemberRecord = new RR_Member__c();
                        MemberRecord = memberMap.get(LeadItem.OwnerId);
                        System.debug('------2------'+MemberRecord);
                        if((LeadItem.Status == 'Open' || LeadItem.Status == 'Contacted') &&
                          ((Trigger.isInsert && LeadItem.IsWebToLead__c == false) || (Trigger.isUpdate &&
                          LeadItem.WebToLeadCheckBox__c == false && 
                          oldLeadMap.get(LeadItem.Id).Status <> 'Open' && 
                          oldLeadMap.get(LeadItem.Id).Status <> 'Contacted') ||
                          (Trigger.isUpdate && LeadItem.OwnerId <> oldLeadMap.get(LeadItem.Id).OwnerId))){
                            //if(MemberRecord.Total_Leads_Dummy__c < 350){ //Change 4.0 - Removed the check. SD
                                MemberRecord.No_of_Other_Leads_Assigned__c = MemberRecord.No_of_Other_Leads_Assigned__c + 1;
                                MemberRecord.Total_Leads_Dummy__c = MemberRecord.Total_Leads_Dummy__c + 1;
                                memberMap.put(LeadItem.OwnerId,MemberRecord);
                            //}
                            //else{
                            //    LeadItem.addError('This Owner Already Assigned with 350 Open Leads. Please Assign it to Queue');
                            //}
                        }
                        
                        if(Trigger.isUpdate && LeadItem.WebToLeadCheckBox__c == false){
                            if((oldLeadMap.get(LeadItem.Id).Status == 'Open' || oldLeadMap.get(LeadItem.Id).Status == 'Contacted') &&
                              (LeadItem.Status <> 'Open' && LeadItem.Status <> 'Contacted')){
                                
                                if(MemberRecord.Total_Leads_Dummy__c > 0){
                                    MemberRecord.No_of_Other_Leads_Assigned__c = MemberRecord.No_of_Other_Leads_Assigned__c - 1;
                                    MemberRecord.Total_Leads_Dummy__c = MemberRecord.Total_Leads_Dummy__c - 1;
                                    memberMap.put(LeadItem.OwnerId,MemberRecord);
                                }
                            }
                        }
                    }
                }
                
                if(Trigger.isUpdate && LeadItem.WebToLeadCheckBox__c == false){
                    if((LeadItem.OwnerId <> oldLeadMap.get(LeadItem.Id).OwnerId)){
                        oldLeadItem = oldLeadMap.get(LeadItem.Id);
                        
                        if(oldLeadItem.Language__c == 'Spanish'){
                            oldQueueName = 'Spanish Queue';
                        }
                        if(oldLeadItem.Language__c <> 'Spanish'){
                            oldQueueName = 'Non-Spanish Queue';
                        }
                        if(queueToMemberLeadCountMap <> null && queueToMemberLeadCountMap.size() > 0){
                            if(queueToMemberLeadCountMap.containsKey(oldQueueName)){
                                oldQueueMemberMap = new Map<Id,RR_Queue_Member__c>();
                                oldQueueMemberMap = queueToMemberLeadCountMap.get(oldQueueName);
                                if(oldQueueMemberMap.containsKey(oldLeadItem.OwnerId)){
                                    oldQueueMemberRecord = new RR_Queue_Member__c();
                                    oldQueueMemberRecord = oldQueueMemberMap.get(oldLeadItem.OwnerId);
                                    if(oldQueueMemberRecord.No_of_Leads_Assigned__c > 0){
                                        oldQueueMemberRecord.No_of_Leads_Assigned__c = oldQueueMemberRecord.No_of_Leads_Assigned__c - 1;
                                        queueToMemberLeadCountMap.get(oldQueueName).put(oldLeadItem.OwnerId,oldQueueMemberRecord);
                                        
                                        if(memberMap.containsKey(oldLeadItem.OwnerId)){
                                            oldMemberRecord = new RR_Member__c();
                                            oldMemberRecord = memberMap.get(oldLeadItem.OwnerId);
                                            if(oldMemberRecord.Total_Leads_Dummy__c > 0){
                                                oldMemberRecord.Total_Leads_Dummy__c = oldMemberRecord.Total_Leads_Dummy__c - 1;
                                                memberMap.put(oldLeadItem.OwnerId,oldMemberRecord);
                                            }
                                        }
                                    }
                                }
                                else{
                                    oldnonQueueMember = true;
                                }
                            }
                            else{
                                oldnonQueueMember = true;
                            }
                        }
                        else{
                            oldnonQueueMember = true;
                        }
                        if(oldnonQueueMember == true){
                            if(memberMap.containsKey(oldLeadItem.OwnerId)){
                                oldMemberRecord = new RR_Member__c();
                                oldMemberRecord = memberMap.get(oldLeadItem.OwnerId);
                                if(oldMemberRecord.No_of_Other_Leads_Assigned__c > 0){
                                    oldMemberRecord.No_of_Other_Leads_Assigned__c = oldMemberRecord.No_of_Other_Leads_Assigned__c - 1;
                                    oldMemberRecord.Total_Leads_Dummy__c = oldMemberRecord.Total_Leads_Dummy__c - 1;
                                    memberMap.put(oldLeadItem.OwnerId,oldMemberRecord);
                                }
                            }
                        }
                    }
                }
            }
                
            if(LeadItem.RecordTypeId == AMNSFSRecordTypeId && LeadItem.Assign_using_active_assignment_rule__c == true){
                LeadItem.Assign_using_active_assignment_rule__c = false;
                LeadItem.OwnerId = groupMemberQueueMap.get(queueGroupName);
                System.debug('------queueGroupName------'+queueGroupName);
                System.debug('------LeadItem.OwnerId------'+LeadItem.OwnerId);
            }
        }
        if(queueToMemberLeadCountMap <> null && queueToMemberLeadCountMap.size() > 0){
            for(Map<Id,RR_Queue_Member__c> QueueMemberItemMap : queueToMemberLeadCountMap.values()){
                for(RR_Queue_Member__c QueueMemberItem : QueueMemberItemMap.values()){
                    QueueMemberList.add(QueueMemberItem);
                }
            }
            if(QueueMemberList <> null && QueueMemberList.size() > 0){
                update QueueMemberList;
            }
        }
        MemberList = memberMap.values();
        if(MemberList <> null && MemberList.size() > 0){
            update MemberList;
        }
    }
    
/****************Venkata.Penneti Code Starts Here*************************/
    //Round Robin Assignment if lead source is Web request or Web .
    Map<Integer,RR_Queue_Member__c> QueueMemberMap = new Map<Integer,RR_Queue_Member__c>();
     Map<Integer,RR_Queue_Member__c> NonSpanishQueueMemberMap = new Map<Integer,RR_Queue_Member__c>();
    if(Trigger.isBefore && Trigger.isUpdate && SpanishLeadCount>0 )
    {
        String SpanishQueueId = '';
        String NonSpanishQueueId = '';
        String GroupQueueId = groupMemberQueueMap.get('Spanish Queue');
        
        String NonSpanishGroupQueueId = groupMemberQueueMap.get('Non-Spanish Queue');
        String DuplicateGroupQueueId = groupMemberQueueMap.get('Duplicate Leads Queue');
        
        for(RR_Queue__c RRQ:[select id,Queue_Name__c from RR_Queue__c where IsActive__c = true and  
                                (Queue_Name__c = 'Spanish Queue' or Queue_Name__c = 'Non-Spanish Queue')])
        {
            if(RRQ.Queue_Name__c == 'Spanish Queue')
                SpanishQueueId = RRQ.Id;
            if(RRQ.Queue_Name__c == 'Non-Spanish Queue')
                NonSpanishQueueId = RRQ.Id;
        }
        if((SpanishQueueId!=null && SpanishQueueId!='' && SpanishQueueId.length()>0 && GroupQueueId!=null && GroupQueueId.length()>0) || 
           (NonSpanishQueueId!=null && NonSpanishQueueId!='' && NonSpanishQueueId.length()>0 && NonSpanishGroupQueueId!=null && NonSpanishGroupQueueId.length()>0))
        {
            SpanishQueueId = SpanishQueueId.substring(0,15);
            NonSpanishQueueId = NonSpanishQueueId.substring(0,15);
            Integer arraysize = [select count() from RR_Queue_Member__c where 
                                        Queue_Name__c=:SpanishQueueId and IsActive__c = 'Yes' and RR_Member__r.Total_Leads_Assigned__c < 500];
            
            Integer NonSpanisharraysize = [select count() from RR_Queue_Member__c where 
                                        Queue_Name__c=:NonSpanishQueueId and IsActive__c = 'Yes' and RR_Member__r.Total_Leads_Assigned__c < 500];
            if(arraysize>0 || NonSpanisharraysize>0)
            {
                RR_Queue_Member__c[] SequenceIds = new RR_Queue_Member__c[arraysize];
                RR_Queue_Member__c[] NonSpanishSequenceIds = new RR_Queue_Member__c[NonSpanisharraysize];
                integer StartIndex = 0;
                Integer listIndex = 0;
                String lastAssignedFound = 'No';
                integer NonSpanishStartIndex = 0;
                Integer NonSpanishlistIndex = 0;
                String NonSpanishlastAssignedFound = 'No';
                Map<String, Integer> LeadCountMap = new Map<String, Integer>();
                
                
                for(RR_Queue_Member__c QM:[Select id,Queue_Name__c,RR_Member__r.Member__c,No_of_Leads_Assigned__c,
                                            Sequence_Number__c, IsActive__c , 
                                            RR_Member__r.Total_Leads_Assigned__c, Last_Assigned__c   from 
                                            RR_Queue_Member__c where 
                                            Queue_Name__c=:SpanishQueueId  or Queue_Name__c =:NonSpanishQueueId Order
                                            by Sequence_Number__c ASC NULLS LAST]){
                   
                    Integer SequenceNumber = Integer.valueof(QM.Sequence_Number__c);
                    if(QM.IsActive__c == 'Yes' && QM.RR_Member__r.Total_Leads_Assigned__c < 500){
                        LeadCountMap.put(QM.Id,Integer.valueof(QM.RR_Member__r.Total_Leads_Assigned__c));
                        if(QM.Last_Assigned__c == true && QM.Queue_Name__c == SpanishQueueId){
                            StartIndex = listIndex+1;
                            QM.Last_Assigned__c = False; 
                            lastAssignedFound = 'Yes';                      
                        }
                        if(QM.Last_Assigned__c == true && QM.Queue_Name__c == NonSpanishQueueId){
                            NonSpanishStartIndex = NonSpanishlistIndex+1;
                            QM.Last_Assigned__c = False; 
                            NonSpanishlastAssignedFound = 'Yes';                      
                        }
                        if(QM.Queue_Name__c == SpanishQueueId){
                            SequenceIds[listIndex] = QM;
                            QueueMemberMap.put(SequenceNumber,QM);
                            listIndex++;
                        }
                        if(QM.Queue_Name__c == NonSpanishQueueId){
                            NonSpanishSequenceIds[NonSpanishlistIndex] = QM;
                            NonSpanishQueueMemberMap.put(SequenceNumber,QM);
                            NonSpanishlistIndex++;
                        }
                        
                    }
                    else{
                        if(QM.Last_Assigned__c == true && lastAssignedFound == 'No' && 
                          QM.Queue_Name__c == SpanishQueueId){
                            StartIndex = listIndex;
                            QM.Last_Assigned__c = False; 
                            lastAssignedFound = 'Yes';
                            QueueMemberMap.put(SequenceNumber,QM);
                        }
                        else{
                            if(QM.Last_Assigned__c == true && NonSpanishlastAssignedFound == 'No' && 
                              QM.Queue_Name__c == NonSpanishQueueId){
                                NonSpanishStartIndex = NonSpanishlistIndex;
                                QM.Last_Assigned__c = False; 
                                NonSpanishlastAssignedFound = 'Yes';
                                NonSpanishQueueMemberMap.put(SequenceNumber,QM);
                            }
                        }
                    }
                }
                system.debug('Map@@@@@@@@@@@@@@@:'+QueueMemberMap);
                system.debug(' Sequence Size@@@@@@@@@@@@@@@:'+SequenceIds.size());
                system.debug('Lead Count Map:'+LeadCountMap);
                if(QueueMemberMap.size()>0 || NonSpanishQueueMemberMap.size()>0){               
                    
                    if (StartIndex>=SequenceIds.size())
                        StartIndex = 0;
                    
                    if (NonSpanishStartIndex>=NonSpanishSequenceIds.size())
                        NonSpanishStartIndex = 0;
                    
                    Integer currentSeqNum = 0;
                    Integer NonSpanishcurrentSeqNum = 0;
                    
                    for(Lead LeadItem : Trigger.new){
                    system.debug('IsWebtoLead:'+LeadItem.IsWebToLead__c+';Lead Owner:'+LeadItem.OwnerId+';DuplicateQueueId:'+DuplicateGroupQueueId);
                        if((Trigger.isUpdate && LeadItem.WebToLeadCheckBox__c) &&
                          LeadItem.RecordTypeId == AMNSFSRecordTypeId && LeadItem.IsWebToLead__c == true){
                            if(LeadItem.Duplicate_Web_To_Lead__c){
                                LeadItem.OwnerId= DuplicateGroupQueueId;
                                LeadItem.WebToLeadCheckBox__c = false;
                            }
                            else{
                                if(LeadItem.Language__c == 'Spanish' && QueueMemberMap.size()>0){
                                    if(SequenceIds.size()>0 ){
                                        system.debug('Start Index:'+StartIndex);
                                        if (StartIndex>=SequenceIds.size())
                                            StartIndex = 0;
                                        currentSeqNum = Integer.valueof(SequenceIds[StartIndex].Sequence_Number__c);
                                        RR_Queue_Member__c thisQM = QueueMemberMap.get(currentSeqNum);
                                        system.debug('Queue Member:'+thisQM.RR_Member__r.Member__c);
                                        Integer TotalLeadCount = LeadCountMap.get(thisQM.Id);
                                        system.debug('Total Lead Count:'+TotalLeadCount+'QMID:'+thisQM.Id);
                              
                                        if(TotalLeadCount < 500){
                                            LeadItem.OwnerId = thisQM.RR_Member__r.Member__c;
                                            LeadItem.WebToLeadCheckBox__c = false;
                                            thisQM.No_of_Leads_Assigned__c = thisQM.No_of_Leads_Assigned__c+1;
                                            system.debug('Lead Assigned:'+LeadItem.OwnerId);
                                            TotalLeadCount ++;
                                
                                            if(TotalLeadCount >=500){
                                                SequenceIds.remove(StartIndex);                         
                                            }
                                            else
                                                StartIndex++;
                                            LeadCountMap.put(thisQM.Id,TotalLeadCount);
                                            QueueMemberMap.put(Integer.valueof(thisQM.Sequence_Number__c),thisQM);
                                        }
                                    }
                                    else{
                                        LeadItem.WebToLeadCheckBox__c = false;
                                        LeadItem.OwnerId = GroupQueueId;
                                    }
                                }
                                else{
                                    if(NonSpanishSequenceIds.size()>0 && NonSpanishQueueMemberMap.size()>0){
                                        system.debug('Start Index:'+NonSpanishStartIndex);
                                        if (NonSpanishStartIndex>=NonSpanishSequenceIds.size())
                                            NonSpanishStartIndex = 0;
                                        NonSpanishcurrentSeqNum = Integer.valueof(NonSpanishSequenceIds[NonSpanishStartIndex].Sequence_Number__c);
                                        RR_Queue_Member__c thisQM = NonSpanishQueueMemberMap.get(NonSpanishcurrentSeqNum);
                                        system.debug('Queue Member:'+thisQM.RR_Member__r.Member__c);
                                        Integer TotalLeadCount = LeadCountMap.get(thisQM.Id);
                                        system.debug('Total Lead Count:'+TotalLeadCount+'QMID:'+thisQM.Id);
                              
                                        if(TotalLeadCount < 500){
                                            LeadItem.OwnerId = thisQM.RR_Member__r.Member__c;
                                            LeadItem.WebToLeadCheckBox__c = false;
                                            thisQM.No_of_Leads_Assigned__c = thisQM.No_of_Leads_Assigned__c+1;
                                            system.debug('Lead Assigned:'+LeadItem.OwnerId);
                                            TotalLeadCount ++;
                                            if(TotalLeadCount >=500)                                
                                                NonSpanishSequenceIds.remove(NonSpanishStartIndex);                                 
                                            else
                                                NonSpanishStartIndex++;
                                            LeadCountMap.put(thisQM.Id,TotalLeadCount);
                                            NonSpanishQueueMemberMap.put(Integer.valueof(thisQM.Sequence_Number__c),thisQM);
                                        }
                                    }
                                    else{
                                        LeadItem.WebToLeadCheckBox__c = false;
                                        LeadItem.OwnerId = NonSpanishGroupQueueId;
                                    }
                                }
                            }
                        }
                    }
                    List<RR_Queue_Member__c> updateLeadCount = new List<RR_Queue_Member__c>();
                    if(currentSeqNum>0){
                        RR_Queue_Member__c LastAssignedQM = QueueMemberMap.get(currentSeqNum);
                        LastAssignedQM.Last_Assigned__c = true;
                        QueueMemberMap.put(currentSeqNum,LastAssignedQM);
                        updateLeadCount = QueueMemberMap.Values();
                   }
                   if(NonSpanishcurrentSeqNum>0){
                        RR_Queue_Member__c NonSpanishLastAssignedQM = NonSpanishQueueMemberMap.get(NonSpanishcurrentSeqNum);
                        NonSpanishLastAssignedQM.Last_Assigned__c = true;
                        NonSpanishQueueMemberMap.put(NonSpanishcurrentSeqNum,NonSpanishLastAssignedQM);
                        updateLeadCount.addAll(NonSpanishQueueMemberMap.Values());
                   }
                   
                   if(updateLeadCount.size()>0)
                        Update updateLeadCount; 
                    
                }   
            }
            else{
                for(Lead LeadItem: Trigger.new){
                    if((Trigger.isInsert || (Trigger.isUpdate && LeadItem.WebToLeadCheckBox__c)) &&
                      LeadItem.RecordTypeId == AMNSFSRecordTypeId && LeadItem.IsWebToLead__c == true ){
                        if(LeadItem.Duplicate_Web_To_Lead__c){
                            LeadItem.OwnerId= DuplicateGroupQueueId;
                        }
                        else{
                            if(LeadItem.Language__c == 'Spanish')
                                LeadItem.OwnerId = GroupQueueId;
                            else
                                LeadItem.OwnerId = NonSpanishGroupQueueId;
                        }
                        LeadItem.WebToLeadCheckBox__c = false;
                    }
                }
            }
        }
        else
        {
            for(Lead LeadItem: Trigger.new){
                if((Trigger.isInsert || (Trigger.isUpdate && LeadItem.WebToLeadCheckBox__c)) &&
                  LeadItem.RecordTypeId == AMNSFSRecordTypeId && LeadItem.IsWebToLead__c == true ){
                    if(LeadItem.Duplicate_Web_To_Lead__c){
                        LeadItem.OwnerId= DuplicateGroupQueueId;
                    }
                    else{
                        if(LeadItem.Language__c == 'Spanish')
                            LeadItem.OwnerId = GroupQueueId;
                        else
                            LeadItem.OwnerId = NonSpanishGroupQueueId;
                    }
                    LeadItem.WebToLeadCheckBox__c = false;
                }
            }
        }
    }
    /****************Venkata.Penneti Code Ends Here***************************/
}