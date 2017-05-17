trigger IITTriggerOnRevenueRecognitionSnapshot on Revenue_Recognition_Snapshot__c(after insert) {

    ClassAfterOnRevenueRecognitionSnapshot handler = new ClassAfterOnRevenueRecognitionSnapshot();
    handler.AfterInserthandler(Trigger.newMap, Trigger.oldMap);   
}