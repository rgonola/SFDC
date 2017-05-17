public class IIT_PopulateVSOEOnORPC {
    
    
    
    public static void populateVSOE(invoiceit_s__Job__c order){
        set<Id> productIds = new set<Id>();
        list<PricebookEntry> listOfPricebookEntry;
        map<Id, Decimal> map_productId_EntryVSOEPrice = new map<Id, Decimal>();
        map<Id, Decimal> map_BundleId_TotalVSOEPrice = new map<Id, Decimal>();
        list<invoiceit_s__Job_Rate_Plan_Charge__c> listOrderRatePlanCharge = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
        list<invoiceit_s__Job_Rate_Plan_Charge__c> listOrderRatePlanChargeisExist = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
        
        listOrderRatePlanCharge = [SELECT Id,QTC__Quote_Line__r.SBQQ__Product__c,invoiceit_s__VSOE_Pricing__c,invoiceit_s__Quantity__c,invoiceit_s__VSOE_Total__c,invoiceit_s__VSOE_Package_Total__c,invoiceit_s__Required_By__c,invoiceit_s__Bundle__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE invoiceit_s__Order__c =: order.id];
        System.debug('listOrderRatePlanCharge listOrderRatePlanCharge  --->'+listOrderRatePlanCharge.size());
        for(invoiceit_s__Job_Rate_Plan_Charge__c orpc : listOrderRatePlanCharge){
            productIds.add(orpc.QTC__Quote_Line__r.SBQQ__Product__c);
        }
        listOrderRatePlanChargeisExist = [SELECT Id,QTC__Quote_Line__r.SBQQ__Product__c,invoiceit_s__VSOE_Pricing__c,invoiceit_s__Quantity__c,invoiceit_s__VSOE_Total__c,invoiceit_s__VSOE_Package_Total__c,invoiceit_s__Required_By__c,invoiceit_s__Bundle__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE Id IN:listOrderRatePlanCharge 
                                          AND invoiceit_s__Required_By__c != null
                                          AND invoiceit_s__Bundle__c = true];
        System.debug('listOrderRatePlanChargeisExist listOrderRatePlanChargeisExist --->'+listOrderRatePlanChargeisExist.size() );   
                                       
        if(!listOrderRatePlanChargeisExist.isEmpty()) {
            listOfPricebookEntry = [SELECT Id,IsActive,Name,Product2Id,QTC__VSOE_Price__c FROM PricebookEntry
                                    WHERE Product2Id In: productIds 
                                    AND Pricebook2Id =: order.QTC__Opportunity__r.SBQQ__PrimaryQuote__r.SBQQ__PriceBook__c];
        }
        for(PricebookEntry pricebookEntryObj : listOfPricebookEntry ) {
            if(pricebookEntryObj.QTC__VSOE_Price__c != null)
                 map_productId_EntryVSOEPrice.put(pricebookEntryObj.Product2Id, pricebookEntryObj.QTC__VSOE_Price__c);
        }  
        for(invoiceit_s__Job_Rate_Plan_Charge__c orpc : listOrderRatePlanCharge) {
            if(map_productId_EntryVSOEPrice.containskey(orpc.QTC__Quote_Line__r.SBQQ__Product__c)) {
                orpc.invoiceit_s__VSOE_Pricing__c = map_productId_EntryVSOEPrice.get(orpc.QTC__Quote_Line__r.SBQQ__Product__c);
                orpc.invoiceit_s__VSOE_Total__c = orpc.invoiceit_s__VSOE_Pricing__c * orpc.invoiceit_s__Quantity__c;
            }
        }
        update  listOrderRatePlanCharge;

        AggregateResult[] groupQuantity = [SELECT SUM(invoiceit_s__VSOE_Total__c) vsoepriceSum,  invoiceit_s__Required_By__c parentBundleId
                                           FROM invoiceit_s__Job_Rate_Plan_Charge__c 
                                           WHERE Id IN: listOrderRatePlanCharge
                                           AND
                                           invoiceit_s__Required_By__c != null
                                           AND invoiceit_s__Bundle__c = true
                                           GROUP BY invoiceit_s__Required_By__c
                                           ];
        for(AggregateResult aggResult : groupQuantity ) {
            map_BundleId_TotalVSOEPrice.put((Id)aggResult.get('parentBundleId'), (decimal)aggResult.get('vsoepriceSum'));
        }

        for (invoiceit_s__Job_Rate_Plan_Charge__c orderCharge : listOrderRatePlanCharge) {
            if(orderCharge.invoiceit_s__Required_By__c != null && map_BundleId_TotalVSOEPrice.containsKey(orderCharge.invoiceit_s__Required_By__c) && orderCharge.invoiceit_s__Bundle__c)
                orderCharge.invoiceit_s__VSOE_Package_Total__c = map_BundleId_TotalVSOEPrice.get(orderCharge.invoiceit_s__Required_By__c);
                orderCharge.VSOE_Status__c = 'Completed';
        }

        update  listOrderRatePlanCharge;
    }

}