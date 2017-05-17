/**********************************************************************
Name: bfInsUpdValidateQueueName
Copyright © 2012 WK
======================================================
======================================================
Purpose: This trigger will be called when a new RR queue record is created or updated
         This trigger will raise an error if an RR queue record name matches an existing queue name
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR            DATE       DETAIL 
1.0       Venkata.Penneti   05/24/2012 INITIAL DEVELOPMENT
1.1       Ted Shevlin       03/30/2013 Code refactoring
                                       Added comments
                                       Rewrote if-then logic to make clearer
***********************************************************************/

trigger bfInsUpdValidateQueueName on RR_Queue__c (before insert, before update) {

    // Setup set of standard queue names to check against in next step
    Set<String> setQueueNames = new Set<String>();
    for(Group groupItem: [SELECT Id,Name FROM Group WHERE Type = 'Queue']) {
        setQueueNames.add(groupItem.Name);
    }

    // For all records being modified, if the queue name matches an existing standard queue, error
    for(RR_Queue__c rrq : Trigger.new) {
        if(!setQueueNames.contains(rrq.Queue_Name__c)) {
            rrq.addError(Label.RR_Queue_Error_Invalid_Queue_Name);
        }
    }
}