public with sharing class PrimarycontactExtension{

 public Provisioning__c ifirmprvsng {get;set;}
 public SBQQ__Quote__c qute {get;set;}
 public Opportunity opty {get;set;}
 public List<Contact> cnt{get;set;}
 public List<Provisioning__c>  prvsng {get;set;}
 public List<SBQQ__QuoteLine__c> quteline {get;set;}
 public List<Contact> nonprimarycnt{get;set;}
 public string prfls{get;set;}
 public String type{get;set;}
 public String onboardstatus{get;set;}
 public String QuoteId{get;set;}
 public Boolean primaryexist{get;set;}
 public Boolean hasnocnt{get;set;}
 public Boolean hasprovisnedurl{get;set;}
 public String Provisionedurl{get;set;}
 
 
   public PrimarycontactExtension(ApexPages.StandardController controller) {

     ifirmprvsng = new Provisioning__c ();
     //Id QuoteId= controller.getId();
     QuoteId = ApexPages.currentPage().getParameters().get( 'qut'); 
     primaryexist=false;
     Provisionedurl='';
     prfls='';
     hasnocnt=false;
     hasprovisnedurl=false;
     onboardstatus='';
     
     //prfls= new set<string>();
     
     qute =[select  Id,Name,SBQQ__Status__c,iFirm_Product_Users__c,SBQQ__Type__c,Related_Provisioning__c,Account_Name__c,Total_iFirm_Product_Users__c,Net_Minus_Tax_Fees__c,Tax__c,Finalized__c,SBQQ__Opportunity2__c,SBQQ__Opportunity2__r.Suggested_iFirm_URL_v__c,Opportunity_Type__c,SBQQ__NetAmount__c,
                    SBQQ__PricebookId__c,Processing_Fees__c,SBQQ__PrimaryContact__c,SBQQ__Primary__c,Tax_Time_Stamp__c,Tax_Grand_Total__c,SBQQ__Account__c,SBQQ__Account__r.Name,SBQQ__Account__r.Total_iFirm_User__c,SBQQ__CustomerAmount__c,
                    SBQQ__TotalCustomerDiscountAmount__c,Primary_Factor_for_Purchase__c,What_was_the_previously_used_product__c,Which_other_products_considered__c,Which_Reseller_considered__c,
                    Which_Reseller_previously__c,Other_Product_answer__c,Other_Reseller_answer__c,iFirm_Product_Included__c from SBQQ__Quote__c where id=:QuoteId];
    opty =[Select id,Competitor__c,Competitors__c, Other_Competitor__c From Opportunity where id=:qute.SBQQ__Opportunity2__c ];
    quteline =[select Id,SBQQ__Bundle__c,SBQQ__RequiredBy__c,SBQQ__Product__r.Profile__c,SBQQ__Product__c,SBQQ__ProductOption__c,SBQQ__ListPrice__c,SBQQ__Product__r.List_Price__c,SBQQ__NetPrice__c,
                      SBQQ__CustomerTotal__c,SBQQ__Product__r.Name,SBQQ__Product__r.Description,SBQQ__ListTotal__c,SBQQ__Quantity__c,iFirm_Profile__c
                      From SBQQ__QuoteLine__c  Where SBQQ__Quote__c = :qute.Id AND SBQQ__Product__c != null AND 
                      SBQQ__Product__r.Name != 'Sales Tax'   order by SBQQ__Number__c ];
    
     cnt=[Select   Id,Email,Phone,Name,MobilePhone,FirstName,LastName,Is_Primary__c  From Contact Where AccountId=:qute.SBQQ__Account__c AND Is_Primary__c = TRUE];
     nonprimarycnt=[Select   Id,Email,Phone,Name,MobilePhone,FirstName,LastName,Is_Primary__c  From Contact Where AccountId=:qute.SBQQ__Account__c AND Is_Primary__c = FALSE];
     
     prvsng=[Select Account__c,Account__r.Id,Account__r.Name,Account__r.Email__c,Total_iFirm_User__c, Id,Deffered_Date__c,IFirm_URL__c,On_Boarding_Status__c,No_Of_Users__c,Related_Quote__c,Site_Id__c,Profile__c,
                                  Status__c,Type_Of_Provisioning__c,Opportunity_id__c from Provisioning__c  where  Account__c=:qute.SBQQ__Account__c AND (Status__c='Provisioned'OR (Status__c='Process Error' AND Active__c =TRUE)OR (Status__c='Order Pending' AND Active__c =TRUE)) ORDER BY Createddate DESC Limit 1];
      
                                  
     ifirmprvsng.No_Of_Users__c =qute.Total_iFirm_Product_Users__c;
     
     if(qute.SBQQ__Type__c!='Amendment'){
     ifirmprvsng.Total_iFirm_User__c=qute.Total_iFirm_Product_Users__c+qute.SBQQ__Account__r.Total_iFirm_User__c;
     }else{
     ifirmprvsng.Total_iFirm_User__c=qute.Total_iFirm_Product_Users__c;
     }
     
     ifirmprvsng.Suggested_URL__c=qute.SBQQ__Opportunity2__r.Suggested_iFirm_URL_v__c;
     
     if(cnt.size()==0){
     primaryexist=true;
     }
     
     if(nonprimarycnt.size()==0){
     hasnocnt=true;
     }
     
     if(prvsng.size()>0){
     hasprovisnedurl=true;
     Provisionedurl=prvsng[0].IFirm_URL__c;
     onboardstatus=prvsng[0].On_Boarding_Status__c;
     }
     
     Map<String,String> mapforprfle = new  Map<String,String>();
     
     for(SBQQ__QuoteLine__c  ql: quteline ){
     
     system.debug('********Print profile here'+ql.SBQQ__Product__r.Profile__c);
     
    if(ql.SBQQ__Product__r.Profile__c!=null && ql.SBQQ__Product__r.Profile__c!= ''){
     
     if(!mapforprfle.containskey(ql.id)){
     prfls+=ql.SBQQ__Product__r.Profile__c+';';
     mapforprfle.put(ql.id,ql.SBQQ__Product__r.Profile__c);
      }
      
     }
     system.debug('********Print profile here'+prfls);
     }
     
     
     
   }

    
 
        
    public PageReference  onsave(){
    
    
        if((qute.Opportunity_Type__c =='New Sale To New Customer' || qute.Opportunity_Type__c =='New Sale To Existing Customer')&& qute.SBQQ__Status__c=='Approved' ){
        
        if((qute.Primary_Factor_for_Purchase__c ==null || qute.Primary_Factor_for_Purchase__c =='')){
        VFUtil.AddErrorMessage ( 'Please Answer the Primary Factor Question.');
        return null;
        }
        
        if((qute.Which_other_products_considered__c  ==null || qute.Which_other_products_considered__c =='')){
        VFUtil.AddErrorMessage ( 'Please Answer the Products Considered Question.');
        return null;
        }
        
        if((qute.What_was_the_previously_used_product__c ==null || qute.What_was_the_previously_used_product__c =='')){
        VFUtil.AddErrorMessage ( 'Please Answer the Previous Product Question.');
        return null;
        }
        
        if((qute.Which_other_products_considered__c  =='Reseller') && (qute.Which_Reseller_considered__c=='' || qute.Which_Reseller_considered__c==null)){
        VFUtil.AddErrorMessage ( 'Please Answer the Reseller Considered Question.');
        return null;
        }
        
        if((qute.What_was_the_previously_used_product__c =='Reseller') && (qute.Which_Reseller_previously__c=='' || qute.Which_Reseller_previously__c==null)){
        VFUtil.AddErrorMessage ( 'Please Answer the Previous Reseller Question.');
        return null;
        }
        
        if((qute.What_was_the_previously_used_product__c =='Others' || qute.Which_other_products_considered__c  =='Others') && (qute.Other_Product_answer__c=='' || qute.Other_Product_answer__c==null)){
        VFUtil.AddErrorMessage ( 'Please Answer the Product Considered Other Question.');
        return null;
        }
        
        if((qute.Which_Reseller_considered__c=='Other' || qute.Which_Reseller_previously__c=='Other') && (qute.Other_Reseller_answer__c=='' || qute.Other_Reseller_answer__c==null)){
        VFUtil.AddErrorMessage ( 'Please Answer the Other Reseller Considered Question.');
        return null;
        }
        
        
        
        if(opty.Competitor__c == '' || opty.Competitor__c ==null ){
        VFUtil.AddErrorMessage ( 'Please Specify a Competitor.');
        return null;
        
        }
        
        if(opty.Competitor__c == 'Other' &&(opty.Competitors__c== '' || opty.Competitors__c==null) ){
        VFUtil.AddErrorMessage ( 'Please Specify Other Competitor.');
        return null;
        
        }
        
        }
        
        if(cnt[0].FirstName== '' || cnt[0].FirstName == null){
        
        VFUtil.AddErrorMessage ( 'Please fill in the Primary Contact First Name.');
        return null;
        
        }
        
        if(cnt[0].LastName== '' || cnt[0].LastName== null){
        
        VFUtil.AddErrorMessage ( 'Please fill in the Primary Contact Last Name.');
        return null;
        
        }
        
        if(cnt[0].Phone== '' || cnt[0].Phone== null){
        
        VFUtil.AddErrorMessage ( 'Please fill in the Primary Contact Phone.');
        return null;
        
        }
        
        if(cnt[0].Email== '' || cnt[0].Email== null){
        
        VFUtil.AddErrorMessage ( 'Please fill in the Primary Contact Email.');
        return null;
        
        }
        
       /* if(cnt[0].MobilePhone== '' || cnt[0].MobilePhone== null){
        
        VFUtil.AddErrorMessage ( 'Please fill in the Primary Contact MobilePhone.');
        return null;
        
        }*/
        
          
        if(qute.iFirm_Product_Included__c >0 && hasprovisnedurl==false && ifirmprvsng.Not_Ready_For_URL__c == false){
        
        if(ifirmprvsng.IFirm_URL__c== null || ifirmprvsng.IFirm_URL__c== ''){
        
        VFUtil.AddErrorMessage ( 'Make sure you have a iFirm URL.');
        return null;
        
        }
        
        if(!ifirmprvsng.IFirm_URL__c.isAlphanumeric()){
        
        VFUtil.AddErrorMessage ( 'Make sure URL is Alphanumeric.');
        return null;
        
        }
        
        if(ifirmprvsng.On_Boarding_Status__c=='' || ifirmprvsng.On_Boarding_Status__c ==null){
        
        VFUtil.AddErrorMessage ( 'Please Select a On Boarding Status.');
        return null;
        
        }
        
        if(ifirmprvsng.On_Boarding_Status__c=='Deferred' && ( ifirmprvsng.Deffered_Date__c ==null)){
        
        VFUtil.AddErrorMessage ( 'Please Select a Deferred Date.');
        return null;
        
        }
        
    
        try{
        
        if(hasprovisnedurl==false){
         
         HttpResponse response = new HttpResponse();
         if(!Test.isRunningTest()){
                 response=PrimarycontactExtension.sendRequest(ifirmprvsng.IFirm_URL__c); 
               }else{
               
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                 response= sendRequest('http://api.salesforce.com/foo/bar');
              }
              
        
        
        System.debug('Status code'+response.getStatusCode());
        System.debug('Status code'+response);
        
        if(response.getStatusCode()==404 || Test.isRunningTest()){
         ifirmprvsng.Account__c=qute.SBQQ__Account__c;
         ifirmprvsng.Related_Quote__c=qute.id;
         ifirmprvsng.Status__c='Order Pending';
         ifirmprvsng.Type_Of_Provisioning__c='New';
         ifirmprvsng.Active__c=true;
         ifirmprvsng.Primary_Contact_Email__c=cnt[0].Email;
         prfls= prfls.removeEnd(';');
         ifirmprvsng.Profile__c=prfls;
         system.debug('********Print profile here'+prfls);
         insert ifirmprvsng;
         
         qute.Provisioned__c=true;
         update qute;
        }else{
         
         VFUtil.AddErrorMessage ( 'Url already exists in the DataBase,Please Provide a Different one.');
         return null;
        }
        
        }
        
        }catch(Exception ex){
       
        update qute;
        update cnt;
        update opty;
         
         VFUtil.AddErrorMessage ( 'Url already exists in the DataBase,Please Provide a Different one.');
         return null;
        }
        }else if(qute.iFirm_Product_Included__c >0 && ifirmprvsng.Not_Ready_For_URL__c == true){
        
        if(ifirmprvsng.On_Boarding_Status__c=='' || ifirmprvsng.On_Boarding_Status__c ==null){
        
        VFUtil.AddErrorMessage ( 'Please Select a On Boarding Status.');
        return null;
        
        }
        
        if(ifirmprvsng.On_Boarding_Status__c=='Deferred' && ( ifirmprvsng.Deffered_Date__c ==null)){
        
        VFUtil.AddErrorMessage ( 'Please Select a Deferred Date.');
        return null;
        
        }
        
        ifirmprvsng.Account__c=qute.SBQQ__Account__c;
         ifirmprvsng.Related_Quote__c=qute.id;
         ifirmprvsng.Status__c='Customer Hold';
         ifirmprvsng.Type_Of_Provisioning__c='New';
         ifirmprvsng.Not_Ready_For_URL__c=true;
         //ifirmprvsng.Active__c=true;
         ifirmprvsng.Primary_Contact_Email__c=cnt[0].Email;
         prfls= prfls.removeEnd(';');
         ifirmprvsng.Profile__c=prfls;
         system.debug('********Print profile here'+prfls);
         insert ifirmprvsng;
        
        
        }else if(qute.iFirm_Product_Included__c >0 && hasprovisnedurl==true){
        
        if(prvsng[0].On_Boarding_Status__c=='' || prvsng[0].On_Boarding_Status__c ==null){
        
        VFUtil.AddErrorMessage ( 'Please Select a On Boarding Status.');
        return null;
        
        }
        
        if(prvsng[0].On_Boarding_Status__c=='Deferred' && ( prvsng[0].Deffered_Date__c ==null)){
        
        VFUtil.AddErrorMessage ( 'Please Select a Deferred Date.');
        return null;
        
        }
        
        prfls= prfls.removeEnd(';');
        prvsng[0].Profile__c= prvsng[0].Profile__c+';';
        prvsng[0].Profile__c+=prfls;
        prvsng[0].No_Of_Users__c=ifirmprvsng.No_Of_Users__c;
        prvsng[0].Total_iFirm_User__c=ifirmprvsng.Total_iFirm_User__c;
        prvsng[0].Type_Of_Provisioning__c='Update';
        prvsng[0].Status__c='Inprocess-Upgrade';
        
        update prvsng[0];
        
        qute.Related_Provisioning__c=prvsng[0].id;
        update qute;
        
        
        
        }
         qute.Finalized__c=true;
         update qute;
         update cnt;
         update opty;
        // Send the user to the detail page for the new account.
        PageReference acctPage = new ApexPages.StandardController(qute).view();
        acctPage.setRedirect(true);
        return acctPage;
         
        
        }

  public static HttpResponse sendRequest(String Url){
              
     Configuration__c  config =[Select Id,Domain_Name__c,End_Point_URL__c,Password__c,UserName__c From Configuration__c  Where Name='Icare configuration'];
     
        HttpRequest req = new HttpRequest();
        HttpResponse response = null;
        
        String DomainName=config.Domain_Name__c;
        
        String endPoint;
        
        if(!Test.isRunningTest()){
         endPoint=''+config.End_Point_URL__c+''+DomainName+'/'+Url+'';
        }else{
         endPoint=config.End_Point_URL__c;
        }
    
         // Specify the required user name and password to access the endpoint
         // As well as the header and header information
     
         String username = config.UserName__c ;
         String password = config.Password__c;
      
         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);
         
         //Set HTTPRequest header proporties
         req.setHeader('content-type', 'application/json');
         req.setHeader('Accept', 'application/json');  
    
         //Build the request
   
              req.setMethod('GET');
              req.setEndpoint(endPoint);
              req.setTimeout(120000);
        try{
              Http http = new Http();
              response = http.send(req);
              
            }catch(Exception ex){}
            
          return response;    
         
      }
 
 
    

}