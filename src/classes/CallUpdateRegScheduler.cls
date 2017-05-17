public class CallUpdateRegScheduler implements Schedulable {

    public void execute(SchedulableContext SC){
        doScheduling();
    }
    public void doScheduling(){
        try{
            UpdateRegCodeScheduler updateReg= new UpdateRegCodeScheduler();
            System.schedule('RegCode Job 1', '0 0 * * * ?',updateReg);
            System.schedule('RegCode Job 2', '0 05 * * * ?',updateReg);
            System.schedule('RegCode Job 3', '0 10 * * * ?',updateReg);
            System.schedule('RegCode Job 4', '0 15 * * * ?',updateReg);
            System.schedule('RegCode Job 5', '0 20 * * * ?',updateReg);
            System.schedule('RegCode Job 6', '0 25 * * * ?',updateReg);
            System.schedule('RegCode Job 7', '0 30 * * * ?',updateReg);
            System.schedule('RegCode Job 8', '0 35 * * * ?',updateReg);
            System.schedule('RegCode Job 9', '0 40 * * * ?',updateReg);
            System.schedule('RegCode Job 10', '0 45 * * * ?',updateReg);
            System.schedule('RegCode Job 11', '0 50 * * * ?',updateReg);
            System.schedule('RegCode Job 12', '0 55 * * * ?',updateReg);
       
        } catch(Exception ex){
            System.debug('Exception in CallUpdateRegScheduler '+ex.getMessage());
        }
    }
}