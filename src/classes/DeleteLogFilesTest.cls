@isTest()
public class DeleteLogFilesTest{

     Static testMethod void DeleteLogFiles(){
     
     DeleteLogFiles deletelog = new DeleteLogFiles();
     deletelog.clearLogs();
     Test.StartTest();
     String sch = '0 0 20 * * ?'; 
     system.schedule('Test LogDeletion', sch, deletelog); 
 }
 }