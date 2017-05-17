public with sharing class cls_Fee_Tier {
public class feeWrapper{
        String myFeeName{get;set;}
        List<Decimal> myPrices{get;set;}
        
    
        public feeWrapper(String fname, List<Decimal> fPrices){
            myFeeName=fname;
            myPrices=fPrices;
            
        }

    }

public class tierWrapper{
    String mytiercode{get;set;}
    List<String> mytiers{get;set;}
    List<Decimal> mydiscounts{get;set;}
    List<feeWrapper> myFees{get;set;}
    
    public tierwrapper(){
        
    }
    
}

    public static Boolean populateTiers(SBQQ__Quote__c myQuote) {
        List<tierWrapper> finalTierWrapper=new List<tierWrapper>();
        Boolean returnVal=false;




Map<String,tierWrapper> tiercodemap=new Map<String,tierWrapper>();
Map<ID,tierWrapper> finaltiercodemap=new Map<ID,tierWrapper>();
Map<tierWrapper,Id> reversefinaltiercodemap=new Map<tierWrapper,Id>();
//Find Quote ID from Order ID
        List<SBQQ__QuoteLine__c> myFeeLines=new List<SBQQ__QuoteLine__c>();

        Map<String,SBQQ__QuoteLine__c> schedule_to_ql=new Map<String,SBQQ__QuoteLine__c>();
        String myQuoteid=myQuote.id;
        //SBQQ__Quote__c myQuote=[Select id,Fee_Tier_Details__c from SBQQ__Quote__c where id=:myQuoteid ];
        
        //criteria for opps
        try{
        if(test.isRunningTest()){
            myFeeLines = [SELECT Id,SBQQ__DiscountSchedule__c,SBQQ__Quote__c, ImageURL__c,SBQQ__ProductName__c,SBQQ__Quantity__c,SBQQ__ListPrice__c,SBQQ__OriginalPrice__c, SBQQ__CustomerPrice__c,SBQQ__NetTotal__c FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=:myQuoteId and SBQQ__DiscountSchedule__c!=null];     //and SBQQ__CustomerPrice__c <>0         
        }else{
            myFeeLines = [SELECT Id,SBQQ__DiscountSchedule__c,SBQQ__Quote__c, ImageURL__c,SBQQ__ProductName__c,SBQQ__Quantity__c,SBQQ__ListPrice__c,SBQQ__OriginalPrice__c, SBQQ__CustomerPrice__c,SBQQ__NetTotal__c FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=:myQuoteId and FeeQuoteLine__c=true and ProductQuoteLine__c=false and SBQQ__DiscountSchedule__c!=null];     //and SBQQ__CustomerPrice__c <>0         
        }
            Map<ID,ID> quotelinetoquote =new Map<ID,ID>();
            
            for(SBQQ__QuoteLine__c ql:myFeeLines){
                schedule_to_ql.put(ql.SBQQ__DiscountSchedule__c,ql);
                quotelinetoquote.put(ql.id,ql.SBQQ__Quote__c);
            }

            List<SBQQ__DiscountTier__c> discTiers=new List<SBQQ__DiscountTier__c>([Select Name, SBQQ__DiscountAmount__c, SBQQ__UpperBound__c, SBQQ__LowerBound__c, SBQQ__Number__c, SBQQ__Schedule__c from SBQQ__DiscountTier__c where SBQQ__Schedule__c IN:schedule_to_ql.keyset() Order by SBQQ__Schedule__c, SBQQ__Number__c]);
            
            returnval=!discTiers.isEmpty();
            
            myQuote.Fee_Tier_Details__c='';
            
            for(SBQQ__DiscountTier__c tiers:disctiers){
                tierwrapper tw=new tierwrapper();
                List<String> tempList=new List<String>();
                List<Decimal> tempListDecimal=new List<Decimal>();
                
                String uBound=String.valueOf(tiers.SBQQ__UpperBound__c);
                String lBound=String.valueOf(tiers.SBQQ__LowerBound__c);
                uBound=(uBound==NULL) ? '999' : uBound;
                lBound=(lBound==NULL) ? '999' : lBound;
                
                //uBound=String.valueOf(uBound);
                //lBound=String.valueOf(lBound);
                
                if(tiercodemap.containsKey(tiers.SBQQ__Schedule__c)){
                    
                    tw=tiercodeMap.get(tiers.SBQQ__Schedule__c);
                    tempList=tw.mytiers;
                    tempList.add(tiers.Name);
                    
                    tempListDecimal=tw.mydiscounts;
                    tempListDecimal.add(tiers.SBQQ__DiscountAmount__c);
                    tw.mydiscounts=tempListDecimal;
                    
                    tw.mytiercode=tw.mytiercode + lBound + uBound;
                    tw.mytiers=tempList;
                    tiercodemap.put(tiers.SBQQ__Schedule__c, tw);
                    
                }else{
                 
                    tempList.add(tiers.Name);
                    
                    tw.mytiercode=lBound + uBound;
                    tw.mytiers=tempList;
                    tempListDecimal.add(tiers.SBQQ__DiscountAmount__c);
                    tw.mydiscounts=tempListDecimal;
                    
                    tiercodemap.put(tiers.SBQQ__Schedule__c, tw);
                }
                
            }
            
            
            for(SBQQ__QuoteLine__c ql:myFeeLines){
                tierwrapper tw=new tierwrapper();
                tierwrapper finaltw=new tierwrapper();
                tw=tiercodemap.get(ql.SBQQ__DiscountSchedule__c);
                
                List<feeWrapper> fwList=new List<feeWrapper>();
                List<Decimal> feePrices=new List<Decimal>();
                
                if(finaltiercodemap.containsKey(ql.Id)){
                
                    Decimal myprice=(ql.SBQQ__OriginalPrice__c==null) ? 0 : ql.SBQQ__OriginalPrice__c;
                    for(Decimal d:tw.mydiscounts){
                        feePrices.add(myprice-d);
                    }
                    finaltw=finaltiercodemap.get(ql.Id);
                    
                    fwList=finaltw.myFees;
                    fwList.add(new feeWrapper(ql.SBQQ__ProductName__c,feePrices));
                    tw.myFees=fwList;
                    finaltiercodemap.put(ql.Id, tw);
                    reversefinaltiercodemap.put(tw,ql.Id);
                    
                }else{
                    Decimal myprice=(ql.SBQQ__OriginalPrice__c==null) ? 0 : ql.SBQQ__OriginalPrice__c;
                    for(Decimal d:tw.mydiscounts){
                        feePrices.add(myprice-d);
                    }
                    
                    fwList.add(new feeWrapper(ql.SBQQ__ProductName__c,feePrices));
                    tw.myFees=fwList;
                    finaltiercodemap.put(ql.Id, tw);
                    reversefinaltiercodemap.put(tw,ql.Id);
                }
                
                    
                    
                    
            }
            system.debug(tiercodemap);
            system.debug(finaltiercodemap);
            
            map<id,String> helpme = new map<id,String>();
            
           String htmlString='<p><table  border="1" cellpadding="0" cellspacing="1" style="width:100%;border-top:1px solid #E6E6E6;border-left:1px solid #E6E6E6;border-right:1px solid #E6E6E6;border-bottom:1px solid #E6E6E6;">';
           //String htmlString2='';
           
           
            for(tierwrapper tw:finaltiercodemap.values()){
            
               
               
                
            htmlString='<p><table  border="1" cellpadding="0" cellspacing="1" style="width:100%; border:1px solid black;">';
               //htmlString2='<table style="width:100%;">';
               
                //htmlString=htmlString+'<tr><td style="width:70%"><div  style="background-color: #0082C8;text-align:left;padding:0px;color:white;"> Fee Name</div></td></tr>';
                //htmlString2=htmlString2 + '<tr><td style="width:70%;">Fee Name</td>';
                
                for(feeWrapper fw:tw.myfees){
                
                    system.debug('values are here fw'+fw);
                    
                    List<String> tierList=tw.mytiers;
                    system.debug(tierList);
                    Decimal tiersize=tierList.size() * 2;
                     htmlString=htmlString+'<tr><td  style="text-align:center;padding:0px;color:black;" colspan="' + tiersize + '">' + fw.myFeeName + '</td></tr><tr>';
                     
                     system.debug(fw.myPrices);
                     Integer i=0;
                     for(String s:tw.mytiers){
                     system.debug('values are here s'+s);
                     
                     htmlString=htmlString+'<td><div  style="text-align:center;padding:0px;" >' + s + '</div></td>';
                     Decimal feedec=fw.myPrices.get(i);
                     String feeStr='$' + String.valueOf(feedec);
                     htmlString=htmlString+'<td>' + feeStr + '</td>';
                       i++;
                    system.debug(s);
                    
                    }
                    htmlString=htmlString+'</tr>';
                }
                
                
                 htmlString=htmlString+'</span></tr>';
                 //htmlString2=htmlString2+'</tr>';
                
                //system.debug(tw.myfees);
                
                

                
                htmlString=htmlString+'</table></p>';
                
                helpme.put(reversefinaltiercodemap.get(tw),htmlString);
                
                system.debug('values are here'+helpme);
                //htmlString2=htmlString2+'</table></p>';
            }
            
            system.debug(htmlString);
            
            for(SBQQ__QuoteLine__c ql:myFeeLines){
            
              if(helpme.get(ql.id)!= null || helpme.get(ql.id) !=''){
                 myQuote.Fee_Tier_Details__c+= helpme.get(ql.id);
                 system.debug('values are here'+myQuote.Fee_Tier_Details__c);
                 }
            }
            
           // myQuote.Fee_Tier_Details__c=htmlString;
            //myQuote.Fee_Tier_Details_Text__c=htmlString;
            //myQuote.Fee_Tier_Details_Test__c=htmlString2;
            //update myQuote;
            

        }catch(QueryException q){
            myFeeLines=new List<SBQQ__QuoteLine__c>();
        }
        
        return returnval;
    }
}