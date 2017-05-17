@isTest
private class testUpdatePaymentsOnQuote {

    static testMethod void myUnitTest() {
        Account acct = new Account(Name='TestAcc');
        insert acct;
        SBQQ__Quote__c q=new SBQQ__Quote__c();
        q.SBQQ__Account__c = acct.Id;
        insert q;
        invoiceit_s__Payment_Plan_Installment__c ppi1 = new invoiceit_s__Payment_Plan_Installment__c();
        ppi1.QTC__Quote__c = q.Id;
        ppi1.invoiceit_s__Payment_Date__c=system.today();
        ppi1.invoiceit_s__Payment_Type__c='Credit Card';
        ppi1.invoiceit_s__Payment_Amount__c=10;
        insert ppi1;
        invoiceit_s__Payment_Plan_Installment__c ppi2 = new invoiceit_s__Payment_Plan_Installment__c();
        ppi2.QTC__Quote__c = q.Id;
        ppi2.invoiceit_s__Payment_Date__c=system.today();
        ppi2.invoiceit_s__Payment_Type__c='ACH';
        ppi2.invoiceit_s__Payment_Amount__c=123;
        insert ppi2;
        
        invoiceit_s__Payment_Plan_Installment__c ppi3 = new invoiceit_s__Payment_Plan_Installment__c();
        ppi3.QTC__Quote__c = q.Id;
        ppi3.invoiceit_s__Payment_Date__c=system.today();
        ppi3.invoiceit_s__Payment_Amount__c=100;
        insert ppi3;
        
        SBQQ__Quote__c q2 = [select Payment_Details_rt__c from SBQQ__Quote__c where Id=:q.id];
        System.assert(!String.isBlank(q2.Payment_Details_rt__c));
        System.assert(q2.Payment_Details_rt__c.contains('10'));
        System.assert(q2.Payment_Details_rt__c.contains('123'));
        System.assert(q2.Payment_Details_rt__c.contains('100'));
        delete ppi3;
        
    }
}