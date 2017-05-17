trigger NewSalesHandOffRR on Contract (after insert, after update) {
    
    Map<Contract,User> userContractMap = new Map<Contract,User>();
    Integer nextInteger,userNo,prevInteger;
    List<User> userUpdate=new List<User>();
    List<Account> listAccount=new List<Account>();
    Set<Id> listUserContract=new Set<Id>();
    List<User> userList = [SELECT Name,id FROM User where UserRole.Name in ('AM Team 1','AM Team 2') and IsActive=true and Out_Of_Office__c=false order by Name];
    List<User> toAssignOwner=[SELECT Name,Id,userRoleId,UserNo__c,ToBeassigned__c FROM User where UserRole.Name in ('AM Team 1','AM Team 2') and IsActive=true and ToBeassigned__c=true];
     
     userNo = getUserNo(toAssignOwner);
     system.debug('userNo**'+userNo);
     
     List<Account> listOwnerUpdate=new List<Account>();
     
     for (Contract contract: trigger.new) {
          
          if(userNo < userList.size()){ 
            userContractMap .put(contract, userList.get(userNo++));
            listUserContract.add(contract.AccountId);
          }else{
            
            userNo = 0;
            userContractMap .put(contract, userList.get(userNo++));
            listUserContract.add(contract.AccountId);
         }
       }
     
      system.debug('listUserContract**'+listUserContract);
 
      
       Map<Id, Account> accList= new Map<Id, Account>([SELECT Id, ownerId,Name,assignmentCheck__c FROM Account 
             WHERE Id In (SELECT AccountId from Opportunity where AccountId In:listUserContract and Owner.UserRole.Name in 
              ('New Sales User 1','New Sales User 2') and StageName in ('Commitment','Active','Onboard')) and ownerId not In:userList]);
              
        
       /*Map<Id, Account> accList= new Map<Id, Account>([SELECT Id, ownerId,Name,assignmentCheck__c FROM Account 
             WHERE Id In (SELECT AccountId from Opportunity where AccountId In:listUserContract and StageName in ('Commitment','Active','Onboard'))]);   */   
              
              system.debug('accList**'+accList);
              
              List<invoiceit_s__Invoice__c> invoices=[Select Id, Name,invoiceit_s__Invoice_Status__c from invoiceit_s__Invoice__c  where invoiceit_s__Account__c In:listUserContract and invoiceit_s__Invoice_Status__c='Posted'];
       system.debug('Invoices'+invoices); 
              
              
       
       Set<Contract> keyUserSet = userContractMap.keySet();
       system.debug('keyUserSet **'+keyUserSet);
       
       for (Contract contr: keyUserSet) {
            system.debug('Inside KeyUserSet');
            system.debug('ContractAccountId**'+contr.AccountId);
            Account acc = accList.get(contr.AccountId);
            Boolean invoiceFlag=false;
            Boolean contractFlag=false;
            system.debug('Account value**'+acc);
            if(acc!=null) {
                if(invoices.size() > 0 && invoiceFlag==false && 
                    accList.size() > 0 && contractFlag==false){
                    Account acctToUpdate = new Account(Id=acc.Id, ownerId=userContractMap.get(contr).Id);
                    acc.assignmentCheck__c=true; 
                    invoiceFlag=true;
                    contractFlag=true;
                    system.debug('After the user is changesd'+acctToUpdate.ownerId);
                    listOwnerUpdate.add(acctToUpdate);
                    userUpdate=listupdateNextUser(acctToUpdate.ownerId,userList);
               }
             }
           } 
                  
          update listOwnerUpdate;
          if(userUpdate.size()>0){
            update userUpdate;
          }
              
       public Integer getUserNo(List<User> toAssign){
           Integer numbUsers;
          List<User> updateUser=new List<User>();
       
           if(toAssign.size()<=0){
               numbUsers=0;
           }
           else{
               for(User user:toAssign){
                   numbUsers= user.UserNo__c.intValue(); 
                   user.ToBeassigned__c=false;
                  
               }
           }
       
            return numbUsers;
      }    
      
             
      public List<User> listupdateNextUser(Id accId, List<User> listUsers) {
           List<User> fieldUpdate=new List<User>();
          
           Id currentUser,prevUser;
           for (Integer i = 0; i < listUsers.size(); i++) {
                currentUser=listUsers.get(i).id;
                if(accId==currentUser){
                   
                   if(accId==listUsers.get(listUsers.size()-1).id) {
                      nextInteger=0;
                      prevInteger=i-1;
                      prevUser=listUsers.get(prevInteger).id;
                      
                    }
                      else{
                          if(i>0){
                             prevInteger=i-1; 
                          }
                         else{
                             prevInteger=listUsers.size()-1;
                         }
                       nextInteger=i+1;
                       
                       prevUser=listUsers.get(prevInteger).id;
                     }
                 }
             }                
                
                 User prevtUserInfo= new User(id=prevUser,ToBeassigned__c=false,UserNo__c=nextInteger);
                 User currentUserInfo= new User (id=accId,ToBeassigned__c=true,UserNo__c=nextInteger);
                
                 
                 fieldUpdate.add(prevtUserInfo);
                 fieldUpdate.add(currentUserInfo);
              
                  return fieldUpdate;
        }       
             
      


}