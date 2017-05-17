/*
    list<SAP_Integration__c> lis = [Select Id From SAP_Integration__c];
    delete lis;
    
    Date d1 = Date.newInstance(2015, 1, 1);
    
    IIT_SAP_InvoiceBATCH1 IB = new IIT_SAP_InvoiceBATCH1(d1, 'UniQue Name Here');
    Id batchId = Database.executeBatch(IB);

*/
global class IIT_SAP_InvoiceBATCH1 implements Database.Batchable<sObject> {
    
    String query;
    invoiceit_s__Batch_Jobs__c job;
    string excetionString;
    Date processedDate;
    string processedDateString;
    map<string, SAP_Integration__c> mapMaterialNoSAPID = new map<string, SAP_Integration__c>();
    string sJobName;

    global IIT_SAP_InvoiceBATCH1(date processedDate,string sJobName) {
        this.processedDate = processedDate;
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
        job.Name = sJobName;
        job.invoiceit_s__Type__c = 'SAP_InvoiceRevBATCH';
        job.invoiceit_s__Start_Date_and_Time__c = system.now();
        job.invoiceit_s__Status__c = 'Processing';
        insert job; 
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query = 'SELECT  invoiceit_s__Invoice__r.Id , SAP_Total_Amount__c, Material_Number1__c ,invoiceit_s__Product_Name__c, invoiceit_s__Total_Line_Amount__c, invoiceit_s__Invoice__r.invoiceit_s__Account__r.ShippingState ';
        query += 'FROM invoiceit_s__Invoice_Lines__c  WHERE Sales_Full_Amount__c = null AND ';
        query += 'invoiceit_s__Invoice__r.invoiceit_s__Invoice_Date__c =: processedDate AND ';
        query += '(invoiceit_s__Invoice__r.invoiceit_s__Invoice_State__c = \'Regular\' OR ';
        query += 'invoiceit_s__Invoice__r.invoiceit_s__Invoice_State__c = \'Upload Trust Usage\' OR ';
        query += 'invoiceit_s__Invoice__r.invoiceit_s__Invoice_State__c = \'Upload - Correction\' OR ';
        query += 'invoiceit_s__Invoice__r.invoiceit_s__Invoice_State__c = \'Monthly iFirm Subscription Billing\' OR ';
        query += 'invoiceit_s__Invoice__r.invoiceit_s__Invoice_State__c = \'Upload - PPRPRS\' )';

        //Query += ' AND createddate = today ORDER BY Material_Number1__c '; 
        //for testing-->use below and comment above
        //Query = Query + ' AND (invoiceit_s__Invoice__r.Id =\'a2QM0000001hFMv\' OR invoiceit_s__Invoice__r.Id =\'a2QM0000001hCBP\') ORDER BY Material_Number1__c ';  
        system.debug('xxxxxxxxxxxxQUERY  ' + Query);
        return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Savepoint sp;

        try {
            sp = Database.setSavePoint();
            mapMaterialNoSAPID = new map<string, SAP_Integration__c>();

            list <SAP_Integration__c> alltoinsert = [Select Amount__c, Amount1__c, Document_Date__c, Document_Type__c,
                                                    GL_Account__c, Line_Description__c, Material_Code__c, Posting_Date__c,
                                                    Posting_Key__c, Record_Type__c, SAP_Processed_Date__c, State__c, Type__c
                                                    FROM SAP_Integration__c
                                                    WHERE SAP_processed_date__c =: processedDate
                                                    AND
                                                    Document_Type__c = 'Sales Invoices'
                                                    AND
                                                    Status__c != 'Completed'
                                                    ];

            for(SAP_Integration__c sapInt : alltoinsert) {
                // ignore the first line
                mapMaterialNoSAPID.put(sapInt.Material_Code__c, sapInt);
            }
            system.debug('mapMaterialNoSAPID ' + mapMaterialNoSAPID);

            if(alltoinsert.size() == 0) {
                // populate the first row
                date processedDate= processedDate;
                string todayDate = string.ValueOf(processedDate.day()) + string.ValueOf(processedDate.month()) + string.ValueOf(processedDate.year());          
                
                //Hardcoded first line
                SAP_Integration__c HeaderSAP= new SAP_Integration__c(Record_Type__c='1', GL_Account__c=processedDateString, Posting_Key__c='US30', Line_Description__c ='' , Posting_Date__c = processedDateString, Document_Type__c='Sales Invoices', Amount__c=integer.ValueOf(todayDate), Amount1__c=processedDateString, Material_Code__c='Daily Sales', State__c ='USD',SAP_processed_date__c = processedDate, Type__c='SA');
                alltoinsert.add (HeaderSAP); 
                insert HeaderSAP;
            }

            string myMNum='None';
            list<invoiceit_s__Invoice_Lines__c> invoiceLines = scope;
            for(invoiceit_s__Invoice_Lines__c il : invoiceLines) {
                myMNum = 'None';

                if(IL.invoiceit_s__Product_Name__c == 'Sales Tax') {
                    myMNum = IL.invoiceit_s__Invoice__r.invoiceit_s__Account__r.ShippingState;
                    if (IL.invoiceit_s__Invoice__r.invoiceit_s__Account__r.ShippingState == null) {
                        myMNum = 'NoStateCode';
                    }
                } else {
                    myMNum = il.Material_Number1__c;
                }

                if(myMNum == '' || myMNum == null) {
                    myMNum = 'None';
                }

                if(!mapMaterialNoSAPID.containsKey('TotalInvoiceSales')) {
                    SAP_Integration__c totalSales= new SAP_Integration__c(Record_Type__c='2', GL_Account__c='12211200', Posting_Key__c='D', Line_Description__c ='Daily Sales' , Posting_Date__c = processedDateString, Document_Type__c='Sales Invoices', Amount__c=0, Amount1__c='0.00', Material_Code__c = 'TotalInvoiceSales', State__c =null,SAP_processed_date__c = processedDate);
                    mapMaterialNoSAPID.put('TotalInvoiceSales', totalSales);
                }

                system.debug ('myMNum  ' +myMNum);
                SAP_Integration__c sapRecord;
                if(mapMaterialNoSAPID.containsKey(myMNum)) {
                    // populate the amount material code
                    sapRecord = mapMaterialNoSAPID.get(myMNum);
                    sapRecord.Amount__c = sapRecord.Amount__c + IL.invoiceit_s__Total_Line_Amount__c;
                    sapRecord.Amount1__c = string.ValueOf(sapRecord.Amount__c);

                } else {
                    if(IL.invoiceit_s__Product_Name__c == 'Sales Tax') {
                        sapRecord = new SAP_Integration__c(Record_Type__c='2', GL_Account__c='13532300', Posting_Key__c='C', Line_Description__c ='Daily Sales', Posting_Date__c = processedDateString, Document_Type__c='Sales Invoices',Amount__c=IL.invoiceit_s__Total_Line_Amount__c, Amount1__c=string.valueof(IL.invoiceit_s__Total_Line_Amount__c), Material_Code__c =myMNum, State__c = myMNum, SAP_processed_date__c = processedDate);
                    } else { 
                        sapRecord = new SAP_Integration__c(Record_Type__c='2', GL_Account__c='13110200', Posting_Key__c='C', Line_Description__c ='Daily Sales', Posting_Date__c = processedDateString, Document_Type__c='Sales Invoices',Amount__c=IL.invoiceit_s__Total_Line_Amount__c, Amount1__c=string.valueof(IL.invoiceit_s__Total_Line_Amount__c), Material_Code__c =myMNum, State__c = null, SAP_processed_date__c = processedDate);
                    }
                }

                // populate the amount for total sales
                SAP_Integration__c totalSales = mapMaterialNoSAPID.get('TotalInvoiceSales');
                totalSales.Amount__c = totalSales.Amount__c + IL.invoiceit_s__Total_Line_Amount__c;
                totalSales.Amount1__c = string.ValueOf(totalSales.Amount__c);
                mapMaterialNoSAPID.put('TotalInvoiceSales', totalSales);

                // populate the tax or material number
                mapMaterialNoSAPID.put(myMNum, sapRecord);
            }

            // upsert the SAP Records
            upsert mapMaterialNoSAPID.values();

            // populates the look ups
            for(invoiceit_s__Invoice_Lines__c il : invoiceLines) {
                myMNum = 'None';

                if(IL.invoiceit_s__Product_Name__c == 'Sales Tax') {
                    myMNum = IL.invoiceit_s__Invoice__r.invoiceit_s__Account__r.ShippingState;
                    if (myMNum == null || myMNum == '') {
                        myMNum = 'NoStateCode';
                    }
                } else {
                    myMNum = il.Material_Number1__c;
                }

                if(myMNum == '' || myMNum == null) {
                    myMNum = 'None';
                }

                // populate the full sales amount lookUp
                il.Sales_Full_Amount__c = mapMaterialNoSAPID.get('TotalInvoiceSales').Id;

                // populate the tax loop up and material code lookup
                il.Sales_Full_Amount_D__c = mapMaterialNoSAPID.get(myMNum).Id;
            }

            // update the invoice lines to populate the look ups
            update invoiceLines;
        }
        catch(Exception ex) {
            database.rollback(sp);

            excetionString = excetionString + ' ' + ex.getMessage() + ' Line No : ' + ex.getLineNumber() + ' Stace Trace : ' + ex.getStackTraceString(); 
            job.invoiceit_s__Completed_Date_and_Time__c = system.now();
            job.invoiceit_s__Status__c = 'Completed with errors';   
            job.invoiceit_s__Exception_Log__c = excetionString;
            update job;
        }
    }
    
    global void finish(Database.BatchableContext BC) {   
        // initiate the credit notes batch
        IIT_SAP_CreditNoteBATCH batchJob = new IIT_SAP_CreditNoteBATCH(processedDate, job);
        database.executebatch(batchJob);
    }   
}