public with sharing class IIT_JSonParserClass{
    
    public static string parseResponseBody(string sResponseBody){
        System.debug('sResponseBody======='+sResponseBody);
        string sReturnValue = '';
        string sReplace = sResponseBody.replaceAll('ns2.','');
        sReplace = sReplace.replaceAll('ns1.','');
        System.debug('sReplace ======='+sReplace );
        
        map<String, Object> mapOfObject = (map<String,Object>) JSON.deserializeUntyped(sReplace);
        map<String, Object> mapOfTaxFieldValue;
        list<Object> listOfObject = new list<Object>();
        
        System.debug('mapOfObject.get(CalculateInvoiceResult) ======='+mapOfObject.get('CalculateInvoiceResult'));
        map<String, Object> mapOfObjectValue = (map<String,Object>) mapOfObject.get('CalculateInvoiceResult');
        string sIsValid = string.ValueOf(mapOfObjectValue.get('ResultType'));
        System.debug('SYysyysysdasd'+mapOfObjectValue.get('LineItemBundles'));
        map<String, Object> mapOfObjectValueLineBundles = (map<String,Object>) mapOfObjectValue.get('LineItemBundles');
        System.debug('LineBundles Values-->'+mapOfObjectValueLineBundles);
        System.debug('Line Values--->'+mapOfObjectValueLineBundles.get('LineItemBundle'));
        map<String, Object> mapOfObjectValueLineBundle = (map<String,Object>) mapOfObjectValueLineBundles.get('LineItemBundle');
        System.debug('Line Values--->'+mapOfObjectValueLineBundles.get('LineItemBundle'));
        System.debug('====='+mapOfObjectValueLineBundle.get('LineItems'));
        map<String, Object> mapOfObjectValueLineItems =(map<String,Object>) mapOfObjectValueLineBundle.get('LineItems');
        System.debug('Mallela-->'+mapOfObjectValueLineItems);
        System.debug('Mallela123-->'+mapOfObjectValueLineItems.get('LineItem'));
        //map<String, Object> mapOfObjectValueLineItem =(map<String,Object>) mapOfObjectValueLineItems.get('LineItem');
        //System.debug('Mallela 123-->'+mapOfObjectValueLineItem);
        
        for(string s : mapOfObjectValueLineItems.keyset()){
           map<String, Object> mapOfObjecttest123 = (map<String,Object>) mapOfObjectValueLineItems.get('ProductCode');
          system.debug('testting==>'+mapOfObjecttest123);
        //map<String, Object> mapOfObjectValueLineItems123 =(map<String,Object>) mapOfObjectValueLineBundle.get(s);
        
        //for(String s1 : mapOfObjectValueLineItems123.keyset()){
          System.debug('sIsValid 1======='+(string)mapOfObjectValueLineItems.get('Quantity') );
        //}
        
        System.debug('s ======='+s);
         
        }  
        
        System.debug('sIsValid ======='+sIsValid );
        
        if(sIsValid =='SUCCESS'){
            map<String, Object> mapOfObjectTaxValue = (map<String,Object>) mapOfObjectValue.get('TotalTax');
            System.debug('mapOfObjectTaxValue======='+mapOfObjectTaxValue);
            sReturnValue = string.ValueOf(mapOfObjectTaxValue.get('DecimalValue'));
        }else{
            sReturnValue = sResponseBody;
        }
        
        return sReturnValue ;   
    }

    public static string parseResponseBodyPost(string sResponseBody,string sId){
        string sReturnValue = '';
        string sReplace = sResponseBody.replaceAll('ns2.','');
        sReplace = sReplace.replaceAll('ns1.','');
        map<String, Object> mapOfInvoice = (map<String,Object>) JSON.deserializeUntyped(sReplace);
        map<String, Object> mapOfTaxFieldValue;
        list<Object> listOfObject = new list<Object>();
        map<String, Object> mapOfInvoiceValue = (map<String,Object>) mapOfInvoice.get('PostInvoiceResult');
        string sIsValid = string.ValueOf(mapOfInvoiceValue.get('ResultType'));
        
        if(sIsValid =='SUCCESS'){
            map<String, Object> mapOfInvoiceTaxValue = (map<String,Object>) mapOfInvoiceValue.get('TotalTax');
            map<String, Object> mapOfTransactionIdValue = (map<String,Object>) mapOfInvoiceValue.get('Transaction');
            string sTransactionId = string.ValueOf(mapOfTransactionIdValue.get('TransactionID'));
            sReturnValue +=sTransactionId+':';      
            sReturnValue += string.ValueOf(mapOfInvoiceTaxValue.get('DecimalValue'));
            System.debug('Line number is 36'+sReturnValue);
            //invoiceit_s__Invoice__c invoice = new invoiceit_s__Invoice__c(id=sId,ST_Transaction_Id__c=sTransactionId,invoiceit_s__Invoice_Status__c='Posted',Speed_TAX__c=Decimal.valueOf(sReturnValue));
            //upsert invoice;      
        }else{
            sReturnValue = sResponseBody;
        }
        
        return sReturnValue ;
    }
    
    public static String jsonStringForGetQuote(list<SBQQ__Quote__c> listOfQuotes)
    {                
        String sJsonString = '';
        Date todayDate = system.today();
        String sQuoteDate = '';
        if(todayDate != null){
            sQuoteDate = todayDate.year() + '-';
                    
            if(todayDate.month() < 10) {
                sQuoteDate += '0' + todayDate.month() + '-'; 
            } else {
                sQuoteDate += todayDate.month() + '-';
            }
            if(todayDate.day() < 10) {
                sQuoteDate += '0' + todayDate.day();
            } else {
                sQuoteDate += todayDate.day();
            }
        }else{
            sQuoteDate = null;
        }
        
        JSONGenerator jsonGenerator = JSON.createGenerator(true);
        jsonGenerator.writeStartObject();
        jsonGenerator.writeFieldName('Invoice');
        jsonGenerator.writeStartObject();
        
        jsonGenerator.writeStringField('InvoiceNumber', String.valueOf(listOfQuotes.get(0).Name)); 
        if(sQuoteDate != null){
             jsonGenerator.writeStringField('InvoiceDate', sQuoteDate+'T00:00:00');
        }else {
            return 'ERROR : "Start Date" is missing for the quote '+' "'+listOfQuotes.get(0).Name+'"';  
        }
        //jsonGenerator.writeStringField('CustomerId', 'AAA');
        jsonGenerator.writeStringField('InvoiceType', 'INVOICE');
        if( listOfQuotes.get(0).SBQQ__Account__r.Tax_Exempt__c == null ||  !listOfQuotes.get(0).SBQQ__Account__r.Tax_Exempt__c){
            jsonGenerator.writeBooleanField('Exempt', False);
        }else{
            jsonGenerator.writeBooleanField('Exempt', True);
            jsonGenerator.writeStringField('ExemptionCertificate', 'Government');
            jsonGenerator.writeStringField('ExemptionReason', 'Government');
            
        }
        if( listOfQuotes.get(0).SBQQ__Account__r.Customer_Account_Number__c != null &&  listOfQuotes.get(0).SBQQ__Account__r.Customer_Account_Number__c !=''){
            jsonGenerator.writeStringField('CustomerName', listOfQuotes.get(0).SBQQ__Account__r.Customer_Account_Number__c );
        }else{
            jsonGenerator.writeStringField('CustomerName', listOfQuotes.get(0).SBQQ__Account__r.Name );
        }
        
        jsonGenerator.writeFieldName('ShipFromAddress');
        jsonGenerator.writeStartObject();
        jsonGenerator.writeStringField('Address1', '225 Chastain Meadows Parkway');
        jsonGenerator.writeStringField('City', 'Kennesaw');
        jsonGenerator.writeStringField('State', 'GA');
        jsonGenerator.writeStringField('Zip','30144');
        jsonGenerator.writeStringField('Country', 'United States');      
        jsonGenerator.writeEndObject(); 
       
        jsonGenerator.writeFieldName('ShipToAddress');
        jsonGenerator.writeStartObject();
        if(listOfQuotes.get(0).SBQQ__ShippingStreet__c != null){
             jsonGenerator.writeStringField('Address1', String.valueOf(listOfQuotes.get(0).SBQQ__ShippingStreet__c)); 
        }
        else {
            return 'Ship To Street is blank, please fill in';  
            
        }
        if(listOfQuotes.get(0).SBQQ__ShippingCity__c != null){
             jsonGenerator.writeStringField('City', String.valueOf(listOfQuotes.get(0).SBQQ__ShippingCity__c));
        }
        else {
            return 'Ship To City is blank, please fill in';  
        }
        
        if(listOfQuotes.get(0).SBQQ__ShippingState__c != null){
            string state = listOfQuotes.get(0).SBQQ__ShippingState__c;
            
            /*IIT_CommonUtilClass.frameMapStateNameANDCode();
            if(IIT_CommonUtilClass.map_StateName_Code.containskey(listOfQuotes.get(0).SBQQ__ShippingState__c.toLowerCase())) {
                state = IIT_CommonUtilClass.map_StateName_Code.get(listOfQuotes.get(0).SBQQ__ShippingState__c.toLowerCase());
            } else {
                state = listOfQuotes.get(0).SBQQ__ShippingState__c;
            }*/
            
            jsonGenerator.writeStringField('State', state);
        
        }else {
            return 'Ship To State is blank, please fill in';  
        }
        
        if(listOfQuotes.get(0).SBQQ__ShippingPostalCode__c != null){
            jsonGenerator.writeStringField('Zip', String.valueOf(listOfQuotes.get(0).SBQQ__ShippingPostalCode__c));
        }
        else {
            return 'Ship To Postal Code is blank, please fill in';  
        }
        
        if(listOfQuotes.get(0).SBQQ__ShippingCountry__c != null){
             jsonGenerator.writeStringField('Country', String.valueOf(listOfQuotes.get(0).SBQQ__ShippingCountry__c));
        }
        else {
            return 'Ship To Country is blank, please fill in';  
        } 
        
        jsonGenerator.writeEndObject();
        
        jsonGenerator.writeFieldName('LineItems');
        jsonGenerator.writeStartObject();
        jsonGenerator.writeFieldName('LineItem');
        jsonGenerator.writeStartArray();
        Integer j = 0;
        for(SBQQ__Quote__c quote: listOfQuotes){
            for(SBQQ__QuoteLine__c line: quote.SBQQ__LineItems__r){
                jsonGenerator.writeStartObject();
                jsonGenerator.writeStringField('LineItemNumber', String.valueOf(j++));
                
                if(line.SBQQ__ProductCode__c != null){
                    jsonGenerator.writeStringField('ProductCode', String.valueOf(line.SBQQ__ProductCode__c));
                }else {
                    return 'ERROR : "Product Code" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }
                
                if(line.SBQQ__Description__c != null){
                    jsonGenerator.writeStringField('ProductDescription', String.valueOf(line.SBQQ__Description__c));
                }else {
                    //return 'ERROR : "Product Description" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }        
                
                if(line.SBQQ__Quantity__c != null){
                    jsonGenerator.writeStringField('Quantity', String.valueOf(line.SBQQ__Quantity__c));
                }else {
                    return 'ERROR : "Quantity" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }             
                jsonGenerator.writeFieldName('UnitPrice');
                jsonGenerator.writeStartObject();
                
                
                if(line.SBQQ__ListPrice__c != null){
                    jsonGenerator.writeStringField('DecimalValue', String.valueOf(line.SBQQ__ListPrice__c));
                }else {
                    return 'ERROR : "List Unit Price" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }                
                jsonGenerator.writeEndObject(); 
                jsonGenerator.writeFieldName('SalesAmount');
                jsonGenerator.writeStartObject();
                
                // if the nettoal is less than zero, we need to send the amount as same always positive and need to pass the attribute as negative.
                decimal netTotal = line.SBQQ__NetTotal__c;
                if(line.SBQQ__NetTotal__c < 0){
                    netTotal = netTotal * (-1);    
                }
                system.debug('netTotal ' + netTotal);
                
                if(line.SBQQ__NetTotal__c != null){
                    jsonGenerator.writeStringField('Cents', String.valueOf(netTotal).substringAfter('.'));
                }else {
                    return 'ERROR : "Net Total" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }
                if(line.SBQQ__NetTotal__c != null){
                    jsonGenerator.writeStringField('Dollars', String.valueOf(netTotal).substringBefore('.'));
                }else {
                    return 'ERROR : "Net Total" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }
                //jsonGenerator.writeStringField('Negative', 'false');
                if(line.SBQQ__NetTotal__c > 0){
                    jsonGenerator.writeStringField('Negative', 'false');
                }else{
                    jsonGenerator.writeStringField('Negative', 'true');
                }
                
                jsonGenerator.writeEndObject();
                jsonGenerator.writeEndObject(); 
              }  
        }
        jsonGenerator.writeEndArray();   
        jsonGenerator.writeEndObject();
        jsonGenerator.writeEndObject();
        jsonGenerator.writeEndObject();
        sJsonString = jsonGenerator.getAsString();   
        return sJsonString;                     
    }
    
     public static String jsonStringForGetInvoice(list<invoiceit_s__Invoice__c> listOfInvoices ,String statusInv)
    {                
        String sJsonString = '';
        
        String sInvoiceDate = '';
        if(listOfInvoices.get(0).invoiceit_s__Invoice_Date__c != null){      
            sInvoiceDate = listOfInvoices.get(0).invoiceit_s__Invoice_Date__c.year() + '-';
            
            if(listOfInvoices.get(0).invoiceit_s__Invoice_Date__c.month() < 10) {
                sInvoiceDate += '0' + listOfInvoices.get(0).invoiceit_s__Invoice_Date__c.month() + '-'; 
            } else {
                sInvoiceDate += listOfInvoices.get(0).invoiceit_s__Invoice_Date__c.month() + '-';
            }
            if(listOfInvoices.get(0).invoiceit_s__Invoice_Date__c.day() < 10) {
                sInvoiceDate += '0' + listOfInvoices.get(0).invoiceit_s__Invoice_Date__c.day();
            } else {
                sInvoiceDate += listOfInvoices.get(0).invoiceit_s__Invoice_Date__c.day();
            }
        }else{
            sInvoiceDate = null;
        }        
        
        JSONGenerator jsonGenerator = JSON.createGenerator(true);
        jsonGenerator.writeStartObject();
        jsonGenerator.writeFieldName('Invoice');
        jsonGenerator.writeStartObject();
        jsonGenerator.writeStringField('InvoiceNumber', String.valueOf(listOfInvoices.get(0).Name)); 
        if(sInvoiceDate != null){
             jsonGenerator.writeStringField('InvoiceDate', sInvoiceDate+'T00:00:00');
        }else {
            return 'ERROR : "Invoice Date" is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }        
        jsonGenerator.writeStringField('InvoiceType', 'INVOICE');

        if( listOfInvoices.get(0).invoiceit_s__Account__r.Tax_Exempt__c == null ||  !listOfInvoices.get(0).invoiceit_s__Account__r.Tax_Exempt__c){
            jsonGenerator.writeBooleanField('Exempt', False);
        }else{
            jsonGenerator.writeBooleanField('Exempt', True);
            jsonGenerator.writeStringField('ExemptionCertificate', 'Government');
            jsonGenerator.writeStringField('ExemptionReason', 'Government');
            
        }
        if( listOfInvoices.get(0).invoiceit_s__Account__r.Customer_Account_Number__c != null &&  listOfInvoices.get(0).invoiceit_s__Account__r.Customer_Account_Number__c !=''){
            jsonGenerator.writeStringField('CustomerName', listOfInvoices.get(0).invoiceit_s__Account__r.Customer_Account_Number__c );
        }else{
            jsonGenerator.writeStringField('CustomerName', listOfInvoices.get(0).invoiceit_s__Account__r.Name );
        }
        
        jsonGenerator.writeFieldName('ShipFromAddress');
        jsonGenerator.writeStartObject();
         jsonGenerator.writeStringField('Address1', '225 Chastain Meadows Parkway');
        jsonGenerator.writeStringField('City', 'Kennesaw');
        jsonGenerator.writeStringField('State', 'GA');
        jsonGenerator.writeStringField('Zip','30144');
        jsonGenerator.writeStringField('Country', 'United States');      
        jsonGenerator.writeEndObject(); 
        /*if(listOfInvoices.get(0).invoiceit_s__Billing_Contact__r.MailingStreet != null){
             jsonGenerator.writeStringField('Address1', String.valueOf(listOfInvoices.get(0).invoiceit_s__Billing_Contact__r.MailingStreet));
        }else {
            return 'ERROR : Billing Contacts Street is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }
        
        if(listOfInvoices.get(0).invoiceit_s__Billing_Contact__r.MailingCity != null){
            jsonGenerator.writeStringField('City', String.valueOf(listOfInvoices.get(0).invoiceit_s__Billing_Contact__r.MailingCity));
        }else {
            return 'ERROR : Billing Contacts city is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }       
        
        if(listOfInvoices.get(0).invoiceit_s__Billing_Contact__r.MailingState != null){
            jsonGenerator.writeStringField('State', String.valueOf(listOfInvoices.get(0).invoiceit_s__Billing_Contact__r.MailingState));
        }else {
            return 'ERROR : Billing Contacts State is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }
        
        if(listOfInvoices.get(0).invoiceit_s__Billing_Contact__r.MailingPostalCode != null){
            jsonGenerator.writeStringField('Zip', String.valueOf(listOfInvoices.get(0).invoiceit_s__Billing_Contact__r.MailingPostalCode));
        }else {
            return 'ERROR : Billing Contacts Zip Code is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }
        
        if(listOfInvoices.get(0).invoiceit_s__Billing_Contact__r.MailingCountry != null){
            jsonGenerator.writeStringField('Country', String.valueOf(listOfInvoices.get(0).invoiceit_s__Billing_Contact__r.MailingCountry));
        }else {
            return 'ERROR : Billing Contacts Country is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }
        jsonGenerator.writeEndObject(); */
       
        jsonGenerator.writeFieldName('ShipToAddress');
        jsonGenerator.writeStartObject();
        if(listOfInvoices.get(0).invoiceit_s__Account__r.ShippingStreet != null){
             jsonGenerator.writeStringField('Address1', String.valueOf(listOfInvoices.get(0).invoiceit_s__Account__r.ShippingStreet));
        }else {
            return 'ERROR : Shipping Account Street is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }
        
        if(listOfInvoices.get(0).invoiceit_s__Account__r.ShippingCity != null){
            jsonGenerator.writeStringField('City', String.valueOf(listOfInvoices.get(0).invoiceit_s__Account__r.ShippingCity));
        }else {
            return 'ERROR : Shipping Account city is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }       
        
        if(listOfInvoices.get(0).invoiceit_s__Account__r.ShippingState  != null){
            jsonGenerator.writeStringField('State', String.valueOf(listOfInvoices.get(0).invoiceit_s__Account__r.ShippingState ));
        }else {
            return 'ERROR : Shipping Account State is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }
        
        if(listOfInvoices.get(0).invoiceit_s__Account__r.ShippingPostalCode != null){
            jsonGenerator.writeStringField('Zip', String.valueOf(listOfInvoices.get(0).invoiceit_s__Account__r.ShippingPostalCode));
        }else {
            return 'ERROR : Shipping Account Zip Code is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }
        
        if(listOfInvoices.get(0).invoiceit_s__Account__r.ShippingCountry != null){
            jsonGenerator.writeStringField('Country', String.valueOf(listOfInvoices.get(0).invoiceit_s__Account__r.ShippingCountry));
        }else {
            return 'ERROR : Shipping Account Country is missing for the invoice '+' "'+listOfInvoices.get(0).Name+'"';  
        }
        jsonGenerator.writeEndObject();
        
        jsonGenerator.writeFieldName('LineItems');
        jsonGenerator.writeStartObject();
        jsonGenerator.writeFieldName('LineItem');
        jsonGenerator.writeStartArray();
        Integer i = 0;
        for(invoiceit_s__Invoice__c invoice: listOfInvoices){
           for(invoiceit_s__Invoice_Lines__c line: invoice.invoiceit_s__Invoice_Lines__r){
                jsonGenerator.writeStartObject();
                jsonGenerator.writeStringField('LineItemNumber', String.valueOf(i++));
                if(line.Product_Code__c != null){
                    jsonGenerator.writeStringField('ProductCode', String.valueOf(line.Product_Code__c));
                }else {
                    return 'ERROR : "Product Name" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }
                if(line.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.QTC__Description1__c!= null){
                    jsonGenerator.writeStringField('ProductDescription', String.valueOf(line.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.QTC__Description1__c));
                }else {
                    //return 'ERROR : "Product Description" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }
                if(line.invoiceit_s__Quantity__c != null){
                    jsonGenerator.writeStringField('Quantity', String.valueOf(line.invoiceit_s__Quantity__c));
                }else {
                    return 'ERROR : "Quantity" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }
                jsonGenerator.writeFieldName('UnitPrice');
                jsonGenerator.writeStartObject();
                if(line.invoiceit_s__Total_Line_Amount__c != null){
                    if(statusInv == 'Posted' || statusInv == 'Draft'){
                      jsonGenerator.writeStringField('DecimalValue', String.valueOf(line.invoiceit_s__Total_Line_Amount__c));
                    }else if(statusInv == 'Cancelled'){
                        jsonGenerator.writeStringField('DecimalValue', String.valueOf(line.invoiceit_s__Total_Line_Amount__c));
                        //jsonGenerator.writeStringField('DecimalValue', true);
                    }
                }else {
                    return 'ERROR : "Total Line Value" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }
               
                jsonGenerator.writeEndObject(); 
                
                jsonGenerator.writeFieldName('SalesAmount');
                jsonGenerator.writeStartObject();
                if(line.invoiceit_s__Total_Line_Amount__c != null){
                        jsonGenerator.writeStringField('Cents', String.valueOf(line.invoiceit_s__Total_Line_Amount__c).substringAfter('.'));        
                }else {
                    return 'ERROR : "Total Line Value" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }
                if(line.invoiceit_s__Total_Line_Amount__c != null){
                    if(statusInv == 'Posted' || statusInv == 'Draft'){
                        jsonGenerator.writeStringField('Dollars', String.valueOf(line.invoiceit_s__Total_Line_Amount__c).substringBefore('.'));
                     }else if(statusInv == 'Cancelled'){
                        jsonGenerator.writeStringField('Dollars', String.valueOf(line.invoiceit_s__Total_Line_Amount__c).substringBefore('.'));
                        
                    }
                }else {
                    return 'ERROR : "Total Line Value" is missing for the line '+' "' + String.valueOf(line.Name)+'"';  
                }
                if(statusInv == 'Posted' || statusInv == 'Draft'){
                    jsonGenerator.writeStringField('Negative', 'false');
                }else{
                    jsonGenerator.writeStringField('Negative', 'true');
                }
                //jsonGenerator.writeStringField('Negative', 'false');
                jsonGenerator.writeEndObject();                
                jsonGenerator.writeEndObject(); 
              }  
        }
        jsonGenerator.writeEndArray();   
        jsonGenerator.writeEndObject();
        jsonGenerator.writeEndObject();
        jsonGenerator.writeEndObject();
        sJsonString = jsonGenerator.getAsString();   
        return sJsonString;                     
    }
    
}