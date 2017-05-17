public with sharing class Bulkpdfgenerator{
Public List<SBQQ__Quote__c> qute {get;set;}
Public String qutstrt {get;set;}
Public String enddat{get;set;}
public Map<String,List<SBQQ__QuoteLine__c>> quteline {get;set;}
private Map<Id, SBQQ__QuoteLine__c> reqqutlns;
Public List<SBQQ__ProductOption__c> featureoptions{get;set;}
public String actid { get; set; }
public Map<String,set<string>> mapfinaltcs {get;set;}
public Map<Id,Id> mapquoteids{get;set;}
public Map<Id, Account> accnt{get;set;}
Public Bulkpdfgenerator(){

       
        mapquoteids= new Map<Id, Id>();
        qute  =[select Id,SBQQ__StartDate__c,SBQQ__ExpirationDate__c,SBQQ__Account__c,SBQQ__NetAmount__c,SBQQ__SalesRep__r.Name,Name,Tax_Year_Version__c,
                        Net_Minus_Tax_Fees__c,Processing_Fees__c,Tax__c,SBQQ__CustomerAmount__c,SBQQ__TotalCustomerDiscountAmount__c from SBQQ__Quote__c 
                        where Id IN ('a1w2900000014Oo','a1w2900000014M5','a1w2900000014M6','a1w2900000014MM','a1w2900000014M7','a1w2900000014M8','a1w2900000014M9','a1w2900000014MA','a1w2900000014Ls','a1w2900000014Lb','a1w2900000014Lc','a1w2900000014Lu','a1w2900000014Lw','a1w2900000014Ld','a1w2900000014Lx','a1w2900000014Le','a1w2900000014Lf','a1w2900000014Ly','a1w2900000014Lg','a1w2900000014M0','a1w2900000014M2','a1w2900000014M3','a1w2900000014M4','a1w2900000014IL','a1w2900000014IT','a1w2900000014Iu','a1w2900000014Ja','a1w2900000014Ji','a1w2900000014Jj','a1w2900000014Jw','a1w2900000014K9','a1w2900000014KC','a1w2900000014KN','a1w2900000014Mc','a1w2900000014Md','a1w2900000014Me','a1w2900000014Ms','a1w2900000014Mf','a1w2900000014Mg','a1w2900000014Mu','a1w2900000014Mh','a1w2900000014MO','a1w2900000014MC','a1w2900000014MP','a1w2900000014MD','a1w2900000014MR','a1w2900000014ME','a1w2900000014MS','a1w2900000014Mh','a1w2900000014Mv','a1w2900000014MS','a1w2900000014MF','a1w2900000014MH','a1w2900000014MI','a1w2900000014MT','a1w2900000014MJ','a1w2900000014MU','a1w2900000014MK','a1w2900000014Os','a1w2900000014Mb','a1w2900000014MG','a1w2900000014Mx','a1w2900000014NF','a1w2900000014Nt','a1w2900000014OL','a1w2900000014OD','a1w2900000014OI','a1w2900000014OZ','a1w2900000014Lo','a1w2900000014Lp','a1w2900000014LX','a1w2900000014Lq','a1w2900000014LY','a1w2900000014Lr','a1w2900000014LZ','a1w2900000014Nw','a1w2900000014Nq','a1w2900000014O1','a1w2900000014PA','a1w2900000014Pj','a1w2900000014Oz','a1w2900000014I1','a1w2900000014I2','a1w2900000014I3','a1w2900000014I4','a1w2900000014I5','a1w2900000014I6','a1w2900000014I7','a1w2900000014I8','a1w2900000014Pj','a1w2900000014Po','a1w2900000014KX','a1w2900000014Hw','a1w2900000014Hx','a1w2900000014Hz','a1w2900000014I0','a1w2900000014I1','a1w2900000014Ln','a1w2900000014Lk','a1w2900000014LS','a1w2900000014LT','a1w2900000014Ll','a1w2900000014LU','a1w2900000014LW','a1w2900000014LL','a1w2900000014LM','a1w2900000014LN','a1w2900000014LO','a1w2900000014Lh','a1w2900000014LP','a1w2900000014Li','a1w2900000014Lj','a1w2900000014Kx','a1w2900000014LF','a1w2900000014Ky','a1w2900000014LG','a1w2900000014Kz','a1w2900000014LH','a1w2900000014LI','a1w2900000014LK','a1w2900000014LL','a1w2900000014Kt','a1w2900000014Ku','a1w2900000014LB','a1w2900000014LC','a1w2900000014Kv','a1w2900000014LD','a1w2900000014Kw','a1w2900000014LE','a1w2900000014Kx','a1w2900000014L5','a1w2900000014Kp','a1w2900000014L6','a1w2900000014Kq','a1w2900000014L7','a1w2900000014L8','a1w2900000014L9','a1w2900000014Ks','a1w2900000014Kt','a1w2900000014Jd','a1w2900000014Je','a1w2900000014Jv','a1w2900000014Jf','a1w2900000014Jg','a1w2900000014Jx','a1w2900000014Jh','a1w2900000014Jy','a1w2900000014Jz','a1w2900000014KA','a1w2900000014KP','a1w2900000014KB','a1w2900000014KQ','a1w2900000014KD','a1w2900000014KR','a1w2900000014KS','a1w2900000014KF','a1w2900000014Jz','a1w2900000014KF','a1w2900000014JM','a1w2900000014JN','a1w2900000014J4','a1w2900000014J5','a1w2900000014JO','a1w2900000014J6','a1w2900000014JP','a1w2900000014J7','a1w2900000014JQ','a1w2900000014J8','a1w2900000014JY','a1w2900000014JZ','a1w2900000014Jr','a1w2900000014Jb','a1w2900000014Js','a1w2900000014Jt','a1w2900000014Jc','a1w2900000014Ju','a1w2900000014KT','a1w2900000014KU','a1w2900000014KG','a1w2900000014KH','a1w2900000014KI','a1w2900000014KY','a1w2900000014KJ','a1w2900000014KZ','a1w2900000014Ka','a1w2900000014KK','a1w2900000014Kb','a1w2900000014Kc','a1w2900000014KL','a1w2900000014Kd','a1w2900000014KM','a1w2900000014Ke','a1w2900000014L0','a1w2900000014Km','a1w2900000014L1','a1w2900000014Kn','a1w2900000014L2','a1w2900000014L3','a1w2900000014Ko','a1w2900000014L4','a1w2900000014Lz','a1w2900000014KO','a1w2900000014L5','a1w2900000014Jo','a1w2900000014K4','a1w2900000014K5','a1w2900000014K6','a1w2900000014Jp','a1w2900000014Jq','a1w2900000014K7','a1w2900000014K8','a1w2900000014Jk','a1w2900000014K0','a1w2900000014Jl','a1w2900000014Jm','a1w2900000014K1','a1w2900000014Jn','a1w2900000014K2','a1w2900000014K3','a1w2900000014Jo','a1w2900000014KO','a1w2900000014Kf','a1w2900000014Kg','a1w2900000014Kh','a1w2900000014Ki','a1w2900000014Kj','a1w2900000014Kk','a1w2900000014Kl','a1w2900000014L0','a1w2900000014JE','a1w2900000014Iv','a1w2900000014JF','a1w2900000014Iw','a1w2900000014JG','a1w2900000014Ix','a1w2900000014JH','a1w2900000014Iy','a1w2900000014Iz','a1w2900000014IM','a1w2900000014If','a1w2900000014IO','a1w2900000014Ig','a1w2900000014IP','a1w2900000014Ih','a1w2900000014Ii','a1w2900000014IQ','a1w2900000014Ij','a1w2900000014Io','a1w2900000014Ip','a1w2900000014Iq','a1w2900000014Ir','a1w2900000014Is','a1w2900000014It','a1w2900000014JC','a1w2900000014JD','a1w2900000014JE','a1w2900000014II','a1w2900000014Ib','a1w2900000014IJ','a1w2900000014Ic','a1w2900000014IK','a1w2900000014Id','a1w2900000014Ie','a1w2900000014IM','a1w2900000014OZ','a1w2900000014Oh','a1w2900000014Oe','a1w2900000014Ok','a1w2900000014Om','a1w2900000014I8','a1w2900000014I9','a1w2900000014IU','a1w2900000014IA','a1w2900000014IV','a1w2900000014IB','a1w2900000014IW','a1w2900000014IC','a1w2900000014IX','a1w2900000014IY','a1w2900000014ID','a1w2900000014IZ','a1w2900000014IE','a1w2900000014Ia','a1w2900000014IH','a1w2900000014Ij','a1w2900000014IR','a1w2900000014Ik','a1w2900000014IS','a1w2900000014Il','a1w2900000014Im','a1w2900000014In','a1w2900000014Io','a1w2900000014J8','a1w2900000014J9','a1w2900000014JR','a1w2900000014JA','a1w2900000014JS','a1w2900000014JB','a1w2900000014JU','a1w2900000014JW','a1w2900000014JX','a1w2900000014JY','a1w2900000014JI','a1w2900000014J0','a1w2900000014JJ','a1w2900000014J1','a1w2900000014JK','a1w2900000014J2','a1w2900000014JL','a1w2900000014J3','a1w2900000014MK','a1w2900000014MV','a1w2900000014ML','a1w2900000014MW','a1w2900000014MX','a1w2900000014MY','a1w2900000014MZ','a1w2900000014Ma','a1w2900000014Mc','a1w2900000014NG','a1w2900000014NM','a1w2900000014NU','a1w2900000014NX','a1w2900000014NY','a1w2900000014IF','a1w2900000014IG','a1w2900000014NG','a1w2900000014KN','a1w2900000014N7','a1w2900000014KV','a1w2900000014NB','a1w2900000014KW','a1w2900000014LA','a1w2900000014LQ','a1w2900000014LV','a1w2900000014Lt','a1w2900000014Mn','a1w2900000014Mz','a1w2900000014Mo','a1w2900000014Mp','a1w2900000014N1','a1w2900000014N2','a1w2900000014N3','a1w2900000014N4','a1w2900000014Lv','a1w2900000014MB','a1w2900000014MN','a1w2900000014MQ','a1w2900000014Mk','a1w2900000014Mq','a1w2900000014Mr','a1w2900000014N4','a1w2900000014N9','a1w2900000014NA','a1w2900000014N5','a1w2900000014N6','a1w2900000014NC','a1w2900000014N8','a1w2900000014Kr','a1w2900000014Mb','a1w2900000014ND','a1w2900000014NE','a1w2900000014Mv','a1w2900000014Mw','a1w2900000014Mi','a1w2900000014Mj','a1w2900000014Ml','a1w2900000014Mm','a1w2900000014My','a1w2900000014Mn'
)AND SBQQ__Primary__c =true order by CreatedDate desc ];
        
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
        accnt = new Map<Id,Account>([select Id,Primary_Contact_Name__c,CID__c,BillingStreet,Billingcity,Billing_Address_2__c,Shipping_Address_2__c,BillingState,Billingpostalcode,BillingCountry,ShippingStreet,shippingcity,shippingState,shippingpostalcode,shippingCountry From Account Where id IN: mapquoteids.values()]);
        
        system.debug('qute'+accnt );
        quteline =new Map<String,List<SBQQ__QuoteLine__c>>();
        Map<String,set<string>> TC= new Map<String,set<string>>();
        Map<String,string> maptogetbody= new Map<String,string>();
        Set<string> settcname=new set<string>();
        
        reqqutlns= new Map<Id, SBQQ__QuoteLine__c>( [select Id,SBQQ__Bundle__c,SBQQ__RequiredBy__c,SBQQ__ListPrice__c,SBQQ__NetPrice__c,SBQQ__Quote__r.Id,SBQQ__CustomerTotal__c,
                                                            SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,SBQQ__Product__r.T_Cs__c,SBQQ__ListTotal__c,SBQQ__Quantity__c,SBQQ__ProductOption__r.Feature_Name__c 
                                                            From SBQQ__QuoteLine__c  Where SBQQ__Quote__c IN :mapquoteids.keyset() AND (SBQQ__RequiredBy__c = null OR SBQQ__ProductOption__r.Feature_Name__c ='FEES')
                                                            AND SBQQ__Product__r.Name != 'Sales Tax' order by SBQQ__Number__c ]);

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


}