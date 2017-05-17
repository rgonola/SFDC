/* Class is created for test code coverage of SolutionHandlerController*/

@isTest(SeeAllData= false)
private class TestSolutionHandlerController{
   
    static testMethod void assignProductValue() {
       
        List<Solution> solutionList=new List<Solution>();
        
        Account a1=new Account(Name='testAccount');
        insert a1;
        
        Contact conID=new Contact(Account=a1, MobilePhone='646548-6562',Lastname='Mah');
        insert conID;
        Case cs= new Case(
        Status = 'Working',
        Origin = 'Phone'
        );

        insert cs;
        
        Solution Soln=new Solution(SolutionName='Soln1');
        insert Soln; 
        solutionList.add(Soln);
       
        CaseSolution caseSoln=new CaseSolution(CaseId=cs.Id,SolutionId=Soln.Id);
        insert caseSoln;
        List<CaseSolution> caseSolutionList=[Select Id from CaseSolution 
                                             where caseId=:cs.Id and SolutionId=:soln.Id];
       
        SolutionTriggerHandler solnHandler=new SolutionTriggerHandler();
        solnHandler.onAfterInsert(solutionList);
        
     }    
}