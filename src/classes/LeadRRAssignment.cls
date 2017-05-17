global class LeadRRAssignment Implements Schedulable
    {
         Integer nextInteger,userNo,prevInteger,ifirmUserNo;
         Map<Lead,User> userLeadMap = new Map<Lead,User>();
         Map<Lead,User> ifirmUserLeadMap = new Map<Lead,User>();
         List<User> userUpdate=new List<User>();
         List<User> usersUpdate=new List<User>();
       
        global void execute(SchedulableContext sc)
        {
            leadAssignment();
        }
 
        public void leadAssignment()
        {
           List<User> userList = [SELECT Name,id FROM User where UserRole.Name in ('New Sales User 1','New Sales User 2') and IsActive=true order by Name];
           List<User> ifirmUserList = [SELECT Name,id FROM User where UserRole.Name in ('iFirm Team') and IsActive=true order by Name];
          
            List<Lead> listLead =[SELECT Id, OwnerId,Priority__c,assignmentCheck__c,LastActivityDate FROM Lead WHERE Status='Open' AND ((Priority__c IN('1') AND XDays_Since_Last_Activity__c > 2) OR (Priority__c IN('2') AND XDays_Since_Last_Activity__c > 4) OR (Priority__c IN ('3') AND XDays_Since_Last_Activity__c > 7)
           OR (Priority__c IN ('4') AND XDays_Since_Last_Activity__c > 10) OR (Priority__c IN('5') AND XDays_Since_Last_Activity__c > 14)) AND (OwnerId In(SELECT Id FROM User where UserRole.Name in ('New Sales User 1','New Sales User 2'))) order by name];
           
           List<Lead> ifirmListLead =[SELECT Id, OwnerId,assignmentCheck__c,LastActivityDate FROM Lead WHERE  
           LeadSource like '%ifirm%' AND 
           (Owner.Name like '%SFS%' OR Owner.Name like '%Pardot%') order by name]; 
           
           /* Just for testing below query can be used */
          
          /* List<Lead> ifirmListLead =[SELECT Id, OwnerId,Priority__c,assignmentCheck__c,LastActivityDate FROM Lead WHERE Status='Open' AND ((Priority__c IN('1') AND XDays_Since_Last_Activity__c > 2) OR (Priority__c IN('2') AND XDays_Since_Last_Activity__c > 4) OR (Priority__c IN ('3') AND XDays_Since_Last_Activity__c > 7)
           OR (Priority__c IN ('4') AND XDays_Since_Last_Activity__c > 10) OR (Priority__c IN('5') AND XDays_Since_Last_Activity__c > 14)) AND LeadSource like '%ifirm%' order by name]; */
          
          system.debug('listLead.size()'+listLead.size());
          system.debug('ifirmListLead.size()'+ifirmListLead.size());
            
          system.debug('listLead'+listLead);
          system.debug('ifirmListLead'+ifirmListLead);
           
           List<User> toAssignOwner=[SELECT Name,Id,userRoleId,LeadUserNo__c,RRTracking__c FROM User where UserRole.Name in
           ('New Sales User 1','New Sales User 2')  and RRTracking__c=true and IsActive=true]; 
           
            List<User> toAssignifirm=[SELECT Name,Id,userRoleId,LeadUserNo__c,RRTracking__c FROM User where UserRole.Name in
           ('iFirm Team')  and RRTracking__c=true and IsActive=true]; 
           
           userNo = getUserNo(toAssignOwner);
           ifirmUserNo=getUserNo(toAssignifirm);
           
           system.debug('userNo '+userNo);
           
           system.debug('ifirmUserNo'+ifirmUserNo);
           
           
           for (Lead lead: listLead) {
               
                if(userNo < userList.size()){ 
                    userLeadMap.put(lead, userList.get(userNo++));
                  }else{
                    userNo = 0;
                    userLeadMap.put(lead, userList.get(userNo++));
                 }   
            }
            
            for(Lead lead: ifirmListLead){
               if(ifirmUserNo < ifirmUserList.size()){ 
                    ifirmUserLeadMap.put(lead, ifirmUserList.get(ifirmUserNo++));
                  }else{
                    ifirmUserNo = 0;
                    ifirmUserLeadMap.put(lead, ifirmUserList.get(ifirmUserNo++));
                }
             }
            
             system.debug('userLeadMap'+userLeadMap);
             system.debug('ifirmUserLeadMap'+ifirmUserLeadMap);
            
             Set<Lead> keyUserSet = userLeadMap.keySet();
             Set<Lead> keyifirmUserSet = ifirmUserLeadMap.keySet();
             
             system.debug('keyUserSet'+keyUserSet);
             system.debug('keyifirmUserSet'+keyifirmUserSet);
             try{
             reassignOwner(keyUserSet,userList,userLeadMap,'normalLead');
             reassignOwner(keyifirmUserSet,ifirmUserList,ifirmUserLeadMap,'ifirmLead');
              }catch(Exception e){}
        
         }
       
        
        public void reassignOwner(Set<Lead> keySetUser, List<User> userLists, Map<Lead,User> userLeadMap,String typeOfLead){
           
           List<Lead> listLeads=new List<Lead>();
            for (Lead lead: keySetUser) {
                system.debug('Before lead.ownerId'+lead.ownerId);
                if(typeOfLead=='normalLead'){
                    lead.ownerId=userLeadMap.get(lead).Id;  
                }
                else if(typeOfLead=='ifirmLead'){
                    lead.ownerId=ifirmUserLeadMap.get(lead).Id;
                }
                system.debug('After lead.ownerId'+lead.ownerId);
                
                lead.assignmentCheck__c=true;
                listLeads.add(lead);
                usersUpdate=listupdateNextUser(lead.ownerId,userLists);
             } 
                    
                  try{  
                  update listLeads;
                   }catch(Exception e){}
                   
                  if(usersUpdate.size()>0){
                     update usersUpdate;
                  }
           }
       
        
        
         public Integer getUserNo(List<User> toAssign){
          
           Integer numbUsers;
           system.debug('toAssign.size()'+toAssign.size()+toAssign);
           List<User> updateUser=new List<User>();
      
           if(toAssign.size()<=0){
               numbUsers=0;
           }
           else{
               for(User user:toAssign){
                   system.debug('user.UserNo__c'+user.LeadUserNo__c);
                   system.debug('ToBeassigned__c'+user.RRTracking__c);
                   user.RRTracking__c=false;
                   numbUsers= user.LeadUserNo__c.intValue();
                   updateUser.add(user);
               }
           }
           
           if(updateUser.size()>0){
            update updateUser;
           }
            return numbUsers;
        }
       
        
        public List<User> listupdateNextUser(Id leadId, List<User> listUsers) {
          
          List<User> userUpdate=new List<User>();
         
           Id currentUser,nextUser,prevUser;
          
           for (Integer i = 0; i < listUsers.size(); i++) {
                currentUser=listUsers.get(i).id;
                if(leadId==currentUser){
                  
                   if(leadId==listUsers.get(listUsers.size()-1).id) {
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
               
                
            user prevUserInfo= new User(id=prevUser,RRTracking__c=false,LeadUserNo__c=nextInteger);    
            user currentUserInfo= new User(id=leadId,RRTracking__c=true,LeadUserNo__c=nextInteger);
            
             system.debug('prevUserInfo'+ prevUserInfo);    
             system.debug('currentUserInfo'+ currentUserInfo);   
             
              userUpdate.add(prevUserInfo);
              userUpdate.add(currentUserInfo);
            
             return userUpdate;
             //system.debug('Updated'+ userUpdate.size());  
              
           }
            
    }