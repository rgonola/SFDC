public without sharing class iFirmtaskExt{

     public List<Account> acc {get; set;}
     public Boolean iserror {get; set;}
     public String Cid {get;set;}
     public String CompName {get;set;}
     public String FirstName{get;set;}
     public String LastName {get;set;}
     public String Email {get;set;} 
     public String PhneNumber {get;set;} 
     public String IfirmUrl {get;set;}
     public String Users {get;set;}
     public String bodyStr;
     public String taskOwner;
    public iFirmtaskExt(){
        
    }  
    
    public  Boolean checkEmail (String sEmail) {
        
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);
    
        Matcher MyMatcher = MyPattern.matcher(sEmail);
    
        if (!MyMatcher.matches()) {
            return false;
            }
        else {
            return true;
        }
    }

    public Pagereference  save(){
        
        iserror = true; 
        // validate CID field
        if ( Cid  != null && !Pattern.matches('^[0-9]{7,20}$', Cid ) ) {
            VFUtil.AddErrorMessage ('CID is not valid.');
            iserror =false;
            return null;
        } 
         
        acc = [SELECT ID, Name, CID__c FROM Account WHERE CID__c =: Cid];
        
        if (acc.size() ==0 ) {
           VFUtil.AddErrorMessage('Invalid CID entered. Please enter again.');
           iserror =false;
           return null; 
        }
       
        if ( (CompName  != null && CompName.length() < 2 ) ) {
            VFUtil.AddErrorMessage('Organization Name is required');
            iserror =false;
            return null ;
        }
        
        if (CompName  != null && CompName.isNumeric() ) {
            VFUtil.AddErrorMessage('Please enter valid Organization Name. Please do not include Numbers ( 1, 2, 3, etc). ');
            iserror =false;
            system.debug('firstname error' +LastName);
            return null ;
        }
        
        String nameregex= '[\\p{L}\\s\\d]*$';
        Pattern myPattern = Pattern.compile( nameregex);
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher mynameMatcher = MyPattern.matcher(CompName);
        
        system.debug('firstname error' +mynameMatcher );
        
        if (!mynameMatcher.matches()) {
            
            VFUtil.AddErrorMessage('Please enter valid Organization Name. Please do not include special characters ( -, &, #, etc).');
            iserror =false;
            return null;
        }       
  
                // Validate Name
        if (FirstName != null && FirstName.length() < 2)  {
            VFUtil.AddErrorMessage('First Name is required');
            iserror =false;
            system.debug('firstname error' +FirstName );
            return null ;
        }
        
        
        if (FirstName.isNumeric() || !FirstName.isAlpha() ) {
            VFUtil.AddErrorMessage('Please enter valid First Name. Please do not include Numbers ( 1, 2, 3, etc).');
            iserror =false;
            system.debug('firstname error' +FirstName );
            return null ;
        }
        
        if ( (LastName != null && LastName.length() < 2 ) ) {
            VFUtil.AddErrorMessage('Last Name is required');
            iserror =false;
            return null ;
        }
        
        if (LastName.isNumeric() || !LastName.isAlpha()) {
            VFUtil.AddErrorMessage('Please enter valid Last Name. Please do not include Numbers ( 1, 2, 3, etc).');
            iserror =false;
            system.debug('firstname error' +LastName);
            return null ;
        }
        
       // String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.) |-( ([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,10}|[0-9]{1,3})';
        //Pattern MyPattern2 = Pattern.compile(emailRegex);
            // Then instantiate a new Matcher object "MyMatcher"
           // Matcher myMatcher = MyPattern2.matcher(Email);
            
            
       if (!checkEmail(Email)) {   
                VFUtil.AddErrorMessage('Please enter a valid email address.');
                iserror =false;
                system.debug('firstname error' +Email);
                return null ;
       }
        
        if (PhneNumber != null && !Pattern.matches('^$|^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$|^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4} x[a-zA-Z0-9]{1,4}$', PhneNumber) ) {
            //VFUtil.addError('Phone number must be at least 10 digits long. Acceptable formats: (123) 456-7891 or (123) 456-7891 x1234');
            VFUtil.AddErrorMessage ('Phone number must be at least 10 digits long. Acceptable formats: (123)456-7891 or (123)456-7891 x1234');
           iserror =false;
            return null;
        }
       
        if(IfirmUrl==null || IfirmUrl==''){
        
        VFUtil.AddErrorMessage ( 'Please enter URL.');
        iserror =false;
        return null;
        
        }
        
       if(IfirmUrl.isNumeric() || !IfirmUrl.isAlpha()){
        
        VFUtil.AddErrorMessage ( 'Make sure URL is not Alphanumeric.');
        iserror =false;
        return null;
        
        }
        
        String checkURL = '[\\p{L}\\s\\d]*$';
        Pattern myPattern3 = Pattern.compile(checkURL);
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher mynameMatcher2 = MyPattern.matcher(IfirmUrl);
        
        system.debug('firstname error' +mynameMatcher2 );
        
        if (!mynameMatcher2.matches()) {
            
            VFUtil.AddErrorMessage('Please enter valid URL. Please do not include special characters ( -, &, #, etc).');
            iserror =false;
            return null;
        }
        
        /*if(Users==null || Users==''){
        
        VFUtil.AddErrorMessage ( 'Please enter number of users.');
        iserror =false;
        return null;
        
        }
        
        if (Users.isAlpha())  {
             VFUtil.AddErrorMessage ( 'Please enter valid number.');
             iserror =false;
             return null;
        }
        
        if (Users.length() > 3)  {
             VFUtil.AddErrorMessage ( 'Total users can not be greater than 99.');
             iserror =false;
             return null;
        }*/
            
        if (iserror == true && acc.size() > 0) {
        
           Task t = new Task();
            t.OwnerId = Label.iFirm_Task_Owner_2;
            t.Subject = 'iFirm Seasonal Offer - Manual Action Required';
            t.description= 'AR to delete portal and add Seasonal Edition at $199, ensure nothing will be pro-rated or refunded. If > 3 users, each additional user should be added at $250/year.';
            t.Status = 'Not Started';
            t.ReminderDateTime = DATE.TODAY()+1;
            t.Priority = 'Normal';
            t.WhatId = acc[0].ID;
            insert t;
         
            Task t1 = new Task();
            t1.OwnerId = Label.iFirm_Task_Owner_1;
            t1.Subject = 'iFirm Seasonal Offer - Manual Action Required';
            t1.description= 'AR to delete portal and add Seasonal Edition at $199, ensure nothing will be pro-rated or refunded. If > 3 users, each additional user should be added at $250/year.';
            t1.Status = 'Not Started';
            t1.ReminderDateTime = DATE.TODAY()+1;
            t1.Priority = 'Normal';
            t1.WhatId = acc[0].ID;
            insert t1;
        
       bodyStr='title'+'\n' + 'notes';
            
          bodyStr+='\n\niFirm Portal Only Form Submission Summary\n' +
                   'CID                : ' + Cid + '\n' + 
                   'Company Name       : ' + CompName + '\n' + 
                   'First Name         : ' + FirstName + '\n' + 
                   'Last Name          : ' + LastName + '\n' + 
                   'Email              : ' + Email + '\n' + 
              	   'Phone Number	   : ' + PhneNumber + '\n' +
                   'iFirm URL          : ' + IfirmUrl + '\n' +		
                   'Requested # Users  : ' + '3' + '\n' ;
         
         bodyStr+='\n\n\n'+System.now();
        
        Attachment att=new Attachment();
         att.OwnerId= Label.iFirm_Task_Owner_2;
         att.Body=Blob.valueOf(bodyStr);
         att.Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
         att.parentId=t.Id;
         insert att;       
        
        Attachment att1=new Attachment();
         att1.OwnerId=Label.iFirm_Task_Owner_1;
         att1.Body=Blob.valueOf(bodyStr);
         att1.Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
         att1.parentId=t1.Id;
         insert att1;      
        }       
            String url = '/apex/iFirmSeasonalPortalBuy_TY';
            return new PageReference(url);
    
   }
 
 
 
}