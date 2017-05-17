trigger SolutionUpdate on Solution (After insert, after update) {
    SolutionTriggerHandler solnHandler=new SolutionTriggerHandler();
    List<CaseSolution> caseSolutionList;
    
    if (trigger.isAfter && trigger.isInsert){
         solnHandler.onAfterInsert(trigger.new);
    }
}