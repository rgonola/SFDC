public without sharing class CustomerRegistrationExtension{

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
    public Boolean iserror { get; set; }
    Public List<Product2> pi{get;set;}  
    public List<invoiceit_s__Payment_Plan__c>  ppl{get;set;}
    public List<SBQQ__QuoteLine__c> mainprdctqutlines{ get; set; }
    public List<SBQQ__QuoteLine__c> optnqllines{ get; set; }
    public List<SBQQ__QuoteLine__c> optionsToUpdate{ get; set; } 
    public Set<String> optlineitems{ get; set; }
    public Map<string,SBQQ__QuoteLine__c> rqrdqutlinemap{ get; set; } 
   
    public String ckid {get;set;}
    
    public CustomerRegistrationExtension(ApexPages.StandardController controller){
       
       iserror=false;
       hasaccount=false; 
        //check existed cookie
             try{
         Cookie idCookie = ApexPages.currentPage().getCookies().get('cartId');
        ckid = idCookie.getvalue();
        crt =[select id,Cart_Account__c,Is_Flashsale__c,Total_Price__c From cart__c Where id =:ckid  ];
        
        
        
      if(crt[0].Cart_Account__c != null){    Existingaccnt=[Select Id,Name,Missing_Billing_Shipping_Info__c,Acct_Primary_Contact__r.Email,Acct_Primary_Contact__r.Name,Acct_Primary_Contact__r.Phone,Acct_Primary_Contact__r.FirstName,Acct_Primary_Contact__r.LastName,
                                BillingStreet,Billingcity,BillingState,Billingpostalcode,ShippingStreet,shippingcity,shippingState,shippingpostalcode,Primary_Contact_Name__c,Shipping_Contact_Name__c  
                                From Account Where id=:crt  [0].Cart_Account__c]; }
          
         
         
          
           if(Existingaccnt.size()>0){ hasaccount=true; }
        }catch(Exception e) {}

          // Get pricebook id
        Pricebook__c pricebook2id = Pricebook__c.getInstance('Pricebook2016'); 
        prcbkid = pricebook2id.Pricebookid__c;
        
         pi=[Select Id,Name From Product2 Where Name='Sales Tax' AND IsActive= true Limit 1 ];
                 
        ppl= [select id,Name From invoiceit_s__Payment_Plan__c Where Name='Paid In Full Payment Plan'];
        acc = new Account();  
        cnt = new Contact();
        opp = new Web_Opp__c ();
        qut = new SBQQ__Quote__c();
        salesqutln = new SBQQ__QuoteLine__c();
       
        acc.type = 'New Customer';
        if(!Test.isRunningTest()){
        acc.Name = '';
        }else{
        acc.Name = 'test';
        }
        acc.SameasBillingAddress__c =true;
        acc.Brand__c='ATX';
        acc.shippingCountry = 'USA';
    }

    Public Pagereference  CreateAccount(){
    
        system.debug('values here'+acc+cnt);
        iserror = true;   
        // Validate Name
        if ( (cnt.FirstName != null && cnt.FirstName.length() < 2) ) {
            VFUtil.AddErrorMessage('First Name is required');
            iserror =false;
            system.debug('firstname error' +cnt.FirstName );
            return null ;
        }
        
        if ( (cnt.LastName != null && cnt.LastName.length() < 2 ) ) {
            VFUtil.AddErrorMessage('Last Name is required');
            iserror =false;
            return null ;
        }
        
        if ( (acc.Name != null && acc.Name.length() < 2 ) ) {
            VFUtil.AddErrorMessage('Account Name is required');
            iserror =false;
            return null ;
        }
        
         
        
        // validate phone fields
        if ( cnt.Phone != null && !Pattern.matches('^$|^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$|^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4} x[a-zA-Z0-9]{1,4}$', cnt.Phone) ) {
            cnt.Phone.addError('Phone number must be at least 10 digits long. Acceptable formats: (123) 456-7891 or (123) 456-7891 x1234');
            VFUtil.AddErrorMessage ('Invalid phone number.');
           iserror =false;
            return null;
        }
       
            insert acc;
         
            cnt.AccountID=acc.id;
            cnt.Is_Primary__c = true;
            cnt.Abandoned_User_New__c=true;
            insert cnt;
        
            acc.Acct_Primary_Contact__c =cnt.id;
            update acc;
            
            
            try{
         
        
        if(crt.Size()>0){ crt[0].Cart_Account__c = acc.id;
        update crt[0];hasaccount=true;
        
        if(crt[0].Is_Flashsale__c ==TRUE){ qut.Is_Switch_Sale__c=TRUE;}
        }
        }catch(Exception e) {}
         
      
                       
           PageReference url = new PageReference('/apex/Billing_Info?aci='+acc.id);
           return url;     
      
    }
    
    
    
   
  
 
  
  
}