/**********************************************************************
Name: bfInsUpdValidateQueueName
Copyright © 2012 WK
======================================================
======================================================
Purpose: This trigger will be called when a new RR Queue Member is created or updated
         The purpose of this trigger is to check for duplicate Queue Members and Sequence Numbers.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR            DATE       DETAIL 
1.0       Venkata.Penneti   25/05/2012 INITIAL DEVELOPMENT 
1.1       Vaibhav.Kulkarni  29/05/2013 Commented From Line no. 78 to 85, We can not Reparent on Child record as 'ReParenting is not checked in Master Detail relationship'
***********************************************************************/


trigger bfInsUpdValidateSeqNum on RR_Queue_Member__c (Before Insert, Before Update) {

    Map<String,Set<Integer>> mapSeqNumbers = new Map<String, Set<Integer>>();
    Map<String,Set<String>> mapQueueMembers = new Map<String, Set<String>>();

    Set<Integer> setSeqNumbers;
    Set<String> setQueueMembers;


    for(RR_Queue_Member__c rrqm : [SELECT Id, Queue_Name__c, RR_Member__c, Sequence_Number__c
                                   FROM RR_Queue_Member__c]) {

        // Build up mapSeqNumbers from queue name to a set of sequence numbers
        if(mapSeqNumbers.containsKey(rrqm.Queue_Name__c)) {
            setSeqNumbers = mapSeqNumbers.get(rrqm.Queue_Name__c);
            setSeqNumbers.add(Integer.valueof(rrqm.Sequence_Number__c));
            mapSeqNumbers.put(rrqm.Queue_Name__c, setSeqNumbers);
        } else {
            setSeqNumbers = new Set<Integer>();
            setSeqNumbers.add(Integer.valueof(rrqm.Sequence_Number__c));
            System.debug('setSeqNumbers.setSeqNumbers.setSeqNumbers.'+setSeqNumbers);
            mapSeqNumbers.put(rrqm.Queue_Name__c, setSeqNumbers);
        }
     
        // Build up mapQueueMembers from queue name to a set of queue members
        if(mapQueueMembers.containsKey(rrqm.Queue_Name__c)) {   
            setQueueMembers = mapQueueMembers.get(rrqm.Queue_Name__c);
            setQueueMembers.add(rrqm.RR_Member__c);
            mapQueueMembers.put(rrqm.Queue_Name__c, setQueueMembers);
        } else {
            setQueueMembers = new Set<String>();
            setQueueMembers.add(rrqm.RR_Member__c);
            mapQueueMembers.put(rrqm.Queue_Name__c, setQueueMembers);
        }
        
        
    }

    for(RR_Queue_Member__c rrqm:Trigger.new) {

         // On insert, or on sequence number change, or on RR Member change,
        if(System.Trigger.isInsert || 
           rrqm.Sequence_Number__c != System.Trigger.oldMap.get(rrqm.Id).Sequence_Number__c ||
           rrqm.RR_Member__c != System.Trigger.oldMap.get(rrqm.Id).RR_Member__c ) {

            // If the sequence number already exists, throw an error
            setSeqNumbers = (mapSeqNumbers.size() > 0) ? mapSeqNumbers.get(rrqm.Queue_Name__c) : null;
            if(Trigger.isInsert || rrqm.Sequence_Number__c != Trigger.oldMap.get(rrqm.Id).Sequence_Number__c) {
                if(setSeqNumbers <> null && setSeqNumbers.contains(Integer.valueof(rrqm.Sequence_Number__c))) {
                    rrqm.addError(Label.RR_Queue_Member_Error_Sequence_Number_Already_Exists);
                }
            }
            
            //Commented by @Vaibhav, took aprroval from Deepthi
            
            // If the member already exists, throw an error
            setQueueMembers = (mapQueueMembers.size() > 0) ? mapQueueMembers.get(rrqm.Queue_Name__c) : null;
            if(Trigger.isInsert || rrqm.RR_Member__c != Trigger.oldMap.get(rrqm.Id).RR_Member__c) {
                if(setQueueMembers <> null && setQueueMembers.contains(rrqm.RR_Member__c)) {
                    rrqm.addError(Label.RR_Queue_Member_Error_User_Already_Assigned);
                }
            }
            
        }
    }
}