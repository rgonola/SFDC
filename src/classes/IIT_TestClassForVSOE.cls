@isTest(seealldata=true)
public with sharing class IIT_TestClassForVSOE{
    static testMethod void populateVSOE() {
       
        set<id> setOfIds = new set<id>();
        list<invoiceit_s__Job_Rate_Plan_Charge__c> listOrderRatePlanChargeisExist = [SELECT Id,invoiceit_s__Order__c ,QTC__Quote_Line__r.SBQQ__Product__c,invoiceit_s__VSOE_Pricing__c,invoiceit_s__Quantity__c,invoiceit_s__VSOE_Total__c,invoiceit_s__VSOE_Package_Total__c,invoiceit_s__Required_By__c,invoiceit_s__Bundle__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE
                                           invoiceit_s__Required_By__c != null
                                          AND invoiceit_s__Bundle__c = true LIMIT 1];
        for(invoiceit_s__Job_Rate_Plan_Charge__c orpc : listOrderRatePlanChargeisExist){
            System.debug('Order Ids are --->'+orpc.invoiceit_s__Order__c);
            setOfIds.add(orpc.invoiceit_s__Order__c);
        }
        Test.startTest();
            IIT_BatchReRunVSOE batch = new IIT_BatchReRunVSOE(setOfIds);
            ID batchprocessid = Database.executeBatch(batch, 1);
        Test.StopTest();
        
        
    }
}