/**********************************************************************
Name: leadDuplicatePreventer
Copyright © 2012 WK
======================================================
======================================================
Purpose: This trigger will be called when a new lead is created or Updating the existing lead.
         This will prevent the creation/updation of lead for "AM/FS/NS" and "Refund Today" record type.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR            DATE       DETAIL 
1.0       Aditya            05/03/2012 INITIAL DEVELOPMENT 
2.0       Venkata.Penneti   21/03/2012 Added logic to check duplicates with respect to Address for AM/NS/FS
3.0       Natesh.Alagiri               Added logic to Check duplicates with respect to Email and Phone for RT
4.0       Venkata.Penneti   08/06/2012 Added logic to update Priemier Account Manager as Owner for RT
5.0       Natesh.Alagiri    20/06/2012 Added logic to add Duplicate Web to Leads to Duplicate Leads Queue
6.0       Rajesh S. Meti    09/07/2012 Review changes and code refinement
7.0       Natesh Alagiri    24/07/2012 Update Contract Expiration Date for Lead based on Process value 'Sign and Close a Prospect'
8.0       Natesh Alagiri    14/08/2012 Check for Lead duplicate with an existing Accounts
9.0       Natesh Alagiri    29/08/2012 Added logic to copy Standard Phone field value to custom Phone field
10.0      Rajesh S Meti     18/09/2012 Review changes and code refinement
11.0      Rajesh S Meti     19/09/2012 Added logic to update owner based on the Sales Rep Code provided
12.0      Natesh Alagiri    25/09/2012 Added logic to allow Sys Admin AM/NS/FS to create lead with duplicate Company Name
13.0      Vaibhav Kulkarni  12/6/2013  Logic matching of Lead Company and Zipcode with existing Leads and Account's Account_Name_Address_Merge__c
14.0      Rajesh Wani       11/9/2013  Logic matching of Lead phone and email with existing Leads and Account's Account_Name_Address_Merge__c of same recordtype (AM/FS/NS or Refunds Today )
***********************************************************************/
trigger leadDuplicatePreventer on Lead (before insert, before update) {
    
    Map<String, Lead> leadFirstNameMap = new Map<String, Lead>();
    Map<String, Lead> leadLastNameMap = new Map<String, Lead>();
    Map<String, Lead> leadCompanyMap = new Map<String, Lead>();
    Map<String, Lead> leadEmailMap = new Map<String, Lead>();
    Map<String, Lead> leadPhoneMap = new Map<String, Lead>();
    Map<String, Lead> leadAddressMap = new Map<String, Lead>();    
    Map<String, Lead> leadEmailPhoneMap = new Map<String, Lead>();
    //8.0
    Map<String, Lead> leadEFINMap = new Map<String, Lead>();
    
    // Sets for AMFSNS
    //Set<String> leadAMFSNSfirstname = new Set<String>();
    //Set<String> leadAMFSNSlastname = new Set<String>();
    Set<String> leadAMFSNScompany = new Set<String>();
    Set<String> leadAMFSNSstreet = new Set<String>();
    Set<String> leadAMFSNScity = new Set<String>();
    Set<String> leadAMFSNSpostalcode = new Set<String>();
    Set<String> leadAMFSNSstate = new Set<String>();
    Set<String> leadAMFSNScountry = new Set<String>();
    Map<String,Lead> leadAMFSNSExistingMap = new Map<String,Lead>();
        
    // Sets for Refunds Today
    Set<String> leadRTphone = new Set<String>();
    Set<String> leadRTemail = new Set<String>();
    Map<String,List<Lead>> leadRTExistingMap = new Map<String,List<Lead>>();
    
    
    // Modified by Cloud sherpas @ 9th september 2013
    // Get Recordtype id by dynamic apex
    schema.describesobjectresult ldDescribe      = Lead.sobjecttype.getdescribe();
    map<string,schema.recordtypeinfo> recTypeInfoLead = ldDescribe.getrecordtypeinfosbyname();
    //8.0
    Id AMFSNSRecordTypeId       = recTypeInfoLead.get('AM/FS/NS Lead').getrecordtypeid();
    Id RefundsTodayRecordTypeId = recTypeInfoLead.get('Leads Refunds Today').getrecordtypeid();
    Id LeadsTrustRecordTypeId = recTypeInfoLead.get('Leads Trust').getrecordtypeid();
    
    //Id AMFSNSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Lead'].Id;    
    //Id  =[select Id from RecordType where Name='Leads Refunds Today'].Id;
    
    // Modified by Cloud sherpas @ 9th september 2013
    // Get Recordtype id by dynamic apex
    schema.describesobjectresult accDescribe      = Account.sobjecttype.getdescribe();
    map<string,schema.recordtypeinfo> recTypeInfo = accDescribe.getrecordtypeinfosbyname();
    //8.0
    Id AMFSNSAccountRecordTypeId       = recTypeInfo.get('AM/FS/NS Account').getrecordtypeid();
    Id RefundsTodayAccountRecordTypeId = recTypeInfo.get('Refunds Today Account').getrecordtypeid();
    Id TrustAccountRecordTypeId = recTypeInfo.get('Trust Account').getrecordtypeid();
    //9.0
    String phoneStandard = '';
    String phoneCustom = '';    
    
    //Update Contract Expiration Date
    Date currentDate = system.today();
    Integer nextYear = currentDate.year() + 1;
    String nextContractEXPNull = nextYear + ' EXP';
    Integer currentEXPYear;
    String currentEXPValue;
    String nextContractEXP;
    
    //11.0    
    Set<string> setSalesRepCodes = new Set<String>();
    Map<String, Id> mapUserId = new Map<String, Id>();
    
    //12.0
    String CurrentUserRoleName;
    
    //13.0
    String leadAddress = '';
    String leadAddressComZip = '';
      
    Set<Id> OwnerIds = new Set<Id>();
    for(Lead lead : Trigger.new) {
        if(lead.RecordTypeId==RefundsTodayRecordTypeId)
            OwnerIds.add(lead.OwnerId);
        
        //11.0 - logic to add Sales Rep Code to Set  
        if(lead.RecordTypeId == AMFSNSRecordTypeId && (lead.SALES_REP_CODE__c != null && lead.SALES_REP_CODE__c != '')
           && (Trigger.isInsert || lead.SALES_REP_CODE__c != Trigger.oldMap.get(lead.Id).SALES_REP_CODE__c)) {        
            setSalesRepCodes.add(lead.SALES_REP_CODE__c);           
        }
    }
    
    //12.0
    OwnerIds.add(System.Userinfo.getUserId());
    
    Map<Id,String> OwnerIdNameMap = new Map<Id,String>();
    for(User UserRecord :[SELECT Id, Name, UserRole.Name FROM User WHERE Id in :OwnerIds]){
        OwnerIdNameMap.put(UserRecord.Id, UserRecord.Name);
        
        //12.0
        if(UserRecord.Id == System.Userinfo.getUserId()){
            CurrentUserRoleName = UserRecord.UserRole.Name;
        }
    }
    
    //11.0 Fetching Users for setSalesRepCodes
    if(setSalesRepCodes != null && setSalesRepCodes.size() > 0) { 
        for(User usr :[SELECT Id, SALES_REP_CODE__c FROM User WHERE 
                       SALES_REP_CODE__c IN :setSalesRepCodes AND IsActive = true])   {
            mapUserId.put(usr.SALES_REP_CODE__c, usr.Id);
        }  
    }
    
    for (Lead lead : Trigger.new) {
        //AM NS FS
        if(lead.RecordTypeId == AMFSNSRecordTypeId  || lead.RecordTypeId == RefundsTodayRecordTypeId || lead.RecordTypeId == LeadsTrustRecordTypeId){
            
            //11.0 logic to update owner
            if(mapUserId.containskey(lead.SALES_REP_CODE__c))   
                lead.OwnerId = mapUserId.get(lead.SALES_REP_CODE__c); 
                        //  system.debug('Lead=========1========'+lead);
            //9.0 - logic to copy Standard Phone field value to custom Phone field
            if(lead.Phone != null && lead.Phone != ''){                
                phoneStandard = lead.Phone;
                phoneStandard = phoneStandard.replace('(','');
                phoneStandard = phoneStandard.replace(')','');
                phoneStandard = phoneStandard.replace('-','');
                phoneStandard = phoneStandard.replace(' ','');                
                phoneCustom = phoneStandard; 
                              
                if(phoneCustom.length() == 10){
                    lead.Phone__c = phoneCustom;
                }
            }
                //system.debug('Lead=========phone========'+lead.phone__C);
            //Update Primary Contact Name and Primary Contact Email if it is null or blank
            if(lead.Primary_Contact_Name__c == '' || lead.Primary_Contact_Name__c == null) {
                if(lead.FirstName <> null && lead.FirstName <> '')
                    lead.Primary_Contact_Name__c = lead.FirstName + ' ' + lead.LastName;
                else               
                    lead.Primary_Contact_Name__c = lead.LastName;                
            }
            
            if(lead.Primary_Contact_Email__c == '' || lead.Primary_Contact_Email__c == null)
                lead.Primary_Contact_Email__c = lead.Email;
       
            
            /*****if((lead.Company != null && lead.Company != '') && (Trigger.isInsert || lead.Company != Trigger.oldMap.get(lead.Id).Company) && CurrentUserRoleName != 'CCHSFS - System Administrator') {
                if (leadCompanyMap.containsKey(lead.Company.toLowerCase())) {
                    if(lead.IsWebToLead__c)
                        lead.Duplicate_Web_To_Lead__c = true;
                    else
                        lead.Company.addError('A lead with this Company already exists');
                }
                else 
                    leadCompanyMap.put(lead.Company.toLowerCase(), lead);                
            }
           // System.debug('leadCompanyMapleadCompanyMapleadCompanyMap'+leadCompanyMap);*****/
            
            if ((lead.Email != null && lead.Email != '') && (Trigger.isInsert ||lead.Email != Trigger.oldMap.get(lead.Id).Email) && CurrentUserRoleName != 'CCHSFS - System Administrator') {
                if (leadEmailMap.containsKey(lead.Email.toLowerCase()))  { 
                    if(lead.IsWebToLead__c)   
                        lead.Duplicate_Web_To_Lead__c = true;
                    else if(leadEmailMap.get(lead.Email).RecordTypeId == lead.RecordTypeId)
                        lead.email.addError('A lead with this email address already exists');
                }
                else
                    leadEmailMap.put(lead.Email.toLowerCase(), lead);                
            }
            // Removed the comment so that it will work for Phone
          if ((lead.Phone__c != null && lead.Phone__c != '') && (Trigger.isInsert || lead.Phone__c != Trigger.oldMap.get(lead.Id).Phone__c) && CurrentUserRoleName != 'CCHSFS - System Administrator') {
                if (leadPhoneMap.containsKey(lead.Phone__c.toLowerCase())) {
                    if(lead.IsWebToLead__c)
                        lead.Duplicate_Web_To_Lead__c = true;
                    
                    else if(leadPhoneMap.get(lead.Phone__c).RecordTypeId == lead.RecordTypeId)
                      lead.Phone.addError('A lead with this Phone number already exists');
                }
                else
                    leadPhoneMap.put(lead.Phone__c.toLowerCase(), lead);                
            }
          
            //8.0
            /*
            if ((lead.EFIN__c != null && lead.EFIN__c != '') && (Trigger.isInsert || lead.EFIN__c != Trigger.oldMap.get(lead.Id).EFIN__c)) {
                if (leadEFINMap.containsKey(lead.EFIN__c.toLowerCase())) {
                    if(lead.IsWebToLead__c)
                        lead.Duplicate_Web_To_Lead__c = true;
                    else
                        lead.EFIN__c.addError('A lead with this EFIN already exists');
                }
                else
                    leadEFINMap.put(lead.EFIN__c.toLowerCase(), lead);                
            }
            */

            /*
            if(lead.FirstName != null && lead.FirstName != '') {           
                leadAddress = lead.FirstName+'%';
                leadAMFSNSfirstname.add(lead.FirstName);            
            }
            else            
                leadAddress = '%';            
            
            if(lead.LastName != null) {           
                leadAddress = leadAddress+lead.LastName+'%';
                leadAMFSNSlastname.add(lead.LastName);                    
            }
            else            
                leadAddress = leadAddress+'%';            
            */
            
            if(lead.Company != null && lead.Company != '') {           
                leadAddress = lead.Company+'%';
                leadAMFSNScompany.add(lead.Company);                    
            }
            else            
                leadAddress = '%';
           // System.debug('leadCompanyMapleadCompanyMapleadCompanyMap'+leadCompanyMap);
            
            //Commente by Vaibhav Kulkarni(Cloud Sherpas) for the Logic matching of Lead Company and Zipcode - STARTS HERE
            /*
            if(lead.Street__c != null && lead.Street__c != '') {           
                leadAddress = leadAddress+lead.Street__c+'%';
                leadAMFSNSstreet.add(lead.Street__c);                    
            }
            else            
                leadAddress = leadAddress+'%';            
            
            if(lead.City__c != null && lead.City__c != '') {           
                leadAddress = leadAddress+lead.City__c+'%';  
                leadAMFSNScity.add(lead.City__c);                  
            }
            else            
                leadAddress = leadAddress +'%';
            
            if(lead.State_Province__c != null && lead.State_Province__c != '') {          
                leadAddress = leadAddress+lead.State_Province__c+'%';  
                leadAMFSNSstate.add(lead.State_Province__c);                      
            }
            else            
                leadAddress = leadAddress +'%';
                
             if(lead.Country__c != null && lead.Country__c != '') {            
                leadAddress = leadAddress+lead.Country__c; 
                leadAMFSNScountry.add(lead.Country__c);                   
            }
            */
            //Commente by Vaibhav Kulkarni(Cloud Sherpas) for the Logic matching of Lead Company and Zipcode - ENDS HERE
            
            if(lead.Zip_Postal_Code__c != null && lead.Zip_Postal_Code__c != '') {            
                leadAddress = leadAddress+lead.Zip_Postal_Code__c+'%';
                leadAMFSNSpostalcode.add(lead.Zip_Postal_Code__c);                    
            }
            else            
                leadAddress = leadAddress +'%';     
            //System.debug('After Adding zipcode leadAddressleadAddressleadAddressleadAddress'+leadAddress);    
            
            String leadAddress1 = leadAddress.replaceAll('%','');
            leadAddress1 = leadAddress1.trim();
            
         //   System.debug('leadAddress1 leadAddress1 leadAddress1'+leadAddress1);
            if ((leadAddress1!= null && leadAddress1!='') &&
                (System.Trigger.isInsert ||(lead.Zip_Postal_Code__c != Trigger.oldMap.get(lead.Id).Zip_Postal_Code__c ||
                lead.Company != Trigger.oldMap.get(lead.Id).Company 
                /*-- Commented By Vaibhav Kulkarni (Cloud Sherpas) for Logic matching of Lead Company and Zipcode --|| lead.Street__c != Trigger.oldMap.get(lead.Id).Street__c 
                 || lead.City__c != Trigger.oldMap.get(lead.Id).City__c ||
                lead.State_Province__c != Trigger.oldMap.get(lead.Id).State_Province__c ||
                lead.Country__c != Trigger.oldMap.get(lead.Id).Country__c */))) {
                  //System.debug('Checking with existing leadAddressMapleadAddressMapleadAddressMapleadAddressMap');
                if (leadAddressMap.containsKey(leadAddress.toLowerCase())){ 
                  
                    if(lead.IsWebToLead__c)
                        lead.Duplicate_Web_To_Lead__c = true;
                    else
                        lead.addError('A lead with this Company Name and Zip code already exists');
                }
                else 

                    leadAddressComZip = leadAddress.replaceAll('%','');
                    leadAddressComZip = leadAddressComZip.trim();
            
                    leadAddressMap.put(leadAddressComZip.toLowerCase(), lead);
                   // System.debug('leadAddressMapleadAddressMapleadAddressMap Checking Map'+leadAddressMap);
            }            
       }
       
       //Refunds today
       String leadAddress_Refunds_today;
       if(lead.RecordTypeId==RefundsTodayRecordTypeId){
            String LeadEmailPhone = '';
            if(lead.Email != null) {           
                LeadEmailPhone = lead.Email+'%'; 
                leadRTemail.add(lead.Email);           
            }
            else            
                LeadEmailPhone = '%';
            
            if(lead.Phone!=null && lead.Phone != '')  {         
                LeadEmailPhone = LeadEmailPhone+lead.Phone; 
                leadRTphone.add(lead.Phone);            
            }
      //  system.debug('**** chk5' +  leadRTemail);  
            /*****
            //Added to Check Duplicate Logic for the Company and Zip code logic for Record Type 'Refunds today' -- STARTS HERE
            if(lead.Company != null && lead.Company != '') {           
                leadAddress_Refunds_today = lead.Company+'%';
                leadAMFSNScompany.add(lead.Company);                    
            }
            else            
                //leadAddress_Refunds_today = leadAddress+'%';  
                leadAddress_Refunds_today  = '%'; 
            
            if(lead.PostalCode != null && lead.PostalCode  != '') {            
                //leadAddress_Refunds_today = leadAddress+lead.Zip_Postal_Code__c+'%';
                leadAddress_Refunds_today = leadAddress_Refunds_today +lead.PostalCode +'%';
                leadAMFSNSpostalcode.add(lead.PostalCode );                    
            }
            else            
                leadAddress_Refunds_today = leadAddress_Refunds_today +'%';
            
            System.debug('leadAddress_Refunds_todayleadAddress_Refunds_today '+leadAddress_Refunds_today);*****/
            //Added to Check Duplicate Logic for the Company and Zip code logic for Record Type 'Refunds today' -- ENDS HERE
            
            String LeadEmailPhone1 = LeadEmailPhone.replaceAll('%','');
        
            if (( LeadEmailPhone1!= null && LeadEmailPhone1!='') &&
                (System.Trigger.isInsert || lead.Email != System.Trigger.oldMap.get(lead.Id).Email || 
                lead.Phone != System.Trigger.oldMap.get(lead.Id).Phone)) {
                if (leadEmailPhoneMap.containsKey(LeadEmailPhone.toLowerCase())) {
                    lead.email.addError('A lead with this email address already exists');
                    /*****lead.Phone.addError('A lead with this Phone number already exists');*****/
                } 
                else 
                    leadEmailPhoneMap.put(LeadEmailPhone.toLowerCase(), lead);                
            }
            /*****
            //Added to Check Duplicate Logic for the Company and Zip code logic for Record Type 'Refunds today' -- STARTS HERE
            String leadAddress_Refunds_today1 = leadAddress_Refunds_today.replaceAll('%','');
        
            if (( leadAddress_Refunds_today1!= null && leadAddress_Refunds_today1!='') &&
                (System.Trigger.isInsert || lead.PostalCode!= System.Trigger.oldMap.get(lead.Id).PostalCode || 
                lead.Company != System.Trigger.oldMap.get(lead.Id).Company)) {
                if (leadAddressMap.containsKey(leadAddress_Refunds_today1.toLowerCase())) {
                    lead.PostalCode.addError('A lead with this Zip code already exists');
                    lead.Company.addError('A lead with this Company already exists');
                } 
                else 
                    leadAddressMap.put(leadAddress_Refunds_today1.toLowerCase(), lead);  
                    
            }*****/
            //Added to Check Duplicate Logic for the Company and Zip code logic for Record Type 'Refunds today' -- ENDS HERE
            
            /*
            //Update Primary Contact Name and Primary Contact Email if it is null or blank
            if(lead.Primary_Contact_Name__c == '' || lead.Primary_Contact_Name__c == null){
                if(lead.FirstName <> null && lead.FirstName <> '')
                    lead.Primary_Contact_Name__c = lead.FirstName + ' ' + lead.LastName;  
                                  
                if(lead.FirstName == null || lead.FirstName == '')
                    lead.Primary_Contact_Name__c = lead.LastName;                
            }
            */
            
            if(lead.Primary_Contact_Email__c == '' || lead.Primary_Contact_Email__c == null)
                lead.Primary_Contact_Email__c = lead.Email;
            
            //Update Premier Account Manager
            if(lead.Premier_Account_Manager__c == '' || lead.Premier_Account_Manager__c == null)
                    lead.Premier_Account_Manager__c = OwnerIdNameMap.get(lead.ownerId);                 
       
            //Update Contract Expiration Date
            if(Trigger.isBefore && Trigger.isInsert){
                if(lead.Process__c == 'Sign and Close a Prospect'){ 
                    
                    if(lead.Contract_Expiration_Date__c <> NULL && 
                    lead.Contract_Expiration_Date__c <> ''){
                        currentEXPValue = lead.Contract_Expiration_Date__c;                        
                        currentEXPYear = Integer.valueOf(currentEXPValue.substring(0,4));                        
                        nextContractEXP = currentEXPYear + 1 + ' EXP';                        
                        lead.Contract_Expiration_Date__c = nextContractEXP;
                    }
                    if((lead.Contract_Expiration_Date__c == NULL || 
                    lead.Contract_Expiration_Date__c == '')){
                        lead.Contract_Expiration_Date__c = nextContractEXPNull;
                    }
                }
            }
            if(Trigger.isBefore && Trigger.isUpdate){
                if(lead.Process__c <> Trigger.oldMap.get(lead.Id).Process__c &&
                    lead.Process__c == 'Sign and Close a Prospect'){ 
                    
                    if((lead.Contract_Expiration_Date__c <> NULL && 
                    lead.Contract_Expiration_Date__c <> '') &&
                    lead.Contract_Expiration_Date__c == Trigger.oldMap.get(lead.Id).Contract_Expiration_Date__c){
                        currentEXPValue = lead.Contract_Expiration_Date__c;
                        currentEXPYear = Integer.valueOf(currentEXPValue.substring(0,4));
                        nextContractEXP = currentEXPYear + 1 + ' EXP';
                        lead.Contract_Expiration_Date__c = nextContractEXP;
                    }
                    if(lead.Contract_Expiration_Date__c == NULL || 
                    lead.Contract_Expiration_Date__c == ''){
                        lead.Contract_Expiration_Date__c = nextContractEXPNull;
                    }
                }
            }
       }
    }
    
    /*if(leadCompanyMap!= null && leadCompanyMap.size()>0 && CurrentUserRoleName != 'CCHSFS - System Administrator'){
        for (Lead lead : [SELECT Company FROM Lead
                          WHERE Company IN :leadCompanyMap.KeySet() AND RecordTypeId=:AMFSNSRecordTypeId]) {
            Lead newLead = leadCompanyMap.get(lead.Company.toLowerCase());
            if(newLead.IsWebToLead__c)
                newLead.Duplicate_Web_To_Lead__c = true;
            else
                newLead.Company.addError('A lead with this Company already exists');
        }
    }*/
    
    if(leadEmailMap != null && leadEmailMap.size()>0 && CurrentUserRoleName != 'CCHSFS - System Administrator'){
        for (Lead lead : [SELECT Email,RecordTypeId FROM Lead   WHERE Email IN :leadEmailMap.KeySet() AND (RecordTypeId=:AMFSNSRecordTypeId OR RecordTypeId=:RefundsTodayRecordTypeId  OR RecordTypeId=:LeadsTrustRecordTypeId)]) {
            Lead newLead = leadEmailMap.get(lead.Email.toLowerCase());
            if(newLead.IsWebToLead__c &&  newLead.RecordTypeId == lead.RecordTypeId)
                newLead.Duplicate_Web_To_Lead__c = true;
            else if(newLead.RecordTypeId == lead.RecordTypeId)
                newLead.email.addError('A lead with this email address already exists');
        }
        
        //8.0
        for (Account account : [SELECT Email__c ,RecordTypeId FROM Account WHERE (Email__c != NULL AND Email__c != '') AND Email__c IN :leadEmailMap.KeySet() AND (RecordTypeId=:AMFSNSAccountRecordTypeId OR RecordTypeId=:RefundsTodayAccountRecordTypeId OR RecordTypeId=:TrustAccountRecordTypeId)]) {
            Lead newLead = leadEmailMap.get(account.Email__c.toLowerCase());
            if(newLead.IsWebToLead__c)
                newLead.Duplicate_Web_To_Lead__c = true;
           else if((newLead.RecordTypeId == AMFSNSRecordTypeId && account.RecordTypeId ==AMFSNSAccountRecordTypeId ) || (newLead.RecordTypeId == RefundsTodayRecordTypeId  && account.RecordTypeId == RefundsTodayAccountRecordTypeId ) || (newLead.RecordTypeId == LeadsTrustRecordTypeId  && account.RecordTypeId == TrustAccountRecordTypeId ) )
                newLead.Email.addError('An Account with this email address already exists');
        }
    }
    // Removed the comment so that it will work for Phone
    if(leadPhoneMap != null && leadPhoneMap.size() > 0 && CurrentUserRoleName != 'CCHSFS - System Administrator'){
        for (Lead lead : [SELECT Phone__c ,RecordTypeId  FROM Lead WHERE Phone__c != NULL AND Phone__c IN :leadPhoneMap.KeySet() AND (RecordTypeId=:AMFSNSRecordTypeId OR RecordTypeId=:RefundsTodayRecordTypeId OR RecordTypeId=:LeadsTrustRecordTypeId)]) {
            Lead newLead = leadPhoneMap.get(lead.Phone__c.toLowerCase());
            if(newLead.IsWebToLead__c && newLead.RecordTypeId == lead.RecordTypeId )
                newLead.Duplicate_Web_To_Lead__c = true;
            else if(newLead.RecordTypeId == lead.RecordTypeId)
                newLead.Phone__c.addError('A lead with this phone number already exists');
        }
    
       
        //8.0
        for (Account account : [SELECT Phone__c ,RecordTypeId FROM Account  WHERE (Phone__c != NULL AND Phone__c != '') AND Phone__c IN :leadPhoneMap.KeySet() AND (RecordTypeId=:AMFSNSAccountRecordTypeId OR RecordTypeId=:RefundsTodayAccountRecordTypeId OR RecordTypeId=:TrustAccountRecordTypeId)]) {
            Lead newLead = leadPhoneMap.get(account.Phone__c.toLowerCase());
            if(newLead.IsWebToLead__c)
                newLead.Duplicate_Web_To_Lead__c = true;
            else if((newLead.RecordTypeId == AMFSNSRecordTypeId && account.RecordTypeId ==AMFSNSAccountRecordTypeId ) || (newLead.RecordTypeId == RefundsTodayRecordTypeId  && account.RecordTypeId == RefundsTodayAccountRecordTypeId )|| (newLead.RecordTypeId == LeadsTrustRecordTypeId  && account.RecordTypeId == TrustAccountRecordTypeId ) )
                newLead.Phone__c.addError('An Account with this phone number already exists');
        }
    }
  
    //8.0
    /*
    if(leadEFINMap!=null && leadEFINMap.size()>0){
        for (Lead lead : [SELECT EFIN__c FROM Lead
                          WHERE EFIN__c != NULL AND EFIN__c IN :leadEFINMap.KeySet() AND RecordTypeId=:AMFSNSRecordTypeId]) {
            Lead newLead = leadEFINMap.get(lead.EFIN__c.toLowerCase());
            if(newLead.IsWebToLead__c)
                newLead.Duplicate_Web_To_Lead__c = true;
            else
                newLead.EFIN__c.addError('A lead with this EFIN already exists');
        }
        
        for (Account account : [SELECT EFIN__c FROM Account
                          WHERE EFIN__c != NULL AND EFIN__c IN :leadEFINMap.KeySet() AND RecordTypeId=:AMFSNSAccountRecordTypeId]) {
            Lead newLead = leadEFINMap.get(account.EFIN__c.toLowerCase());
            if(newLead.IsWebToLead__c)
                newLead.Duplicate_Web_To_Lead__c = true;
            else
                newLead.EFIN__c.addError('An Account with this EFIN already exists');
        }
    }
    */
    
    //Checking the Company Name and Zip code for existing Leads so Querying with Company and Zipcode and match it from Map 'leadAMFSNSExistingMap'
/*****if(leadAddressMap!=null && leadAddressMap.size()>0 && CurrentUserRoleName != 'CCHSFS - System Administrator'){
        for (Lead lead : [SELECT Company,Street__c,City__c,State_Province__c,Zip_Postal_Code__c,Country__c,PostalCode,RecordTypeId FROM Lead
                          WHERE Company IN :leadAMFSNScompany AND (Zip_Postal_Code__c IN :leadAMFSNSpostalcode  OR PostalCode  IN :leadAMFSNSpostalcode ) 
                          /* Commented By Vaibhav Kulkarni, Checking the Duplicacy logic for the existing Leads -- STARTS HERE
                          AND Street__c IN :leadAMFSNSstreet  
                          AND City__c IN :leadAMFSNScity AND State_Province__c IN :leadAMFSNSstate                    
                          AND Country__c IN :leadAMFSNScountry 
                          Commented By Vaibhav Kulkarni, Checking the Duplicacy logic for the existing Leads -- ENDS HERE */
                          
                        /*  AND (RecordTypeId =:AMFSNSRecordTypeId OR RecordTypeId =:RefundsTodayRecordTypeId)]) {
            System.debug('Checking with existing leadAddressMapleadAddressMapleadAddressMapleadAddressMap');                
            //String leadAMFSNSaddress = lead.Company+'%'+lead.Street__c+'%'+lead.City__c+'%'+lead.State_Province__c+'%'+lead.Zip_Postal_Code__c+'%'+lead.Country__c;
            String leadAMFSNSaddress ;
            if(Lead.RecordTypeId == AMFSNSRecordTypeId ){
                leadAMFSNSaddress = lead.Company+'%'+lead.Zip_Postal_Code__c;
            }
            else if(Lead.RecordTypeId == RefundsTodayRecordTypeId){
                leadAMFSNSaddress = lead.Company+'%'+lead.PostalCode ;
            }
            String leadAMFSNSaddress1 = leadAMFSNSaddress.replaceAll('%','');
            leadAMFSNSaddress1 = leadAMFSNSaddress1.trim();
            leadAMFSNSExistingMap.put(leadAMFSNSaddress1.toLowerCase(), lead); 
            System.debug('leadAMFSNSExistingMapleadAMFSNSExistingMapleadAMFSNSExistingMap'+leadAMFSNSExistingMap); 
            System.debug('leadAddressMapleadAddressMapleadAddressMap--'+leadAddressMap); 
        }
        
        for(String thisAddress:leadAddressMap.KeySet()){
          System.debug('thisAddressthisAddressthisAddress LOOP'+thisAddress);
          
            if(leadAMFSNSExistingMap.containskey(thisAddress.toLowerCase())) {
              System.debug('leadAMFSNSExistingMapleadAMFSNSExistingMap Match Found');
                Lead newLead = leadAddressMap.get(thisAddress);
                if(newLead.IsWebToLead__c)
                    newLead.Duplicate_Web_To_Lead__c = true;
                else
                    newLead.addError('A lead with this Company Name and Zip code already exists');
            }
        }
        
        for (Account account : [SELECT Id,Account_Name_Address_Merge__c FROM Account
                          WHERE Account_Name_Address_Merge__c IN :leadAddressMap.KeySet()
                          AND RecordTypeId =:AMFSNSAccountRecordTypeId]) {
            Lead newLead = leadAddressMap.get(account.Account_Name_Address_Merge__c.toLowerCase());
            if(newLead.IsWebToLead__c)
                newLead.Duplicate_Web_To_Lead__c = true;
            else
                newLead.addError('An Account with this Company Name and Address already exists');
        }
    }*****/
    
    //Checking the Phone and Email of existing Leads with the Record Type 'RefundsTodayRecordTypeId'
    if(LeadEmailPhoneMap!= null && LeadEmailPhoneMap.size()>0){
        for (Lead lead : [SELECT Email,Phone,RecordTypeId FROM Lead WHERE Email IN :leadRTemail 
                          /*****AND Phone IN :leadRTphone*****/ AND (RecordTypeId =:RefundsTodayRecordTypeId OR RecordTypeId =: AMFSNSRecordTypeId)])  {
            
            String leadRTemailemail = '';
            if(lead.Email != null) {           
                leadRTemailemail = lead.Email+'%';                            
            }
            else            
                leadRTemailemail = '%';
            
            if(lead.Phone!=null && lead.Phone != '')  {         
                leadRTemailemail = leadRTemailemail +lead.Phone; 
            }
            /*****String leadRTemailemail = lead.Email+'%'+lead.Phone;
            leadRTExistingMap.put(leadRTemailemail.toLowerCase(),lead);*****/
            if(leadRTExistingMap.containskey(leadRTemailemail.toLowerCase())){
               leadRTExistingMap.get(leadRTemailemail.toLowerCase()).add(lead);            
            }
            else
            {
              leadRTExistingMap.put(leadRTemailemail.toLowerCase(),new List<Lead>{lead});
            }             
        }
        
        system.debug('**** chk3' + LeadEmailPhoneMap.KeySet());
        system.debug('**** chk4' + leadRTExistingMap);
        for(String thisEmailPhone:LeadEmailPhoneMap.KeySet()) {  
            if(leadRTExistingMap.containskey(thisEmailPhone.toLowerCase())){
                system.debug('***chk1' + LeadEmailPhoneMap.get(thisEmailPhone).RecordTypeId);
                //system.debug('***chk2' + leadRTExistingMap.get(thisEmailPhone.toLowerCase()).RecordTypeId);
              for(Lead Lea: leadRTExistingMap.get(thisEmailPhone.toLowerCase()) ){  
              if(LeadEmailPhoneMap.get(thisEmailPhone).RecordTypeId == Lea.RecordTypeId){
                   
                    Lead newLead = LeadEmailPhoneMap.get(thisEmailPhone.toLowerCase());
                   /***** newLead.Email.addError('A RT lead with this email address already exists');*****/
                    /*****newLead.Phone.addError('A RT lead with this Phone number already exists');*****/
                    newLead.Email.addError('A lead with this email address already exists');
               }  
               }    
            }
        }
    }  
}