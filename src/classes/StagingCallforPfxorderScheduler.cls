global class StagingCallforPfxorderScheduler implements Schedulable{

    global void execute(SchedulableContext sc) {
      try{
        StagingCallforPfxorder UpdateRegCode=new StagingCallforPfxorder();
        ID batchprocessidA = Database.executeBatch(UpdateRegCode,1);            
      } catch(Exception Ex){
         system.debug('Exception'+Ex);
      }
        
    }
}