global class ScheduledDispatcher Implements Schedulable {
	public Interface IScheduleDispatched 
    { 
        void execute(SchedulableContext sc); 
    } 
    
    global void execute(SchedulableContext sc) 
    {
        Type targettype = Type.forName('ScheduleHandler');   
        if(targettype!=null) {
            IScheduleDispatched obj = (IScheduleDispatched)targettype.NewInstance();
            obj.execute(sc);   
        } 
    } 
}