/**********************************************************************
Name: TestSubHistoryRelatedlistController
Copyright © 2012 WK
======================================================
======================================================
Purpose: Test class for SubHistoryRelatedlistController.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Natesh   03/05/2012 INITIAL DEVELOPMENT
2.0       Aditya   14/06/2012 added code to cover the newly added logic.
***********************************************************************/
@isTest
private class TestSubHistoryRelatedlistController {
    
    static testMethod void myUnitTest() {
        integer testcount=101;
        Account newAccount = new Account();
        newAccount.Name = 'Test Account'+testcount;
        newAccount.Primary_Contact_Name__c = 'Test Contact'+testcount;
        newAccount.Email__c = 'Test12345'+testcount+'@Test.com';
        insert newAccount;
        
        Product_Category__c productCategoryobj=new Product_Category__c();
        productCategoryobj.Account__c=newAccount.Id;
        productCategoryobj.Activation__c='ABC'+testcount;
        productCategoryobj.Active__c=true;
        productCategoryobj.Invoice_Date__c=Date.today();
        productCategoryobj.Invoice_Number__c='1234'+testcount;
        productCategoryobj.Order_Date__c=Date.today();
        productCategoryobj.Unique_Key__c='unique1234'+testcount;
        insert productCategoryobj;
        
        ApexPages.StandardController controllerObj = new ApexPages.StandardController(newAccount);
        SubHistoryRelatedlistController SubHistController = new SubHistoryRelatedlistController(controllerObj);
        SubHistController.getSubscriptionHistory();
        
        List<Subscription_History__c> subHistoryList = new List<Subscription_History__c>();
        for(Integer cnt=1;cnt<=5;cnt++){
            Subscription_History__c subHistItem = new Subscription_History__c();
            subHistItem.Account__c = newAccount.Id;
            subHistItem.Quantity__c = 10*cnt;
            subHistItem.Prior_Year_Whole_Value__c = 12000*cnt;
            subHistoryList.add(subHistItem);
        }
        insert subHistoryList;
        SubHistController.getSubscriptionHistory();
        ApexPages.currentPage().getParameters().put('year',String.valueOf(Date.today().year()));
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(newAccount.Id));
        Component.Apex.TabPanel tabPanel1=SubHistController.getTabbedView();
        ApexPages.currentPage().getParameters().put('year',String.valueOf(Date.today().addYears(-2).year()));
        ApexPages.currentPage().getParameters().put('accountId',String.valueOf(newAccount.Id));
        Component.Apex.TabPanel tabPanel2=SubHistController.getTabbedView();
        ApexPages.currentPage().getParameters().put('year',String.valueOf(Date.today().addYears(-2).year()));
        ApexPages.currentPage().getParameters().put('accountId','abc');
        Component.Apex.TabPanel tabPanel3=SubHistController.getTabbedView();
    }
}