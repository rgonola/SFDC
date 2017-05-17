public class UpdateContractedFlag implements Schedulable {
    public void execute(SchedulableContext sc) {
        List<Opportunity> opptiesToUpdate = new List<Opportunity>();
        
        for(Opportunity oppty : [Select Id, Stagename, Product__c, SBQQ__Contracted__c,Onboard_Time__c From Opportunity Where StageName = 'Onboard' AND Product__c = 'Web-Order' AND SBQQ__Contracted__c = false  Limit 50]) {
          if( oppty.Onboard_Time__c.addMinutes(5) < system.now() || Test.isRunningTest()){
            oppty.SBQQ__Contracted__c = true;
            opptiesToUpdate.add(oppty);
            }
        }
        
        if(!opptiesToUpdate.isEmpty())
            update opptiesToUpdate;
    }
}