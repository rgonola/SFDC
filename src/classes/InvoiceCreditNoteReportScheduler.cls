global class InvoiceCreditNoteReportScheduler implements Schedulable{

    global void execute(SchedulableContext sc) {
      try{
        InvoiceReportBatch icr=new InvoiceReportBatch();
        CreditNoteReportBatch crNote=new CreditNoteReportBatch();
        ID batchprocessidA = Database.executeBatch(icr,50);
        ID batchprocessidB = Database.executeBatch(crNote,50);  
                  
      } catch(Exception Ex){
         system.debug('Exception'+Ex);
      }
        
    }
}