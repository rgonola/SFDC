@isTest
public class TestprimaryContactInformation {
    static testMethod void myUnitTest() {
      Account acc= new Account();
      acc.Name = 'Test Acc';
      insert acc;
      Contact con = new Contact();
      con.AccountId = acc.Id;
      con.LastName = 'test con';
      con.Email = 'testcon@test.com';
      con.phone = '94445667823';
      insert con;
      con.Is_Primary__c = True ;
      update con;
      acc.Email__c = con.Email;
      acc.Primary_Contact_Name__c = con.LastName;
      acc.Primary_Contact_Phone__c = con.Phone;
      update acc; 
      
      
    }
 
}