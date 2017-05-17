public with sharing class ATXTWQuotepdfgenerator{
Public List<SBQQ__Quote__c> qute {get;set;}
Public String qutstrt {get;set;}
Public String enddat{get;set;}
public Map<String,List<SBQQ__QuoteLine__c>> quteline {get;set;}
public Map<Id, SBQQ__QuoteLine__c> reqqutlns;
Public List<SBQQ__ProductOption__c> featureoptions{get;set;}
public String actid { get; set; }
public Boolean pagebrk{ get; set; }
public String ids { get; set; }
public Map<String,set<string>> mapfinaltcs {get;set;}
public Map<Id,Id> mapquoteids{get;set;}
public Map<Id, Account> accnt{get;set;}


  Public ATXTWQuotepdfgenerator(){
         
         pagebrk=false;
       
        PDF_Quote_Ids__c batchno = PDF_Quote_Ids__c.getInstance('Batch'); 
        string prcbkid = batchno.Batch_No__c;
       
        mapquoteids= new Map<Id, Id>();
        if(!Test.isrunningTest()){
        qute  =[select Id,SBQQ__StartDate__c,SBQQ__ExpirationDate__c,Account_CID__c,SBQQ__Account__c,SBQQ__NetAmount__c,SBQQ__SalesRep__r.Name,Name,Tax_Year_Version__c,
                        Net_Minus_Tax_Fees__c,Processing_Fees__c,Tax__c,SBQQ__CustomerAmount__c,SBQQ__TotalCustomerDiscountAmount__c from SBQQ__Quote__c 
                        where Batch_Print__c =:prcbkid  AND SBQQ__Primary__c =true order by CreatedDate desc ]; 
                       // where ID=:actid AND SBQQ__Primary__c =true order by CreatedDate desc ];
        }else{
        string actid = ApexPages.currentPage().getParameters().get( 'accuntId');
        
        qute  =[select Id,SBQQ__StartDate__c,SBQQ__ExpirationDate__c,SBQQ__Account__c,SBQQ__NetAmount__c,SBQQ__SalesRep__r.Name,Name,Tax_Year_Version__c,
                        Net_Minus_Tax_Fees__c,Processing_Fees__c,Tax__c,SBQQ__CustomerAmount__c,SBQQ__TotalCustomerDiscountAmount__c from SBQQ__Quote__c 
                        where Id =:actid  AND SBQQ__Primary__c =true order by CreatedDate desc ];
        
        
        }
        
        for(SBQQ__Quote__c q :qute){
        system.debug('qute'+q);
        if(q.SBQQ__StartDate__c !=null){
         Date stdt= date.newinstance(q.SBQQ__StartDate__c.year(), q.SBQQ__StartDate__c.month(), q.SBQQ__StartDate__c.day()); 
         
         qutstrt =stdt.format();
         }
        
        system.debug('q'+qutstrt );
        if(q.SBQQ__ExpirationDate__c!=null){
        Date endt= date.newinstance(q.SBQQ__ExpirationDate__c.year(), q.SBQQ__ExpirationDate__c.month(), q.SBQQ__ExpirationDate__c.day()); 
        
         enddat=endt.format();
         }
         mapquoteids.put(q.id,q.SBQQ__Account__c);
         }
        system.debug('qute'+enddat);
        accnt = new Map<Id,Account>([select Id,Name,Primary_Contact_Name__c,CID__c,BillingStreet,Billingcity,Billing_Address_2__c,Shipping_Address_2__c,BillingState,Billingpostalcode,BillingCountry,ShippingStreet,shippingcity,shippingState,shippingpostalcode,shippingCountry From Account Where id IN: mapquoteids.values()]);
        
        system.debug('qute'+accnt );
        quteline =new Map<String,List<SBQQ__QuoteLine__c>>();
        Map<String,set<string>> TC= new Map<String,set<string>>();
        Map<String,string> maptogetbody= new Map<String,string>();
        Set<string> settcname=new set<string>();
        
        reqqutlns= new Map<Id, SBQQ__QuoteLine__c>( [select Id,SBQQ__Bundle__c,SBQQ__RequiredBy__c,SBQQ__ListPrice__c,SBQQ__NetPrice__c,SBQQ__Quote__r.Id,SBQQ__CustomerTotal__c,
                                                            SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.Marketing_Name__c,SBQQ__Product__r.Detail_description__c ,SBQQ__Product__r.Description,SBQQ__Product__r.T_Cs__c,SBQQ__ListTotal__c,SBQQ__Quantity__c,SBQQ__ProductOption__r.Feature_Name__c 
                                                            From SBQQ__QuoteLine__c  Where SBQQ__Quote__c IN :mapquoteids.keyset() AND (SBQQ__RequiredBy__c = null )   //OR SBQQ__Product__r.Shipping_Processing__c=true )
                                                            AND SBQQ__Product__r.Name != 'Sales Tax' order by SBQQ__Number__c ]);
         
         if(reqqutlns.size()>2 || reqqutlns.size()<5){
         
         pagebrk=true;
         }
         
         
        for(SBQQ__QuoteLine__c  qt: reqqutlns.values()){
            
           if(qt.SBQQ__Product__r.T_Cs__c!=null){
           settcname.addAll(qt.SBQQ__Product__r.T_Cs__c.split(';'));
           }
           
           if(!TC.containsKey(qt.SBQQ__Quote__c )){
           
           if(qt.SBQQ__Product__r.T_Cs__c!=null){
           
           Set<string> qtc =new set<string>();
           qtc.addAll(qt.SBQQ__Product__r.T_Cs__c.split(';'));
            TC.put(qt.SBQQ__Quote__c ,qtc);
            }
            }else{
            if(qt.SBQQ__Product__r.T_Cs__c!=null){
           TC.get(qt.SBQQ__Quote__c ).addAll(qt.SBQQ__Product__r.T_Cs__c.split(';'));
            }
                }
          
                if(!quteline .containsKey(qt.SBQQ__Quote__c ))
                    quteline .put(qt.SBQQ__Quote__c , new List<SBQQ__QuoteLine__c>{qt});
                else 
                    quteline .get(qt.SBQQ__Quote__c ).add(qt);
             

        }
        
       for(SBQQ__QuoteTerm__c sqtcs :[ Select id,TC_Name__c,SBQQ__Body__c From SBQQ__QuoteTerm__c where TC_Name__c IN :settcname]){

       maptogetbody.put(sqtcs.TC_Name__c,sqtcs.SBQQ__Body__c);




       }
        
       mapfinaltcs= new Map<String,set<string>>(); 
       for(string t :TC.Keyset()){

      for(string t1: TC.get(t)){

       if(!mapfinaltcs.containsKey(t ))
                mapfinaltcs .put(t , new set<string>{maptogetbody.get(t1)});
            else 
                mapfinaltcs .get(t ).add(maptogetbody.get(t1));


      }
      }
      
      for(SBQQ__Quote__c q :qute){
        
        if(!quteline.containsKey(q.id ) ){
        
        quteline.put(q.Id, new List<SBQQ__QuoteLine__c>());
        system.debug('****'+reqqutlns);

        }
        if(!mapfinaltcs.containsKey(q.id )){
         mapfinaltcs .put(q.id , new set<string>());
        }

        }
}
    
    
    
    
     /*Public void SaveAttach(){
  
  
            PageReference pdf = Page.ATXTWQuote;
        // create the new attachment
        Attachment attach = new Attachment();
    
        // the contents of the attachment from the pdf
        Blob body;
    
        try {
    
            // returns the output of the page as a PDF
            body = pdf.getContent();
    
        // need to pass unit test -- current bug    
        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }
    
        attach.Body = body;
        // add the user entered name
        attach.Name = 'test';
        attach.IsPrivate = false;
        // attach the pdf to the account
        attach.ParentId = actid ;
        insert attach;
  
  }*/

}