trigger CalculateUsercountforiFirm on SBQQ__Subscription__c (after insert,after update) {
    
   
    map<Id,Decimal> mapfornonportalcount= new map<Id,Decimal>();
    map<Id,Decimal> mapforportalcount= new map<Id,Decimal>();
    
    map<Id,Decimal> mapfornonportalcountforaccount= new map<Id,Decimal>();
    map<Id,Decimal> mapforportalcountforaccount= new map<Id,Decimal>();
    
    List<Account> Accounttoupdate = new List<Account>();
    
    List<Contract> contractstoupdate = new List<Contract>();
    
    List<Account> Accounttoupdate1 = new List<Account>();
    
    List<Contract> contractstoupdate1 = new List<Contract>();
    
    public Decimal nonportalcount;
    public Decimal portalcount;
    public  Id Contractid;
    nonportalcount=0;
    portalcount=0;
    
    
    
      for(SBQQ__Subscription__c  s:Trigger.new){
        
        if(s.SBQQ__Contract__c!=null)
         Contractid=s.SBQQ__Contract__c;
         
         if(Trigger.isinsert){
         
         if(s.Is_Portal__c == TRUE ){
        
         if(s.of_iFirm_Portal_Users__c !=0 ){
         
         portalcount=+s.of_iFirm_Portal_Users__c;
         
         }
         
         }else{
         
         if(s.of_iFirm_Non_Portal_Users__c !=0){
         
         nonportalcount=+s.of_iFirm_Non_Portal_Users__c;
         
         }
         
         }
         }
         system.debug('non portal count'+nonportalcount);
         system.debug('portal count'+portalcount);
      }
         system.debug('non portal count'+nonportalcount);
         system.debug('portal count'+portalcount);
         system.debug('Contract id'+Contractid);
         
         if(portalcount >99){
         
         portalcount= 99;
         
         }
         
         if(nonportalcount>0 ){
         
         mapfornonportalcount.put(Contractid,nonportalcount);
         
         
         }
         
        if(portalcount >0 ){
         
         mapforportalcount.put(Contractid,portalcount);
         
         }
         system.debug('non portal count'+mapfornonportalcount);
         system.debug('portal count'+mapforportalcount);
       
         // logic to get portal count on account
         
      List<Contract> c = [Select Id,Total_iFirm_User__c,of_iFirm_Non_Portal_Users__c,of_iFirm_Portal_Users__c,AccountId From Contract Where id IN : mapforportalcount.keyset()];
      
      for(Contract ct : c){
      
      if (portalcount != 0 ) {
      
      if(ct.of_iFirm_Portal_Users__c >0 ){
      ct.of_iFirm_Portal_Users__c =ct.of_iFirm_Portal_Users__c+mapforportalcount.get(ct.id);
      mapforportalcountforaccount.put(ct.AccountId,ct.of_iFirm_Portal_Users__c );
      }else{
      ct.of_iFirm_Portal_Users__c = mapforportalcount.get(ct.id);
      mapforportalcountforaccount.put(ct.AccountId,ct.of_iFirm_Portal_Users__c );
      }
       system.debug('portal count'+ct.of_iFirm_Portal_Users__c);
      }
      
     
      contractstoupdate.add(ct);
      }
     
     if(contractstoupdate.size()>0)
     update contractstoupdate;
     
     List<Account> a = [Select Id,of_iFirm_Users__c,No_of_non_Portal_Users__c,No_of_Portal_Users__c From Account Where id IN : mapforportalcountforaccount.keyset()];
   
   for(Account act : a){
   if(Trigger.isInsert){
    if(act.No_of_Portal_Users__c != null){
   if (act.No_of_Portal_Users__c != 0 ) {
   if(mapforportalcountforaccount.get(act.id)!= null ){
   act.No_of_Portal_Users__c =act.No_of_Portal_Users__c+mapforportalcountforaccount.get(act.id);
   system.debug('map values heere'+mapforportalcountforaccount);
   }
   }
   }
   if(act.No_of_Portal_Users__c == 0 || act.No_of_Portal_Users__c == null){
   if(mapforportalcountforaccount.get(act.id)!= null ){
   act.No_of_Portal_Users__c =mapforportalcountforaccount.get(act.id);
   system.debug('map values heere'+mapforportalcountforaccount);
   }
   }
   
   Accounttoupdate.add(act);
   }
    }
    
    if(Accounttoupdate.size()>0)
   update Accounttoupdate;
   
   // logic to get nonportal count on account
   
    List<Contract> c1 = [Select Id,Total_iFirm_User__c,of_iFirm_Non_Portal_Users__c,of_iFirm_Portal_Users__c,AccountId From Contract Where id IN : mapfornonportalcount.keyset()];
      
      for(Contract ct : c1){
      
      if(nonportalcount!=0){
      if(ct.of_iFirm_Non_Portal_Users__c>0){
      ct.of_iFirm_Non_Portal_Users__c=ct.of_iFirm_Non_Portal_Users__c+mapfornonportalcount.get(ct.id);
      mapfornonportalcountforaccount.put(ct.AccountId,ct.of_iFirm_Non_Portal_Users__c);
      }else{
      ct.of_iFirm_Non_Portal_Users__c= mapfornonportalcount.get(ct.id);
       mapfornonportalcountforaccount.put(ct.AccountId,ct.of_iFirm_Non_Portal_Users__c);
       }
       system.debug('non portal count'+ct.of_iFirm_Non_Portal_Users__c);
      }
      
    
      contractstoupdate1.add(ct);
      }
     
     if(contractstoupdate1.size()>0)
     update contractstoupdate1;
     
     List<Account> a1 = [Select Id,of_iFirm_Users__c,No_of_non_Portal_Users__c,No_of_Portal_Users__c From Account Where id IN : mapfornonportalcountforaccount.keyset()];
   
   for(Account act : a1){
     
   if(Trigger.isInsert){
   if(act.No_of_non_Portal_Users__c!= null){
   if (act.No_of_non_Portal_Users__c!= 0  ) {
   if(mapfornonportalcountforaccount.get(act.id)!= null ){
   act.No_of_non_Portal_Users__c=act.No_of_non_Portal_Users__c+mapfornonportalcountforaccount.get(act.id);
   system.debug('map values heere'+mapfornonportalcountforaccount);
   }
   }
   }
   
   if(act.No_of_non_Portal_Users__c== 0 || act.No_of_non_Portal_Users__c== null){
   if(mapfornonportalcountforaccount.get(act.id)!= null ){
   act.No_of_non_Portal_Users__c=mapfornonportalcountforaccount.get(act.id);
   system.debug('map values heere'+mapfornonportalcountforaccount);
   }
   }
   
   
   
   Accounttoupdate1.add(act);
   }
    }
    
    if(Accounttoupdate1.size()>0)
   update Accounttoupdate1;
}