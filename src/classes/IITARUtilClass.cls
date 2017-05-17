public with sharing class IITARUtilClass {
  public static list<AR_Snapshot__c> populateARUnpaidInvoices(list<invoiceit_s__Invoice__c> unpaidInvoices, string nameOfAR, date closingDate) {

    list<AR_Snapshot__c> snapshotRecordsToInsert = new list<AR_Snapshot__c>();  
    AR_Snapshot__c snapshot;

    for(invoiceit_s__Invoice__c unpaidInvoice : unpaidInvoices) {

      integer NoOfDaysfromInvoiceDateToClosingDate = unpaidInvoice.invoiceit_s__Invoice_Date__c.daysBetween(closingDate);

          snapshot = new AR_Snapshot__c();
          snapshot.Name = nameOfAR;
          snapshot.Invoice__c = unpaidInvoice.Id;
          snapshot.Transaction_Value__c = null;
          snapshot.Debit_Amount__c = unpaidInvoice.invoiceit_s__Total_Invoice_Value__c;
          snapshot.Transaction_Type__c = 'Invoice'; 
          snapshot.Account__c = unpaidInvoice.invoiceit_s__Account__c;
          snapshot.Statement_Date__c = closingDate;
          
          snapshotRecordsToInsert.add(snapshot);
      }

      return snapshotRecordsToInsert;
  }


  public static list<AR_Snapshot__c> populateARUnAllocatedPayments(list<invoiceit_s__Payment__c> unAllocatedPayments, string nameOfAR, date closingDate) {
    list<AR_Snapshot__c> snapshotRecordsToInsert = new list<AR_Snapshot__c>();  
    AR_Snapshot__c snapshot;

    for(invoiceit_s__Payment__c payment : unAllocatedPayments) {
            snapshot = new AR_Snapshot__c();
            snapshot.Name = nameOfAR;
            snapshot.Payment__c = payment.Id;
            snapshot.Transaction_Value__c = payment.invoiceit_s__Amount__c * (-1);
            snapshot.Debit_Amount__c = null;
            snapshot.Transaction_Type__c = 'Payment'; 
            snapshot.Account__c = payment.invoiceit_s__Account__c;
            snapshot.Statement_Date__c = closingDate;
            
            snapshotRecordsToInsert.add(snapshot);
        }

        return snapshotRecordsToInsert;
  }
  
  public static list<AR_Snapshot__c> populateCreditNotes(list<invoiceit_s__Credit_Note__c> creditNotes, string nameOfAR, date closingDate) {

    list<AR_Snapshot__c> snapshotRecordsToInsert = new list<AR_Snapshot__c>();  
    AR_Snapshot__c snapshot;

    for(invoiceit_s__Credit_Note__c creditNote : creditNotes) {
          
          snapshot = new AR_Snapshot__c();
          snapshot.Name = nameOfAR;
          snapshot.Credit_Note__c = creditNote.Id;
          snapshot.Transaction_Value__c = creditNote.invoiceit_s__Total_Credit_Note_Value__c * (-1);
          snapshot.Debit_Amount__c = null;
          snapshot.Transaction_Type__c = 'Credit Note'; 
          snapshot.Account__c = creditNote.invoiceit_s__Account__c;
          snapshot.Statement_Date__c = closingDate;
               
          snapshotRecordsToInsert.add(snapshot);
      }

      return snapshotRecordsToInsert;
  }
  
  public static list<AR_Snapshot__c> populateRefunds(list<invoiceit_s__Refund__c> refunds, string nameOfAR, date closingDate) {

    list<AR_Snapshot__c> snapshotRecordsToInsert = new list<AR_Snapshot__c>();  
    AR_Snapshot__c snapshot;

    for(invoiceit_s__Refund__c refund : refunds) {
          snapshot = new AR_Snapshot__c();
          snapshot.Name = nameOfAR;
          snapshot.Refund__c = refund.Id;
          snapshot.Transaction_Value__c = null;
          snapshot.Debit_Amount__c = refund.invoiceit_s__Refund_Amount__c;
          snapshot.Transaction_Type__c = 'Refund'; 
          snapshot.Account__c = refund.invoiceit_s__Account__c;
          snapshot.Statement_Date__c = closingDate;
          
          snapshotRecordsToInsert.add(snapshot);
      }

      return snapshotRecordsToInsert;
  }
}