public class SchedulerforRevenueTransaction implements Schedulable {

    public void execute(SchedulableContext SC){
        doScheduling();
    }
    public void doScheduling(){
        try{
            
            invoiceit_s.BatchProcessRevenueForInvoiceLines batch = new invoiceit_s.BatchProcessRevenueForInvoiceLines(null); 
            Database.executeBatch(batch, 1);
       
        } catch(Exception ex){
            System.debug('Exception in CallUpdateRegScheduler '+ex.getMessage());
        }
    }
}