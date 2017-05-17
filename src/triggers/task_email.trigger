trigger task_email on SBQQ__Quote__c (after update) {

    if(trigger.size==1){
        for(SBQQ__Quote__c q:trigger.new){
            SBQQ__Quote__c oldQuote = Trigger.oldMap.get(q.ID);
                  
                  system.debug('new quote'+q);
                  system.debug('old quote'+oldQuote );
                  
                  if( (q.Opportunity_Type__c=='Renewal' && q.Is_Accounting_Tax__c >0 && (q.QTC__Order__c!=null && oldQuote.QTC__Order__c==null))){
                  
                  
                  Account a = new Account();
                  a.id=q.SBQQ__Account__c;
                  a.Type='Renewed customer';
                  
                  update a;
                  
                  }else if(q.QTC__Order__c!=null && oldQuote.QTC__Order__c==null){
                  
                    if(q.Account_Type__c =='Prospect' || q.Account_Type__c =='Prior Customer'){
                     
                      Account a = new Account();
                      a.id=q.SBQQ__Account__c;
                      a.Type='New Customer';
                  
                      update a;
                    
                    }
                  }
                  
                  
                  if(  (q.SBQQ__PrimaryContact__c!=null && (q.QTC__Order__c!=null && oldQuote.QTC__Order__c==null))){
                    //Here we will build the single email message
                    Messaging.reserveSingleEmailCapacity(1);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    //Get Template ID
                    String templateId;
                    try{
                        templateId=[Select id from EmailTemplate where DeveloperName='VF_Order_Confirmation'].id;
                        mail.setTemplateId(templateId);
                    }catch(QueryException qe){
                        system.debug(qe.getMessage());
                    }
                    
                    system.debug(templateId);
                    //Get Contact E-Mail Address
                    try{
                        String contactEmail=[Select Email from Contact where id=:q.SBQQ__PrimaryContact__c].Email;
                    
                    
                    String[] toAddresses = new String[]{contactEmail};
                    mail.setToAddresses(toAddresses);
                    mail.setUseSignature(false);
                    mail.setSaveAsActivity(true);
                    //mail.setSenderDisplayName('MMPT');
                    mail.setWhatId(q.id);
                    mail.setTargetObjectId(q.SBQQ__PrimaryContact__c);
                    
                    
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
                    

                }
                

                
            }

    }
    
}