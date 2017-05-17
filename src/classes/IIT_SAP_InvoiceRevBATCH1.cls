/*
list<SAP_Integration__c> lis = [Select Id From SAP_Integration__c];
delete lis;

Date d1 = Date.newInstance(2015, 1, 1);
Date d2 = Date.newInstance(2015, 1, 31);


IIT_SAP_InvoiceRevBATCH1 IB = new IIT_SAP_InvoiceRevBATCH1(d1, d2);
database.executebatch(IB);
*/
global class IIT_SAP_InvoiceRevBATCH1 implements Database.Batchable<sObject>, Database.Stateful {
    
    String query;
    Date processedDate;
    string processedDateString;
    Date endDate;
    map<string, SAP_Integration__c> mapMaterialNoSAPID = new map<string, SAP_Integration__c>();
    map<string, SAP_Integration__c> mapMaterialNoSAPIDCredit = new map<string, SAP_Integration__c>();
    invoiceit_s__Batch_Jobs__c job;
    string excetionString;
    string sJobName;
    
    global IIT_SAP_InvoiceRevBATCH1(date processedDate, date endDate,string sJobName) {
        this.processedDate = processedDate;
        this.endDate = endDate;
        this.sJobName = sJobName;
        
        // format should be YYYYMMDD
        processedDateString = '';
        processedDateString += processedDate.year();
        
        if(processedDate.month() < 10) {
            processedDateString += '0' + processedDate.month(); 
        } else {
            processedDateString += processedDate.month();
        }
        if(processedDate.day() < 10) {
            processedDateString += '0' + processedDate.day();
        } else {
            processedDateString += processedDate.day();
        }

        // insert the batch jobs
        job = new invoiceit_s__Batch_Jobs__c();
        //job.Name = 'SAP_InvoiceRevBATCH1 ' + system.now();
        job.Name = sJobName;
        job.invoiceit_s__Type__c = 'SAP_InvoiceRevBATCH';
        job.invoiceit_s__Start_Date_and_Time__c = system.now();
        job.invoiceit_s__Status__c = 'Processing';
        insert job;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // this query will pick the revenue trasnactions based on the
        // start date, end date and SAP_Revenue_Rec__c = null
        // if the SAP_Revenue_Rec__c is populated, then we conider the record has been processed previously
        query = 'SELECT ID, invoiceit_s__Invoice_Line__r.Material_Number1__c, invoiceit_s__Credit_Line__r.Material_Number1__c, ';
        query = query + 'invoiceit_s__Revenue_Amount__c, invoiceit_s__Credit_Line__c, invoiceit_s__Invoice_Line__c ';
        query = query + 'FROM invoiceit_s__Revenue_Transaction__c ';
        query = query + 'WHERE invoiceit_s__Revenue_Period__r.invoiceit_s__Revenue_Period_Start_Date__c =: processedDate AND invoiceit_s__Revenue_Period__r.invoiceit_s__Revenue_Period_End_Date__c =: endDate AND SAP_Revenue_Rec__c = null';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        Savepoint sp;

        try {
            sp = Database.setSavePoint();
            mapMaterialNoSAPID = new map<string, SAP_Integration__c>();
            mapMaterialNoSAPIDCredit = new map<string, SAP_Integration__c>();

            list <SAP_Integration__c> alltoinsert = [Select Amount__c, Amount1__c, Document_Date__c, Document_Type__c,
                                                    GL_Account__c, Line_Description__c, Material_Code__c, Posting_Date__c,
                                                    Posting_Key__c, Record_Type__c, SAP_Processed_Date__c, State__c, Type__c
                                                    FROM SAP_Integration__c
                                                    WHERE SAP_processed_date__c =: processedDate
                                                    AND
                                                    Document_Type__c='Monthly Deferred Revenue Posting'
                                                    AND
                                                    Status__c != 'Completed'
                                                    ];

            for(SAP_Integration__c sapInt : alltoinsert) {
                // ignore the first line and D
                if(sapInt.Posting_Key__c == 'D' || sapInt.Posting_Key__c == 'US30') {
                    mapMaterialNoSAPID.put(sapInt.Material_Code__c, sapInt);
                } else {
                    mapMaterialNoSAPIDCredit.put(sapInt.Material_Code__c, sapInt);
                }
            }
            system.debug('mapMaterialNoSAPIDCredit ' + mapMaterialNoSAPIDCredit);

            if(alltoinsert.size() == 0) {
                // populate the first row
                date processedDate= processedDate;
                string todayDate = string.ValueOf(processedDate.day()) + string.ValueOf(processedDate.month()) + string.ValueOf(processedDate.year());          
                //Hardcoded first line
                SAP_Integration__c HeaderSAP= new SAP_Integration__c(Record_Type__c='1', GL_Account__c=processedDateString, Posting_Key__c='US30', Line_Description__c ='Monthly Deferred Revenue Posting', Posting_Date__c = processedDateString, Document_Type__c='Monthly Deferred Revenue Posting', Amount__c=integer.ValueOf(todayDate), Amount1__c=processedDateString,Material_Code__c ='Monthly Deferred revenue posting', State__c='USD',SAP_processed_date__c = processedDate, Type__c = 'SA');
                mapMaterialNoSAPID.put('Monthly Deferred revenue posting', HeaderSAP);
            }
            
            //store invoicelines by material number. Use material number & State as map key.
            system.debug ('xxxxxxxxxxxxSCOPE   ' + scope); 
            
            //SAP_Revenue_Rec
            string myMNum='None';
            list<invoiceit_s__Revenue_Transaction__c> transactions = scope;
            for(invoiceit_s__Revenue_Transaction__c rt : transactions) {
                myMNum='None';
                //check if it's a invoiceLine or creditLine
                if(rt.invoiceit_s__Credit_Line__c != null) {                
                    if(rt.invoiceit_s__Credit_Line__r.Material_Number1__c <>null) myMNum=rt.invoiceit_s__Credit_Line__r.Material_Number1__c;               
                    
                } else {
                    if(rt.invoiceit_s__Invoice_Line__r.Material_Number1__c <>null) myMNum=rt.invoiceit_s__Invoice_Line__r.Material_Number1__c; 
                
                }

                if(myMNum == '' || myMNum == null) {
                    myMNum = 'None';
                }

                system.debug ('myMNum  ' +myMNum);
                SAP_Integration__c sapRecord;
                if(mapMaterialNoSAPID.containsKey(myMNum)) {
                    sapRecord = mapMaterialNoSAPID.get(myMNum);
                    sapRecord.Amount__c = sapRecord.Amount__c + rt.invoiceit_s__Revenue_Amount__c;
                    sapRecord.Amount__c = sapRecord.Amount__c.setScale(2);
                    sapRecord.Amount1__c = string.ValueOf(sapRecord.Amount__c);
                } else {
                    sapRecord = new SAP_Integration__c(Record_Type__c='2', GL_Account__c='13110200', Posting_Key__c='D', Line_Description__c ='Monthly Deferred Revenue Posting', Posting_Date__c =string.valueof(processedDate), Document_Type__c='Monthly Deferred Revenue Posting', Amount__c=rt.invoiceit_s__Revenue_Amount__c, Amount1__c=string.ValueOf(rt.invoiceit_s__Revenue_Amount__c), Material_Code__c = myMNum,State__c =null, SAP_processed_date__c = processedDate);
                }
                mapMaterialNoSAPID.put(myMNum, sapRecord);
            }

            // upsert the SAP Records
            upsert mapMaterialNoSAPID.values();

            // populate the SAP ID into transaction
            // Loop over
            for(invoiceit_s__Revenue_Transaction__c rt : transactions) {
                myMNum = 'None';
                //check if it's a invoiceLine or creditLine
                if(rt.invoiceit_s__Credit_Line__c != null) {                
                    if(rt.invoiceit_s__Credit_Line__r.Material_Number1__c <>null) 
                        myMNum=rt.invoiceit_s__Credit_Line__r.Material_Number1__c;               
                    
                } else {
                    if(rt.invoiceit_s__Invoice_Line__r.Material_Number1__c <>null) 
                        myMNum=rt.invoiceit_s__Invoice_Line__r.Material_Number1__c; 
                
                }

                if(myMNum == null || myMNum == '') {
                    myMNum = 'None';
                }

                if(mapMaterialNoSAPID.containsKey(myMNum)) {
                    rt.SAP_Revenue_Rec__c = mapMaterialNoSAPID.get(myMNum).Id;
                }
            }
            update transactions;    
        }    
        Catch(Exception ex) {
            database.rollback(sp);

            excetionString = excetionString + ' ' + ex.getMessage() + ' Line No : ' + ex.getLineNumber() + ' Stace Trace : ' + ex.getStackTraceString(); 
            job.invoiceit_s__Completed_Date_and_Time__c = system.now();
            job.invoiceit_s__Status__c = 'Completed with errors';   
            job.invoiceit_s__Exception_Log__c = excetionString;
            update job;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        // delete the existing records
        delete mapMaterialNoSAPIDCredit.values();

        system.debug('mapMaterialNoSAPID === ' + mapMaterialNoSAPID);
        for(string key : mapMaterialNoSAPID.keySet()) {
            if(key != 'Monthly Deferred revenue posting') {
                system.debug('adding === ' + mapMaterialNoSAPIDCredit);
                SAP_Integration__c oldRecord = mapMaterialNoSAPID.get(key); 
                SAP_Integration__c newRecod = oldRecord.clone(false);
                newRecod.GL_Account__c='31101001';
                newRecod.Posting_Key__c='C';
                mapMaterialNoSAPIDCredit.put(key, newRecod);

                system.debug('mapMaterialNoSAPIDCredit === ' + mapMaterialNoSAPIDCredit);
            }
        }
        // insert credit values
        insert mapMaterialNoSAPIDCredit.values();    

        job.invoiceit_s__Completed_Date_and_Time__c = system.now();
        job.invoiceit_s__Status__c = 'Completed';   
        update job;
    }   
}