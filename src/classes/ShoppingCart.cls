/* Controller for  Shopping Cart 
 Handles extarction of Products,Prices and updating the cart along with promo code functinality
 */
public with sharing class ShoppingCart {
    
            Public List<schema.Product2> products {get;set;}
        
            Public List<schema.Product2> recmndprdct {get;set;}
        
            public Map<String, List<SBQQ__ProductOption__c>> featuresWithOptions {get;set;}
        
            public Map<String, Decimal> unitprice {get;set;}
            
            public set<String> prductpageids {get;set;}
            
            public String priceJSON{get;set;}
        
            public String urlprdct{get;set;}
            
            public String urlprdct2{get;set;}
        
            public String urlprdct3{get;set;}
            
            public Decimal nonswitchlines{get;set;}
            
            public Decimal switchlines{get;set;}
            
            public string prmtn{get;set;}
        
            public string snglprmtn{get;set;}
        
            public Set<String> crtlnprdcts{get;set;}
            
            public cart__c chrt{get;set;}
            
            public List<Cart_Line__c> crtln{get;set;}
            
            public Map<String, List<string>> productToSelectedOptionsMap {get;set;}
             
            public Map<Id, Product2> productMap {get;set;}
             
            public Map<String, Boolean> hasFeatures {get;set;}
        
            public SBQQ__Quote__c  qute{get;set;}
            
            public Boolean cupnscess{get;set;}
            
            public List<SBQQ__QuoteLine__c> mainprdctqutlines{get;set;}
            
            public List<SBQQ__QuoteLine__c>  quteline{get;set;}
        
            public Map<String, Map<String, List<SBQQ__ProductOption__c>>> productFeatures {get;set;}
            
            public Map<string,string> mapgetreqirdql {get;set;}
            
            public Map<string,Decimal> mapdiscuntdprice{get;set;}
            
            public Map<string,Boolean> mapfreeprice{get;set;}
            
            public Map<string,string> mapnottocreatelineitems{get;set;}
        
            public Map<string,SBQQ__QuoteLine__c> rqrdqutlinemap{get;set;}
            
            public String mapProductIdToQuantityJSON {get;set;}
            
            public string coupon{get;set;}
            
            Public List<Product2> pi{get;set;}
            
            public Boolean hasprdcts{get;set;}
            
            public Boolean hasflashsale{get;set;}
            
            public Set<String> cartedProducts{get;set;}
            
            public Map<String, String> selectedOptionsMap {get;set;}
            
            private Map<Id, SBQQ__ProductOption__c> options;
            
            public Set<String> optlineitems{get;set;}
    

  Public ShoppingCart  (ApexPages.StandardController controller) {
    
        //Id productId = controller.getId();
        selectedOptionsMap = new Map<String, String>();
        products = new List<schema.Product2>();
        mapdiscuntdprice=new Map<string,Decimal>();
        mapfreeprice=new Map<string,Boolean>();
        cartedProducts = new Set<String>();
        Map<String, Decimal> mapProductIdToQuantity = new Map<String, Decimal>();
         productToSelectedOptionsMap = new Map<String, List<string>>();
        mapProductIdToQuantityJSON = '';
        unitprice = new Map<String, Decimal>();
         urlprdct='';
         urlprdct2='';
         urlprdct3='';
         prmtn='';
         snglprmtn='';
         nonswitchlines=0;
         switchlines=0;
         
         hasflashsale=false;
        Cookie cartCookie = ApexPages.currentPage().getCookies().get('cartId');
        urlprdct = ApexPages.currentPage().getParameters().get('pdrct');
        urlprdct2 = ApexPages.currentPage().getParameters().get('pdrct2');
        urlprdct3 = ApexPages.currentPage().getParameters().get('pdrct3');
        prmtn= ApexPages.currentPage().getParameters().get('Promo');
        snglprmtn= ApexPages.currentPage().getParameters().get('Promotn');
        String cupnstatus= ApexPages.currentPage().getParameters().get( 'coupon'); 
        hasprdcts =true;
        cupnscess=false;
        
          try {
        chrt =[select id,Cart_Account__c,Promo_Id__c,Promo_Value__c,Originate_URL__c,Switch_Promo__c ,Total_Price__c,Is_Flashsale__c From cart__c Where id =: cartCookie.getvalue()];
        crtln=[select id,Product__c,Discounted_Price__c,Product_Family__c,Promo_Value__c,Is_Flashsale__c From Cart_Line__c  Where cart__c =:chrt.id ];
        
        
          for(Cart_Line__c  cl:crtln){
          if(cl.Discounted_Price__c!=null){
          mapdiscuntdprice.put(cl.Product__c,cl.Discounted_Price__c );
          }else{
          mapdiscuntdprice.put(cl.Product__c,0 );
          }
          
          if(cl.Is_Flashsale__c==TRUE){
          mapfreeprice.put(cl.Product__c,TRUE );
          switchlines=+1;
          }else{
          mapfreeprice.put(cl.Product__c,FALSE);
          nonswitchlines=+1;
          }
          
          system.debug('Map 78'+mapfreeprice);
          }
          
               
           if(cupnstatus !=null && cupnstatus!=''){
              cupnscess=true;
                 }  
                 
                 
          for(Cart_Line__c cln:crtln){
          if(!mapdiscuntdprice.containskey(cln.Product__c)){
          mapdiscuntdprice.put(cln.Product__c,0 );
          system.debug('cln line  75'+cln);
          }
          if(!mapfreeprice.containskey(cln.Product__c)){
          mapfreeprice.put(cln.Product__c,FALSE);
          nonswitchlines=+1;
          system.debug('cln line  75'+cln);
          }
          }
          system.debug('cartid'+cartCookie.getvalue());
        qute =[select Id,Net_Minus_Tax_Fees__c,Tax__c,SBQQ__NetAmount__c,SBQQ__PricebookId__c,Processing_Fees__c,SBQQ__Primary__c,Tax_Time_Stamp__c,Tax_Grand_Total__c,SBQQ__Account__c,SBQQ__CustomerAmount__c,
                      SBQQ__TotalCustomerDiscountAmount__c from SBQQ__Quote__c where SBQQ__Account__c =: chrt.Cart_Account__c AND      
                      SBQQ__Primary__c =true  order by CreatedDate desc Limit 1];
         
         pi=[Select Id,Name From Product2 Where Name='Sales Tax' AND IsActive= true Limit 1 ];
                      
        mapgetreqirdql= new map<string,string>();         
        quteline =[select Id,SBQQ__Bundle__c,SBQQ__RequiredBy__c,SBQQ__Product__c,SBQQ__ProductOption__c,SBQQ__ListPrice__c,SBQQ__Product__r.List_Price__c,SBQQ__NetPrice__c,
                          SBQQ__CustomerTotal__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,SBQQ__ListTotal__c,
                          SBQQ__Quantity__c  From SBQQ__QuoteLine__c  Where SBQQ__Quote__c = :qute.Id AND SBQQ__Product__c != null AND 
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
        products = [Select Id, Name, Description,Marketing_Name__c,Family ,Detail_description__c,RegCode_Required__c,Type__c,Pipeline_Designation__c From Product2 Where Id IN : cartedProducts];
       if(products.size()==0){
       
       hasprdcts =false;
       
       }
        //recommended products
        Set<String> upsellprdct = new Set<string>();
        /*
        upsellprdct.add('CSIFIRMPLSTD5GBNONSB_2016');//CCH  iFirm Practice Manager 1-3 Users
        upsellprdct.add('TAXBOOKDELUXE_2016');//Health Care Reform Library
        upsellprdct.add('TPPSTDBUND_2016');// Tax Prep Partner Standard Bundle
        
        recmndprdct = [Select Id, Name, Description,Marketing_Name__c,Family From Product2 Where ProductCode IN: upsellprdct]; 
         */
        // Get Fetaures and their options
        featuresWithOptions = new Map<String, List<SBQQ__ProductOption__c>>();
        productFeatures = new Map<String, Map<String, List<SBQQ__ProductOption__c>>>();
        Set<Id> optionProductIds = new Set<Id>();
        options = new Map<Id, SBQQ__ProductOption__c>([Select Id,Name,SBQQ__Feature__r.Name, Display_Type__c,SBQQ__UnitPrice__c, SBQQ__Number__c,SBQQ__ConfiguredSKU__c,Feature_Name__c, SBQQ__Type__c, SBQQ__ProductCode__c, 
                                                                                           SBQQ__OptionalSKU__r.Marketing_Name__c,SBQQ__OptionalSKU__r.Name,SBQQ__ProductName__c,SBQQ__Selected__c, SBQQ__ProductDescription__c, SBQQ__OptionalSKU__c,SBQQ__Required__c, SBQQ__Bundled__c   
                                                                                         From SBQQ__ProductOption__c 
                                                                                         Where SBQQ__ConfiguredSKU__c IN : cartedProducts AND Feature_Name__c!='Recommended Products'  AND Feature_Name__c!='Fees' AND
                                                                                               SBQQ__Feature__c != null AND SBQQ__ProductCode__c !='TWDVDFEE_2017' AND SBQQ__ProductCode__c !='ATX-DVDFEE_2017' AND SBQQ__OptionalSKU__r.SBQQ__Hidden__c =False
                                                                                         ORDER BY SBQQ__Feature__r.SBQQ__Number__c, SBQQ__Number__c ASC]);
        for(SBQQ__ProductOption__c option : options.values()) {
        if(option.Feature_Name__c!='Fees' || (option.SBQQ__UnitPrice__c==null && option.Feature_Name__c=='Fees') ){
           optionProductIds.add(option.SBQQ__OptionalSKU__c);
           }else{
           if(option.SBQQ__UnitPrice__c!=null)
           unitprice.put(option.SBQQ__OptionalSKU__c, option.SBQQ__UnitPrice__c);
           }
                         system.debug('line 108'+option);
            if(!productFeatures.containsKey(option.SBQQ__ConfiguredSKU__c) && option.SBQQ__Bundled__c !=TRUE &&  option.Feature_Name__c!='Training') {
                productFeatures.put(option.SBQQ__ConfiguredSKU__c, new Map<String, List<SBQQ__ProductOption__c>>{option.SBQQ__Feature__r.Name => new List<SBQQ__ProductOption__c>{option}});
                
            }
            else if(option !=null &&  option.Feature_Name__c!='Training') {
                featuresWithOptions = productFeatures.get(option.SBQQ__ConfiguredSKU__c);
                system.debug('******'+featuresWithOptions );
                if(featuresWithOptions!=null){
                if(!featuresWithOptions.containsKey(option.SBQQ__Feature__r.Name) && option.SBQQ__Bundled__c !=TRUE)
                    featuresWithOptions.put(option.SBQQ__Feature__r.Name, new List<SBQQ__ProductOption__c>{option});
                else if( option.SBQQ__Bundled__c !=TRUE) 
                    featuresWithOptions.get(option.SBQQ__Feature__r.Name).add(option);
                    }
                if(option.SBQQ__Bundled__c !=TRUE &&  option.Feature_Name__c!='Training')
                productFeatures.put(option.SBQQ__ConfiguredSKU__c, featuresWithOptions);
            }
            
            if(option.SBQQ__Bundled__c ==TRUE || option.Feature_Name__c=='Training'){

            
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
        
        
        for(PricebookEntry price : [SELECT Id, Name, UnitPrice, Product2Id FROM PricebookEntry WHERE (Product2Id IN :cartedProducts OR Product2Id IN : optionProductIds OR Product2.ProductCode  IN :upsellprdct) AND Pricebook2Id =:prcbkid]){
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
    
  
  // Method used on load to store Product code and populating its deatils on Cart

  public PageReference  urltosaveprdct(){
    
      
              string y = ApexPages.currentPage().getParameters().get('returnurl');
              
              system.debug('**url '+urlprdct);
              if(y!=null && y!=''&& Chrt!=null){

               chrt.Originate_URL__c=y;
               update chrt;
              }

              if(urlprdct!= null && urlprdct!='' ){
              try{
              Cookie rencrt = ApexPages.currentPage().getCookies().get('rcid');
              if(rencrt!=null ){
              PageReference prl = new pageReference('/apex/RenewalCart?pdrct='+urlprdct);
               prl.setRedirect(true);
               return prl;
              
              }
              }catch(Exception e){}

               CreateCart cc = new CreateCart(); 
               Product2 prcdts = [Select Id, Name, Description,Marketing_Name__c From Product2 Where ProductCode = : urlprdct AND IsActive =True];
               
               try {
               if(prmtn!= null && prmtn!='' ){
               if(nonswitchlines >0 && switchlines ==0){
               cc.Line(prcdts.id,chrt.id,y,prmtn);
               }else{
               
               cc.Line(prcdts.id,null,y,prmtn);
                
               }
               }else if(snglprmtn !=null && snglprmtn !=''){
               cc.Line(prcdts.id,chrt.id,null,snglprmtn);
               }else {
               cc.Line(prcdts.id,chrt.id,null,null);
               }
               }catch(Exception e){
               if(prmtn!= null && prmtn!='' ){
               cc.Line(prcdts.id,null,y,prmtn);
               }else if(snglprmtn !=null && snglprmtn !=''){
               cc.Line(prcdts.id,null,y,snglprmtn);
               }else{
               cc.Line(prcdts.id,null,y,null);
               }
               }
               
               if((urlprdct2!= null && urlprdct2!='')){
               Cookie secndprdct= ApexPages.currentPage().getCookies().get('cartId');
               List<cart__c>  scndcrt =[select id,Cart_Account__c,Promo_Id__c,Promo_Value__c,Originate_URL__c,Total_Price__c,Is_Flashsale__c From cart__c Where id =: secndprdct.getvalue()];
               if(scndcrt.size()>0 && (prmtn!=null && prmtn!='')){
               scndcrt[0].Is_Flashsale__c =TRUE;
               update scndcrt[0];
               }
               
               CreateCart cc1 = new CreateCart(); 
               Product2 prcdts2 = [Select Id, Name, Description,Marketing_Name__c From Product2 Where ProductCode = : urlprdct2 AND IsActive =True];
               try {
               if(prmtn!= null && prmtn!='' ){
               cc1.Line(prcdts2.id,scndcrt[0].id,null,prmtn);
               }else{
               cc1.Line(prcdts2.id,scndcrt[0].id,null,null);
               }
               }catch(Exception e){
               if(prmtn!= null && prmtn!='' ){
               cc1.Line(prcdts2.id,null,y,prmtn);
               }else{
               cc1.Line(prcdts2.id,null,y,null);
               }
               }
               
                if((urlprdct3!= null && urlprdct3!='')){
               CreateCart cc2 = new CreateCart(); 
               Product2 prcdts3 = [Select Id, Name, Description,Marketing_Name__c From Product2 Where ProductCode = : urlprdct3 AND IsActive =True];
               try {
               if(prmtn!= null && prmtn!='' ){
               cc1.Line(prcdts3.id,scndcrt[0].id,null,prmtn);
               }else{
               cc1.Line(prcdts3.id,scndcrt[0].id,null,null);
               }
               }catch(Exception e){
               if(prmtn!= null && prmtn!='' ){
               cc1.Line(prcdts3.id,null,y,prmtn);
               }else{
               cc1.Line(prcdts3.id,null,y,null);
               }
               }
               }

               }

               PageReference prl = new pageReference('/apex/ShoppingCart');
               prl.setRedirect(true);
               return prl;
               }
               return null;
    }

  
  //Method on Checkout of Cart to Store all changes and proceed to next step
   public PageReference onCheckout() {

              Cookie cartCookie = ApexPages.currentPage().getCookies().get('cartId');
              String prodInfo = ApexPages.currentPage().getParameters().get('prodInfo');
              String  oppPrice = ApexPages.currentPage().getParameters().get('totalprice');
              String selopid = ApexPages.currentPage().getParameters().get('selectedoptions');
              String featuresPrice = ApexPages.currentPage().getParameters().get('featuresPrice');
              featuresPrice = featuresPrice.removeEnd(',');
              prodInfo = prodInfo.removeEnd(',');
              
              system.debug('***158'+oppPrice );
              if(oppPrice != null){
                  cart__c crt =[select id,Cart_Account__c,Total_Price__c From cart__c Where id =: cartCookie.getvalue()];
                  crt.Total_Price__c = decimal.valueOf(oppPrice);
                  update crt;
              }
              
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
                    for(Cart_Line__c crtln:[select id,Option_Id__c,Product__c From Cart_Line__c Where cart__c =: cartCookie.getvalue() AND Product__c IN : mapproductidtoselectedoptions.keyset()]){
                        crtln.Option_Id__c = mapproductidtoselectedoptions.get(crtln.Product__c );
                        crtlntoupdate.add(crtln);
                    }
                    if(crtlntoupdate.size()>0)
                        update crtlntoupdate;
              }

           updateCartLines(prodInfo, cartCookie.getValue());
           if(chrt.Cart_Account__c ==null){
                
                  PageReference pageRef = new PageReference(+Label.UMMS_Login+'SFDCCartID='+chrt.id+'&SFDCReturnURL='+Label.Ecom_Link1+'sales/Paymentconfirmationpage');
                  return pageRef ;
           }else{
               createqutlins();
               return null;
           }
   }
    

  public void onKeepshopping() {

        Cookie cartCookie = ApexPages.currentPage().getCookies().get('cartId');
        String prodInfo = ApexPages.currentPage().getParameters().get('prodQua');
        String  oppPrice = ApexPages.currentPage().getParameters().get('totalprice');
        String selopid = ApexPages.currentPage().getParameters().get('selectedoptions');
        String featuresPrice = ApexPages.currentPage().getParameters().get('featuresPrice');
        featuresPrice = featuresPrice.removeEnd(',');
        
        prodInfo = prodInfo.removeEnd(',');
        
        //  Prepares a map of ProductId and it's feature price
        Map<String, Decimal> featurePriceMap = new map<String, Decimal>();
        for(String s : featuresPrice.split(',')) {
            try {
                featurePriceMap.put(s.split(':')[0], Decimal.valueOf(s.split(':')[1]));
            }catch(Exception e) {
                featurePriceMap.put(s.split(':')[0], 0);
            }
        }
        
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
                  crtln.Feature_Price__c = featurePriceMap.get(crtln.Product__c);
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
 
    
  public pageReference removeProduct(){
    
        string removePrdct = ApexPages.currentPage().getParameters().get('removePrdct');
        system.debug('remove product is  '+removePrdct);
        
        Cookie cartCookie = ApexPages.currentPage().getCookies().get('cartId');
        string ctid = cartCookie.getValue();
        set<String> rmvprdcts = new set<String>();
        
        try {
            if(removePrdct != null){
            
            Cart_Line__c  cltodelete = [Select Id,Is_Flashsale__c  From Cart_Line__c Where Cart__c =: ctid AND Product__c =: removePrdct];
            
            if(cltodelete.Is_Flashsale__c  == TRUE){
            
            List<Cart_Line__c> ctln= [Select Id,Product__r.id  From Cart_Line__c Where Cart__c =: ctid AND Is_Flashsale__c = TRUE];
            
            if(ctln.size()>0){
            for(Cart_Line__c cn :ctln){
            
            rmvprdcts.add(cn.Product__r.id);
            
            }
            }
            if(ctln.size()>0)
            delete ctln;
            
            }else{
                delete [Select Id From Cart_Line__c Where Cart__c =: ctid AND Product__c =: removePrdct];
            }
                
                if(qute !=null && (cltodelete.Is_Flashsale__c  == False)){
                
                 qute.Tax_Time_Stamp__c=null;
                 update qute;
                SBQQ__QuoteLine__c todelete= [Select Id From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: qute.id AND SBQQ__Product__c  =: removePrdct];
                system.debug('remove product is  ' +todelete);
                delete [Select Id From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: qute.id AND SBQQ__RequiredBy__c =:todelete.id ];
                delete todelete;
                 
                }else if(qute !=null && cltodelete.Is_Flashsale__c ==TRUE){
                
                set<String> qltodelete = new set<String>();
                qute.Tax_Time_Stamp__c=null;
                 update qute;
                List<SBQQ__QuoteLine__c> todelete= [Select Id From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: qute.id AND SBQQ__Product__c  =: rmvprdcts];
                
                for(SBQQ__QuoteLine__c qln : todelete){
            
                qltodelete.add(qln.id);
            
                }
                system.debug('remove product is  ' +todelete);
                delete [Select Id From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: qute.id AND SBQQ__RequiredBy__c IN:qltodelete ];
                delete todelete;
                
                
                }
             }   
            PageReference pr = new pageReference('/apex/ShoppingCart');
            pr.setRedirect(true);
            return pr;
        }catch(Exception e) {
            return null;
        }
  }
    

  public Pagereference salestx(){
         
         String Tax;
         system.debug('values sales'+qute.SBQQ__NetAmount__c +qute.Tax_Grand_Total__c);
         if(qute.SBQQ__NetAmount__c != qute.Tax_Grand_Total__c || qute.Tax_Time_Stamp__c == null || qute.Tax_Grand_Total__c == null || qute.Tax_Time_Stamp__c.addHours(24) < system.now()){
          try{
          Tax= IIT_SpeedTaxConnector.calculateTaxForQuote(qute.id);
          }catch(Exception e){
          
          
          }
          }
          system.debug('tax values'+Tax);
          
           SBQQ__QuoteLine__c slql= [SELECT Id,Name,SBQQ__Quote__c,SBQQ__CustomerPrice__c,SBQQ__Quote__r.SBQQ__NetAmount__c,SBQQ__Product__r.Name FROM SBQQ__QuoteLine__c Where SBQQ__Product__r.Name = 'Sales Tax' AND SBQQ__Quote__c= :qute.Id ];
           
           
           
           qute.Tax_Time_Stamp__c=System.now();
           qute.Tax_Grand_Total__c=slql.SBQQ__Quote__r.SBQQ__NetAmount__c;
           qute.Tax__c=slql.SBQQ__CustomerPrice__c;
           update qute;
          
          
          Decimal r=math.random(); 
          PageReference url = new pageReference('/apex/PaymentConfirmationPage?accuntId='+chrt.id+'&r='+r);
          url.setRedirect(true);
          return url;
  }
        
  public pageReference emptyCart(){
       
          try {
          Cookie cartCookie = ApexPages.currentPage().getCookies().get('cartId');
          string ctid = cartCookie.getValue();
         
          if(ctid != null){
              delete [Select Id, Product__c, Quantity__c,cart__r.Total_Price__c From Cart_Line__c Where cart__c = :ctid ];
              cart__c delitem =[Select Id,Total_Price__c From cart__c Where id= :ctid ];
              delitem.Total_Price__c = null;
              update delitem;
          if(qute !=null){
             qute.Tax_Time_Stamp__c=null;
             update qute;
             delete [Select Id From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: qute.id AND SBQQ__Product__r.Name != 'Sales Tax'];
            
          }    
           
          }
              PageReference pr = new pageReference('/apex/ShoppingCart');
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
         Cookie prodCookie = ApexPages.currentPage().getCookies().get('cartId');
           String prodid = ApexPages.currentPage().getParameters().get('rcmprdct');
           String prodInfo = ApexPages.currentPage().getParameters().get('prodInfo');
           String selopid = ApexPages.currentPage().getParameters().get('selectedoptions'); 
         if((coupon==null || coupon =='') && !Test.isRunningTest()){
          VFUtil.AddErrorMessage ( 'Please enter a valid coupon.');
                  return null;
         }
         
         List<Promotion_Entry__c> cp =[Select Id,Active__c,Product__c,Price__c,Promo_Value__c,Promo_Code__c From Promotion_Entry__c where Promo_Code__c =:coupon 
                                              AND Active__c =true AND Web_Active__c = TRUE AND Product__c IN :cartedProducts  AND Promo_Code__c !=null  ];
         
          if(cp.size()==0 && !test.isrunningtest()){
          VFUtil.AddErrorMessage ( 'Coupon Not Valid.');
          return null;
         }
         if(cp.size()>0 && chrt.Promo_Id__c!=null && !test.isrunningtest()){
         chrt.Promo_Id__c=cp[0].Promo_Code__c ;
         update chrt;
         }else if(cp.size()>0 && chrt.Promo_Id__c==null){
         chrt.Promo_Id__c=cp[0].Promo_Code__c ;
         update chrt;
         }
         
         for(Promotion_Entry__c c :cp){
         
         mapcoupnentry.put(c.Product__c,c);
         system.debug('Mapcouponentry'+mapcoupnentry);
         if(c.Promo_Value__c !=null ){
         Mappromovalue.put(c.Product__c,c.Promo_Value__c);
         }else{
         Mappromovalue.put(c.Product__c,0);
         }
         }
         
         for(Cart_Line__c c:[Select Id,Promo_Value__c,Promo_Id__c,Discounted_Price__c,Product__c,Cart__r.Promo_Id__c From Cart_Line__c  where Cart__c=:chrt.id]){
          if(!mapcoupnentry.containskey(c.Product__c)){
          mapcoupnentry.put(c.Product__c,new Promotion_Entry__c() );
          }
         c.Promo_Id__c=mapcoupnentry.get(c.Product__c).Id;
         c.Promo_Value__c=Mappromovalue.get(c.Product__c);
         c.Discounted_Price__c=mapcoupnentry.get(c.Product__c).Price__c;
         Promotocartline.add(c);
         }
         
         if(Promotocartline.size()>0)
         update Promotocartline;

         if(mapcoupnentry != null && qute != null){
         for(SBQQ__QuoteLine__c q :[select id,Promotion__c,SBQQ__Product__c  From SBQQ__QuoteLine__c where SBQQ__Product__c =:mapcoupnentry.keyset() AND SBQQ__Quote__c =:qute.id]){
         
         q.Promotion__c =mapcoupnentry.get(q.SBQQ__Product__c ).Id;
         
         coupontoadd.add(q);
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
                    for(Cart_Line__c crtln:[select id,Option_Id__c,Product__c From Cart_Line__c Where cart__c =: prodCookie.getvalue() AND Product__c IN : mapproductidtoselectedoptions.keyset()]){
                        crtln.Option_Id__c = mapproductidtoselectedoptions.get(crtln.Product__c );
                       
                        crtlntoupdate.add(crtln);
                    }
                    if(crtlntoupdate.size()>0)
                        update crtlntoupdate;
              }

           updateCartLines(prodInfo, prodCookie.getValue());
           
         PageReference pr = new pageReference('/apex/ShoppingCart?coupon='+'success');
                  pr.setRedirect(true);
                  return pr;
         
         
   }


  public pagereference createqutlins(){
    

        //Create quote lines
        mainprdctqutlines= new List<SBQQ__QuoteLine__c>();
        List<SBQQ__QuoteLine__c> qtnupdate= new List<SBQQ__QuoteLine__c>();
        crtlnprdcts= new Set<String>(); 
        mapnottocreatelineitems= new map<string,string>();
        List<SBQQ__QuoteLine__c> optionsToUpdate = new List<SBQQ__QuoteLine__c>();
        optlineitems= new Set<String>();
        Map<string,Decimal> mapprdctqnt= new map<string,Decimal>();
        rqrdqutlinemap= new map<string,SBQQ__QuoteLine__c>(); 
       
            system.debug('***line 275 '+quteline);  
        
         
          for(SBQQ__QuoteLine__c q: quteline ){
            mapnottocreatelineitems.put(q.SBQQ__Product__c,q.id);
          }
               
         //create main quote lines if we did not do yet.        
        for(Cart_Line__c lns: [Select Id,Option_Id__c,Product__c,Quantity__c,Promo_Id__c From Cart_Line__c Where cart__r.Cart_Account__c =: chrt.Cart_Account__c AND cart__c=:chrt.id]) {
          if(lns.Option_Id__c!=null && lns.Option_Id__c!='')
            crtlnprdcts.addAll(lns.Option_Id__c.split(','));
            mapprdctqnt.put(lns.Product__c,lns.Quantity__c);
            system.debug('crtlns'+mapprdctqnt);
              if( !mapnottocreatelineitems.containsKey(lns.Product__c)){
                SBQQ__QuoteLine__c qutlines= new SBQQ__QuoteLine__c(SBQQ__Quantity__c = lns.Quantity__c, 
                                                                    SBQQ__Product__c = lns.Product__c, 
                                                                    Promotion__c=lns.Promo_Id__c,
                                                                    SBQQ__Quote__c  = qute.id
                                                                    );
                if(lns.Option_Id__c!=null && lns.Option_Id__c!='')
                  optlineitems.addAll(lns.Option_Id__c.split(','));
                rqrdqutlinemap.put(lns.Product__c,qutlines);
                optionsToUpdate.add(qutlines);
                
                 }
            }       
               system.debug('**********************'+optionsToUpdate);
               if(optionsToUpdate.size()>0){    
                 insert optionsToUpdate;
                 }
                 
                 //if Quantity has changed on product upate on QL
                 for(SBQQ__QuoteLine__c q: quteline ){
                 if(q.SBQQ__Quantity__c!=mapprdctqnt.get(q.SBQQ__Product__c)){
                 q.SBQQ__Quantity__c=mapprdctqnt.get(q.SBQQ__Product__c);
                 qtnupdate.add(q);
                 }   
                 }
                 
                 if(qtnupdate.size()>0){    
                 update qtnupdate;
                 }
                 
                 if(qtnupdate.size()>0 || optionsToUpdate.size()>0 ){
                 qute.Tax_Time_Stamp__c = null;
                 update qute;
                 }
                 
                //get any changed options to create quote lines below
                List<SBQQ__QuoteLine__c> updatedcrtlns= new List<SBQQ__QuoteLine__c>();
                for(SBQQ__QuoteLine__c q: [Select Id,SBQQ__Quote__c,SBQQ__ProductOption__c,SBQQ__Product__c From  SBQQ__QuoteLine__c Where SBQQ__Quote__c  =: qute.id AND SBQQ__Product__r.Name != 'Sales Tax' AND SBQQ__RequiredBy__c != null AND SBQQ__Bundled__c != true ]){
                if(!crtlnprdcts.contains(q.SBQQ__ProductOption__c)){
                updatedcrtlns.add(q);
                system.debug('****Line 299'+updatedcrtlns);
                }else{
                crtlnprdcts.remove(q.SBQQ__ProductOption__c);
                }
                }
                if(updatedcrtlns.size()>0)
                delete updatedcrtlns;
            return null;
          }

  /*
    public pageReference addrcmndprdct(){
     
           //check existed cookie
           Cookie prodCookie = ApexPages.currentPage().getCookies().get('cartId');
           String prodid = ApexPages.currentPage().getParameters().get('rcmprdct');
           String prodInfo = ApexPages.currentPage().getParameters().get('prodInfo');
           String selopid = ApexPages.currentPage().getParameters().get('selectedoptions'); 
           prodInfo = prodInfo.removeEnd(',');  
             

              CreateCart cc = new CreateCart();
              if(prodCookie == null)
                  cc.Line(prodid, null,null,null);
              else
                  cc.Line(prodid, prodCookie.getvalue(),null,null);
                  
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
                    for(Cart_Line__c crtln:[select id,Option_Id__c,Product__c From Cart_Line__c Where cart__c =: prodCookie.getvalue() AND Product__c IN : mapproductidtoselectedoptions.keyset()]){
                        crtln.Option_Id__c = mapproductidtoselectedoptions.get(crtln.Product__c );
                       
                        crtlntoupdate.add(crtln);
                    }
                    if(crtlntoupdate.size()>0)
                        update crtlntoupdate;
              }

           updateCartLines(prodInfo, prodCookie.getValue());

          PageReference pr = new pageReference('/apex/ShoppingCart');
          pr.setRedirect(true);
          return pr;

  }
  */
  
  Public pagereference createql(){

         //using product id and required and display type field create quotelines
         
           for(SBQQ__ProductOption__c ml :[Select Id,SBQQ__OptionalSKU__c,SBQQ__ConfiguredSKU__c,SBQQ__Feature__r.Name From SBQQ__ProductOption__c  Where SBQQ__ConfiguredSKU__c IN :rqrdqutlinemap.keyset() AND  (SBQQ__Bundled__c=true OR SBQQ__Feature__r.Name ='Fees') AND SBQQ__Required__c = true ORDER BY  SBQQ__Number__c ASC] ){
           
              SBQQ__QuoteLine__c ql= new SBQQ__QuoteLine__c(SBQQ__Quantity__c = 1, 
                                                            SBQQ__Product__c = ml.SBQQ__OptionalSKU__c, 
                                                            SBQQ__Quote__c  = qute.id, 
                                                            SBQQ__Bundled__c = true, 
                                                            SBQQ__RequiredBy__c=rqrdqutlinemap.get(ml.SBQQ__ConfiguredSKU__c).Id, 
                                                            SBQQ__ProductOption__c=ml.Id);
                                                            
             if(ml.SBQQ__Feature__r.Name =='Fees'){
              ql.SBQQ__Quantity__c=0;
             }
            mainprdctqutlines.add(ql);
            system.debug('**********************'+ql);
            system.debug('**********************'+rqrdqutlinemap);
          }
           
            
         
          for(SBQQ__ProductOption__c m :[Select Id,SBQQ__OptionalSKU__c,SBQQ__ConfiguredSKU__c,SBQQ__OptionalSKU__r.Shipping_Processing__c From SBQQ__ProductOption__c  Where (id IN :optlineitems OR id IN :crtlnprdcts) ORDER BY  SBQQ__Number__c ASC] ){
           
            SBQQ__QuoteLine__c qln= new SBQQ__QuoteLine__c(SBQQ__Quantity__c = 1, 
                                                            SBQQ__Product__c = m.SBQQ__OptionalSKU__c, 
                                                            SBQQ__Quote__c  = qute.id, 
                                                            Shipping_Processing__c=m.SBQQ__OptionalSKU__r.Shipping_Processing__c,
                                                            SBQQ__ProductOption__c = m.Id, 
                                                            SBQQ__RequiredBy__c = (rqrdqutlinemap.get(m.SBQQ__ConfiguredSKU__c)!= null ? rqrdqutlinemap.get(m.SBQQ__ConfiguredSKU__c).Id : mapnottocreatelineitems.get(m.SBQQ__ConfiguredSKU__c)));
            mainprdctqutlines.add(qln);
            system.debug('line 570'+mainprdctqutlines);
          }
          if(mainprdctqutlines.size()>0) {
           if(qute.Tax_Time_Stamp__c != null ){
             qute.Tax_Time_Stamp__c=null;
             update qute;
           }
            insert mainprdctqutlines;
          } 

    
           return null;
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
          
       
}