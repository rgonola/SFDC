trigger RoundRobinAssignmentOnOpportunity on Opportunity(after insert, after update) 
{
    
          Map<Opportunity,User> userOppMap = new Map<Opportunity,User>();
          Map<Opportunity,User> trainerOppMap = new Map<Opportunity,User>();
           
          Integer nextInteger,userNo,trainerNo;
          
          List<User> trainersUpdate=new List<User>();
          List<User> userUpdate=new List<User>();
          
          List<Account> listAccount=new List<Account>();
          List<Account> listOwnerUpdate=new List<Account>();
          
          Set<Id> listUserOpp=new Set<Id>();
          Set<Id> listTrainerOpp=new Set<Id>();
          
          List<User> userList = [SELECT Name,id FROM User where UserRole.Name in ('AM Team 1','AM Team 2') and IsActive=true];
          List<User> trainerList = [SELECT Name,Id,userRoleId FROM User where UserRole.Name='Specialists' and IsActive=true];
          
          List<User> toAssigntrainer=[SELECT Name,Id,userRoleId,UserNo__c,ToBeassigned__c FROM User where UserRole.Name='Specialists' and IsActive=true and ToBeassigned__c=true];
          List<User> toAssignOwner=[SELECT Name,Id,userRoleId,UserNo__c,ToBeassigned__c FROM User where UserRole.Name in ('AM Team 1','AM Team 2') and IsActive=true and ToBeassigned__c=true];
          
          
         
         
          /*To get the UserNo. in series*/
          
          userNo = getUserNo(toAssignOwner);
          trainerNo= getUserNo(toAssigntrainer); 
          
            
         /* Adding Users and Opportunities in Map*/
            
           for (Opportunity opp: trigger.new) {
                
                
                if(trainerNo < trainerList.size() ){  
                    trainerOppMap.put(opp, trainerList.get(trainerNo++));
                    listTrainerOpp.add(opp.AccountId);
                }else{
                    trainerNo = 0;
                    trainerOppMap.put(opp, trainerList.get(trainerNo++));
                    listTrainerOpp.add(opp.AccountId);
                }

                if(userNo < userList.size()){  
                    userOppMap .put(opp, userList.get(userNo++));
                    listUserOpp.add(opp.AccountId);
                 }else{
                    userNo = 0;
                    userOppMap .put(opp, userList.get(userNo++));
                    listUserOpp.add(opp.AccountId);
                  }
              }
             

  /* Fetching Accounts associated with Opportunities which belongs to New Sales User and other User(Writing query and fetching as user Role is not part of Account and Contacts) */
             
             List<Account> listTrainerAccount = [SELECT Id,Trainer__c, Name FROM Account 
             WHERE Id IN (SELECT AccountId from Opportunity where AccountId In :listUserOpp and StageName in ('Commitment','Active','Onboard'))];  
                
             List<Account> accList=[SELECT Id, ownerId,Name,assignmentCheck__c FROM Account 
             WHERE Id IN (SELECT AccountId from Opportunity where AccountId IN :listUserOpp and Owner.UserRole.Name in 
              ('New Sales User 1','New Sales User 2') and StageName in ('Commitment','Active','Onboard'))];
            
             
             Set<Opportunity> keyUserSet = userOppMap.keySet();
             Set<Opportunity> keyTrainerSet = trainerOppMap.keySet();
            
         
            for (Opportunity opp: keyTrainerSet) {   
                  
                for(Account acc: listTrainerAccount){       
                   
                    if(opp.AccountId==acc.Id){
                       
                       if(String.isBlank(acc.Trainer__c)){
                           acc.Trainer__c=trainerOppMap.get(opp).Id;
                           system.debug('TrainerAfter****'+acc.Trainer__c);
                           acc.trainerAssigned__c=true;
                           listAccount.add(acc);
                           
                           /* For storing the current and next user sequence*/
                           
                           trainersUpdate=listupdateNextUser(acc.Trainer__c,trainerList);
                           
                         }
                    }
                 }
            }
             
             
           update listAccount;
              
           
          if(trainersUpdate.size()>0&& trainersUpdate!=null){
               update trainersUpdate;
           }
            
           
           
           for (Opportunity oppt: keyUserSet) {
            for(Account acc: accList){
                if(oppt.AccountId==acc.Id){
                  
                    UserRole userRole=[Select name,Id from UserRole where Id in (SELECT userRoleId FROM User where Id=:acc.ownerId)];
                    system.debug('userRole**'+userRole.Name);
                    if(userRole.name != 'AM Team 1'&& userRole.name != 'AM Team 2') {
                        Account acctToUpdate = new Account(Id=acc.Id, ownerId=userOppMap.get(oppt).Id);
                        acc.assignmentCheck__c=true; 
                        listOwnerUpdate.add(acctToUpdate);
                       
                       userUpdate=listupdateNextUser(acctToUpdate.ownerId,userList);
                        
                    }
                 }
              }
           } 
                  
               update listOwnerUpdate;
              if(userUpdate.size()>0&& userUpdate!=null){
               update userUpdate;
           }
             
             
             
      
        
         /* All methods below*/
     
         /*For getting No.of Users*/
     
        public Integer getUserNo(List<User> toAssign){
           Integer numbUsers;
          
       
           if(toAssign.size()<=0){
               numbUsers=0;
           }
           else{
               for(User user:toAssign){
                   numbUsers= user.UserNo__c.intValue(); 
               }
           }
       
            return numbUsers;
        }
      
         
                
      
       public List<User> listupdateNextUser(Id accId, List<User> listUsers) {
           List<User> trainerUpdate=new List<User>();
          
           Id currentUser,nextUser;
           for (Integer i = 0; i < listUsers.size(); i++) {
                currentUser=listUsers.get(i).id;
                if(accId==currentUser){
                   
                   if(accId==listUsers.get(listUsers.size()-1).id) {
                      nextInteger=0;
                      nextUser=listUsers.get(nextInteger).id;
                      
                    }
                      else{
                       nextInteger=i+1;
                       nextUser=listUsers.get(nextInteger).id;
                      
                     }
                  }
               }
                
                
                
                 User currentUserInfo= new User (id=accId,ToBeassigned__c=false,UserNo__c=0);
                 User nextUserInfo= new User(id=nextUser,ToBeassigned__c=true,UserNo__c=nextInteger);
                 
                 
                 trainerUpdate.add(currentUserInfo);
                 trainerUpdate.add(nextUserInfo);
              
              
              return trainerUpdate;
        }
     
                  
 }