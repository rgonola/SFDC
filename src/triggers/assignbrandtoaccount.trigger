trigger assignbrandtoaccount on Cart__c (after insert,after update) {

 Map<Id,string> cartlst= new Map<Id,string>();
 List<Account> acctstoupdate= new List<Account>();
 Map<String,String> mapbrandincl=new Map<String,String>(); 
 Map<String,String> maptoaddacnt=new Map<String,String>(); 
    
   
    
    for(Cart__c ct: trigger.new){
    
    
    if(ct.Cart_Account__c !=null ){
    
    
     cartlst.put(ct.id,ct.Cart_Account__c);
    
    }
    
    }


             
     for(Cart_Line__c c : [Select Id,Product__c,Brand__c,cart__r.Cart_Account__c From Cart_Line__c Where  Cart__c IN: cartlst.Keyset()]){
             
        if(c.Brand__c=='TW'){
        
        mapbrandincl.put(c.cart__r.Cart_Account__c,c.Brand__c);
        }
             
       }
    
     for(Account a :[Select Id,Brand__c From Account Where Id IN :mapbrandincl.keyset()]){
    
    
     a.Brand__c=mapbrandincl.get(a.id);
     acctstoupdate.add(a);
     
     }
     
     
    
        
     
     
     
     if(acctstoupdate.size()>0)
     update acctstoupdate;    
         
}