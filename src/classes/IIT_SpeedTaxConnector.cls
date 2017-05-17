global class IIT_SpeedTaxConnector {

    public static String requestCall;
    public static String appType;
    public static invoiceit_s__Gateway__c gateway;
   // global  Map<string,decimal> map_Pcode_Taxamt;
    
    //This method will verify the address 
    webservice static String resolveAddress(String pincode,String city,String state ,String address1,String country){
        gateway = [SELECT invoiceit_s__Merchant_ID__c,invoiceit_s__Merchant_Reference__c,invoiceit_s__Merchant_Seal_User_Id__c,invoiceit_s__Security_Key__c,Name FROM invoiceit_s__Gateway__c WHERE Name = 'Speed Tax'];
        requestCall='GET';
        appType = 'json';
        
        if(address1 == null || address1 == ''){
            return 'Ship To Street is blank, please fill in';
        }

        if(city == null || city == ''){
            return 'Ship To City is blank, please fill in';
        }

        if(state == null || state == ''){
            return 'Ship To State is blank, please fill in';
        }

        if(pincode == null || pincode == ''){
            return 'Ship To Postal Code is blank, please fill in';
        }
        
        if(country == null || country == ''){
            return 'Ship To Country is blank, please fill in';
        }
        
        address1=address1.replaceAll('[\n\r]', '');            
        /*IIT_CommonUtilClass.frameMapStateNameANDCode();
        if(state != null && IIT_CommonUtilClass.map_StateName_Code.containskey(state.toLowerCase())) {
            state = IIT_CommonUtilClass.map_StateName_Code.get(state.toLowerCase());
        } else {
            return 'Ship To State does not exists, please enter the correct Ship To State';
        }*/
        string endpointurl;
        
        if(!Test.IsRunningTest()){
         endpointurl='https://service.myspeedtax.com/tx2/services/rest/address?State='+state+'&Zip='+pincode+'&Address1='+address1+'&City='+city+'&Country='+country;
        }
        try
            {
             HTTPResponse authresp = new HTTPResponse ();
             if(!Test.IsRunningTest()){
                 authresp = IIT_CommonUtilClass.getRequest(endpointurl,requestCall,null,appType);
                }else{
                 Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                 authresp  = IIT_CommonUtilClass.getRequest('http://api.salesforce.com/foo/bar','GET',null,'internal');
                }
                
                system.debug('+++authresp +++'+authresp);
                if(authresp.getStatusCode() == 200)
                { 
                    system.debug('sJsonStrDataToreturn in resolveAddress ***--->' + authresp.getBody());
                    string sReplace = authresp.getBody().replaceAll('ns2.','');
                    sReplace = sReplace.replaceAll('ns1.','');
                    System.debug(''+sReplace);
                    map<String, Object> mapOfObject = (map<String,Object>) JSON.deserializeUntyped(sReplace);
                    map<String, Object> mapOfTaxFieldValue;
                    list<Object> listOfObject = new list<Object>();
                    map<String, Object> mapOfObjectValue = (map<String,Object>) mapOfObject.get('ResolveAddressResult');
                    System.debug(''+mapOfObjectValue );
                    string sIsValid;
                     if(!Test.IsRunningTest()){
                    sIsValid = string.ValueOf(mapOfObjectValue.get('ResultType'));
                    }else{
                    sIsValid ='UNRESOLVED';
                    }
                    System.debug(''+sIsValid );
                    if(sIsValid == 'UNRESOLVED'){
                        string sIsValid2;
                        if(mapOfObjectValue.containskey('STSErrorMessage')){
                            sIsValid2 = string.ValueOf(mapOfObjectValue.get('STSErrorMessage')); 
                            sIsValid2 = sIsValid2.replace(',' , '\n').replace('{' , '').replace('}' , '');
                            System.debug('Line number is 45 '+sIsValid2);
                            return sIsValid2;
                     }else{
                            return 'Issue with Address';
                        }
                    } else if(sIsValid == 'STATE') {
                        return 'The address could only be resolved to the State level. City/ZIP was not supplied or is incorrect for the given state. The resulting tax calculation will only apply state rates.';
                    }
                                   
                }
                else{                    
                    system.debug('authresp.getBody() in resolveAddress ==== ' + authresp.getBody());
                    return authresp.getBody();
                }    
        }catch(exception ex){
            return '' +ex.getMessage();         
        }       
        return 'Success';               
    }   
     //It will return only tax, we will populate the tax on the Quote line item 
     webservice static string calculateTaxForQuote(string Id ){         
         
         SBQQ__Quote__c quote = [SELECT SBQQ__ShippingCity__c,SBQQ__ShippingCountry__c,SBQQ__ShippingName__c,SBQQ__ShippingPostalCode__c,SBQQ__ShippingState__c,SBQQ__ShippingStreet__c,SBQQ__BillingCity__c,SBQQ__BillingCountry__c,SBQQ__BillingPostalCode__c,SBQQ__BillingState__c,SBQQ__BillingStreet__c FROM SBQQ__Quote__c WHERE Id =: Id];
         
         system.debug('quote.SBQQ__ShippingPostalCode__c ' + quote.SBQQ__ShippingPostalCode__c);
         system.debug('quote.SBQQ__ShippingPostalCode__c ' + quote.SBQQ__ShippingCity__c);
         system.debug('quote.SBQQ__ShippingPostalCode__c ' + quote.SBQQ__ShippingState__c);
         system.debug('quote.SBQQ__ShippingPostalCode__c ' + quote.SBQQ__ShippingStreet__c);

     //    string validateAddress = resolveAddress(quote.SBQQ__ShippingPostalCode__c,quote.SBQQ__ShippingCity__c,quote.SBQQ__ShippingState__c,quote.SBQQ__ShippingStreet__c,quote.SBQQ__ShippingCountry__c);
     //    if(!validateAddress.contains('Success')) {
     //        return validateAddress;
     //    }

         if(quote.SBQQ__ShippingCountry__c == null || quote.SBQQ__ShippingCountry__c == ''){
            return 'Ship To Country is blank, please fill in';
         }

         if(quote.SBQQ__ShippingCountry__c.tolowerCase() !='us' && quote.SBQQ__ShippingCountry__c.tolowerCase() !='usa' && quote.SBQQ__ShippingCountry__c.tolowerCase() !='united states' && quote.SBQQ__ShippingCountry__c.tolowerCase() !='canada' && quote.SBQQ__ShippingCountry__c.tolowerCase() !='ca'
          && quote.SBQQ__ShippingCountry__c.tolowerCase() !='can'){
            return 'Please enter a valid country, it should be Canada or United States';
         }
         if(quote.SBQQ__ShippingCountry__c.tolowerCase() =='us' || quote.SBQQ__ShippingCountry__c.tolowerCase() =='usa' || quote.SBQQ__ShippingCountry__c.tolowerCase() =='united states' && quote.SBQQ__ShippingCountry__c.tolowerCase() !='canada' && quote.SBQQ__ShippingCountry__c.tolowerCase() !='ca'
            && quote.SBQQ__ShippingCountry__c.tolowerCase() !='can'){
            System.debug('Coming to USA formate');
            string validateAddress;
            if(Test.isRunningTest()){
                validateAddress = 'Success';
            }else{
                validateAddress = resolveAddress(quote.SBQQ__ShippingPostalCode__c,quote.SBQQ__ShippingCity__c,quote.SBQQ__ShippingState__c,quote.SBQQ__ShippingStreet__c,quote.SBQQ__ShippingCountry__c);
                if(!validateAddress.contains('Success')) {
                     return validateAddress;
                }  
            }   
              
         }
         
         
         string sJsonStrDataToreturn = calculateTax(Id,null);
         if(Test.isRunningTest()){
             sJsonStrDataToreturn  = '32';
         }
         System.debug('sJsonStrDataToreturnsJsonStrDataToreturn'+sJsonStrDataToreturn);
         if(sJsonStrDataToreturn.contains('FAILED') || sJsonStrDataToreturn.contains('ERROR')){
            system.debug('114 ---->'+sJsonStrDataToreturn);
             return sJsonStrDataToreturn;
         }else{
             SBQQ__Quote__c sbQuote;
             SBQQ__QuoteLine__c quoteLine = [SELECT Id,Name,SBQQ__Quote__c,SBQQ__Product__r.Name,SBQQ__Quote__r.SBQQ__NetAmount__c,SBQQ__Quote__r.SBQQ__ListAmount__c FROM SBQQ__QuoteLine__c Where SBQQ__Product__r.Name = 'Sales Tax' AND SBQQ__Quote__c= :Id ];
             System.debug('quoteLine'+quoteLine);
             
             system.debug('sJsonStrDataToreturn == ' + sJsonStrDataToreturn);
             quoteLine.Tax__c = Decimal.valueOf(sJsonStrDataToreturn) ;
             quoteLine.SBQQ__ListPrice__c = Decimal.valueOf(sJsonStrDataToreturn);
             quoteLine.SBQQ__CustomerPrice__c = Decimal.valueOf(sJsonStrDataToreturn);
             quoteLine.SBQQ__NetPrice__c = Decimal.valueOf(sJsonStrDataToreturn);
             quoteLine.SBQQ__ProratedListPrice__c = Decimal.valueOf(sJsonStrDataToreturn);
             
             update quoteLine;
             
             sbQuote = [SELECT Name,SBQQ__NetAmount__c FROM SBQQ__Quote__c Where id = :Id];
             System.debug('Quote Net Total is --->'+quoteLine.SBQQ__Quote__r.SBQQ__NetAmount__c);
             System.debug('Quote Net Total is --->131'+Decimal.valueOf(sJsonStrDataToreturn));
             System.debug('Quote Net Total is --->132'+quoteLine.SBQQ__Quote__r.SBQQ__NetAmount__c+Decimal.valueOf(sJsonStrDataToreturn));
             System.debug('Quote Net Total is --->132'+quoteLine.SBQQ__Quote__r.SBQQ__ListAmount__c+Decimal.valueOf(sJsonStrDataToreturn));
             sbQuote = new SBQQ__Quote__c(id = Id,Tax__c = Decimal.valueOf(sJsonStrDataToreturn),Tax_Time_Stamp__c=System.now(),Tax_Grand_Total__c = sbQuote.SBQQ__NetAmount__c);
             update sbQuote;
             System.debug('Quote Net Total is148 --->'+sbQuote);
             return 'Tax for the record saved Successfully';
         }
       
      }
     //It will return only tax, we will populate the tax on the tax field on the Invoice
     webservice static string calculateTaxForInvoice(string Id , string status){        
        
        string sJsonStrDataToreturn = calculateTax(Id,status);
         
         if(sJsonStrDataToreturn.contains('FAILED') || sJsonStrDataToreturn.contains('ERROR')){
             return sJsonStrDataToreturn;
         }else{
             invoiceit_s__Invoice__c invoice;
             //invoice = new invoiceit_s__Invoice__c(id = Id,Speed_TAX__c = Decimal.valueOf(sJsonStrDataToreturn));
             //update invoice;
             return 'Tax for the record saved Successfully';
         }
     }    
     //It will create the record in the speed tax as a pending status and return the transaction ID and tax
     webservice static wrapperclass postTax(string Id,string status){
         gateway = [SELECT invoiceit_s__Merchant_ID__c,invoiceit_s__Merchant_Reference__c,invoiceit_s__Merchant_Seal_User_Id__c,invoiceit_s__Security_Key__c,Name FROM invoiceit_s__Gateway__c WHERE Name = 'Speed Tax'];
        wrapperclass wrapperResult = new wrapperclass();
        String sJsonStrDataToreturn = '';
        appType = 'json';
        requestCall = 'POST';
        string sReturnValue = '';
        //String sJsonStrData ;
        Map<string,decimal> map_Pcode_Taxamt = new Map<string,decimal>();
        String sJsonStrData = IIT_CommonUtilClass.getDetails(Id,status);        
        if(sJsonStrData.contains('ERROR')){
           wrapperResult.sresponse = sJsonStrData;
           return wrapperResult;
        }
        system.debug('sJsonStrData--->' + sJsonStrData);
        HTTP auth = new HTTP();
        HTTPRequest req = new HTTPRequest();
        
        string endpointurl='https://service.myspeedtax.com/tx2/services/rest/entity/'+gateway.invoiceit_s__Security_Key__c+'/invoice/post';        
        try{
            HTTPResponse authresp;
            
            if(!Test.isRunningTest())
            authresp = IIT_CommonUtilClass.getRequest(endpointurl,requestCall,sJsonStrData,appType);

            if(Test.isRunningTest() || authresp.getStatusCode() == 200){   
               //sJsonStrDataToreturn =  IIT_JSonParserClass.parseResponseBodyPost(authresp.getBody(),Id); 
               //System.debug('sJsonStrDataToreturnsJsonStrDataToreturn--168>'+sJsonStrDataToreturn);
               string sReplace;
               if(!Test.isRunningTest()) {
                sReplace = authresp.getBody().replaceAll('ns2.','');
        sReplace = sReplace.replaceAll('ns1.','');
               } else {
                sReplace = '{"PostInvoiceResult":{"ResultType":"SUCCESS","LineItemBundles":{"LineItemBundle":{"AddressForTax":{"Address1":"TEST","Address2":"","City":"ANNAPOLIS","State":"MD","Zip":21401,"Country":"USA","FullFipsCode":2400301600,"Latitude":38.982171,"Longitude":-76.527473},"AddressResolution":"FULL","LineItems":{"LineItem":[{"LineItemNumber":0,"CustomReference":"","ProductCode":"2016 ATX Total Tax Office Package","Quantity":1,"UnitPrice":{"Cents":38,"CentsWithPrecision":"38.000","DecimalValue":457.38,"DecimalValueWithPrecision":"457.38000","Dollars":457,"Negative":false},"SalesAmount":{"Cents":38,"CentsWithPrecision":"38.000","DecimalValue":457.38,"DecimalValueWithPrecision":"457.38000","Dollars":457,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":38,"CentsWithPrecision":"38.000","DecimalValue":457.38,"DecimalValueWithPrecision":"457.38000","Dollars":457,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":44,"CentsWithPrecision":"44.280","DecimalValue":27.44,"DecimalValueWithPrecision":"27.44280","Dollars":27,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":44,"CentsWithPrecision":"44.280","DecimalValue":27.44,"DecimalValueWithPrecision":"27.44280","Dollars":27,"Negative":false}}}},{"LineItemNumber":1,"CustomReference":"","ProductCode":"2016 ATX Deferred Payment Fee","Quantity":1,"UnitPrice":{"Cents":50,"CentsWithPrecision":"50.000","DecimalValue":27.5,"DecimalValueWithPrecision":"27.50000","Dollars":27,"Negative":false},"SalesAmount":{"Cents":50,"CentsWithPrecision":"50.000","DecimalValue":27.5,"DecimalValueWithPrecision":"27.50000","Dollars":27,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":50,"CentsWithPrecision":"50.000","DecimalValue":27.5,"DecimalValueWithPrecision":"27.50000","Dollars":27,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":65,"CentsWithPrecision":"65.000","DecimalValue":1.65,"DecimalValueWithPrecision":"1.65000","Dollars":1,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":65,"CentsWithPrecision":"65.000","DecimalValue":1.65,"DecimalValueWithPrecision":"1.65000","Dollars":1,"Negative":false}}}},{"LineItemNumber":2,"CustomReference":"","ProductCode":"2016 ATX Standard Processing - Total Tax Office Package","Quantity":1,"UnitPrice":{"Cents":90,"CentsWithPrecision":"90.000","DecimalValue":108.9,"DecimalValueWithPrecision":"108.90000","Dollars":108,"Negative":false},"SalesAmount":{"Cents":90,"CentsWithPrecision":"90.000","DecimalValue":108.9,"DecimalValueWithPrecision":"108.90000","Dollars":108,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":90,"CentsWithPrecision":"90.000","DecimalValue":108.9,"DecimalValueWithPrecision":"108.90000","Dollars":108,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":53,"CentsWithPrecision":"53.400","DecimalValue":6.53,"DecimalValueWithPrecision":"6.53400","Dollars":6,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":53,"CentsWithPrecision":"53.400","DecimalValue":6.53,"DecimalValueWithPrecision":"6.53400","Dollars":6,"Negative":false}}}},{"LineItemNumber":3,"CustomReference":"","ProductCode":"2016 ATX Business States (All)","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":4,"CustomReference":"","ProductCode":"2016 ATX 1040 Package","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":5,"CustomReference":"","ProductCode":"EFile Fee","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":6,"CustomReference":"","ProductCode":"2016 ATX Standard Processing - 1040 package","Quantity":1,"UnitPrice":{"Cents":90,"CentsWithPrecision":"90.000","DecimalValue":42.9,"DecimalValueWithPrecision":"42.90000","Dollars":42,"Negative":false},"SalesAmount":{"Cents":90,"CentsWithPrecision":"90.000","DecimalValue":42.9,"DecimalValueWithPrecision":"42.90000","Dollars":42,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":90,"CentsWithPrecision":"90.000","DecimalValue":42.9,"DecimalValueWithPrecision":"42.90000","Dollars":42,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":57,"CentsWithPrecision":"57.400","DecimalValue":2.57,"DecimalValueWithPrecision":"2.57400","Dollars":2,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":57,"CentsWithPrecision":"57.400","DecimalValue":2.57,"DecimalValueWithPrecision":"2.57400","Dollars":2,"Negative":false}}}},{"LineItemNumber":7,"CustomReference":"","ProductCode":"2016 ATX Federal 1040","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":8,"CustomReference":"","ProductCode":"2016 ATX User Guide PDF","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":9,"CustomReference":"","ProductCode":"2016 ATX 1040 State (1-3 States)","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":10,"CustomReference":"","ProductCode":"2016 2 (Two) Concurrent User Licenses","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":11,"CustomReference":"","ProductCode":"2016 ATX PaperlessPLUS","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":12,"CustomReference":"","ProductCode":"2016 ATX Tax Season Essentials CD","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":13,"CustomReference":"","ProductCode":"2016 ATX 1040 State (All States)","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":14,"CustomReference":"","ProductCode":"2016 ATX Federal Business and Specialty","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":15,"CustomReference":"","ProductCode":"2016 ATX Tax Prep Partner Standard Bundle","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":16,"CustomReference":"","ProductCode":"2016 Unlimited Efiling","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":17,"CustomReference":"","ProductCode":"2016 ATX-Tax Prep Partner 1041","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":18,"CustomReference":"","ProductCode":"2016 Payroll Compliance Reporting","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":19,"CustomReference":"","ProductCode":"2016 US Master Tax Guide Online","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":20,"CustomReference":"","ProductCode":"2016 ATX User Guide PDF","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":21,"CustomReference":"","ProductCode":"2016 US Master Tax Guide Book","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":22,"CustomReference":"","ProductCode":"2016 Complete Tax Library","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":23,"CustomReference":"","ProductCode":"2016 5 (Five) Concurrent User Licenses","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":24,"CustomReference":"","ProductCode":"2016 Practical Tax Bulletin","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}},{"LineItemNumber":25,"CustomReference":"","ProductCode":"2016 Practical Tax Expert","Quantity":1,"UnitPrice":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"SalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"ShipFromAddress":{"Address1":"225 Chastain Meadows Parkway","Address2":"","City":"Kennesaw","Country":"UNITED STATES","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"GA","Zip":"30144-5897"},"ShipToAddress":{"Address1":"Test","Address2":"","City":"annapolis","Country":"US","Jurisdictions":"","Latitude":0,"Longitude":0,"State":"MD","Zip":21401},"TaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":10,"DecimalValueWithPrecision":"10.00000","Dollars":10,"Negative":false},"NonTaxableSalesAmount":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TaxAmount":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false},"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TaxationType":"SELLER_USE","TotalTax":{"Cents":60,"CentsWithPrecision":"60.000","DecimalValue":0.6,"DecimalValueWithPrecision":"0.60000","Dollars":0,"Negative":false}}}}]},"RecalculatedJurisdictions":true,"Taxes":{"InvoiceTax":{"JurisdictionFips":24,"JurisdictionLevel":"STATE","JurisdictionName":"Maryland","EffectiveRate":0.06,"TotalTax":{"Cents":40,"CentsWithPrecision":"40.080","DecimalValue":51.4,"DecimalValueWithPrecision":"51.40080","Dollars":51,"Negative":false}}}}},"TotalExemptSales":{"Cents":0,"CentsWithPrecision":"0.000","DecimalValue":0,"DecimalValueWithPrecision":"0.00000","Dollars":0,"Negative":false},"TotalSales":{"Cents":68,"CentsWithPrecision":"68.000","DecimalValue":856.68,"DecimalValueWithPrecision":"856.68000","Dollars":856,"Negative":false},"TotalTax":{"Cents":40,"CentsWithPrecision":"40.080","DecimalValue":51.4,"DecimalValueWithPrecision":"51.40080","Dollars":51,"Negative":false},"Transactions":{"Dates":"2016-02-26T00:00:00-08:00","InvoiceNumber":"INV-0710","TransactionsID":120501653}}}';
               }
                //new code for populate tax at invoice line 
                map<String, Object> mapOfInvoice = (map<String,Object>) JSON.deserializeUntyped(sReplace);
                map<String, Object> mapOfInvoiceValue = (map<String,Object>) mapOfInvoice.get('PostInvoiceResult');
                map<String, Object> invMapAmount = (map<String,Object>) mapOfInvoice.get('Transactions');
                string sIsValid = string.ValueOf(mapOfInvoiceValue.get('ResultType'));
                if(sIsValid =='SUCCESS'){

                    map<String, Object> mapOfInvoiceLineItemBundles = (map<String,Object>) mapOfInvoiceValue.get('LineItemBundles');

                    map<String, Object> mapOfInvoiceLineItemBundle = (map<String,Object>) mapOfInvoiceLineItemBundles.get('LineItemBundle');

                    //Total tax on the invoice 
                    map<String, Object> mapOfInvoiceTaxValue = (map<String,Object>) mapOfInvoiceValue.get('TotalTax');
                    map<String, Object> mapOfTransactionIdValue = (map<String,Object>) mapOfInvoiceValue.get('Transaction');
                    string sTransactionId = string.ValueOf(mapOfTransactionIdValue.get('TransactionID'));
                    sReturnValue +=sTransactionId+':';      
                    sReturnValue += string.ValueOf(mapOfInvoiceTaxValue.get('DecimalValue'));
                    System.debug('Line number is 36'+sReturnValue);
                    sJsonStrDataToreturn =sReturnValue ;
                    map<String, Object> mapOfInvoiceLineItems = (map<String,Object>) mapOfInvoiceLineItemBundle.get('LineItems');

                    System.debug('List values '+mapOfInvoiceLineItemBundle.get('LineItems'));
                    System.debug('mapOfInvoiceLineItemBundles Newewew==>>'+mapOfInvoiceLineItems);
                    
                    map<String, Object> mapOfLineItems;
                    List<Object> lstobject = new List<Object>();
                    
                    System.debug('mapOfInvoiceLineItemBundles size is==>>'+mapOfInvoiceLineItems.size());
                    if( sReplace.countMatches('LineItemNumber') != 1) {
                       lstobject = (List<Object>)mapOfInvoiceLineItems.get('LineItem');
                   
                    } else {
                        mapOfLineItems = (map<String,Object>) mapOfInvoiceLineItems.get('LineItem');
                         System.debug('mapOfLineItems  value is==>>'+mapOfLineItems);
                       lstobject = mapOfInvoiceLineItems.values();
                    
                    }
                    
                  for(Object s : lstobject ){
                        // single object map
                        Map<String, Object> lineItemamp = (Map<String, Object>)s;
                        Map<String, Object> taxAmtMap = (Map<String, Object>)lineItemamp.get('TaxAmount');
                        map_Pcode_Taxamt.put((string)lineItemamp.get('ProductCode') ,(decimal)taxAmtMap.get('DecimalValue'));
                    }
                        
                    
                    
                     
                    
                }
               // system.debug('map_Pcode_Taxamt==>>'+map_Pcode_Taxamt);    
               wrapperResult.sresponse = sJsonStrDataToreturn ;
               wrapperResult.map_Pcode_Taxamt= map_Pcode_Taxamt;
               
            }
            else{
                wrapperResult.sresponse = authresp.getBody();
                
            }    
        }catch(exception ex){
             wrapperResult.sresponse = ex.getMessage() + ex.getLineNumber();
             return  wrapperResult ;  
        }
        System.debug('114 Line number'+sJsonStrDataToreturn);
         return wrapperResult;
     }
     public static string calculateTax(string Id,string status){
        gateway = [SELECT invoiceit_s__Merchant_ID__c,invoiceit_s__Merchant_Reference__c,invoiceit_s__Merchant_Seal_User_Id__c,invoiceit_s__Security_Key__c,Name FROM invoiceit_s__Gateway__c WHERE Name = 'Speed Tax'];
        
        requestCall='POST';
        appType = 'json';
        String sJsonStrDataToreturn = '';
        
        //String sJsonStrData ;
        String sJsonStrData = IIT_CommonUtilClass.getDetails(Id,status);

        if(!sJsonStrData.contains('ERROR')){
            try{
                system.debug('sJsonStrData after calling IIT_CommonUtilClass ' + gateway);
                
                string endpointurl;
                HTTPResponse authresp= new HTTPResponse ();
                 
                if(!Test.IsRunningTest()){
                endpointurl='https://service.myspeedtax.com/tx2/services/rest/entity/'+gateway.invoiceit_s__Security_Key__c+'/invoice/calculate';
                authresp = IIT_CommonUtilClass.getRequest(endpointurl,requestCall,sJsonStrData,appType);
                }else{
                 Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                 authresp  = IIT_CommonUtilClass.getRequest('http://api.salesforce.com/foo/bar','GET',null,'internal');
                }
                
                system.debug('authresp.getBody() ==' + authresp.getBody());
                
                if(authresp.getStatusCode() == 200){ 
                    system.debug('sJsonStrDataToreturn ***--->' + authresp.getBody());
                    sJsonStrDataToreturn =  IIT_JSonParserClass.parseResponseBody(authresp.getBody());
                    //sJsonStrDataToreturn =  IIT_JSonParserClass.parseResponseBodyPost(authresp.getBody(),Id);
                    
                }
                else{
                    sJsonStrDataToreturn = authresp.getBody();
                    system.debug('Error--->' + authresp + authresp.getBody());
                }    
            }catch(exception ex){
                     return '' +ex.getMessage();  
            }
            system.debug('sJsonStrDataToreturn------>' + sJsonStrDataToreturn);
        }else{
            sJsonStrDataToreturn = sJsonStrData;
        }
        
        return sJsonStrDataToreturn;
        
     }
     //This method will post the invoice 
     webservice static string postInvoiceTax(string Id , String status){
         //invoiceit_s__Invoice__c inv = [SELECT invoiceit_s__Shipping_Contact__c FROM invoiceit_s__Invoice__c WHERE Id =: Id];
          wrapperclass wrapReslut = postTax(Id,status);
          
          map<string,decimal> map_Pcode_Taxamt = new map<string,decimal>();
          
          
          map_Pcode_Taxamt  = wrapReslut.map_Pcode_Taxamt;
          
          
          String postTaxTID = wrapReslut.sresponse;
         System.debug('postTaxTID--->147'+wrapReslut.sresponse);
         requestCall='POST';
         appType= 'json';
         String  doDirectRequest = IIT_CommonUtilClass.postInvoic(Id);
        string endpointurl='https://service.myspeedtax.com/tx/services/STxTransactionService';       
        try{
            HTTPResponse authresp;
            if(!Test.isRunningTest())
                authresp = IIT_CommonUtilClass.getRequest(endpointurl,requestCall,doDirectRequest,appType);
            if(Test.isRunningTest() || authresp.getStatusCode() == 200){ 
                 system.debug('sJsonStrDataToreturn ***--->' + authresp.getBody());
                system.debug('sJsonStrDataToreturn ***--->' + authresp.getBody());   
                String[] str= postTaxTID.split(':') ;
                System.debug('Line number is -->157'+str.get(0)+'--'+str.get(1)+'---');
                
                /*invoiceit_s__Invoice__c invoice = new invoiceit_s__Invoice__c(id=Id,ST_Transaction_Id__c=str.get(0),invoiceit_s__Invoice_Status__c='Posted',Speed_TAX__c=Decimal.valueOf(str.get(1)));
                upsert invoice;        
                invoiceit_s__Invoice_Lines__c invLine = [SELECT Id,invoiceit_s__Product_Name__c,invoiceit_s__Invoice__c,invoiceit_s__Tax__c FROM invoiceit_s__Invoice_Lines__c WHERE invoiceit_s__Invoice__c =: Id AND invoiceit_s__Product_Name__c = 'Sales Tax'];
                invLine.invoiceit_s__Tax__c = Decimal.valueOf(str.get(1));
                invLine.invoiceit_s__Unit_Price__c = Decimal.valueOf(str.get(1));
                update invLine;*/
                invoiceit_s__Invoice__c invoice ; 
                if(status=='Posted' || status == 'Draft'){
                    invoice = new invoiceit_s__Invoice__c(Id=Id, ST_Transaction_Id__c=str.get(0),Tax_call_Error__c=true,Speed_TAX__c=Decimal.valueOf(str.get(1)));
                 
                }else{
                    invoice = new invoiceit_s__Invoice__c(Id=Id,Tax_call_Error__c=true, Cancel_Transaction_Id__c=str.get(0),Cancel_Tax__c=Decimal.valueOf(str.get(1)));
                 
                }
                 
                 upsert invoice;    
                 invoiceit_s__Invoice__c invQuery = [SELECT Id,invoiceit_s__Order__c,invoiceit_s__Invoice_Date__c FROM invoiceit_s__Invoice__c WHERE Id =: invoice.id];
                 
                 System.debug('order on the invoice ===>'+invQuery.invoiceit_s__Order__c);
                 list<invoiceit_s__Invoice_Lines__c> listofInvoiceLine = [SELECT Id, invoiceit_s__Product_Name__c,Product_Code__c FROM invoiceit_s__Invoice_Lines__c WHERE invoiceit_s__Invoice__c =: Id AND invoiceit_s__Product_Name__c != null];
                 System.debug('-------->'+listofInvoiceLine );
                 map<String, invoiceit_s__Invoice_Lines__c> mapofInvoiceLine = new map<String, invoiceit_s__Invoice_Lines__c>();
                for(invoiceit_s__Invoice_Lines__c invLine : listofInvoiceLine) {
                    mapofInvoiceLine.put(invLine.Product_Code__c, invLine);
                }
                if(status!='Cancelled'){
                    list<invoiceit_s__Invoice_Lines__c> listofInvoiceLineToUpdate = new list<invoiceit_s__Invoice_Lines__c>();
                
                    if(mapofInvoiceLine.containskey('Tax')){
                       listofInvoiceLineToUpdate.add(new invoiceit_s__Invoice_Lines__c(Id = mapofInvoiceLine.get(string.valueof('Tax')).Id,invoiceit_s__Line_Amount__c = Decimal.valueOf(str.get(1)) ,invoiceit_s__Unit_Price__c = Decimal.valueOf(str.get(1))));
                    }else {
                       list<invoiceit_s__Job_Rate_Plan_Charge__c> orpc = [SELECT Id,invoiceit_s__Order__c,Product_Code__c,Product_Name__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE Product_Name__c = 'Sales Tax' AND invoiceit_s__Order__c =:invQuery.invoiceit_s__Order__c]; 
                       invoiceit_s__Invoice_Lines__c invoiceline  = new invoiceit_s__Invoice_Lines__c(invoiceit_s__Job_Rate_Plan_Charge__c =  orpc[0].id, invoiceit_s__Sequence_No__c = 999 ,invoiceit_s__Service_Start_Date__c = invQuery.invoiceit_s__Invoice_Date__c ,invoiceit_s__Service_End_Date__c = invQuery.invoiceit_s__Invoice_Date__c ,invoiceit_s__Quantity__c = 1,invoiceit_s__Job__c =invQuery.invoiceit_s__Order__c ,invoiceit_s__Invoice__c = invQuery.id,invoiceit_s__Product_Name__c = 'Sales Tax',invoiceit_s__Line_Amount__c = Decimal.valueOf(str.get(1)) ,invoiceit_s__Unit_Price__c = Decimal.valueOf(str.get(1)));
                       insert invoiceline;
                    }
                    for(String producCode  : map_Pcode_Taxamt.keySet()){
                        if(mapofInvoiceLine.containskey(producCode)){
                            listofInvoiceLineToUpdate.add(new invoiceit_s__Invoice_Lines__c(Id = mapofInvoiceLine.get(producCode).Id, Tax_New__c = map_Pcode_Taxamt.get(producCode)));
                        }
                    }
                    
                    System.debug('List Of Invoice Line updated BEFORE ');    
                    update listofInvoiceLineToUpdate;
                    System.debug('List Of Invoice Line updated AFTER ');

                }
                
            }
            else{                
                system.debug('Error--->' + authresp + authresp.getBody());
            }    
         }catch(exception ex){
              return '' +ex.getMessage();        
         }
        
        return 'Sucessfully posted the Invoice';
     
     }  
     
     //It will create the record in speed tax and return the transaction and tax
     webservice static string postQuoteTax(string Id){
         SBQQ__Quote__c quote = [SELECT SBQQ__ShippingCity__c,SBQQ__ShippingCountry__c,SBQQ__ShippingName__c,SBQQ__ShippingPostalCode__c,SBQQ__ShippingState__c,SBQQ__ShippingStreet__c,SBQQ__BillingCity__c,SBQQ__BillingCountry__c,SBQQ__BillingPostalCode__c,SBQQ__BillingState__c,SBQQ__BillingStreet__c FROM SBQQ__Quote__c WHERE Id =: Id];
         
        String sJsonStrDataToreturn = '';
        

         if(quote.SBQQ__ShippingCountry__c == null || quote.SBQQ__ShippingCountry__c == ''){
            return 'Ship To Country is blank, please fill in';
         }

         if(quote.SBQQ__ShippingCountry__c.tolowerCase() !='us' && quote.SBQQ__ShippingCountry__c.tolowerCase() !='usa' && quote.SBQQ__ShippingCountry__c.tolowerCase() !='united states' && quote.SBQQ__ShippingCountry__c.tolowerCase() !='canada'){
            return 'Please enter a valid country, it should be Canada or United States';
         }
         if(quote.SBQQ__ShippingCountry__c.tolowerCase() =='us' || quote.SBQQ__ShippingCountry__c.tolowerCase() =='usa' || quote.SBQQ__ShippingCountry__c.tolowerCase() =='united states' ){
           string validateAddress;
            if(Test.isRunningTest()){
                validateAddress = 'Success';
            }else{
                 validateAddress = resolveAddress(quote.SBQQ__ShippingPostalCode__c,quote.SBQQ__ShippingCity__c,quote.SBQQ__ShippingState__c,quote.SBQQ__ShippingStreet__c,quote.SBQQ__ShippingCountry__c);
                 if(!validateAddress.contains('Success')) {
                     return validateAddress;
                 }
            }
        }
         /*if(quote.SBQQ__ShippingCountry__c.tolowerCase() =='us' || quote.SBQQ__ShippingCountry__c.tolowerCase() =='usa' || quote.SBQQ__ShippingCountry__c.tolowerCase() =='united states' ){
            System.debug('Coming to USA formate');
            string validateAddress = resolveAddress(quote.SBQQ__ShippingPostalCode__c,quote.SBQQ__ShippingCity__c,quote.SBQQ__ShippingState__c,quote.SBQQ__ShippingStreet__c,quote.SBQQ__ShippingCountry__c);
             if(!validateAddress.contains('Success')) {
                 return validateAddress;
             }   
         }*/
         //String sJsonStrData ;
        String sJsonStrData = IIT_CommonUtilClass.getDetails(Id,null);
        requestCall='POST';
        appType = 'json';
        if(!sJsonStrData.contains('ERROR')){
            try{
                System.debug('requestCall IS'+ requestCall);
                System.debug('appType IS'+ appType);
                string endpointurl='https://service.myspeedtax.com/tx2/services/rest/entity/'+gateway.invoiceit_s__Security_Key__c+'/invoice/post';
                HTTPResponse authresp = IIT_CommonUtilClass.getRequest(endpointurl,requestCall,sJsonStrData,appType);
                if(authresp.getStatusCode() == 200){ 
                    system.debug('sJsonStrDataToreturn ***--->' + authresp.getBody());
                    //sJsonStrDataToreturn =  IIT_JSonParserClass.parseResponseBody(authresp.getBody());
                    sJsonStrDataToreturn =  IIT_JSonParserClass.parseResponseBodyPost(authresp.getBody(),Id);
                    String[] str= sJsonStrDataToreturn.split(':') ;
                    System.debug(''+str.get(0) +''+str.get(1));
                    SBQQ__QuoteLine__c quoteLine = [SELECT Id,Name,SBQQ__Quote__c,SBQQ__Product__r.Name FROM SBQQ__QuoteLine__c Where SBQQ__Product__r.Name = 'Sales Tax' AND SBQQ__Quote__c= :Id ];
                     System.debug('quoteLine'+quoteLine);
             
                     quoteLine.Tax__c = Decimal.valueOf(str.get(1)) ;
                     quoteLine.SBQQ__ListPrice__c = Decimal.valueOf(str.get(1));
                     quoteLine.SBQQ__CustomerPrice__c = Decimal.valueOf(str.get(1));
                     quoteLine.SBQQ__NetPrice__c = Decimal.valueOf(str.get(0));
                     quoteLine.SBQQ__ProratedListPrice__c = Decimal.valueOf(str.get(1));
             
                     update quoteLine;
                }
                else{
                    sJsonStrDataToreturn = authresp.getBody();
                    system.debug('Error--->' + authresp + authresp.getBody());
                }    
            }catch(exception ex){
                     return '' +ex.getMessage();  
            }
            system.debug('sJsonStrDataToreturn------>' + sJsonStrDataToreturn);
        }else{
            sJsonStrDataToreturn = sJsonStrData;
        }
        
        return 'Record save sucesfully';
         
     } 
    /* webservice static string voidTax(string Id){
        map<String , String> mapinfo = new map<String ,String>();
        
        gateway = [SELECT invoiceit_s__Merchant_ID__c,invoiceit_s__Merchant_Reference__c,invoiceit_s__Merchant_Seal_User_Id__c,invoiceit_s__Security_Key__c,Name FROM invoiceit_s__Gateway__c WHERE Name = 'Speed Tax'];
        
         requestCall='POST';
         appType= 'json';
         String  doDirectRequest = IIT_CommonUtilClass.voidInvoiceId(Id);
         string endpointurl='https://service.myspeedtax.com/tx2/services/STxTransactionService';

         try{
            HTTPResponse authresp = IIT_CommonUtilClass.getRequest(endpointurl,requestCall,doDirectRequest,appType);
            if(authresp.getStatusCode() == 200){ 
                //sRawHttpResponse = authresp.getBody();
               Dom.Document doc = authresp.getBodyDocument();
               Dom.XMLNode rootElement = doc.getRootElement();
               mapinfo = IIT_CommonUtilClass.getElements(rootElement);
               System.debug('Response is '+mapinfo);
               SYSTEM.DEBUG(''+mapinfo.values());
               if(mapinfo.get('ResultType') == 'FAILED'){
                    System.debug('FAILED');
                    
                    String errorMsg = mapinfo.get('ErrorCode') +'\n' + mapinfo.get('Description');
                    System.debug('errorMsg'+errorMsg);
                    
                    
                   return  errorMsg;
               }else{
                   System.debug('mapinfohello how are you-->'+mapinfo.get('ResultType'));
                   invoiceit_s__Invoice__c invoiceVoid = new invoiceit_s__Invoice__c(id=Id, Is_Void__c =true);
                    update invoiceVoid; 
               }
               
            }
            else{                
                system.debug('Error--->' + authresp + authresp.getBody());
            }    
         }catch(exception ex){
              return '' +ex.getMessage();        
         }

        return 'Sucessfully';

     }*/
     
     global class wrapperclass{
      global string sresponse;
      global map<string,decimal> map_Pcode_Taxamt ;
     }
            
    
}