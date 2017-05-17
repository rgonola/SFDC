trigger sendAccountData on Account (After update) 
{
    
 
     
    for(Account a:Trigger.new)
    {
    
        
       if(system.trigger.NewMap.get(a.Id).CC_on_File__c != system.trigger.OldMap.get(a.Id).CC_on_File__c ){ UpdateAccountInfoInDM.sendCCOnFileAndCutOffData(a.Id,'ccOnFile');} 
        
        if(system.trigger.NewMap.get(a.Id).Cutoff__c != system.trigger.OldMap.get(a.Id).Cutoff__c ) { UpdateAccountInfoInDM.sendCCOnFileAndCutOffData(a.Id,'cutoffData'); 
            //Triggerflag.firstRun=false;  
        }
        
      /*Will be triggered when CID and PID are not null */
      
     if(a.PID__c!=null && a.CID__c!=null){
       
       if((
       (system.trigger.NewMap.get(a.Id).PID__c!= system.trigger.OldMap.get(a.Id).PID__c)||
       (system.trigger.NewMap.get(a.Id).OFFC__c != system.trigger.OldMap.get(a.Id).OFFC__c) ||
       (system.trigger.NewMap.get(a.Id).Email__c!= system.trigger.OldMap.get(a.Id).Email__c) ||
       (system.trigger.NewMap.get(a.Id).Name!= system.trigger.OldMap.get(a.Id).Name) ||
       (system.trigger.NewMap.get(a.Id).CID__c!= system.trigger.OldMap.get(a.Id).CID__c) ||
       (system.trigger.NewMap.get(a.Id).Brand__c!= system.trigger.OldMap.get(a.Id).Brand__c) ||
       (system.trigger.NewMap.get(a.Id).BillingPostalCode != system.trigger.OldMap.get(a.Id).BillingPostalCode ) ||
       (system.trigger.NewMap.get(a.Id).BillingState!= system.trigger.OldMap.get(a.Id).BillingState) ||
       (system.trigger.NewMap.get(a.Id).Primary_Contact_Phone__c!= system.trigger.OldMap.get(a.Id).Primary_Contact_Phone__c) ||
       (system.trigger.NewMap.get(a.Id).Primary_Contact_Fax__c!= system.trigger.OldMap.get(a.Id).Primary_Contact_Fax__c) ||
       (system.trigger.NewMap.get(a.Id).Billing_Contact_Email__c != system.trigger.OldMap.get(a.Id).Billing_Contact_Email__c) ||
       (system.trigger.NewMap.get(a.Id).BillingCountry!= system.trigger.OldMap.get(a.Id).BillingCountry) ||
       (system.trigger.NewMap.get(a.Id).BillingCity!= system.trigger.OldMap.get(a.Id).BillingCity) ||
       (system.trigger.NewMap.get(a.Id).Primary_Contact_Name__c!= system.trigger.OldMap.get(a.Id).Primary_Contact_Name__c) ||
       (system.trigger.NewMap.get(a.Id).Billing_Address_2__c!= system.trigger.OldMap.get(a.Id).Billing_Address_2__c) ||
       (system.trigger.NewMap.get(a.Id).BillingStreet!= system.trigger.OldMap.get(a.Id).BillingStreet) ||
       (system.trigger.NewMap.get(a.Id).Primary_MobilePhone__c!= system.trigger.OldMap.get(a.Id).Primary_MobilePhone__c) ||
       
       (system.trigger.NewMap.get(a.Id).ShippingPostalCode!= system.trigger.OldMap.get(a.Id).ShippingPostalCode) ||
       (system.trigger.NewMap.get(a.Id).ShippingState!= system.trigger.OldMap.get(a.Id).ShippingState) ||
       (system.trigger.NewMap.get(a.Id).Shipping_Contact_Email__c!= system.trigger.OldMap.get(a.Id).Shipping_Contact_Email__c) ||
       (system.trigger.NewMap.get(a.Id).ShippingCountry!= system.trigger.OldMap.get(a.Id).ShippingCountry) ||
       (system.trigger.NewMap.get(a.Id).ShippingCity!= system.trigger.OldMap.get(a.Id).ShippingCity) ||
       
        (system.trigger.NewMap.get(a.Id).Shipping_Address_2__c!= system.trigger.OldMap.get(a.Id).Shipping_Address_2__c) ||
       (system.trigger.NewMap.get(a.Id).ShippingStreet!= system.trigger.OldMap.get(a.Id).ShippingStreet) ) && system.trigger.NewMap.get(a.Id).Has_PFX_Promotion__c==false){
       
         UpdateAccountInfoInDM.replicateCustomer(a.Id);
       }
     } 
     
    }
   
}