global with sharing class IIT_CustomerStatements {
    public invoiceit_s__Invoice__c invoice {get; set;}
    Id accountId;
    
    public IIT_CustomerStatements(ApexPages.StandardController controller) {
       accountId = (Id) controller.getId();   
    }
    
    @RemoteAction
    global static ResponseClass generateStatementByDatesJS(string accountId, string sstartDate, string sendDate) {
        system.debug('start date : ' + sstartDate);
        system.debug('start date : ' + sendDate);
        ResponseClass responseClass = new ResponseClass();
        
        if(sstartDate == null || sstartDate == '' || sendDate == null || sendDate == '') {
            responseClass.message = 'Start Date/End Date cannot be blank';
            return responseClass;
        }
        
        String[] firstdate = sstartDate.split('/');
        String[] seconddate = sendDate.split('/');
        
        Date startDate = Date.newInstance(integer.ValueOf(firstdate[2]), integer.ValueOf(firstdate[0]), integer.ValueOf(firstdate[1]));
        Date endDate = Date.newInstance(integer.ValueOf(seconddate[2]), integer.ValueOf(seconddate[0]), integer.ValueOf(seconddate[1]));
        
        system.debug('startDate is ' + startDate);
        system.debug('endDate is ' + endDate);
        
        //Date startDate = Date.newInstance(integer.ValueOf(sstartDate.substring(0,4)), integer.ValueOf(sstartDate.substring(5,7)), integer.ValueOf(sstartDate.substring(8,10)));
        //Date endDate = Date.newInstance(integer.ValueOf(sendDate.substring(0,4)), integer.ValueOf(sendDate.substring(5,7)), integer.ValueOf(sendDate.substring(8,10)));
        
        list<invoiceit_s__Invoice__c> unpaidInvoices;
        list<invoiceit_s__Payment__c> unAllocatedPayments;
        list<invoiceit_s__Credit_Note__c> creditNotes;
        list< invoiceit_s__Refund__c> refunds;
        
        list<AR_Snapshot__c> snapshotRecordsToInsert = new list<AR_Snapshot__c>();
        string arRecordName;
        date todaysDate = system.today();
        
        try {
                Account acc = [SELECT Outstanding_Balance__c
                               FROM Account
                               WHERE Id =: accountId
                              ];
                              
                arRecordName = string.ValueOf(system.now());
                unpaidInvoices = [SELECT invoiceit_s__Invoice_Date__c,
                                  invoiceit_s__Account__c, invoiceit_s__Paid_Amount__c,invoiceit_s__Total_Invoice_Value__c,invoiceit_s__Unpaid_Amount__c,Unpaid_Amount_0_30_Days__c,Unpaid_Amount_31_60_Days__c,Unpaid_Amount_61_90_Days__c,Unpaid_Amount_91_120_Days__c,Unpaid_Amount_120_Days__c 
                                  FROM invoiceit_s__Invoice__c 
                                  WHERE (invoiceit_s__Invoice_Status__c = 'Posted' OR (invoiceit_s__Invoice_Status__c = 'Cancelled' AND invoiceit_s__Credited_Amount__c > 0))
                                  AND 
                                  invoiceit_s__Invoice_Date__c >=: startDate
                                  AND
                                  invoiceit_s__Invoice_Date__c <=: endDate
                                  AND
                                  invoiceit_s__Account__c =: accountId 
                                ];

                unAllocatedPayments = [SELECT invoiceit_s__Account__c, invoiceit_s__Allocated_Amount__c, invoiceit_s__Amount__c,invoiceit_s__Payment_Date__c,invoiceit_s__Status__c, invoiceit_s__Unallocated_Amount__c, UnAllocated_Amount_0_30_Days__c, UnAllocated_Amount_31_60_Days__c, UnAllocated_Amount_61_90_Days__c, UnAllocated_Amount_91_120_Days__c, invoiceit_s__Refunded_Amount__c 
                                         FROM invoiceit_s__Payment__c 
                                         WHERE (invoiceit_s__Status__c = 'Completed' OR (invoiceit_s__Status__c = 'Cancelled' AND invoiceit_s__Refunded_Amount__c > 0))
                                         AND 
                                         invoiceit_s__Payment_Date__c >=: startDate
                                         AND
                                         invoiceit_s__Payment_Date__c <=: endDate
                                         AND
                                         invoiceit_s__Account__c =: accountId
                                        ];
                
                creditNotes = [SELECT invoiceit_s__Account__c, invoiceit_s__Total_Credit_Note_Value__c, invoiceit_s__Amount__c, Name
                               FROM invoiceit_s__Credit_Note__c
                               WHERE 
                               invoiceit_s__Credit_Note_Date__c >=: startDate
                               AND
                               invoiceit_s__Credit_Note_Date__c <=: endDate
                               AND
                               invoiceit_s__Account__c =: accountId
                               ];
                
                refunds = [SELECT invoiceit_s__Account__c, invoiceit_s__Refund_Amount__c, invoiceit_s__Status__c, Name
                           FROM invoiceit_s__Refund__c
                           WHERE 
                           invoiceit_s__Refund_Date__c >=: startDate
                           AND
                           invoiceit_s__Refund_Date__c <=: endDate
                           AND
                           invoiceit_s__Account__c =: accountId
                           ];
                
                // get the UnPaidInvoices
                snapshotRecordsToInsert = IITARUtilClass.populateARUnpaidInvoices(unpaidInvoices, arRecordName, system.today()); 
                
                // get the UnAllocatedPayments
                snapshotRecordsToInsert.addALL(IITARUtilClass.populateARUnAllocatedPayments(unAllocatedPayments, arRecordName, system.today()));
                
                // get the UnAllocatedPayments
                snapshotRecordsToInsert.addALL(IITARUtilClass.populateCreditNotes(creditNotes, arRecordName, system.today()));
                
                // get the UnAllocatedPayments
                snapshotRecordsToInsert.addALL(IITARUtilClass.populateRefunds(refunds, arRecordName, system.today()));
                
                // insert the data invoices and payments
                insert snapshotRecordsToInsert;
                
                // we need to populate the customer balance
                list<AggregateResult> invsAmount;
                list<AggregateResult> paymentsAmount;
                list<AggregateResult> creditNotesAmount;
                list<AggregateResult> refundsAmount;
                decimal invoicesSum, paymentsSum, creditNoteSum, refundSum;
                
                invsAmount = [SELECT SUM(invoiceit_s__Total_Invoice_Value__c) invoicesSum
                              FROM invoiceit_s__Invoice__c 
                              WHERE (invoiceit_s__Invoice_Status__c = 'Posted' OR (invoiceit_s__Invoice_Status__c = 'Cancelled' AND invoiceit_s__Credited_Amount__c > 0))
                              AND 
                              invoiceit_s__Invoice_Date__c <: startDate
                              AND
                              invoiceit_s__Account__c =: accountId 
                            ];
                
                paymentsAmount = [SELECT Sum(invoiceit_s__Amount__c) paymentsSum
                                     FROM invoiceit_s__Payment__c 
                                     WHERE invoiceit_s__Status__c = 'Completed'
                                     AND 
                                     invoiceit_s__Payment_Date__c <: startDate
                                     AND
                                     invoiceit_s__Account__c =: accountId
                                    ];
                
                creditNotesAmount = [SELECT SUM(invoiceit_s__Total_Credit_Note_Value__c) creditNoteSum
                                     FROM invoiceit_s__Credit_Note__c
                                     WHERE 
                                     invoiceit_s__Credit_Note_Date__c <: startDate
                                     AND
                                     invoiceit_s__Account__c =: accountId
                                     ];
                
                refundsAmount = [SELECT SUM(invoiceit_s__Refund_Amount__c) refundSum
                                   FROM invoiceit_s__Refund__c
                                   WHERE 
                                   invoiceit_s__Refund_Date__c <: startDate
                                   AND
                                   invoiceit_s__Account__c =: accountId
                                   ];
                
                invoicesSum = (decimal) invsAmount.get(0).get('invoicesSum');
                paymentsSum = (decimal) paymentsAmount.get(0).get('paymentsSum');
                creditNoteSum = (decimal) creditNotesAmount.get(0).get('creditNoteSum');
                refundSum = (decimal) refundsAmount.get(0).get('refundSum');
                
                if(invoicesSum == null) {
                    invoicesSum = 0.00;
                }
                if(paymentsSum == null) {
                    paymentsSum = 0.00;
                }
                if(creditNoteSum == null) {
                    creditNoteSum = 0.00;
                }
                if(refundSum == null) {
                    refundSum = 0.00;
                }
                               
                // query the insert ones add the balance by OrderBy
                list<AR_Snapshot__c> snapshotRecordsToUpdate = [SELECT Name, Transaction_Date__c, Transaction_Name__c, Transaction_Type__c, Transaction_Value__c, Statement_Date__c, Balance_Amount__c, Debit_Amount__c, Invoice__c, Refund__c  
                                                                FROM AR_Snapshot__c 
                                                                WHERE Id IN: snapshotRecordsToInsert 
                                                                ORDER BY Transaction_Date__c];
                
                system.debug('snapshotRecordsToUpdate ' + snapshotRecordsToUpdate.size());
                system.debug('invoicesSum ' + invoicesSum);
                system.debug('paymentsSum' + paymentsSum);
                system.debug('creditNoteSum' + creditNoteSum);
                system.debug('refundSum' + refundSum);
                decimal previousBalance = invoicesSum - paymentsSum - creditNoteSum + refundSum;
                
                // populate the balance
                AR_Snapshot__c arBalance = new AR_Snapshot__c(Account__c = accountId, Transaction_Type__c = 'BALANCE FORWARD', Balance_Amount__c = previousBalance, Name = arRecordName, Sequence_No__c = 0, Statement_Start_Date__c =startDate, Statement_End_Date__c =endDate, Account_Outstanding_Balance__c = acc.Outstanding_Balance__c);
                
                
                system.debug('previousBalance ' + previousBalance);
                decimal Sequence = 1;
                for(AR_Snapshot__c ar : snapshotRecordsToUpdate) {
                    system.debug('previousBalance ' + ar);
                    
                    decimal amount = 0;
                    if(ar.Invoice__c != null || ar.Refund__c != null) {
                        amount = ar.Debit_Amount__c;
                    } else {
                        amount = ar.Transaction_Value__c;
                    }
                    
                    if(amount == null) {
                        amount = 0;
                    }
                    
                    ar.Balance_Amount__c = previousBalance + amount;   
                    previousBalance = ar.Balance_Amount__c;
                    ar.Sequence_No__c = Sequence;
                    ++Sequence;
                    system.debug('Sequence ' + Sequence);
                }
                
                snapshotRecordsToUpdate.add(arBalance);
                upsert snapshotRecordsToUpdate;
                
                responseClass.message = 'success';
                responseClass.snapshotName = arRecordName;
                system.debug('arRecordName == ' + arRecordName);
                return responseClass;
            } catch(exception ex) {
                system.debug('exception getMessage is : ' + ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString() );
                
                responseClass.message = 'An exception has occured, exception type is ' + ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString();
                return responseClass;
        }

        return responseClass;
    }

    // global class used as reponse for JS
    global class ResponseClass {
        global string message;
        global string snapshotName;
    }
    
     public PageReference processARreportByAcc(){   
        IIT_Batch_CreateARSnapShotForAccount batch_CreateARSnapShotForAccount = new IIT_Batch_CreateARSnapShotForAccount();  
        Id batchId = database.executebatch(batch_CreateARSnapShotForAccount);
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Confirm, 'Batch process has started'));
        return null;        
      }

}