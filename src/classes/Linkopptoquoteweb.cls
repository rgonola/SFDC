global class Linkopptoquoteweb {

 webService static Id qutid(String qut,String oppid) {

SBQQ__Quote__c myQuote=[select Id,SBQQ__Opportunity2__c From SBQQ__Quote__c Where id=:qut]; 

opportunity opp =[select Id,QTC__Create_Order__c,SBQQ__PrimaryQuote__c From opportunity Where id=:oppid];  

                   myQuote.SBQQ__Opportunity2__c=opp.id;
                   update myQuote;
                   
                   opp.SBQQ__PrimaryQuote__c=myQuote.id;   
                   update opp;

       return opp.id;
    }

}