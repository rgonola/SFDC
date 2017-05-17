Public without sharing class OrderConfirmationExtension{

        Public invoiceit_s__Payment_Method__c pymntmethd {get; set;}
        public Map<String, List<SBQQ__ProductOption__c>> productToSelectedOptionsMap {get;set;}
        Public invoiceit_s__Payment_Plan_Installment__c pymntplninstmnt {get;set;}
        public String memberaccuntId { get; set; }
        public Boolean hasorder{ get; set; }
        public Account acnt {get;set;}
        Public List<invoiceit_s__Payment_Method__c> availablepymnt {get; set;}
        public Map<String,String> mapdisplaycard{get;set;}
        Public SBQQ__Quote__c qute {get;set;}
        public cart__c chrt{get;set;}
        public Map<String,String> mapprdctincluded{get;set;}
        Public List<SBQQ__QuoteLine__c> quteline {get;set;}
        public Map<String, List<SBQQ__ProductOption__c>> featuresWithOptions {get;set;}
        public Map<String, Map<String, List<SBQQ__ProductOption__c>>> productFeatures {get;set;}
        private Map<Id, SBQQ__ProductOption__c> options;
        public Map<Id, Product2> productMap {get;set;}
        public Map<String, Boolean> hasFeatures {get;set;}
        public invoiceit_s__Job__c order {get;set;}
        public Cookie cartCookie{get;set;}
        
Public OrderConfirmationExtension(){

         pymntmethd = new invoiceit_s__Payment_Method__c();
         productToSelectedOptionsMap = new Map<String, List<SBQQ__ProductOption__c>>(); 
         pymntplninstmnt = new invoiceit_s__Payment_Plan_Installment__c();
         // Get the Account id
         memberaccuntId = ApexPages.currentPage().getParameters().get( 'accuntId');  

         string rtyp= ApexPages.currentPage().getParameters().get( 'type');
         hasorder=false; 
      
         
             try{
             
                chrt =[select id,Cart_Account__c,Promo_Value__c,Customer_Type__c,Originate_URL__c,Total_Price__c From cart__c Where id =: rtyp];
                 
    
                acnt =[Select id,BillingStreet,Billingcity,BillingState,Billingpostalcode,SBQQ__DefaultOpportunity__r.SBQQ__PrimaryQuote__c,SBQQ__DefaultOpportunity__c,Email__c,ShippingStreet,shippingcity,shippingState,
                              shippingpostalcode,Primary_Contact_Name__c,(SELECT
                              name,Contact.FirstName, Contact.LastName
                              FROM Account.Contacts) From Account where id=:chrt.Cart_Account__c];

               
               availablepymnt =[Select Id,invoiceit_s__Billing_First_Name__c,invoiceit_s__Billing_Last_Name__c,invoiceit_s__Billing_Email__c,invoiceit_s__Account__c,
                                       invoiceit_s__Active__c,invoiceit_s__Payment_Method__c,invoiceit_s__Default__c,invoiceit_s__Name_on_Card__c,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,
                                       invoiceit_s__Card_Expiration_Year__c,invoiceit_s__CVV__c,Actno_Last4digits__c,invoiceit_s__Bank_Account_Number__c,invoiceit_s__Bank_Account_Name__c,invoiceit_s__Bank_Account_Type__c,invoiceit_s__Bank_Name__c,
                                       invoiceit_s__Bank_Routing_Code__c,invoiceit_s__Billing_Address__c,invoiceit_s__Billing_City__c,invoiceit_s__Billing_State_Province__c,invoiceit_s__Billing_Zip_Postal__c,
                                       invoiceit_s__Billing_Country__c From invoiceit_s__Payment_Method__c Where invoiceit_s__Account__c=:acnt.id AND invoiceit_s__Default__c =true];
                }catch(Exception e) {}
               mapdisplaycard= new Map<String,String>();
               
               for(invoiceit_s__Payment_Method__c pm:availablepymnt ){
              
                
               if(pm.invoiceit_s__Payment_Method__c=='Credit Card'){
               mapdisplaycard.put(pm.id,pm.invoiceit_s__Card_Number__c);
               }
               if(pm.invoiceit_s__Payment_Method__c!='Credit Card'){
               mapdisplaycard.put(pm.id,pm.Actno_Last4digits__c);
               system.debug('****pymnt'+mapdisplaycard);
               }
                
               }
                //Display quote information 
                qute =[select Id,Net_Minus_Tax_Fees__c,Tax__c,Processing_Fees__c,SBQQ__Primary__c,SBQQ__Account__c,SBQQ__CustomerAmount__c,Sub_Total__c,
                              SBQQ__BillingName__c,SBQQ__BillingStreet__c,SBQQ__BillingCity__c,SBQQ__Opportunity2__c,SBQQ__BillingState__c,SBQQ__BillingPostalCode__c,SBQQ__BillingCountry__c,SBQQ__Account__r.BillingState,SBQQ__Account__r.BillingStreet,SBQQ__Account__r.BillingCity,SBQQ__Account__r.BillingPostalCode,SBQQ__Account__r.ShippingState,SBQQ__Account__r.ShippingStreet,SBQQ__Account__r.ShippingCity,SBQQ__Account__r.ShippingPostalCode,
                              SBQQ__ShippingName__c,SBQQ__ShippingStreet__c,SBQQ__ShippingCity__c,SBQQ__ShippingState__c,SBQQ__ShippingPostalCode__c,SBQQ__ShippingCountry__c, 
                              SBQQ__TotalCustomerDiscountAmount__c from SBQQ__Quote__c where SBQQ__Account__c =: acnt.id AND SBQQ__Primary__c =true  
                              order by CreatedDate desc Limit 1];
                system.debug('qute'+qute);
                try{
                 if(!Test.isRunningTest())
                order =[Select Id,Name,Order_Number__c,invoiceit_s__Start_Date__c From invoiceit_s__Job__c Where invoiceit_s__Account__c=:acnt.id AND QTC__Opportunity__c =:qute.SBQQ__Opportunity2__c order by CreatedDate desc Limit 1];
                }catch(Exception e) {
                hasorder=true;
                }
                Map<Id,Id> mapquotelines= new Map<Id, Id>();
                mapprdctincluded= new Map<String,String>();
                
                quteline =[select Id,SBQQ__Bundle__c,SBQQ__CustomerPrice__c,SBQQ__RequiredBy__c,SBQQ__Product__r.Detail_description__c,SBQQ__ListPrice__c,SBQQ__ComponentListTotal__c,SBQQ__Product__r.List_Price__c,SBQQ__NetPrice__c,
                                  SBQQ__CustomerTotal__c,SBQQ__Product__c,SBQQ__Product__r.Marketing_Name__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,SBQQ__ListTotal__c,
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
                for(SBQQ__ProductOption__c ml :[Select Id,SBQQ__OptionalSKU__r.Name,SBQQ__OptionalSKU__r.Marketing_Name__c,SBQQ__ConfiguredSKU__c From SBQQ__ProductOption__c  Where  SBQQ__ConfiguredSKU__c IN :mapquotelines.keyset() AND SBQQ__Bundled__c =TRUE AND SBQQ__Required__c = true] ){
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
                options = new Map<Id, SBQQ__ProductOption__c>([Select Id,Name,SBQQ__Feature__r.Name, Display_Type__c, SBQQ__Number__c,SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__r.List_Price__c, 
                                                                                                        SBQQ__ProductName__c,SBQQ__OptionalSKU__r.Marketing_Name__c,  SBQQ__OptionalSKU__c,SBQQ__Required__c, SBQQ__Bundled__c   
                                                                                                 From SBQQ__ProductOption__c 
                                                                                                 Where Id IN : reqqutlinesmap.keyset() AND SBQQ__ConfiguredSKU__c = :mapquotelines.keyset() AND
                                                                                                       SBQQ__Feature__c != null  AND Feature_Name__c!='Fees'  
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
                    if(!productFeatures.containsKey(s))
                        productFeatures.put(s, new Map<String, List<SBQQ__ProductOption__c>>());
                }
          
           if(chrt.Customer_Type__c=='Renewal'){
             cartCookie = ApexPages.currentPage().getCookies().get('rcid');
             Cookie myCookies=new Cookie('rcid','',null,-1,true);
             ApexPages.currentPage().setCookies(new Cookie[]{myCookies}); 
             }else{
             cartCookie = ApexPages.currentPage().getCookies().get('cartId');
             Cookie myCookies=new Cookie('cartId','',null,-1,true);
              ApexPages.currentPage().setCookies(new Cookie[]{myCookies}); 
             }
             
          



}
}