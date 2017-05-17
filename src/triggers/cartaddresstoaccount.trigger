trigger cartaddresstoaccount  on Cart__c (after update) {

  map<string,Cart__c > actid=new map<string,Cart__c >();
  List<Account> updatedaccount= new  List<Account>();
  set<string> originquote = new set<string>();
  List<Cart__c > qutstoupdate= new  List<Cart__c >();
 
  

  for(Cart__c  a:Trigger.new) {
  
    if( a.Street_Address__c!= trigger.oldmap.get(a.id).Street_Address__c||a.Shipping_City__c!= trigger.oldmap.get(a.id).Shipping_City__c|| a.State__c!= trigger.oldmap.get(a.id).State__c||a.Shipping_Zip__c!= trigger.oldmap.get(a.id).Shipping_Zip__c ||a.Shipping_Name__c != trigger.oldmap.get(a.id).Shipping_Name__c  ) {
      actid.put(a.Cart_Account__c,a);
     }
  }
  
  
  if(actid.size()>0){
  for(Account c:[select id,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalcode,shippingStreet,shippingCity,shippingState,shippingCountry,shippingPostalcode from Account where Id in: actid.Keyset()]) {

    Cart__c a = actid.get(c.id);
   
    boolean updatedrecord = false;
    
    c.Billing_Contact_Name__c= a.Shipping_Name__c;
    c.BillingStreet= a.Street_Address__c;
    c.BillingCity= a.Shipping_City__c;
    c.BillingState= a.State__c;
    c.BillingPostalcode = a.Shipping_Zip__c;
    c.BillingCountry= 'USA';
    c.shippingStreet= a.Street_Address__c;
    c.shippingCity= a.Shipping_City__c;
    c.shippingState= a.State__c;
    c.shippingPostalcode = a.Shipping_Zip__c;
    c.shippingCountry= 'USA';
    c.Shipping_Contact_Name__c= a.Shipping_Name__c;
    if(a.Sales_Assignment__c!= null)
    c.OwnerId=a.Sales_Assignment__c;
    updatedrecord = true;
   

    if(updatedrecord) {

      updatedaccount.add(c);

    }

  }
  
  
  if(updatedaccount.size()>0)
  update updatedaccount;
  
 system.debug('line 83'+updatedaccount);
}
}