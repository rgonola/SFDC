trigger Fee_Tier_Trigger on SBQQ__Quote__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) {

        if (Trigger.isBefore && Trigger.isUpdate && Trigger.size==1) {
            //call your handler.before method
            for(SBQQ__Quote__c quote:trigger.new){
            
            quote.Has_Fee_Tier__c=cls_Fee_Tier.populateTiers(quote);
            }
        
        } else if (Trigger.isAfter) {
            //call handler.after method
        
        }
}