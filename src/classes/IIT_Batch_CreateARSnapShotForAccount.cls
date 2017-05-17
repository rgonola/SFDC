global class IIT_Batch_CreateARSnapShotForAccount implements Database.Batchable<sObject>, Database.Stateful {

    global Database.querylocator start(Database.BatchableContext BC) {       
        return Database.getQueryLocator([SELECT NAME,Outstanding_Balance__c,(SELECT name FROM AR_Snapshots__r where Process_Date__c != null AND Process_Date__c =: system.today())
        FROM Account WHERE Outstanding_Balance__c != 0]);
        
        //return Database.getQueryLocator([SELECT NAME,(SELECT name FROM AR_Snapshots__r where Process_Date__c != null AND Process_Date__c =: system.today())
        //FROM Account WHERE Outstanding_Balance__c != 0 AND (id = '001M000000sd8k4' or id = '001M000000q3goO')]);
         
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
       
       list<AR_Snapshot__c> listOfSanpShots = new list<AR_Snapshot__c>();

       map<string, decimal> mapAmounts = new map<string, decimal>{'0-30'=> 0.00, 
        '31-60'=> 0.00, '61-90' => 0.00, '91-120'=> 0.00, '>120'=> 0.00, '0-90' => 0.00,
        '91-180' => 0.00, '181-270'=> 0.00, '271-360'=> 0.00, '>360' => 0.00};
        
      list<aggregateresult>  invoiceAggResult = [SELECT sum(Unpaid_Amount_0_30_Days__c) first1,sum(Unpaid_Amount_31_60_Days__c) second,
                                               sum(Unpaid_Amount_61_90_Days__c) third,
                                               sum(Unpaid_Amount_91_120_Days__c) fourth,sum(Unpaid_Amount_120_Days__c) fifth,
                                               sum(Unpaid_Amount_0_90_Days__c) sixth,
                                               sum(Unpaid_Amount_91_180_Days__c) seventh,sum(Unpaid_Amount_181_270_Days__c) eight,
                                               sum(Unpaid_Amount_271_360_Days__c) ninth,
                                               sum(Unpaid_Amount_360_Days__c) tenth 
                                                ,invoiceit_s__Account__c Account 
                                                FROM invoiceit_s__Invoice__c
                                                WHERE invoiceit_s__Invoice_Status__c = 'Posted' 
                                                AND 
                                                invoiceit_s__Unpaid_Amount__c != 0 
                                                //AND 
                                                //invoiceit_s__Invoice_Date__c <=: system.today()
                                                AND
                                                invoiceit_s__Account__c IN: scope
                                                Group By invoiceit_s__Account__c
                                                ];
    
        list<aggregateresult> paymentAggResult = [SELECT sum(UnAllocated_Amount_0_30_Days__c) first1,sum(UnAllocated_Amount_31_60_Days__c) second,
                                               sum(UnAllocated_Amount_61_90_Days__c) third,
                                               sum(UnAllocated_Amount_91_120_Days__c) fourth,sum(UnAllocated_Amount_120_Days__c) fifth,
                                               sum(UnAllocated_Amount_0_90_Days__c) sixth,
                                               sum(UnAllocated_Amount_91_180_Days__c) seventh,sum(UnAllocated_Amount_181_270_Days__c) eight,
                                               sum(UnAllocated_Amount_271_360_Days__c) ninth,
                                               sum(UnAllocated_Amount_360_Days__c) tenth  ,invoiceit_s__Account__c Account   
                                                
                                                FROM invoiceit_s__Payment__c
                                                WHERE invoiceit_s__Status__c = 'Completed'
                                                 AND 
                                                 invoiceit_s__Unallocated_Amount__c != 0 
                                                 //AND 
                                                 //invoiceit_s__Payment_Date__c <=: system.today()
                                                 AND
                                                 invoiceit_s__Account__c IN: scope
                                                 Group By invoiceit_s__Account__c
                                                ];


        for(aggregateresult agg : invoiceAggResult){
            mapAmounts.put('0-30'+'_' + ((id)agg.get('Account')), ((decimal)agg.get('first1')).setscale(2));
            mapAmounts.put('31-60' +'_'+ ((id)agg.get('Account')), ((decimal)agg.get('second')).setscale(2));
            mapAmounts.put('61-90' +'_'+ ((id)agg.get('Account')), ((decimal)agg.get('third')).setscale(2));
            mapAmounts.put('91-120'+'_' + ((id)agg.get('Account')), ((decimal)agg.get('fourth')).setscale(2));
            mapAmounts.put('>120' +'_'+ ((id)agg.get('Account')), ((decimal)agg.get('fifth')).setscale(2));
            mapAmounts.put('0-90' +'_'+ ((id)agg.get('Account')), ((decimal)agg.get('sixth')).setscale(2));
            mapAmounts.put('91-180' +'_'+ ((id)agg.get('Account')), ((decimal)agg.get('seventh')).setscale(2));
            mapAmounts.put('181-270' +'_'+ ((id)agg.get('Account')), ((decimal)agg.get('eight')).setscale(2));
            mapAmounts.put('271-360' +'_'+ ((id)agg.get('Account')), ((decimal)agg.get('ninth')).setscale(2));
            mapAmounts.put('>360' +'_'+ ((id)agg.get('Account')), ((decimal)agg.get('tenth')).setscale(2));
        }    



       for(aggregateresult agg : paymentAggResult){
            decimal sSum = 0;
            
            if(mapAmounts.containskey('0-30'+'_' +(id)agg.get('Account'))){
                sSum = ((decimal)agg.get('first1')).setscale(2);
                sSum = mapAmounts.get('0-30'+'_' +(id)agg.get('Account')) - sSum;
                mapAmounts.put('0-30'+'_'+((id)agg.get('Account')), sSum);
            } else  {
                sSum = ((decimal)agg.get('first1')).setscale(2);
                mapAmounts.put('0-30'+'_'+((id)agg.get('Account')), -sSum);    
            }

            if(mapAmounts.containskey('31-60'+'_' +(id)agg.get('Account'))){
                sSum = ((decimal)agg.get('second')).setscale(2);
                sSum = mapAmounts.get('31-60'+'_' +(id)agg.get('Account')) - sSum;
                mapAmounts.put('31-60'+'_'+((id)agg.get('Account')), sSum);
            } else  {
                sSum = ((decimal)agg.get('second')).setscale(2);
                mapAmounts.put('31-60'+'_'+((id)agg.get('Account')), -sSum);    
            }

            if(mapAmounts.containskey('61-90'+'_' +(id)agg.get('Account'))){
                sSum = ((decimal)agg.get('third')).setscale(2);
                sSum = mapAmounts.get('61-90'+'_' +(id)agg.get('Account')) -  sSum;
                mapAmounts.put('61-90'+'_'+((id)agg.get('Account')), sSum);
            } else  {
                sSum = ((decimal)agg.get('third')).setscale(2);
                mapAmounts.put('61-90'+'_'+((id)agg.get('Account')), -sSum);    
            }

            if(mapAmounts.containskey('91-120'+'_' +(id)agg.get('Account'))){
                sSum = ((decimal)agg.get('fourth')).setscale(2);
                sSum = mapAmounts.get('91-120'+'_' +(id)agg.get('Account')) - sSum;
                mapAmounts.put('91-120'+'_'+ ((id)agg.get('Account')), sSum);
            } else  {
                sSum = ((decimal)agg.get('fourth')).setscale(2);
                mapAmounts.put('91-120'+'_'+((id)agg.get('Account')), -sSum);    
            }

            if(mapAmounts.containskey('>120'+'_' +(id)agg.get('Account'))){
                sSum = ((decimal)agg.get('fifth')).setscale(2);
                sSum = mapAmounts.get('>120'+'_' +(id)agg.get('Account')) - sSum;
                mapAmounts.put('>120'+'_'+ ((id)agg.get('Account')), sSum);
            } else  {
                sSum = ((decimal)agg.get('fifth')).setscale(2);
                mapAmounts.put('>120'+'_'+((id)agg.get('Account')), -sSum);    
            }

            if(mapAmounts.containskey('0-90'+'_' +(id)agg.get('Account'))){
                sSum = ((decimal)agg.get('sixth')).setscale(2);
                sSum =  mapAmounts.get('0-90'+'_' +(id)agg.get('Account')) - sSum;
                mapAmounts.put('0-90'+'_'+ ((id)agg.get('Account')), sSum);
            } else  {
                sSum = ((decimal)agg.get('sixth')).setscale(2);
                mapAmounts.put('0-90'+'_'+((id)agg.get('Account')), -sSum);    
            }

            if(mapAmounts.containskey('91-180'+'_' +(id)agg.get('Account'))){
                sSum = ((decimal)agg.get('seventh')).setscale(2);
                sSum = mapAmounts.get('91-180'+'_' +(id)agg.get('Account')) - sSum;
                mapAmounts.put('91-180'+'_'+ ((id)agg.get('Account')), sSum);
            } else  {
                sSum = ((decimal)agg.get('seventh')).setscale(2);
                mapAmounts.put('91-180'+'_'+((id)agg.get('Account')), -sSum);    
            }

            if(mapAmounts.containskey('181-270'+'_' +(id)agg.get('Account'))){
                sSum = ((decimal)agg.get('eight')).setscale(2);
                sSum = mapAmounts.get('181-270'+'_' +(id)agg.get('Account')) - sSum;
                mapAmounts.put('181-270'+'_'+ ((id)agg.get('Account')), sSum);
            } else  {
                sSum = ((decimal)agg.get('eight')).setscale(2);
                mapAmounts.put('181-270'+'_'+((id)agg.get('Account')), -sSum);    
            }

            if(mapAmounts.containskey('271-360'+'_' +(id)agg.get('Account'))){
                sSum = ((decimal)agg.get('ninth')).setscale(2);
                sSum =  mapAmounts.get('271-360'+'_' +(id)agg.get('Account')) - sSum;
                mapAmounts.put('271-360'+'_'+ ((id)agg.get('Account')), sSum);
            } else  {
                sSum = ((decimal)agg.get('ninth')).setscale(2);
                mapAmounts.put('271-360'+'_'+((id)agg.get('Account')), -sSum);    
            }

            if(mapAmounts.containskey('>360'+'_' +(id)agg.get('Account'))){
                sSum = ((decimal)agg.get('tenth')).setscale(2);
                sSum =  mapAmounts.get('>360'+'_' +(id)agg.get('Account')) - sSum;
                mapAmounts.put('>360'+'_'+ ((id)agg.get('Account')), sSum);
            } else  {
                sSum = ((decimal)agg.get('tenth')).setscale(2);
                mapAmounts.put('>360'+'_'+((id)agg.get('Account')), -sSum);    
            }

        }
        
        list<AR_Snapshot__c> lstTodelete = new list<AR_Snapshot__c>();
        for(Account acc : scope){
            if(acc.AR_Snapshots__r.size() > 0){
             lstTodelete.addall(acc.AR_Snapshots__r);
            }
            
            AR_Snapshot__c snapshot = new AR_Snapshot__c();
            snapshot.name = string.ValueOf(system.now());
            snapshot.Account__c = acc.id;
            snapshot.Process_Date__c = system.today();
            snapshot.Account_Outstanding_Balance__c = acc.Outstanding_Balance__c;

            if(mapAmounts.containskey('0-30'+'_' +acc.id)){
                 snapshot.UnAllocated_Amount_0_30_Days__c = mapAmounts.get('0-30'+'_'+acc.id);
            }

            if(mapAmounts.containskey('31-60'+'_' +acc.id)){
                 snapshot.UnAllocated_Amount_31_60_Days__c = mapAmounts.get('31-60'+'_'+acc.id);
            }

            if(mapAmounts.containskey('61-90'+'_' +acc.id)){
                 snapshot.UnAllocated_Amount_61_90_Days__c = mapAmounts.get('61-90'+'_'+acc.id);
            }

            if(mapAmounts.containskey('91-120'+'_' +acc.id)){
                 snapshot.UnAllocated_Amount_91_120_Days__c = mapAmounts.get('91-120'+'_'+acc.id);
            }

            if(mapAmounts.containskey('>120'+'_' +acc.id)){
                 snapshot.UnAllocated_Amount_120_Days__c = mapAmounts.get('>120'+'_'+acc.id);
            }

            if(mapAmounts.containskey('0-90'+'_' +acc.id)){
                 snapshot.UnAllocated_Amount_0_90_Days__c = mapAmounts.get('0-90'+'_'+acc.id);
            }

            if(mapAmounts.containskey('91-180'+'_' +acc.id)){
                 snapshot.UnAllocated_Amount_91_180_Days__c = mapAmounts.get('91-180'+'_'+acc.id);
            }

            if(mapAmounts.containskey('181-270'+'_' +acc.id)){
                 snapshot.UnAllocated_Amount_181_270_Days__c = mapAmounts.get('181-270'+'_'+acc.id);
            }

            if(mapAmounts.containskey('271-360'+'_' +acc.id)){
                 snapshot.UnAllocated_Amount_271_360_Days__c = mapAmounts.get('271-360'+'_'+acc.id);
            }

            if(mapAmounts.containskey('>360'+'_' +acc.id)){
                 snapshot.UnAllocated_Amount_360_Days__c = mapAmounts.get('>360'+'_'+acc.id);
            }

            listOfSanpShots.add(snapshot);
        }
         
         
        
        // some times there will be exiting AR records where it has been created and after some time if they re-run & account balance is zero then some AR records are not deleted.
        list<AR_Snapshot__c> lstTodeleteWhereAccount = [SELECT Name 
                                                        FROM AR_Snapshot__c 
                                                        WHERE Process_Date__c != null 
                                                        AND 
                                                        Process_Date__c =: system.today()
                                                        AND
                                                        Account__r.Outstanding_Balance__c = 0
                                                        LIMIT 2000
                                                        ];
        lstTodelete.addAll(lstTodeleteWhereAccount);
                                                        
        // delete the existing ar snapshots records present for a day
        delete lstTodelete;
        
        // insert the new ar snapshots records present for a day
        insert listOfSanpShots;
    }


    global void finish(Database.BatchableContext BC){  }
    
    
}