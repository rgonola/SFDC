public class IIT_CreateOrderchargefulfillment {
    list<invoiceit_s__Job_Rate_Plan_Charge__c> listOfORPC ; 
    map<id, list<Product_Fulfillment_Step__c> > mapOfProductfulfilment = new map<id, list<Product_Fulfillment_Step__c> >();
    list<Product_Fulfillment_Step__c> listOfPfulfillment ; 
    set<id> setOfProductIds = new set<id>();

    public PageReference createOrderfulfilment(set<id> orderIds){
        System.debug('Hello--->'+orderIds);
        listOfORPC = [SELECT  QTC__Quote_Line__c,invoiceit_s__Order__r.QTC__Opportunity__r.SBQQ__PrimaryQuote__r.OwnerId ,invoiceit_s__Order__c, Product_Id__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE invoiceit_s__Order__c in:orderIds];
        for(invoiceit_s__Job_Rate_Plan_Charge__c orpc : listOfORPC){
            setOfProductIds.add(orpc.Product_Id__c);
            
        }
        
        listOfPfulfillment = [SELECT Id,Subject_Of_Task__c,Description__c,No_Of_Days__c,Name,Actionss__c,Order_Rate_Plan_Charge__c,Product__c,Status__c FROM Product_Fulfillment_Step__c WHERE Product__c in: setOfProductIds];
        
        list<Product_Fulfillment_Step__c> listOfPfulfillmentLoc; 
        for(Product_Fulfillment_Step__c pfulfilment : listOfPfulfillment){
            if(mapOfProductfulfilment.containsKey(pfulfilment.Product__c)){
                listOfPfulfillmentLoc = mapOfProductfulfilment.get(pfulfilment.Product__c);
           
            }else{
                listOfPfulfillmentLoc = new list<Product_Fulfillment_Step__c>();
            }
            listOfPfulfillmentLoc.add(pfulfilment);
            mapOfProductfulfilment.put(pfulfilment.Product__c, listOfPfulfillmentLoc);
        }
        //mapOfProductfulfilment = new map<id,list<Product_Fulfillment_Step__c >>();
        Task vTask ;
        list<Task> listOfTask = new list<Task>();
        list<Product_Fulfillment_Step__c> listOfProductfulfillmentInsert = new list<Product_Fulfillment_Step__c>();
        for(invoiceit_s__Job_Rate_Plan_Charge__c orpcInsert : listOfORPC){
            System.debug('orpcInsert--->'+orpcInsert);
            if(mapOfProductfulfilment.get(orpcInsert.Product_Id__c) != null){
                Product_Fulfillment_Step__c pf;
                for(Product_Fulfillment_Step__c prFulfilment : mapOfProductfulfilment.get(orpcInsert.Product_Id__c)){
                    System.debug('prFulfilment--->'+prFulfilment);
                    pf = new Product_Fulfillment_Step__c();
                    pf = prFulfilment.clone(false);
                    pf.Product__c = null;
                    pf.Order_Rate_Plan_Charge__c = orpcInsert.id;
                    pf.Quote_Line__c = orpcInsert.QTC__Quote_Line__c;
                    

                    Date myDate = system.TODAY() ;
                    if(pf.Actionss__c == 'Create Task'){
                         vTask = new Task();
                         vTask.WhatId = orpcInsert.id;
                         //vTask.WhatId = orpcInsert.id;
                         //vTask.Description = 'Task has been created';
                         vTask.OwnerId =orpcInsert.invoiceit_s__Order__r.QTC__Opportunity__r.SBQQ__PrimaryQuote__r.OwnerId ;
                         vTask.Description = pf.Description__c;
                         vTask.Subject = pf.Subject_Of_Task__c;
                         vTask.Product_Fulfillment_Step__c = prFulfilment.id;
                         System.debug('HHHHHHHHHHH'+pf.No_Of_Days__c);
                         if(pf.No_Of_Days__c != null){
                             System.debug('NNNNNNNNNN'+pf.No_Of_Days__c);
                             //vTask.ActivityDate = system.TODAY().addDays(Decimal.valueOf(pf.No_Of_Days__c));
                             vTask.ActivityDate = myDate.addDays(integer.valueOf(pf.No_Of_Days__c));
                         }else{
                             System.debug('MMMMMMMMMM'+pf.No_Of_Days__c);
                             vTask.ActivityDate = system.TODAY();
                         }
                         
                         listOfTask.add(vTask);
                         System.debug('vTask--->'+vTask);
                    }
                    listOfProductfulfillmentInsert.add(pf);
                }
            }
            
            
        }
        if(listOfProductfulfillmentInsert.size()>0){
            insert listOfProductfulfillmentInsert;
        }
        if(listOfTask.size() > 0 ){
            insert listOfTask;
            System.debug('listOfTask--->'+listOfTask);
        }
        
        return null;
    }
}