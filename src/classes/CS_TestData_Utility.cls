/*   
* Created by : Cloud Sherpas Offshore - Project: CCHSFS 
* Date: 03/06/2013
* Description: This utility class is developed to create test data for test class 
               and can be reused.
*/


@isTest(SeeAllData=true)
global class CS_TestData_Utility {
	
	//method to create the single account
   public Account createAccountData(Id acctRecordTypeId, Integer OFFCInt, string PIDStr)
   {
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.RecordTypeId = acctRecordTypeId;
        acc.Primary_Contact_Name__c = 'Test Contact 1';
        acc.Email__c ='testcontact1@test.com';
        acc.Process__c = 'Sign & Close a Customer';
        acc.OFFC__c = OFFCInt;
	    acc.PID__c = PIDStr;
        
        return acc;
        
                                        
   } 
   
   
   //method to create the Accounts in bulk   
   public List<Account> createAccountDataLst(Id acctRecordTypeId, Integer OFFCInt, string PIDStr)
   {
        List<Account> accLst = new List<Account>();
        
        for(Integer i = 1; i<=5; i++)
        {
            Account acct = new Account();
            acct.Name = 'Test Account '+ String.valueOf(i);
            acct.RecordTypeId = acctRecordTypeId;
	        acct.Primary_Contact_Name__c = 'Test Contact ' + String.valueOf(i);
	        acct.Email__c ='testcontact'+String.valueOf(i)+'@test.com';
	        acct.Process__c = 'Sign & Close a Customer';
	        acct.OFFC__c = OFFCInt;
	        acct.PID__c = PIDStr;
            accLst.add(acct);
        }
        
        return accLst;
   }



//method to create the RR Members
public List<RR_Member__c> createRRmembers(list<User> newUserList)
{
	List<RR_Member__c> newRRMemberList = new List<RR_Member__c>();
    RR_Member__c rrMemberItem = new RR_Member__c();
        
        for(Integer i=0;i<5;i++){
            rrMemberItem = new RR_Member__c();
            rrMemberItem.Member__c = newUserList[i].Id;
            if(i==2){
                rrMemberItem.No_of_Other_Leads_Assigned__c = 248;
            }
            newRRMemberList.add(rrMemberItem);
        }
        
        return newRRMemberList;
}

   
   //method to create the users in bulk
   public list<User> createUsers()
   {
	   	 Id AMUserProfileId = [SELECT Id,Name FROM Profile WHERE Name='Account Management User'].Id;
	     List<User> newUserList = new List<User>();
	     User userItem = new User();
        for(Integer i=0;i<5;i++){
            userItem = new User();
            userItem.FirstName = 'Test';
            userItem.LastName = 'User 00' + i;
            userItem.Email = 'TestUser00' + i + '@Test.com';
            userItem.Username = 'TestUser00' + i + '@Test.com';
            userItem.Alias = 'Test00' + i;
            userItem.CommunityNickname = 'TestCommunity 00' + i;
            userItem.ProfileId = AMUserProfileId;
            userItem.TimeZoneSidKey = 'America/New_York';
            userItem.LocaleSidKey = 'en_US';
            userItem.LanguageLocaleKey = 'en_US';
            userItem.EmailEncodingKey = 'ISO-8859-1';
            newUserList.add(userItem);
        }
        
        return newUserList;
   }
   
   //method to create the users with different profile
   public User createUsersDiffProfile(string usrName, string profName, string roleName)
   {
	   	 Id AMUserProfileId = [SELECT Id,Name FROM Profile WHERE Name like: '%'+profName+'%' limit 1].Id;
	   	 id usrRoleId = [Select id, Name from UserRole where Name like: '%'+roleName+'%' limit 1 ].Id;
	     List<User> newUserList = new List<User>();
	     User userItem = new User();
        //for(Integer i=0;i<5;i++){
            userItem = new User();
            userItem.FirstName = 'Test';
            userItem.LastName = usrName;
            userItem.Email = 'TestUser' + usrName + '@Test.com';
            userItem.Username = 'TestUser00' + usrName + '@Test.com';
            userItem.Alias = 'Tst' + usrName.Left(3);
            userItem.CommunityNickname = 'TstComm' + usrName;
            userItem.ProfileId = AMUserProfileId;
            userItem.TimeZoneSidKey = 'America/New_York';
            userItem.LocaleSidKey = 'en_US';
            userItem.LanguageLocaleKey = 'en_US';
            userItem.EmailEncodingKey = 'ISO-8859-1';
            userItem.UserRoleId = usrRoleId;
            newUserList.add(userItem);
       // }
        
        return userItem;
   }

//method to retrieve the users from data base in case if system is not allowing you to create test user record due to mixed DML exception   
   public User getUsersDiffProfile(string usrName, string profName, string roleName)
   {
	   	 Id AMUserProfileId = [SELECT Id,Name FROM Profile WHERE Name like: '%'+profName+'%' limit 1].Id;
	   	 id usrRoleId = [Select id, Name from UserRole where Name like: '%'+roleName+'%' limit 1 ].Id;
	     List<User> newUserList = new List<User>();
	     User userItem = new User();
         userItem = [select id, Name, UserRole.Name from User where ProfileId =: AMUserProfileId and UserRoleId =: usrRoleId limit 1];
         
        return userItem;
   }
   
   
 //method to create the test leads
 public Lead createLeadRec (string LstName ,id AMFSNSRecordTypeId, id ldOwnerId) 
 {
 	Lead newLead1 = new Lead(LastName = LstName, Company = 'Test Lead for Update EXP111',
                                   Status = 'Open', Primary_Contact_Email__c = 'TestEmail'+LstName+'@test.com',
                                   RecordTypeId = AMFSNSRecordTypeId, Process__c = 'Sign and Close a Prospect', OwnerId = ldOwnerId);
                                   
   return newLead1;                                
 } 
 
 
 //method to create the test leads in bulk
 public list<Lead> createLeadLst (string LstName ,id AMFSNSRecordTypeId, id ldOwnerId) 
 {
 	list<Lead> newLeadLst = new list<Lead>();
 	
 	for(Integer i=0;i<5;i++)
 	{
 		string tempStr = LstName+i;
	 	Lead newLead1 = new Lead(LastName = tempStr, Company = 'Test Lead for Update EXP111',
	                                   Status = 'Open', Primary_Contact_Email__c = 'TestEmail'+tempStr+'@test.com',
	                                   RecordTypeId = AMFSNSRecordTypeId, Process__c = 'Sign and Close a Prospect', OwnerId = ldOwnerId);
 	}                                
                                   
   return newLeadLst;                                
 }   
   
   
   
}