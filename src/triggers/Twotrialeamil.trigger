trigger Twotrialeamil on Account (after update) {

   List<Contact> contactstoupdate = new List<Contact>();
 if(trigger.size==1){

    for(Account a:trigger.new){
            Account oldaccnt= Trigger.oldMap.get(a.ID);
            
            
              if(  (a.Acct_Primary_Contact__c!=null && (a.TwoTrial_Regcode__c!=null && oldaccnt.TwoTrial_Regcode__c==null)) && Triggerflag.firstRun ){
                    
                    Contact c= new contact();
                    c.id=a.Acct_Primary_Contact__c;
                    c.TwoTrial_Regcode__c=a.TwoTrial_Regcode__c;
                    contactstoupdate.add(c);
                    
                    
                    //Here we will build the single email message
                    Messaging.reserveSingleEmailCapacity(1);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    //Get Template ID
                    String templateId;
                    try{
                        templateId=[Select id from EmailTemplate where Name='Two Trial confirmation email'].id;
                        mail.setTemplateId(templateId);
                    }catch(QueryException qe){
                        system.debug(qe.getMessage());
                    }
                    
                    system.debug(templateId);
                    //Get Contact E-Mail Address
                    try{
                        
                    
                    
                    String[] toAddresses = new String[]{a.Email__c};
                    
                    mail.setToAddresses(toAddresses );
                    mail.setUseSignature(false);
                    mail.setSaveAsActivity(true);
                    mail.setWhatId(a.id);
                    //setHtmlBody(htmlBody);
                    mail.setTargetObjectId(a.Acct_Primary_Contact__c);
                    
                    
                    //Savepoint sp = Database.setSavepoint();
                
                    system.debug(mail);
                    try{
                    
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                    }catch(Exception e){
                        system.debug('Email Fail To Send');
                        system.debug(e.getmessage());
                    }
                    //Database.rollback(sp);
                    }catch(QueryException qq){
                        system.debug(qq.getMessage());
                    }
                    
                    Triggerflag.firstRun=false; 
                }
            
            
            
            }
            
            
            
 }
 
 if(contactstoupdate.size()>0)
 update contactstoupdate;
 
 
}