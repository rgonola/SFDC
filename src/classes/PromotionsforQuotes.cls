public class PromotionsforQuotes{
   
   
   public static String requestCall;
    public static String appType;
    public static invoiceit_s__Gateway__c gateway;
    
    
    public void createPromotion(String QuoteId){   
    
     Set<ID>substoprocess = new Set<Id>();
     map<String,String>twtoprocess = new map<String,String>();
     map<String,String> Mappromovalue=new map<String,String>();
     List<SBQQ__QuoteLine__c > coupontoadd=new List<SBQQ__QuoteLine__c >();
     
     List<SBQQ__QuoteLine__c> quoteline =[select  Id,SBQQ__Bundle__c,SBQQ__RequiredBy__c,SBQQ__Product__c,SBQQ__Product__r.SBQQ__RenewalProduct__c,SBQQ__ProductOption__c,SBQQ__ListPrice__c,SBQQ__Product__r.List_Price__c,SBQQ__NetPrice__c,
                                                SBQQ__CustomerTotal__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,SBQQ__ListTotal__c,Promotion__c ,SBQQ__Product__r.Pipeline_Designation__c,
                                                SBQQ__Quantity__c  From SBQQ__QuoteLine__c  Where SBQQ__Quote__c  =:QuoteId  AND SBQQ__Product__c != null AND 
                                                SBQQ__Product__r.Name != :Label.Sales_Tax_Product_Name AND SBQQ__RequiredBy__c = null AND (SBQQ__Quantity__c > 0 OR SBQQ__Quantity__c = 0) order by SBQQ__Number__c ];
     
     String coupon =label.ATX_EBD;
     String twcoupon = label.TW_EBD;  
     
      for(SBQQ__QuoteLine__c s: quoteline ){ 
          
           List<Promotion_Entry__c> cp =[Select Id,Active__c,Product__c,Price__c,Promo_Value__c,Promo_Code__c From Promotion_Entry__c where (Promo_Code__c =:coupon OR Promo_Code__c =:twcoupon) AND Active__c =true  AND Product__c =:s.SBQQ__Product__c AND Promo_Code__c !=null  ];
   
          if(cp.size()>0) if(cp[0].Promo_Value__c !=null ){ Mappromovalue.put(cp[0].Product__c,cp[0].Id);}
           
          //substoprocess.add(s.SBQQ__Product__c); 
          
      }
      
      system.debug(+substoprocess+coupon);
   
   
   
   for(SBQQ__QuoteLine__c qln: quoteline ){if(Mappromovalue.containskey(qln.SBQQ__Product__c)){qln.Promotion__c = Mappromovalue.get(qln.SBQQ__Product__c);coupontoadd.add(qln);} }
    
    
   if(coupontoadd.size()>0) update coupontoadd;
   
   
   
     
    }
    
    
    
    
 }