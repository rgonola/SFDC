global class UpdateRegCodeScheduler implements Schedulable{

    global void execute(SchedulableContext sc) {
      try{
        UpdateRegCode UpdateRegCode=new UpdateRegCode();
        ID batchprocessidA = Database.executeBatch(UpdateRegCode,50);            
      } catch(Exception Ex){
         system.debug('Exception'+Ex);
      }
        
    }
}