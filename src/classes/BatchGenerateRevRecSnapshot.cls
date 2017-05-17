/*
    Date startDate = Date.newInstance(2015, 1, 1);
    Date endDate = Date.newInstance(2015, 6, 30);
    BatchGenerateRevRecSnapshot b = new BatchGenerateRevRecSnapshot('a3mM0000000Csa6', startDate, endDate, 'a2GM0000003iqHq');
    Database.ExecuteBatch(b);
    
    
*/

global class BatchGenerateRevRecSnapshot implements Database.Batchable<sObject>, Database.Stateful {
    
    String query;
    global Id snapshotId;
    global Date startDate = null;
    global Date endDate = null;
    global Id currencyId;
    global boolean isCreditNote;
    map<Id,Revenue_Recognition_Snapshot_Line__c> mapInvoiceLineAndRevRecSnapshot = new map<Id,Revenue_Recognition_Snapshot_Line__c>();

    global BatchGenerateRevRecSnapshot(Id snapshotId, Date startDate, Date endDate, Id currencyId, boolean isCreditNote) {
        system.debug('In here');
        this.snapshotId = snapshotId;
        this.currencyId = currencyId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isCreditNote = isCreditNote;

        if(isCreditNote == false) {
            // if isCreditNote is false, execute the invoice line query
            //this.query =    'select id from invoiceit_s__Invoice_Lines__c where'+
            //                ' invoiceit_s__Revenue_Recognition_Rule__c != null AND Id = \'' + 'a2Q290000004jcd' + '\'';
                            
            this.query =    'select id from invoiceit_s__Invoice_Lines__c where'+
                            ' invoiceit_s__Revenue_Recognition_Rule__c != null';
        } else {
            //this.query =    'select id from invoiceit_s__Credit_Line__c where'+
            //                ' invoiceit_s__Revenue_Recognition_Rule__c != null AND Id = \'' + 'a2Q290000004jcd' + '\'';
                            
            this.query =    'select id from invoiceit_s__Credit_Line__c where'+
                            ' invoiceit_s__Revenue_Recognition_Rule__c != null';                
        }
                        
        /*this.query =  'select id from invoiceit_s__Revenue_Transaction__c'+
                        ' where invoiceit_s__Revenue_Period_Start_Date__c >= '+startDate.year()+'-'+startDate.month()+'-'+startDate.day()+
                        ' and invoiceit_s__Revenue_Period_Start_Date__c < '+endDate.year()+'-'+endDate.month()+'-'+endDate.day();
        */

        system.debug('In here ='+query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('In start');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        system.debug('In execute');
        list<Id> listofinvoicelineids = new list<Id>();
        

        for (sObject s : scope) {
            listofinvoicelineids.add(s.Id);
        }

        //Get all the revenue transactions for the invoice lines
        invoiceit_s__Revenue_Transaction__c[] listOfRevenueTransactions;
        
        if(isCreditNote == false) {
            // if isCreditNote is false, execute the invoice line query
            listOfRevenueTransactions = [select Id, Name, invoiceit_s__Account__c, invoiceit_s__Revenue_Period__c, invoiceit_s__Credit_Line__c, 
                                            invoiceit_s__Credit_Note__c, invoiceit_s__CurrencyL__c, invoiceit_s__Deferred_Balance__c, invoiceit_s__Invoice_Line__c, 
                                            invoiceit_s__Invoice__c, invoiceit_s__Order_Rate_Plan_Charge__c, invoiceit_s__Order__c, 
                                            invoiceit_s__Recognised_Revenue__c, invoiceit_s__Revenue_Amount__c, invoiceit_s__Revenue_Period_End_Date__c, 
                                            invoiceit_s__Revenue_Period_Start_Date__c from invoiceit_s__Revenue_Transaction__c 
                                            where invoiceit_s__Revenue_Period_Start_Date__c >= :startDate
                                            and invoiceit_s__Revenue_Period_End_Date__c <= :endDate
                                            and invoiceit_s__Invoice_Line__c IN :listofinvoicelineids
                                            ORDER BY invoiceit_s__Revenue_Period_Start_Date__c, Name];
        } else {
           // if isCreditNote is false, execute the invoice line query
            listOfRevenueTransactions = [select Id, Name, invoiceit_s__Account__c, invoiceit_s__Revenue_Period__c, invoiceit_s__Credit_Line__c, 
                                            invoiceit_s__Credit_Note__c, invoiceit_s__CurrencyL__c, invoiceit_s__Deferred_Balance__c, invoiceit_s__Invoice_Line__c, 
                                            invoiceit_s__Invoice__c, invoiceit_s__Order_Rate_Plan_Charge__c, invoiceit_s__Order__c, 
                                            invoiceit_s__Recognised_Revenue__c, invoiceit_s__Revenue_Amount__c, invoiceit_s__Revenue_Period_End_Date__c, 
                                            invoiceit_s__Revenue_Period_Start_Date__c,
                                            invoiceit_s__Credit_Line__r.invoiceit_s__Invoice_Line__c,
                                            invoiceit_s__Credit_Line__r.invoiceit_s__Invoice__c
                                            from invoiceit_s__Revenue_Transaction__c 
                                            where invoiceit_s__Revenue_Period_Start_Date__c >= :startDate
                                            and invoiceit_s__Revenue_Period_End_Date__c <= :endDate
                                            and invoiceit_s__Credit_Line__c IN :listofinvoicelineids
                                            ORDER BY invoiceit_s__Revenue_Period_Start_Date__c, Name]; 
        }

        system.debug('listOfRevenueTransactions ='+listOfRevenueTransactions);
        system.debug('listOfRevenueTransactions size ='+listOfRevenueTransactions.size());


        Date startDate1 = this.startDate;
        Date endDate1 = startDate1.addMonths(1).addDays(-1);
        
        Date startDate2 = startDate1.addMonths(1);
        Date endDate2 = startDate2.addMonths(1).addDays(-1);

        Date startDate3 = startDate2.addMonths(1);
        Date endDate3 = startDate3.addMonths(1).addDays(-1);

        Date startDate4 = startDate3.addMonths(1);
        Date endDate4 = startDate4.addMonths(1).addDays(-1);

        Date startDate5 = startDate4.addMonths(1);
        Date endDate5 = startDate5.addMonths(1).addDays(-1);

        Date startDate6 = startDate5.addMonths(1);
        Date endDate6 = startDate6.addMonths(1).addDays(-1);

        Date startDate7 = startDate6.addMonths(1);
        Date endDate7 = startDate7.addMonths(1).addDays(-1);

        Date startDate8 = startDate7.addMonths(1);
        Date endDate8 = startDate8.addMonths(1).addDays(-1);

        Date startDate9 = startDate8.addMonths(1);
        Date endDate9 = startDate9.addMonths(1).addDays(-1);

        Date startDate10 = startDate9.addMonths(1);
        Date endDate10 = startDate10.addMonths(1).addDays(-1);

        Date startDate11 = startDate10.addMonths(1);
        Date endDate11 = startDate11.addMonths(1).addDays(-1);

        Date startDate12 = startDate11.addMonths(1);
        Date endDate12 = startDate12.addMonths(1).addDays(-1);  
        
        //=====After 12 months==========

        Date startDate13 = startDate12.addMonths(1);
        Date endDate13 = startDate13.addMonths(1).addDays(-1);

        Date startDate14 = startDate13.addMonths(1);
        Date endDate14 = startDate14.addMonths(1).addDays(-1);

        Date startDate15 = startDate14.addMonths(1);
        Date endDate15 = startDate15.addMonths(1).addDays(-1);

        Date startDate16 = startDate15.addMonths(1);
        Date endDate16 = startDate16.addMonths(1).addDays(-1);

        Date startDate17 = startDate16.addMonths(1);
        Date endDate17 = startDate17.addMonths(1).addDays(-1);

        Date startDate18 = startDate17.addMonths(1);
        Date endDate18 = startDate18.addMonths(1).addDays(-1);

        Date startDate19 = startDate18.addMonths(1);
        Date endDate19 = startDate19.addMonths(1).addDays(-1);

        Date startDate20 = startDate19.addMonths(1);
        Date endDate20 = startDate20.addMonths(1).addDays(-1);

        Date startDate21 = startDate20.addMonths(1);
        Date endDate21 = startDate21.addMonths(1).addDays(-1);

        Date startDate22 = startDate21.addMonths(1);
        Date endDate22 = startDate22.addMonths(1).addDays(-1);  
        
        Date startDate23 = startDate22.addMonths(1);
        Date endDate23 = startDate23.addMonths(1).addDays(-1); 
        
        Date startDate24 = startDate23.addMonths(1);
        Date endDate24 = startDate24.addMonths(1).addDays(-1); 
        
        system.debug('endDate1 ='+endDate1);
        system.debug('endDate2 ='+endDate2);
        system.debug('endDate3 ='+endDate3);
        system.debug('endDate4 ='+endDate4);
        system.debug('endDate5 ='+endDate5);
        system.debug('endDate6 ='+endDate6);
        system.debug('endDate7 ='+endDate7);
        system.debug('endDate8 ='+endDate8);
        system.debug('endDate9 ='+endDate9);
        system.debug('endDate10 ='+endDate10);    
        system.debug('endDate11 ='+endDate11);
        system.debug('endDate12 ='+endDate12);          

        for(invoiceit_s__Revenue_Transaction__c trans : listOfRevenueTransactions){
            Revenue_Recognition_Snapshot_Line__c sl;
            
            
            Id invoiceLineOrCreditNoteId;
            if(isCreditNote == false) {
                invoiceLineOrCreditNoteId = trans.invoiceit_s__Invoice_Line__c;   
            } else {
                invoiceLineOrCreditNoteId = trans.invoiceit_s__Credit_Line__c;
            }
            
            //Get the date range
            if(!mapInvoiceLineAndRevRecSnapshot.containsKey(invoiceLineOrCreditNoteId)){
                Revenue_Recognition_Snapshot_Line__c snapShot;
                snapShot = new Revenue_Recognition_Snapshot_Line__c
                                (Revenue_Recognition_Snapshot__c = snapshotId, 
                                Invoice_Line__c = trans.invoiceit_s__Invoice_Line__c,
                                Invoice__c = trans.invoiceit_s__Invoice__c,
                                Credit_Note__c = trans.invoiceit_s__Credit_Note__c,
                                Credit_Line__c = trans.invoiceit_s__Credit_Line__c,
                                Account__c = trans.invoiceit_s__Account__c,
                                Order__c = trans.invoiceit_s__Order__c,
                                Order_Rate_Plan_Charge__c = trans.invoiceit_s__Order_Rate_Plan_Charge__c,
                                // populate the Deferred_Revenue__c as full amount so that it can be overriden later
                                Deferred_Revenue__c = (trans.invoiceit_s__Revenue_Amount__c + trans.invoiceit_s__Deferred_Balance__c)
                                );
                
                if(isCreditNote == true) {
                    // populate the invoice and invoice lines   
                    snapShot.Invoice_Line__c = trans.invoiceit_s__Credit_Line__r.invoiceit_s__Invoice_Line__c;
                    snapShot.Invoice__c = trans.invoiceit_s__Credit_Line__r.invoiceit_s__Invoice__c;
                }
                
                mapInvoiceLineAndRevRecSnapshot.put(invoiceLineOrCreditNoteId, snapShot);
            }

            sl = mapInvoiceLineAndRevRecSnapshot.get(invoiceLineOrCreditNoteId);
            system.debug('sl ='+sl);
            
            
            system.debug('trans.invoiceit_s__Revenue_Period_End_Date__c ='+trans.invoiceit_s__Revenue_Period_End_Date__c);
            
            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate1){
                Decimal currentValue = sl.Month_1__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_1__c = currentValue;
                
                system.debug('trans.Name ' + trans.Name);
                system.debug('trans.Name ' + trans.invoiceit_s__Recognised_Revenue__c);
                
                // populate the def balance and reconize revenue once the date matches the first month
                sl.Recognize_Revenue__c = trans.invoiceit_s__Recognised_Revenue__c;
                
                sl.Deferred_Revenue__c = trans.invoiceit_s__Deferred_Balance__c;
            }
            
            
            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate2){
                Decimal currentValue = sl.Month_2__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_2__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate3){
                Decimal currentValue = sl.Month_3__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_3__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate4){
                Decimal currentValue = sl.Month_4__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_4__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate5){
                Decimal currentValue = sl.Month_5__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_5__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate6){
                Decimal currentValue = sl.Month_6__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_6__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate7){
                Decimal currentValue = sl.Month_7__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_7__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate8){
                Decimal currentValue = sl.Month_8__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_8__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate9){
                Decimal currentValue = sl.Month_9__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_9__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate10){
                Decimal currentValue = sl.Month_10__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_10__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate11){
                Decimal currentValue = sl.Month_11__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_11__c = currentValue;
            }
            
            system.debug(trans.invoiceit_s__Revenue_Period_End_Date__c);
            system.debug('endDate12 = ' + endDate12);
            
            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate12){
                Decimal currentValue = sl.Month_12__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_12__c = currentValue;
            }
            
            //=======
            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate13){
                Decimal currentValue = sl.Month_13__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_13__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate14){
                Decimal currentValue = sl.Month_14__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_14__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate15){
                Decimal currentValue = sl.Month_15__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_15__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate16){
                Decimal currentValue = sl.Month_16__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_16__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate17){
                Decimal currentValue = sl.Month_17__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_17__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate18){
                Decimal currentValue = sl.Month_18__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_18__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate19){
                Decimal currentValue = sl.Month_19__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_19__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate20){
                Decimal currentValue = sl.Month_20__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_20__c = currentValue;
            }

            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate21){
                Decimal currentValue = sl.Month_21__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_21__c = currentValue;
            }
            
            system.debug(trans.invoiceit_s__Revenue_Period_End_Date__c);
            system.debug('endDate12 = ' + endDate12);
            
            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate22){
                Decimal currentValue = sl.Month_22__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_22__c = currentValue;
            }
            
            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate23){
                Decimal currentValue = sl.Month_23__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_23__c = currentValue;
            }
            
            if(trans.invoiceit_s__Revenue_Period_End_Date__c == endDate24){
                Decimal currentValue = sl.Month_24__c;
                if(currentValue == null){
                    currentValue = 0;
                }
                currentValue += trans.invoiceit_s__Revenue_Amount__c;

                sl.Month_24__c = currentValue;
            }
        }
        
        // insert the records
        insert mapInvoiceLineAndRevRecSnapshot.values();
        mapInvoiceLineAndRevRecSnapshot = new map<Id,Revenue_Recognition_Snapshot_Line__c>();
    }
    
    global void finish(Database.BatchableContext BC) {
        if(isCreditNote == false) {
            
            BatchGenerateRevRecSnapshot b = new BatchGenerateRevRecSnapshot(snapshotId, startDate, endDate, currencyId, true);
            Database.ExecuteBatch(b);   
        }
    }
}