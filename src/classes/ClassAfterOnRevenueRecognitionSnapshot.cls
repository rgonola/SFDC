Public Class ClassAfterOnRevenueRecognitionSnapshot
{
    public void AfterInserthandler(map<Id, Revenue_Recognition_Snapshot__c> newMap, map<Id, Revenue_Recognition_Snapshot__c> oldMap)
    {
        // this will initiate the batch process for creating the SnapShot
        for(Revenue_Recognition_Snapshot__c revenueRecSnapShot : newMap.values()) 
        {
            Date startDate = revenueRecSnapShot.Start_Date__c;
            Date endDate = revenueRecSnapShot.End_Date__c;
            BatchGenerateRevRecSnapshot b = new BatchGenerateRevRecSnapshot(revenueRecSnapShot.Id, startDate, endDate, revenueRecSnapShot.Currency__c, false);
            Database.ExecuteBatch(b);  
        }  
    }
}