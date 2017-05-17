public with sharing class Displayproducts {
public List<schema.Product2> productdetails{get;set;}
    Set<String> crtdPrdctIds = new Set<String>();
    Public Cart__C cart {get;set;}
    public Map<String, Decimal> unitprice {get;set;}
    public Displayproducts(ApexPages.StandardController controller)  {
        cart = new Cart__c();
        Set<String> atxpackages = new Set<String>();
        
        atxpackages.add('ATX-PRSRET1_2016'); //Pay Per Return
        atxpackages.add('ATX-1040_2016'); //1040 Package
        atxpackages.add('ATX-MAX_2016'); //Max Package
        atxpackages.add('ATX-TTO_2016'); //Total Tax Office
        atxpackages.add('ATX-ADVANTAGE_2016'); //Advantage
        
            
        productdetails = [Select Id, Name, Description,Marketing_Name__c,ProductCode  ,Detail_description__c , Product_Short_Description__c From Product2 Where Productcode IN: atxpackages];  
        
         // Get prices of the Products
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        string prcbkid = pricebook2id.Pricebookid__c;
        unitprice = new Map<String, Decimal>();
        
        for(PricebookEntry price : [SELECT Id, Name, UnitPrice, Product2Id FROM PricebookEntry WHERE (Product2Id IN :productdetails ) AND Pricebook2Id =:prcbkid]){
            if(price.UnitPrice != null)
            unitprice.put(price.Product2Id, price.UnitPrice);
        }   
    }       
    
   /* public PageReference saveToCart(){
        
        String prodid = ApexPages.currentPage().getParameters().get('prodids');
      
        
        //check existed cookie
        Cookie prodCookie = ApexPages.currentPage().getCookies().get('cartId');
        CreateCart cc = new CreateCart();
        if(prodCookie == null)
            cc.Line(prodid, null,null);
        else
            cc.Line(prodid, prodCookie.getvalue(),null);
            
        String url1 = 'https://' + ApexPages.currentPage().getHeaders().get('Host') + ApexPages.currentPage().getHeaders().get('Referrer');
          system.debug('**page url'+url1);   
        String url = '/apex/ShoppingCart';
       // return new PageReference( url);
       return null;
    }*/
     

}