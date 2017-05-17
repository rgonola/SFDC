public without sharing class Twodemoextn{

    public Account acc{get; set;}
    public Contact cnt{get; set;}
    public Boolean iserror{get; set;}
    public Boolean onLoad{get; set;}
    
    
    /* ReCaptcha Configuration */

    // The API endpoint for the reCAPTCHA service
    // google account used for recaptcha is Username: cchsfs225@gmail.com , Pass:CCH@sfs225
    private static String baseUrl = 'https://www.google.com/recaptcha/api/verify'; 

    // The keys you get by signing up for reCAPTCHA for your domain
    private static String privateKey = '6LeQKCMTAAAAAAfP3PDfe_44Hi9KBFvxfxnPvD2K';
    public String publicKey { 
        get { return '6LeQKCMTAAAAAHzqUYPygmFTQyUGHMlnQKrth8L8'; }
    } 
    // Create properties for the non-VF component input fields generated
    // by the reCAPTCHA JavaScript.
    public String challenge { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_challenge_field');
        }
    }
    public String response  { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_response_field');
        }
    }
    // Whether the submission has passed reCAPTCHA validation or not
    public Boolean verified { get; private set; }
    
    public Twodemoextn(){
        
        onLoad = true;
        verified = false; 
        acc = new Account();  
        cnt = new Contact();

        iserror=false;
       
        acc.type = 'Prospect';
        if(!Test.isRunningTest()){
        acc.Name = '';
        }else{
        acc.Name = 'test';
        }
        acc.SameasBillingAddress__c = true;
        acc.Brand__c ='TWO';
        acc.shippingCountry = 'USA';
        cnt.TwoTrial_Campaign__c = Label.Campaign_Name_For_Trial;
        
     }
       



    public Pagereference  save(){
        onLoad = false;
        iserror = true;   
        // Validate Name
        if (cnt.FirstName != null && cnt.FirstName.length() < 2)  {
            VFUtil.AddErrorMessage('First Name is required');
            iserror =false;
            system.debug('firstname error' +cnt.FirstName );
            return null ;
        }
        
        if (cnt.FirstName.isNumeric() || !cnt.FirstName.isAlpha() ) {
            VFUtil.AddErrorMessage('Please enter valid First Name. Please do not include Numbers ( 1, 2, 3, etc).');
            iserror =false;
            system.debug('firstname error' +cnt.FirstName );
            return null ;
        }
        
        if ( (cnt.LastName != null && cnt.LastName.length() < 2 ) ) {
            VFUtil.AddErrorMessage('Last Name is required');
            iserror =false;
            return null ;
        }
        
         if (cnt.LastName.isNumeric() || !cnt.LastName.isAlpha()) {
            VFUtil.AddErrorMessage('Please enter valid Last Name. Please do not include Numbers ( 1, 2, 3, etc).');
            iserror =false;
            system.debug('firstname error' +cnt.LastName);
            return null ;
        }
        
        if ( (acc.Name != null && acc.Name.length() < 2 ) ) {
            VFUtil.AddErrorMessage('Company Name is required');
            iserror =false;
            return null ;
        }
        
        if (acc.Name.isNumeric() ) {
            VFUtil.AddErrorMessage('Please enter valid Company Name. Please do not include Numbers ( 1, 2, 3, etc). ');
            iserror =false;
            system.debug('AccountName error' +acc.Name);
            return null ;
        }     
        if ( acc.Billing_Zip_Postal_Code__c != null && !Pattern.matches('^[0-9]{5}(?:-[0-9]{4})?$',acc.Billing_Zip_Postal_Code__c )) {
            VFUtil.AddErrorMessage('ZIP/Postal Code is required');
            iserror =false;
            system.debug('BillingZipCode error' +acc.Billing_Zip_Postal_Code__c);          
            return null ;
        }         
             
        
        String nameregex= '[\\p{L}\\s\\d]*$';
        Pattern myPattern = Pattern.compile(nameregex);
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher mynameMatcher = MyPattern.matcher(acc.Name);
        
        system.debug('firstname error' +mynameMatcher );
        
        if (!mynameMatcher.matches()) {
            
            VFUtil.AddErrorMessage('Please enter valid Company Name. Please do not include special characters ( -, &, #, etc).');
            iserror =false;
            return null;
        }              

        
        // validate phone fields
        if ( cnt.Phone != null && !Pattern.matches('^$|^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$|^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4} x[a-zA-Z0-9]{1,4}$', cnt.Phone) ) {
            cnt.Phone.addError('Phone number must be at least 10 digits long. Acceptable formats: (123) 456-7891 or (123) 456-7891 x1234');
            VFUtil.AddErrorMessage ('Phone number is not valid.');
            iserror =false;
            return null;
        }        
        
        if(!verified) {
            VFUtil.AddErrorMessage ('Please verify that you are not a Machine!');
            iserror =false;
            return null;
        }
        system.debug('account deatsil'+acc);
           
         system.debug(acc);
//            acc.BillingStreet = acc.ShippingStreet;
//            acc.Billingcity= acc.shippingcity;
//            acc.BillingState =acc.shippingState;
            acc.Billingpostalcode=acc.Billing_Zip_Postal_Code__c;
            acc.BillingCountry =acc.shippingCountry;
            acc.Primary_Contact_Name__c = cnt.FirstName + ' ' +cnt.LastName;
            acc.Demo__c='Two Demo';
              insert acc;
       
            cnt.AccountID=acc.id;
            cnt.Is_Primary__c = true;
            cnt.Is_DEMO__c = true;
             insert cnt;
        
            acc.Acct_Primary_Contact__c =cnt.id;
             update acc;
             
           IIT_PID_CID_check.output op =  IIT_PID_CID_check.noPID_noCID_noOFFC_AccID(null, null, null,acc.id)  ;
           try{
           UpdateTrialAccountInfoInDM.trialAccount(acc.id,Label.TWO_Trial_SKU);
           }catch (exception e) {}
             String url = '/apex/TWODemoThankYou?accuntId';
             return new PageReference( url);
        
    }
    
    public void verify() {
        onLoad = false;
        System.debug('reCAPTCHA verification attempt');
        // On first page load, form is empty, so no request to make yet
        if ( challenge == null || response == null ) { 
            System.debug('reCAPTCHA verification attempt with empty form');
            
            return; 
        }
                    
        HttpResponse r = makeRequest(baseUrl,
            'privatekey=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&challenge=' + challenge +
            '&response='  + response
        );
        
        if ( r!= null ) {
            this.verified = (r.getBody().startsWithIgnoreCase('true'));
        }
        
        if(this.verified) {
            // If they pass verification, you might do something interesting here
            // Or simply return a PageReference to the "next" page
            return;
        }
        else {
            // stay on page to re-try reCAPTCHA
             VFUtil.AddErrorMessage ('Please verify that you are not a Machine!');
            return; 
        }
    }

    /* Private helper methods */
    private static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('reCAPTCHA response: ' + response);
            System.debug('reCAPTCHA body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }   
        
    private String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null)
                ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }
 
 
 
}