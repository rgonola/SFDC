/*
    To re-run the VSOE calculation on the order rateplan 
    set<id> orderid = new set<id>();

    for(SBQQ__Quote__c q : [SELECT QTC__Order__c  FROM SBQQ__Quote__c  WHERE VSOE_Issue__c != '']) {
    orderid.add(q.QTC__Order__c);
    }
    
    IIT_BatchReRunVSOE job = new IIT_BatchReRunVSOE(orderid);
    Database.ExecuteBatch(job);
    
 */
global class IIT_BatchReRunVSOE implements Database.Batchable<sObject>, Database.Stateful {
    String query; 
    set<id> orderid = new set<id>();
    global IIT_BatchReRunVSOE(set<id> orderids){
        System.debug('Order IS sis '+orderids);
        orderid = orderids;
        query = 'SELECT Id,Name,QTC__Opportunity__r.SBQQ__PrimaryQuote__r.SBQQ__PriceBook__c FROM invoiceit_s__Job__c WHERE Id IN: orderid';
        System.debug('queryquery'+query);
    } 
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('ListOfRecords-->'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext BC, List<invoiceit_s__Job__c> scope) {       
        populateVSOE(scope[0]);         
    }

    global void finish(Database.BatchableContext BC) {

    }
    
    //We need to populate the order id
    public static void populateVSOE(invoiceit_s__Job__c order){
        set<Id> productIds = new set<Id>();
        list<PricebookEntry> listOfPricebookEntry;
        map<Id, Decimal> map_productId_EntryVSOEPrice = new map<Id, Decimal>();
        map<Id, Decimal> map_BundleId_TotalVSOEPrice = new map<Id, Decimal>();
        list<invoiceit_s__Job_Rate_Plan_Charge__c> listOrderRatePlanCharge = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
        list<invoiceit_s__Job_Rate_Plan_Charge__c> listOrderRatePlanChargeisExist = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
        
        System.debug('order.Id  --->'+order.Id);
        
        listOrderRatePlanCharge = [SELECT Id,QTC__Quote_Line__r.SBQQ__Product__c,invoiceit_s__VSOE_Pricing__c,invoiceit_s__Quantity__c,invoiceit_s__VSOE_Total__c,invoiceit_s__VSOE_Package_Total__c,invoiceit_s__Required_By__c,invoiceit_s__Bundle__c, QTC__Quote_Line__r.SBQQ__Bundled__c,
                                       (SELECT Id,invoiceit_s__Revenue_Recognition_Rule__c,invoiceit_s__Revenue_Recognition_Start_Date__c,invoiceit_s__Revenue_Recognition_Status__c 
                                       FROM invoiceit_s__Invoice_Lines__r WHERE invoiceit_s__Status__c != 'Cancelled') 
                                       FROM invoiceit_s__Job_Rate_Plan_Charge__c 
                                       WHERE invoiceit_s__Order__c =: order.id];
        System.debug('listOrderRatePlanCharge listOrderRatePlanCharge  --->'+listOrderRatePlanCharge.size());
        
        for(invoiceit_s__Job_Rate_Plan_Charge__c orpc : listOrderRatePlanCharge){
            productIds.add(orpc.QTC__Quote_Line__r.SBQQ__Product__c);
        }
        
        /*listOrderRatePlanChargeisExist = [SELECT Id,QTC__Quote_Line__r.SBQQ__Product__c,invoiceit_s__VSOE_Pricing__c,invoiceit_s__Quantity__c,invoiceit_s__VSOE_Total__c,invoiceit_s__VSOE_Package_Total__c,invoiceit_s__Required_By__c,invoiceit_s__Bundle__c, QTC__Quote_Line__r.SBQQ__Bundled__c FROM invoiceit_s__Job_Rate_Plan_Charge__c 
                                          WHERE Id IN:listOrderRatePlanCharge 
                                          AND invoiceit_s__Required_By__c != null
                                          AND invoiceit_s__Bundle__c = true];*/

        listOrderRatePlanChargeisExist = [SELECT Id,QTC__Quote_Line__r.SBQQ__Product__c,invoiceit_s__VSOE_Pricing__c,invoiceit_s__Quantity__c,invoiceit_s__VSOE_Total__c,invoiceit_s__VSOE_Package_Total__c,invoiceit_s__Required_By__c,invoiceit_s__Bundle__c, QTC__Quote_Line__r.SBQQ__Bundled__c FROM invoiceit_s__Job_Rate_Plan_Charge__c 
                                          WHERE Id IN:listOrderRatePlanCharge 
                                          //AND invoiceit_s__Required_By__c != null
                                          AND QTC__Quote_Line__r.SBQQ__Bundled__c = true];                                  
        System.debug('listOrderRatePlanChargeisExist listOrderRatePlanChargeisExist --->'+listOrderRatePlanChargeisExist.size() );   
                                       
        if(!listOrderRatePlanChargeisExist.isEmpty()) {
            listOfPricebookEntry = [SELECT Id,IsActive,Name,Product2Id,QTC__VSOE_Price__c FROM PricebookEntry
                                    WHERE Product2Id In: productIds 
                                    AND Pricebook2Id =: order.QTC__Opportunity__r.SBQQ__PrimaryQuote__r.SBQQ__PriceBook__c];
        }
        System.debug('productIds --->'+productIds);
        //System.debug('listOfPricebookEntry --->'+listOfPricebookEntry.size() );
        
        for(PricebookEntry pricebookEntryObj : listOfPricebookEntry ) {
            if(pricebookEntryObj.QTC__VSOE_Price__c != null)
                 map_productId_EntryVSOEPrice.put(pricebookEntryObj.Product2Id, pricebookEntryObj.QTC__VSOE_Price__c);
        }  
        
        for(invoiceit_s__Job_Rate_Plan_Charge__c orpc : listOrderRatePlanCharge) {
            if(map_productId_EntryVSOEPrice.containskey(orpc.QTC__Quote_Line__r.SBQQ__Product__c)) {
                System.debug('populating VSOE ');
                orpc.invoiceit_s__VSOE_Pricing__c = map_productId_EntryVSOEPrice.get(orpc.QTC__Quote_Line__r.SBQQ__Product__c);
                orpc.invoiceit_s__VSOE_Total__c = orpc.invoiceit_s__VSOE_Pricing__c * orpc.invoiceit_s__Quantity__c;
                orpc.VSOE_Status__c = 'Completed';
            }else{
                System.debug('Else ');
                orpc.VSOE_Status__c = 'Pending';
                orpc.invoiceit_s__Charge_Code__c = 'VSOE blank on the PBook Entry';
            }
        }
        update  listOrderRatePlanCharge;

        /*AggregateResult[] groupQuantity = [SELECT SUM(invoiceit_s__VSOE_Total__c) vsoepriceSum,  invoiceit_s__Required_By__c parentBundleId
                                           FROM invoiceit_s__Job_Rate_Plan_Charge__c 
                                           WHERE Id IN: listOrderRatePlanCharge
                                           AND
                                           invoiceit_s__Required_By__c != null
                                           AND invoiceit_s__Bundle__c = true
                                           GROUP BY invoiceit_s__Required_By__c
                                           ];*/

        AggregateResult[] groupQuantity = [SELECT SUM(invoiceit_s__VSOE_Total__c) vsoepriceSum,  invoiceit_s__Required_By__c parentBundleId
                                           FROM invoiceit_s__Job_Rate_Plan_Charge__c 
                                           WHERE Id IN: listOrderRatePlanCharge
                                           AND
                                           invoiceit_s__Required_By__c != null
                                           AND QTC__Quote_Line__r.SBQQ__Bundled__c = true
                                           GROUP BY invoiceit_s__Required_By__c
                                           ];
        for(AggregateResult aggResult : groupQuantity ) {
            map_BundleId_TotalVSOEPrice.put((Id)aggResult.get('parentBundleId'), (decimal)aggResult.get('vsoepriceSum'));
        }
        list<invoiceit_s__Invoice_Lines__c> listOfLine  =new list<invoiceit_s__Invoice_Lines__c>();
        invoiceit_s__Invoice_Lines__c invLine ; 
        for (invoiceit_s__Job_Rate_Plan_Charge__c orderCharge : listOrderRatePlanCharge) {
            if(orderCharge.invoiceit_s__Required_By__c != null && map_BundleId_TotalVSOEPrice.containsKey(orderCharge.invoiceit_s__Required_By__c) && orderCharge.QTC__Quote_Line__r.SBQQ__Bundled__c) {
                orderCharge.invoiceit_s__VSOE_Package_Total__c = map_BundleId_TotalVSOEPrice.get(orderCharge.invoiceit_s__Required_By__c);                
            }
            for (invoiceit_s__Invoice_Lines__c invoiceLine: orderCharge.invoiceit_s__Invoice_Lines__r) {
                invLine = new invoiceit_s__Invoice_Lines__c(id=invoiceLine.id,invoiceit_s__Revenue_Recognition_Status__c = 'Queued');
                listOfLine.add(invLine);
            
            }
        }

        update listOrderRatePlanCharge; 
        update listOfLine ;
    }
}