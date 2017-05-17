public without sharing class Billing_Info_Extn{

    public Account acc{get; set;}
    public List<Account> Existingaccnt{get; set;}
    public Contact cnt{get; set;}
    public List<cart__c> crt{get; set;}
   
    public Web_Opp__c  opp{get; set;}
    public Cart_Line__c  crtlns{get; set;}
    public SBQQ__Quote__c  qut{get; set;} 
    public string prcbkid{get;set;}
    public SBQQ__QuoteLine__c  salesqutln{get; set;} 
   // public SBQQ__QuoteLine__c  ql{get; set;} 
    public Boolean validState { get; set; }
    public Boolean hasaccount { get; set; }
    public Boolean hasshipping { get; set; }
    public Boolean iserror { get; set; }
    Public List<Product2> pi{get;set;} 
    public  List<Zip_Code__c> zp {get;set;} 
    public List<invoiceit_s__Payment_Plan__c>  ppl{get;set;}
    public List<SBQQ__QuoteLine__c> mainprdctqutlines{ get; set; }
    public List<SBQQ__QuoteLine__c> optnqllines{ get; set; }
    public List<SBQQ__QuoteLine__c> optionsToUpdate{ get; set; } 
    public Set<String> optlineitems{ get; set; }
    public Map<string,SBQQ__QuoteLine__c> rqrdqutlinemap{ get; set; } 
   
    public String ckid {get;set;}
    
    public Billing_Info_Extn(){
       
       iserror=false;
       hasaccount=false; 
       hasshipping =false;
       
        String memberaccuntId = ApexPages.currentPage().getParameters().get( 'aci');     
         
        
          Existingaccnt=[Select Id,Name,OwnerId,Missing_Billing_Shipping_Info__c,Acct_Primary_Contact__r.Email,Acct_Primary_Contact__r.Name,Acct_Primary_Contact__r.Phone,Acct_Primary_Contact__r.FirstName,Acct_Primary_Contact__r.LastName,
                                BillingStreet,Billingcity,BillingState,Billingpostalcode,ShippingStreet,shippingcity,shippingState,shippingpostalcode,Primary_Contact_Name__c,Shipping_Contact_Name__c  
                                From Account Where id=:memberaccuntId ];
       
         //check existed cookie
             try{
             if(!Test.isRunningTest()){
         Cookie idCookie = ApexPages.currentPage().getCookies().get('cartId');
        ckid = idCookie.getvalue();
        
        crt =[select id,Cart_Account__c,Is_Flashsale__c,Total_Price__c,Shipping_Name__c,Shipping_Zip__c,Shipping_City__c,State__c,Sales_Assignment__c,Street_Address__c,Missing_Shipping_Info__c From cart__c Where id =:ckid  ];
        if(crt[0].Missing_Shipping_Info__c == TRUE)hasshipping =true;
        }else{
        crt =[select id,Cart_Account__c,Is_Flashsale__c,Total_Price__c,Shipping_Name__c,Shipping_Zip__c,Shipping_City__c,State__c,Sales_Assignment__c,Street_Address__c,Missing_Shipping_Info__c From cart__c where Cart_Account__c=:Existingaccnt[0].id  ];
       
        }
        }catch(Exception e) {}
             
           
            if(Existingaccnt.size()>0){if(Existingaccnt[0].Missing_Billing_Shipping_Info__c == TRUE)hasaccount=true; }
             
             
         cnt=[Select Id,AccountID,Is_Primary__c,Abandoned_User_Renewal__c,Abandoned_User_New__c From Contact Where Is_Primary__c =true AND AccountID=:memberaccuntId  order by CreatedDate desc Limit 1 ];

          // Get pricebook id
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        prcbkid = pricebook2id.Pricebookid__c;
        
         pi=[Select Id,Name From Product2 Where Name='Sales Tax' AND IsActive= true Limit 1 ];
                 
        ppl= [select id,Name From invoiceit_s__Payment_Plan__c Where Name='Paid In Full Payment Plan'];
        
    }
    
    
 public Pagereference  updatebillingshipping(){
        
       
         if ( (crt[0].Shipping_Name__c != null && crt[0].Shipping_Name__c.length() < 2 ) ) {
            VFUtil.AddErrorMessage('Shipping Name is required');
            iserror =false;
            return null ;
        }
        
        system.debug('account deatsil'+acc);
         
         if(!Test.isRunningTest()){ crt[0].State__c =crt[0].State__c.toUpperCase();  }
        
        // validate state
        
        Set<String> validStates = new Set<String>{ 'AS', 'AR', 'CA', 'UT', 'NV',
            'AL', 'AK', 'AZ', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA','GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY','MP', 
            'LA', 'ME','MH', 'MD', 'MA', 'MI','FM', 'MN', 'MS', 'MO', 'NV','MT', 'NE', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 
            'OH', 'OK', 'OR', 'PA','PW', 'RI', 'SC', 'SD', 'TN','UT', 'TX','VI', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY' };
            
            if ( !validStates.contains( crt[0].State__c) || crt[0].State__c.length() > 2 || crt[0].State__c.length() < 2  ) {
            VFUtil.AddErrorMessage ('Enter a valid state. Acceptable formats: GA,TX,CA,AZ.');
            iserror =false;
            return null;
                }
              
          // validate zip codes     
        if ( crt[0].Shipping_Zip__c != null && crt[0].Shipping_Zip__c != '' && !Pattern.matches('^([0-9]{5})||([0-9]{5}-[0-9]{4})$', crt[0].Shipping_Zip__c) ) {
            VFUtil.AddErrorMessage ( 'Invalid zip code.');
            iserror =false;
            return null ;
        }     
         system.debug(acc);
           
           
             zp =[Select Id,Name,N2N_Sales_Rep__c,N2E_Sales_Rep__c,Custodial_Sales_Rep__c From Zip_Code__c Where Name =:crt[0].Shipping_Zip__c ];
            
             if(zp.size()>0 && crt.size()>0 ){
           
           if(zp[0].Custodial_Sales_Rep__c != null){ crt[0].Sales_Assignment__c=zp[0].Custodial_Sales_Rep__c; }else {crt[0].Sales_Assignment__c=zp[0].N2N_Sales_Rep__c; }
           
          
           }
            
           update crt[0];
           
           //System.debug('zip code here'+zp[0]);
           
        
     
        PageReference url = new PageReference('/apex/Payment_Info?aci='+Existingaccnt[0].id);
           return url;  
    }


}