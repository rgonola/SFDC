trigger IIT_Usage on invoiceit_s__Usage_Charge__c (before insert) {
      // CCH will upload the usages using the below fields :
      // invoiceit_s__Order__c, SKU_Code__c, Amount__c, Original_Quantity__c
      // For Bank charges, CCH will upload Quantity and Amount to bill, this trigger will populate the invoiceit_s__Quantity__c

      set<Id> setOfOrderIds = new set<id>();
      set<String> setOfprodcutCode = new set<String>();
      map<Id, Id> orderIdQuoteId = new map<Id, Id>();

      for(invoiceit_s__Usage_Charge__c usage1 : trigger.new)
      {
         system.debug('usage1.SKU_Code__c ===  ' + usage1.SKU_Code__c);
         if(usage1.invoiceit_s__Order__c != null
             && usage1.SKU_Code__c != null)
         {
            system.debug('Adding usage1.SKU_Code__c ===  ' + usage1.SKU_Code__c);

            usage1.SKU_Code__c = usage1.SKU_Code__c.toLowerCase();
            setOfOrderIds.add(usage1.invoiceit_s__Order__c);
            setOfprodcutCode.add(usage1.SKU_Code__c);
            
            // populate the
            if(usage1.Amount__c != null) {
                usage1.invoiceit_s__Quantity__c = usage1.Amount__c;  
            } else {
                usage1.invoiceit_s__Quantity__c = usage1.Original_Quantity__c;  
            }
            
         }
         else
         {
            usage1.addError('SKU Code or Order Id is blank, please populate the required fields'); 
         }
      }

      for(SBQQ__Quote__c quote : [SELECT Id, QTC__Order__c FROM SBQQ__Quote__c WHERE QTC__Order__c IN: setOfOrderIds]) {
        orderIdQuoteId.put(quote.QTC__Order__c, quote.Id);
      }
     
     system.debug('setOfprodcutCode ===  ' + setOfprodcutCode);  
     map<string,Product2> mapOfProducts= new map<string,Product2>() ;
     list<Product2> listOfProducts = [SELECT CreatedDate,Id,Name,ProductCode,QTC__Revenue_Recognition_Rule__c 
                                      FROM Product2 
                                      WHERE ProductCode =:setOfprodcutCode 
                                      AND ProductCode!= null
                                      ];
     for(Product2 stdProduct : listOfProducts)
     {
        string lowerCaseProductCode = stdProduct.ProductCode.toLowerCase();
        mapOfProducts.put(lowerCaseProductCode, stdProduct);
     }

     system.debug('listOfProducts is === ' + listOfProducts); 
     system.debug('mapOfProducts is === ' + mapOfProducts.keySet()); 
     
     set<id> setOfUsageIds = new set<id>();
     list<invoiceit_s__Usage_Charge__c> lstUsageUpdate = new list<invoiceit_s__Usage_Charge__c>();
  
     map<Id, decimal> chargeIdFreeUnits = new map<Id, decimal>();
     map<Id, decimal> chargeIdUsedFreeUnits = new map<Id, decimal>();
     map<Id, invoiceit_s__Usage_Charge__c> usageIdFreeUnits = new map<Id, invoiceit_s__Usage_Charge__c>();
     
     // populate the ORPC
     for(invoiceit_s__Job_Rate_Plan_Charge__c ordCharge : [SELECT id, Product_Code__c, invoiceit_s__Order__c, Free_EFiles__c
                                                            FROM invoiceit_s__Job_Rate_Plan_Charge__c
                                                            WHERE invoiceit_s__Order__c in : setOfOrderIds
                                                            AND Product_Code__c IN: setOfprodcutCode])
      {     
       for(invoiceit_s__Usage_Charge__c usage : system.trigger.new)
       {      
          if(ordCharge.Product_Code__c == usage.SKU_Code__c 
             && usage.invoiceit_s__Order__c == ordCharge.invoiceit_s__Order__c
            )
          {
             usage.invoiceit_s__Order_Rate_Plan_Charge__c = ordCharge.id;
             
             lstUsageUpdate.add(usage);
             setOfUsageIds.add(usage.Id);
             //break; 
          }
        }
      }      
      
    list<invoiceit_s__Job_Product__c> listOrderProduct = new list < invoiceit_s__Job_Product__c>();
    list<invoiceit_s__Job_Rate_Plan__c> listOrderRatePlan = new list <invoiceit_s__Job_Rate_Plan__c>();
    list<invoiceit_s__Job_Rate_Plan_Charge__c> listOrderPlanCharge = new list < invoiceit_s__Job_Rate_Plan_Charge__c>();
    list<SBQQ__QuoteLine__c> listQuoteLines = new list <SBQQ__QuoteLine__c>();

    invoiceit_s__Job_Product__c prodLocal;
    invoiceit_s__Job_Rate_Plan__c rateplanLocal;
    invoiceit_s__Job_Rate_Plan_Charge__c chargeLocal;
    SBQQ__QuoteLine__c quoteLineLocal;
    set<string> setOfCode_OID = new set<String>(); 
          
    system.debug('Usages ==== ');
    for(invoiceit_s__Usage_Charge__c usage : system.trigger.new)
    {
      if(usage.invoiceit_s__Order_Rate_Plan_Charge__c == null
          && 
         !setOfCode_OID.contains(usage.SKU_Code__c + '_' + usage.invoiceit_s__Order__c)
         &&
         usage.SKU_Code__c != null
         &&
         usage.invoiceit_s__Order__c != null
        )
      {
          system.debug('mapOfProducts.containsKey(usage.SKU_Code__c) is === ' + mapOfProducts.containsKey(usage.SKU_Code__c)); 
          if(mapOfProducts.containsKey(usage.SKU_Code__c)) 
          {
             prodLocal = new invoiceit_s__Job_Product__c();   
             // don't change the below code as it's being referred and it will break    
             // SKU code is consider as the primary key for mapping and don't change this line of code   
             prodLocal.Name = usage.SKU_Code__c;
             prodLocal.invoiceit_s__Product_Code__c = usage.SKU_Code__c;
             prodLocal.invoiceit_s__Product_Family__c = usage.SKU_Code__c;
             prodLocal.invoiceit_s__SequenceNumber__c = 1;
             prodLocal.invoiceit_s__Job__c = usage.invoiceit_s__Order__c;
             listOrderProduct.add(prodLocal);
             
             system.debug('added order Product ==== ');

             setOfCode_OID.add(usage.SKU_Code__c + '_' + usage.invoiceit_s__Order__c); 

             quoteLineLocal = new SBQQ__QuoteLine__c();
             quoteLineLocal.SBQQ__Quantity__c = 0;
             quoteLineLocal.SBQQ__Product__c = mapOfProducts.get(usage.SKU_Code__c).Id;
             quoteLineLocal.SBQQ__Quote__c = orderIdQuoteId.get(usage.invoiceit_s__Order__c);
             quoteLineLocal.SBQQ__ListPrice__c = 0;
             quoteLineLocal.SBQQ__CustomerPrice__c = 0;
             quoteLineLocal.SBQQ__NetPrice__c = 0;
             quoteLineLocal.SBQQ__SpecialPrice__c = 0;
             quoteLineLocal.SBQQ__RegularPrice__c = 0;
             quoteLineLocal.SBQQ__ProratedListPrice__c = 0;
             quoteLineLocal.SBQQ__SubscriptionPricing__c = 'Fixed Price';
             quoteLineLocal.SBQQ__SubscriptionTerm__c = 0;
             quoteLineLocal.SBQQ__Number__c = 1000;

             listQuoteLines.add(quoteLineLocal);

           }
           else
           {
             if(usage.SKU_Code__c != null
               ||
               usage.invoiceit_s__Order__c != null) 
             {
                System.debug('adding error');
                usage.addError('Product does not exists with the mentioned SKU Code, please create the product & then upload. Possible other reasons are Order Id is missing');
             }
           }
                         
      }
  }

  insert listOrderProduct;

  insert listQuoteLines;
  
  for(invoiceit_s__Job_Product__c prod :  listOrderProduct)
  {
       rateplanLocal = new invoiceit_s__Job_Rate_Plan__c();
       rateplanLocal.invoiceit_s__Job_Product__c = prod.id;
       rateplanLocal.invoiceit_s__SequenceNumber__c = 1;
       rateplanLocal.Name = prod.Name;
       listOrderRatePlan.add(rateplanLocal);
  }

  insert listOrderRatePlan;

  for(integer i = 0; i < listOrderRatePlan.size(); i++)
  {
       invoiceit_s__Job_Rate_Plan__c plan = listOrderRatePlan[i];
       chargeLocal = new invoiceit_s__Job_Rate_Plan_Charge__c();
       chargeLocal.invoiceit_s__Job_Rate_Plan__c = plan.id;
       chargeLocal.Name = plan.Name;
       chargeLocal.invoiceit_s__Price_Type__c = 'Usage';
       chargeLocal.invoiceit_s__Price_Format__c = 'Per Unit Pricing';
       chargeLocal.invoiceit_s__Unit_Price__c = 1;
       chargeLocal.invoiceit_s__Cost_Price__c = 1;
       chargeLocal.invoiceit_s__Price__c = 1;
       chargeLocal.invoiceit_s__Sequence_No__c = 1;
       chargeLocal.invoiceit_s__Quantity__c = 0;
       chargeLocal.invoiceit_s__Net_Total__c = 1;
       chargeLocal.invoiceit_s__VAT_Percentage__c = 0;
       chargeLocal.invoiceit_s__Tax_Percentage__c = 0;
       chargeLocal.QTC__Quote_Line__c = listQuoteLines[i].Id;
       chargeLocal.invoiceit_s__Revenue_Recognition_Rule__c = mapOfProducts.get(plan.Name).qtc__Revenue_Recognition_Rule__c; 
       listOrderPlanCharge.add(chargeLocal);
   }

   insert listOrderPlanCharge;
   list<invoiceit_s__Job_Rate_Plan_Charge__c> lstUpdate = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
   for(invoiceit_s__Job_Rate_Plan_Charge__c ordCharge : [SELECT id, Product_Code__c, invoiceit_s__Order__c,
                                                          invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__c,
                                                          invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__r.invoiceit_s__Service_Activation_Date__c,
                                                          invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__r.invoiceit_s__Service_End_Date__c,
                                                          invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__r.invoiceit_s__CurrencyL__c
                                                          FROM invoiceit_s__Job_Rate_Plan_Charge__c
                                                          WHERE ID IN: listOrderPlanCharge
                                                          ]){
       
       system.debug('assigning inserted chargeId ==== ');
       for(invoiceit_s__Usage_Charge__c usage : system.trigger.new){
          if(ordCharge.Product_Code__c == usage.SKU_Code__c 
              && usage.invoiceit_s__Order__c == ordCharge.invoiceit_s__Order__c
              && usage.invoiceit_s__Order_Rate_Plan_Charge__c == null)
          {
             system.debug('assigning inserted chargeId ==== ');
             usage.invoiceit_s__Order_Rate_Plan_Charge__c = ordCharge.id;
             
             lstUsageUpdate.add(usage);
             setOfUsageIds.add(usage.Id);
             //break; 
          }
      }

      ordCharge.invoiceit_s__Service_Activation_Date__c = ordCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__r.invoiceit_s__Service_Activation_Date__c;
      ordCharge.invoiceit_s__Service_End_Date__c = ordCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__r.invoiceit_s__Service_End_Date__c;
      ordCharge.invoiceit_s__CurrencyL__c =ordCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__r.invoiceit_s__CurrencyL__c;
      ordCharge.invoiceit_s__Order__c = ordCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__c;
      lstUpdate.add(ordCharge);
    }  
    update lstUpdate;
}

/*

below code is to test the functionality

list<invoiceit_s__Usage_Charge__c> lstUpdate = new list<invoiceit_s__Usage_Charge__c>();
invoiceit_s__Usage_Charge__c u1 = new invoiceit_s__Usage_Charge__c();
u1.invoiceit_s__Order__c = 'a2VM0000006oYSK';
u1.invoiceit_s__Start_Date__c = system.today();
u1.invoiceit_s__End_Date__c = system.today();
u1.SKU_Code__c = 'ATX-MAX2016';
u1.invoiceit_s__Quantity__c = 1;

invoiceit_s__Usage_Charge__c u11 = new invoiceit_s__Usage_Charge__c();
u11.invoiceit_s__Order__c = 'a2VM0000006oYSK';
u11.invoiceit_s__Start_Date__c = system.today();
u11.invoiceit_s__End_Date__c = system.today();
u11.SKU_Code__c = 'ATX-MAX2016';
u11.invoiceit_s__Quantity__c = 2;

invoiceit_s__Usage_Charge__c u111 = new invoiceit_s__Usage_Charge__c();
u111.invoiceit_s__Order__c = 'a2VM0000006oYSK';
u111.invoiceit_s__Start_Date__c = system.today();
u111.invoiceit_s__End_Date__c = system.today();
u111.SKU_Code__c = 'ATX-MAX2016123';
u111.invoiceit_s__Quantity__c = 3;

invoiceit_s__Usage_Charge__c u1111 = new invoiceit_s__Usage_Charge__c();
u1111.invoiceit_s__Order__c = 'a2VM0000006oYSK';
u1111.invoiceit_s__Start_Date__c = system.today();
u1111.invoiceit_s__End_Date__c = system.today();
u1111.SKU_Code__c = 'ATX-ZSHIPSTDMAX2016 ';
u1111.invoiceit_s__Quantity__c = 5;

invoiceit_s__Usage_Charge__c u11111 = new invoiceit_s__Usage_Charge__c();
u11111.invoiceit_s__Order__c = 'a2VM0000006oYSK';
u11111.invoiceit_s__Start_Date__c = system.today();
u11111.invoiceit_s__End_Date__c = system.today();
u11111.SKU_Code__c = 'ATX-MAX2016123';
u11111.invoiceit_s__Quantity__c = 3;
  

lstUpdate.add(u1);
lstUpdate.add(u11);
lstUpdate.add(u111);
lstUpdate.add(u1111);
lstUpdate.add(u11111);

invoiceit_s__Usage_Charge__c u12 = new invoiceit_s__Usage_Charge__c();
u12.invoiceit_s__Order__c = 'a2VM0000006oYRl';
u12.invoiceit_s__Start_Date__c = system.today();
u12.invoiceit_s__End_Date__c = system.today();
u12.SKU_Code__c = 'ATX-MAX2016';
u12.invoiceit_s__Quantity__c = 1;

invoiceit_s__Usage_Charge__c u112 = new invoiceit_s__Usage_Charge__c();
u112.invoiceit_s__Order__c = 'a2VM0000006oYRl';
u112.invoiceit_s__Start_Date__c = system.today();
u112.invoiceit_s__End_Date__c = system.today();
u112.SKU_Code__c = 'ATX-MAX2016';
u112.invoiceit_s__Quantity__c = 2;

invoiceit_s__Usage_Charge__c u11112 = new invoiceit_s__Usage_Charge__c();
u11112.invoiceit_s__Order__c = 'a2VM0000006oYRl';
u11112.invoiceit_s__Start_Date__c = system.today();
u11112.invoiceit_s__End_Date__c = system.today();
u11112.SKU_Code__c = 'ATX-ZSHIPSTDMAX2016 ';
u11112.invoiceit_s__Quantity__c = 3;

invoiceit_s__Usage_Charge__c u1112 = new invoiceit_s__Usage_Charge__c();
u1112.invoiceit_s__Order__c = 'a2VM0000006oYRl';
u1112.invoiceit_s__Start_Date__c = system.today();
u1112.invoiceit_s__End_Date__c = system.today();
u1112.SKU_Code__c = 'ATX-MAX2016123';
u1112.invoiceit_s__Quantity__c = 3;

lstUpdate.add(u12);
lstUpdate.add(u112);
lstUpdate.add(u1112);
lstUpdate.add(u11112);

insert lstUpdate;

*/