global class InvoiceReportBatch Implements Database.Batchable<sObject> {
    public String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
    try{  
        Integer current_Month,current_year;
        Date startDate,endDate;
        if(Date.Today().day() > 7){
            startDate=date.newInstance(system.today().year(),system.today().Month(),7);
            endDate=Date.Today();
        }
        
        else{
           startDate=date.newInstance(system.today().year(),system.today().Month(),1);
           startDate=StartDate.addMonths(-1);
           startDate=StartDate.adddays(6);
           endDate=Date.Today();
        }
    
        if(!Test.isRunningTest()){
            system.debug('Inside test If running');
            query = 'Select id,invoiceit_s__Account__c ,invoiceit_s__Invoice_Date__c,Invoice_Sent_Formatted__c,Account_CID__c,Account_PID__c,invoiceit_s__Order__c,'+
            'Name,invoiceit_s__Paid_Amount__c,invoiceit_s__Tax__c,Last_Payment_Type__c,Order_Value__c from invoiceit_s__Invoice__c where invoiceit_s__Invoice_Date__c >:startDate and invoiceit_s__Invoice_Date__c <:endDate and ' 
            +'invoiceit_s__Invoice_Status__c= \''
            + String.escapeSingleQuotes('Posted') + '\'';
           
        }
        
        else{
             query = 'Select id,invoiceit_s__Account__c ,invoiceit_s__Invoice_Date__c,Invoice_Sent_Formatted__c,Account_CID__c,Account_PID__c,invoiceit_s__Order__c,'+
            'Name,invoiceit_s__Paid_Amount__c,invoiceit_s__Tax__c,Last_Payment_Type__c,Order_Value__c from invoiceit_s__Invoice__c where invoiceit_s__Invoice_Date__c >:startDate and invoiceit_s__Invoice_Date__c <:endDate and '
            +'invoiceit_s__Invoice_Status__c= \''
            + String.escapeSingleQuotes('Posted') + '\' limit 10';
           
        }
     
        
    }catch(Exception Ex){
        system.debug('Exception'+Ex);
    }
    return Database.getQueryLocator(query); 
    
    }
    
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Invoice__c> scope) {
        Set<Id> invoiceIds=new Set<Id>();
        Set<Id> accInvoiceIds=new Set<Id>();
        
       /* Map<Id, invoiceit_s__Invoice__c> invoices=new Map<Id, invoiceit_s__Invoice__c>([Select id,invoiceit_s__Account__c ,invoiceit_s__Invoice_Date__c,Invoice_Sent_Formatted__c,Account_CID__c,Account_PID__c,invoiceit_s__Order__c,Name,
        invoiceit_s__Paid_Amount__c,invoiceit_s__Tax__c,Last_Payment_Type__c,Order_Value__c from invoiceit_s__Invoice__c where 
        invoiceit_s__Invoice_Status__c='Posted' and invoiceit_s__Invoice_Date__c>=2016-04-06]); */
        
         for(invoiceit_s__Invoice__c invoices: scope) {
            invoiceIds.add(invoices.Id);
            accInvoiceIds.add(invoices.invoiceit_s__Account__c);
         }
         
        List<invoiceit_s__Invoice_Lines__c> invoiceLines=[Select   Id,Name,invoiceit_s__Invoice__c,invoiceit_s__Unit_Price__c,Product_Code__c,invoiceit_s__Sequence_No__c,invoiceit_s__Quantity__c,invoiceit_s__Product_Name__c,Product_Year__c,invoiceit_s__Line_Name__c,
        invoiceit_s__Net_Total__c,invoiceit_s__Tax__c,invoiceit_s__Service_Start_Date__c,invoiceit_s__Service_End_Date__c,Price_Extended__c,Product_Taxable__c,invoiceit_s__Job_Rate_Plan_Charge__c,
        Training_Contact_Email__c,Product_Purchase_Type__c,Product_Family__c from invoiceit_s__Invoice_Lines__c  where invoiceit_s__Invoice__c IN:invoiceIds];
        
        List<Account> accList=[Select Id, Name from Account where Id In:accInvoiceIds];
        
        String invoiceHeader = 'Invoice Date,Invoice number, product code, Product description,Quantity,Unit price,Product Family,Account Name,Line Number \n';
        String finalstr= invoiceHeader;
        
         for(invoiceit_s__Invoice__c invoice:scope){
            for(invoiceit_s__Invoice_Lines__c invoiceLine: invoiceLines){ 
                for(Account acc:accList){
                    if(invoiceLine.invoiceit_s__Invoice__c==invoice.id && invoice.invoiceit_s__Account__c==acc.Id){
                        string recordString = invoice.invoiceit_s__Invoice_Date__c+','+invoice.name+','+invoiceLine.Product_Code__c+','+invoiceLine.invoiceit_s__Product_Name__c+',' +
                        invoiceLine.invoiceit_s__Quantity__c+','+invoiceLine.invoiceit_s__Unit_Price__c+','+invoiceLine.Product_Family__c+','+acc.Name+','+invoiceLine.name+'\n';
                        finalstr = finalstr +recordString;
                    }
                  }
            }
        }
        
        blob csvInvBlob = Blob.valueOf(finalstr);
   
        Folder folder = new Folder();
        Folder invCN =[Select Id from Folder where name='Invoice and CreditNote'];
        
        folder.id=invCN.Id;
        Document doc = new Document();
       
        doc.Body=csvInvBlob;
        doc.ContentType='text/csv';
        doc.Name ='Invoice'+'  ' +system.today().format()+'.csv';
        doc.FolderId=folder.Id;
        
       insert doc;   
    }
    
    
       
    global void finish(Database.BatchableContext BC){} 

}