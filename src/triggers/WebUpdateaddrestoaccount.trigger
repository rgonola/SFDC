trigger WebUpdateaddrestoaccount on SBQQ__Quote__c(after update) {

  map<string,SBQQ__Quote__c> actid=new map<string,SBQQ__Quote__c>();
  List<Account> updatedaccount= new  List<Account>();
  List<Opportunity> oopstoupdate= new  List<Opportunity>();
  set<string> originquote = new set<string>();
  List<SBQQ__Quote__c> qutstoupdate= new  List<SBQQ__Quote__c>();
  List<invoiceit_s__Payment_Method__c> updatedpy= new  List<invoiceit_s__Payment_Method__c>();

  

  for(SBQQ__Quote__c a:Trigger.new) {
  if(a.Origin_Source__c!=''|| a.Origin_Source__c!=null ){
    if((( a.SBQQ__BillingStreet__c!= trigger.oldmap.get(a.id).SBQQ__BillingStreet__c||

       a.SBQQ__BillingCity__c!= trigger.oldmap.get(a.id).SBQQ__BillingCity__c||

       a.SBQQ__BillingCountry__c!= trigger.oldmap.get(a.id).SBQQ__BillingCountry__c||

       a.SBQQ__BillingState__c!= trigger.oldmap.get(a.id).SBQQ__BillingState__c||

       a.SBQQ__BillingPostalCode__c!= trigger.oldmap.get(a.id).SBQQ__BillingPostalCode__c ||                                    
       
       a.SBQQ__shippingStreet__c!= trigger.oldmap.get(a.id).SBQQ__shippingStreet__c||

       a.SBQQ__shippingCity__c!= trigger.oldmap.get(a.id).SBQQ__shippingCity__c||

       a.SBQQ__shippingCountry__c!= trigger.oldmap.get(a.id).SBQQ__shippingCountry__c||

       a.SBQQ__shippingState__c!= trigger.oldmap.get(a.id).SBQQ__shippingState__c||

       a.SBQQ__shippingPostalCode__c != trigger.oldmap.get(a.id).SBQQ__shippingPostalCode__c || 
       
       a.SBQQ__BillingName__c != trigger.oldmap.get(a.id).SBQQ__BillingName__c || 
       
       a.SBQQ__BillingName__c != trigger.oldmap.get(a.id).SBQQ__BillingName__c)&&a.Origin_Source__c=='WEB')) {
      
      actid.put(a.SBQQ__Account__c,a);
     

    }
    }

 system.debug('origin quote '+a.Original_Quote__c);
    if(a.Original_Quote__c != null && a.Origin_Source__c=='WEB' && a.SBQQ__Status__c =='Invoiced' ){
   
   system.debug('origin quote '+a.Original_Quote__c);
       originquote.add(a.Original_Quote__c);
     
  }

  }

  if(originquote.size()>0){
  
  for(SBQQ__Quote__c qt :[Select Id,SBQQ__Status__c From SBQQ__Quote__c Where Id IN :originquote ]){
  
  qt.SBQQ__Status__c='Transferred';
  
  qutstoupdate.add(qt);
  }
  
  if(qutstoupdate.size()>0)
  update qutstoupdate;
  
  for(Opportunity p :[select Id,StageName From Opportunity Where SBQQ__PrimaryQuote__c IN :originquote  ]){
  
  p.StageName='Transferred';
  
  oopstoupdate.add(p);
  
  }
  
  if(oopstoupdate.size()>0)
  update oopstoupdate;
  
  }
  
  
  if(actid.size()>0){
  for(Account c:[select id,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalcode,shippingStreet,shippingCity,shippingState,shippingCountry,shippingPostalcode from Account where Id in: actid.Keyset()]) {

    SBQQ__Quote__c a = actid.get(c.id);
   
    boolean updatedrecord = false;
   
     
     
    if(c.BillingStreet== trigger.oldmap.get(a.id).SBQQ__BillingStreet__c) {
     
      c.BillingStreet= a.SBQQ__BillingStreet__c;
     
      updatedrecord = true;

    }

    if(c.BillingCity== trigger.oldmap.get(a.id).SBQQ__BillingCity__c) {

      c.BillingCity= a.SBQQ__BillingCity__c;

      updatedrecord = true;

    }

    if(c.BillingState== trigger.oldmap.get(a.id).SBQQ__BillingState__c) {

      c.BillingState= a.SBQQ__BillingState__c;

      updatedrecord = true;

    }

    if(c.BillingPostalcode == trigger.oldmap.get(a.id).SBQQ__BillingPostalCode__c) {

      c.BillingPostalcode = a.SBQQ__BillingPostalCode__c;

      updatedrecord = true;

    }

    if(c.BillingCountry== trigger.oldmap.get(a.id).SBQQ__BillingCountry__c) {

      c.BillingCountry= a.SBQQ__BillingCountry__c;

      updatedrecord = true;

    }
    
        if(c.shippingStreet== trigger.oldmap.get(a.id).SBQQ__shippingStreet__c) {
     
      c.shippingStreet= a.SBQQ__shippingStreet__c;
     
      updatedrecord = true;

    }

    if(c.shippingCity== trigger.oldmap.get(a.id).SBQQ__shippingCity__c) {

      c.shippingCity= a.SBQQ__shippingCity__c;

      updatedrecord = true;

    }

    if(c.shippingState== trigger.oldmap.get(a.id).SBQQ__shippingState__c) {

      c.shippingState= a.SBQQ__shippingState__c;

      updatedrecord = true;

    }

    if(c.shippingPostalcode == trigger.oldmap.get(a.id).SBQQ__shippingPostalCode__c) {

      c.shippingPostalcode = a.SBQQ__shippingPostalCode__c;

      updatedrecord = true;

    }

    if(c.shippingCountry== trigger.oldmap.get(a.id).SBQQ__shippingCountry__c) {

      c.shippingCountry= a.SBQQ__shippingCountry__c;

      updatedrecord = true;

    }
    
    if(updatedrecord) {

      updatedaccount.add(c);

    }

  }
  
  
  for(invoiceit_s__Payment_Method__c p:[select id,invoiceit_s__Account__c,invoiceit_s__Billing_First_Name__c,invoiceit_s__Billing_Last_Name__c,invoiceit_s__Billing_Address__c,invoiceit_s__Billing_City__c,invoiceit_s__Billing_State_Province__c,invoiceit_s__Billing_Country__c,invoiceit_s__Billing_Zip_Postal__c from invoiceit_s__Payment_Method__c where invoiceit_s__Account__c   in: actid.Keyset()]) {
   
   List<string> n = new List<string>();
   
    SBQQ__Quote__c a = actid.get(p.invoiceit_s__Account__c);
    system.debug('quote here is  '+a);
    boolean updatedpymnt = false;
    
    if(a.SBQQ__BillingName__c!=null || a.SBQQ__BillingName__c !='')
        n=a.SBQQ__BillingName__c.split(' ');
    
    system.debug('================'+n);
    if(!n.isEmpty() ){
        p.invoiceit_s__Billing_First_Name__c = n[0];
        if(n.size() == 2)
            p.invoiceit_s__Billing_Last_Name__c = n[1];
        else if(n.size() > 2) {
            String firstName = '';
            for(Integer i=0;i<n.size()-1;i++)
                firstName += ' ' + n[i];
                
            p.invoiceit_s__Billing_First_Name__c = firstName;
            p.invoiceit_s__Billing_Last_Name__c = n[n.size()-1];
        }
    
        updatedpymnt = true;
    }
    
    if(p.invoiceit_s__Billing_Address__c== trigger.oldmap.get(a.id).SBQQ__BillingStreet__c) {
     
      p.invoiceit_s__Billing_Address__c= a.SBQQ__BillingStreet__c;
     
      updatedpymnt = true;

    }

    if(p.invoiceit_s__Billing_City__c== trigger.oldmap.get(a.id).SBQQ__BillingCity__c) {

      p.invoiceit_s__Billing_City__c= a.SBQQ__BillingCity__c;

      updatedpymnt = true;

    }

    if(p.invoiceit_s__Billing_State_Province__c== trigger.oldmap.get(a.id).SBQQ__BillingState__c) {

      p.invoiceit_s__Billing_State_Province__c= a.SBQQ__BillingState__c;

      updatedpymnt = true;

    }

    if(p.invoiceit_s__Billing_Zip_Postal__c == trigger.oldmap.get(a.id).SBQQ__BillingPostalCode__c) {

      p.invoiceit_s__Billing_Zip_Postal__c = a.SBQQ__BillingPostalCode__c;

      updatedpymnt = true;

    }

    if(p.invoiceit_s__Billing_Country__c== trigger.oldmap.get(a.id).SBQQ__BillingCountry__c) {

      p.invoiceit_s__Billing_Country__c= a.SBQQ__BillingCountry__c;

      updatedpymnt = true;

    }
    
    
    if(updatedpymnt) {

      updatedpy.add(p);

    }
    system.debug('updated payment details  '+p);
  } 
  
  }
  
  
  
  if(updatedpy.size()>0)
  update updatedpy;
  
  system.debug('line 201'+updatedpy);
  
  if(updatedaccount.size()>0)
  update updatedaccount;
  
 system.debug('line 83'+updatedaccount);
}