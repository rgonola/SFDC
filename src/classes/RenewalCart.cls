public with sharing class RenewalCart {
    
    Public List<schema.Product2> products {get;set;}

    public Map<String, List<SBQQ__ProductOption__c>> featuresWithOptions {get;set;}

    public Map<String, Decimal> unitprice {get;set;}
    
    public set<String> prductpageids {get;set;}
    
    public String priceJSON{get;set;}
    
    public String urlprdct{get;set;}
    
    public String urlprdct2{get;set;}
    
    public String urlprdct3{get;set;}
    
    public Boolean cupnscess{get;set;}
    
    public Set<String> crtlnprdcts{get;set;}
    
    public Boolean hasprdcts{get;set;}
    
    public Opportunity  opp{get; set;}
    
    public string prmtn{get;set;}
      
    public cart__c chrt{get;set;}
    
     public String qid{ get; set; }
    
    public List<Contact> cn{ get; set; }
    
    public List<Cart_Line__c> crtln{get;set;}
    
    public Map<String, List<string>> productToSelectedOptionsMap {get;set;}
     
    public Map<Id, Product2> productMap {get;set;}
     
    public Map<String, Boolean> hasFeatures {get;set;}
    
    public List<SBQQ__Quote__c>  qute{get;set;}
    
    Public List<Product2> pi{get;set;} 
    
    public Account acnt {get;set;}
    
    public List<SBQQ__QuoteLine__c>  quteline{get;set;}

    public Map<String, Map<String, List<SBQQ__ProductOption__c>>> productFeatures {get;set;}
    
    public Map<string,string> mapgetreqirdql {get;set;}
    
    public List<invoiceit_s__Payment_Plan__c>  ppl{get;set;}
    
    public List<SBQQ__QuoteLine__c> mainprdctqutlines{get;set;}
    
    public Map<string,Decimal> mapdiscuntdprice{get;set;}
    
    public Map<string,string> mapnottocreatelineitems{get;set;}
    public Map<string,SBQQ__QuoteLine__c> rqrdqutlinemap{get;set;}
    
    public string coupon{get;set;}
    
    public Boolean hasquote{get;set;}
    
    public Set<String> cartedProducts{get;set;}
    public String mapProductIdToQuantityJSON {get;set;}
    
    public Map<String, String> selectedOptionsMap {get;set;}
    
    public Set<String> optlineitems{get;set;}
    
    private Map<Id, SBQQ__ProductOption__c> options;
    
    public List<SBQQ__QuoteLine__c> mapmainlines{get;set;}            
    public List<SBQQ__QuoteLine__c> optionsToUpdate {get;set;}      
    public Set<String> mapoptnlineitms{get;set;}       
    public Map<string,SBQQ__QuoteLine__c > maprqrdqutlinemap{get;set;}
    public List<SBQQ__QuoteLine__c> mapmainlinesfrst {get;set;}
    
    public RenewalCart (ApexPages.StandardController controller) {
        //Id productId = controller.getId();
        selectedOptionsMap = new Map<String, String>();
        products = new List<schema.Product2>();
        cartedProducts = new Set<String>();
        Map<String, Decimal> mapProductIdToQuantity = new Map<String, Decimal>();
        mapdiscuntdprice=new Map<string,Decimal>();
         productToSelectedOptionsMap = new Map<String, List<string>>();
        mapProductIdToQuantityJSON = '';
        unitprice = new Map<String, Decimal>();
         urlprdct='';
         hasquote=false;
         cupnscess=false;
        Cookie cartCookie = ApexPages.currentPage().getCookies().get('rcid');
        urlprdct = ApexPages.currentPage().getParameters().get('pdrct');
        urlprdct2 = ApexPages.currentPage().getParameters().get('pdrct2');
        urlprdct3 = ApexPages.currentPage().getParameters().get('pdrct3');
         prmtn= ApexPages.currentPage().getParameters().get('Promo');
        String memberaccuntId1 = ApexPages.currentPage().getParameters().get( 'SFDCCartID'); 
        String cupnstatus= ApexPages.currentPage().getParameters().get( 'coupon'); 
        hasprdcts =true;
        qid='';
        
          try {
          
          system.debug('cookie'+cartCookie);
          
           if((memberaccuntId1 !=null )&& (memberaccuntId1 !='' )){
         
           cartCookie = new Cookie('rcid',memberaccuntId1, null, 172800, false); 
          ApexPages.currentPage().setCookies(new Cookie[]{cartCookie}); 
          system.debug('cookieee here'+cartCookie.getvalue());
          
          chrt =[select id,Total_Price__c,Purchase_in_Page4__c,cart_Account__c,Existing_login__c,Promo_Id__c,Promo_Value__c,Originate_URL__c,Tax_Calculated__c From Cart__c Where (Id=:memberaccuntId1 ) ];
          } else{
          chrt =[select id,Cart_Account__c,Purchase_in_Page4__c,Promo_Id__c,Originate_URL__c,Existing_login__c,Promo_Value__c,Total_Price__c From cart__c Where id =: cartCookie.getvalue()];
          }
           
         
         if(cupnstatus !=null && cupnstatus!=''){
              cupnscess=true;
                 }  
           
         crtln=[select id,Product__c,Discounted_Price__c From Cart_Line__c  Where cart__c =:chrt.id ];
         system.debug('cln line  75'+crtln);
          
         
                   
                        
          for(Cart_Line__c  cl:crtln){
          if(cl.Discounted_Price__c!=null){
          mapdiscuntdprice.put(cl.Product__c,cl.Discounted_Price__c );
          }else{
          mapdiscuntdprice.put(cl.Product__c,0 );
          }
          system.debug('Map 78'+mapdiscuntdprice);
          }
                          
          for(Cart_Line__c cln:crtln){
          if(!mapdiscuntdprice.containskey(cln.Product__c)){
          mapdiscuntdprice.put(cln.Product__c,0 );
          system.debug('cln line  75'+cln);
          }
          } 
        acnt =[Select id,Name,OwnerId,BillingStreet,Billingcity,BillingCountry,ShippingCountry,Contact__r.id,BillingState,Billingpostalcode,SBQQ__DefaultOpportunity__r.SBQQ__PrimaryQuote__c,SBQQ__DefaultOpportunity__c,Email__c,ShippingStreet,shippingcity,shippingState,
                              shippingpostalcode,Primary_Contact_Name__c,(SELECT
                              name,Contact.FirstName, Contact.LastName
                              FROM Account.Contacts) From Account where id=:chrt.cart_Account__c];
                              
        qute =[select Id,Net_Minus_Tax_Fees__c,Tax__c,SBQQ__Status__c,Original_Quote__c,SBQQ__NetAmount__c,SBQQ__PricebookId__c,Processing_Fees__c,SBQQ__Primary__c,Tax_Time_Stamp__c,Tax_Grand_Total__c,SBQQ__Account__c,SBQQ__CustomerAmount__c,
                      SBQQ__TotalCustomerDiscountAmount__c from SBQQ__Quote__c where SBQQ__Account__c =: chrt.Cart_Account__c AND Web_Renewal__c=true AND     
                      SBQQ__Primary__c =true AND SBQQ__Status__c !='Invoiced'  order by CreatedDate desc Limit 1];
                      
         ppl= [select id,Name From invoiceit_s__Payment_Plan__c Where Name='Paid In Full Payment Plan'];
         
         try{
                cn=[Select Id,Name,AccountID,Is_Primary__c,Phone,Email From Contact Where Is_Primary__c =true AND AccountID=:chrt.Cart_Account__c order by CreatedDate desc Limit 1 ];
                  
                  }catch(Exception e){}
                              
        pi=[Select Id,Name From Product2 Where Name='Sales Tax' AND IsActive= true Limit 1 ];
                      
        mapgetreqirdql= new map<string,string>();         
        quteline =[select Id,SBQQ__Bundle__c,SBQQ__RequiredBy__c,SBQQ__Product__c,SBQQ__ProductOption__c,SBQQ__ListPrice__c,SBQQ__Product__r.List_Price__c,SBQQ__NetPrice__c,
                          SBQQ__CustomerTotal__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,SBQQ__ListTotal__c,
                          SBQQ__Quantity__c  From SBQQ__QuoteLine__c  Where SBQQ__Quote__c = :qute[0].Id AND SBQQ__Product__c != null AND 
                          SBQQ__Product__r.Name != 'Sales Tax' AND SBQQ__RequiredBy__c = null order by SBQQ__Number__c ];
                          
         for(SBQQ__QuoteLine__c qlns :quteline){
         mapgetreqirdql.put(qlns.SBQQ__Product__c,qlns.id);
         
         }
           }catch(Exception e) {
           
           
           }                                        
        try{
        for(Cart_Line__c cartline : [Select Id, Product__c, Quantity__c, Option_Id__c From cart_Line__c Where cart__c =: cartCookie.getValue()]) {
            mapProductIdToQuantity.put(cartline.Product__c, cartline.Quantity__c);
            if(cartline.Option_Id__c != null && cartline.Option_Id__c !=''){
            selectedOptionsMap.put(cartline.Product__c, cartline.Option_Id__c);
            }else{
            selectedOptionsMap.put(cartline.Product__c, '');
            system.debug('map at 82'+mapProductIdToQuantity);
            }
        }
        mapProductIdToQuantityJSON = JSON.serialize(mapProductIdToQuantity);
        cartedProducts.addAll(mapProductIdToQuantity.keyset());
        system.debug('cartedProducts'+cartedProducts);
        }catch(Exception e){}
        
        //Get products
        products = [Select Id, Name, Description,Marketing_Name__c,Family,Detail_description__c From Product2 Where Id IN : cartedProducts];
         
         if(products.size()==0){
       
       hasprdcts =false;
       
       }
        // Get Fetaures and their options
        featuresWithOptions = new Map<String, List<SBQQ__ProductOption__c>>();
        productFeatures = new Map<String, Map<String, List<SBQQ__ProductOption__c>>>();
        Set<Id> optionProductIds = new Set<Id>();
        options = new Map<Id, SBQQ__ProductOption__c>([Select Id,Name,SBQQ__Feature__r.Name, Display_Type__c, SBQQ__Number__c,SBQQ__ConfiguredSKU__c, SBQQ__Type__c, SBQQ__ProductCode__c,SBQQ__UnitPrice__c,Feature_Name__c,
                                                                                            SBQQ__OptionalSKU__r.Marketing_Name__c,SBQQ__Selected__c,SBQQ__OptionalSKU__r.Name,SBQQ__ProductName__c, SBQQ__ProductDescription__c, SBQQ__OptionalSKU__c,SBQQ__Required__c, SBQQ__Bundled__c   
                                                                                         From SBQQ__ProductOption__c 
                                                                                         Where SBQQ__ConfiguredSKU__c IN : cartedProducts AND Feature_Name__c!='Recommended Products' AND Feature_Name__c!='Fees' AND SBQQ__ProductCode__c !='TWDVDFEE_2017' AND SBQQ__ProductCode__c !='ATX-DVDFEE_2017'
                                                                                          AND    SBQQ__Feature__c != null   AND (Feature_Name__c!='Training'  ) AND SBQQ__OptionalSKU__r.SBQQ__Hidden__c =False
                                                                                         ORDER BY SBQQ__Feature__r.SBQQ__Number__c, SBQQ__Number__c ASC]);
        for(SBQQ__ProductOption__c option : options.values()) {
             if(option.Feature_Name__c!='Fees' || (option.SBQQ__UnitPrice__c==null && option.Feature_Name__c=='Fees') ){ 
            optionProductIds.add(option.SBQQ__OptionalSKU__c); 
            }else{
            if(option.SBQQ__UnitPrice__c!=null)
           unitprice.put(option.SBQQ__OptionalSKU__c, option.SBQQ__UnitPrice__c);
           }            
            if(!productFeatures.containsKey(option.SBQQ__ConfiguredSKU__c)&& option.SBQQ__Bundled__c !=TRUE) {
                productFeatures.put(option.SBQQ__ConfiguredSKU__c, new Map<String, List<SBQQ__ProductOption__c>>{option.SBQQ__Feature__r.Name => new List<SBQQ__ProductOption__c>{option}});
            }
            else if(option !=null ){
                featuresWithOptions = productFeatures.get(option.SBQQ__ConfiguredSKU__c);
                if(featuresWithOptions!=null){
                if(!featuresWithOptions.containsKey(option.SBQQ__Feature__r.Name) && option.SBQQ__Bundled__c !=TRUE)
                    featuresWithOptions.put(option.SBQQ__Feature__r.Name, new List<SBQQ__ProductOption__c>{option});
                else if( option.SBQQ__Bundled__c !=TRUE) 
                    featuresWithOptions.get(option.SBQQ__Feature__r.Name).add(option);
                    }
                  if(option.SBQQ__Bundled__c !=TRUE)
                productFeatures.put(option.SBQQ__ConfiguredSKU__c, featuresWithOptions);
            }
            
            if(option.SBQQ__Bundled__c ==TRUE){
            
                    //if(productToSelectedOptionsMap.containsKey(option.SBQQ__ConfiguredSKU__c))
                        //opn.addAll(productToSelectedOptionsMap.get(option.SBQQ__ConfiguredSKU__c));
                        system.debug('dfss'+options);
                    if(options !=null  ){
                    if(!productToSelectedOptionsMap.containsKey(option.SBQQ__ConfiguredSKU__c))
                    productToSelectedOptionsMap.put(option.SBQQ__ConfiguredSKU__c, new List<string>{option.SBQQ__OptionalSKU__r.Marketing_Name__c} );
                    else
                    productToSelectedOptionsMap.get(option.SBQQ__ConfiguredSKU__c).add(option.SBQQ__OptionalSKU__r.Marketing_Name__c);
                    }else{
                     productToSelectedOptionsMap.put(option.SBQQ__ConfiguredSKU__c, new List<string>() );
                    }
              }else{
                     productToSelectedOptionsMap.put(option.SBQQ__ConfiguredSKU__c, new List<string>() );
                    } 
        }
        
        
                  //  Used to display Product description, when  there are no options selected for a productmapgetreqirdql
                productMap = new Map<Id, Product2>([Select Id, Description From product2 Where Id IN : cartedProducts]);
                
                hasFeatures = new Map<String, Boolean>();
                //  Adds productIds to the map, which have no options
                for(String s : cartedProducts) {
                    if(!productFeatures.containsKey(s)) {
                         productToSelectedOptionsMap.put(s, new list<string>());
                        hasFeatures.put(s, false);
                    }
                    else
                        hasFeatures.put(s, true);
                        system.debug('line 139'+hasFeatures);
                }
                //  Adds productIds to the map, which have no options
                for(String s : cartedProducts) {
                    if(!productFeatures.containsKey(s))
                        productFeatures.put(s, new Map<String, List<SBQQ__ProductOption__c>>());
                }
                
        // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
        
        
        for(PricebookEntry price : [SELECT Id, Name, UnitPrice, Product2Id FROM PricebookEntry WHERE (Product2Id IN :cartedProducts OR Product2Id IN : optionProductIds) AND Pricebook2Id =:prcbkid]){
            unitprice.put(price.Product2Id, price.UnitPrice);
        }
        
                for(Id pu: cartedProducts) {
         if(!unitprice.containsKey(pu))
          unitprice.put(pu, 0);
         }
         for(Id pon: optionProductIds ) {
         if(!unitprice.containsKey(pon))
          unitprice.put(pon, 0);
         }
         
        priceJSON = JSON.serialize(unitprice);
        
        try {
            for(Id prodId : cartedProducts) {
                if(!productFeatures.containsKey(prodId))
                    productFeatures.put(prodId, new Map<String, List<SBQQ__ProductOption__c>>());
            }
        }catch(Exception e){}
    }
    public PageReference  urltosaveprdct(){
    
      
      string y = ApexPages.currentPage().getParameters().get('returnurl');
      system.debug('**url '+y );
      if(y!=null && y!=''&& Chrt!=null){

       chrt.Originate_URL__c=y;
       update chrt;
      }
      string x='x';
      if(urlprdct!= null && urlprdct!=''){
       CreateCart cc = new CreateCart(); 
        Product2 prcdts = [Select Id, Name, Description,Marketing_Name__c From Product2 Where ProductCode = : urlprdct];
       try {
       cc.Line(prcdts.id,chrt.id,null,null);
       }catch(Exception e){
       cc.Line(prcdts.id,x,y,null);
       }
       
       
       
       PageReference prl = new pageReference('/apex/Renewalcart');
       prl.setRedirect(true);
       return prl;
       }
       return null;
    }
    
    
    public PageReference onCheckout() {
    
        Cookie cartCookie = ApexPages.currentPage().getCookies().get('rcid');
        String prodInfo = ApexPages.currentPage().getParameters().get('prodInfo');
        String  oppPrice = ApexPages.currentPage().getParameters().get('totalprice');
        String selopid = ApexPages.currentPage().getParameters().get('selectedoptions');
        prodInfo = prodInfo.removeEnd(',');
        
        if(oppPrice != null){
            cart__c crt =[select id,Cart_Account__c,Total_Price__c From cart__c Where id =: cartCookie.getvalue()];
            crt.Total_Price__c = decimal.valueOf(oppPrice);
            update crt;
        }
        
        Map<String,String> mapproductidtoselectedoptions= new Map<String, String>();
        List<Cart_Line__c > crtlntoupdate= new List<Cart_Line__c >();
        String selectedprdctoptns ='';
        
        if(selopid != null && selopid !=''){
               for(String optn :selopid.split(',')){
               
                   if(options.containskey(optn)){
                        selectedprdctoptns =optn;
                       if(mapproductidtoselectedoptions.containskey(options.get(optn).SBQQ__ConfiguredSKU__c))
                           selectedprdctoptns += ','+mapproductidtoselectedoptions.get(options.get(optn).SBQQ__ConfiguredSKU__c);
                       
                       mapproductidtoselectedoptions.put(options.get(optn).SBQQ__ConfiguredSKU__c,selectedprdctoptns );
                   }
              }
              for(Cart_Line__c crtln:[select id,Option_Id__c,Product__c From Cart_Line__c Where cart__c =: cartCookie.getvalue() AND Product__c IN : mapproductidtoselectedoptions.keyset()]){
                  crtln.Option_Id__c = mapproductidtoselectedoptions.get(crtln.Product__c );
                  crtlntoupdate.add(crtln);
              }
              if(crtlntoupdate.size()>0)
                  update crtlntoupdate;
        }
        
        updateCartLines(prodInfo, cartCookie.getValue());
        
        chrt.Purchase_in_Page4__c=TRUE;
       update chrt;
          if(chrt.Existing_login__c==true){
         
          createqutlins();
          }
          
          
         
        
         return null;
    
    }
    
    public void onKeepshopping() {
        Cookie cartCookie = ApexPages.currentPage().getCookies().get('rcid');
        String prodInfo = ApexPages.currentPage().getParameters().get('prodQua');
        String  oppPrice = ApexPages.currentPage().getParameters().get('totalprice');
         String selopid = ApexPages.currentPage().getParameters().get('selectedoptions');
        
        prodInfo = prodInfo.removeEnd(',');
        
        if(oppPrice != null){
            cart__c crt =[select id,Cart_Account__c,Total_Price__c From cart__c Where id =: cartCookie.getvalue()];
            crt.Total_Price__c = decimal.valueOf(oppPrice);
            update crt;
        }
        
         Map<String,String> mapproductidtoselectedoptions= new Map<String, String>();
        List<Cart_Line__c > crtlntoupdate= new List<Cart_Line__c >();
        String selectedprdctoptns ='';
        
        if(selopid != null){
               for(String optn :selopid.split(',')){
               
                   if(options.containskey(optn)){
                        selectedprdctoptns =optn;
                       if(mapproductidtoselectedoptions.containskey(options.get(optn).SBQQ__ConfiguredSKU__c))
                           selectedprdctoptns += ','+mapproductidtoselectedoptions.get(options.get(optn).SBQQ__ConfiguredSKU__c);
                       
                       mapproductidtoselectedoptions.put(options.get(optn).SBQQ__ConfiguredSKU__c,selectedprdctoptns );
                   }
              }
              for(Cart_Line__c crtln:[select id,Option_Id__c,Product__c From Cart_Line__c Where cart__c =: cartCookie.getvalue() AND Product__c IN : mapproductidtoselectedoptions.keyset()]){
                  crtln.Option_Id__c = mapproductidtoselectedoptions.get(crtln.Product__c );
                  crtlntoupdate.add(crtln);
              }
              if(crtlntoupdate.size()>0)
                  update crtlntoupdate;
        }

        
        if(prodInfo != null) {
            try {
                updateCartLines(prodInfo, cartCookie.getValue());
            }catch(Exception e) {}
        }
             
        
    }
    
    public pageReference PromoBooks(){
    
        string book1= ApexPages.currentPage().getParameters().get('pymh1');
        string book2= ApexPages.currentPage().getParameters().get('pymh2');
        string book3= ApexPages.currentPage().getParameters().get('pymh3');
        
        If(((book1== null || book1=='')) && (book2== null || book2=='') && (book3== null || book3=='')){
       
       VFUtil.AddErrorMessage ( 'Please Select a Book.');
       return null;
       
       }else{
       
        if(book1!= null && book1!=''){
       CreateCart cc2 = new CreateCart(); 
        Product2 prcdts2 = [Select Id, Name, Description,Marketing_Name__c From Product2 Where ProductCode =:book1];
       
       cc2.Line(prcdts2.id,chrt.id,null,Label.Book_Promo);
       System.debug('Came here book1 ');
       }
       
       if(book2!= null && book2!=''){
       CreateCart cc3 = new CreateCart(); 
        Product2 prcdts3 = [Select Id, Name, Description,Marketing_Name__c From Product2 Where ProductCode =:book2];
       
       cc3.Line(prcdts3.id,chrt.id,null,Label.Book_Promo);
       System.debug('Came here book2');
       }
       
       if(book3!= null && book3!=''){
       CreateCart cc4 = new CreateCart(); 
        Product2 prcdts4 = [Select Id, Name, Description,Marketing_Name__c From Product2 Where ProductCode =:book3];
       
       cc4.Line(prcdts4.id,chrt.id,null,Label.Book_Promo);
       System.debug('Came here book2');
       }
       
       chrt.Purchase_in_Page4__c=TRUE;
       update chrt;
        
          Decimal r=math.random();  
         PageReference pr = new pageReference('/apex/Renewalcart?r='+r);
            pr.setRedirect(true);
            return pr;
        }
        
        return null;
        }
        
        
        
    public pageReference removeProduct(){
    
        string removePrdct = ApexPages.currentPage().getParameters().get('removePrdct');
        system.debug('remove product is  '+removePrdct);
        
        Cookie cartCookie = ApexPages.currentPage().getCookies().get('rcid');
        string ctid = cartCookie.getValue();
        
        
        try {
            if(removePrdct != null){
                delete [Select Id From Cart_Line__c Where Cart__c =: ctid AND Product__c =: removePrdct];
                if(qute !=null){
                 qute[0].Tax_Time_Stamp__c=null;
                 
                 update qute;
                SBQQ__QuoteLine__c todelete= [Select Id From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: qute[0].id AND SBQQ__Product__c  =: removePrdct AND SBQQ__RequiredBy__c =null];
                system.debug('remove product is  ' +todelete);
                delete [Select Id From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: qute[0].id AND SBQQ__RequiredBy__c =:todelete.id ];
                delete todelete;
                 
                }
             }   
            PageReference pr = new pageReference('/apex/Renewalcart');
            pr.setRedirect(true);
            return pr;
        }catch(Exception e) {
            return null;
        }
    }
       public Pagereference salestx(){
       
       String Tax;
       system.debug('values sales'+qute[0].SBQQ__NetAmount__c +qute[0].Tax_Grand_Total__c);
       if(qute[0].SBQQ__NetAmount__c != qute[0].Tax_Grand_Total__c || qute[0].Tax_Time_Stamp__c == null || qute[0].Tax_Grand_Total__c == null || qute[0].Tax_Time_Stamp__c.addHours(24) < system.now()){
        try{
        Tax= IIT_SpeedTaxConnector.calculateTaxForQuote(qute[0].id);
        }catch(Exception e){
        
        
        }
        }
        system.debug('tax values'+Tax);
        
         SBQQ__QuoteLine__c slql= [SELECT Id,Name,SBQQ__Quote__c,SBQQ__CustomerPrice__c,SBQQ__Quote__r.SBQQ__NetAmount__c,SBQQ__Product__r.Name FROM SBQQ__QuoteLine__c Where SBQQ__Product__r.Name = 'Sales Tax' AND SBQQ__Quote__c= :qute[0].Id ];
         
         
         
         qute[0].Tax_Time_Stamp__c=System.now();
         qute[0].Tax_Grand_Total__c=slql.SBQQ__Quote__r.SBQQ__NetAmount__c;
         qute[0].Tax__c=slql.SBQQ__CustomerPrice__c;
         update qute;
        
      
        
        Decimal r=math.random(); 
        PageReference url = new pageReference('/apex/RenewalPaymentPage?accuntId='+chrt.id+'&r='+r);
        url.setRedirect(true);
        return url;
        }
        
       public pageReference emptyCart(){
    try {
        Cookie cartCookie = ApexPages.currentPage().getCookies().get('rcid');
        string ctid = cartCookie.getValue();
        
        if(ctid != null){
            delete [Select Id, Product__c, Quantity__c,cart__r.Total_Price__c From Cart_Line__c Where cart__c = :ctid ];
            cart__c delitem =[Select Id,Total_Price__c From cart__c Where id= :ctid ];
            delitem.Total_Price__c = null;
            update delitem;
        if(qute !=null){
           
           qute[0].Tax_Time_Stamp__c=null;
           update qute;
           delete [Select Id From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: qute[0].id AND SBQQ__Product__r.Name != 'Sales Tax'];
          
        }    
         
        }
            PageReference pr = new pageReference('/apex/Renewalcart');
            pr.setRedirect(true);
            return pr;
        }catch(Exception e){
        return null;
        }
       
    }
    public pagereference applycoupon(){
    
    List<Cart_Line__c > Promotocartline=new List<Cart_Line__c >();
   List<SBQQ__QuoteLine__c > coupontoadd=new List<SBQQ__QuoteLine__c >();
   map<string,Promotion_Entry__c> mapcoupnentry =new map<string,Promotion_Entry__c>();
   map<string,Decimal> Mappromovalue=new map<string,Decimal>();
   Cookie prodCookie = ApexPages.currentPage().getCookies().get('rcid');
     String prodid = ApexPages.currentPage().getParameters().get('rcmprdct');
     String prodInfo = ApexPages.currentPage().getParameters().get('prodInfo');
     String selopid = ApexPages.currentPage().getParameters().get('selectedoptions');
     
   if(coupon==null || coupon ==''){
    VFUtil.AddErrorMessage ( 'Please enter a valid coupon.');
            return null;
   }
   
    
   
   List<Promotion_Entry__c> cp =[Select Id,Active__c,Product__c,Price__c,Promo_Value__c,Promo_Code__c From Promotion_Entry__c where Promo_Code__c =:coupon 
                                        AND Active__c =true AND Web_Active__c = TRUE AND Product__c IN :cartedProducts  AND Promo_Code__c !=null  ];
   
    if(cp.size()==0){
    VFUtil.AddErrorMessage ( 'Coupon Not Valid.');
    return null;
   }
   
   if(cp.size()>0 && chrt.Promo_Id__c!=null){
   chrt.Promo_Id__c=cp[0].Promo_Code__c ;
   update chrt;
   }else if(cp.size()>0 && chrt.Promo_Id__c==null){
   chrt.Promo_Id__c=cp[0].Promo_Code__c ;
   update chrt;
   }
  
   for(Promotion_Entry__c c :cp){
   
   mapcoupnentry.put(c.Product__c,c);
   if(c.Promo_Value__c !=null ){
   Mappromovalue.put(c.Product__c,c.Promo_Value__c);
   }else{
   Mappromovalue.put(c.Product__c,0);
   }
   }
    system.debug('mapcoupnentry herr'+mapcoupnentry);
    
   for(Cart_Line__c c:[Select Id,Promo_Value__c,Promo_Id__c,Discounted_Price__c,Product__c From Cart_Line__c  where Cart__c=:chrt.id]){
    
    if(!mapcoupnentry.containskey(c.Product__c)){
    mapcoupnentry.put(c.Product__c,new Promotion_Entry__c() );
    }
   c.Promo_Id__c=mapcoupnentry.get(c.Product__c).id;
   c.Promo_Value__c=Mappromovalue.get(c.Product__c);
   c.Discounted_Price__c=mapcoupnentry.get(c.Product__c).Price__c;
   Promotocartline.add(c);
   }
   
   if(Promotocartline.size()>0)
    update Promotocartline;
    
    if(mapcoupnentry != null && qute != null){
    if(qute[0].Original_Quote__c!=null){
   for(SBQQ__QuoteLine__c q :[select id,Promotion__c,SBQQ__Product__c  From SBQQ__QuoteLine__c where SBQQ__Product__c =:mapcoupnentry.keyset() AND SBQQ__Quote__c =:qute[0].id]){
   
   q.Promotion__c =mapcoupnentry.get(q.SBQQ__Product__c ).Id;
   
   coupontoadd.add(q);
   }
   }
   }
   system.debug(''+coupon);
   if(coupontoadd.size()>0)
   update coupontoadd;
   
   Map<String,String> mapproductidtoselectedoptions= new Map<String, String>();
        List<Cart_Line__c > crtlntoupdate= new List<Cart_Line__c >();
        String selectedprdctoptns ='';
        system.debug('line 180'+selopid );
        if(selopid != null && selopid !=''){
               for(String optn :selopid.split(',')){
               
                   if(options.containskey(optn)){
                        selectedprdctoptns =optn;
                       if(mapproductidtoselectedoptions.containskey(options.get(optn).SBQQ__ConfiguredSKU__c))
                           selectedprdctoptns += ','+mapproductidtoselectedoptions.get(options.get(optn).SBQQ__ConfiguredSKU__c);
                       
                       mapproductidtoselectedoptions.put(options.get(optn).SBQQ__ConfiguredSKU__c,selectedprdctoptns );
                   }
              }
              system.debug('Line 523'  +prodCookie.getvalue());
              for(Cart_Line__c crtln:[select id,Option_Id__c,Product__c From Cart_Line__c Where cart__c =: prodCookie.getvalue() AND Product__c IN : mapproductidtoselectedoptions.keyset()]){
                  crtln.Option_Id__c = mapproductidtoselectedoptions.get(crtln.Product__c );
                 
                  crtlntoupdate.add(crtln);
              }
              if(crtlntoupdate.size()>0)
                  update crtlntoupdate;
        }
     updateCartLines(prodInfo, prodCookie.getValue());
     
   PageReference pr = new pageReference('/apex/RenewalCart?coupon='+'success');
            pr.setRedirect(true);
            return pr;
   
   
   }
   
   
   public void createqutlins(){
   
           
        //Create quote lines
        mainprdctqutlines= new List<SBQQ__QuoteLine__c>();
         List<SBQQ__QuoteLine__c> qtnupdate= new List<SBQQ__QuoteLine__c>();
        crtlnprdcts= new Set<String>(); 
        List<SBQQ__QuoteLine__c> optionsToUpdate = new List<SBQQ__QuoteLine__c>();
        optlineitems= new Set<String>();
        Map<string,string> mapnottocreatelineitems= new map<string,string>();
        Map<string,Decimal> mapprdctqnt= new map<string,Decimal>();
        rqrdqutlinemap= new map<string,SBQQ__QuoteLine__c>(); 
       
            system.debug('***line 275 '+quteline);                                                 
        if(quteline.size()>0 ){
        for(SBQQ__QuoteLine__c q: quteline ){
        mapnottocreatelineitems.put(q.SBQQ__Product__c,q.id);
        system.debug('***line 279 '+mapnottocreatelineitems);
        }
        }                  
        for(Cart_Line__c lns: [Select Id,Option_Id__c,Product__c,Quantity__c,Promo_Id__c  From Cart_Line__c Where cart__r.Cart_Account__c =: chrt.Cart_Account__c AND cart__c=:chrt.id]) {
        if(lns.Option_Id__c!=null && lns.Option_Id__c!='')
         crtlnprdcts.addAll(lns.Option_Id__c.split(','));
         mapprdctqnt.put(lns.Product__c,lns.Quantity__c);
         
         system.debug('crtlns'+lns);
             if( !mapnottocreatelineitems.containsKey(lns.Product__c)){
                SBQQ__QuoteLine__c qutlines= new SBQQ__QuoteLine__c();
                qutlines.SBQQ__Quantity__c = lns.Quantity__c;
                qutlines.SBQQ__Product__c = lns.Product__c;
                qutlines.Promotion__c=lns.Promo_Id__c;
                qutlines.SBQQ__Quote__c  = qute[0].id;
                if(lns.Option_Id__c!=null && lns.Option_Id__c!='')
                optlineitems.addAll(lns.Option_Id__c.split(','));
                rqrdqutlinemap.put(lns.Product__c,qutlines);
                optionsToUpdate .add(qutlines);
                
                 }
            }       
               system.debug('**********************'+optionsToUpdate);
               if(optionsToUpdate.size()>0){    
                 insert optionsToUpdate;
                 qute[0].Tax_Time_Stamp__c = null;
                 update qute;
                 }
                 
                //Quantity upate on QL
                 for(SBQQ__QuoteLine__c q: quteline ){
                 if(q.SBQQ__Quantity__c!=mapprdctqnt.get(q.SBQQ__Product__c)){
                 q.SBQQ__Quantity__c=mapprdctqnt.get(q.SBQQ__Product__c);
                 qtnupdate.add(q);
                 
                 }   
                 }
                 
                 if(qtnupdate.size()>0){    
                 update qtnupdate;
                 qute[0].Tax_Time_Stamp__c = null;
                 update qute;
                 }
                 
                //get any change options to create quote lines below
                List<SBQQ__QuoteLine__c> updatedcrtlns= new List<SBQQ__QuoteLine__c>();
                for(SBQQ__QuoteLine__c q: [Select Id,SBQQ__Quote__c,SBQQ__ProductOption__c,SBQQ__Product__c From  SBQQ__QuoteLine__c Where SBQQ__Quote__c  =: qute[0].id AND SBQQ__Product__r.Name != 'Sales Tax' AND SBQQ__RequiredBy__c != null AND SBQQ__Bundled__c != true ]){
                if(!crtlnprdcts.contains(q.SBQQ__ProductOption__c)){
                updatedcrtlns.add(q);
                system.debug('****Line 299'+updatedcrtlns);
                }else{
                crtlnprdcts.remove(q.SBQQ__ProductOption__c);
                }
                }
                if(updatedcrtlns.size()>0)
                delete updatedcrtlns;
         //using product id and required and display type field create quotelines
         
           for(SBQQ__ProductOption__c ml :[Select Id,SBQQ__OptionalSKU__c,SBQQ__ConfiguredSKU__c,SBQQ__Feature__r.Name From SBQQ__ProductOption__c  Where SBQQ__ConfiguredSKU__c IN :rqrdqutlinemap.keyset() AND  (SBQQ__Bundled__c=true OR SBQQ__Feature__r.Name ='Fees') AND SBQQ__Required__c = true ORDER BY  SBQQ__Number__c ASC] ){
           
            SBQQ__QuoteLine__c ql= new SBQQ__QuoteLine__c();
          if(ml.SBQQ__Feature__r.Name !='Fees'){
          ql.SBQQ__Quantity__c = 1;
          }else{
          ql.SBQQ__Quantity__c = 0; 
          }
          ql.SBQQ__Product__c = ml.SBQQ__OptionalSKU__c ;
          ql.SBQQ__Quote__c  = qute[0].id;
          ql.SBQQ__Bundled__c = true;
          if(rqrdqutlinemap.get(ml.SBQQ__ConfiguredSKU__c).Id!=null){
          ql.SBQQ__RequiredBy__c=rqrdqutlinemap.get(ml.SBQQ__ConfiguredSKU__c).Id;
          }else{
          ql.SBQQ__RequiredBy__c=mapnottocreatelineitems.get(ml.SBQQ__ConfiguredSKU__c);
          }
          ql.SBQQ__ProductOption__c=ml.Id;
          
          mainprdctqutlines.add(ql);
          system.debug('**********************'+ql);
          system.debug('**********************'+rqrdqutlinemap);
          }
           
            
         
           for(SBQQ__ProductOption__c m :[Select Id,SBQQ__OptionalSKU__c,SBQQ__OptionalSKU__r.Shipping_Processing__c,SBQQ__ConfiguredSKU__c From SBQQ__ProductOption__c  Where (id IN :optlineitems OR id IN :crtlnprdcts) ORDER BY  SBQQ__Number__c ASC] ){
           
            SBQQ__QuoteLine__c qln= new SBQQ__QuoteLine__c();
          qln.SBQQ__Quantity__c = 1;
          qln.SBQQ__Product__c = m.SBQQ__OptionalSKU__c ;
          qln.SBQQ__Quote__c  = qute[0].id;
          qln.Shipping_Processing__c=m.SBQQ__OptionalSKU__r.Shipping_Processing__c;

          if(rqrdqutlinemap.get(m.SBQQ__ConfiguredSKU__c)!= null){
          qln.SBQQ__RequiredBy__c=rqrdqutlinemap.get(m.SBQQ__ConfiguredSKU__c).Id;
          }else{
          qln.SBQQ__RequiredBy__c= mapgetreqirdql.get(m.SBQQ__ConfiguredSKU__c);
          }
          qln.SBQQ__ProductOption__c=m.Id;
          
          mainprdctqutlines.add(qln);
          system.debug('**********************'+qln);
          }
          if(mainprdctqutlines.size()>0) {
           if(qute[0].Tax_Time_Stamp__c != null ){
             qute[0].Tax_Time_Stamp__c=null;
             update qute;
           }
            insert mainprdctqutlines;
          } 
      
    
    
    
        }
    
        public void updateCartLines(String prodInfo, String cartId) {
         try {
           
            Map<String, Cart_Line__c> mapProductIdToCartLine = new Map<String, Cart_Line__c>();
            List<Cart_Line__c> cartLinesToUpdate = new List<Cart_Line__c>(); 
            
            
            
            //    Get all existing cart lines
            for(Cart_Line__c cartline : [Select Id, Product__c, Quantity__c From Cart_Line__c Where Cart__c =: cartId]) {
                mapProductIdToCartLine.put(cartline.Product__c, cartline);
            }
            try {
                //system.debug();
                for(String prodKey : prodInfo.split(',')) {
                    if(mapProductIdToCartLine.containsKey(prodKey.split(':')[0])) {
                        Cart_Line__c cartline = mapProductIdToCartLine.get(prodKey.split(':')[0]);
                        cartline.Quantity__c = Decimal.valueOf(prodKey.split(':')[1]);
                        
                        system.debug('quantity'+cartline.Quantity__c);
                        cartLinesToUpdate.add(cartline);
                    }
                }
                
                if(!cartLinesToUpdate.isEmpty())
                    update cartLinesToUpdate;
            }catch(Exception e) {
                
            }
            
        }catch(Exception e) {}
    } 
    

     Public PageReference editrenewalcart(){
   
         maprqrdqutlinemap= new map<string,SBQQ__QuoteLine__c >();
         mapmainlines= new List<SBQQ__QuoteLine__c>();
   // if(!Test.isRunningTest()){ 
       if(chrt.Existing_login__c==false && (qute[0].Original_Quote__c == null )){    
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        String prcbkid = pricebook2id.Pricebookid__c;   
        
        system.debug('original quote'+qute[0].id);
            //create Quote
        SBQQ__Quote__c qut = new SBQQ__Quote__c();
        qut.SBQQ__Type__c ='Renewal';
        qut.SBQQ__Status__c='Draft';
        qut.SBQQ__SalesRep__c=acnt.OwnerId;
        qut.OwnerId=acnt.OwnerId;
        if(cn.size()>0){
        qut.SBQQ__PrimaryContact__c=cn[0].id;
        }
        qut.SBQQ__Primary__c = true;
        if(qute != null)
        qut.Original_Quote__c=qute[0].id;
        qut.SBQQ__LineItemsGrouped__c =true;
        qut.SBQQ__BillingName__c=acnt.Primary_Contact_Name__c;
        qut.SBQQ__BillingStreet__c=acnt.BillingStreet;
        qut.SBQQ__BillingCity__c=acnt.BillingCity;
        qut.SBQQ__BillingState__c=acnt.BillingState;
        qut.SBQQ__BillingPostalCode__c=acnt.Billingpostalcode;
        qut.SBQQ__BillingCountry__c = acnt.BillingCountry;
        qut.SBQQ__Account__c=acnt.id;
        qut.Origin_Source__c = 'WEB';
        qut.Web_Renewal__c=true;
        qut.SBQQ__ShippingName__c=acnt.Primary_Contact_Name__c;
        if(acnt.ShippingStreet!=null && acnt.ShippingStreet!=''){
        qut.SBQQ__ShippingStreet__c=acnt.ShippingStreet;
        }else{
        qut.SBQQ__ShippingStreet__c=acnt.BillingStreet;
        }
        if(acnt.ShippingCity!=null && acnt.ShippingCity!=''){
        qut.SBQQ__ShippingCity__c=acnt.ShippingCity;
        }else{
        qut.SBQQ__ShippingCity__c=acnt.BillingCity;
        }
        if(acnt.ShippingState!=null && acnt.ShippingState!=''){
        qut.SBQQ__ShippingState__c=acnt.ShippingState;
        }else{
        qut.SBQQ__ShippingState__c=acnt.BillingState;
        }
        if(acnt.Shippingpostalcode!=null && acnt.Shippingpostalcode!=''){
        qut.SBQQ__ShippingPostalCode__c=acnt.Shippingpostalcode;
        }else{
        qut.SBQQ__ShippingPostalCode__c=acnt.Billingpostalcode;
        }
        if(acnt.ShippingCountry!=null && acnt.ShippingCountry!=''){
        qut.SBQQ__ShippingCountry__c = acnt.ShippingCountry;
        }else{
        qut.SBQQ__ShippingCountry__c = acnt.BillingCountry;
        }
        if(!Test.isRunningTest()) {
        qut.QTC__Payment_Plan__c =  ppl[0].id;
        }else{
         //insert Opportunity 
        Opportunity opp = new Opportunity();
        opp.AccountId = acnt.id;
        opp.CloseDate = System.today();
        opp.StageName = 'Validation';
        opp.Name = 'Opportunity Test';
        opp.ForecastCategoryName = 'Medium Probability';
        opp.Product__c = 'ATX';
        insert opp;
        qut.SBQQ__Opportunity2__c=opp.id;
        }
        
        qut.SBQQ__PricebookId__c =prcbkid ;
        qut.SBQQ__PriceBook__c =prcbkid ;
       
       
        insert qut;
      
        qid=qut.id;

          //Create Opportunity
          Web_Opp__c  opp =new Web_Opp__c();
        opp.Name= 'weborder'+''+datetime.now();
        opp.WebAccount__c= acnt.id;
        opp.Company_Name__c=acnt.Name;
        opp.Primary_Contact_Name__c=cn[0].Name;
        opp.Primary_Phone__c=cn[0].Phone;
        opp.Primary_Email__c=cn[0].Email;
        opp.Amount__c = chrt.Total_Price__c;
        opp.CloseDate__c = Date.today();
        opp.StageName__c = 'Negotiation';
        opp.Product_c__c ='Web-Order';
        opp.web_quote__c=qut.id;
        opp.Type__c='Renewal';
        opp.PricebookId__c=prcbkid;
        insert opp;  

        //Create quote lines
         
          mapmainlinesfrst= new List<SBQQ__QuoteLine__c>();
        optionsToUpdate = new List<SBQQ__QuoteLine__c>();
        mapoptnlineitms= new Set<String>();
        
       
      
        for(Cart_Line__c lns: [Select Id,Option_Id__c,Product__c,Quantity__c,Promo_Id__c From Cart_Line__c Where cart__r.Cart_Account__c =: acnt.id AND cart__c=:chrt.id]) {
         
                SBQQ__QuoteLine__c qutlines= new SBQQ__QuoteLine__c();
                                            qutlines.SBQQ__Quantity__c = lns.Quantity__c;
                                            qutlines.SBQQ__Product__c = lns.Product__c;
                                            qutlines.SBQQ__Quote__c  = qut.id;
                                            qutlines.SBQQ__Bundle__c=true;
                                            qutlines.Promotion__c=lns.Promo_Id__c;
                                            maprqrdqutlinemap.put(lns.Product__c,qutlines);
                                            if(lns.Option_Id__c!=null && lns.Option_Id__c!='')
                                            mapoptnlineitms.addAll(lns.Option_Id__c.split(','));
                optionsToUpdate .add(qutlines);
                
                 }
                 
         //create salestax quote line
          for(SBQQ__Quote__c sql :[Select Id From SBQQ__Quote__c  Where Id =: qut.id ] ){
                            SBQQ__QuoteLine__c salesqutln=new SBQQ__QuoteLine__c ();
                                salesqutln.SBQQ__Quantity__c = 1;
                                salesqutln.SBQQ__Product__c = pi[0].id;
                                salesqutln.SBQQ__Quote__c  = sql.id;
          
           optionsToUpdate.add(salesqutln);
           
         }
         if(optionsToUpdate.size()>0)  
         insert optionsToUpdate;
               
        }
               return null;
          
                    }
          
     public pagereference crtql() {

     
            //using product id and required and display type field create quotelines
        
         
           for(SBQQ__ProductOption__c ml :[Select Id,SBQQ__OptionalSKU__c,SBQQ__Bundled__c,SBQQ__OptionalSKU__r.Shipping_Processing__c,SBQQ__ConfiguredSKU__c,SBQQ__Feature__r.Name From SBQQ__ProductOption__c  Where ((id IN :mapoptnlineitms ) OR (SBQQ__ConfiguredSKU__c IN :maprqrdqutlinemap.keyset()  AND (SBQQ__Bundled__c = true OR SBQQ__Feature__r.Name ='Fees' ) ))ORDER BY  SBQQ__Number__c ASC] ){
           
            SBQQ__QuoteLine__c ql= new SBQQ__QuoteLine__c();
           if(ml.SBQQ__Feature__r.Name !='Fees'){
          ql.SBQQ__Quantity__c = 1;
          }else{
          ql.SBQQ__Quantity__c = 0; 
          }
          ql.SBQQ__Product__c = ml.SBQQ__OptionalSKU__c ;
          ql.Shipping_Processing__c=ml.SBQQ__OptionalSKU__r.Shipping_Processing__c;
          ql.SBQQ__Quote__c  = qid;
           if(ml.SBQQ__OptionalSKU__r.Shipping_Processing__c == False && ml.SBQQ__Bundled__c  == TRUE){ql.SBQQ__Bundled__c = true;}
          ql.SBQQ__RequiredBy__c=maprqrdqutlinemap.get(ml.SBQQ__ConfiguredSKU__c).Id;
          ql.SBQQ__ProductOption__c=ml.Id;
          
          mapmainlines.add(ql);
          system.debug('**********************'+ql);
          }
          /*
         if(mainprdctqutlines.size()>0)    
           insert mainprdctqutlines;
         
         system.debug('****sql quote id'+qute.id);
        
        
     
          
         //using product id and required and display type field create quotelines
         
           for(SBQQ__ProductOption__c ml :[Select Id,SBQQ__OptionalSKU__c,SBQQ__ConfiguredSKU__c From SBQQ__ProductOption__c  Where SBQQ__ConfiguredSKU__c IN :maprqrdqutlinemap.keyset() AND (SBQQ__Bundled__c=true OR SBQQ__Feature__r.Name ='Fees') AND SBQQ__Required__c = true ORDER BY  SBQQ__Number__c ASC] ){
           
            SBQQ__QuoteLine__c ql= new SBQQ__QuoteLine__c();
          ql.SBQQ__Quantity__c = 1;
          ql.SBQQ__Product__c = ml.SBQQ__OptionalSKU__c ;
          ql.SBQQ__Quote__c  = qid;
          ql.SBQQ__Bundled__c = true;
          ql.SBQQ__RequiredBy__c=maprqrdqutlinemap.get(ml.SBQQ__ConfiguredSKU__c).Id;
          ql.SBQQ__ProductOption__c=ml.Id;
          mapmainlines.add(ql);
          system.debug('***Line 892'+ql);
          }
         

          
         for(SBQQ__ProductOption__c m :[Select Id,SBQQ__OptionalSKU__c,SBQQ__ConfiguredSKU__c,SBQQ__OptionalSKU__r.Shipping_Processing__c From SBQQ__ProductOption__c  Where id IN :mapoptnlineitms  ORDER BY  SBQQ__Number__c ASC] ){
           
            SBQQ__QuoteLine__c ql= new SBQQ__QuoteLine__c();
          ql.SBQQ__Quantity__c = 1;
          ql.SBQQ__Product__c = m.SBQQ__OptionalSKU__c ;
          ql.Shipping_Processing__c=m.SBQQ__OptionalSKU__r.Shipping_Processing__c;
          ql.SBQQ__Quote__c  = qid;
          ql.SBQQ__RequiredBy__c=maprqrdqutlinemap.get(m.SBQQ__ConfiguredSKU__c).Id;
          ql.SBQQ__ProductOption__c=m.Id;
          //optionsToUpdate.add(ql);
           mapmainlines.add(ql);
           system.debug('***Line 875'+ql);
          }
         */
         if(mapmainlines.size()>0) 
          insert mapmainlines;
         
         chrt.Existing_login__c=true;
         update chrt;
        
        Decimal r=math.random(); 
        PageReference url = new pageReference('/apex/RenewalPaymentPage?accuntId='+chrt.id+'&r='+r);
        url.setRedirect(true);
        return url;
         
         
      } 
       
}