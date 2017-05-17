public class SolutionTriggerHandler {
    Set<Id> solutionSet=new Set<Id>();
    Set<Id> caseSet=new Set<Id>();
    List<CaseSolution> caseSolutionList;
    List<Case> caseList=new List<Case>();
    List<Solution> solnList=new List<Solution>();
    
    public void onAfterInsert(List<Solution> SolutionList) {
     
     //List <Monitoring_Log__c> errorRecordslist= new List <Monitoring_Log__c>();
     //try{
        for(Solution soln:SolutionList){
           solutionSet.add(soln.Id);
           
         } 
         if(solutionSet.size()>0){
            caseSolutionList=[Select Id, CaseId, SolutionId from CaseSolution where SolutionId In:solutionSet];
         } 
         if(caseSolutionList.size()>0){
           for(CaseSolution caseSolution:caseSolutionList){
             caseSet.add(caseSolution.CaseId);
            }
         }   
         if(caseSet.size()>0){
             caseList=[Select Id,Product__c,topic__c from Case where Id In:caseSet];
         }
         if(caseList.size()>0){
            for(Case cases: caseList){
              for(CaseSolution caseSln:caseSolutionList){
                if(cases.Id==caseSln.CaseId){
                  Solution solution=new Solution(Id=caseSln.SolutionId,Products__c=cases.Product__c,topic__c=cases.topic__c);
                   solnList.add(solution);
                  }
               }
            }
         } 
          
        if(solnList.size()>0){
           update solnList;
         } 
       //}catch(WK_Exception e ){
        // errorRecordslist.add(LoggerUtil.createMonitoringLogWithTpe('Product update in Solution','SolutionTriggerHandler',
         // e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage(),'CreateMonitoringLogWithTpe',WK_Exception.ATA_CODE_ERROR));
       //}    
       //if(errorRecordslist.size()>0){
          // Database.insert(errorRecordslist,false);
       //}         
    }
}