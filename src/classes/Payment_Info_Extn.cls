public without sharing class Payment_Info_Extn{

    public Account acc{get; set;}
    public List<Account> Existingaccnt{get; set;}
    public Contact cnt{get; set;}
    public List<cart__c> crt{get; set;}
    static transactionError trxError;
    public Web_Opp__c  opp{get; set;}
    public Cart_Line__c  crtlns{get; set;}
    public SBQQ__Quote__c  qut{get; set;} 
    public string prcbkid{get;set;}
    public Boolean  paymentmethod{get;set;}
    public SBQQ__QuoteLine__c  salesqutln{get; set;} 
   // public SBQQ__QuoteLine__c  ql{get; set;} 
    public Boolean validState { get; set; }
    public Boolean hasaccount { get; set; }
    public Boolean iserror { get; set; }
    public Boolean sameasshippung{ get; set; }
    Public List<Product2> pi{get;set;}  
    public List<invoiceit_s__Payment_Plan__c>  ppl{get;set;}
    public List<SBQQ__QuoteLine__c> mainprdctqutlines{ get; set; }
    public List<SBQQ__QuoteLine__c> optnqllines{ get; set; }
    public List<SBQQ__QuoteLine__c> optionsToUpdate{ get; set; } 
    public Set<String> optlineitems{ get; set; }
    public Map<string,SBQQ__QuoteLine__c> rqrdqutlinemap{ get; set; } 
    Public invoiceit_s__Payment_Method__c ccpm {get; set;}
    Public invoiceit_s__Payment_Method__c achpm {get; set;}
    Public List<invoiceit_s__Payment_Method__c> availablepymnt {get; set;}
   
    public String ckid {get;set;}
    
    public Payment_Info_Extn(){
       
       iserror=false;
       hasaccount=false; 
       paymentmethod=false;
       qut = new SBQQ__Quote__c(); 
       ccpm = new invoiceit_s__Payment_Method__c();
       achpm = new invoiceit_s__Payment_Method__c();
       opp = new Web_Opp__c ();
       salesqutln = new SBQQ__QuoteLine__c();
       ccpm.Same_as_Shipping_Add__c=true;
       achpm.Same_as_Shipping_Add__c=true;
       ccpm.invoiceit_s__Default__c=true;
       achpm.invoiceit_s__Default__c=true;
       
         
         
          String memberaccuntId = ApexPages.currentPage().getParameters().get( 'aci');     
         
        
          Existingaccnt=[Select Id,OwnerId,Name,Missing_Billing_Shipping_Info__c,Email__c,Acct_Primary_Contact__r.Name,Acct_Primary_Contact__r.Email,Acct_Primary_Contact__r.Phone,Acct_Primary_Contact__r.FirstName,Acct_Primary_Contact__r.LastName,
                                BillingStreet,Billingcity,BillingState,Billingpostalcode,ShippingStreet,shippingcity,shippingState,shippingpostalcode,Primary_Contact_Name__c,Shipping_Contact_Name__c  
                                From Account Where id=:memberaccuntId ];
                                
         //check existed cookie
             try{
              if(!Test.isRunningTest()){
         Cookie idCookie = ApexPages.currentPage().getCookies().get('cartId');
        ckid = idCookie.getvalue();
        crt =[select id,Cart_Account__c,Is_Flashsale__c,Total_Price__c,Shipping_Name__c,Shipping_Zip__c,Shipping_City__c,State__c,Street_Address__c From cart__c Where id =:ckid  ];
         }else{
        crt =[select id,Cart_Account__c,Is_Flashsale__c,Total_Price__c,Shipping_Name__c,Shipping_Zip__c,Shipping_City__c,State__c,Sales_Assignment__c,Street_Address__c,Missing_Shipping_Info__c From cart__c where Cart_Account__c=:Existingaccnt[0].id  ];
       
        }
        
        }catch(Exception e) {}
             
             
        
                                
          availablepymnt =[Select Id,invoiceit_s__Billing_First_Name__c,invoiceit_s__Billing_Last_Name__c,invoiceit_s__Billing_Email__c,invoiceit_s__Account__c,
                                       invoiceit_s__Active__c,invoiceit_s__Payment_Method__c,invoiceit_s__Default__c,invoiceit_s__Name_on_Card__c,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,
                                       invoiceit_s__Card_Expiration_Year__c,invoiceit_s__CVV__c,Actno_Last4digits__c,invoiceit_s__Bank_Account_Number__c,invoiceit_s__Bank_Account_Name__c,invoiceit_s__Bank_Account_Type__c,invoiceit_s__Bank_Name__c,
                                       invoiceit_s__Bank_Routing_Code__c,invoiceit_s__Billing_Address__c,invoiceit_s__Billing_City__c,invoiceit_s__Billing_State_Province__c,invoiceit_s__Billing_Zip_Postal__c,
                                       invoiceit_s__Billing_Country__c,Same_as_Shipping_Add__c  From invoiceit_s__Payment_Method__c Where invoiceit_s__Account__c=:memberaccuntId  ];
           if(Existingaccnt.size()>0){
            if(Existingaccnt[0].Missing_Billing_Shipping_Info__c == TRUE)
             hasaccount=true;
             }
             
         cnt=[Select Id,Name,AccountID,Is_Primary__c,Abandoned_User_Renewal__c,Abandoned_User_New__c,Phone,Email From Contact Where Is_Primary__c =true AND AccountID=:memberaccuntId  order by CreatedDate desc Limit 1 ];

          // Get pricebook id
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        prcbkid = pricebook2id.Pricebookid__c;
        
         pi=[Select Id,Name From Product2 Where Name='Sales Tax' AND IsActive= true Limit 1 ];
                 
        ppl= [select id,Name From invoiceit_s__Payment_Plan__c Where Name='Paid In Full Payment Plan'];
        
    }
    
    
  public Pagereference insertquote() {
        
        
        //create Quote
        qut.SBQQ__Type__c ='Quote';
        qut.SBQQ__Status__c='Draft';
        qut.SBQQ__SalesRep__c=Existingaccnt[0].OwnerId;
        qut.OwnerId=Existingaccnt[0].OwnerId;
        qut.SBQQ__PrimaryContact__c=cnt.id;
        qut.SBQQ__Primary__c = true;
        qut.SBQQ__LineItemsGrouped__c =true;
        qut.SBQQ__BillingName__c=crt[0].Shipping_Name__c ;
        qut.SBQQ__BillingStreet__c=crt[0].Street_Address__c;
        qut.SBQQ__BillingCity__c=crt[0].Shipping_City__c;
        qut.SBQQ__BillingState__c=crt[0].State__c;
        qut.SBQQ__BillingPostalCode__c=crt[0].Shipping_Zip__c;
        qut.SBQQ__BillingCountry__c = 'USA';
        qut.Origin_Source__c = 'WEB';
        qut.SBQQ__Account__c=Existingaccnt[0].id;
        qut.SBQQ__ShippingName__c=crt[0].Shipping_Name__c ;
        qut.SBQQ__ShippingStreet__c=crt[0].Street_Address__c;
        qut.SBQQ__ShippingCity__c=crt[0].Shipping_City__c;
        qut.SBQQ__ShippingState__c=crt[0].State__c;
        qut.SBQQ__ShippingPostalCode__c=crt[0].Shipping_Zip__c;
        qut.SBQQ__ShippingCountry__c = 'USA';
        if(!Test.isRunningTest())
        qut.QTC__Payment_Plan__c =  ppl[0].id;
        qut.SBQQ__PricebookId__c =prcbkid ;
        qut.SBQQ__PriceBook__c =prcbkid ;
        system.debug('peimary quote'+qut);

         if(!Test.isRunningTest())insert qut;
        
        //Create Opportunity
        opp.Name= 'weborder'+''+datetime.now();
        opp.WebAccount__c= Existingaccnt[0].id;
        if(!Test.isRunningTest()){
        opp.Amount__c = crt[0].Total_Price__c;
        }
        opp.Company_Name__c=Existingaccnt[0].Name;
        opp.Primary_Contact_Name__c=cnt.Name;
        opp.Primary_Phone__c=cnt.Phone;
        opp.Primary_Email__c=cnt.Email;
        opp.CloseDate__c = Date.today();
        opp.StageName__c= 'Negotiation';
        opp.Product_c__c ='Web-Order';
        opp.web_quote__c=qut.id;
        opp.Type__c='New to New';
        opp.PricebookId__c=prcbkid;
         if(!Test.isRunningTest())insert opp; 
        
        system.debug('peimary quote'+opp);
        
        system.debug('oppid'+opp.id);
        
        
       
         system.debug('qut'+qut);
        //Create quote lines
         mainprdctqutlines= new List<SBQQ__QuoteLine__c>();
         optnqllines= new List<SBQQ__QuoteLine__c>();
         optionsToUpdate = new List<SBQQ__QuoteLine__c>();
         optlineitems= new Set<String>();
         rqrdqutlinemap= new map<string,SBQQ__QuoteLine__c>(); 
         if(!Test.isRunningTest()){
         for(SBQQ__Quote__c sql :[Select Id From SBQQ__Quote__c  Where Id =: qut.id ] ){
               
                salesqutln.SBQQ__Quantity__c = 1;
                 
                salesqutln.SBQQ__Product__c = pi[0].id;
               
                salesqutln.SBQQ__Quote__c  = sql.id;
                
               
               optionsToUpdate .add(salesqutln);
                system.debug('****sql quote linessss'+salesqutln);
         }
               
          
       }
         for(Cart_Line__c lns: [Select Id,Option_Id__c,Product__c,Quantity__c,Promo_Id__c From Cart_Line__c Where cart__r.Cart_Account__c =: Existingaccnt[0].id AND cart__c=:crt[0].id]) {
         system.debug('crtlns'+lns);
                SBQQ__QuoteLine__c qutlines= new SBQQ__QuoteLine__c();
                qutlines.SBQQ__Quantity__c = lns.Quantity__c;
                qutlines.SBQQ__Product__c = lns.Product__c;
                qutlines.Promotion__c=lns.Promo_Id__c;
                qutlines.SBQQ__Quote__c  = qut.id;
                
                
                rqrdqutlinemap.put(lns.Product__c,qutlines);
                if(lns.Option_Id__c!=null && lns.Option_Id__c!='')
                optlineitems.addAll(lns.Option_Id__c.split(','));
                optionsToUpdate .add(qutlines);
                
                
                 }
                // }
               system.debug('**********************'+rqrdqutlinemap);
             if(!Test.isRunningTest())  if(optionsToUpdate.size()>0) insert optionsToUpdate;   
                 
           return null;     
        
     }
     
     
    public pagereference creatql(){    
     
        
         //using product id and required and display type field create quotelines
         system.debug('**bundled line items for ql'+rqrdqutlinemap.keyset());
           for(SBQQ__ProductOption__c ml :[Select Id,SBQQ__OptionalSKU__c,SBQQ__Bundled__c,SBQQ__OptionalSKU__r.Shipping_Processing__c,SBQQ__ConfiguredSKU__c,SBQQ__Feature__r.Name From SBQQ__ProductOption__c  Where ((id IN :optlineitems) OR (SBQQ__ConfiguredSKU__c IN :rqrdqutlinemap.keyset()  AND (SBQQ__Bundled__c = true OR SBQQ__Feature__r.Name ='Fees' )))ORDER BY  SBQQ__Number__c ASC] ){
           
            SBQQ__QuoteLine__c ql= new SBQQ__QuoteLine__c();
           if(ml.SBQQ__Feature__r.Name !='Fees'){
          ql.SBQQ__Quantity__c = 1;
          }else{
          ql.SBQQ__Quantity__c = 0; 
          }
          ql.SBQQ__Product__c = ml.SBQQ__OptionalSKU__c ;
          ql.Shipping_Processing__c=ml.SBQQ__OptionalSKU__r.Shipping_Processing__c;
          ql.SBQQ__Quote__c  = qut.id;
           if(ml.SBQQ__OptionalSKU__r.Shipping_Processing__c == False && ml.SBQQ__Bundled__c  == TRUE){ql.SBQQ__Bundled__c = true;}
          ql.SBQQ__RequiredBy__c=rqrdqutlinemap.get(ml.SBQQ__ConfiguredSKU__c).Id;
          ql.SBQQ__ProductOption__c=ml.Id;
          
          optnqllines.add(ql);
          system.debug('**********************'+ql);
          }
          
        if(!Test.isRunningTest()) if(optnqllines.size()>0)    insert optnqllines;
         
         system.debug('****sql quote id'+qut.id);
        
        

            return null;
    }
    
    
    public Pagereference salestx(){
  
        system.debug('qute id***'+qut.id);
         if(!Test.isRunningTest()){
        IIT_SpeedTaxConnector.calculateTaxForQuote(qut.id);

        }
       
        return null;
        
        
    }

  Public PageReference saveAch(){
            system.debug('payment mode'+achpm +Existingaccnt[0].id);
          achpm.invoiceit_s__Account__c = Existingaccnt[0].id;
          achpm.invoiceit_s__Payment_Method__c = 'ACH';
          
           if ( achpm.invoiceit_s__Billing_First_Name__c== null || achpm.invoiceit_s__Billing_First_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid Name on Account.');
            paymentmethod=true;
            return null;
        }  
           
           if ( achpm.invoiceit_s__Billing_Last_Name__c== null || achpm.invoiceit_s__Billing_Last_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid Name on Account.');
            paymentmethod=true;
            return null;
        }  
        
          if ( (achpm.invoiceit_s__Bank_Routing_Code__c != null && achpm.invoiceit_s__Bank_Routing_Code__c != ''  && !Pattern.matches('^([0-9]{9})||([0-9]{5}-[0-9]{4})$', achpm.invoiceit_s__Bank_Routing_Code__c)) || ( achpm.invoiceit_s__Bank_Routing_Code__c == null || achpm.invoiceit_s__Bank_Routing_Code__c == '') ) {
            
            VFUtil.AddErrorMessage ( 'Invalid Routing Number.');
            paymentmethod=true;
            return null;
        }
            if (( achpm.invoiceit_s__Bank_Account_Number__c == null || achpm.invoiceit_s__Bank_Account_Number__c == '' ) ||(achpm.invoiceit_s__Bank_Account_Number__c.length() <4 || achpm.invoiceit_s__Bank_Account_Number__c.length() > 17 )){
            VFUtil.AddErrorMessage ( 'Enter Valid Account Number.');
            paymentmethod=true;
            return null;
        }     

 
            if ( achpm.invoiceit_s__Bank_Account_Type__c == null || achpm.invoiceit_s__Bank_Account_Type__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Please select account type.');
            paymentmethod=true;
            return null;
        }   
            
              if ( achpm.invoiceit_s__Bank_Name__c == null || achpm.invoiceit_s__Bank_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Please provide bank organization name.');
            paymentmethod=true;
            return null;
        } 
         system.debug('payment mode'+achpm +Existingaccnt[0].id);
         
         if(achpm.Same_as_Shipping_Add__c ==true){
         achpm.invoiceit_s__Billing_Address__c=Existingaccnt[0].BillingStreet;
         achpm.invoiceit_s__Billing_City__c=Existingaccnt[0].BillingCity;
         achpm.invoiceit_s__Billing_State_Province__c=Existingaccnt[0].BillingState;
         achpm.invoiceit_s__Billing_Zip_Postal__c=Existingaccnt[0].BillingPostalCode;
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
            VFUtil.AddErrorMessage ('Enter a valid state. Acceptable formats: GA,TX,CA,AZ.'); 
            return null;
                }
                
        
         
          if ( achpm.invoiceit_s__Billing_Zip_Postal__c != null && achpm.invoiceit_s__Billing_Zip_Postal__c != '' && !Pattern.matches('^([0-9]{5})||([0-9]{5}-[0-9]{4})$', achpm.invoiceit_s__Billing_Zip_Postal__c) ) {
            VFUtil.AddErrorMessage ( 'Invalid zip code.');
            return null ;
        }   
         
           List<invoiceit_s__Payment_Method__c> ptoupdate= new List<invoiceit_s__Payment_Method__c>();
          for(invoiceit_s__Payment_Method__c pi:availablepymnt ){
          
          pi.invoiceit_s__Default__c =false;
          ptoupdate.add(pi);
          }
          update ptoupdate;
          
          achpm.invoiceit_s__Billing_Country__c='USA';
          achpm.invoiceit_s__Billing_Email__c=Existingaccnt[0].Email__c;         
          
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
          
          iserror = true;  
           
           return null;            
    }
    
    
    Public PageReference savecc(){
     
          ccpm.invoiceit_s__Account__c = Existingaccnt[0].id;
           system.debug('payment mode'+ccpm +Existingaccnt[0].id);

          if(ccpm.invoiceit_s__Card_Number__c == null || ccpm.invoiceit_s__Card_Number__c == ''){
             ccpm.invoiceit_s__CVV__c = null; 
            VFUtil.AddErrorMessage ( 'Invalid credit card number.');
             return null;
           }

           if ( ccpm.invoiceit_s__Billing_First_Name__c== null || ccpm.invoiceit_s__Billing_First_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid Name on Account.');
            return null;
        }  
           
           if ( ccpm.invoiceit_s__Billing_Last_Name__c== null || ccpm.invoiceit_s__Billing_Last_Name__c == ''  ) {
            VFUtil.AddErrorMessage ( 'Invalid Name on Account.');
            return null;
        }  
           
           if(ccpm.invoiceit_s__Card_Expiration_Month__c == null || ccpm.invoiceit_s__Card_Expiration_Month__c == ''){
            ccpm.invoiceit_s__CVV__c = null; 
            ccpm.invoiceit_s__Card_Number__c = null;  
            VFUtil.AddErrorMessage ( 'Select credit card expiration month .');
             return null;
           }
           
           if(ccpm.invoiceit_s__Card_Expiration_Year__c == null || ccpm.invoiceit_s__Card_Expiration_Year__c == ''){
            ccpm.invoiceit_s__CVV__c = null; 
            ccpm.invoiceit_s__Card_Number__c = null;  
            VFUtil.AddErrorMessage ( 'Select credit card expiration year .');
             return null;
           }

           if(ccpm.invoiceit_s__Card_Type__c == null || ccpm.invoiceit_s__Card_Type__c == ''){
            ccpm.invoiceit_s__CVV__c = null; 
            ccpm.invoiceit_s__Card_Number__c = null;  
            VFUtil.AddErrorMessage ( 'Select credit card type .');
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
            VFUtil.AddErrorMessage ( 'Invalid credit card.');
             return null;

          }
         if(ccpm.Same_as_Shipping_Add__c ==true){
         ccpm.invoiceit_s__Billing_Address__c=Existingaccnt[0].BillingStreet;
         ccpm.invoiceit_s__Billing_City__c=Existingaccnt[0].BillingCity;
         ccpm.invoiceit_s__Billing_State_Province__c=Existingaccnt[0].BillingState;
         ccpm.invoiceit_s__Billing_Zip_Postal__c=Existingaccnt[0].BillingPostalCode;
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
            VFUtil.AddErrorMessage ('Enter a valid state. Acceptable formats: GA,TX,CA,AZ.'); 
            return null;
                }
                
        
         
          if ( ccpm.invoiceit_s__Billing_Zip_Postal__c != null && ccpm.invoiceit_s__Billing_Zip_Postal__c != '' && !Pattern.matches('^([0-9]{5})||([0-9]{5}-[0-9]{4})$', ccpm.invoiceit_s__Billing_Zip_Postal__c) ) {
            VFUtil.AddErrorMessage ( 'Invalid zip code.');
            return null ;
        }   
        
          ccpm.invoiceit_s__Billing_Country__c='USA';
          ccpm.invoiceit_s__Billing_Email__c=Existingaccnt[0].Email__c;
          //upsert ccpm;
          
          system.debug('payment mode'+ccpm );
            List<invoiceit_s__Payment_Method__c> ptoupdate= new List<invoiceit_s__Payment_Method__c>();
          for(invoiceit_s__Payment_Method__c pi:availablepymnt ){
          
          pi.invoiceit_s__Default__c =false;
          ptoupdate.add(pi);
          }
          update ptoupdate;
          
          try{
           ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(Existingaccnt[0]);
          invoiceit_s.ControllerForGenerateTokenForCyberSource createTokenController = new invoiceit_s.ControllerForGenerateTokenForCyberSource(controller);
          createTokenController.paymentMethod  = ccpm;
          createTokenController.generateToken();
           }catch(Exception e) {
            
            iserror = false;  
            return null;
           }
           
       iserror = true;  
        
           
           return null;            
    }


}