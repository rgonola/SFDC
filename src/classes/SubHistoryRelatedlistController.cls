/**********************************************************************
Name: SubHistoryRelatedlistController
Copyright © 2012 WK
======================================================
======================================================
Purpose: This class is used in the account view page to show the subscription history.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR   DATE       DETAIL 
1.0       Aditya   28/03/2012 INITIAL DEVELOPMENT 
***********************************************************************/

public with sharing class SubHistoryRelatedlistController {
public String accountId{get;set;}
public String year{get;set;}
private final Account accountObj;
public boolean showTable{get;set;}
public boolean showmessage{get;set;}
public List<Subscription_History__c> listSubscription{get;set;}

public SubHistoryRelatedlistController(ApexPages.StandardController controllerObj){
    this.accountObj=(Account)controllerObj.getRecord();
    accountId=accountObj.Id;
    
    system.debug('-----accountId----'+accountId);
}
public void getSubscriptionHistory(){
    listSubscription=[select Id,Year__c,Previous_Software__c,Account__r.Current_Software__c,Product_Name__c,Account__r.Qualify__c,Active_Bank_del__c,Bank_Products_del__c,
                       E_files_del__c,Refund_Amount_del__c,Refunded_Product_del__c,Software_Invoice_Amount_del__c,Whole_Value_del__c,Purchase_Date__c 
                       ,Prior_Year_Whole_Value__c,E_File_Fees__c,PPR_PRS_Count__c,Workflow_Product__c,Accounting_Product__c,
                        Research_Product__c,Total_Office_Product__c,Active_Promo__c,Active_Contract__c,Training_Purchased__c from Subscription_History__c where Account__c=:accountId order by year__c desc];
    system.debug('------listSubscription--------'+listSubscription);
    if(listSubscription!=null && listSubscription.size()>0){
        showTable=true;
        showmessage=false;
    }else{
        showTable=false;
        showmessage=true;
    }
}

 public Component.Apex.TabPanel getTabbedView(){
    String strYear=ApexPages.currentPage().getParameters().get('year');
    String accountId=ApexPages.currentPage().getParameters().get('accountId');
    system.debug('----accountId------'+accountId);
    system.debug('----strYear------'+strYear);
    year=strYear;
    Set<Integer> setYears=new Set<Integer>();
    List<Product_Category__c> lstProductCategory=[select Id,Account__c,Product_Code__c,Product_Description__c,Activation__c,Ship_Date__c,Order_Number__c,Order_Date__c from Product_Category__c where Account__c=:accountId];
    for(Product_Category__c lstObj:lstProductCategory){
        if(lstObj.Order_Date__c!=null)
            setYears.add(lstObj.Order_Date__c.year());
    }
    system.debug('----setYears----'+setYears);
    Component.Apex.TabPanel panel = new Component.Apex.TabPanel(switchType = 'client',title = 'Products',selectedTab=year,width='100%');
    if(setYears!=null && setYears.size()>0){
    for(Integer intYearObj:setYears){
        Component.Apex.Tab acctTab = new Component.Apex.Tab();
        acctTab.label = String.valueOf(intYearObj);
        acctTab.name = String.valueOf(intYearObj);
        panel.childComponents.add(acctTab);
        List<Product_Category__c> actualList=new List<Product_Category__c>();
        for(Product_Category__c obj:lstProductCategory){
            if(obj.Order_Date__c!=null && (obj.Order_Date__c.year()==intYearObj)){
                actualList.add(obj);
            }
        }
        system.debug('-----actualList-------'+actualList);
        
        Component.Apex.PageBlockTable pbtable=new Component.Apex.PageBlockTable();
        pbtable.value=actualList;
        pbtable.var='lstObj';
        
        Component.Apex.outputField out = new Component.Apex.outputField();
        out.Expressions.value = '{!lstObj.Product_Code__c}';
        
        Component.Apex.outputLink lnk=new Component.Apex.outputLink();
        lnk.expressions.Value='/{!lstObj.id}';
        lnk.childComponents.add(out);
        
        Component.Apex.Column productCode = new Component.Apex.Column(headerValue='Product Code');
        productCode.childComponents.add(lnk);
        
        Component.Apex.Column productDescription = new Component.Apex.Column();
        productDescription.expressions.value = '{!lstObj.Product_Description__c}';
        
        Component.Apex.Column invoiceNumber = new Component.Apex.Column();
        invoiceNumber.expressions.value = '{!lstObj.Activation__c}';
        
        Component.Apex.Column orderNumber = new Component.Apex.Column();
        orderNumber.expressions.value = '{!lstObj.Order_Number__c}';
        
        Component.Apex.Column shipDate = new Component.Apex.Column();
        shipDate.expressions.value = '{!lstObj.Ship_Date__c}';
        
        pbtable.childComponents.add(productCode);
        pbtable.childComponents.add(productDescription);
        pbtable.childComponents.add(invoiceNumber);
        pbtable.childComponents.add(orderNumber);
        pbtable.childComponents.add(shipDate);
        
        acctTab.childComponents.add(pbtable);
        panel.childComponents.add(acctTab);
    }
    if(!setYears.contains(Integer.valueOf(strYear))){
            Component.Apex.Tab acctTab2 = new Component.Apex.Tab();
            acctTab2.label = String.valueOf(strYear);
            acctTab2.name = String.valueOf(strYear);
            panel.childComponents.add(acctTab2);
            Component.Apex.pageMessage pageMessage=new Component.Apex.pageMessage(summary='No Records Found',strength='3',severity='info');
            acctTab2.childComponents.add(pageMessage);
        }
    }else{
        Component.Apex.Tab acctTab2 = new Component.Apex.Tab();
        acctTab2.label = String.valueOf(strYear);
        acctTab2.name = String.valueOf(strYear);
        panel.childComponents.add(acctTab2);
        Component.Apex.pageMessage pageMessage=new Component.Apex.pageMessage(summary='No Records Found',strength='3',severity='info');
        acctTab2.childComponents.add(pageMessage);
    }
        return panel;                                                    
  }
}