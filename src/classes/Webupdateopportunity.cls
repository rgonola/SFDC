global class Webupdateopportunity {

 webService static Id QTC(String qut) {
 
opportunity opp =[select Id,QTC__Create_Order__c From opportunity Where id=:qut];  

           opp.QTC__Create_Order__c=true;
           update opp;

       return opp.id;
    }

}