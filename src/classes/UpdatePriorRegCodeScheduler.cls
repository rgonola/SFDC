global class UpdatePriorRegCodeScheduler implements Schedulable{

    global void execute(SchedulableContext sc) {
      try{
        UpdatePriorRegCode UpdateRegCode=new UpdatePriorRegCode();
        ID batchprocessidA = Database.executeBatch(UpdateRegCode,100);            
      } catch(Exception Ex){
         system.debug('Exception'+Ex);
      }
        
    }
}