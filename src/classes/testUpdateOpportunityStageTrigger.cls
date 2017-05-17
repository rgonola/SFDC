@isTest
private class testUpdateOpportunityStageTrigger {

    static testMethod void myUnitTest() {
        Account acct = new Account(Name='TestAcc');
        insert acct;
        Opportunity opp = new Opportunity(Name='TestOpp',AccountId=acct.Id);
        opp.StageName='Demo';
        opp.CloseDate=system.today();
        insert opp;
        SBQQ__Quote__c q=new SBQQ__Quote__c();
        q.SBQQ__Account__c = acct.Id;    
        insert q;
        q.Do_It__c = true;
        update q;
        Opportunity opp2 = [select Id, StageName from Opportunity where  id=:opp.Id];
        system.assertEquals(opp2.StageName,'Demo');
        q.SBQQ__Opportunity2__c=opp.Id;
        update q;
        opp2 = [select Id, StageName from Opportunity where  id=:opp.Id];
        system.assertEquals(opp2.StageName,'Active');
        
    }
    
}