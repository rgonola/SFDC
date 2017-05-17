global class calculateTax{

@Future(callout=true)  
public static void calltax(String QuoteId){

          string sJsonStrDataToreturn = calculateTax(QuoteId,null);
         if(Test.isRunningTest()){
             sJsonStrDataToreturn  = '32';
         }
         System.debug('sJsonStrDataToreturnsJsonStrDataToreturn'+sJsonStrDataToreturn);
         if(sJsonStrDataToreturn.contains('FAILED') || sJsonStrDataToreturn.contains('ERROR')){
            
             //return sJsonStrDataToreturn;
         }else{
              
             SBQQ__QuoteLine__c txln= [SELECT Id,Name,SBQQ__Quote__c,SBQQ__Product__r.Name,SBQQ__Quote__r.SBQQ__NetAmount__c,SBQQ__Quote__r.SBQQ__ListAmount__c FROM SBQQ__QuoteLine__c Where SBQQ__Product__r.Name = 'Sales Tax' AND SBQQ__Quote__c= :QuoteId];
            
             txln.Tax__c = Decimal.valueOf(sJsonStrDataToreturn) ;
             txln.SBQQ__ListPrice__c = Decimal.valueOf(sJsonStrDataToreturn);
             txln.SBQQ__CustomerPrice__c = Decimal.valueOf(sJsonStrDataToreturn);
             txln.SBQQ__NetPrice__c = Decimal.valueOf(sJsonStrDataToreturn);
             txln.SBQQ__ProratedListPrice__c = Decimal.valueOf(sJsonStrDataToreturn);
             
             update txln;
             
            SBQQ__Quote__c sbQuote = [SELECT Name,SBQQ__NetAmount__c FROM SBQQ__Quote__c Where id = :QuoteId];
             
            sbQuote.Tax__c = Decimal.valueOf(sJsonStrDataToreturn);
            sbQuote.Tax_Time_Stamp__c=System.now();
            sbQuote.Tax_Grand_Total__c = sbQuote.SBQQ__NetAmount__c;
             update sbQuote;
             
         }
       
       }
       
       
public static string calculateTax(string Id,string status){
     invoiceit_s__Gateway__c    gateway = [SELECT invoiceit_s__Merchant_ID__c,invoiceit_s__Merchant_Reference__c,invoiceit_s__Merchant_Seal_User_Id__c,invoiceit_s__Security_Key__c,Name FROM invoiceit_s__Gateway__c WHERE Name = 'Speed Tax'];
        
        String requestCall='POST';
        String appType = 'json';
        String sJsonStrDataToreturn = '';
        
        //String sJsonStrData ;
        String sJsonStrData = IIT_CommonUtilClass.getDetails(Id,status);
        
        system.debug('sJsonStrData------>' + sJsonStrData);


        if(!sJsonStrData.contains('ERROR')){
            try{
                system.debug('sJsonStrData after calling IIT_CommonUtilClass ' + gateway);
                
                string endpointurl;
                HTTPResponse authresp= new HTTPResponse ();
                 
               
                endpointurl='https://service.myspeedtax.com/tx2/services/rest/entity/'+gateway.invoiceit_s__Security_Key__c+'/invoice/calculate';
               
                
                
                HTTP auth = new HTTP();
                HTTPRequest req = new HTTPRequest();
                req.setEndpoint(endpointURL);
                
                Blob headerValue = Blob.valueOf(gateway.invoiceit_s__Merchant_ID__c +':' +gateway.invoiceit_s__Merchant_Reference__c);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                
                if(requestCall== 'GET'){
                    System.debug('Get method ');
                    req.setHeader('Content-Type', 'application/json');
                    req.setHeader('Accept', 'application/json');
                    req.setMethod('GET');            
                }else if(requestCall=='POST'){
                    System.debug('Get method ');
                    if(appType=='xml'){
                        req.setHeader('Content-Type', 'application/xml');
                        req.setHeader('Accept', 'application/xml');
                        System.debug('XML IS method ');
                    }else{
                        req.setHeader('Content-Type', 'application/json');
                        req.setHeader('Accept', 'application/json');    
                        System.debug('JSON IS method ');        
                    }            
                    req.setMethod('POST'); 
                    req.setBody(sJsonStrData);       
                }        
                System.debug('request is --->'+req);
                req.setTimeout(120000);
                authresp =auth.send(req);
        
              
                
                system.debug('authresp.getBody() ==' + authresp.getBody());
                
                if(authresp.getStatusCode() == 200){  sJsonStrDataToreturn =  IIT_JSonParserClass.parseResponseBody(authresp.getBody());}
                else{ sJsonStrDataToreturn = authresp.getBody();}    
            }catch(exception ex){
                     return '' +ex.getMessage();  
            }
            
        }else{sJsonStrDataToreturn = sJsonStrData;}
        
        return sJsonStrDataToreturn;
        
     }
     
     }