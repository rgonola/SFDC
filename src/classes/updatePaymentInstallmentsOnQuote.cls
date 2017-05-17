public with sharing class updatePaymentInstallmentsOnQuote {
private static String formatCurrency(Decimal i) {
    if (i == null) return '0.00';
    i = Decimal.valueOf(Math.roundToLong(i * 100)) / 100;
    String s = (i.setScale(2) + (i >= 0 ? 0.001 : -0.001)).format();
    return s.substring(0, s.length() - 1);
}
    public static void updateQuotes(Set<Id> quoteIds) {
        Id curId = null;
        string payments='';
        Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c>([select id,Payment_Details__c,Payment_Details_rt__c from SBQQ__Quote__c where id in : quoteIds]);
        for(invoiceit_s__Payment_Plan_Installment__c ppi : [Select i.invoiceit_s__Payment_Type__c, i.invoiceit_s__Payment_Date__c, 
                                                            i.invoiceit_s__Payment_Amount__c, i.QTC__Quote__c, i.Payment_Method1__r.Last_4_Digits__c, 
                                                            i.Payment_Method1__r.invoiceit_s__Payment_Method__c, i.Payment_Method1__r.invoiceit_s__Card_Number__c, 
                                                            i.Payment_Method1__r.Name, i.Payment_Method1__c, i.Id From invoiceit_s__Payment_Plan_Installment__c i
                                                            where i.QTC__Quote__c in :quoteIds
                                                            order by i.QTC__Quote__c,i.invoiceit_s__Payment_Date__c]) {
            if(curId == null || curId != ppi.QTC__Quote__c) {
                if(curId!=null)
                    quoteMap.get(curId).Payment_Details__c = payments+'</table>';
                payments='<table border="1" cellpadding="1" cellspacing="1" style="width:350px;border: 1px solid #E6E6E6;">';
                curId=ppi.QTC__Quote__c;
            }
                payments += '<tr><td  style="width: 50px;"><span style="font-size:10px;">'+ppi.invoiceit_s__Payment_Date__c.format()+'</span></td><td style="width: 250px;"><span style="font-size:10px;">';
            if(ppi.invoiceit_s__Payment_Type__c=='Credit Card')
                payments += ppi.invoiceit_s__Payment_Type__c + ' ending in '+ ppi.Payment_Method1__r.invoiceit_s__Card_Number__c;
            else if(ppi.invoiceit_s__Payment_Type__c=='ACH')
                payments += ppi.invoiceit_s__Payment_Type__c + ' ending in '+ ppi.Payment_Method1__r.Last_4_Digits__c;
            payments += '</span></td><td align="right" style="width: 50px;"><span style="font-size:10px;">  $'+formatCurrency(ppi.invoiceit_s__Payment_Amount__c) + '</span></td></tr>';
                                                                    
        }
        payments+='</table>';
        if(curId != null)
            quoteMap.get(curId).Payment_Details_rt__c = payments;
        update quoteMap.values();
    }
}