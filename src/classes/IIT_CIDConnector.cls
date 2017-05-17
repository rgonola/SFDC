global class IIT_CIDConnector {
      
    
    webservice static string getCustomerBalance(string cid){
        string unpaid;
        if(cid != '' || cid != null){
           list<Account> acc = [SELECT Outstanding_Balance__c ,Unallocated_Amount__c , Unpaid_Amount__c ,Active__c,CID__c,Id,Name,OFFC__c,PID_GROUP__c,PID__c FROM Account WHERE CID__c = :cid];
           if(acc.size() > 0){
               
               unpaid = string.valueof(acc[0].Outstanding_Balance__c);
           }else{
               
               unpaid = 'CID doesnt associated with any account';
           }
           
        }else{
            return 'Please pass the CID';
        }
        return unpaid;
    }
}