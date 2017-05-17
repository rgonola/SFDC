global with sharing class IIT_BatchCalculateTaxOnInv implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    global String query;
    global Database.QueryLocator start(Database.BatchableContext BC){
       
       query = 'SELECT Account_PID__c,Id,invoiceit_s__Invoice_Status__c,invoiceit_s__Tax__c,Name,Error_Log__c,Speed_TAX__c,ST_Transaction_Id__c FROM invoiceit_s__Invoice__c WHERE  (Is_DataLoader__c = false AND ST_Transaction_Id__c = null and invoiceit_s__Invoice_Status__c =\'Posted\') OR  (Is_DataLoader__c = false AND Cancel_Transaction_Id__c = null AND ST_Transaction_Id__c != null and invoiceit_s__Invoice_Status__c =\'Cancelled\') ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,list<invoiceit_s__Invoice__c> scope){
        System.debug('Invoice id is-->'+scope[0].id);
         String responseMsg = IIT_SpeedTaxConnector.postInvoiceTax(scope[0].id , scope[0].invoiceit_s__Invoice_Status__c);
               System.debug('responseMsgresponseMsgresponseMsg-->'+responseMsg);
                if(responseMsg != 'Sucessfully posted the Invoice'){
                    invoiceit_s__Invoice__c inv = new invoiceit_s__Invoice__c(id=scope[0].id , Error_Log__c = responseMsg,Tax_call_Error__c=true);
                    update inv;
                }
    
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}