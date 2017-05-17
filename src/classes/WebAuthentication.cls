@RestResource(urlMapping='/getcinfo/*')

global  with sharing class WebAuthentication{
 
 @HttpPost
 webService static String CID(String CID,String CrtId,String CustomerType) {
  Decimal total;
  Account accs;
  List<Contact>  cn;
  String prcbkid;
  String prcbkid1;
  List<SBQQ__Quote__c >  rnwqut;
  List<SBQQ__QuoteLine__c> quteline;
  Boolean haspromo;
  cart__c ct;
  List<Promotion_Entry__c> pe;
  List<Zip_Code__c> zp ;
  
   try{ 
       system.debug('info here'+CID +CrtId);
       
       Pricebook__c pricebook2id1 = Pricebook__c.getInstance('Pricebook2016'); 
        prcbkid1 = pricebook2id1.Pricebookid__c;  
        
           accs = [Select Id,Name,Contact__c,Contact__r.id,Primary_Contact_Name__c,BillingStreet,BillingCity,BillingState,Billingpostalcode,
                          BillingCountry,ShippingStreet,ShippingCity,ShippingState,Shippingpostalcode,ShippingCountry From Account Where CID__c =: CID]; 
               try{             
            cn=[Select Id,Name,AccountID,Is_Primary__c,Abandoned_User_Renewal__c,Abandoned_User_New__c,Phone,Email From Contact Where Is_Primary__c =true AND AccountID=:accs.id order by CreatedDate desc Limit 1 ];
            
            rnwqut=[select Id,Net_Minus_Tax_Fees__c,Tax_Calculated__c,Tax__c,Original_Quote__c,Tax_Time_Stamp__c,Processing_Fees__c,SBQQ__Primary__c,SBQQ__Account__c,SBQQ__CustomerAmount__c,
                              SBQQ__BillingName__c,SBQQ__BillingStreet__c,SBQQ__BillingCity__c,SBQQ__BillingState__c,SBQQ__BillingPostalCode__c,SBQQ__BillingCountry__c, 
                              SBQQ__ShippingName__c,SBQQ__ShippingStreet__c,SBQQ__ShippingCity__c,SBQQ__ShippingState__c,SBQQ__ShippingPostalCode__c,SBQQ__ShippingCountry__c, 
                              SBQQ__TotalCustomerDiscountAmount__c from SBQQ__Quote__c where SBQQ__Account__c =: accs.id AND Web_Renewal__c=true AND SBQQ__Primary__c =true  AND SBQQ__Status__c !='Invoiced' AND Account_Type__c !='Renewed customer'
                              AND SBQQ__PriceBook__c =:prcbkid1   order by CreatedDate desc Limit 1];
                              
                              
            if(rnwqut.size()>0 || (Test.isRunningTest()) ){
            
            
       quteline =[select Id,SBQQ__Bundle__c,SBQQ__RequiredBy__c,SBQQ__ListPrice__c,SBQQ__Product__r.List_Price__c,Promotion__c,Promotion__r.id,Promotion__r.Promo_Value__c,Promotion__r.Price__c,
                         SBQQ__NetPrice__c,SBQQ__CustomerTotal__c,SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,
                         SBQQ__ListTotal__c,SBQQ__Quantity__c  From SBQQ__QuoteLine__c  Where SBQQ__Quote__c = :rnwqut[0].id AND SBQQ__Product__c != null AND SBQQ__Product__r.Shipping_Processing__c=false
                         AND SBQQ__Product__r.Name != 'Sales Tax' AND SBQQ__RequiredBy__c = null order by SBQQ__Number__c ];
           
            
            
            
            }                  
                              
                              
            }catch(Exception e){}
            
          
          
            system.debug('contact here is'+accs.Contact__c);
             //check existed cookie
         if( CrtId !=null && CrtId!='')  {       
         cart__c cart =[select id,Total_Price__c,cart_Account__c,Is_Flashsale__c From Cart__c Where id=:CrtId];
         cart.cart_Account__c=accs.id;
         update cart;
         
         if(cn.size()>0){
         cn[0].Abandoned_User_New__c=true;
         update cn[0];
         }
         
         total=cart.Total_Price__c;
           
        List<invoiceit_s__Payment_Plan__c>  ppl= [select id,Name From invoiceit_s__Payment_Plan__c Where Name='Paid In Full Payment Plan'];
          
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        prcbkid = pricebook2id.Pricebookid__c;   
        
        zp =[Select Id,Name,N2N_Sales_Rep__c,N2E_Sales_Rep__c,Custodial_Sales_Rep__c From Zip_Code__c Where Name =:accs.Billingpostalcode ];
            
            
            
        //create Quote
        SBQQ__Quote__c qut = new SBQQ__Quote__c();
        qut.SBQQ__Type__c ='Quote';
        if(cart.Is_Flashsale__c ==TRUE)
        qut.Is_Switch_Sale__c= TRUE;
        qut.SBQQ__Status__c='Draft';
       
        if(cn.size()>0){
        
        qut.SBQQ__PrimaryContact__c=cn[0].id;
        }
        qut.SBQQ__Primary__c = true;
        qut.SBQQ__LineItemsGrouped__c =true;
        qut.SBQQ__BillingName__c=accs.Primary_Contact_Name__c;
        qut.SBQQ__BillingStreet__c=accs.BillingStreet;
        qut.SBQQ__BillingCity__c=accs.BillingCity;
        qut.SBQQ__BillingState__c=accs.BillingState;
        qut.SBQQ__BillingPostalCode__c=accs.Billingpostalcode;
        qut.SBQQ__BillingCountry__c = accs.BillingCountry;
        qut.SBQQ__Account__c=accs.id;
        qut.Ecom_New_to_Existing__c=true;
        qut.Origin_Source__c = 'WEB';
        qut.SBQQ__ShippingName__c=accs.Primary_Contact_Name__c;
        if(accs.ShippingStreet!=null && accs.ShippingStreet!=''){
        qut.SBQQ__ShippingStreet__c=accs.ShippingStreet;
        }
        if(accs.ShippingCity!=null && accs.ShippingCity!=''){
        qut.SBQQ__ShippingCity__c=accs.ShippingCity;
        }
        if(accs.ShippingState!=null && accs.ShippingState!=''){
        qut.SBQQ__ShippingState__c=accs.ShippingState;
        }
        if(accs.Shippingpostalcode!=null && accs.Shippingpostalcode!=''){
        qut.SBQQ__ShippingPostalCode__c=accs.Shippingpostalcode;
        }
        if(accs.ShippingCountry!=null && accs.ShippingCountry!=''){
        qut.SBQQ__ShippingCountry__c = accs.ShippingCountry;
        }
        if(!Test.isRunningTest()){ 
        qut.QTC__Payment_Plan__c =  ppl[0].id;
        qut.SBQQ__PricebookId__c =prcbkid ;
        qut.SBQQ__PriceBook__c =prcbkid ;
        }
        
         if(zp.size()>0 ){
           
           if(zp[0].Custodial_Sales_Rep__c != null){
           qut.SBQQ__SalesRep__c=zp[0].Custodial_Sales_Rep__c; qut.OwnerId=zp[0].Custodial_Sales_Rep__c;
           
           }else {
           
           qut.SBQQ__SalesRep__c=zp[0].N2E_Sales_Rep__c; qut.OwnerId=zp[0].N2E_Sales_Rep__c;
           
           }
          
           }
           
         insert qut;


          //Create Opportunity
          Web_Opp__c  opp =new Web_Opp__c();
        opp.Name= 'weborder'+''+datetime.now();
        opp.WebAccount__c= accs.id;
        opp.Amount__c = total;
        opp.Company_Name__c=accs.Name;
        opp.Primary_Contact_Name__c=cn[0].Name;
        opp.Primary_Phone__c=cn[0].Phone;
        opp.Primary_Email__c=cn[0].Email;
        opp.CloseDate__c = Date.today();
        opp.StageName__c = 'Negotiation';
        opp.Product_c__c ='Web-Order';
        opp.web_quote__c=qut.id;
        opp.Type__c='New to New';
        opp.PricebookId__c=prcbkid;
        insert opp;  
        
         String JSONString = '{"success":"true"}';

            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSONString);
            
            JSONString = JSON.serialize ( m );
            
            return '{\'success\':\'true\'}';
            
       }else if(CustomerType == 'Existing' && (CrtId ==null || CrtId=='')){
       
       
        if(cn.size()>0){
         cn[0].Abandoned_User_Renewal__c=true;
         update cn[0];
         }
       
       if(quteline.size()>0 || (Test.isRunningTest())){
       
        haspromo=false;
     
      List<string> cp = new List<string>();
      
      Map<String, string> mapmainprdct = new Map<String, string>();
    
            for(SBQQ__QuoteLine__c q: quteline){
             system.debug('ql lines here'+q);
             mapmainprdct.put(q.id,q.SBQQ__Product__c);
             system.debug('ql lines here'+mapmainprdct);
             if(q.Promotion__r.id !=null){
             
             cp.add(q.Promotion__r.id);
             haspromo=true;
             }

            }
            
            if(haspromo ==false){
             cp.add('');
                  
             }
            if(cp[0]!=null && cp[0]!=''){
              pe =[Select Id,Active__c,Product__c,Price__c,Promo_Value__c,Promo_Code__c From Promotion_Entry__c where  id=:cp[0]
                                                             AND Active__c =true AND Web_Active__c = TRUE AND Promo_Code__c !=null  ];
                  }                                         
              system.debug('ql lines here'+mapmainprdct);                                                
            string selectedOptions = '';
            
            Map<String, string> mapoptntostr = new Map<String, string>();
            List<Cart_Line__c> crtlntoinsert = new List<Cart_Line__c>();

            for(SBQQ__ProductOption__c option : [Select Id, SBQQ__Required__c, SBQQ__Bundled__c,SBQQ__ConfiguredSKU__c From SBQQ__ProductOption__c Where SBQQ__ConfiguredSKU__c IN :mapmainprdct.values() AND SBQQ__Feature__r.Name !='Fees']) {
                system.debug('================'+option);
                if(option.SBQQ__Bundled__c != True && option.SBQQ__Required__c) {
                    selectedOptions += option.Id + ',';
                    mapoptntostr.put(option.SBQQ__ConfiguredSKU__c,selectedOptions);
                    system.debug('****'+mapoptntostr);
                }
            }
        
            ct = new Cart__c();
             ct.cart_Account__c=accs.id;
             ct.Customer_Type__c='Renewal';
             if(rnwqut[0].Original_Quote__c!=null)
             ct.Existing_login__c=true;
             ct.Originate_URL__c=Label.Ecom_Marketing_Link+'enhance/';
             if(cp[0]!=null && cp[0]!='')
              ct.Promo_Id__c=pe[0].Promo_Code__c;
             
             insert ct;
             
         for(SBQQ__QuoteLine__c q: quteline){
             Cart_Line__c cartline = new Cart_Line__c();
             cartline.Product__c=q.SBQQ__Product__c;
             cartline.Cart__c = ct.Id;
             cartline.Quantity__c=q.SBQQ__Quantity__c;
             cartline.Option_Id__c = mapoptntostr.get(q.SBQQ__Product__c);
             cartline.Promo_Id__c=q.Promotion__r.id;
             cartline.Promo_Value__c=q.Promotion__r.Promo_Value__c;
             cartline.Discounted_Price__c=q.Promotion__r.Price__c;
            crtlntoinsert.add(cartline);
            }

            if(crtlntoinsert.size()>0){
            insert crtlntoinsert;
            }
       
       }
       String accountsJSON = JSON.serializePretty(ct);
       String jsonModified = accountsJSON.replaceall('\n','');
       String jsonModifie1 = accountsJSON.replaceall('\'','');
       system.debug('here is thae value'+accountsJSON);
       
       jsonModified = jsonModified.replaceAll('\"', '\\"');
       //return jsonModified;
       
      // return '{\'Cartid\':\'accountsJSON \'}';
          return '{\'Cartid\':\''+ct.Id+'\'}';
       
       
       
       }
           return '{\'success\':\'false\'}';
            
             }catch(Exception e){
             
             String JSONString = '{"success":"false"}';

            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSONString);
            
            JSONString = JSON.serialize ( m );
            
            return '{\'success\':\'false\'}';
             }
     
  
       
    }

}