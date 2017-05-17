Public class OffersResearchPageExtension{ 
   
    public Pricebookentry smbbkprice {get;set;}
    public Pricebookentry smbbkprice2 {get;set;}
    public List<cart__c> ct {get;set;}
    public string prcbkid{get;set;}
    public SBQQ__Quote__c qute {get;set;}
    public Boolean process {get;set;}
    public Boolean isretry {get;set;}
    public Boolean nopromo {get;set;}
    public Boolean collectpayment{get;set;}
    public Set<String> upsellprdct {get;set;}
    public List<Web_Opp__c> webopp  {get;set;}
    public List<invoiceit_s__Payment_Method__c> mthofpay {get;set;}
    public List<invoiceit_s__Payment_Plan_Installment__c> ppi{get;set;}
    public List<invoiceit_s__Transaction__c> Errorpymnts{get;set;}
    
    
Public OffersResearchPageExtension(){
      process =false;
      collectpayment=false;
      String rcid;
      nopromo=false;
      isretry=false;
      //recommended products
       try{
       Cookie prodCookie = ApexPages.currentPage().getCookies().get('rcid');
       rcid=prodCookie.getvalue();
       }catch(Exception e) {}
       
        ct=[select id,Page4__c,page5__c,Total_Price__c,Promo_Id__c,Purchase_in_Page5__c,cart_Account__c from cart__c where id=:rcid order by CreatedDate Limit 1];
      
      
      
        qute =[select Id,Net_Minus_Tax_Fees__c,Tax__c,Processing_Fees__c,SBQQ__PricebookId__c,SBQQ__Account__r.id,Payment_Processed__c,SBQQ__Primary__c,SBQQ__Account__c from SBQQ__Quote__c
                      where SBQQ__Account__c =: ct[0].cart_Account__c  AND SBQQ__Primary__c =true  
                      order by CreatedDate desc Limit 1];
         
         mthofpay =[Select id,invoiceit_s__Account__c,invoiceit_s__Active__c,invoiceit_s__Payment_Method__c,invoiceit_s__Default__c
                                           From invoiceit_s__Payment_Method__c Where invoiceit_s__Account__c =: qute.SBQQ__Account__r.id AND invoiceit_s__Default__c = true order by CreatedDate desc Limit 1];  
           
        if( !Test.isrunningtest() )                                             
          ppi =[Select Id,QTC__Quote__c,invoiceit_s__Account__c,invoiceit_s__Payment_Method__c From   invoiceit_s__Payment_Plan_Installment__c Where QTC__Quote__c=:qute.id AND invoiceit_s__Account__c=:qute.SBQQ__Account__r.id AND invoiceit_s__Payment_Method__c =:mthofpay[0].id  ];
          
          try{
          webopp = [select id,web_quote__c,Amount__c,WebAccount__c From Web_Opp__c where web_quote__c =:qute.id order by Createddate Limit 1];
          }catch(Exception e) {}
          
       upsellprdct = new Set<string>();
        
        system.debug('prdcts here are'+upsellprdct);
       // Get prices of the Products
      
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
       
         system.debug('pricebook'+prcbkid);
    
    smbbkprice = [SELECT Product2Id,Product2.Marketing_Name__c, Name, UnitPrice FROM PricebookEntry WHERE (Product2.Productcode ='TPPSTDBUND_2016') AND Pricebook2Id =:prcbkid];
    
     smbbkprice2 = [SELECT Product2Id,Product2.Marketing_Name__c, Name, UnitPrice FROM PricebookEntry WHERE (Product2.Productcode ='CCH-ICONNECT_TRC_PKG_2016') AND Pricebook2Id =:prcbkid];
    
        upsellprdct.add(smbbkprice.Product2Id);//Unlimited CCH Webinars Package
        upsellprdct.add(smbbkprice2.Product2Id);//Unlimited CCH Learning Center
}


Public Pagereference nothanks(){
        String rcid;
       try{
       Cookie prodCookie = ApexPages.currentPage().getCookies().get('rcid');
       rcid=prodCookie.getvalue();
       }catch(Exception e) {}
        
       List<cart__c> ct=[select id,Page4__c,page5__c,Total_Price__c,Purchase_in_Page4__c,Purchase_in_Page5__c from cart__c where id=:rcid order by CreatedDate Limit 1];
      if(webopp.size() ==0 ) {
                     //Create Opportunity
                Web_Opp__c opp = new Web_Opp__c ();
                opp.Name= 'weborder'+''+datetime.now();
                opp.WebAccount__c= qute.SBQQ__Account__r.id;
                if(!Test.isRunningTest()){
                opp.Amount__c = ct[0].Total_Price__c;
                }
                opp.CloseDate__c = Date.today();
                opp.StageName__c= 'Negotiation';
                opp.Product_c__c ='Web-Order';
                opp.web_quote__c=qute.id;
                opp.Type__c='Renewal';
                opp.PricebookId__c=qute.SBQQ__PricebookId__c;
                insert opp; 
                }
                
      if(ct.size()>0){
      system.debug('**page 4'+ct[0].page4__c);
      if(ct[0].page5__c =='Not-Visited' ){
      ct[0].page5__c ='Visited';
      update ct;
       }
       if(ct[0].Purchase_in_Page4__c ==true){
       
       process =true;
       return null;
       }
       if(ct[0].Purchase_in_Page4__c ==false && ct[0].Purchase_in_Page5__c  ==false){
       system.debug('**page 4'+ct[0].page4__c);
       
        
                
       return null;
       }
       }
     
       
       Decimal r=math.random();
      PageReference prl = new pageReference('/apex/RenewalPaymentPage?accuntId='+ct[0].id+'&r='+r);
       prl.setRedirect(true);
       return prl;
    
    
    return null;
    

}

Public Pagereference ad2cart(){
       String rcid; 
        String p= ApexPages.currentPage().getParameters().get( 'pymnhg'); 
        String p1= ApexPages.currentPage().getParameters().get( 'pymnhg1'); 
        system.debug('ids here'+p +p1);
      
       if(webopp.size() ==0 ) {
                     //Create Opportunity
                Web_Opp__c opp = new Web_Opp__c ();
                opp.Name= 'weborder'+''+datetime.now();
                opp.WebAccount__c= qute.SBQQ__Account__r.id;
                if(!Test.isRunningTest()){
                opp.Amount__c = ct[0].Total_Price__c;
                }
                opp.CloseDate__c = Date.today();
                opp.StageName__c= 'Negotiation';
                opp.Product_c__c ='Web-Order';
                opp.web_quote__c=qute.id;
                opp.Type__c='Renewal';
                opp.PricebookId__c=qute.SBQQ__PricebookId__c;
                insert opp; 
                }
                
       if((p==null || p=='')&& (p1==null||p1=='')){
        VFUtil.AddErrorMessage ( 'Please select a Product to make a Purchase.');
            return null;
       
       }else{
       process =true;
       }
          system.debug('Cart promo code'+ct[0].Promo_Id__c);
          system.debug('product here'+upsellprdct   );
          List<Promotion_Entry__c> cp =[Select Id,Active__c,Product__c,Price__c,Promo_Value__c,Promo_Code__c From Promotion_Entry__c where Promo_Code__c ='PERKTPP'
                                                             AND Active__c =true AND Product__c IN :upsellprdct   AND Promo_Code__c !=null  ];
        
        Map<string,Promotion_Entry__c> mapprmid =new map<string,Promotion_Entry__c>();
        for(Promotion_Entry__c pen :cp){
        
        mapprmid.put(pen.Product__c,pen);
        }
        
        if(cp.size()>0){
        nopromo=true;
        }
        //    Create a new cart line item for the productId
         if(p!=null && p!=''){
        Cart_Line__c cartline = new Cart_Line__c();
        
        cartline.Cart__c = ct[0].id;
       
        cartline.Product__c = smbbkprice.Product2Id;
        if(nopromo==true){
        cartline.Promo_Id__c=mapprmid.get(smbbkprice.Product2Id).id;
        
        cartline.Promo_Value__c=mapprmid.get(smbbkprice.Product2Id).Promo_Value__c;
        
        cartline.Discounted_Price__c=mapprmid.get(smbbkprice.Product2Id).Price__c;
         
         }
        cartline.Quantity__c = 1;
        
        insert cartline;
        
         }
         
        if(p1!=null && p1!=''){
         
         Cart_Line__c cartline = new Cart_Line__c();
        
        cartline.Cart__c = ct[0].id;
       
        cartline.Product__c = smbbkprice2.Product2Id;
          if(nopromo==true){
        cartline.Promo_Id__c=mapprmid.get(smbbkprice2.Product2Id).id;
        
        cartline.Promo_Value__c=mapprmid.get(smbbkprice2.Product2Id).Promo_Value__c;
        
        cartline.Discounted_Price__c=mapprmid.get(smbbkprice2.Product2Id).Price__c;
        }
        cartline.Quantity__c = 1;
        
        insert cartline;
         }
         
         
         
         
      if(p!=null && p!=''){                 
       SBQQ__QuoteLine__c qutlines= new SBQQ__QuoteLine__c();
       qutlines.SBQQ__Quantity__c = 1;
     
       qutlines.SBQQ__Product__c = smbbkprice.Product2Id;
       if(nopromo==true){
       qutlines.Promotion__c= mapprmid.get(smbbkprice.Product2Id).id;
         }
       qutlines.SBQQ__Quote__c  = qute.id;
       insert qutlines;
       
       }
       
      if(p1!=null && p1!=''){
       
       SBQQ__QuoteLine__c qutlines= new SBQQ__QuoteLine__c();
       qutlines.SBQQ__Quantity__c = 1;
     
       qutlines.SBQQ__Product__c = smbbkprice2.Product2Id;
        if(nopromo==true){
       qutlines.Promotion__c= mapprmid.get(smbbkprice2.Product2Id).id;
        }
       qutlines.SBQQ__Quote__c  = qute.id;
       insert qutlines;
       
        }
      
      
      
      
      if(ct.size()>0){
      system.debug('**page 4'+ct[0].page5__c );
      if(ct[0].page5__c =='Not-Visited' ){
      ct[0].page5__c ='Visited';
      ct[0].Purchase_in_Page5__c=true;
      update ct;
       }
       }
       
  return null;

}

Public Pagereference Tax(){

    IIT_SpeedTaxConnector.calculateTaxForQuote(qute.id);    

                 
      Decimal r=math.random();
      PageReference prl = new pageReference('/apex/RenewalPaymentPage?accuntId='+ct[0].id+'&r='+r);
      prl.setRedirect(true);
      return prl;


}

  Public pagereference CreatePayment(){
        
        
        collectpayment=false;
        if(qute.Payment_Processed__c==false){
          try {
             
              string qpid =qute.id;
              WebCreateOrder cc = new WebCreateOrder();
              Boolean success =cc.validpayment(qpid );
              if(!success ){
         
               system.debug('****line 506  '+qute.SBQQ__Account__r.id +ppi[0].id);
               string a = String.valueOf(qute.SBQQ__Account__r.id).substring(0, 15);
               try{
                   Errorpymnts =[Select Id,Account_ID__c,invoiceit_s__Response_Status__c,payment_plan_installment__c From invoiceit_s__Transaction__c where Account_ID__c=:a AND payment_plan_installment__c=:ppi[0].id order by CreatedDate desc Limit 1];
               }catch (exception e) {}
               if(Errorpymnts.size()>0){
                   if(Errorpymnts[0].invoiceit_s__Response_Status__c!= null){
                       VFUtil.AddErrorMessage ( Errorpymnts[0].invoiceit_s__Response_Status__c);
                       collectpayment=true;
                      String r='Please Check Your Payment Method';
                      PageReference prl = new pageReference('/apex/RenewalPaymentPage?accuntId='+ct[0].id+'&err='+r);
                      prl.setRedirect(true);
                      return prl;
                   }
                   }else{
                       VFUtil.AddErrorMessage ( 'UnKnown Error has Encountered');
                       collectpayment=true;
                       String r='Please Check Your Payment Method';
                       PageReference prl = new pageReference('/apex/RenewalPaymentPage?accuntId='+ct[0].id+'&err='+r);
                      prl.setRedirect(true);
                      return prl;
                   }
                   //return null;
                   }else{
                  qute.Payment_Processed__c=true;
                  update qute; 
                  system.debug('flag value of payment'+success);
                  }
              return null;
          }
          catch(Exception e) {
              collectpayment=true;
              String r='Please Check Your Payment Method';
              PageReference prl = new pageReference('/apex/RenewalPaymentPage?accuntId='+ct[0].id+'&err='+r);
              prl.setRedirect(true);
              return prl;
          }
        }
        return null;
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
       
      List<SBQQ__Quote__c> qt =[select Id,Retry_count__c from SBQQ__Quote__c where SBQQ__Account__c =: ct[0].cart_Account__c AND SBQQ__Primary__c =true  
                              order by CreatedDate desc Limit 1];
                system.debug('qute'+qt);
                    if(qt.size()>0)   {         
                      if(qt[0].Retry_count__c != null && qt[0].Retry_count__c < 3 ){
                      isretry=true;
                      }else{
                      isretry=false;
                      }
                    }
      
      return null;
      }
      
      Public pagereference orderconf(){
      
      PageReference url = new PageReference('/apex/OrderConfirmationPage?type='+ct[0].id);
      
      return url;
      
      }

}