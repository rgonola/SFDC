global class PfxOrderUtil{



   @future(callout=true)
   public static void createorder(Id accountId,Id oppid,ID QuoteId){
          
           List<Product2> pi;
       try{
       
         if(!Test.IsRunningTest()){
           pi=[Select Id,Name From Product2 Where Name=:Label.Sales_Tax_Product_Name AND IsActive= true Limit 1 ];
          }else{   pi=[Select Id,Name From Product2 Where Name='Sales Tax' AND IsActive= true Limit 1 ]; }
         
             
             
           List<SBQQ__QuoteLine__c> optnqllines= new List<SBQQ__QuoteLine__c>(); 
              
            SBQQ__QuoteLine__c ql= new SBQQ__QuoteLine__c();
          ql.SBQQ__Quantity__c = 1;
          if(!Test.IsRunningTest()){ ql.SBQQ__Product__c = Label.PFX_Book_ID ; } else{ ql.SBQQ__Product__c = pi[0].id; }
          ql.SBQQ__ListPrice__c=0;
          ql.SBQQ__Quote__c  = QuoteId;
          ql.SBQQ__SubscriptionPricing__c='Fixed Price';
          ql.SBQQ__SubscriptionBase__c='List';
          ql.SBQQ__SubscriptionPercent__c=0;
          ql.SBQQ__DefaultSubscriptionTerm__c=12;
          
           SBQQ__QuoteLine__c ql2= new SBQQ__QuoteLine__c();
          ql2.SBQQ__Quantity__c = 1;
          if(!Test.IsRunningTest()){ ql2.SBQQ__Product__c = Label.PFX_TAXBOOKDELUXE_ID ; } else{ ql2.SBQQ__Product__c = pi[0].id; }
          ql2.SBQQ__ListPrice__c=0;
          ql2.SBQQ__Quote__c  = QuoteId;
           ql2.SBQQ__SubscriptionPricing__c='Fixed Price';
          ql2.SBQQ__SubscriptionBase__c='List';
          ql2.SBQQ__SubscriptionPercent__c=0;
          ql2.SBQQ__DefaultSubscriptionTerm__c=12;
            //Create sales Tax line
         SBQQ__QuoteLine__c salesline = new SBQQ__QuoteLine__c (SBQQ__Quantity__c = 1,SBQQ__Product__c = pi[0].id,SBQQ__Quote__c  = QuoteId);
         
          optnqllines.add(ql);
          optnqllines.add(ql2);
          optnqllines.add(salesline);
          
          system.debug('lines for QL'+optnqllines);
           if(optnqllines.size()>0) insert optnqllines;
           
          
           
         
     if(!Test.IsRunningTest())     
    IIT_PID_CID_check.output op =  IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(null, null, null,accountId)  ;
    
    
    opportunity opp =[select Id,QTC__Create_Order__c From opportunity Where id=:oppid];  

         if(!Test.IsRunningTest()){  opp.QTC__Create_Order__c=true;  opp.SBQQ__Contracted__c=false;  update opp; }
    
     list <invoiceit_s__Job__c> createdOrder = [SELECT id,invoiceit_s__Create_Invoice_Automatically__c,invoiceit_s__Start_Date__c
                             FROM invoiceit_s__Job__c 
                             WHERE 
                             QTC__Opportunity__c = : oppid] ;
            Id OrderID ;                
                    if (createdOrder.size() > 0 ) { OrderID = createdOrder[0].id; createdOrder[0].invoiceit_s__Create_Invoice_Automatically__c = true;    update createdOrder;  }
                      
                          
      
       list <invoiceit_s__Invoice__c > createdInvoice =[SELECT Id,invoiceit_s__Order__c,Name,invoiceit_s__CurrencyL__c, invoiceit_s__Total_Invoice_Value__c
                               FROM invoiceit_s__Invoice__c 
                               WHERE invoiceit_s__Order__c = : OrderID 
                               ORDER BY Name DESC NULLS LAST];
                                             
              opp.SBQQ__Contracted__c=true; update opp;
                    
              }catch(Exception ex){
              
              String Msg='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
              
               LogFiles__c log=new LogFiles__c (Related_Account__c=accountId,Log_Type__c='PFX Book Promo',Info__c=Msg);
              
               insert log;
              
              
              
              }                   
  }
 
 
 
   
   
        
   
    
}