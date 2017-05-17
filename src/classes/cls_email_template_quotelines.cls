public class cls_email_template_quotelines {
    //capture the quote id
    public Id myQuoteId{get;set;}
    //public Id myOrderId {get;set;}
    public String emailorattach{get;set;}
    public String accountOrderNumber{get;set;}
    public String firstName{get;set;}
    public String lastName{get;set;}
    public String Phone{get;set;}
    public String email{get;set;}   
    public Boolean order_atx{get;set;}             
    public Boolean order_tw{get;set;}
    public Boolean order_ifirm{get;set;}
    public Boolean order_default{get;set;}

    //public invoiceit_s__Job__c myOrder{get;set;}

    public String myLogoPath{get{
        String returnString='';
        try{
             String logodocId=[Select id from Document where DeveloperName='Wolters_Kluwer_Logo' LIMIT 1].id;
            String orgId=UserInfo.getOrganizationId();
            String instance=[SELECT IsSandbox,InstanceName from Organization].InstanceName;
            
            //if(instance.contains('CS')){
                returnString='https://c.' + instance + '.content.force.com/servlet/servlet.ImageServer?id=' + logodocId + '&oid=' + orgId;
            //}
            
            //if(instance.contains('NA')){
                
                //returnString='https://c.' + instance + '.content.force.com/servlet/servlet.ImageServer?id=' + logodocId + '&oid=' + orgId;
            //}
            }catch(QueryException q){
                returnString='';
            }
           
            return returnString;
        }
        set;}
        
        /*
        public String mydisclaimerPath{get{
        String returnString='';
        try{
             String logodocId=[Select id from Document where DeveloperName='Disclaimer2_jpg' LIMIT 1].id;
            String orgId=UserInfo.getOrganizationId();
            String instance=[SELECT IsSandbox,InstanceName from Organization].InstanceName;
            
            if(instance.contains('CS')){
                returnString='https://c.' + instance + '.content.force.com/servlet/servlet.ImageServer?id=' + logodocId + '&oid=' + orgId;
            }
            }catch(QueryException q){
                returnString='';
            }
           
            return returnString;
        }
        set;}
        */
    public List<SBQQ__QuoteLine__c> myQuoteLines=new List<SBQQ__QuoteLine__c>();
    public List<SBQQ__QuoteLine__c> myFeeLines=new List<SBQQ__QuoteLine__c>();
    public SBQQ__Quote__c myQuoteDetails=new SBQQ__Quote__c();
    public List<invoiceit_s__Payment_Plan_Installment__c> myPaymentDetails=new List<invoiceit_s__Payment_Plan_Installment__c>();

    public List<SBQQ__QuoteLine__c> getmyQuoteLines() {
        //Find Quote ID from Order ID
      
        myQuoteLines=new List<SBQQ__QuoteLine__c>();
        //criteria for opps
        try{
            myQuoteLines = [SELECT Id,Product_Name_and_Description__c, ImageURL__c,SBQQ__ProductCode__c, SBQQ__ProductName__c,SBQQ__Quantity__c,SBQQ__ListPrice__c,SBQQ__CustomerPrice__c,SBQQ__NetTotal__c FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=:myQuoteId and SBQQ__CustomerPrice__c <>0 and ProductQuoteLine__c=true and FeeQuoteLine__c=false AND SBQQ__Product__r.SBQQ__Hidden__c = false];     
        }catch(Exception q){
            //myQuoteLines=new List<SBQQ__QuoteLine__c>();
        }
        
        //myQuoteLines=(myQuoteLines.isEmpty()) ? new List<SBQQ__QuoteLine__c>(): myQuoteLines;
        

        return myQuoteLines;    
    }

    public List<SBQQ__QuoteLine__c> getmyFeeLines(){
        //Find Quote ID from Order ID
        
        myFeeLines=new List<SBQQ__QuoteLine__c>();
        //criteria for opps
        try{
            myFeeLines = [SELECT Id,ImageURL__c, SBQQ__ProductName__c,SBQQ__Quantity__c,SBQQ__ListPrice__c,SBQQ__CustomerPrice__c,SBQQ__NetTotal__c FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=:myQuoteId and FeeQuoteLine__c=true and ProductQuoteLine__c=false];     // and SBQQ__CustomerPrice__c <>0

        }catch(Exception q){
            //myFeeLines=new List<SBQQ__QuoteLine__c>();

        }
        //myFeeLines=(myFeeLines.isEmpty()) ? new List<SBQQ__QuoteLine__c>(): myFeeLines;
        return myFeeLines;  

    }

    public SBQQ__Quote__c getmyQuoteDetails(){
        //Find Quote ID from Order ID
      
        myQuoteDetails=new SBQQ__Quote__c();
        try{
            myQuoteDetails=[Select id,Fee_Tier_Details__c ,Quote_Created_Date__c,SBQQ__ExpirationDate__c,Name,Tax_Year__c,Sales_Rep_Phone__c,Account_Manager__c,SBQQ__ShippingName__c,SBQQ__ShippingStreet__c,SBQQ__ShippingCity__c,SBQQ__ShippingState__c,SBQQ__ShippingPostalCode__c,SBQQ__BillingName__c,SBQQ__BillingStreet__c,SBQQ__BillingCity__c,SBQQ__BillingState__c,SBQQ__BillingPostalCode__c,Net_Minus_Tax_Fees__c,TaxCurrency__c,Processing_Fees__c,SBQQ__NetAmount__c,Payment_Details_rt__c from SBQQ__Quote__c where id=:myQuoteId LIMIT 1];    
        }catch(Exception q){
            //myQuoteDetails=new SBQQ__Quote__c();
        }
        
        myQuoteDetails=(myQuoteDetails==null) ? new SBQQ__Quote__c(): myQuoteDetails;
        
        return myQuoteDetails;

    }

    public List<invoiceit_s__Payment_Plan_Installment__c> getmyPaymentDetails(){
      
        myPaymentDetails=new List<invoiceit_s__Payment_Plan_Installment__c>();
        try{
            myPaymentDetails=[Select i.invoiceit_s__Payment_Type__c, i.invoiceit_s__Payment_Date__c, 
                                                            i.invoiceit_s__Payment_Amount__c, i.QTC__Quote__c, i.Payment_Method1__r.Last_4_Digits__c, 
                                                            i.Payment_Method1__r.invoiceit_s__Payment_Method__c, i.Payment_Method1__r.invoiceit_s__Card_Number__c, 
                                                            i.Payment_Method1__r.Name, i.Payment_Method1__c, i.Id From invoiceit_s__Payment_Plan_Installment__c i
                                                            where i.QTC__Quote__c=:myQuoteId
                                                            order by i.QTC__Quote__c,i.invoiceit_s__Payment_Date__c];
            }catch(Exception q){
                //myPaymentDetails=new List<invoiceit_s__Payment_Plan_Installment__c>();
            }
        
            myPaymentDetails=(myPaymentDetails.isEmpty()) ? new List<invoiceit_s__Payment_Plan_Installment__c>(): myPaymentDetails;
        
        return myPaymentDetails;
    }
    
   public boolean gethasFees(){
       myFeeLines=new List<SBQQ__QuoteLine__c>();
   Boolean returnVal;
       try{
            myFeeLines = [SELECT Id,ImageURL__c,SBQQ__ProductName__c,SBQQ__Quantity__c,SBQQ__ListPrice__c,SBQQ__CustomerPrice__c,SBQQ__NetTotal__c FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=:myQuoteId and FeeQuoteLine__c=true and ProductQuoteLine__c=false];     // and SBQQ__CustomerPrice__c <>0
            returnVal=!myFeeLines.isEmpty();
            
        }catch(QueryException q){
            //myFeeLines=new List<SBQQ__QuoteLine__c>();
            returnVal=false;
        }
        
        return returnVal;
   }
    
    public void getvisibility(){

        
        order_tw=false;
        order_atx=false;
        order_ifirm=false;
        order_default=false;
        myQuoteLines=new List<SBQQ__QuoteLine__c>();
        
        system.debug(myQuoteid);
        try{
            
                myQuoteLines = [SELECT Id,T_Cs__c, ImageURL__c,SBQQ__ProductCode__c, SBQQ__ProductName__c,SBQQ__Quantity__c,SBQQ__ListPrice__c,SBQQ__CustomerPrice__c,SBQQ__NetTotal__c FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=:myQuoteId and SBQQ__CustomerPrice__c <>0 and ProductQuoteLine__c=true and FeeQuoteLine__c=false];         
            
            
        }catch(Exception q){
            
        }
        
        for(SBQQ__QuoteLine__c ql:myQuoteLines){
            system.debug(ql.SBQQ__ProductCode__c);
            if(ql.SBQQ__ProductCode__c.contains('ATX')){
                order_atx=true;
                order_tw=false;
                break;
            }else if(ql.SBQQ__ProductCode__c.contains('TW')){
                order_tw=true;
            }else if(ql.SBQQ__ProductCode__c.contains('CSIFIRM')){
                order_ifirm=true;
            }
            

            
            
        }
        
        if(order_atx==true){
            order_tw=false;
            order_default=false;
            order_ifirm=false;
        }else if(order_atx==false && order_tw==true){
            order_ifirm=false;
            order_default=false;
        }else if(order_tw==false && order_ifirm==true){
            order_default=false;
        }else if(order_tw==false && order_ifirm==false && order_atx==false){
            order_default=true;
        }
        
}

     public List<String> getTandC(){
        Set<String> tcSet=new Set<String>();
        List<String> returnString=new List<String>();
        

        myQuoteLines=new List<SBQQ__QuoteLine__c>();

        try{
            
                myQuoteLines = [SELECT Id,T_Cs__c, ImageURL__c,SBQQ__ProductCode__c, SBQQ__ProductName__c,SBQQ__Quantity__c,SBQQ__ListPrice__c,SBQQ__CustomerPrice__c,SBQQ__NetTotal__c FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=:myQuoteId and ProductQuoteLine__c=true and FeeQuoteLine__c=false];         
            //and SBQQ__CustomerPrice__c <>0 
            
        }catch(Exception q){
            
        }
        
        for(SBQQ__QuoteLine__c ql:myQuoteLines){
           
            
            if(ql.T_Cs__c!=null){
               tcSet.addAll(ql.T_Cs__c.split(';'));
            }
            
            
        }
        
       
        system.debug(tcSet);
        
        for(SBQQ__QuoteTerm__c terms:[Select SBQQ__Body__c from SBQQ__QuoteTerm__c where SBQQ__Active__c=true and TC_Name__c IN:tcSet]){
          returnString.add(terms.SBQQ__Body__c); 
        }
        //order_atx=false;
        //order_tw=true;
        return returnString;
    }
    
    public cls_email_template_quotelines(){
        

        
    }
}