global class CreditNoteReportBatch Implements Database.Batchable<sObject> {
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
          query = 'Select CreatedDate,Id,Name,invoiceit_s__Account__c from invoiceit_s__Credit_Note__c where CreatedDate>:startDate and CreatedDate<:endDate';
          
          
        }
        else{
            query = 'Select CreatedDate,Id,Name,invoiceit_s__Account__c from invoiceit_s__Credit_Note__c where CreatedDate>:startDate and CreatedDate<:endDate';
        }
    
    }catch(Exception Ex){
        system.debug('Exception'+Ex);
    }
    return Database.getQueryLocator(query); 
    
    }
    
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Credit_Note__c> scope) {
        Set<Id> CNIds=new Set<Id>();
        Set<Id> accCNIds=new Set<Id>();
       
         for(invoiceit_s__Credit_Note__c creditNote: scope) {
            CNIds.add(creditNote.Id);
            accCNIds.add(creditNote.invoiceit_s__Account__c);
         }
         
          List<invoiceit_s__Credit_Line__c> creditLine=[Select CreatedDate,Id,Name,invoiceit_s__Quantity__c,invoiceit_s__Unit_Price__c,invoiceit_s__Credit_Note__c 
          from invoiceit_s__Credit_Line__c where invoiceit_s__Credit_Note__c In:CNIds];
          
        
        List<Account> accList=[Select Id, Name from Account where Id In:accCNIds];
        
        
        String creditHeader= 'Created Date,Credit Line Id, Credit Note Name, Credit Line Name, Quantity,Unit Price,Account Name \n';
        String finalCreditstr= creditHeader;
        
        for(invoiceit_s__Credit_Note__c credNote:scope){
            for(invoiceit_s__Credit_Line__c credLine: creditLine){ 
              for(Account acc:accList){
                if(credLine.invoiceit_s__Credit_Note__c ==credNote.id && credNote.invoiceit_s__Account__c==acc.Id){
                    string recordString = credNote.CreatedDate+','+credNote.Id+','+credNote.Name+','+credLine.Name+',' +
                    credLine.invoiceit_s__Unit_Price__c+','+credLine.invoiceit_s__Unit_Price__c+','+acc.Name+'\n';
                    finalCreditstr= finalCreditstr+recordString;
                }
               }
            }
        }
        
        blob csvCredNoteBlob = Blob.valueOf(finalCreditstr);
   
        Folder folder = new Folder();
        Folder invCN =[Select Id from Folder where name='Invoice and CreditNote'];
        
        folder.id=invCN.Id;
        
        Document doc = new Document();
       
        doc.Body=csvCredNoteBlob;
        doc.ContentType='text/csv';
        doc.Name ='Credit Notes'+'  ' +system.today().format()+'.csv';
        doc.FolderId=folder.Id;
        
        insert doc;   
    }
    
    
       
    global void finish(Database.BatchableContext BC){} 

}