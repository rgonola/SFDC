/**********************************************************************
Name: afInsUpdBigMachinesQuote
Copyright © 2012 WK
======================================================
======================================================
Purpose: This trigger will be called when a new BigMachine Quote record is created.
         This will create Sync record for SOAP call.
         This will update the opportunity Invoice Amount.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR    DATE            DETAIL 
1.0       Aditya    12/09/2012      Initial Development
***********************************************************************/
trigger afInsUpdBigMachinesQuote on BigMachines__Quote__c (after insert, after update, after delete) {
    List<SFDCQuote_BMQuote_Sync__c> lstQuotesToInsert=new List<SFDCQuote_BMQuote_Sync__c>();
    Set<Id> setOpportunityIds = new Set<Id>();
    Map<Id,Id> mapAccountId = new Map<Id, Id>();
    Map<Id,Opportunity> mapOpportunity = new Map<Id,Opportunity>();
    List<Opportunity> updateOpportunityList = new List<Opportunity>();
    Opportunity oppItem = new Opportunity();
    
    if(Trigger.isInsert || Trigger.isUpdate){
        for(BigMachines__Quote__c bmQuoteObj :Trigger.new){
            setOpportunityIds.add(bmQuoteObj.BigMachines__Opportunity__c);
        }
    }
    if(Trigger.isDelete){
        for(BigMachines__Quote__c bmQuoteObj :Trigger.old){
            setOpportunityIds.add(bmQuoteObj.BigMachines__Opportunity__c);
        }
    }
    
    for(Opportunity opp : [SELECT Id, AccountId, Invoiced_Amount__c FROM Opportunity WHERE Id IN:setOpportunityIds]) {
        mapAccountId.put(opp.Id, opp.AccountId);
        mapOpportunity.put(opp.Id,opp);
    }
    
    System.debug('--->mapAccountId:-'+mapAccountId);

    if(Trigger.isInsert || Trigger.isUpdate){
        for(BigMachines__Quote__c bmQuoteObj :Trigger.new){
        	//if(Trigger.isInsert){
	            SFDCQuote_BMQuote_Sync__c sfdcQuoteObj=new SFDCQuote_BMQuote_Sync__c();            
	            sfdcQuoteObj.Account_Id__c = mapAccountId.get(bmQuoteObj.BigMachines__Opportunity__c);
	            System.debug('--->AccountId:-'+mapAccountId.get(bmQuoteObj.BigMachines__Opportunity__c));
	            sfdcQuoteObj.Opportunity_Id__c=bmQuoteObj.BigMachines__Opportunity__c;
	            sfdcQuoteObj.Quote_Owner_Id__c=bmQuoteObj.OwnerId;
	            sfdcQuoteObj.Quote_Id__c=bmQuoteObj.Id;
	            sfdcQuoteObj.Quote_Transaction_Number__c=bmQuoteObj.BigMachines__Transaction_Id__c;
	            lstQuotesToInsert.add(sfdcQuoteObj);
        	//}          
            //update oportunity Invoice Amount
            if(mapOpportunity != null && mapOpportunity.containsKey(bmQuoteObj.BigMachines__Opportunity__c)){
                if(bmQuoteObj.BigMachines__Status__c == 'Invoiced' && 
                  (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(bmQuoteObj.Id).BigMachines__Status__c != 'Invoiced'))){
                    oppItem = new Opportunity();
                    oppItem = mapOpportunity.get(bmQuoteObj.BigMachines__Opportunity__c);
                    if(oppItem.Invoiced_Amount__c!=null && bmQuoteObj.BigMachines__Total_Amount__c!=null)//Added by aditya
                    	oppItem.Invoiced_Amount__c = oppItem.Invoiced_Amount__c + bmQuoteObj.BigMachines__Total_Amount__c;
                    mapOpportunity.put(oppItem.Id,oppItem);
                }
                
                if(bmQuoteObj.BigMachines__Status__c != 'Invoiced' && Trigger.isUpdate && Trigger.oldMap.get(bmQuoteObj.Id).BigMachines__Status__c == 'Invoiced'){
                    oppItem = new Opportunity();
                    oppItem = mapOpportunity.get(bmQuoteObj.BigMachines__Opportunity__c);
                    if(oppItem.Invoiced_Amount__c!=null && bmQuoteObj.BigMachines__Total_Amount__c!=null)//Added by aditya
                    	oppItem.Invoiced_Amount__c = oppItem.Invoiced_Amount__c - bmQuoteObj.BigMachines__Total_Amount__c;
                    mapOpportunity.put(oppItem.Id,oppItem);
                }
            }
        }
    }
    
    //update oportunity Invoice Amount
    if(Trigger.isDelete){
        for(BigMachines__Quote__c bmQuoteObj :Trigger.old){
            if(mapOpportunity != null && mapOpportunity.containsKey(bmQuoteObj.BigMachines__Opportunity__c) && bmQuoteObj.BigMachines__Status__c == 'Invoiced'){
                oppItem = new Opportunity();
                oppItem = mapOpportunity.get(bmQuoteObj.BigMachines__Opportunity__c);
                if(oppItem.Invoiced_Amount__c!=null && bmQuoteObj.BigMachines__Total_Amount__c!=null)//Added by aditya
                	oppItem.Invoiced_Amount__c = oppItem.Invoiced_Amount__c - bmQuoteObj.BigMachines__Total_Amount__c;
                mapOpportunity.put(oppItem.Id,oppItem);
            }
        }
    }
    
    if(lstQuotesToInsert!=null && lstQuotesToInsert.size()>0)
        //insert lstQuotesToInsert;
        upsert lstQuotesToInsert Quote_Transaction_Number__c; 

    //update oportunity Invoice Amount
    updateOpportunityList = mapOpportunity.values();
    if(updateOpportunityList!=null && updateOpportunityList.size()>0)
        update updateOpportunityList;
}