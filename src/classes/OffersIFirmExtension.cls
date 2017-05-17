Public class OffersIFirmExtension{ 
public Pricebookentry smbbkprice {get;set;}
public string pid {get;set;}
public SBQQ__Quote__c qute{get;set;}
public SBQQ__QuoteLine__c qutlines{get;set;}
public List<cart__c> ct {get;set;}
public List<Promotion_Entry__c> cp{get;set;}


Public OffersIFirmExtension(){
   
    // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
      
        pid ='CSIFIRMPLSTD5GBNONSB_2016';
       
        
       
    smbbkprice = [SELECT Product2Id,Product2.Marketing_Name__c, Name, UnitPrice FROM PricebookEntry WHERE (Product2.Productcode =:pid ) AND Pricebook2Id =:prcbkid];
    
}


Public Pagereference nothanks(){
       String rcid; 
       try{
       Cookie prodCookie = ApexPages.currentPage().getCookies().get('rcid');
       rcid=prodCookie.getvalue();
       }catch(Exception e) {}
       
       List<cart__c> ct=[select id,Page4__c,page5__c from cart__c where id=:rcid order by CreatedDate Limit 1];
      
      if(ct.size()>0){
      system.debug('**page 4'+ct[0].page4__c);
      if(ct[0].page4__c=='Not-Visited' ){
      ct[0].page4__c='Visited';
      update ct;
       }
       }
      PageReference prl = new pageReference('/apex/OffersResearchProductPage');
       prl.setRedirect(true);
       return prl;


}

Public Void ad2cart(){
       String rcid; 
       try{
       Cookie prodCookie = ApexPages.currentPage().getCookies().get('rcid');
       rcid=prodCookie.getvalue();
       }catch(Exception e) {}
        
        system.debug('cms'+pid);
        
         cp =[Select Id,Active__c,Product__c,Price__c,Promo_Value__c,Promo_Code__c From Promotion_Entry__c where Promo_Code__c ='PERKIFIRM'
                                                             AND Active__c =true AND Product__c =:smbbkprice.Product2Id AND Promo_Code__c !=null  ]; 
                                                             
        ct=[select id,Page4__c,page5__c,Purchase_in_Page4__c,cart_Account__c from cart__c where id=:rcid order by CreatedDate Limit 1];
      
      
        //    Create a new cart line item for the productId
        Cart_Line__c cartline = new Cart_Line__c(Cart__c = ct[0].id, Product__c = smbbkprice.Product2Id , Quantity__c = 1);
        if(cp.size()>0){
        cartline.Promo_Id__c=cp[0].id;
        cartline.Promo_Value__c=cp[0].Promo_Value__c;
        cartline.Discounted_Price__c=cp[0].Price__c;
        
        }
        insert cartline;
      
        qute =[select Id,Net_Minus_Tax_Fees__c,Tax__c,Processing_Fees__c,SBQQ__Primary__c,SBQQ__Account__c from SBQQ__Quote__c
                      where SBQQ__Account__c =: ct[0].cart_Account__c  AND SBQQ__Primary__c =true  
                       order by CreatedDate desc Limit 1];
     
                              
                
   
       qutlines= new SBQQ__QuoteLine__c();
       qutlines.SBQQ__Quantity__c = 1;
       qutlines.SBQQ__Product__c = smbbkprice.Product2Id;
       if(cp.size()>0){
       qutlines.Promotion__c= cp[0].id;
       }
       qutlines.SBQQ__Quote__c  = qute.id;
       insert qutlines;
       
       
     }
     
   Public Pagereference cql(){ 
   
     
       List<SBQQ__QuoteLine__c> mainprdctqutlines= new List<SBQQ__QuoteLine__c>();
       
          for(SBQQ__ProductOption__c m :[Select Id,SBQQ__OptionalSKU__c,SBQQ__ConfiguredSKU__c,SBQQ__OptionalSKU__r.Shipping_Processing__c From SBQQ__ProductOption__c  Where SBQQ__ConfiguredSKU__c =:smbbkprice.Product2Id    ORDER BY  SBQQ__Number__c ASC] ){
           
            SBQQ__QuoteLine__c ql= new SBQQ__QuoteLine__c();
          ql.SBQQ__Quantity__c = 1;
          ql.SBQQ__Product__c = m.SBQQ__OptionalSKU__c ;
          ql.SBQQ__Quote__c  = qute.id;
          ql.Shipping_Processing__c=m.SBQQ__OptionalSKU__r.Shipping_Processing__c;
          ql.SBQQ__RequiredBy__c=qutlines.Id;
          ql.SBQQ__ProductOption__c=m.Id;
          
          mainprdctqutlines.add(ql);
         //system.debug('**********************'+rqrdqutlinemap.get(m.SBQQ__ConfiguredSKU__c));
          }
          if(mainprdctqutlines.size()>0)    
           insert mainprdctqutlines;
        
    
      
      
      if(ct.size()>0){
      system.debug('**page 4'+ct[0].page4__c);
      if(ct[0].page4__c=='Not-Visited' ){
      ct[0].page4__c='Visited';
      ct[0].Purchase_in_Page4__c=true;
      update ct;
       }
       }
        
      PageReference prl = new pageReference('/apex/OffersResearchProductPage');
       prl.setRedirect(true);
       return prl;


}



}