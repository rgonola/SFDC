public class Insertnewstagingtable{

public void sendStagingData(Id invoiceId){
    //system.debug('SessionId**'+SessionId);
      try{
       
        CreateOrder createOrder=new CreateOrder();
        CreateOrder.Staging createStaging=New CreateOrder.Staging();
        
        CreateOrder.DataControl dataControl= new CreateOrder.DataControl();    
        CreateOrder.Sfdc sfdc= new CreateOrder.Sfdc();
        CreateOrder.Customer customer= new CreateOrder.Customer();
        
        CreateOrder.Contacts shippingContact=new CreateOrder.Contacts();
        CreateOrder.Contacts billingContact=new CreateOrder.Contacts();

        List<CreateOrder.Contacts> contactList=new List<CreateOrder.Contacts>();
        
        CreateOrder.Order order=new CreateOrder.Order();
        
        List<SBQQ__QuoteLine__c> QuoteLines=new List<SBQQ__QuoteLine__c>();
        
        List<CreateOrder.Products> productsList=new List<CreateOrder.Products>();
        
        List<CreateOrder.Fees> feesList=new List<CreateOrder.Fees>();
        
        Set<String> productIds=new Set<String>();
        Set<String> productCode=new Set<String>();
        Set<Id> ratePlanCharges=new Set<Id>();
        Set<Id> feeRatePlanCharges=new Set<Id>();
        Set<Id> QuoteLineId=new Set<Id>();
        
               
        invoiceit_s__Invoice__c invoiceObj=[Select id,invoiceit_s__Account__c ,Invoice_Sent_Formatted__c,Account_CID__c,Account_PID__c,invoiceit_s__Order__c,Name,
        invoiceit_s__Paid_Amount__c,invoiceit_s__Tax__c,Last_Payment_Type__c,Order_Value__c from invoiceit_s__Invoice__c where Id=:invoiceId];
        
        invoiceit_s__Job__c orderObj= [Select Id,Name,invoiceit_s__Partner__c,Quote_Type__c,Order_Number__c,CreatedDate,invoiceit_s__Quote__c, 
        Sales_Rep_Codex__c,QTC__Opportunity__c from invoiceit_s__Job__c  where Id=:invoiceObj.invoiceit_s__Order__c];
        
        List<invoiceit_s__Invoice_Lines__c> invoiceLines=[Select   Id,invoiceit_s__Unit_Price__c,Product_Code__c,invoiceit_s__Sequence_No__c,invoiceit_s__Quantity__c,invoiceit_s__Product_Name__c,Product_Year__c,invoiceit_s__Line_Name__c,
        invoiceit_s__Net_Total__c,invoiceit_s__Tax__c,invoiceit_s__Service_Start_Date__c,invoiceit_s__Service_End_Date__c,Price_Extended__c,Product_Taxable__c,invoiceit_s__Job_Rate_Plan_Charge__c,
        Training_Contact_Email__c,Product_Purchase_Type__c,Product_Family__c from invoiceit_s__Invoice_Lines__c  where invoiceit_s__Job__c=:orderObj.Id AND invoiceit_s__Invoice__c=:invoiceObj.Id AND Bundled__c=False
         ];
         
        
         /* Added for Fees Structure */
         
        List<invoiceit_s__Job_Rate_Plan_Charge__c> orderRatePlan=[Select   Id,Product_Name__c,invoiceit_s__Unit_Price__c,Product_Code__c,invoiceit_s__Sequence_No__c,invoiceit_s__Quantity__c,Product_Year__c,
        invoiceit_s__Net_Total__c,invoiceit_s__Tax__c,invoiceit_s__Service_End_Date__c,Price_Extended__c,
        Training_Contact_Email__c,Product_Purchase_Type__c,Product_Family__c from invoiceit_s__Job_Rate_Plan_Charge__c  where invoiceit_s__Order__c=:orderObj.Id ] ; 
        
        List<SBQQ__QuoteLine__c> Fees=[Select Id,name,SBQQ__Quantity__c ,SBQQ__Quote__c,QTC__Order_Rate_Plan_Charge__c,SBQQ__PackageProductCode__c,
        SBQQ__PackageProductDescription__c,SBQQ__ListPrice__c,SBQQ__NetPrice__c,SBQQ__StartDate__c,Tax__c,SBQQ__EndDate__c,Product_Familyx__c,Product_Year__c,
        Product_Codex__c,Productx__c  
        from SBQQ__QuoteLine__c where QTC__Order_Rate_Plan_Charge__c In :orderRatePlan and Product_Familyx__c='Fees'];

        for(invoiceit_s__Invoice_Lines__c invoiceLineId: invoiceLines){
            productIds.add(invoiceLineId.invoiceit_s__Line_Name__c);

        }
        
        for(invoiceit_s__Invoice_Lines__c ratePlanCharge: invoiceLines){
        if(ratePlanCharge.invoiceit_s__Job_Rate_Plan_Charge__c!=null)
            ratePlanCharges.add(ratePlanCharge.invoiceit_s__Job_Rate_Plan_Charge__c);
          
        }
       
       for(SBQQ__QuoteLine__c ratePlanCharge: fees){
       if(ratePlanCharge.QTC__Order_Rate_Plan_Charge__c!=null)
            feeRatePlanCharges.add(ratePlanCharge.QTC__Order_Rate_Plan_Charge__c);
        }
       
      
       QuoteLines=[Select Id,name,SBQQ__Quote__c from SBQQ__QuoteLine__c where QTC__Order_Rate_Plan_Charge__c In :ratePlanCharges];
       

       
       for(SBQQ__QuoteLine__c QuoteLine:QuoteLines){
           QuoteLineId.add(QuoteLine.SBQQ__Quote__c);
       }
       
         
       List<invoiceit_s__Invoice_Lines__c> assemblies=[Select Id,Product_Code__c,RequiredBy__c
        from invoiceit_s__Invoice_Lines__c where invoiceit_s__Job__c=:orderObj.Id AND RequiredBy__c In :productIds and 
         ((Bundled__c=TRUE) AND (Packaged__c=False) AND (RequiredBy__c!=null)) and invoiceit_s__Invoice__c=:invoiceObj.Id];
         
         /* For getting Tiers */

         
         List<invoiceit_s__Job_Rate_Plan_Charge_Tier__c> tiers=[Select invoiceit_s__End_Unit__c,invoiceit_s__Job_Rate_Plan_Charge__c,
         invoiceit_s__Start_Unit__c,invoiceit_s__Unit_Cost_Price__c,invoiceit_s__Unit_Price__c,Last_modified_Formatted__c 
         from invoiceit_s__Job_Rate_Plan_Charge_Tier__c where invoiceit_s__Job_Rate_Plan_Charge__c in:feeRatePlanCharges];
        
         for(invoiceit_s__Invoice_Lines__c productCodes:assemblies){
             productCode.add(productCodes.Product_Code__c);
         }
        
         system.debug('Product code Here ****'+productCode);
         List<Product2> product2=[Select Name,Id,ProductCode,Price_Book__c,QTC__Revenue_Recognition_Rule__c,QTC__Revenue_Recognition_Start_Date__c,Product_Year__c 
         from Product2 where ProductCode In :productCode]; 
         
         SBQQ__Quote__c Quote =[select SBQQ__Source__c,Origin_Source__c,SBQQ__Type__c,Name,Id from SBQQ__Quote__c where QTC__Order__c=:orderObj.Id and SBQQ__Primary__c=true and 
         Id In :QuoteLineId limit 1];
         


        Opportunity opportunity=[Select Name,LeadSource,Id,Description,Partner_Sales_Rep_Code__c,SBQQ__PrimaryQuote__c
        from Opportunity where SBQQ__PrimaryQuote__c=:Quote.id];
        
        Account accountObj=[Select Id,Brand__c,Type,OFFC__c,Territory__c,Fax,Primary_Contact_Name__c ,Name,BillingStreet,BillingCity,BillingPostalCode,BillingState,BillingCountry,Primary_MobilePhone__c,
        Phone,Billing_Contact_Email__c,Billing_Address_2__c,Shipping_Contact_Email__c,ShippingStreet,Shipping_Address_2__c,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry  from Account where Id=:invoiceObj.invoiceit_s__Account__c];
        
        List<invoiceit_s__Credit_Note__c> creditsNote=[Select Id,Name,invoiceit_s__Account__c,invoiceit_s__Billing_Contact__c,invoiceit_s__Related_Invoice__c,invoiceit_s__Credit_Note_Date__c,
        invoiceit_s__Credit_Note_Status__c,invoiceit_s__CurrencyL__c,invoiceit_s__Due_Date__c,invoiceit_s__Exchange_Rate_Applied__c,
        invoiceit_s__Net_Total__c,invoiceit_s__Number_Of_Credit_Lines__c,invoiceit_s__Discount_Value__c,invoiceit_s__Order__c,invoiceit_s__Shipping_Contact__c,
        invoiceit_s__Amount__c,invoiceit_s__Tax__c,Territory__c,invoiceit_s__Total_Credit_Note_Value__c,invoiceit_s__VAT__c from invoiceit_s__Credit_Note__c where invoiceit_s__Related_Invoice__c=:invoiceId];
        
        sfdc.SF_Account_ID= invoiceObj.invoiceit_s__Account__c ;
        sfdc.SF_Invoice_ID=invoiceObj.Id;
        sfdc.SF_Opportunity_ID=opportunity.Id;
        sfdc.SF_Order_ID=invoiceObj.invoiceit_s__Order__c;
        sfdc.SF_Quote_ID=Quote.Id; 
        
        customer.PID=invoiceObj.Account_PID__c;
        customer.ClientID=invoiceObj.Account_CID__c;
        customer.Office=String.ValueOf(accountObj.OFFC__c);
        customer.Brand_Type=accountObj.Brand__c;
        customer.Company=accountObj.Name;
        customer.Territory=accountObj.Territory__c;
        customer.Email=accountObj.Billing_Contact_Email__c;
        if(accountObj.Primary_Contact_Name__c!=null){
            String[] contaName=accountObj.Primary_Contact_Name__c.split('\\s+');
           
            if(contaName.size() > 1){
               customer.First_Name=contaName[0];                                           
               customer.Last_Name=contaName[1];      
             }
                    
           else{
                customer.First_Name=contaName[0];
            } 
       }          
       
        shippingContact.CNT_Type='Shipping';
        shippingContact.Phone=accountObj.Phone;
        shippingContact.Fax=accountObj.Fax;
        shippingContact.Mobile=accountObj.Primary_MobilePhone__c;
        shippingContact.Email=accountObj.Shipping_Contact_Email__c;  
        shippingContact.Addr1=accountObj.ShippingStreet;
        shippingContact.Addr2=accountObj.Shipping_Address_2__c;  
        shippingContact.City=accountObj.ShippingCity;
        shippingContact.State=accountObj.ShippingState;
        shippingContact.Zip=accountObj.ShippingPostalCode;
        shippingContact.Country=accountObj.ShippingCountry;
        
        billingContact.CNT_Type='Mailing';
        billingContact.Phone=accountObj.Phone;
        billingContact.Fax=accountObj.Fax;
        billingContact.Mobile=accountObj.Primary_MobilePhone__c;
        billingContact.Email=accountObj.Billing_Contact_Email__c;  
        billingContact.Addr1=accountObj.BillingStreet;
        billingContact.Addr2=accountObj.Billing_Address_2__c;  
        billingContact.City=accountObj.BillingCity;
        billingContact.State=accountObj.BillingState;
        billingContact.Zip=accountObj.BillingPostalCode;
        billingContact.Country=accountObj.BillingCountry;
       
        order.STX_Invoice_Number=invoiceObj.Name;
        order.STX_Invoice_Sent=invoiceObj.Invoice_Sent_Formatted__c;
        order.Description=opportunity.Description;
        order.Addl_SLS_CD=opportunity.Partner_Sales_Rep_Code__c;
        order.QuoteNum=Quote.Name;
        order.QuoteType=Quote.SBQQ__Type__c;                                 
        order.STX_Order_Number=orderObj.Order_Number__c;
        order.STX_Order_Sent=orderObj.CreatedDate;
        order.SLS_CD=orderObj.Sales_Rep_Codex__c;
        order.STOL_Total_Tax=String.ValueOf(invoiceObj.invoiceit_s__Tax__c);
        order.Payment_Type=invoiceObj.Last_Payment_Type__c; 
        order.Ord_Val=String.ValueOf(invoiceObj.Order_Value__c);
       
        order.Ord_Source=Quote.Origin_Source__c;
        order.Web_Source=opportunity.LeadSource;
       
        order.OrderType=Quote.SBQQ__Type__c;  
        

        Integer productIndex=1;
        
       for(invoiceit_s__Invoice_Lines__c invoiceLine: invoiceLines){
           CreateOrder.Products product=new CreateOrder.Products();
           product.LineSequence=String.ValueOf(productIndex++);
           product.ItemID=invoiceLine.Product_Code__c;
           product.ItemDescription=invoiceLine.invoiceit_s__Product_Name__c; 
           system.debug('creditsNote.size()**'+creditsNote.size()); 
           if(creditsNote.size() > 0){
      
             product.Quantity=String.ValueOf(-invoiceLine.invoiceit_s__Quantity__c);
             
             for(invoiceit_s__Credit_Note__c credNote:creditsNote){
              product.CreditNoteNumber=credNote.Name;
              sfdc.SF_CreateNote_ID=credNote.Id;
              
             }
           }
           else{
                product.Quantity=String.ValueOf(invoiceLine.invoiceit_s__Quantity__c);
           }
            
           product.PriceList=String.ValueOf(invoiceLine.invoiceit_s__Unit_Price__c);
           product.PriceNet=String.ValueOf(invoiceLine.invoiceit_s__Net_Total__c);
        
           product.PriceExtended=String.ValueOf(invoiceLine.Price_Extended__c);
           product.Revision_Number=invoiceLine.Product_Year__c;
           product.STOL_Tax=String.ValueOf(invoiceLine.invoiceit_s__Tax__c);
           product.Sub_Start_Date=String.ValueOf(invoiceLine.invoiceit_s__Service_Start_Date__c);
           product.Sub_End_Date=String.ValueOf(invoiceLine.invoiceit_s__Service_End_Date__c);
           //product.TRT_ID=String.ValueOf(invoiceLine.QTC__Quote_Line__r.SBQQ__Product__r.Product_Feature__r.SBQQ__Number__c);
           product.TRT_ID='xxx';
           product.Up_Down_Grade='N';
           product.Taxable=String.ValueOf(invoiceLine.Product_Taxable__c);
           product.ItemClass=invoiceLine.Product_Family__c;
           order.Train_Email=invoiceLine.Training_Contact_Email__c; 
           order.Total_Shipping=String.ValueOf(invoiceLine.invoiceit_s__Unit_Price__c);
           
           
           Integer index=1;
           List<CreateOrder.Assemblies> assembliesList=new List<CreateOrder.Assemblies>();
           for(invoiceit_s__Invoice_Lines__c assembly:assemblies){
               if(assembly.RequiredBy__c==invoiceLine.invoiceit_s__Line_Name__c){
               
                  for(Product2 prod: product2){
                      if(assembly.Product_Code__c==prod.ProductCode){
                        CreateOrder.Assemblies assemlies=new CreateOrder.Assemblies();
                        assemlies.SKU=prod.ProductCode;
                        assemlies.RevNo=prod.Product_Year__c;
                        assemlies.DR_Template_CD=prod.QTC__Revenue_Recognition_Rule__c;
                        assemlies.DR_Template_Date=String.ValueOf(prod.QTC__Revenue_Recognition_Start_Date__c);
                        assemlies.AssmSeq=String.ValueOf(index++);
                        assembliesList.add(assemlies);
                       }
                     }
                  }
               }
            product.Assemblies=assembliesList; 
              
             productsList.add(product);
             
         }
        
        /* Mapping for Fee */
        Integer feeProductIndex=1;
         for(SBQQ__QuoteLine__c invoiceLine: fees){
           CreateOrder.Fees fee=new CreateOrder.Fees();
          // fee.LineSequence=String.ValueOf(feeProductIndex++);
           fee.ItemID=invoiceLine.Product_Codex__c;
          // fee.ItemDescription=invoiceLine.Productx__c;   
          // fee.Quantity=String.ValueOf(invoiceLine.SBQQ__Quantity__c);
          //fee.PriceList=String.ValueOf(invoiceLine.SBQQ__ListPrice__c);
          // fee.PriceNet=String.ValueOf(invoiceLine.SBQQ__NetPrice__c);
        
           //fee.PriceExtended=String.ValueOf(invoiceLine.Price_Extended__c);
           fee.Revision_Number=invoiceLine.Product_Year__c;
          // fee.STOL_Tax=String.ValueOf(invoiceLine.Tax__c);
           //fee.Sub_Start_Date=String.ValueOf(invoiceLine.SBQQ__StartDate__c);
           //fee.Sub_End_Date=String.ValueOf(invoiceLine.SBQQ__EndDate__c);
           //fee.TRT_ID=String.ValueOf(invoiceLine.QTC__Quote_Line__r.SBQQ__Product__r.Product_Feature__r.SBQQ__Number__c);
           //fee.TRT_ID='xxx';
           //fee.Up_Down_Grade='N';
           //fee.Taxable=String.ValueOf(invoiceLine.Product_Taxable__c);
           //fee.ItemClass=invoiceLine.Product_Familyx__c;
           
           
           Integer tierIndex=1;
           List<CreateOrder.Tiers > tierList=new List<CreateOrder.Tiers>();
           for(invoiceit_s__Job_Rate_Plan_Charge_Tier__c tier: Tiers){
             if(invoiceLine.QTC__Order_Rate_Plan_Charge__c ==tier.invoiceit_s__Job_Rate_Plan_Charge__c){
                 CreateOrder.Tiers tr=new CreateOrder.Tiers();
                 tr.Tierline=String.ValueOf(tierIndex++);
                 tr.StartUnit=String.ValueOf(tier.invoiceit_s__Start_Unit__c);
                 tr.EndUnit=String.ValueOf(tier.invoiceit_s__End_Unit__c);
                 tr.UnitPrice=String.ValueOf(tier.invoiceit_s__Unit_Price__c);
                 fee.TimeStamp=tier.Last_modified_Formatted__c;
                // tr.OrderRatePlanCharge=tier.invoiceit_s__Job_Rate_Plan_Charge__c;
                 tierList.add(tr);
             }   
           }
          fee.Tiers=tierList;
          feesList.add(fee);
         }
         
      
        contactList.add(shippingContact);
        contactList.add(billingContact);
        createStaging.Sfdc=sfdc;
        createStaging.Customer=customer;
        createStaging.Contacts=contactList;
        createStaging.Order=order;
        createStaging.Products=productsList;
        createStaging.Fees=feesList;
        

        
        //insert log

    LogFiles__c logInfo=new LogFiles__c();
                  logInfo.Related_Account__c=accountObj.Id;
                  logInfo.Related_Invoice__c=invoiceObj.Id;
                  logInfo.Related_Order__c=orderObj.Id;
                  logInfo.Related_Opportunity__c=opportunity.Id;
                  logInfo.Related_Quote__c=Quote.Id;
                  logInfo.Log_Type__c='JSON-Fee';
                  insert logInfo;
         
         Datetime createdDate=[Select CreatedDate from LogFiles__c  where Id=:logInfo.id].CreatedDate;
        String createdDateFormat =createdDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
         dataControl.Sent_At=string.valueOf(createdDateFormat);
         dataControl.Event_ID=logInfo.id;
         dataControl.Event_Source='SFDC';
         
         createStaging.DataControl=dataControl;

       
        
        createOrder.Staging=createStaging;
      
       String strRequestParam = JSON.serialize(createOrder);
        system.debug('request Json**'+strRequestParam);
        
        LogFiles__c log=new LogFiles__c ();
               log.id=logInfo.Id;
               log.Info__c='Json - '+'  '+ strRequestParam;
               Update log;
       
       
      
    }
    catch(Exception e){
        
        LogFiles__c logInfo=new LogFiles__c();
                  
                  logInfo.Related_Invoice__c=invoiceId;
                  
                  logInfo.Log_Type__c='JSON ERROR';
                  logInfo.Response__c=e.getMessage()+ 'LN:' + e.getLineNumber();
                  insert logInfo;
        System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber());  
    }
  }
  
      }