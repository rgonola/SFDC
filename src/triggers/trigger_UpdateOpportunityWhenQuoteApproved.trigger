trigger trigger_UpdateOpportunityWhenQuoteApproved on SBQQ__Quote__c (after update) {
    Set<Id> oppIds = new Set<Id>();
    Map<Id,Decimal> Newsalesamount= new Map<Id,Decimal>();
    Map<Id,Decimal> twelvemonthamount= new Map<Id,Decimal>();
    List<Opportunity> opptoupdate = new List<Opportunity>();
    
    
    // Logic for update New sales amount from quote to Opportunity
    for(SBQQ__Quote__c q: trigger.new){
     system.debug('new ql amount here'+q.QL_New_Amount__c +q.SBQQ__Opportunity2__c +q.Opportunity_Type__c +q.Net_Minus_Tax_Fees__c);
     
     if((q.QL_New_Amount__c !=0 && q.QL_New_Amount__c !=null && q.SBQQ__Opportunity2__c != null )&& (q.Opportunity_Type__c =='Renewal')){
    
    Newsalesamount.put(q.SBQQ__Opportunity2__c,q.QL_New_Amount__c);
    twelvemonthamount.put(q.SBQQ__Opportunity2__c,q.X12_Month_Value__c);
     system.debug('new ql amount here'+q.QL_New_Amount__c);
     
    
    }else if(q.Net_Minus_Tax_Fees__c !=0 && q.SBQQ__Opportunity2__c != null  && (q.Opportunity_Type__c =='New Sale To New Customer' || q.Opportunity_Type__c =='New Sale To Existing Customer' || q.Opportunity_Type__c =='Renewal')){
    
    Newsalesamount.put(q.SBQQ__Opportunity2__c,q.Net_Minus_Tax_Fees__c);
    twelvemonthamount.put(q.SBQQ__Opportunity2__c,q.X12_Month_Value__c);
    
    }
    
    }
    
    if(Newsalesamount.size() > 0){
    List<Opportunity> oppty =[select Id,New_Sales_Amount__c,Renew_Sales_Amount__c,Type,Amount,SBQQ__PrimaryQuote__r.QL_New_Amount__c,SBQQ__PrimaryQuote__r.Net_Minus_Tax_Fees__c from Opportunity where Id in : Newsalesamount.keyset()];
    
    for(Opportunity p : oppty ){
    
    if(p.Type =='New Sale To New Customer' || p.Type =='New Sale To Existing Customer'){
    
    p.New_Sales_Amount__c = Newsalesamount.get(p.id)+twelvemonthamount.get(p.id);
    opptoupdate.add(p);
    
    }else if( p.Type =='Renewal'){
    
     system.debug('new ql amount here'+p.SBQQ__PrimaryQuote__r.QL_New_Amount__c);
     
    if(p.SBQQ__PrimaryQuote__r.QL_New_Amount__c != 0 && p.SBQQ__PrimaryQuote__r.QL_New_Amount__c !=null){
    p.New_Sales_Amount__c = Newsalesamount.get(p.id)+twelvemonthamount.get(p.id);
    if(twelvemonthamount.get(p.id) >0 ){
    p.Renew_Sales_Amount__c=p.New_Sales_Amount__c;
    }else{
    p.Renew_Sales_Amount__c=p.Amount-p.New_Sales_Amount__c;
    }
    opptoupdate.add(p);
    
     }else{
     
     system.debug('new ql amount here'+p.SBQQ__PrimaryQuote__r.Net_Minus_Tax_Fees__c);
     if(p.Type !='Renewal'){
     p.New_Sales_Amount__c = Newsalesamount.get(p.id)+twelvemonthamount.get(p.id);
     p.Renew_Sales_Amount__c=0;
     opptoupdate.add(p);
      }else{
      p.Renew_Sales_Amount__c= Newsalesamount.get(p.id);
     p.New_Sales_Amount__c =0;
     opptoupdate.add(p);
      
      }
     }
     
     
     
    }
    }
    
    
    if(opptoupdate.size()>0)
    update opptoupdate;
    }
    
}