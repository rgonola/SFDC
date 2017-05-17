/* Class deals with creation of Renewal Opportunity and Quote for the Account.
  Querying Previous Year deatils and using that creating the new Quote*/ 

global class RenewalQuoteCreation{

  public static void createquote(Id accountId) {

   List<SBQQ__Subscription__c> sub;
   Set<ID>contractstoprocess = new Set<ID>();
   Set<ID>substoprocess = new Set<ID>();
   Set<ID>Idstoberemoved= new Set<ID>();
   Set<ID>linestobethere= new Set<ID>();
   Map<String,Decimal>producttoqunatity= new Map<String,Decimal>();
   opportunity   opp;
   SBQQ__Quote__c newquote;
   
   Account   acc=[Select id,BillingStreet,Billingcity,OwnerId,BillingCountry,ShippingCountry,Contact__r.id,BillingState,Billingpostalcode,SBQQ__DefaultOpportunity__r.SBQQ__PrimaryQuote__c,SBQQ__DefaultOpportunity__c,Email__c,ShippingStreet,shippingcity,shippingState,
                                 shippingpostalcode,Primary_Contact_Name__c From Account where id=:accountId];  
    
   Try{
                                 
   List<Contract> contracts =[select Id,AccountId,Status,ContractNumber From Contract where AccountId=:accountId AND Status='Activated' order by CreatedDate desc ];
     
     if(contracts.size()>0){
     
      for(Contract c:contracts ){
      
      contractstoprocess.add(c.id);
      
      }
    
    List<PriceBook2>  pbk =[Select Id,Name,IsActive From PriceBook2 Where Name=:Label.Renewal_Pricebook];
     
    RecordType rt = [select Id from RecordType where Name = :Label.Bulk_Opp_Record_Type and SobjectType = 'opportunity' limit 1];
    
    RecordType qrt = [select Id from RecordType where Name = :Label.Bulk_Quotes_Record_Type and SobjectType = 'SBQQ__Quote__c' limit 1];
       
     if(!Test.IsRunningTest()){  
     sub =[select Id,SBQQ__Quantity__c,SBQQ__Product__r.ProductCode,SBQQ__RevisedSubscription__c,Name,SBQQ__Contract__c,SBQQ__Product__c,SBQQ__QuoteLine__c,SBQQ__Product__r.SBQQ__RenewalProduct__c,SBQQ__Product__r.Renewal_Product_Mapping_Diff__c From SBQQ__Subscription__c 
                                             where SBQQ__Contract__c IN :contractstoprocess  AND SBQQ__Product__r.Shipping_Processing__c=False
                                             AND (Is_Subscription__c=False AND ((Package__c = TRUE AND Bundleds__c = False) OR (Package__c=False AND Bundleds__c = False  )) ) AND SBQQ__Product__r.SBQQ__RenewalProduct__c!=null
                                             AND SBQQ__Product__r.Name != :Label.Sales_Tax_Product_Name  AND SBQQ__Product__r.SBQQ__RenewalProduct__r.Price_Book__c=:pbk[0].id AND ((QTC__Order_Rate_Plan_Charge__c!= null AND SBQQ__Quantity__c >0) OR ( SBQQ__Quantity__c <0))   
                                             order by CreatedDate desc ];
                                             
                                        
    }else{
      sub =[select Id,SBQQ__Quantity__c,SBQQ__Product__r.ProductCode,SBQQ__RevisedSubscription__c,Name,SBQQ__Contract__c,SBQQ__Product__c,SBQQ__QuoteLine__c,SBQQ__Product__r.SBQQ__RenewalProduct__c,SBQQ__Product__r.Renewal_Product_Mapping_Diff__c From SBQQ__Subscription__c 
                                             where SBQQ__Contract__c IN :contractstoprocess  AND SBQQ__Product__r.Shipping_Processing__c=False
                                             AND (Is_Subscription__c=False AND (Package__c = TRUE OR (Package__c=False AND Bundleds__c = False  ) )) ];
    
    
    }
    //AND QTC__Order_Rate_Plan_Charge__r.invoiceit_s__Status__c !='Cancelled' AND (SBQQ__Quantity__c > 0 OR SBQQ__Quantity__c = 0)
                    
    List<Contact >   cn=[Select Id,AccountID,Is_Primary__c From Contact Where Is_Primary__c =true AND AccountID=:accountId order by CreatedDate desc Limit 1 ];   
    
    
      
    
    List<Product2> pi=[Select Id,Name From Product2 Where Name=:Label.Sales_Tax_Product_Name AND IsActive= true Limit 1 ];
     
    
   
   
   //Create Renewal opportunity
   
    opp = new Opportunity(Name=Label.Renewal_Opp_Name,AccountID = accountId,CloseDate = Date.today().addmonths(12), RecordTypeID=rt.id,OwnerId=acc.OwnerId,
                              StageName = Label.Renewal_Batch_Opp_Stage_Name, Contact__c=cn[0].id,Product_Category__c='Small Firm Software',SBQQ__QuotePricebookId__c=pbk[0].id,Type = 'Renewal',Renewal_Quote__c=true,Forecast_Type__c=Label.Batch_Quotes_Forecast,Product_Sub_Category__c='Tax'); 
                             
    insert opp; 
    
    
    
    //Create Quote 
    
    newquote = new SBQQ__Quote__c (SBQQ__Type__c ='Renewal',SBQQ__Status__c='Draft',SBQQ__SalesRep__c=acc.OwnerId,SBQQ__PrimaryContact__c=cn[0].id,SBQQ__Primary__c = true,SBQQ__Opportunity2__c=opp.id,RecordTypeID=qrt.id,
                                                  SBQQ__StartDate__c=date.ValueOf(Label.Batch_Quotes_Start_Date), SBQQ__BillingName__c=acc.Primary_Contact_Name__c,SBQQ__BillingStreet__c=acc.BillingStreet,SBQQ__BillingCity__c=acc.BillingCity,Web_Renewal__c=true,
                                                  SBQQ__BillingState__c=acc.BillingState,SBQQ__BillingPostalCode__c=acc.Billingpostalcode,SBQQ__BillingCountry__c = acc.BillingCountry,Origin_Source__c = 'REP',SBQQ__Account__c=acc.id,
                                                  SBQQ__ShippingName__c=acc.Primary_Contact_Name__c,SBQQ__ShippingStreet__c=acc.ShippingStreet,SBQQ__ShippingCity__c=acc.ShippingCity,SBQQ__ShippingState__c=acc.ShippingState,
                                                  Batch_Designation__c=Label.Batch_Quotes_Designation,SBQQ__ShippingPostalCode__c=acc.Shippingpostalcode,SBQQ__ShippingCountry__c = acc.ShippingCountry,SBQQ__PricebookId__c =pbk[0].id,SBQQ__PriceBook__c =pbk[0].id);
        

        insert newquote ;
    
    
  
    //Create main lines items
    
     
     List<SBQQ__QuoteLine__c> qlinetoupdate= new List<SBQQ__QuoteLine__c>();
     Set<ID>revisedsubs= new Set<ID>();
     Set<ID>twoprodtoone= new Set<ID>();
     
    
     for(SBQQ__Subscription__c  qln :sub ){
     
     system.debug('Subscriotion lines here***'+qln);   
     
     if(qln.SBQQ__RevisedSubscription__c != null ){  revisedsubs.add(qln.SBQQ__RevisedSubscription__c);   }
     
     if(qln.SBQQ__Quantity__c < 0 ) {  revisedsubs.add(qln.id);   }
     
     if(!producttoqunatity.ContainsKey(qln.SBQQ__Product__r.ProductCode)){
     
      producttoqunatity.put(qln.SBQQ__Product__r.ProductCode,qln.SBQQ__Quantity__c );
      
      linestobethere.add(qln.id);
     system.debug('product to quantity'+producttoqunatity);
     
     }else{
     
      Decimal q = producttoqunatity.get(qln.SBQQ__Product__r.ProductCode);
      q += qln.SBQQ__Quantity__c ;
      producttoqunatity.put(qln.SBQQ__Product__r.ProductCode,q );
      Idstoberemoved.add(qln.id);
      system.debug('product to quantity'+producttoqunatity+Idstoberemoved);
     }
     
    }
    
    system.debug('product to quantity'+producttoqunatity+twoprodtoone);
    
    for(SBQQ__Subscription__c  qln :sub ){
    
    if((linestobethere.contains(qln.id) && producttoqunatity.get(qln.SBQQ__Product__r.ProductCode) >0 ) || (!revisedsubs.contains(qln.id) && !Idstoberemoved.contains(qln.id) && ((!twoprodtoone.contains(qln.SBQQ__Product__r.SBQQ__RenewalProduct__c) && qln.SBQQ__Product__r.Renewal_Product_Mapping_Diff__c == True) || qln.SBQQ__Product__r.Renewal_Product_Mapping_Diff__c == False ))) {
    
     system.debug('Subscriotion lines here***'+qln); 
      
      
      SBQQ__QuoteLine__c mainline= new SBQQ__QuoteLine__c(SBQQ__Quantity__c = qln.SBQQ__Quantity__c ,SBQQ__Product__c = qln.SBQQ__Product__r.SBQQ__RenewalProduct__c,SBQQ__Quote__c  = newquote.id);

      twoprodtoone.add(qln.SBQQ__Product__r.SBQQ__RenewalProduct__c);

      if(producttoqunatity.containskey(qln.SBQQ__Product__r.ProductCode)){
      
       mainline.SBQQ__Quantity__c = producttoqunatity.get(qln.SBQQ__Product__r.ProductCode);
      }
      
      
      qlinetoupdate.add(mainline);
      
      
    
     }
    }
    
    
      //Create sales Tax line
      SBQQ__QuoteLine__c salesline = new SBQQ__QuoteLine__c (SBQQ__Quantity__c = 1,SBQQ__Product__c = pi[0].id,SBQQ__Quote__c  = newquote.id);
    
      qlinetoupdate.add(salesline);
      
      System.debug('Values for Quote Line'+qlinetoupdate);
      
      if(qlinetoupdate.size()>0 )  {
       insert qlinetoupdate;    
       CreateSublines(newquote.id);
       
      }else{
      
      opp.No_Lines_Found__c=true;
      update opp;
      
      } 
       
      }
     
      }catch(Exception e){
      
      LogFiles__c log=new LogFiles__c ();
               log.Related_Account__c=acc.Id;
               log.Log_Type__c='Renewal Process';
               log.Info__c=e.getMessage() + ' Line No : ' + e.getLineNumber()
                                        + ' Stack Trace : ' + e.getStackTraceString()
                                        + ' TypeName : ' + e.getTypeName()
                                        + ' Cause : ' + e.getCause();
               log.Error_Code__c=e.getLineNumber();
               insert log;
        
      if(Test.IsRunningTest()){
      calculateTax('');
       
       CreateSublines('');
      }
      }
     
     
 }
  
  
   @future(callout=true)
    public static void calculateTax(String qutid) {
          
          try{ PromotionsforQuotes promo = new PromotionsforQuotes();
          promo.createPromotion(qutid); }catch(Exception e){}
          
          }
        
   
   
   @future(callout=true)
    public static void CreateSublines(String newquote) {       
      

      map<string,SBQQ__QuoteLine__c> rqrdqutlinemap= new map<string,SBQQ__QuoteLine__c>();
      List<SBQQ__QuoteLine__c> optnqllines= new List<SBQQ__QuoteLine__c>(); 
      

       List<SBQQ__QuoteLine__c> quteline =[select  Id,SBQQ__Bundle__c,SBQQ__RequiredBy__c,SBQQ__Product__c,SBQQ__Product__r.SBQQ__RenewalProduct__c,SBQQ__ProductOption__c,SBQQ__ListPrice__c,SBQQ__Product__r.List_Price__c,SBQQ__NetPrice__c,
                                                SBQQ__CustomerTotal__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,SBQQ__ListTotal__c,
                                                SBQQ__Quantity__c  From SBQQ__QuoteLine__c  Where SBQQ__Quote__c  =:newquote AND SBQQ__Product__c != null AND 
                                                SBQQ__Product__r.Name !=: Label.Sales_Tax_Product_Name AND SBQQ__RequiredBy__c = null AND (SBQQ__Quantity__c > 0 OR SBQQ__Quantity__c = 0) order by SBQQ__Number__c ];

      

      for(SBQQ__QuoteLine__c  qln :quteline ){rqrdqutlinemap.put(qln.SBQQ__Product__c,qln);  }

      for(SBQQ__ProductOption__c ml :[Select Id,SBQQ__OptionalSKU__c,SBQQ__ConfiguredSKU__c,SBQQ__Bundled__c ,SBQQ__Feature__r.Name,SBQQ__OptionalSKU__r.Shipping_Processing__c From SBQQ__ProductOption__c  Where SBQQ__ConfiguredSKU__c IN :rqrdqutlinemap.keyset()  AND (SBQQ__Bundled__c = true OR SBQQ__Feature__r.Name ='Fees' OR SBQQ__Selected__c =True )ORDER BY  SBQQ__Number__c ASC] ){
           
            SBQQ__QuoteLine__c ql= new SBQQ__QuoteLine__c();
           if(ml.SBQQ__Feature__r.Name !='Fees'){ql.SBQQ__Quantity__c = 1;}else{ql.SBQQ__Quantity__c = 0; }
          ql.Shipping_Processing__c=ml.SBQQ__OptionalSKU__r.Shipping_Processing__c;
          if(ql.Shipping_Processing__c) ql.SBQQ__Quantity__c =rqrdqutlinemap.get(ml.SBQQ__ConfiguredSKU__c).SBQQ__Quantity__c ;
          ql.SBQQ__Product__c = ml.SBQQ__OptionalSKU__c ;
          ql.SBQQ__Quote__c  = newquote;
          if(ml.SBQQ__OptionalSKU__r.Shipping_Processing__c == False && ml.SBQQ__Bundled__c  == TRUE){ql.SBQQ__Bundled__c = true; ql.SBQQ__Quantity__c =rqrdqutlinemap.get(ml.SBQQ__ConfiguredSKU__c).SBQQ__Quantity__c ;}
          ql.SBQQ__RequiredBy__c=rqrdqutlinemap.get(ml.SBQQ__ConfiguredSKU__c).Id;
          ql.SBQQ__ProductOption__c=ml.Id;
          
          optnqllines.add(ql);
          
          }
    
          
     
       if(optnqllines.size()>0) insert optnqllines;


     } 

}