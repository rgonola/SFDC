//Creates Assets for the account from the invoicelines

 trigger CreateAssetAfterSubcription on SBQQ__Subscription__c (after Insert,after Update) {
  if(Trigger.IsInsert){
 List<SFS_Asset__c> assetList = new List<SFS_Asset__c>(); 
    
    boolean haschanged =false;
    
    Map<Id,SBQQ__Subscription__c > quantityforsub= new Map<Id,SBQQ__Subscription__c >(); 
    
  List<String> qlname= new List<String>();
   
    
    for(SBQQ__Subscription__c iline : trigger.new){
    
    system.debug('*********Quantity of the line '+iline.SBQQ__RenewalQuantity__c +iline.SBQQ__Product__c);
    
    if(iline.SBQQ__RenewalQuantity__c > 0){
    SFS_Asset__c asst = new SFS_Asset__c();
    asst.Name = iline.SBQQ__ProductName__c;
    asst.Account__c= iline.SBQQ__Account__c;
    asst.Product__c= iline.SBQQ__Product__c;
    asst.Quantity__c= iline.SBQQ__RenewalQuantity__c;
    asst.Status__c='Purchased';
    asst.Current_Subscription__c=iline.id;
    asst.Price__c= iline.SBQQ__CustomerPrice__c;
    if(!Test.isRunningTest()){
    asst.Tax_Year__c =Label.Assets_Tax_Year;
    asst.Tax_year_name__c=Label.Assets_Tax_Year_Name;
    }
    asst.Order_Rate_Plan_Charge__c = iline.QTC__Order_Rate_Plan_Charge__c;
    asst.Quote_Line__c = iline.SBQQ__QuoteLine__c;
    asst.Contract__c=iline.SBQQ__Contract__c;  
    assetList.add(asst);
    if(iline.QTC__Order_Rate_Plan_Charge__c!=null )
    qlname.add(iline.QTC__Order_Rate_Plan_Charge__c);
    }else{
    
    quantityforsub.put(iline.SBQQ__RevisedSubscription__c,iline);
    
     system.debug('*********Came heree  '+quantityforsub);
     
    haschanged =true;
    }
    }
    
    if(assetList.size()>0)
    insert assetList;
    
    Map<String,invoiceit_s__Invoice_Lines__c> qlforotherfields= new Map<String,invoiceit_s__Invoice_Lines__c >();
    
    if(qlname.size()>0){
    for(invoiceit_s__Invoice_Lines__c sql :[Select Id,Quote_ID__c,invoiceit_s__Invoice__c,invoiceit_s__Invoice__r.Name,invoiceit_s__Job_Rate_Plan_Charge__c,
                                                   invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Order__r.CreatedDate,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Order__r.id,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Order__r.Name,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Required_By__r.Name
                                                   From invoiceit_s__Invoice_Lines__c  Where invoiceit_s__Job_Rate_Plan_Charge__c IN : qlname] ){
    
   qlforotherfields.put(sql.invoiceit_s__Job_Rate_Plan_Charge__c ,sql);
    
    }
    }
    
    List<SFS_Asset__c> updateassetList = new List<SFS_Asset__c>();
    
    if(qlforotherfields.size()>=0){
    for(SFS_Asset__c ast :[Select Id,Order_Rate_Plan_Charge__c,Contract__c,Contract__r.SBQQ__Opportunity__r.Type,Product__c,Product__r.List_Price__c,Product__r.ProductCode,Product__r.Description,Product__r.Family,Product__r.Product_Year__c,Account__c,Account__r.CID__c,Account__r.PID__C,Account__r.Name,Account__r.rrpu__Alert_Message__c,Quote_Line__c,
                                  Order_Rate_Plan_Charge__r.invoiceit_s__Order__r.CreatedDate,Order_Rate_Plan_Charge__r.invoiceit_s__Order__r.id,Order_Rate_Plan_Charge__r.invoiceit_s__Order__r.Name,Order_Rate_Plan_Charge__r.invoiceit_s__Required_By__r.Name,Quote_Line__r.SBQQ__Quote__r.Origin_Source__c
                                  From SFS_Asset__c Where Order_Rate_Plan_Charge__c IN: qlforotherfields.keyset()]){
    
    
    ast.Invoice__c = qlforotherfields.get(ast.Order_Rate_Plan_Charge__c).invoiceit_s__Invoice__c;
    ast.Invoice_Number__c=qlforotherfields.get(ast.Order_Rate_Plan_Charge__c).invoiceit_s__Invoice__r.Name;
    
    
    
    ast.Account_CID__c=ast.Account__r.CID__c;
    ast.Quote_Source__c=ast.Quote_Line__r.SBQQ__Quote__r.Origin_Source__c;
    ast.Account_PID__c=ast.Account__r.PID__c;
    ast.Account_Name__c=ast.Account__r.Name;
    ast.Actual_Alert_Message__c=ast.Account__r.rrpu__Alert_Message__c;
    ast.Product_Code__c=ast.Product__r.ProductCode;
    ast.Product_Description__c=ast.Product__r.Description;
    ast.Product_Family__c=ast.Product__r.Family;
    ast.Product_List_Price__c=ast.Product__r.List_Price__c;
    ast.Opportunity_type__c=ast.Contract__r.SBQQ__Opportunity__r.Type;
    ast.Product_Year__c=ast.Product__r.Product_Year__c;
    
    ast.Order_Date__c=ast.Order_Rate_Plan_Charge__r.invoiceit_s__Order__r.CreatedDate;
    ast.Order_ID__c=ast.Order_Rate_Plan_Charge__r.invoiceit_s__Order__r.id;
    ast.Order_Number__c=ast.Order_Rate_Plan_Charge__r.invoiceit_s__Order__r.Name;
    ast.Required_By__c=ast.Order_Rate_Plan_Charge__r.invoiceit_s__Required_By__r.Name;
    
    updateassetList.add(ast);
    }
    
    }
    
    if(updateassetList.size()>=0)
    update updateassetList;
    
    Map<String,String> oldsubline= new Map<String,String>();
    
    if(quantityforsub.size()>0){
    for(SBQQ__Subscription__c sub: [Select Id,QTC__Order_Rate_Plan_Charge__c From SBQQ__Subscription__c Where Id IN: quantityforsub.keyset()]){
    
    oldsubline.put(sub.QTC__Order_Rate_Plan_Charge__c,sub.Id);
    
    
    }
    }
    
    List<SFS_Asset__c> updateaststatus= new List<SFS_Asset__c>();
    
    system.debug('key set values for query'+quantityforsub.keyset());
    
    if(oldsubline.size()>0){
    for(SFS_Asset__c upast :[Select Id,Order_Rate_Plan_Charge__c,Quantity__c ,Product__c,Account__c,Contract__c ,Quote_Line__c From SFS_Asset__c Where Order_Rate_Plan_Charge__c IN: oldsubline.keyset()]){
    
    
    upast.Quantity__c =upast.Quantity__c + quantityforsub.get(oldsubline.get(upast.Order_Rate_Plan_Charge__c)).SBQQ__RenewalQuantity__c;
    
    updateaststatus.add(upast);
    
    }
    }
    
    if(updateaststatus.size()>=0)
    update updateaststatus;
 
 
 
    }
    else{
    
    List<String> qlname= new List<String>();
    
    for(SBQQ__Subscription__c iline : trigger.new){
    
    if(iline.QTC__Order_Rate_Plan_Charge__c!=null){
    
    qlname.add(iline.QTC__Order_Rate_Plan_Charge__c);
    
    }
    }
    
    Map<String,invoiceit_s__Invoice_Lines__c> qlforotherfields= new Map<String,invoiceit_s__Invoice_Lines__c >();
    
    if(qlname.size()>0){
    for(invoiceit_s__Invoice_Lines__c sql :[Select Id,Quote_ID__c,invoiceit_s__Invoice__c,invoiceit_s__Invoice__r.Name,invoiceit_s__Job_Rate_Plan_Charge__c,
                                                   invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Order__r.CreatedDate,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Order__r.id,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Order__r.Name,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Required_By__r.Name
                                                   From invoiceit_s__Invoice_Lines__c  Where invoiceit_s__Job_Rate_Plan_Charge__c IN : qlname]){
    
    if(sql.Quote_ID__c != null){
    qlforotherfields.put(sql.Quote_ID__c,sql);
    }
    
    }
    }
    
    List<SFS_Asset__c> updateassetList = new List<SFS_Asset__c>();
    
    if(qlforotherfields.size()>0){
    
    for(SFS_Asset__c ast :[Select Id,Order_Rate_Plan_Charge__c,Contract__c,Quote_Id__c,Contract__r.SBQQ__Opportunity__r.Type,Product__c,Product__r.List_Price__c,Product__r.ProductCode,Product__r.Description,Product__r.Family,Product__r.Product_Year__c,Account__c,Account__r.CID__c,Account__r.PID__C,Account__r.Name,Account__r.rrpu__Alert_Message__c,Quote_Line__c,
                                  Order_Rate_Plan_Charge__r.invoiceit_s__Order__r.CreatedDate,Order_Rate_Plan_Charge__r.invoiceit_s__Order__r.id,Order_Rate_Plan_Charge__r.invoiceit_s__Order__r.Name,Order_Rate_Plan_Charge__r.invoiceit_s__Required_By__r.Name,Quote_Line__r.SBQQ__Quote__r.Origin_Source__c
                                  From SFS_Asset__c Where Quote_Id__c IN: qlforotherfields.keyset()]){
    
    
    ast.Invoice__c = qlforotherfields.get(ast.Quote_Id__c).invoiceit_s__Invoice__c;
    ast.Invoice_Number__c=qlforotherfields.get(ast.Quote_Id__c).invoiceit_s__Invoice__r.Name;
    ast.Account_CID__c=ast.Account__r.CID__c;
    ast.Order_Rate_Plan_Charge__c = qlforotherfields.get(ast.Quote_Id__c).invoiceit_s__Job_Rate_Plan_Charge__c;
    ast.Quote_Source__c=ast.Quote_Line__r.SBQQ__Quote__r.Origin_Source__c;
    ast.Account_PID__c=ast.Account__r.PID__c;
    ast.Account_Name__c=ast.Account__r.Name;
    ast.Actual_Alert_Message__c=ast.Account__r.rrpu__Alert_Message__c;
    ast.Product_Code__c=ast.Product__r.ProductCode;
    ast.Product_Description__c=ast.Product__r.Description;
    ast.Product_Family__c=ast.Product__r.Family;
    ast.Product_List_Price__c=ast.Product__r.List_Price__c;
    ast.Opportunity_type__c=ast.Contract__r.SBQQ__Opportunity__r.Type;
    ast.Product_Year__c=ast.Product__r.Product_Year__c;
    
    ast.Order_Date__c=qlforotherfields.get(ast.Quote_Id__c).invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Order__r.CreatedDate;
    ast.Order_ID__c=qlforotherfields.get(ast.Quote_Id__c).invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Order__r.id;
    ast.Order_Number__c=qlforotherfields.get(ast.Quote_Id__c).invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Order__r.Name;
    ast.Required_By__c=qlforotherfields.get(ast.Quote_Id__c).invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Required_By__r.Name;
    
    updateassetList.add(ast);
    }
    
    if(updateassetList.size()>0)
    update updateassetList;
    
    }
    
    
    
    }
    
    }