trigger triggertax on SBQQ__Quote__c (after update) {

    if(trigger.size==1){
        for(SBQQ__Quote__c q:trigger.new){
            SBQQ__Quote__c oldQuote = Trigger.oldMap.get(q.ID);
               
                if( q.Calculate_Tax__c == True && oldQuote.Calculate_Tax__c == False && Triggerflag.firstRun ){ calculateTax.calltax(q.id);  Triggerflag.firstRun=false;  }
                
                PromotionsforQuotes pm= new PromotionsforQuotes();
                
                if( q.Apply_Promo__c== True && oldQuote.Apply_Promo__c== False && Triggerflag.firstRun ){ pm.createPromotion(q.id);  Triggerflag.firstRun=false;  }
                    
           }
           
      }     
      
      
      
  }