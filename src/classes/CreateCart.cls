public with sharing class CreateCart{
 Public Cookie rewcart{get;set;}
 Public Boolean haspromo{get;set;}
 public  List<cart__c> cartexist {get;set;}
 public List<Promotion_Entry__c> pe {get;set;}
public void renewalcrt(Id qutid,Id acid) {

      haspromo=false;
      try{
      List<string> cp = new List<string>();
      
      Map<String, string> mapmainprdct = new Map<String, string>();
      List<SBQQ__QuoteLine__c> quteline =[select Id,SBQQ__Bundle__c,SBQQ__RequiredBy__c,SBQQ__ListPrice__c,SBQQ__Product__r.List_Price__c,Promotion__c,Promotion__r.id,Promotion__r.Promo_Value__c,Promotion__r.Price__c,
                                                 SBQQ__NetPrice__c,SBQQ__CustomerTotal__c,SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,
                                                 SBQQ__ListTotal__c,SBQQ__Quantity__c  From SBQQ__QuoteLine__c  Where SBQQ__Quote__c = :qutid AND SBQQ__Product__c != null AND SBQQ__Product__r.Shipping_Processing__c=false AND SBQQ__Product__r.Name != 'Sales Tax' AND SBQQ__RequiredBy__c = null order by SBQQ__Number__c ];
       
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
             system.debug('ql lines here'+mapmainprdct);
            try{
             rewcart = ApexPages.currentPage().getCookies().get('rcid');
            }catch(Exception e) {}
         
         if(rewcart==null ){
             cart__c ct = new Cart__c();
             ct.Cart_Account__c=acid;
             ct.Originate_URL__c='Label.Ecom_Marketing_Linkenhance/';
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
            Cookie cooky = new Cookie('rcid', ct.Id, null, 172800, false); 
            ApexPages.currentPage().setCookies(new Cookie[]{cooky }); 
                         
             }else{
             
            cookie rid= ApexPages.currentPage().getCookies().get('rcid');
            
            cart__c  cartexist =[select id,Originate_URL__c,Promo_Id__c from cart__c where id =:rewcart.getvalue()];
            cartexist.Originate_URL__c='Label.Ecom_Marketing_Linkenhance/';
            system.debug('Promo ID Here'+quteline[0].Promotion__r.id);
            if(cp[0]!=null && cp[0]!='')
            cartexist.Promo_Id__c=pe[0].Promo_Code__c;
             
            update cartexist;
            system.debug('Cart created'+cartexist);
            
            Map<String, string> mapexistnclprdct = new Map<String, string>();
            
             List<Cart_Line__c> cln = [Select Id,Product__c From Cart_Line__c Where  Cart__c =: cartexist.id];
             
             for(Cart_Line__c c : cln){
             
             mapexistnclprdct.put(c.Product__c,c.id);
             
             }
             system.debug('Cart lines exists'+mapexistnclprdct);
             
            for(SBQQ__QuoteLine__c q: quteline){
            if(!mapexistnclprdct.containsKey(q.SBQQ__Product__c)){
             system.debug('Cart lines exists'+mapexistnclprdct);
             Cart_Line__c cartline = new Cart_Line__c();
             cartline.Product__c=q.SBQQ__Product__c;
             cartline.Cart__c = rid.getvalue();
             cartline.Quantity__c=q.SBQQ__Quantity__c;
             cartline.Option_Id__c = mapoptntostr.get(q.SBQQ__Product__c);
             
             cartline.Promo_Id__c=q.Promotion__r.id;
             cartline.Promo_Value__c=q.Promotion__r.Promo_Value__c;
             cartline.Discounted_Price__c=q.Promotion__r.Price__c;
            crtlntoinsert.add(cartline);
            }
            }

            if(crtlntoinsert.size()>0){
            insert crtlntoinsert;
            }
             
             
             }
             }catch(Exception e) {}
}
public void Line(Id productId, String cartId,String url,String Promo) {
        try {
            string selectedOptions = '';
            for(SBQQ__ProductOption__c option : [Select Id, SBQQ__Required__c, SBQQ__Bundled__c From SBQQ__ProductOption__c Where SBQQ__ConfiguredSKU__c =: productId AND SBQQ__Feature__r.Name !='Fees']) {
                system.debug('================'+option);
                if(option.SBQQ__Bundled__c != True && option.SBQQ__Required__c) {
                    selectedOptions += option.Id + ',';
                }
            }
            selectedOptions.removeEnd(',');
            system.debug('**********'+selectedOptions);
            if(cartId == null || cartId== 'x' ) {
                //    Create Cart
               Cart__c cart = new Cart__c();
                cart .Originate_URL__c=url;
                insert cart;
                
                List<Promotion_Entry__c> cp;
                if(Promo!= null && Promo!= ''){
                cp =[Select Id,Active__c,Product__c,Price__c,Promo_Value__c,Promo_Code__c From Promotion_Entry__c where Promo_Code__c =:Promo
                                                             AND Active__c =true AND Web_Active__c = TRUE  AND Product__c = :productId  AND Promo_Code__c !=null  ];
                          
                          }                                   
                //    Create Cart lines
                Cart_Line__c cartline = new Cart_Line__c(Product__c = productId, Cart__c = cart.Id, Quantity__c = 1);
                if(cp!=null && cp.size()>0){
                        cartline.Promo_Id__c=cp[0].id;
                        cartline.Promo_Value__c=cp[0].Promo_Value__c;
                        cartline.Discounted_Price__c=cp[0].Price__c;
                        if(cp[0].Promo_Code__c =='ATXSTBOOK' ||cp[0].Promo_Code__c =='TWSTBOOK' ){
                        cartline.Is_Flashsale__c=True;
                        }
                        }
                cartline.Option_Id__c = selectedOptions;               
                insert cartline;
                
                 if(cartId== null) {
            Cookie cooky = new Cookie('cartId', cart.Id, null, 1209600, false); 
            ApexPages.currentPage().setCookies(new Cookie[]{cooky });
            system.debug('cookie'+cooky );
               }else if(cartId== 'x') {
               
               Cookie cooky = new Cookie('rcid', cart.Id, null, 172800, false); 
            ApexPages.currentPage().setCookies(new Cookie[]{cooky });
            system.debug('cookie'+cooky );
               
               
               }
            }
            else {
                //    Check if a cart line already exists with the selected productId on the cart
                try {
                    Cart_Line__c cartline = [Select Id From Cart_Line__c Where Product__c =: productId AND Cart__c =: cartId];    
                    //    Do nothing, if any cartline found.
                    //    Throws exception, when no rows found and enters the catch block. 
                }catch(Exception e) {
                    
                    cartexist =[select id,Promo_Id__c,Switch_Promo__c from cart__c where id =:cartId];
                    system.debug('cartexits******'+cartexist.size() );
                    
                    if(cartexist.size()== 0){
                        cart__c ct = new Cart__c();
                         insert ct;
                         
                         system.debug('newcartline******'+ct);
                        //    Create a new cart line item for the productId
                        Cart_Line__c cl= new Cart_Line__c(Cart__c = ct.id, Product__c = productId, Quantity__c = 1);
                        cl.Option_Id__c = selectedOptions;
                        insert cl;
                        
                        Cookie cooky = new Cookie('cartId', ct.Id, null, 1209600, false); 
                        ApexPages.currentPage().setCookies(new Cookie[]{cooky });
                    }else{
                    
                        //    Create a new cart line item for the productId
                        Cart_Line__c cartline = new Cart_Line__c(Cart__c = cartId, Product__c = productId, Quantity__c = 1);
                        cartline.Option_Id__c = selectedOptions;
                        
                        system.debug('coupon to apply '+cartexist[0].Promo_Id__c  +productId  );
                        if((cartexist[0].Promo_Id__c !=null && cartexist[0].Promo_Id__c !='') || (Promo!=null && Promo!='')){


                        List<Promotion_Entry__c> cp =[Select Id,Active__c,Product__c,Price__c,Promo_Value__c,Promo_Code__c From Promotion_Entry__c where (Promo_Code__c =:cartexist[0].Promo_Id__c OR Promo_Code__c =:Promo)
                                                             AND Active__c =true AND Web_Active__c = TRUE  AND Product__c = :productId  AND Promo_Code__c !=null  ];
                        
                        if(cp.size()>0){
                        cartline.Promo_Id__c=cp[0].id;
                        cartline.Promo_Value__c=cp[0].Promo_Value__c;
                        cartline.Discounted_Price__c=cp[0].Price__c;
                        if(cp[0].Promo_Code__c =='ATXSTBOOK' ||cp[0].Promo_Code__c =='TWSTBOOK' ){
                        cartline.Is_Flashsale__c=True;
                        }
                        }
                        }
                        insert cartline;
                    }
                }
            }
            
        }catch(Exception e) {}
     }
     
  
    }