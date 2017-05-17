public with sharing class QuotePDF {
Public SBQQ__Quote__c qute {get;set;}
Public Account accnt {get;set;}
Public String qutstrt {get;set;}
public Map<String,List<SBQQ__QuoteLine__c>> qtl{get;set;}
Public String enddat{get;set;}
public Map<String,set<string>> mapfinaltcs {get;set;}
Public List<SBQQ__QuoteLine__c> quteline {get;set;}
//Public List<SBQQ__ProductOption__c> featureoptions{get;set;}
public String actid { get; set; }
Public QuotePDF(){

        actid = ApexPages.currentPage().getParameters().get( 'accuntId');
        
        qute =[select Id,SBQQ__StartDate__c,SBQQ__ExpirationDate__c,SBQQ__Account__c,SBQQ__NetAmount__c,SBQQ__SalesRep__r.Name,Name,Tax_Year_Version__c,
                        Net_Minus_Tax_Fees__c,Processing_Fees__c,Tax__c,SBQQ__CustomerAmount__c,SBQQ__TotalCustomerDiscountAmount__c from SBQQ__Quote__c where SBQQ__Account__c =: actid AND SBQQ__Primary__c =true order by CreatedDate desc Limit 1 ];
        system.debug('qute'+qute);
        
        if(qute.SBQQ__StartDate__c !=null){
         Date stdt= date.newinstance(qute.SBQQ__StartDate__c.year(), qute.SBQQ__StartDate__c.month(), qute.SBQQ__StartDate__c.day()); 
         
         qutstrt =stdt.format();
         }
        
        system.debug('qute'+qutstrt );
        if(qute.SBQQ__ExpirationDate__c!=null){
        Date endt= date.newinstance(qute.SBQQ__ExpirationDate__c.year(), qute.SBQQ__ExpirationDate__c.month(), qute.SBQQ__ExpirationDate__c.day()); 
        
         enddat=endt.format();
         }
        
        system.debug('qute'+enddat);
        accnt =[select Id,Primary_Contact_Name__c,BillingStreet,Billingcity,BillingState,Billingpostalcode,BillingCountry,ShippingStreet,shippingcity,shippingState,shippingpostalcode,shippingCountry From Account Where id =:qute.SBQQ__Account__c];
        
        system.debug('qute'+accnt );
        quteline =[select Id,SBQQ__Bundle__c,SBQQ__Quote__c,SBQQ__RequiredBy__c,SBQQ__Product__r.Detail_description__c,SBQQ__Product__r.T_Cs__c,SBQQ__ListPrice__c,SBQQ__NetPrice__c,SBQQ__CustomerTotal__c,SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,SBQQ__ListTotal__c,SBQQ__Quantity__c  From SBQQ__QuoteLine__c  Where SBQQ__Quote__c = :qute.Id AND SBQQ__RequiredBy__c = null AND SBQQ__Product__r.Name != 'Sales Tax' order by SBQQ__Number__c ];
        
        system.debug(''+quteline );
      
      
      qtl =new Map<String,List<SBQQ__QuoteLine__c>>();
        Map<String,set<string>> TC= new Map<String,set<string>>();
        Map<String,string> maptogetbody= new Map<String,string>();
        Set<string> settcname=new set<string>();
        
        for(SBQQ__QuoteLine__c  qt: quteline ){
            
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
        
        if(!qtl.containsKey(qute.id ) ){
        qtl.put(qute.Id, new List<SBQQ__QuoteLine__c>());
        //system.debug('****'+reqqutlns);
        }
        if(!mapfinaltcs.containsKey(qute.id )){
         mapfinaltcs .put(qute.id , new set<string>());
        }


    }

}