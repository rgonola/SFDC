public with sharing class IIT_ControllerPaymentMethodDisplay {
    public list<invoiceit_s__Payment_Method__c> listofPM {get;set;}
    //string recordId ;
    public invoiceit_s__Payment_Method__c paymentMethod {get; set;}
    public invoiceit_s__Payment_Method__c displymnt{get; set;}
    public invoiceit_s__Payment_Method__c paymentMethod1 {get; set;}
    public list<invoiceit_s__Payment_Method__c> listofPMDefault;
    public account acc;
    public string smessege{get;set;}
    public boolean renderButton {get;set;}
    static transactionError trxError;
    Public string recordId {get;set;}
    String navigationPage;
    String navgateURL;
    String paymentmethodId ;
    String pmIdupdate ;
    public String payType {set;get;}
    public boolean isTermcondition{set;get;}
    invoiceit_s__Payment_Method__c updateToPM ;
    public string makede {get;set;}
    
    public boolean isCheckMethod{get;set;}
    public IIT_ControllerPaymentMethodDisplay(){
        isCheckMethod = false;
        recordId = system.currentPageReference().getParameters().get('Id');
        
        
        //navigationPage = system.currentPageReference().getParameters().get('navigate');
        navgateURL = system.currentPageReference().getParameters().get('redirectURL');
        listofPM = [SELECT Id,invoiceit_s__Account__r.CID__c,invoiceit_s__Account__r.PID__c, Last_4_Digits__c ,invoiceit_s__Bank_Account_Number__c, invoiceit_s__Bank_Account_Name__c ,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Payment_Method__c,invoiceit_s__Active__c,invoiceit_s__Account__r.Name,invoiceit_s__Account__c,invoiceit_s__Default__c,Name, invoiceit_s__Billing_Email__c FROM invoiceit_s__Payment_Method__c WHERE invoiceit_s__Account__c =: recordId and invoiceit_s__Active__c =true AND Customer_Deletion__c =false ORDER BY Name ASC NULLS FIRST];
        renderButton = true;
        isTermcondition = false;
        //recordId = system.currentPageReference().getParameters().get('Id');
        paymentmethodId = system.currentPageReference().getParameters().get('pmid');
        payType = system.currentPageReference().getParameters().get('pm');
        System.debug('paymentmethodIdpaymentmethodId-->'+payType);
        System.debug('paymentmethodIdpaymentmethodId-->'+paymentmethodId);
        paymentMethod =  new invoiceit_s__Payment_Method__c();
        paymentMethod1 = new invoiceit_s__Payment_Method__c();
        acc = [SELECT Billing_Street__c, Billing_City__c, Billing_Zip_Postal_Code__c, Billing_Country__c, Billing_State_Province__c,(SELECT Email,FirstName,Is_Primary__c,LastName FROM Contacts WHERE Is_Primary__c = true) FROM Account WHERE Id = :recordId];
        paymentMethod.invoiceit_s__Billing_Address__c = acc.Billing_Street__c;
        System.debug(''+acc);
        
            
        //Credit card address details will fill the form
        paymentMethod.invoiceit_s__Billing_City__c = acc.Billing_City__c;
        paymentMethod.invoiceit_s__Billing_State_Province__c = acc.Billing_State_Province__c;
        paymentMethod.invoiceit_s__Billing_Zip_Postal__c = acc.Billing_Zip_Postal_Code__c;
        paymentMethod.invoiceit_s__Billing_Country__c = acc.Billing_Country__c;
        paymentMethod.invoiceit_s__Account__c = recordId;
        paymentMethod.invoiceit_s__Payment_Method__c = 'Credit Card';
        if(acc.Contacts.size() > 0){
            paymentMethod.invoiceit_s__Billing_First_Name__c = acc.Contacts[0].FirstName;
            paymentMethod.invoiceit_s__Billing_Last_Name__c = acc.Contacts[0].LastName;
        }
        //ACH address details will fill in the form
        paymentMethod1.invoiceit_s__Billing_Address__c = acc.Billing_Street__c;
        paymentMethod1.invoiceit_s__Billing_City__c = acc.Billing_City__c;
        paymentMethod1.invoiceit_s__Billing_State_Province__c = acc.Billing_State_Province__c;
        paymentMethod1.invoiceit_s__Billing_Zip_Postal__c = acc.Billing_Zip_Postal_Code__c;
        paymentMethod1.invoiceit_s__Billing_Country__c = acc.Billing_Country__c;
        paymentMethod1.invoiceit_s__Account__c = recordId;
        paymentMethod1.invoiceit_s__Payment_Method__c = 'ACH';
        if(acc.Contacts.size() > 0){
            paymentMethod1.invoiceit_s__Billing_First_Name__c = acc.Contacts[0].FirstName;
            paymentMethod1.invoiceit_s__Billing_Last_Name__c = acc.Contacts[0].LastName;
        }      
    }
    public PageReference generateToken() { 
        
        if(navgateURL== 'null' || navgateURL == null || navgateURL == ''){
            PageReference pr = new PageReference('/apex/IIT_PaymentSiteProcess?id='+recordId);
            return pr;
        }else{
             PageReference pr = new PageReference(''+navgateURL);
            return pr;
        }
        
        return null;
    }
    String pmId ; 
    public PageReference makeDefault(){
    
    System.debug('Check box'+ApexPages.CurrentPage().getParameters().get('termselected'));
        //if(isCheckMethod){
            pmId = ApexPages.CurrentPage().getParameters().get('makede');
            
            system.debug('makede === ' + makede);
            listofPMDefault = [SELECT Id,invoiceit_s__Account__r.CID__c,invoiceit_s__Account__r.PID__c, Last_4_Digits__c,invoiceit_s__Payment_Profile_ID__c ,invoiceit_s__Bank_Account_Number__c, invoiceit_s__Bank_Account_Name__c ,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Payment_Method__c,invoiceit_s__Account__r.Name,invoiceit_s__Active__c,invoiceit_s__Account__c,invoiceit_s__Default__c,Name FROM invoiceit_s__Payment_Method__c WHERE invoiceit_s__Account__c =: recordId and invoiceit_s__Active__c =true and invoiceit_s__Default__c = true ORDER BY Name ASC NULLS FIRST];
            if(listofPMDefault.size() > 0){
                listofPMDefault[0].invoiceit_s__Default__c = false;
                update listofPMDefault ;
            }
            isTermcondition =true;
            invoiceit_s__Payment_Method__c pmToUpdate = new invoiceit_s__Payment_Method__c(id=pmId , invoiceit_s__Default__c = true);
            update pmToUpdate;
            listofPM = [SELECT Id,invoiceit_s__Account__r.CID__c,invoiceit_s__Account__r.PID__c, Last_4_Digits__c,invoiceit_s__Payment_Profile_ID__c ,invoiceit_s__Bank_Account_Number__c, invoiceit_s__Bank_Account_Name__c ,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Payment_Method__c,invoiceit_s__Account__r.Name,invoiceit_s__Active__c,invoiceit_s__Account__c,invoiceit_s__Default__c,Name FROM invoiceit_s__Payment_Method__c WHERE invoiceit_s__Account__c =: recordId and invoiceit_s__Active__c =true AND Customer_Deletion__c= FALSE ORDER BY Name ASC NULLS FIRST];
         //}else{
           //  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select terms & condition checkbox.');
            // ApexPages.addMessage(myMsg); 
         //}       
        return null;
    }
    public PageReference updateToken(){
        renderButton = false;
         
        pmIdupdate = ApexPages.CurrentPage().getParameters().get('updateT');
        
        /*PageReference pr = new PageReference('/apex/IIT_SitePaymentTokenGenerate?id='+recordId+'&pmid='+pmIdupdate);
        return pr;*/
        updateToPM = [SELECT Id, invoiceit_s__Account__r.CID__c,invoiceit_s__Account__r.PID__c,invoiceit_s__Billing_First_Name__c ,invoiceit_s__Billing_Address__c,invoiceit_s__Billing_Country__c,invoiceit_s__Billing_Zip_Postal__c,invoiceit_s__Billing_State_Province__c,invoiceit_s__Billing_City__c, invoiceit_s__Billing_Last_Name__c ,invoiceit_s__Payment_Profile_ID__c ,invoiceit_s__Billing_Email__c ,invoiceit_s__Name_on_Card__c ,Last_4_Digits__c ,invoiceit_s__Bank_Account_Number__c, invoiceit_s__Bank_Account_Name__c ,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Payment_Method__c,invoiceit_s__Account__r.Name,invoiceit_s__Active__c,invoiceit_s__Account__c,invoiceit_s__Default__c,Name FROM invoiceit_s__Payment_Method__c WHERE id =:pmIdupdate];
        paymentMethod.invoiceit_s__Billing_First_Name__c = updateToPM.invoiceit_s__Billing_First_Name__c;
        paymentMethod.invoiceit_s__Billing_Last_Name__c = updateToPM.invoiceit_s__Billing_Last_Name__c;
        paymentMethod.invoiceit_s__Card_Type__c = updateToPM.invoiceit_s__Card_Type__c;
        paymentMethod.invoiceit_s__Card_Number__c = updateToPM.invoiceit_s__Card_Number__c;
        paymentMethod.invoiceit_s__Name_on_Card__c = updateToPM.invoiceit_s__Name_on_Card__c;
        paymentMethod.invoiceit_s__Card_Expiration_Month__c = updateToPM.invoiceit_s__Card_Expiration_Month__c;
        paymentMethod.invoiceit_s__Card_Expiration_Year__c = updateToPM.invoiceit_s__Card_Expiration_Year__c; 
        //paymentMethod.invoiceit_s__Card_Expiration_Year__c = updateToPM.invoiceit_s__Card_Expiration_Year__c;
        paymentMethod.invoiceit_s__Billing_Email__c = updateToPM.invoiceit_s__Billing_Email__c;
        paymentMethod.invoiceit_s__Billing_Address__c = updateToPM.invoiceit_s__Billing_Address__c;
        paymentMethod.invoiceit_s__Billing_City__c = updateToPM.invoiceit_s__Billing_City__c;
        paymentMethod.invoiceit_s__Billing_State_Province__c = updateToPM.invoiceit_s__Billing_State_Province__c;
        paymentMethod.invoiceit_s__Billing_Zip_Postal__c = updateToPM.invoiceit_s__Billing_Zip_Postal__c;
        paymentMethod.invoiceit_s__Billing_Country__c = updateToPM.invoiceit_s__Billing_Country__c;

        /*ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(acc);
        invoiceit_s.ControllerForUpdateTokenForCyberSource createUpdateTokenController1 = new invoiceit_s.ControllerForUpdateTokenForCyberSource(controller);
        createUpdateTokenController1.paymentMethod  = paymentMethod;
        //createUpdateTokenController1.updateToken();
        //System.debug(createUpdateTokenController1.paymentMethod);
        
        smessege = createUpdateTokenController1.sMessege;*/
        //PageReference pr = new PageReference('/apex/IIT_PaymentMethodProcess?id='+recordId);
        //pr.setredirect(true);
        return null;
        
    }
    
    
    public PageReference updateButton(){
    
        invoiceit_s__Payment_Method__c pmTocken = new invoiceit_s__Payment_Method__c();
        paymentMethod.invoiceit_s__Payment_Profile_ID__c = updateToPM.invoiceit_s__Payment_Profile_ID__c;
        paymentMethod.id = updateToPM.id;
        ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(acc);
        invoiceit_s.ControllerForUpdateTokenForCyberSource createUpdateTokenController1 = new invoiceit_s.ControllerForUpdateTokenForCyberSource(controller);
        createUpdateTokenController1.paymentMethod  = paymentMethod;
        createUpdateTokenController1.updateToken();
        System.debug(createUpdateTokenController1.paymentMethod);
        pmTocken = createUpdateTokenController1.paymentMethod;
        smessege = createUpdateTokenController1.sMessege;
        
        paymentMethod = pmTocken.clone(false);
        paymentMethod.invoiceit_s__Card_Number__c = '';
        paymentMethod.invoiceit_s__Name_on_Card__c = '';
        paymentMethod.invoiceit_s__Card_Expiration_Month__c = '';
        paymentMethod.invoiceit_s__Card_Expiration_Year__c = ''; 
        paymentMethod.invoiceit_s__Card_Expiration_Year__c = '';
        paymentMethod.invoiceit_s__Billing_Email__c = '';
        //state
        if(acc.Billing_State_Province__c != '' ){
             paymentMethod.invoiceit_s__Billing_State_Province__c = acc.Billing_State_Province__c;
        }else{
            paymentMethod.invoiceit_s__Billing_State_Province__c ='' ;
        }
        //city
        if(acc.Billing_City__c != '' ){
             paymentMethod.invoiceit_s__Billing_City__c = acc.Billing_City__c;
        }else{
            paymentMethod.invoiceit_s__Billing_City__c = '';
        }
        //Zip code
        if(acc.Billing_Zip_Postal_Code__c != '' ){
              paymentMethod.invoiceit_s__Billing_Zip_Postal__c = acc.Billing_Zip_Postal_Code__c;
        }else{
            paymentMethod.invoiceit_s__Billing_Zip_Postal__c = '';
        }
        //country
        if(acc.Billing_Country__c != '' ){
              paymentMethod.invoiceit_s__Billing_Country__c = acc.Billing_Country__c;
        }else{
            paymentMethod.invoiceit_s__Billing_Country__c = '';
        }
        //paymentMethod.invoiceit_s__Billing_Address__c = acc.Billing_Street__c;
        if(acc.Billing_Street__c != '' ){
              paymentMethod.invoiceit_s__Billing_Address__c = acc.Billing_Street__c;
        }else{
            paymentMethod.invoiceit_s__Billing_Address__c = '';
        }
        
        paymentMethod.invoiceit_s__Billing_First_Name__c = '';
        paymentMethod.invoiceit_s__Billing_Last_Name__c = '';
        
        if(acc.Contacts.size() > 0){

            if(acc.Contacts[0].FirstName != ''){
                paymentMethod.invoiceit_s__Billing_First_Name__c = acc.Contacts[0].FirstName;
            }            
            if(acc.Contacts[0].LastName != ''){
                paymentMethod.invoiceit_s__Billing_Last_Name__c = acc.Contacts[0].LastName;
            }
            
        }
        if(smessege == 'Success'){
            renderButton = true;
           listofPM = [SELECT Id,invoiceit_s__Account__r.CID__c,invoiceit_s__Account__r.PID__c, Last_4_Digits__c,invoiceit_s__Payment_Profile_ID__c ,invoiceit_s__Bank_Account_Number__c, invoiceit_s__Bank_Account_Name__c ,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Payment_Method__c,invoiceit_s__Account__r.Name,invoiceit_s__Active__c,invoiceit_s__Account__c,invoiceit_s__Default__c,Name FROM invoiceit_s__Payment_Method__c WHERE invoiceit_s__Account__c =: recordId and invoiceit_s__Active__c =true AND Customer_Deletion__c=FALSE ORDER BY Name ASC NULLS FIRST];
            //return pr; 
        }
       
        return null;
        
    }
    public pageReference GenerateTokenPM() {
         //navigationPage = system.currentPageReference().getParameters().get('navigate');
        navgateURL = system.currentPageReference().getParameters().get('redirectURL');
         invoiceit_s__Payment_Method__c pmTocken = new invoiceit_s__Payment_Method__c();
         invoiceit_s__Payment_Method__c pmTockennew = new invoiceit_s__Payment_Method__c();
        paymentMethod.invoiceit_s__Payment_Method__c = 'Credit Card';
        System.debug('SDSsass'+paymentMethod);
        ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(acc);
        invoiceit_s.ControllerForGenerateTokenForCyberSource createTokenController = new invoiceit_s.ControllerForGenerateTokenForCyberSource(controller);
        createTokenController.paymentMethod  = paymentMethod;
        //System.debug('Generate -->'+createTokenController.generateToken());
        createTokenController.generateToken();
        pmTocken = createTokenController.paymentMethod ;
        
        System.debug('Payment method new '+pmTocken);
        
        smessege = createTokenController.sMessege;
        System.debug('smessegesmessege'+smessege); 
        paymentMethod = pmTocken.clone(false);
        paymentMethod.invoiceit_s__Card_Number__c = '';
        paymentMethod.invoiceit_s__Name_on_Card__c = '';
        paymentMethod.invoiceit_s__Card_Expiration_Month__c = '';
        paymentMethod.invoiceit_s__Card_Expiration_Year__c = ''; 
        paymentMethod.invoiceit_s__Card_Expiration_Year__c = '';
        paymentMethod.invoiceit_s__Billing_Email__c = '';
        //state
        if(acc.Billing_State_Province__c != '' ){
             paymentMethod.invoiceit_s__Billing_State_Province__c = acc.Billing_State_Province__c;
        }else{
            paymentMethod.invoiceit_s__Billing_State_Province__c ='' ;
        }
        //city
        if(acc.Billing_City__c != '' ){
             paymentMethod.invoiceit_s__Billing_City__c = acc.Billing_City__c;
        }else{
            paymentMethod.invoiceit_s__Billing_City__c = '';
        }
        //Zip code
        if(acc.Billing_Zip_Postal_Code__c != '' ){
              paymentMethod.invoiceit_s__Billing_Zip_Postal__c = acc.Billing_Zip_Postal_Code__c;
        }else{
            paymentMethod.invoiceit_s__Billing_Zip_Postal__c = '';
        }
        //country
        if(acc.Billing_Country__c != '' ){
              paymentMethod.invoiceit_s__Billing_Country__c = acc.Billing_Country__c;
        }else{
            paymentMethod.invoiceit_s__Billing_Country__c = '';
        }
        //paymentMethod.invoiceit_s__Billing_Address__c = acc.Billing_Street__c;
        if(acc.Billing_Street__c != '' ){
              paymentMethod.invoiceit_s__Billing_Address__c = acc.Billing_Street__c;
        }else{
            paymentMethod.invoiceit_s__Billing_Address__c = '';
        }
        
        paymentMethod.invoiceit_s__Billing_First_Name__c = '';
        paymentMethod.invoiceit_s__Billing_Last_Name__c = '';
        
        if(acc.Contacts.size() > 0){

            if(acc.Contacts[0].FirstName != ''){
                paymentMethod.invoiceit_s__Billing_First_Name__c = acc.Contacts[0].FirstName;
            }            
            if(acc.Contacts[0].LastName != ''){
                paymentMethod.invoiceit_s__Billing_Last_Name__c = acc.Contacts[0].LastName;
            }
            
        }
        
        PageReference pr;
        if(smessege == 'Success'){
           pr = new PageReference('/apex/IIT_PaymentMethodProcess?id='+recordId+'&redirectURL='+navgateURL);
           listofPM = [SELECT Id,invoiceit_s__Account__r.CID__c,invoiceit_s__Account__r.PID__c, Last_4_Digits__c ,invoiceit_s__Bank_Account_Number__c, invoiceit_s__Bank_Account_Name__c ,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Payment_Method__c,invoiceit_s__Account__r.Name,invoiceit_s__Active__c,invoiceit_s__Account__c,invoiceit_s__Default__c,Name FROM invoiceit_s__Payment_Method__c WHERE invoiceit_s__Account__c =: recordId and invoiceit_s__Active__c =true AND Customer_Deletion__c =FALSE ORDER BY Name ASC NULLS FIRST];
            pr.setredirect(true);
            return pr; 
        }
         
        return null;
  
    }
    public pageReference CancelButton() {
        
        PageReference pr = new PageReference('/apex/IIT_PaymentMethodProcess?id='+recordId);
        pr.setredirect(true);
        return pr; 
    }
    
     public pageReference Addcc() {
        
        PageReference pr = new PageReference('/apex/CreatecreditcardForPortal?id='+recordId);
        pr.setredirect(true);
        return pr; 
    }
    
    public pageReference AddAch() {
        
        PageReference pr = new PageReference('/apex/CreateachforPortal?id='+recordId);
        pr.setredirect(true);
        return pr; 
    }
    
    public pageReference Deletepaymnt() {
        
        String deletepid= system.currentPageReference().getParameters().get('pid');
        
        listofPM = [SELECT Id,invoiceit_s__Account__r.CID__c,Customer_Deletion__c,invoiceit_s__Card_Expiration_Month__c,invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Payment_Method__c,invoiceit_s__Active__c,invoiceit_s__Account__r.Name,invoiceit_s__Account__c,invoiceit_s__Default__c,Name, invoiceit_s__Billing_Email__c FROM invoiceit_s__Payment_Method__c WHERE id=:deletepid Limit 1];
        
        listofPM[0].Customer_Deletion__c= true;
        
        update listofPM[0] ;
        
        PageReference pr = new PageReference('/apex/IIT_PaymentMethodProcess?id='+recordId);
        pr.setredirect(true);
        return pr; 
    }
    
    public pageReference createACH() {

        //navigationPage = system.currentPageReference().getParameters().get('navigate');
        navgateURL = system.currentPageReference().getParameters().get('redirectURL');
    list<invoiceit_s__Payment_Method__c> listofpaymentnew = new list<invoiceit_s__Payment_Method__c>();
        invoiceit_s__Payment_Method__c pay23 = new invoiceit_s__Payment_Method__c();
        paymentMethod1.invoiceit_s__Payment_Method__c= 'ACH';
        System.debug('ACH Payment method-->'+paymentMethod);
        
        
        
        String tokenId=CyberSourceConnection.getTokenFromACH(paymentMethod1);
        
        //Store only last four from Account Number
        
        if(paymentMethod1.invoiceit_s__Bank_Account_Number__c.length() >4){
        Integer len= paymentMethod1.invoiceit_s__Bank_Account_Number__c.length();
        Integer substringval;
        
        substringval = len-4;
        
        paymentMethod1.invoiceit_s__Bank_Account_Number__c= paymentMethod1.invoiceit_s__Bank_Account_Number__c.substring(substringval,len);
        }
        
        //Store only last four from Routing Number
       /* if(paymentMethod.invoiceit_s__Bank_Routing_Code__c.length() >4){
        Integer routlen= paymentMethod.invoiceit_s__Bank_Routing_Code__c.length();
        Integer routsubstringval;
        
        routsubstringval = routlen-4;
        
        paymentMethod.invoiceit_s__Bank_Routing_Code__c= paymentMethod.invoiceit_s__Bank_Routing_Code__c.substring(routsubstringval,routlen);
        
        }*/
        trxError = transactionError.instance;
        
        if (trxError.errorFound) {
        VFUtil.AddErrorMessage ( trxError.errorMessage);
        return null;
        
        } 

        if(!String.isBlank(tokenId)){
        paymentMethod1.invoiceit_s__Payment_Profile_ID__c=tokenId;
        }else{
       
       VFUtil.AddErrorMessage ('Something Went wrong,Please retry the request again.');
        return null;
        

        }
        
        insert paymentMethod1;
        
        
        pay23 = paymentMethod1.clone(false);
        pay23.invoiceit_s__Bank_Account_Name__c = '';
        pay23.invoiceit_s__Bank_Account_Number__c = '';
        pay23.invoiceit_s__Bank_Account_Type__c ='';
        pay23.invoiceit_s__Bank_Name__c = '';
        pay23.invoiceit_s__Bank_Routing_Code__c = '';
        pay23.invoiceit_s__Billing_Email__c ='';
        //state
        if(acc.Billing_State_Province__c != '' ){
             pay23.invoiceit_s__Billing_State_Province__c = acc.Billing_State_Province__c;
        }else{
            pay23.invoiceit_s__Billing_State_Province__c ='' ;
        }
        //city
        if(acc.Billing_City__c != '' ){
             pay23.invoiceit_s__Billing_City__c = acc.Billing_City__c;
        }else{
            pay23.invoiceit_s__Billing_City__c = '';
        }
        //Zip code
        if(acc.Billing_Zip_Postal_Code__c != '' ){
              pay23.invoiceit_s__Billing_Zip_Postal__c = acc.Billing_Zip_Postal_Code__c;
        }else{
            pay23.invoiceit_s__Billing_Zip_Postal__c = '';
        }
        //country
        if(acc.Billing_Country__c != '' ){
              pay23.invoiceit_s__Billing_Country__c = acc.Billing_Country__c;
        }else{
            pay23.invoiceit_s__Billing_Country__c = '';
        }
        //paymentMethod.invoiceit_s__Billing_Address__c = acc.Billing_Street__c;
        if(acc.Billing_Street__c != '' ){
              pay23.invoiceit_s__Billing_Address__c = acc.Billing_Street__c;
        }else{
            pay23.invoiceit_s__Billing_Address__c = '';
        }
        if(acc.Contacts.size() > 0){
            System.debug('Coming contact loop');
            //FirstName
            if(acc.Contacts[0].FirstName != ''){
                pay23.invoiceit_s__Billing_First_Name__c = acc.Contacts[0].FirstName;
            }else{
                pay23.invoiceit_s__Billing_First_Name__c = '';
            }
            //LastName
            if(acc.Contacts[0].LastName != ''){
                pay23.invoiceit_s__Billing_Last_Name__c = acc.Contacts[0].LastName;
            }else{
                pay23.invoiceit_s__Billing_Last_Name__c = '';
            }
            
        }else {
            pay23.invoiceit_s__Billing_First_Name__c = '';
            pay23.invoiceit_s__Billing_Last_Name__c = '';
        }
        paymentMethod1 = new invoiceit_s__Payment_Method__c();
        paymentMethod1 = pay23;
        
        //listofPM.add(paymentMethod);
        listofPM = [SELECT Id,invoiceit_s__Account__r.CID__c,invoiceit_s__Account__r.PID__c, Last_4_Digits__c,invoiceit_s__Payment_Profile_ID__c ,invoiceit_s__Bank_Account_Number__c, invoiceit_s__Bank_Account_Name__c ,invoiceit_s__Card_Number__c,invoiceit_s__Card_Type__c,invoiceit_s__Card_Expiration_Month__c,invoiceit_s__Card_Expiration_Year__c,invoiceit_s__Payment_Method__c,invoiceit_s__Account__r.Name,invoiceit_s__Active__c,invoiceit_s__Account__c,invoiceit_s__Default__c,Name FROM invoiceit_s__Payment_Method__c WHERE invoiceit_s__Account__c =: recordId and invoiceit_s__Active__c =true ORDER BY Name ASC NULLS FIRST];
         
        PageReference pr = new PageReference('/apex/IIT_PaymentMethodProcess?id='+recordId+'&redirectURL='+navgateURL);
        pr.setredirect(true);
        return pr; 
    }
    
    
    

}