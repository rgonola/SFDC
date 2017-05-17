@isTest (SeeAllData=true)
public class LeadRRAssignmentTest {
    
    @isTest
    public static void leadRRAsignTest() {
        Test.startTest();
        String CRON_EXP = '0 0 0 * * ?';
        
        Profile p = [Select Id from Profile where Name like '% Administrator' limit 1];
        UserRole ur = [Select Id, Name from UserRole where Name =: 'New Sales User 1'];
        //Create User
        User u = new User(Alias = 'testuser', Email='testuser@bio-rad.com', UserRoleId = ur.Id,
          EmailEncodingKey='UTF-8', LastName='SFS', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id,
          TimeZoneSidKey='America/Los_Angeles', UserName='testuser@bio-rad.com');
        
        insert u;
        
        System.runAs(u) {
            Lead l = new Lead();
            l.LastName = 'Test Lead';
            l.Company = 'Test Comp';
            l.Priority__c = '1';
            l.assignmentCheck__c = true;
            l.Status='Open';
            insert l;
            
            Task t= new Task(Subject='Test task', WhoId= l.id, ActivityDate = Date.today() - 4, Status = 'Completed');
            insert t;
            System.debug('=====================l:'+l);
            System.debug('=====================l.XDays_Since_Last_Activity__c:'+l.XDays_Since_Last_Activity__c);
            LeadRRAssignment sch = new LeadRRAssignment();
            String jobId = System.schedule('TestScheduledApex',CRON_EXP,sch);
        }
        Test.stopTest();
    }
}