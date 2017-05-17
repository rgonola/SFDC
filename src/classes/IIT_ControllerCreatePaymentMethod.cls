public with sharing class IIT_ControllerCreatePaymentMethod {
        public SBQQ__Quote__c quoteObj{get;set;}
    public IIT_ControllerCreatePaymentMethod(ApexPages.StandardController controller) {
        quoteObj = (SBQQ__Quote__c)controller.getRecord();
        quoteObj = [select name,SBQQ__Account__r.Name,SBQQ__Account__c,QTC__Payment_Plan__c,SBQQ__ListAmount__c,SBQQ__NetAmount__c from SBQQ__Quote__c where id=: quoteObj.id];
        
    }
    public pagereference redirectPage(){
          Schema.DescribeSObjectResult R = invoiceit_s__Payment_Method__c.SObjectType.getDescribe();
           //PageReference pr = new PageReference('/' + R.getKeyPrefix() + '/e');
           PageReference pr = new PageReference('/apex/IIT_paymentMethodRedirect?aid='+quoteObj.SBQQ__Account__c+'&qid='+quoteObj.Id);
           //pr.getParameters().put(System.Label.AccountIdAyPaymentMethod+'_lkid',quoteObj.SBQQ__Account__c);
           //pr.getParameters().put(System.Label.AccountIdAyPaymentMethod,quoteObj.SBQQ__Account__r.Name);
           //pr.getParameters().put(System.Label.PaymentMethodType+'_lkid',quoteObj.SBQQ__Account__c);
           //pr.getParameters().put(System.Label.PaymentMethodType,'ACH');
           return pr;
    }
    public pagereference redirectTOCC(){
        //PageReference pr = new PageReference('/apex/invoiceit_s__generateTokenForCyberSource?id=' + quoteObj.SBQQ__Account__c);
        //return pr;
         Schema.DescribeSObjectResult R = invoiceit_s__Payment_Method__c.SObjectType.getDescribe();
         PageReference pr = new PageReference('/apex/IIT_paymentMethodRedirectCreditCard?aid='+quoteObj.SBQQ__Account__c+'&qid='+quoteObj.Id);
         //pr.getParameters().put(System.Label.PaymentMethodType,'CreditCard');
         return pr;
    }
}