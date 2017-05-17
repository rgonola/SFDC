trigger trigger_UpdatePaymentInstallmentsOnQuote on invoiceit_s__Payment_Plan_Installment__c (after insert, after update, before delete) {
	Set<Id> quoteIds = new Set<Id>();
	if(trigger.isDelete) {
		for(invoiceit_s__Payment_Plan_Installment__c ppi : trigger.old)
			if(ppi.QTC__Quote__c != null) quoteIds.add(ppi.QTC__Quote__c);
	} else {
		for(invoiceit_s__Payment_Plan_Installment__c ppi : trigger.new)
			if(ppi.QTC__Quote__c != null) quoteIds.add(ppi.QTC__Quote__c);
		
	}
	updatePaymentInstallmentsOnQuote.updateQuotes(quoteIds);
}