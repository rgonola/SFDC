public without sharing class PaymentconfirmationExtension{
    
    public Account acnt {get;set;}
    public List<Contact> cnt{ get; set; }
    public String memberaccuntId { get; set; }
    public String pid { get; set; }
    public List<Account> acntdet { get; set; }
    Public invoiceit_s__Payment_Method__c pymntmethd {get; set;}
    Public List<invoiceit_s__Payment_Method__c> availablepymnt {get; set;}
    Public invoiceit_s__Payment_Method__c displymnt {get; set;}
    Public SBQQ__Quote__c qute {get;set;}
    Public Account accnt {get;set;}
    Public cart__c cart {get;set;}
    Public Boolean success {get;set;}
    Public Boolean Ismissingfileds{get;set;}
    Public List<Product2> pi{get;set;} 
     public Boolean newppi{get;set;}
     public Boolean isretry{get;set;}
     public Boolean nopaymntprcsd{get;set;}
     static transactionError trxError;
    public List<invoiceit_s__Payment_Plan__c>  ppl{get;set;}
    Public Boolean nonlogin{get;set;}
    Public Boolean iserror {get;set;}
    Public List<SBQQ__QuoteLine__c> quteline {get;set;}
    private Map<Id, SBQQ__ProductOption__c> options;
    Public List<SBQQ__ProductOption__c> featureoptions{get;set;}
    Public List<SBQQ__QuoteLine__c> reqqut {get;set;}
    public Map<String, Map<String, List<SBQQ__ProductOption__c>>> productFeatures {get;set;}
    public Map<Id,Id> mapquotelines{get;set;}
    public Map<String,String> mapprdctincluded{get;set;}
    public List<invoiceit_s__Transaction__c> Errorpymnts{get;set;}
     public SBQQ__QuoteLine__c  salesqutln{get; set;} 
    public Map<String,String> mapdisplaycard{get;set;}
    public Map<String, List<SBQQ__ProductOption__c>> productToSelectedOptionsMap {get;set;}
    public Map<String, List<SBQQ__ProductOption__c>> featuresWithOptions {get;set;}
    Public invoiceit_s__Payment_Plan_Installment__c pymntplninstmnt {get;set;}
    public List<invoiceit_s__Payment_Method__c> mthofpay {get;set;}
    public Map<String, Boolean> hasFeatures {get;set;}
    public Map<Id, Product2> productMap {get;set;}
    public Boolean proceedToOrder {get;set;}
    public Web_Opp__c webopp  {get;set;}
    public List<SBQQ__QuoteLine__c> mainprdctqutlines{get;set;}
    public List<SBQQ__QuoteLine__c> optionsToUpdate {get;set;}
    public Set<String> optlineitems{get;set;}
    public Map<string,SBQQ__QuoteLine__c > rqrdqutlinemap{get;set;}
    Public invoiceit_s__Payment_Method__c ccpm {get; set;}
    Public invoiceit_s__Payment_Method__c achpm {get; set;}
     
    
    public PaymentconfirmationExtension(ApexPages.StandardController stdController) {
         proceedToOrder = true;
         salesqutln = new SBQQ__QuoteLine__c();
         iserror=false;
         newppi=false;
         isretry=false;
         nopaymntprcsd=false;
         Ismissingfileds=false;
         pymntmethd = new invoiceit_s__Payment_Method__c();
         productToSelectedOptionsMap = new Map<String, List<SBQQ__ProductOption__c>>(); 
         pymntplninstmnt = new invoiceit_s__Payment_Plan_Installment__c();
         ccpm = new invoiceit_s__Payment_Method__c();
         achpm = new invoiceit_s__Payment_Method__c();
         ccpm.Same_as_Shipping_Add__c=true;
         achpm.Same_as_Shipping_Add__c=true;
         
         
         // Get the Account id
         memberaccuntId = ApexPages.currentPage().getParameters().get( 'accuntId'); 
          String memberaccuntId1 = ApexPages.currentPage().getParameters().get( 'SFDCCartID'); 
         pid='';
         
                try{  
             //check existed cookie
        Cookie idCookie = ApexPages.currentPage().getCookies().get('cartId');             
          cart =[select id,Total_Price__c,cart_Account__c,Existing_login__c From Cart__c Where (id=:memberaccuntId OR Id=:memberaccuntId1 ) ];
         system.debug('info here'+idCookie.getvalue());
        
            }catch(Exception e){}
                 
                   pi=[Select Id,Name From Product2 Where Name='Sales Tax' AND IsActive= true Limit 1 ];

                    
                 
                ppl= [select id,Name From invoiceit_s__Payment_Plan__c Where Name='Paid In Full Payment Plan'];
                
                acnt =[Select id,OwnerId,Name,Missing_Billing_Shipping_Info__c,BillingStreet,Billingcity,BillingState,Billingpostalcode,SBQQ__DefaultOpportunity__r.SBQQ__PrimaryQuote__c,SBQQ__DefaultOpportunity__c,Email__c,ShippingStreet,shippingcity,shippingState,
                              shippingpostalcode,Acct_Primary_Contact__r.Email,Acct_Primary_Contact__r.Name,Acct_Primary_Contact__r.Phone,Primary_Contact_Name__c,(SELECT
                              name,Contact.FirstName, Contact.LastName
                              FROM Account.Contacts) From Account where id=:cart.cart_Account__c];
                
                cnt=[Select Id,AccountID,Is_Primary__c,Abandoned_User_Renewal__c,Abandoned_User_New__c,Email,Phone From Contact Where Is_Primary__c =true AND AccountID=:acnt.id order by CreatedDate desc Limit 1 ];
              
               availablepymnt =[Select Id,invoiceit_s__Billing_First_Name__c,invoiceit_s__Billing_Last_Name__c,invoiceit_s__Billing_Email__c,invoiceit_s__Account__c,
                                       invoiceit_s__Active__c,invoiceit_s__Payment_Method__c,invoiceit_s__Default__c,invoiceit_s__Name_on_Card__c,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,
                                       invoiceit_s__Card_Expiration_Year__c,invoiceit_s__CVV__c,Actno_Last4digits__c,invoiceit_s__Bank_Account_Number__c,invoiceit_s__Bank_Account_Name__c,invoiceit_s__Bank_Account_Type__c,invoiceit_s__Bank_Name__c,
                                       invoiceit_s__Bank_Routing_Code__c,invoiceit_s__Billing_Address__c,invoiceit_s__Billing_City__c,invoiceit_s__Billing_State_Province__c,invoiceit_s__Billing_Zip_Postal__c,
                                       invoiceit_s__Billing_Country__c,Same_as_Shipping_Add__c  From invoiceit_s__Payment_Method__c Where invoiceit_s__Account__c=:acnt.id ];
               
               
               if(acnt.Missing_Billing_Shipping_Info__c == True ){
               
               Ismissingfileds=true;
               
               }
               mapdisplaycard= new Map<String,String>();
               
               for(invoiceit_s__Payment_Method__c pm:availablepymnt ){
              
                
               if(pm.invoiceit_s__Payment_Method__c=='Credit Card'){
               if(pm.invoiceit_s__Card_Number__c.length()>4){
               string lst4 = pm.invoiceit_s__Card_Number__c.substring(12, 16);
               mapdisplaycard.put(pm.id,lst4);
               }else{
               mapdisplaycard.put(pm.id,pm.invoiceit_s__Card_Number__c);
               }
               }
               if(pm.invoiceit_s__Payment_Method__c!='Credit Card'){
               mapdisplaycard.put(pm.id,pm.Actno_Last4digits__c);
               system.debug('****pymnt'+mapdisplaycard);
               }
                
               }
                //Display quote information 
                qute =[select Id,Net_Minus_Tax_Fees__c,Sub_Total__c,Tax__c,Tax_Calculated__c,Processing_Fees__c,Payment_Processed__c,SBQQ__Primary__c,SBQQ__Account__c,SBQQ__CustomerAmount__c,Retry_count__c,
                              SBQQ__BillingName__c,SBQQ__BillingStreet__c,SBQQ__BillingCity__c,SBQQ__BillingState__c,SBQQ__BillingPostalCode__c,SBQQ__BillingCountry__c,SBQQ__Account__r.BillingState,SBQQ__Account__r.BillingStreet,SBQQ__Account__r.BillingCity,SBQQ__Account__r.BillingPostalCode,SBQQ__Account__r.ShippingState,SBQQ__Account__r.ShippingStreet,SBQQ__Account__r.ShippingCity,SBQQ__Account__r.ShippingPostalCode,
                              SBQQ__ShippingName__c,SBQQ__ShippingStreet__c,SBQQ__ShippingCity__c,SBQQ__ShippingState__c,SBQQ__ShippingPostalCode__c,SBQQ__ShippingCountry__c, IFirm_Campaign__c,
                              SBQQ__TotalCustomerDiscountAmount__c,Primary_Email__c,Primay_Phone__c from SBQQ__Quote__c where SBQQ__Account__c =: acnt.id AND SBQQ__Primary__c =true  
                              order by CreatedDate desc Limit 1];
                system.debug('qute'+qute);
                                
                  webopp = [select id,web_quote__c,Amount__c,Type__c,Company_Name__c,Primary_Contact_Name__c,Primary_Phone__c,WebAccount__c,Primary_Email__c,Opportunity__c From Web_Opp__c where web_quote__c =:qute.id order by Createddate Limit 1];
                
                
                Map<Id,Id> mapquotelines= new Map<Id, Id>();
                mapprdctincluded= new Map<String,String>();
                
                quteline =[select Id,SBQQ__Bundle__c,SBQQ__CustomerPrice__c,SBQQ__RequiredBy__c,SBQQ__ListPrice__c,SBQQ__Product__r.Detail_description__c,SBQQ__ComponentListTotal__c,SBQQ__Product__r.List_Price__c,SBQQ__NetPrice__c,
                                  SBQQ__CustomerTotal__c,SBQQ__Product__c,SBQQ__Product__r.Family,SBQQ__Product__r.Marketing_Name__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,SBQQ__ListTotal__c,
                                  SBQQ__Quantity__c  From SBQQ__QuoteLine__c  Where SBQQ__Quote__c = :qute.Id AND SBQQ__Product__c != null AND
                                  SBQQ__Product__r.Name != 'Sales Tax' AND SBQQ__RequiredBy__c = null order by SBQQ__Number__c ];
                                  
                for(SBQQ__QuoteLine__c qt :quteline ){
                    if(qt.SBQQ__Product__r.Name != 'Sales Tax'){
                mapquotelines.put(qt.SBQQ__Product__c,qt.Id );
                    }
                system.debug('**********************'+mapquotelines +qt);
                }
                system.debug(''+quteline );
                
                //featureoptions= [Select Id,SBQQ__OptionalSKU__r.Name,SBQQ__ConfiguredSKU__c From SBQQ__ProductOption__c  Where SBQQ__ConfiguredSKU__c IN :mapquotelines.keyset() AND SBQQ__Bundled__c =TRUE AND SBQQ__Required__c = true];
                
                //Get Feature options 
                for(SBQQ__ProductOption__c ml :[Select Id,SBQQ__OptionalSKU__r.Name,SBQQ__OptionalSKU__r.Marketing_Name__c,SBQQ__OptionalSKU__r.List_Price__c,SBQQ__ConfiguredSKU__c From SBQQ__ProductOption__c  Where  SBQQ__ConfiguredSKU__c IN :mapquotelines.keyset() AND SBQQ__Bundled__c =TRUE AND SBQQ__Required__c = true AND SBQQ__OptionalSKU__r.SBQQ__Hidden__c =False] ){
                    List<SBQQ__ProductOption__c> options = new List<SBQQ__ProductOption__c>{ml};
                    if(productToSelectedOptionsMap.containsKey(ml.SBQQ__ConfiguredSKU__c))
                        options.addAll(productToSelectedOptionsMap.get(ml.SBQQ__ConfiguredSKU__c));
                        system.debug('dfss'+options);
                    if(options !=null  ){
                    productToSelectedOptionsMap.put(ml.SBQQ__ConfiguredSKU__c, options);
                    }
                    if(!mapprdctincluded.containsKey(ml.SBQQ__ConfiguredSKU__c )) {
                        mapprdctincluded.put(ml.Id,ml.SBQQ__OptionalSKU__r.Marketing_Name__c );
                        system.debug('**********************'+mapprdctincluded);
                    }
               }
                
                
                //display selected option from the shopping cart
                Map<Id,Id> reqqutlinesmap= new Map<Id, Id>();
                
                List<SBQQ__QuoteLine__c> reqqut =[select Id,SBQQ__Bundle__c,SBQQ__RequiredBy__c,SBQQ__ListPrice__c,SBQQ__ProductOption__c From SBQQ__QuoteLine__c  Where SBQQ__Quote__c = :qute.Id AND SBQQ__Product__c != null AND SBQQ__Bundled__c!= true AND SBQQ__RequiredBy__c != null order by SBQQ__Number__c ];
                for(SBQQ__QuoteLine__c q :reqqut ){
                reqqutlinesmap.put(q.SBQQ__ProductOption__c,q.Id );
                }
                
                featuresWithOptions = new Map<String, List<SBQQ__ProductOption__c>>();
                productFeatures = new Map<String, Map<String, List<SBQQ__ProductOption__c>>>();
                Set<Id> optionProductIds = new Set<Id>();
                options = new Map<Id, SBQQ__ProductOption__c>([Select Id,Name,SBQQ__Feature__r.Name, Display_Type__c, SBQQ__Number__c,SBQQ__ConfiguredSKU__c,SBQQ__OptionalSKU__r.List_Price__c, 
                                                                                                        SBQQ__ProductName__c,SBQQ__OptionalSKU__r.Marketing_Name__c,  SBQQ__OptionalSKU__c,SBQQ__Required__c, SBQQ__Bundled__c   
                                                                                                 From SBQQ__ProductOption__c 
                                                                                                 Where Id IN : reqqutlinesmap.keyset() AND SBQQ__ConfiguredSKU__c = :mapquotelines.keyset() AND
                                                                                                       SBQQ__Feature__c != null  AND SBQQ__Feature__r.Name !='Fees' AND SBQQ__OptionalSKU__r.SBQQ__Hidden__c =False
                                                                                                 ORDER BY SBQQ__Feature__r.SBQQ__Number__c, SBQQ__Number__c ASC]);
                     system.debug('*****options'+options);
                for(SBQQ__ProductOption__c option : options.values()) {
                                  
                    if(!productFeatures.containsKey(option.SBQQ__ConfiguredSKU__c)) {
                        productFeatures.put(option.SBQQ__ConfiguredSKU__c, new Map<String, List<SBQQ__ProductOption__c>>{option.SBQQ__Feature__r.Name => new List<SBQQ__ProductOption__c>{option}});
                        system.debug('*****productFeatures'+productFeatures);
                    }
                    else {
                        featuresWithOptions = productFeatures.get(option.SBQQ__ConfiguredSKU__c);
                        
                        if(!featuresWithOptions.containsKey(option.SBQQ__Feature__r.Name))
                            featuresWithOptions.put(option.SBQQ__Feature__r.Name, new List<SBQQ__ProductOption__c>{option});
                        else 
                            featuresWithOptions.get(option.SBQQ__Feature__r.Name).add(option);
                        
                        productFeatures.put(option.SBQQ__ConfiguredSKU__c, featuresWithOptions);
                    }
                    optionProductIds.add(option.SBQQ__OptionalSKU__c);
                    
                }

                //  Used to display Product description, when  there are no options selected for a product
                productMap = new Map<Id, Product2>([Select Id, Description From product2 Where Id IN : mapquotelines.keyset()]);
                
                hasFeatures = new Map<String, Boolean>();
                //  Adds productIds to the map, which have no options
                for(String s : mapquotelines.keyset()) {
                    if(!productToSelectedOptionsMap.containsKey(s)) {
                        productToSelectedOptionsMap.put(s, new List<SBQQ__ProductOption__c>());
                        hasFeatures.put(s, false);
                    }
                    else
                        hasFeatures.put(s, true);
                }

                //  Adds productIds to the map, which have no options
                for(String s : mapquotelines.keyset()) {
                    if(!productFeatures.containsKey(s)){
                        productFeatures.put(s, new Map<String, List<SBQQ__ProductOption__c>>());
                        }else{
                        hasFeatures.put(s, true);
                        }
                }
        
                
    }
  
       
    Public PageReference savecc(){
            
            Account Existingaccnt =acnt;
            ccpm.invoiceit_s__Account__c = Existingaccnt.id;
           system.debug('payment mode' +Existingaccnt.id);
           system.debug('payment mode'+ccpm );
           
          if(ccpm.invoiceit_s__Card_Number__c == null || ccpm.invoiceit_s__Card_Number__c == ''){
             ccpm.invoiceit_s__CVV__c = null; 
            VFUtil.AddErrorMessage ( 'Invalid credit card number.');
             return null;
           }

           if ( ccpm.invoiceit_s__Billing_First_Name__c== null || ccpm.invoiceit_s__Billing_First_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid name on account.');
            return null;
        }  
           
           if ( ccpm.invoiceit_s__Billing_Last_Name__c== null || ccpm.invoiceit_s__Billing_Last_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid name on account.');
            return null;
        }  
           
           if(ccpm.invoiceit_s__Card_Expiration_Month__c == null || ccpm.invoiceit_s__Card_Expiration_Month__c == ''){
            ccpm.invoiceit_s__CVV__c = null; 
            ccpm.invoiceit_s__Card_Number__c = null;  
            VFUtil.AddErrorMessage ( 'Select credit card expiration month.');
             return null;
           }
           
           if(ccpm.invoiceit_s__Card_Expiration_Year__c == null || ccpm.invoiceit_s__Card_Expiration_Year__c == ''){
            ccpm.invoiceit_s__CVV__c = null; 
            ccpm.invoiceit_s__Card_Number__c = null;  
            VFUtil.AddErrorMessage ( 'Select credit card expiration year.');
             return null;
           }

           if(ccpm.invoiceit_s__Card_Type__c == null || ccpm.invoiceit_s__Card_Type__c == ''){
            ccpm.invoiceit_s__CVV__c = null; 
            ccpm.invoiceit_s__Card_Number__c = null;  
            VFUtil.AddErrorMessage ( 'Select credit card type.');
             return null;
           }
          if ( (ccpm.invoiceit_s__CVV__c != null && ccpm.invoiceit_s__CVV__c != '' && ccpm.invoiceit_s__Card_Type__c != 'American Express' && !Pattern.matches('^([0-9]{3})||([0-9]{5}-[0-9]{4})$', ccpm.invoiceit_s__CVV__c)) || ( ccpm.invoiceit_s__CVV__c == null || ccpm.invoiceit_s__CVV__c == '') ) {
            ccpm.invoiceit_s__CVV__c = null; 
            ccpm.invoiceit_s__Card_Number__c = null;         
            VFUtil.AddErrorMessage ( 'Invalid security number.');
            return null;
          } 
            if ( (ccpm.invoiceit_s__CVV__c != null && ccpm.invoiceit_s__CVV__c != '' && ccpm.invoiceit_s__Card_Type__c == 'American Express' && !Pattern.matches('^([0-9]{4})||([0-9]{5}-[0-9]{4})$', ccpm.invoiceit_s__CVV__c)) || ( ccpm.invoiceit_s__CVV__c == null || ccpm.invoiceit_s__CVV__c == '') ) {
            ccpm.invoiceit_s__CVV__c = null; 
            ccpm.invoiceit_s__Card_Number__c = null;    
            VFUtil.AddErrorMessage ( 'Invalid security number.');
            return null;
        }

           // Expiration Date in the future
              String currentYearMonth = '' + Date.today().year();
              if ( Date.today().month() > 9 ) {
              currentYearMonth += Date.today().month();
              } else {
              currentYearMonth += '0' + Date.today().month();
               }
              if ( (ccpm.invoiceit_s__Card_Expiration_Year__c + ccpm.invoiceit_s__Card_Expiration_Month__c ) < currentYearMonth) {
              ccpm.invoiceit_s__CVV__c = null; 
              ccpm.invoiceit_s__Card_Number__c = null;  
               VFUtil.AddErrorMessage ( 'Credit card has expired.');
                return null;
               }

           CreditCardValidation cc = new CreditCardValidation();
           Boolean valid = cc.isValid(ccpm.invoiceit_s__Card_Type__c, ccpm.invoiceit_s__Card_Number__c);
           system.debug('valid????????'+valid);
          if(!valid ){
            system.debug('not valid card');
             ccpm.invoiceit_s__CVV__c = null; 
             ccpm.invoiceit_s__Card_Number__c = null;
            VFUtil.AddErrorMessage ( 'Invalid credit card number.');
             return null;

          }
         if(ccpm.Same_as_Shipping_Add__c ==true){
         ccpm.invoiceit_s__Billing_Address__c=Existingaccnt.BillingStreet;
         ccpm.invoiceit_s__Billing_City__c=Existingaccnt.BillingCity;
         ccpm.invoiceit_s__Billing_State_Province__c=Existingaccnt.BillingState;
         ccpm.invoiceit_s__Billing_Zip_Postal__c=Existingaccnt.BillingPostalCode;
         }
         
         if((ccpm.invoiceit_s__Billing_Address__c == null || ccpm.invoiceit_s__Billing_Address__c =='') && ccpm.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing address.');
         return null;
         }
         
         if((ccpm.invoiceit_s__Billing_City__c== null || ccpm.invoiceit_s__Billing_City__c=='') && ccpm.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing city.');
         return null;
         }
         
         if((ccpm.invoiceit_s__Billing_State_Province__c== null || ccpm.invoiceit_s__Billing_State_Province__c=='') && ccpm.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing state.');
         return null;
         }
         
         
         if((ccpm.invoiceit_s__Billing_Zip_Postal__c == null || ccpm.invoiceit_s__Billing_Zip_Postal__c =='') && ccpm.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a zip code.');
         return null;
         }
         
         if(!Test.isRunningTest()){
        ccpm.invoiceit_s__Billing_State_Province__c =ccpm.invoiceit_s__Billing_State_Province__c.toUpperCase();
         }
        // validate state
        
       Set<String> validStates = new Set<String>{ 'AS', 'AR', 'CA', 'UT', 'NV',
            'AL', 'AK', 'AZ', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA','GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY','MP', 
            'LA', 'ME','MH', 'MD', 'MA', 'MI','FM', 'MN', 'MS', 'MO', 'NV','MT', 'NE', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 
            'OH', 'OK', 'OR', 'PA','PW', 'RI', 'SC', 'SD', 'TN','UT', 'TX','VI', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY' };
            
            if ( !validStates.contains( ccpm.invoiceit_s__Billing_State_Province__c) || ccpm.invoiceit_s__Billing_State_Province__c.length() > 2 || ccpm.invoiceit_s__Billing_State_Province__c.length() < 2  ) {
            VFUtil.AddErrorMessage ('Enter valid state. Acceptable formats: GA,TX,CA,AZ.'); 
            return null;
                }
                
        
         
          if ( ccpm.invoiceit_s__Billing_Zip_Postal__c != null && ccpm.invoiceit_s__Billing_Zip_Postal__c != '' && !Pattern.matches('^([0-9]{5})||([0-9]{5}-[0-9]{4})$', ccpm.invoiceit_s__Billing_Zip_Postal__c) ) {
            VFUtil.AddErrorMessage ( 'Invalid zip code.');
            return null ;
        }   
        
          ccpm.invoiceit_s__Billing_Country__c='USA';
          ccpm.invoiceit_s__Billing_Email__c=Existingaccnt.Email__c;
          //upsert ccpm;
          
          system.debug('payment mode'+ccpm );
          
           ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(Existingaccnt);
          invoiceit_s.ControllerForGenerateTokenForCyberSource createTokenController = new invoiceit_s.ControllerForGenerateTokenForCyberSource(controller);
          createTokenController.paymentMethod  = ccpm;
          createTokenController.generateToken();
           
                     
        
       
        
           Decimal r=math.random();                  
           PageReference url = new PageReference('/apex/PaymentConfirmationPage?accuntId='+cart.id+'&r='+r);
           url.setRedirect(true);
           return url;            
    }

      Public PageReference saveAch(){
      
           Account Existingaccnt =acnt;
            achpm.invoiceit_s__Account__c = Existingaccnt.id;
          achpm.invoiceit_s__Payment_Method__c = 'ACH';
          
           if ( achpm.invoiceit_s__Billing_First_Name__c== null || achpm.invoiceit_s__Billing_First_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid name on account.');
            
            return null;
        }  
           
           if ( achpm.invoiceit_s__Billing_Last_Name__c== null || achpm.invoiceit_s__Billing_Last_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid name on account.');
            
            return null;
        }  
        
          if ( (achpm.invoiceit_s__Bank_Routing_Code__c != null && achpm.invoiceit_s__Bank_Routing_Code__c != ''  && !Pattern.matches('^([0-9]{9})||([0-9]{5}-[0-9]{4})$', achpm.invoiceit_s__Bank_Routing_Code__c)) || ( achpm.invoiceit_s__Bank_Routing_Code__c == null || achpm.invoiceit_s__Bank_Routing_Code__c == '') ) {
            
            VFUtil.AddErrorMessage ( 'Invalid routing number.');
            
            return null;
        }
            if (( achpm.invoiceit_s__Bank_Account_Number__c == null || achpm.invoiceit_s__Bank_Account_Number__c == '' ) ||(achpm.invoiceit_s__Bank_Account_Number__c.length() <4 || achpm.invoiceit_s__Bank_Account_Number__c.length() > 17 )){
            VFUtil.AddErrorMessage ( 'Invalid account number.');
            
            return null;
        }     

 
            if ( achpm.invoiceit_s__Bank_Account_Type__c == null || achpm.invoiceit_s__Bank_Account_Type__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Please select account type.');
            
            return null;
        }   
            
              if ( achpm.invoiceit_s__Bank_Name__c == null || achpm.invoiceit_s__Bank_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Please provide bank organization name.');
            
            return null;
        } 
         system.debug('payment mode'+achpm +Existingaccnt.id);
         
         if(achpm.Same_as_Shipping_Add__c ==true){
         achpm.invoiceit_s__Billing_Address__c=Existingaccnt.BillingStreet;
         achpm.invoiceit_s__Billing_City__c=Existingaccnt.BillingCity;
         achpm.invoiceit_s__Billing_State_Province__c=Existingaccnt.BillingState;
         achpm.invoiceit_s__Billing_Zip_Postal__c=Existingaccnt.BillingPostalCode;
         }
         
         if((achpm.invoiceit_s__Billing_Address__c == null || achpm.invoiceit_s__Billing_Address__c =='') && achpm.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing address.');
         return null;
         }
         
         if((achpm.invoiceit_s__Billing_City__c== null || achpm.invoiceit_s__Billing_City__c=='') && achpm.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing city.');
         return null;
         }
         
         if((achpm.invoiceit_s__Billing_State_Province__c== null || achpm.invoiceit_s__Billing_State_Province__c=='') && achpm.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing state.');
         return null;
         }
         
         if((achpm.invoiceit_s__Billing_Zip_Postal__c == null || achpm.invoiceit_s__Billing_Zip_Postal__c =='') && achpm.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a zip code.');
         return null;
         }
         
         if(!Test.isRunningTest()){
        achpm.invoiceit_s__Billing_State_Province__c =achpm.invoiceit_s__Billing_State_Province__c.toUpperCase();
         }
        // validate state
        
        Set<String> validStates = new Set<String>{ 'AS', 'AR', 'CA', 'UT', 'NV',
            'AL', 'AK', 'AZ', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA','GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY','MP', 
            'LA', 'ME','MH', 'MD', 'MA', 'MI','FM', 'MN', 'MS', 'MO', 'NV','MT', 'NE', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 
            'OH', 'OK', 'OR', 'PA','PW', 'RI', 'SC', 'SD', 'TN','UT', 'TX','VI', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY' };
            
            if ( !validStates.contains( achpm.invoiceit_s__Billing_State_Province__c) || achpm.invoiceit_s__Billing_State_Province__c.length() > 2 || achpm.invoiceit_s__Billing_State_Province__c.length() < 2  ) {
            VFUtil.AddErrorMessage ('Enter valid state. Acceptable formats: GA,TX,CA,AZ.'); 
            return null;
                }
                
        
         
          if ( achpm.invoiceit_s__Billing_Zip_Postal__c != null && achpm.invoiceit_s__Billing_Zip_Postal__c != '' && !Pattern.matches('^([0-9]{5})||([0-9]{5}-[0-9]{4})$', achpm.invoiceit_s__Billing_Zip_Postal__c) ) {
            VFUtil.AddErrorMessage ( 'Invalid zip code.');
            return null ;
        }   
         
          achpm.invoiceit_s__Billing_Country__c='USA';
          achpm.invoiceit_s__Billing_Email__c=Existingaccnt.Email__c;         
        
        String tokenId=CyberSourceConnection.getTokenFromACH(achpm);
        
        //Store only last four from Account Number
        
        if(achpm.invoiceit_s__Bank_Account_Number__c.length() >4){
        Integer len= achpm.invoiceit_s__Bank_Account_Number__c.length();
        Integer substringval;
        
        substringval = len-4;
        
        achpm.invoiceit_s__Bank_Account_Number__c= achpm.invoiceit_s__Bank_Account_Number__c.substring(substringval,len);
        }
        
        //Store only last four from Routing Number
       /* if(paymentMethod.invoiceit_s__Bank_Routing_Code__c.length() >4){
        Integer routlen= paymentMethod.invoiceit_s__Bank_Routing_Code__c.length();
        Integer routsubstringval;
        
        routsubstringval = routlen-4;
        
        paymentMethod.invoiceit_s__Bank_Routing_Code__c= paymentMethod.invoiceit_s__Bank_Routing_Code__c.substring(routsubstringval,routlen);
        
        }*/
        
        trxError = transactionError.instance;
        
        if (trxError.errorFound) {
        VFUtil.AddErrorMessage ( trxError.errorMessage);
        return null;
        
        } 

        if(!String.isBlank(tokenId)){
        achpm.invoiceit_s__Payment_Profile_ID__c=tokenId;
        }else{
       
       VFUtil.AddErrorMessage ('Something Went wrong,Please retry the request again.');
        return null;
        

        }
        
        
          upsert achpm;
          
          
           Decimal rd=math.random();                  
           PageReference url = new PageReference('/apex/PaymentConfirmationPage?accuntId='+cart.id+'&r='+rd);
           url.setRedirect(true);
           return url;            
    }

    public PageReference editShippingaddress(){
       
        system.debug('acnt : '+acnt);
          
        
          
          // Validate Name
        if ( (qute.SBQQ__ShippingName__c != null && qute.SBQQ__ShippingName__c.length() < 2) || (qute.SBQQ__ShippingName__c == null || qute.SBQQ__ShippingName__c == '')) {
            VFUtil.AddErrorMessage(' Name is required');
            
            return null;
        }
         
           // validate shipping streeet     
        if ( (qute.SBQQ__ShippingStreet__c == null || qute.SBQQ__ShippingStreet__c == '')&& !Test.isRunningTest()  ) {
            VFUtil.AddErrorMessage ( 'Please enter street.');
           system.debug( 'camehere');
            return null;
        } 
        
             // validate shipping streeet       
        if ( qute.SBQQ__ShippingCity__c == null || qute.SBQQ__ShippingCity__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Please enter city.');
            return null;
        } 
        
         if (  qute.SBQQ__ShippingState__c == null || qute.SBQQ__ShippingState__c == ''  ) {
            VFUtil.AddErrorMessage ('Enter valid state. Acceptable formats: GA,TX,CA,AZ.');
            return null;
                }
        
        qute.SBQQ__ShippingState__c =qute.SBQQ__ShippingState__c.toUpperCase();
         
        // validate state
        
        Set<String> validStates = new Set<String>{ 'AS', 'AR', 'CA', 'UT', 'NV',
            'AL', 'AK', 'AZ', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA','GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY','MP', 
            'LA', 'ME','MH', 'MD', 'MA', 'MI','FM', 'MN', 'MS', 'MO', 'NV','MT', 'NE', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 
            'OH', 'OK', 'OR', 'PA','PW', 'RI', 'SC', 'SD', 'TN','UT', 'TX','VI', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY' };
            
            if ( !validStates.contains( qute.SBQQ__ShippingState__c) || qute.SBQQ__ShippingState__c.length() > 2 || qute.SBQQ__ShippingState__c.length() < 2  ) {
            VFUtil.AddErrorMessage ('Enter valid state. Acceptable formats: GA,TX,CA,AZ.');
            return null;
                }
                
          // validate zip codes     
        if ( (qute.SBQQ__ShippingPostalCode__c != null && qute.SBQQ__ShippingPostalCode__c != '' && 
            !Pattern.matches('^([0-9]{5})||([0-9]{5}-[0-9]{4})$', qute.SBQQ__ShippingPostalCode__c)) || ( qute.SBQQ__ShippingPostalCode__c == null || qute.SBQQ__ShippingPostalCode__c == '') ) {
            VFUtil.AddErrorMessage ( 'Invalid zip code.');
            return null;
        }    
 
              
        update qute;
              system.debug('account update details'+qute.SBQQ__Account__r.ShippingStreet);
               
           
            
           Decimal r=math.random();                  
           PageReference url = new PageReference('/apex/PaymentConfirmationPage?accuntId='+cart.id+'&r='+r);
           url.setRedirect(true);
           return url;
    }
   
   
   public PageReference Updateshippbill(){
       
        system.debug('acnt : '+acnt);
          
           iserror=false;
           
        
          
          // Validate Name
        if ( (qute.SBQQ__ShippingName__c != null && qute.SBQQ__ShippingName__c.length() < 2) || (qute.SBQQ__ShippingName__c == null || qute.SBQQ__ShippingName__c == '')) {
            VFUtil.AddErrorMessage(' Shipping name is required');
            iserror=true;
            return null;
        }
         
           // validate shipping streeet     
        if ( (qute.SBQQ__ShippingStreet__c == null || qute.SBQQ__ShippingStreet__c == '')&& !Test.isRunningTest()  ) {
            VFUtil.AddErrorMessage ( 'Please enter shipping street.');
           system.debug( 'camehere');
           iserror=true;
            return null;
        } 
        
             // validate shipping streeet       
        if ( qute.SBQQ__ShippingCity__c == null || qute.SBQQ__ShippingCity__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Please enter shipping city.');
            iserror=true;
            return null;
        } 
        
         if (  qute.SBQQ__ShippingState__c == null || qute.SBQQ__ShippingState__c == ''  ) {
            VFUtil.AddErrorMessage ('Enter valid shipping state. Acceptable formats: GA,TX,CA,AZ.');
            iserror=true;
            return null;
                }
        
        qute.SBQQ__ShippingState__c =qute.SBQQ__ShippingState__c.toUpperCase();
         
        // validate state
        
        Set<String> validStates = new Set<String>{ 'AS', 'AR', 'CA', 'UT', 'NV',
            'AL', 'AK', 'AZ', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA','GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY','MP', 
            'LA', 'ME','MH', 'MD', 'MA', 'MI','FM', 'MN', 'MS', 'MO', 'NV','MT', 'NE', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 
            'OH', 'OK', 'OR', 'PA','PW', 'RI', 'SC', 'SD', 'TN','UT', 'TX','VI', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY' };
            
            if ( !validStates.contains( qute.SBQQ__ShippingState__c) || qute.SBQQ__ShippingState__c.length() > 2 || qute.SBQQ__ShippingState__c.length() < 2  ) {
            VFUtil.AddErrorMessage ('Enter valid shipping state. Acceptable formats: GA,TX,CA,AZ.');
            iserror=true;
            return null;
                }
                
          // validate zip codes     
        if ( (qute.SBQQ__ShippingPostalCode__c != null && qute.SBQQ__ShippingPostalCode__c != '' && 
            !Pattern.matches('^([0-9]{5})||([0-9]{5}-[0-9]{4})$', qute.SBQQ__ShippingPostalCode__c)) || ( qute.SBQQ__ShippingPostalCode__c == null || qute.SBQQ__ShippingPostalCode__c == '') ) {
            VFUtil.AddErrorMessage ( 'Invalid shipping zip code.');
            iserror=true;
            return null;
        }   
       
        
          // Validate Name
        if ( (qute.SBQQ__BillingName__c != null && qute.SBQQ__BillingName__c.length() < 2) || (qute.SBQQ__BillingName__c == null || qute.SBQQ__BillingName__c == '')) {
            VFUtil.AddErrorMessage('Billing name is required.');
            iserror=true;
            return null;
        }
         
           // validate shipping streeet     
        if ( qute.SBQQ__BillingStreet__c == null || qute.SBQQ__BillingStreet__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Please enter billing  street.');
           system.debug( 'camehere');
           iserror=true;
            return null;
        } 
        
             // validate billing streeet       
        if ( qute.SBQQ__BillingCity__c == null || qute.SBQQ__BillingCity__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Please enter billing city.');
            iserror=true;
            return null;
        } 
        
         if (  qute.SBQQ__BillingState__c == null || qute.SBQQ__BillingState__c == ''  ) {
            VFUtil.AddErrorMessage ('Enter valid billing state. Acceptable formats: GA,TX,CA,AZ.');
            iserror=true;
            return null;
                }
        
        qute.SBQQ__BillingState__c =qute.SBQQ__BillingState__c.toUpperCase();
         
            
            if ( !validStates.contains( qute.SBQQ__BillingState__c) || qute.SBQQ__BillingState__c.length() > 2 || qute.SBQQ__BillingState__c.length() < 2  ) {
            VFUtil.AddErrorMessage ('Enter valid billing state. Acceptable formats: GA,TX,CA,AZ.');
            iserror=true;
            return null;
                }
                
          // validate zip codes     
        if (( qute.SBQQ__BillingPostalCode__c != null && qute.SBQQ__BillingPostalCode__c != '' && 
            !Pattern.matches('^([0-9]{5})||([0-9]{5}-[0-9]{4})$', qute.SBQQ__BillingPostalCode__c)) || ( qute.SBQQ__BillingPostalCode__c == null || qute.SBQQ__BillingPostalCode__c == '') ) {
            VFUtil.AddErrorMessage ( 'Invalid billing zip code.');
            iserror=true;
            return null;
        }  
      update qute;
           return null;
    }
      
      
      public void createCase() { 
              
                
               displymnt=[Select Id,invoiceit_s__Billing_First_Name__c,invoiceit_s__Billing_Last_Name__c,invoiceit_s__Billing_Email__c,invoiceit_s__Account__c,
               invoiceit_s__Active__c,invoiceit_s__Payment_Method__c,invoiceit_s__Default__c,invoiceit_s__Name_on_Card__c,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,
               invoiceit_s__Card_Expiration_Year__c,invoiceit_s__CVV__c,Actno_Last4digits__c,invoiceit_s__Bank_Account_Number__c,invoiceit_s__Bank_Account_Name__c,invoiceit_s__Bank_Account_Type__c,invoiceit_s__Bank_Name__c,
               invoiceit_s__Bank_Routing_Code__c,invoiceit_s__Billing_Address__c,invoiceit_s__Billing_City__c,invoiceit_s__Billing_State_Province__c,invoiceit_s__Billing_Zip_Postal__c,
               invoiceit_s__Billing_Country__c,Same_as_Shipping_Add__c  From invoiceit_s__Payment_Method__c Where Id=:pid ];
            System.Debug('>>>>>>>>>>>>> HERE IS THE VALUE --> ' + displymnt);
            

    }
      
      Public PageReference editCard(){
      system.debug('<<<<<updaate item'+displymnt);

     

           if ( displymnt.invoiceit_s__Billing_First_Name__c== null || displymnt.invoiceit_s__Billing_First_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid name on account.');
            return null;
        }  
           
           if ( displymnt.invoiceit_s__Billing_Last_Name__c== null || displymnt.invoiceit_s__Billing_Last_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid name on account.');
            return null;
        }  
           
           if(displymnt.invoiceit_s__Card_Expiration_Month__c == null || displymnt.invoiceit_s__Card_Expiration_Month__c == ''){
           // displymnt.invoiceit_s__CVV__c = null; 
            //displymnt.invoiceit_s__Card_Number__c = null;  
            VFUtil.AddErrorMessage ( 'Select credit card expiration month.');
             return null;
           }
           
           if(displymnt.invoiceit_s__Card_Expiration_Year__c == null || displymnt.invoiceit_s__Card_Expiration_Year__c == ''){
           // displymnt.invoiceit_s__CVV__c = null; 
           // displymnt.invoiceit_s__Card_Number__c = null;  
            VFUtil.AddErrorMessage ( 'Select credit card expiration year.');
             return null;
           }

           if(displymnt.invoiceit_s__Card_Type__c == null || displymnt.invoiceit_s__Card_Type__c == ''){
            //displymnt.invoiceit_s__CVV__c = null; 
           // displymnt.invoiceit_s__Card_Number__c = null;  
            VFUtil.AddErrorMessage ( 'Select credit card type.');
             return null;
           }
          if ( (displymnt.invoiceit_s__CVV__c != null && displymnt.invoiceit_s__CVV__c != '' && displymnt.invoiceit_s__Card_Type__c != 'American Express' && !Pattern.matches('^([0-9]{3})||([0-9]{5}-[0-9]{4})$', displymnt.invoiceit_s__CVV__c)) || ( displymnt.invoiceit_s__CVV__c == null || displymnt.invoiceit_s__CVV__c == '') ) {
            displymnt.invoiceit_s__CVV__c = null; 
            //displymnt.invoiceit_s__Card_Number__c = null;         
            VFUtil.AddErrorMessage ( 'Invalid security number.');
            return null;
          } 
            if ( (displymnt.invoiceit_s__CVV__c != null && displymnt.invoiceit_s__CVV__c != '' && displymnt.invoiceit_s__Card_Type__c == 'American Express' && !Pattern.matches('^([0-9]{4})||([0-9]{5}-[0-9]{4})$', displymnt.invoiceit_s__CVV__c)) || ( displymnt.invoiceit_s__CVV__c == null || displymnt.invoiceit_s__CVV__c == '') ) {
            displymnt.invoiceit_s__CVV__c = null; 
           // displymnt.invoiceit_s__Card_Number__c = null;    
            VFUtil.AddErrorMessage ( 'Invalid security number.');
            return null;
        }

           // Expiration Date in the future
              String currentYearMonth = '' + Date.today().year();
              if ( Date.today().month() > 9 ) {
              currentYearMonth += Date.today().month();
              } else {
              currentYearMonth += '0' + Date.today().month();
               }
              if ( (displymnt.invoiceit_s__Card_Expiration_Year__c + displymnt.invoiceit_s__Card_Expiration_Month__c ) < currentYearMonth) {
             // displymnt.invoiceit_s__CVV__c = null; 
              //displymnt.invoiceit_s__Card_Number__c = null;  
               VFUtil.AddErrorMessage ( 'Credit card has expired.');
                return null;
               }
                 if((displymnt.invoiceit_s__Billing_Address__c == null || displymnt.invoiceit_s__Billing_Address__c =='') && displymnt.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing address.');
         return null;
         }
         
         if((displymnt.invoiceit_s__Billing_City__c== null || displymnt.invoiceit_s__Billing_City__c=='') && displymnt.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing city.');
         return null;
         }
         
         if((displymnt.invoiceit_s__Billing_State_Province__c== null || displymnt.invoiceit_s__Billing_State_Province__c=='') && displymnt.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing state.');
         return null;
         }
         if((displymnt.invoiceit_s__Billing_Zip_Postal__c == null || displymnt.invoiceit_s__Billing_Zip_Postal__c =='') && displymnt.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a zip code.');
         return null;
         }
         if(!Test.isRunningTest()){
        displymnt.invoiceit_s__Billing_State_Province__c =displymnt.invoiceit_s__Billing_State_Province__c.toUpperCase();
         }
        // validate state
        
        Set<String> validStates = new Set<String>{ 'AS', 'AR', 'CA', 'UT', 'NV',
            'AL', 'AK', 'AZ', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA','GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY','MP', 
            'LA', 'ME','MH', 'MD', 'MA', 'MI','FM', 'MN', 'MS', 'MO', 'NV','MT', 'NE', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 
            'OH', 'OK', 'OR', 'PA','PW', 'RI', 'SC', 'SD', 'TN','UT', 'TX','VI', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY' };
            
            if ( !validStates.contains( displymnt.invoiceit_s__Billing_State_Province__c) || displymnt.invoiceit_s__Billing_State_Province__c.length() > 2 || displymnt.invoiceit_s__Billing_State_Province__c.length() < 2  ) {
            VFUtil.AddErrorMessage ('Enter valid state. Acceptable formats: GA,TX,CA,AZ.'); 
            return null;
                }
                
        
         
          if ( displymnt.invoiceit_s__Billing_Zip_Postal__c != null && displymnt.invoiceit_s__Billing_Zip_Postal__c != '' && !Pattern.matches('^([0-9]{5})||([0-9]{5}-[0-9]{4})$', displymnt.invoiceit_s__Billing_Zip_Postal__c) ) {
            VFUtil.AddErrorMessage ( 'Invalid zip code.');
            return null ;
        }   
         
      update displymnt;

      Decimal ln=math.random(); 
      PageReference url = new PageReference('/apex/PaymentConfirmationPage?accuntId='+cart.id+'&r='+ln);
      url.setRedirect(true);
      return url;
     
      }
      
       Public PageReference editAch(){
      system.debug('<<<<<updaate item'+displymnt);
      
           if ( displymnt.invoiceit_s__Billing_First_Name__c== null || displymnt.invoiceit_s__Billing_First_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid name on account.');
            return null;
        }  
           
           if ( displymnt.invoiceit_s__Billing_Last_Name__c== null || displymnt.invoiceit_s__Billing_Last_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid name on account.');
            return null;
        }  
        
          if ( (displymnt.invoiceit_s__Bank_Routing_Code__c != null && displymnt.invoiceit_s__Bank_Routing_Code__c != ''  && !Pattern.matches('^([0-9]{9})||([0-9]{5}-[0-9]{4})$', displymnt.invoiceit_s__Bank_Routing_Code__c)) || ( displymnt.invoiceit_s__Bank_Routing_Code__c == null || displymnt.invoiceit_s__Bank_Routing_Code__c == '') ) {
            
            VFUtil.AddErrorMessage ( 'Invalid routing number.');
            return null;
        }
            if (( displymnt.invoiceit_s__Bank_Account_Number__c == null || displymnt.invoiceit_s__Bank_Account_Number__c == '' ) ||(displymnt.invoiceit_s__Bank_Account_Number__c.length() <4 || displymnt.invoiceit_s__Bank_Account_Number__c.length() > 17 )){
            VFUtil.AddErrorMessage ( 'Invalid account number.');
            return null;
        }     

 
            if ( displymnt.invoiceit_s__Bank_Account_Type__c == null || displymnt.invoiceit_s__Bank_Account_Type__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Please select account type.');
            return null;
        }   
            
              if ( displymnt.invoiceit_s__Bank_Name__c == null || displymnt.invoiceit_s__Bank_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Please provide bank organization name.');
            return null;
        }

                 if((displymnt.invoiceit_s__Billing_Address__c == null || displymnt.invoiceit_s__Billing_Address__c =='') && displymnt.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing address.');
         return null;
         }
         
         if((displymnt.invoiceit_s__Billing_City__c== null || displymnt.invoiceit_s__Billing_City__c=='') && displymnt.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing city.');
         return null;
         }
         
         if((displymnt.invoiceit_s__Billing_State_Province__c== null || displymnt.invoiceit_s__Billing_State_Province__c=='') && displymnt.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a billing state.');
         return null;
         }
         if((displymnt.invoiceit_s__Billing_Zip_Postal__c == null || displymnt.invoiceit_s__Billing_Zip_Postal__c =='') && displymnt.Same_as_Shipping_Add__c ==false){
         VFUtil.AddErrorMessage ( 'Please provide a zip code.');
         return null;
         }
         if(!Test.isRunningTest()){
        displymnt.invoiceit_s__Billing_State_Province__c =displymnt.invoiceit_s__Billing_State_Province__c.toUpperCase();
         }
        // validate state
        
        Set<String> validStates = new Set<String>{ 'AS', 'AR', 'CA', 'UT', 'NV',
            'AL', 'AK', 'AZ', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA','GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY','MP', 
            'LA', 'ME','MH', 'MD', 'MA', 'MI','FM', 'MN', 'MS', 'MO', 'NV','MT', 'NE', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 
            'OH', 'OK', 'OR', 'PA','PW', 'RI', 'SC', 'SD', 'TN','UT', 'TX','VI', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY' };
            
            if ( !validStates.contains( displymnt.invoiceit_s__Billing_State_Province__c) || displymnt.invoiceit_s__Billing_State_Province__c.length() > 2 || displymnt.invoiceit_s__Billing_State_Province__c.length() < 2  ) {
            VFUtil.AddErrorMessage ('Enter valid state. Acceptable formats: GA,TX,CA,AZ.'); 
            return null;
                }
                
        
         
          if ( displymnt.invoiceit_s__Billing_Zip_Postal__c != null && displymnt.invoiceit_s__Billing_Zip_Postal__c != '' && !Pattern.matches('^([0-9]{5})||([0-9]{5}-[0-9]{4})$', displymnt.invoiceit_s__Billing_Zip_Postal__c) ) {
            VFUtil.AddErrorMessage ( 'Invalid zip code.');
            return null ;
        }   
        
        String tokenId=CyberSourceConnection.getTokenFromACH(displymnt);
        
        //Store only last four from Account Number
        
        if(displymnt.invoiceit_s__Bank_Account_Number__c.length() >4){
        Integer len= displymnt.invoiceit_s__Bank_Account_Number__c.length();
        Integer substringval;
        
        substringval = len-4;
        
        displymnt.invoiceit_s__Bank_Account_Number__c= displymnt.invoiceit_s__Bank_Account_Number__c.substring(substringval,len);
        }
        
        //Store only last four from Routing Number
       /* if(paymentMethod.invoiceit_s__Bank_Routing_Code__c.length() >4){
        Integer routlen= paymentMethod.invoiceit_s__Bank_Routing_Code__c.length();
        Integer routsubstringval;
        
        routsubstringval = routlen-4;
        
        paymentMethod.invoiceit_s__Bank_Routing_Code__c= paymentMethod.invoiceit_s__Bank_Routing_Code__c.substring(routsubstringval,routlen);
        
        }*/
        trxError = transactionError.instance;
        
        if (trxError.errorFound) {
        VFUtil.AddErrorMessage ( trxError.errorMessage);
        return null;
        
        } 

        if(!String.isBlank(tokenId)){
        displymnt.invoiceit_s__Payment_Profile_ID__c=tokenId;
        }else{
       
       VFUtil.AddErrorMessage ('Something Went wrong,Please retry the request again.');
        return null;
        

        }
        
          upsert displymnt;

      Decimal ed=math.random(); 
      PageReference url = new PageReference('/apex/PaymentConfirmationPage?accuntId='+cart.id+'&r='+ed);
      url.setRedirect(true);
      return url;
     
      }
      
      
      Public PageReference editaccinfo(){
       
       System.debug('*******debug here'+qute.Primay_Phone__c+qute.Primary_Email__c);
         if ( webopp.Primary_Phone__c != null && !Pattern.matches('^$|^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$|^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4} x[a-zA-Z0-9]{1,4}$', webopp.Primary_Phone__c) ) {
           
            VFUtil.AddErrorMessage ('Invalid phone number.');
           
            return null;
        }
      
        if(webopp.Company_Name__c == null || webopp.Company_Name__c==''){
          
          VFUtil.AddErrorMessage ('Please enter company name.');
           
            return null;
        
        }
       if(webopp.Primary_Contact_Name__c== null || webopp.Primary_Contact_Name__c==''){
          
          VFUtil.AddErrorMessage ('Please enter contact name.');
           
            return null;
        
        }
        if(webopp.Primary_Email__c == null || webopp.Primary_Email__c==''){
          
          VFUtil.AddErrorMessage ('Invalid email address.');
           
            return null;
        
        }
       if(webopp.Primary_Phone__c == null || webopp.Primary_Phone__c ==''){
          
          VFUtil.AddErrorMessage ('Invalid phone number.');
           
            return null;
        
        }
        
       update webopp;
       
       Decimal ed=math.random(); 
      PageReference url = new PageReference('/apex/PaymentConfirmationPage?accuntId='+cart.id+'&r='+ed);
      url.setRedirect(true);
      return url;
      
      }
      
      
      
      
      
     // payment Section from Cart 
      
      Public PageReference onSubmit(){
      
       string p='';
       p= ApexPages.currentPage().getParameters().get( 'pymnhg'); 
      system.debug('**** pymtsekkedc'+p);
       
       if(acnt.Missing_Billing_Shipping_Info__c==true){
       
         VFUtil.AddErrorMessage ( 'Please ensure you have completed the billing and shipping fields.');
         iserror=true;
         return null;
       
       }
       
       if(qute.Tax_Calculated__c==false){
        
        IIT_SpeedTaxConnector.calculateTaxForQuote(qute.id);    

            iserror=true;    
            Decimal r=math.random();                  
            PageReference prn = new PageReference('/apex/PaymentConfirmationPage?accuntId='+cart.id+'&r='+r);
            prn.setRedirect(true);
            return prn;
         
       
       }
       
       if(p != null && p!=''){
          List<invoiceit_s__Payment_Method__c> ptoupdate= new List<invoiceit_s__Payment_Method__c>();
          for(invoiceit_s__Payment_Method__c pi:availablepymnt ){
          
          pi.invoiceit_s__Default__c =false;
          ptoupdate.add(pi);
          }
          update ptoupdate;
          invoiceit_s__Payment_Method__c mp =[Select id,invoiceit_s__Default__c From invoiceit_s__Payment_Method__c Where id=:p];
          system.debug('**** default'+mp);
          mp.invoiceit_s__Default__c =true;
          update mp;
          system.debug('**** default'+mp);
       }
      try{
      mthofpay =[Select id,invoiceit_s__Account__c,invoiceit_s__Active__c,invoiceit_s__Payment_Method__c,invoiceit_s__Default__c
                                           From invoiceit_s__Payment_Method__c Where invoiceit_s__Account__c =: acnt.id AND invoiceit_s__Default__c = true order by CreatedDate desc Limit 1];
      
      }catch(Exception e){}
      if(mthofpay.size() == 0){
      
         VFUtil.AddErrorMessage ( 'Please select a payment method.');
         iserror=true;
         return null;
      
      }
      iserror=false;
     List<invoiceit_s__Payment_Plan_Installment__c> ppi =[Select Id,QTC__Quote__c,invoiceit_s__Account__c,invoiceit_s__Payment_Amount__c,invoiceit_s__Payment_Method__c From   invoiceit_s__Payment_Plan_Installment__c Where QTC__Quote__c=:qute.id AND invoiceit_s__Account__c=:acnt.id AND invoiceit_s__Payment_Method__c =:mthofpay[0].id order by CreatedDate desc Limit 1 ];
     if(ppi.size()>0){
      if(ppi[0].invoiceit_s__Payment_Amount__c!=qute.SBQQ__CustomerAmount__c){
      newppi=true;
      delete ppi[0];
      }
     }
     
      if(ppi.size()==0 || newppi){
      pymntplninstmnt.invoiceit_s__Account__c =acnt.id;
      pymntplninstmnt.invoiceit_s__Payment_Type__c =mthofpay[0].invoiceit_s__Payment_Method__c;
      pymntplninstmnt.invoiceit_s__Payment_Amount__c=qute.SBQQ__CustomerAmount__c;
      pymntplninstmnt.invoiceit_s__Payment_Date__c =Date.today();
      pymntplninstmnt.QTC__Quote__c =qute.id;
      pymntplninstmnt.invoiceit_s__Payment_Method__c=mthofpay[0].id;
      pymntplninstmnt.Payment_Method1__c=mthofpay[0].id;
      pymntplninstmnt.PI_Billing_Contact_Email__c= acnt.Email__c;
      pymntplninstmnt.Min_Down_Payment__c=true;
      insert pymntplninstmnt;
      }
      
      system.debug('***boolean'+iserror);
      
       return null;
      }
      
    
      Public void CreatePayment(){
          proceedToOrder = true;
          if(qute.Payment_Processed__c==false){
          try {
              string qpid =qute.id;
              
              Boolean success;
              try{
              WebCreateOrder cc = new WebCreateOrder();
              success =cc.validpayment(qpid );
              }catch (exception e) {
              success =false;
              }
              
              if(!success ){
               string a = String.valueOf(acnt.id).substring(0, 15);
               try{
                   Errorpymnts =[Select Id,Account_ID__c,invoiceit_s__Response_Status__c,payment_plan_installment__c From invoiceit_s__Transaction__c where Account_ID__c=:a AND payment_plan_installment__c=:pymntplninstmnt.id order by CreatedDate desc Limit 1];
               }catch (exception e) {}
               if(Errorpymnts.size()>0){
                   if(Errorpymnts[0].invoiceit_s__Response_Status__c!= null &&  Errorpymnts[0].invoiceit_s__Response_Status__c!= 'Approved'){
                       VFUtil.AddErrorMessage ( Errorpymnts[0].invoiceit_s__Response_Status__c);
                       proceedToOrder = false;
                   }else if(Errorpymnts[0].invoiceit_s__Response_Status__c== 'Approved'){
                    VFUtil.AddErrorMessage ( 'We apologize. An error occurred when processing your order. We may have collected your payment, but you need to speak with one of our Account Managers to complete your order. Please call: 1-800-495-4626 Hours: M-F 8:30am - 6:00pm Eastern Time');
                       proceedToOrder = false;
                   
                   }
                   }else{
                   
                    List<SBQQ__Quote__c> qt =[select Id,Retry_count__c,Payment_Processed__c,SBQQ__Status__c from SBQQ__Quote__c where id=:qpid   
                              order by CreatedDate desc Limit 1];
                system.debug('qute'+qt);
                    if(qt.size()>0)   {         
                      if(qt[0].Retry_count__c != null && qt[0].Retry_count__c < 3 && qt[0].Payment_Processed__c ==False && qt[0].SBQQ__Status__c != 'Invoiced' ){
                      isretry=true;
                      }else{
                      isretry=false;
                      }
                    }
                    if( qt[0].Payment_Processed__c ==False ){
                    nopaymntprcsd=false;
                    }
                       VFUtil.AddErrorMessage ( 'We apologize. An error occurred when processing your order. We may have collected your payment, but you need to speak with one of our Account Managers to complete your order. Please call: 1-800-495-4626 Hours: M-F 8:30am - 6:00pm Eastern Time');
                       proceedToOrder = false;
                   }
                   //return null;
                   }else{
                  
                  nopaymntprcsd=true;
                  qute.Payment_Processed__c=true;
                  qute.Exception_Message__c='';
                  update qute;
                  
                  
                  system.debug('flag value of payment'+success);
                  }
              //return null;
          }
          catch(Exception e) {
              proceedToOrder = false;
          }
          }else{
          
          nopaymntprcsd=true;
          isretry=false;
          qute.Retry_count__c=null;
          qute.Exception_Message__c='';
          update qute;
          }
      }
     
     
       Public void linkquoteandopp(){
                
              Web_Opp__c webopp = [select id,web_quote__c,Amount__c,Type__c,WebAccount__c,Opportunity__c From Web_Opp__c where web_quote__c =:qute.id order by Createddate Limit 1];
                 
                   partnerSoapforceCom.Soap myPartnerSoap = new partnerSoapforceCom.Soap();  
                   partnerSoapforceCom.LoginResult partnerLoginResult = myPartnerSoap.login(Label.WebUser_Username, Label.WebUser_Pswd); 
                   WebClassLinkopptoq.SessionHeader_element webserviceSessionHeader = new WebClassLinkopptoq.SessionHeader_element(); 
                   webserviceSessionHeader.sessionId = partnerLoginResult.sessionId;//UserInfo.getsessionId(); 
                   WebClassLinkopptoq.Linkopptoquoteweb obj = new WebClassLinkopptoq.Linkopptoquoteweb();
                   obj.SessionHeader = webserviceSessionHeader; 
                   obj.qutid(webopp.web_quote__c,webopp.Opportunity__c);
     
     }
     
     
      Public pagereference createorder(){
      WebCreateOrder cc = new WebCreateOrder();
      Boolean co=cc.orderTocreate(qute.id);
       
      List<SBQQ__Quote__c> qt =[select Id,Retry_count__c,SBQQ__Status__c from SBQQ__Quote__c where SBQQ__Account__c =: acnt.id AND SBQQ__Primary__c =true  
                              order by CreatedDate desc Limit 1];
                system.debug('qute'+qt);
                    if(qt.size()>0)   {         
                      if(qt[0].Retry_count__c != null && qt[0].Retry_count__c < 3 && qt[0].SBQQ__Status__c != 'Invoiced'){
                      isretry=true;
                      }else{
                      isretry=false;
                      }
                    }
      //PageReference url = new PageReference('/apex/OrderConfirmationPage?type='+cart.id);
      return null;
      }
      Public pagereference orderconf(){
      
      if(cnt.size()>0){
      cnt[0].Abandoned_User_New__c =false;
      update cnt[0];
      }

      PageReference url = new PageReference('/apex/OrderConfirmationPage?type='+cart.id);
      
      return url;
      
      }
      
    //Payment section ends here
    
    
    // Section of logic for Login Customers from UMMS
    
    Public Void existingCust(){
      String memberaccuntId1 = ApexPages.currentPage().getParameters().get( 'SFDCCartID'); 
        if(memberaccuntId1 !=null && memberaccuntId1 !='' && cart.Existing_login__c==false){
        //Create quote lines
        cart.Existing_login__c=true;
        update cart;
         mainprdctqutlines= new List<SBQQ__QuoteLine__c>();
        optionsToUpdate = new List<SBQQ__QuoteLine__c>();
        optlineitems= new Set<String>();
        rqrdqutlinemap= new map<string,SBQQ__QuoteLine__c >(); 
       
       if(acnt!=null) {
        for(Cart_Line__c lns: [Select Id,Option_Id__c,Product__c,Quantity__c,Promo_Id__c From Cart_Line__c Where cart__r.Cart_Account__c =: acnt.id AND cart__c=:cart.id]) {
         
                SBQQ__QuoteLine__c qutlines= new SBQQ__QuoteLine__c();
                                            qutlines.SBQQ__Quantity__c = lns.Quantity__c;
                                            qutlines.SBQQ__Product__c = lns.Product__c;
                                            qutlines.SBQQ__Quote__c  = qute.id;
                                            qutlines.Promotion__c=lns.Promo_Id__c;
                                            rqrdqutlinemap.put(lns.Product__c,qutlines);
                                            if(lns.Option_Id__c!=null && lns.Option_Id__c!='')
                                            optlineitems.addAll(lns.Option_Id__c.split(','));
                optionsToUpdate .add(qutlines);
                
                 }
                 
         //create salestax quote line
          for(SBQQ__Quote__c sql :[Select Id From SBQQ__Quote__c  Where Id =: qute.id ] ){
                                salesqutln.SBQQ__Quantity__c = 1;
                                salesqutln.SBQQ__Product__c = pi[0].id;
                                salesqutln.SBQQ__Quote__c  = sql.id;
          
           optionsToUpdate.add(salesqutln);
           
         }
         if(optionsToUpdate.size()>0)  
         insert optionsToUpdate;
               
        
          }
          }else{
          nonlogin=true;
          }
      }
          
    public pagereference crtql(){    
     
        
         //using product id and required and display type field create quotelines
         system.debug('**bundled line items for ql'+rqrdqutlinemap.keyset());
         
           for(SBQQ__ProductOption__c ml :[Select Id,SBQQ__OptionalSKU__c,SBQQ__Bundled__c,SBQQ__OptionalSKU__r.Shipping_Processing__c,SBQQ__ConfiguredSKU__c,SBQQ__Feature__r.Name From SBQQ__ProductOption__c  Where ((id IN :optlineitems) OR (SBQQ__ConfiguredSKU__c IN :rqrdqutlinemap.keyset()  AND (SBQQ__Bundled__c = true OR SBQQ__Feature__r.Name ='Fees' ) ))ORDER BY  SBQQ__Number__c ASC] ){
           
            SBQQ__QuoteLine__c ql= new SBQQ__QuoteLine__c();
           if(ml.SBQQ__Feature__r.Name !='Fees'){
          ql.SBQQ__Quantity__c = 1;
          }else{
          ql.SBQQ__Quantity__c = 0; 
          }
          ql.SBQQ__Product__c = ml.SBQQ__OptionalSKU__c ;
          ql.Shipping_Processing__c=ml.SBQQ__OptionalSKU__r.Shipping_Processing__c;
          ql.SBQQ__Quote__c  = qute.id;
           if(ml.SBQQ__OptionalSKU__r.Shipping_Processing__c == False && ml.SBQQ__Bundled__c  == TRUE){ql.SBQQ__Bundled__c = true;}
          ql.SBQQ__RequiredBy__c=rqrdqutlinemap.get(ml.SBQQ__ConfiguredSKU__c).Id;
          ql.SBQQ__ProductOption__c=ml.Id;
          
          mainprdctqutlines.add(ql);
          system.debug('**********************'+ql);
          }
         if(mainprdctqutlines.size()>0)    
           insert mainprdctqutlines;
         
         system.debug('****sql quote id'+qute.id);
        
        

            return null;
    }
   
 
  public PageReference salestx(){
     
            IIT_SpeedTaxConnector.calculateTaxForQuote(qute.id);    

                 
            String url = '/apex/PaymentConfirmationPage?accuntId='+cart.id;
            pagereference pr =new PageReference( url);
            pr.setredirect(true);
            return pr;
           
  } 
  
  //Login section ends here
  
  
}