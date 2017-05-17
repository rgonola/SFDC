/**********************************************************************
Name: bfInsertQuoteLineItemInsertOppQuote 
Copyright © 2012 WK
=======================================================================
=======================================================================
Purpose: This trigger will be called when a new QuoteLineItem is created and 
         it will create Opportunity and Quote.         
=======================================================================
=======================================================================
History
-----------------------------------------------------------------------
VERSION    AUTHOR        DATE           DETAIL 
1.0        Rajesh Meti   11/June/2012   INITIAL DEVELOPMENT    
***********************************************************************/
trigger bfInsertQuoteLineItemInsertOppQuote on QuoteLineItem (before insert) {

    Date currentDate = System.Today();
    Integer currentYear = currentDate.year();   
    
    Map<String, Id> AccountIdMap = new Map<String, Id>();     
    Map<Decimal, Id> opportunityIdMap = new Map<Decimal, Id>();
    Map<Decimal, Id> quoteIdMap = new Map<Decimal, Id>();
    Map<Decimal, String> quoteIdCIDMap = new Map<Decimal, String>(); 
    Map<Decimal, String> quoteIdPromDescMap = new Map<Decimal, String>();
    Map<String, Id> itemIdProductIdMap = new Map<String, Id>();
    Map<Id, Id> productIdPricebookEntryIdMap = new Map<Id, Id>();
    
    Set<String> itemIds = new Set<String>();       
    Set<Decimal> quoteIds = new Set<Decimal>();
    Set<String> CIDs = new Set<String>(); 
    Set<Id> opportunityIds = new Set<Id>();
    Set<Id> productIds = new Set<Id>(); 
    
    List<Opportunity> opportunityList = new List<Opportunity>();
    List<Quote> quoteList = new List<Quote>();
    List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
    
    if(Trigger.isBefore && Trigger.isInsert) {     
        
        Id AMFSNSRecordTypeId=[SELECT Id FROM RecordType WHERE Name='AM/FS/NS Opportunity'].Id;
        System.debug('---------AMFSNSRecordTypeId-------- '+AMFSNSRecordTypeId);
        Id priceBook2Id = [SELECT Id FROM Pricebook2 WHERE IsStandard = True LIMIT 1].Id;
        System.debug('---------PriceBook2Id -------- '+PriceBook2Id);                           
                
        for(QuoteLineItem qli : Trigger.new) {
            if(qli.Quote_Id__c != null)   {               
                quoteIds.add(qli.Quote_Id__c);
                CIDs.add(qli.CID__c);
                quoteIdCIDMap.put(qli.Quote_Id__c,qli.CID__c);                
                itemIds.add(qli.Item_Id__c);                
                if(qli.PROMO_DESC__c != null && qli.PROMO_DESC__c != '') {                                        
                    quoteIdPromDescMap.put(qli.Quote_Id__c,qli.PROMO_DESC__c);
                }
            }
        }
        
        for(Account account :[SELECT Id, CID__c FROM Account WHERE CID__c IN :CIDs])   {
            accountIdMap.put(account.CID__c, account.Id);
        }
        
        for(Product2 product :[SELECT Id, ProductCode FROM Product2 WHERE ProductCode IN :itemIds])  {
            productIds.add(product.Id); 
            itemIdProductIdMap.put(product.ProductCode,product.Id);            
        }
        
        for(PricebookEntry pbe : [SELECT Id, Product2Id FROM PricebookEntry WHERE Product2Id IN :productIds AND Pricebook2Id = :priceBook2Id])  {
            productIdPricebookEntryIdMap.put(pbe.Product2Id,pbe.Id);           
        }
                   
        for(Decimal i : quoteIds)  {
            Opportunity opportunity = new Opportunity();
            opportunity.Name = currentYear + ' Renewals - ' + String.valueOf(i);
            opportunity.StageName = 'Present Solution';
            opportunity.Quote_Id__c = i;
            opportunity.CloseDate = currentDate.addYears(1);
            if(quoteIdCIDMap.containskey(i)) {
                if(accountIdMap.containskey(quoteIdCIDMap.get(i)))
                    opportunity.AccountId = accountIdMap.get(quoteIdCIDMap.get(i));
            }
            opportunity.RecordTypeId = AMFSNSRecordTypeId;
            opportunityList.add(opportunity);
        } 
        System.debug('-----opportunityListsize-----:'+opportunityList.size());  
        if(opportunityList!= null && opportunityList.size() > 0)  {
            upsert opportunityList Quote_Id__c;
            for(Opportunity opp:opportunityList) {
                opportunityIdMap.put(opp.Quote_Id__c,opp.Id);
            }
        }
        
        for(Decimal i : quoteIds)  {           
            Quote quote = new Quote();
            quote.Name = currentYear+' Renewals - '+String.valueOf(i);
            quote.Quote_Id__c = i;
            quote.Description = quoteIdPromDescMap.get(i);
            quote.OpportunityId = opportunityIdMap.get(i);
            quote.Pricebook2Id = priceBook2Id;
            quoteList.add(quote);
        }        
        System.debug('-----QuoteListsize-----:'+quoteList.size()); 
        if(quoteList != null && quoteList.size() > 0) {       
            upsert quoteList Quote_Id__c;
            for(Quote quote:quoteList) {
                quoteIdMap.put(quote.Quote_Id__c,quote.Id);
            }           
        }
        
        for(QuoteLineItem qli : Trigger.new) {
            if(qli.Quote_Id__c != null)   {           
                qli.QuoteId = QuoteIdMap.get(qli.Quote_Id__c);
                qli.PricebookEntryId = productIdPricebookEntryIdMap.get(itemIdProductIdMap.get(qli.Item_Id__c));                       
            }
        } 
    }    
}