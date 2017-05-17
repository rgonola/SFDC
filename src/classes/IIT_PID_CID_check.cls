//Purpose: To accept inputs (webservice), increment PID and CID where necessary, 
//update the account and output via webservice.
//Exposed webservice methods= 
// noPID_noCID_noOFFC_AccID,  output  PID_noCID_noOFFC_AccID,PID_noCID_OFFC_AccID,noPID_CID_noOFFC_AccID,PID_CID_OFFC_AccID
//--------------------------------------------
//Precondition : custom settings PID_last and CID_last already created. 
//               value stored in invoiceit_s__Number_Value__c field
//---------------------------------------------
//Date Created: Nov 4 2015 
//Author: K. Yatim
// ********history here ********************************//
// Date         Author          Development description
//******************************************************//
//Nov-14-2015   K Yatim         Added Scenario 5
//Nov-23-2015   K Yatim         Added Scenario 6

global class IIT_PID_CID_check {

    
    //this is what the final output values are stored in.
    global class output {
        webservice string oPID;
        webservice string oCID;
        webservice integer oOFFC;
        webservice string oGroupId;
        webservice string oStatus;
        webservice string oErrorMsg;
    }
    
    
     
    //All scenario specs at EOF.
    //This is the webmethod to call for SCENARIO ONE
    webservice static output noPID_noCID_noOFFC_AccID(integer PID, integer CID, integer OFFC, string acct) {

        list <account> acc = [SELECT id, name, CID__c,PID_GROUP__c,PID__c,OFFC__c FROM account WHERE id = :acct For Update];
        output returnedOP=new output();
        
        if (acc.size()>0 && CID==null && PID==Null && OFFC==null)  {
            
            string error='';
            //check if SFDC account already has values
            if ( acc[0].pid__c <> null && acc[0].pid__c <> '') error='PID already populated in SFDC';
            if ( acc[0].cid__c <> null && acc[0].cid__c <> '') error='CID already populated in SFDC';
            if ( acc[0].OFFC__c >0  ) error='OFFC already populated in SFDC';
                        
            //check for and get output from the correct scenario
            if (PID==null && CID==null && error=='' ) {
                returnedOP = Scenario1 (acc, acct) ; 
            } 
            else { 
                returnedOP.oPID=null; 
                returnedOP.oCID=null;
                returnedOP.oOFFC=null;
                returnedOP.oGroupId =null;
                returnedOP.oStatus ='Failed';
                returnedOP.oErrorMsg= 'Ensure PID, OFFC and CID provided are null. ' + error ;
            } 
        }
        else {
            returnedOP.oPID=string.valueof(pid);
            returnedOP.oCID=string.valueof(cid );
            returnedOP.oOFFC=offc;
            returnedOP.oGroupId =null;
            returnedOP.oStatus ='Failed';
            returnedOP.oErrorMsg='No Account Found';
        }  system.debug ('xxxxxxxxxx SCENARIO ONE'   + returnedOP);
        return returnedOP;      // return output 
    }
        //This is the webmethod to call for SCENARIO 2
        webservice static output  PID_noCID_noOFFC_AccID(integer PID, integer CID, integer OFFC, string acct) {

            list <account> acc = [SELECT id, name, CID__c,PID_GROUP__c,PID__c,OFFC__c FROM account WHERE id = :acct For Update];
            output returnedOP=new output();
            
            if (acc.size()>0 && PID<>null && CID==null && OFFC==null  )  {
            
                string error='';
                if ( acc[0].cid__c <> null && acc[0].cid__c <> '') error='CID already populated in SFDC';
                if ( acc[0].OFFC__c >0) error='OFFC already populated in SFDC'; 
                
                //check for and get output from the correct scenario
                if (error=='' && pid!=null && cid==null && (offc==null || offc==0)  ) {
                        returnedOP = Scenario2 (acc, acct, string.valueof(pid) ) ; 
                } 
                else {
                    returnedOP.oPID=null;
                    returnedOP.oCID=null;
                    returnedOP.oOFFC=null;
                    returnedOP.oGroupId =null;
                    returnedOP.oStatus ='Failed';
                    returnedOP.oErrorMsg='Ensure PID is provided, provide null for CID and OFFC. ' + error ;
                } 
            }
            else {
                returnedOP.oPID=string.valueof(pid);
                returnedOP.oCID=string.valueof(cid );
                returnedOP.oOFFC=offc;
                returnedOP.oGroupId =null;
                returnedOP.oStatus ='Failed';
                returnedOP.oErrorMsg='No Account Found';
            }system.debug ('xxxxxxxxxx SCENARIO TWO'   + returnedOP);
            return returnedOP;      // return output 
    }
        //This is the webmethod to call for SCENARIO 3.
    webservice static output  PID_noCID_OFFC_AccID(integer PID, integer CID, integer OFFC, string acct) {

        list <account> acc = [SELECT id, name, CID__c,PID_GROUP__c,PID__c,OFFC__c FROM account WHERE id = :acct For Update];
        output returnedOP=new output();
        
        if (acc.size()>0 && PID<>null && cid==null && OFFC>0)  {
            
            string error='';
            //check if SFDC account already has values 
            if ( acc[0].cid__c <> null && acc[0].cid__c <> '') error='CID already populated in SFDC'; 
            if ( acc[0].OFFC__c >0  ) error='OFFC already populated in SFDC';
            
            //check for and get output from the correct scenario
            if (pid!=null && cid==null  && offc>0 && error=='' )  {
                    returnedOP = Scenario3 (acc, acct, string.valueof(pid), offc) ; 
            }
            else {
                returnedOP.oPID=null;
                returnedOP.oCID=null;
                returnedOP.oOFFC=null;
                returnedOP.oGroupId =null;
                returnedOP.oStatus ='Failed';
                returnedOP.oErrorMsg='Ensure PID is provided, OFFC is more than 0, provide null for CID. ' + error ;
            } 
        }
        else {
            returnedOP.oPID=string.valueof(pid);
            returnedOP.oCID=string.valueof(cid );
            returnedOP.oOFFC=offc;
            returnedOP.oGroupId =null;
            returnedOP.oStatus ='Failed';
            returnedOP.oErrorMsg='No Account Found';
        }system.debug ('xxxxxxxxxx SCENARIO THREE'   + returnedOP);
        return returnedOP;      // return output 
    }
       
       
   
    //This is the webmethod to call for SCENARIO 4.
    webservice static output  noPID_CID_noOFFC_AccID(integer PID, integer CID, integer OFFC, string acct) {

        list <account> acc = [SELECT id, name, CID__c,PID_GROUP__c,PID__c,OFFC__c FROM account WHERE id = :acct For Update];
        output returnedOP=new output();
        
        if (acc.size()>0 && PID==null && CID<>null)  {
            string error='';
            
            //check if SFDC account already has values
            if ( acc[0].pid__c <> null && acc[0].pid__c <> '') error='PID already populated in SFDC'; 
            if ( acc[0].OFFC__c >0  ) error='OFFC already populated in SFDC';
            
            //check for and get output from the correct scenario
            if (pid==null && cid!=null && error=='' )  {  
                    returnedOP = Scenario4 (acc, acct, string.valueof(cid ) ) ; 
            }
            else {
                returnedOP.oPID=null;
                returnedOP.oCID=null;
                returnedOP.oOFFC=null;
                returnedOP.oGroupId =null;
                returnedOP.oStatus ='Failed';
                returnedOP.oErrorMsg='Ensure CID is provided, provide null for PID. ' + error ;
            } 
        }
        else {
            returnedOP.oPID=string.valueof(pid);
            returnedOP.oCID=string.valueof(cid );
            returnedOP.oOFFC=offc;
            returnedOP.oGroupId =null;
            returnedOP.oStatus ='Failed';
            returnedOP.oErrorMsg='No Account Found or Ensure CID is provided, provide null for PID ';
        } system.debug ('xxxxxxxxxx SCENARIO FOUR'   + returnedOP);
        return returnedOP;      // return output 
    }
    
    //This is the webmethod to call for SCENARIO 5     
    //Both scenarios have the same parameters passed in
    webservice static output PID_CID_OFFC_AccID(integer PID, integer CID, integer OFFC, string acct) {
        list <account> acc = [SELECT id, name,CID__c,PID_GROUP__c,PID__c,OFFC__c FROM account 
                              WHERE id = :acct OR CID__c=:string.valueof (CID)    
                              For Update];
                              
        output returnedOP=new output();
        
        system.debug('aaaaaaaaa  ' + acc);
        
        if (acc.size()==1)  {
            string error='';
            
            if (pid!=null && cid!=null   )  {  
                    returnedOP = Scenario5  (acc, acct, string.valueof(cid ),string.valueof(pid),OFFC ) ; 
            }
            else {
                returnedOP.oPID=null;
                returnedOP.oCID=null;
                returnedOP.oOFFC=null;
                returnedOP.oGroupId =null;
                returnedOP.oStatus ='Failed';
                returnedOP.oErrorMsg='Ensure CID and PID and AccountID are provided. ' + error ;
            } 
        }
        else {
            returnedOP.oPID=string.valueof(pid);
            returnedOP.oCID=string.valueof(cid );
            returnedOP.oOFFC=offc;
            returnedOP.oGroupId =null;
            returnedOP.oStatus ='Failed';
            returnedOP.oErrorMsg='No Account Found or Ensure CID and AccID provided belong to the same account';
        } system.debug ('xxxxxxxxxx SCENARIO FIVE '   + returnedOP);
        return returnedOP;      // return output 
        
    }
    
            //This is the webmethod to call for SCENARIO 6.
    webservice static output  PID_CID_newOFFC_AccID(integer PID, integer CID, integer OFFC, string acct) {

        list <account> acc = [SELECT id, name, CID__c,PID_GROUP__c,PID__c,OFFC__c FROM account WHERE id = :acct For Update];
        output returnedOP=new output();
        
        if (acc.size()>0 && PID<>null && cid<>null && OFFC<>null)  {
 
            //check for and get output from the correct scenario
 
             returnedOP = Scenario6 (acc, acct, string.valueof(cid),  string.valueof(pid), offc) ; 
 
        }
        else {
            returnedOP.oPID=string.valueof(pid);
            returnedOP.oCID=string.valueof(cid );
            returnedOP.oOFFC=offc;
            returnedOP.oGroupId =null;
            returnedOP.oStatus ='Failed';
            returnedOP.oErrorMsg='Ensure PID, CID are provided, OFFC is not blank.';
        }system.debug ('xxxxxxxxxx SCENARIO six'   + returnedOP);
        return returnedOP;      // return output 
    }
    
    
    
    //this fills the output wrapper with the final values. Error is blank unless an exception occured  
    static output CreateOutput(string error, string pid, string CID, integer offc, string groupId) {
        output OP = new output();
        OP.oPID = pid;
        OP.oCID = CID;
        OP.oOFFC = offc;
        OP.oGroupId = groupId;
        if (error=='' || error==null)      OP.oStatus='Success';    
        else {
            OP.oErrorMsg= error;
            OP.oStatus='Failed';
        }
        return OP;
     }
    
    static string createNewPID_Group(integer pid, string accid, string AccName) {
         //for now name it G + pid number
         
        PID_GROUP__c pidgroup= new PID_GROUP__c(Account_Record__c = accid, name= AccName   ) ;
        insert pidgroup;
        
        return string.valueof(pidgroup.id);
         
    }
    
   webservice static string[] incrementPID (string acctID, string AccName) {  //2 returns. pid and pidgroupId
            integer newPID;
            invoiceit_s__Configuration__c pidCustomsetting  =invoiceit_s__Configuration__c.getValues('PID_last' ) ; 
            newPID= integer.valueof(pidCustomsetting.invoiceit_s__Number_Value__c )    ;
            newPID=newPID+1 ;
            //createNewPID_Group();
            string pidgroupid = createNewPID_Group(newPID,acctID, AccName ); 
            
            pidCustomsetting.invoiceit_s__Number_Value__c = decimal.valueof(newPID);
            update pidCustomsetting;
            
            string [] a=new string[]{ string.valueof(newPID),pidgroupid  };  //need to return the incremented  pid and the SFDC id of the new PidGroup
            return a;//string.valueof(newPID);
    }
    webservice static string incrementCID() {   //return cid
            integer newCID;
            invoiceit_s__Configuration__c cidCustomsetting  =invoiceit_s__Configuration__c.getValues('CID_last' ) ; 
            newCID = integer.valueof(cidCustomsetting.invoiceit_s__Number_Value__c )    ;
            newCID=newCID+1 ;
             
            cidCustomsetting.invoiceit_s__Number_Value__c = decimal.valueof(newCID);
            update cidCustomsetting;    
            
            return string.valueof(newCID);
    }
    //once the values are retrieved, update the SFDC account using this. Return success or errormsg.
    static string updateAcc (account acc, string newCID, string newPID, string pidgroupid, integer OFFC) {
            acc.CID__c=string.valueof(newCID);
            acc.PID__c=string.valueof(newPID);
            acc.PID_GROUP__c=pidgroupid;
            acc.OFFC__c=OFFC;
            system.debug (newPID + ' nnnnnnnnnnnnn  '+ pidgroupid  );
            try {
                update acc;
            } 
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
                return ('The following exception has occurred: ' + e.getMessage());
            }
            return 'Success';
    }
    static output Scenario1 (list<account> acc , string acctID) {       
            
            string newPID;string newCID; string pidgroupid;
            
            string[] PIDcheck = incrementPID (acctID, acc[0].Name) ;
            newPID = PIDcheck[0];
            pidgroupid=PIDcheck[1]; 
            
            newCID = incrementCID(); 
        
            string success = updateAcc (acc[0], newCID , string.valueof(newPID) ,pidgroupid,0   ) ;
            if (success == 'success')   return CreateOutput(null,string.valueof(newPID) ,  newCID,0, pidgroupid  ) ; 
            else return CreateOutput(success,string.valueof(newPID) ,  newCID,0, pidgroupid  ) ; 
    }
    static output Scenario2 (list<account> acc , string acctID,string pid) {
        
            string pidgroupid;string newCID;
        
            list <PID_GROUP__c> pidgroup= [SELECT id FROM PID_GROUP__c  WHERE PID_Number__c=:pid  ] ;
 
            if (pidgroup.size()==1)   {
                pidgroupid = pidgroup[0].id;
            }              
            else  if (pidgroup.size()==0) return CreateOutput('Unknown PID Group',pid,''  ,0 , '') ;
            else if (pidgroup.size()>1)  return CreateOutput('More than 1 PID Group found',pid,''  ,0 , '') ;
            
            newCID = incrementCID();  
            
            AggregateResult[]  aggResults =[SELECT MAX(OFFC__c)offcMax  FROM Account WHERE PID__c= :pid ]; 
            for (AggregateResult ar : aggResults)  {
               system.debug (  'vvvvvvvvvvvvvvvvvv   ' +  ar.get('offcMax')) ;
            }
            integer offc=0;
            if (aggResults[0].get('offcMax') ==null  )  offc=0 ;
            else offc=  integer.valueof(aggResults[0].get('offcMax')) +1 ; 
        
            system.debug('bbbbbbbbb  '  + offc) ;
        
            string success = updateAcc (acc[0],newCID, pid ,pidgroupid,offc  ) ;
            //return success;
            if (success == 'success')  return CreateOutput(null,pid,NewCID  ,offc , pidgroupid) ;
            else return CreateOutput(success,pid,newCID  ,offc , pidgroupid) ;
    }
    static output Scenario3 (list<account> acc , string acctID,string pid, integer offc) {
        
            string pidgroupid;string newCID;
        
            list <PID_GROUP__c> pidgroup= [SELECT id FROM PID_GROUP__c  WHERE PID_Number__c=:pid  ] ;
            if (pidgroup.size()==1)   {
                pidgroupid = pidgroup[0].id;
            }              
            else  if (pidgroup.size()==0) return CreateOutput('Unknown PID Group',pid,''  ,0 , '') ;
            else if (pidgroup.size()>1)  return CreateOutput('More than 1 PID Group found',pid,''  ,0 , '') ;
            
            newCID = incrementCID(); 
            
            list<account> accCheck = [SELECT OFFC__c from account where PID_GROUP__c=:pidgroupid and OFFC__c=:offc  ];
            if (accCheck.size() >0)  return CreateOutput('OFFC already in use.', PID , newCID ,offc ,pidgroupid )   ; 
        
            string success = updateAcc (acc[0], newCID , pid ,pidgroupid,offc  ) ;
            //return success;
            if (success == 'success') return CreateOutput(null,PID ,newCID,offc ,pidgroupid   ) ;
            else return CreateOutput(success,PID ,newCID,offc ,pidgroupid   ) ;
    }
    
    public static output Scenario4 (list<account> acc , string acctID,string cid ) {
        
            string newPID;string newCID; string pidgroupid;
            
            string[] PIDcheck = incrementPID (acctID, acc[0].Name) ;
            newPID = PIDcheck[0];
            pidgroupid=PIDcheck[1];     
        
            string success = updateAcc (acc[0], CID ,  newPID  ,pidgroupid,0  ) ;
            //return success;
            if (success == 'success')  return CreateOutput(null,string.valueof(newPID) ,cid ,0 ,pidgroupid  ) ;
            else return CreateOutput(success,string.valueof(newPID) ,cid ,0 ,pidgroupid  ) ;
    } 

    static output Scenario5  (list<account> acc , string acctID,string cid, string pid ,integer old_offc) {
            
            string pidgroupid;string newCID;
        
            //check if provided PID exists select from pidgroup__c
            list <PID_GROUP__c> pidgroup= [SELECT id , Account_Record__c FROM PID_GROUP__c  WHERE PID_Number__c=:pid  ] ;
            if (pidgroup.size()==1)   {
                pidgroupid = pidgroup[0].id;
            }              
              
            else  if (pidgroup.size()==0) return CreateOutput('Unknown PID Group',pid,''  ,0 , '') ;
            else if (pidgroup.size()>1)  return CreateOutput('More than 1 PID Group found',pid,''  ,0 , '') ;
            
            //check if pidgroup   belongs to the provided acc
            list <PID_GROUP__c> pidgroupOrig= [SELECT id , Account_Record__c FROM PID_GROUP__c  
                                        WHERE Account_Record__c = :acctID];
            
            
             
            //get Max offc for that PID
            AggregateResult[]  aggResults =[SELECT MAX(OFFC__c)offcMax  FROM Account WHERE PID__c= :pid ]; 
            for (AggregateResult ar : aggResults)  {
               system.debug (  'vvvvvvvvvvvvvvvvvv   ' +  ar.get('offcMax')) ;
            }
            integer offc=0;
            if (aggResults[0].get('offcMax') ==null  )  offc=0 ;
            else offc=  integer.valueof(aggResults[0].get('offcMax')) +1 ; 
        
            system.debug('bbbbbbbbbbbbb  '  + offc) ;
            //update account with new PID & max OFFC
            string success = updateAcc (acc[0], CID ,  pid  ,pidgroupid,offc  ) ;
            
            
            if (success == 'success')  {
                if (pidgroupOrig.size()>0 ) {
                    if (pidgroupOrig[0].Account_Record__c == Acctid)  {
                        list <account> nextAcc = [SELECT id from account WHERE PID_GROUP__c = :pidgroupOrig[0].id order by OFFC__c];
                        if (nextAcc.size()==0)       pidgroupOrig[0].Account_Record__c=null;
                        else pidgroupOrig[0].Account_Record__c=nextAcc[0].id;
                    }
                    update pidgroupOrig;
                }
                   
                     
                    return CreateOutput(null, PID  ,cid ,0 ,pidgroupid  ) ;
            }
            else return CreateOutput(success,pid ,cid ,old_offc ,pidgroupid  ) ;
            
            //else returnedOP Failed
    }
    
     static output Scenario6 (list<account> acc , string acctID,string cid, string pid, integer offc) {
        
            string pidgroupid;string newCID;
        
            list <PID_GROUP__c> pidgroup= [SELECT id FROM PID_GROUP__c  WHERE PID_Number__c=:pid  ] ;
            if (pidgroup.size()==1)   {
                pidgroupid = pidgroup[0].id;
            }              
            else  if (pidgroup.size()==0) return CreateOutput('Unknown PID Group',pid,''  ,0 , '') ;
            else if (pidgroup.size()>1)  return CreateOutput('More than 1 PID Group found',pid,''  ,0 , '') ;
           
            list<account> accCheck = [SELECT OFFC__c from account where PID_GROUP__c=:pidgroupid and OFFC__c=:offc  ];
            if (accCheck.size() >0)  return CreateOutput('OFFC already in use.', PID , newCID ,offc ,pidgroupid )   ; 
        
            string success = updateAcc (acc[0],  CID , pid ,pidgroupid,offc  ) ;
            //return success;
            if (success == 'success') return CreateOutput(null,PID , CID,offc ,pidgroupid   ) ;
            else return CreateOutput(success,PID , CID,offc ,pidgroupid   ) ;
    }
    

    
    
}//end global class IIT_PID_CID_check  
    
        //Scenario 1 : only accID
            //get customsetting PID and increment it
            //create new PID_GROUP__c ->fill in Account_Record__c with accountid, PID_Number__c with incremented number
            //update PID custom setting with incremented value          
            //get customsetting CID and increment it
            //update CID custom setting with incremented value 
            //update account.PID_GROUP__c , CID__c, pid__c, OFFC__c=0  //use soql FOR UPDATE
            //return output, .... oStatus="Success." else oStatus="Failed." & oErrorMsg
        
        //Scenario 2 : PID, accID
            //get PIDgroup
            //get customsetting CID and increment it
            //update CID custom setting with incremented value 
            //get SELECT max(OFFC) FROM Account WHERE PIDgroup=PID and increment it
            //update account.PID_GROUP__c , CID__c, pid__c, OFFC__c
            //return output, .... oStatus="Success." else oStatus="Failed." & oErrorMsg
                
        //Scenario 3:PID, OFFC==X, accID
            //get PIDgroup
            //get customsetting CID and increment it
            //update CID custom setting with incremented value 
            //SELECT OFFC from account where PIDgroup=pid and OFFC=X . 
                //if null, use X. 
                //else ERROR
            //update account.PID_GROUP__c , CID__c, pid__c, OFFC__c
            //return output, .... oStatus="Success." else oStatus="Failed." & oErrorMsg
            
        //Scenario 4:  CID , accID, (if OFFC provided, ignore)
            //get customsetting PID and increment it
            //create new PID_GROUP__c ->fill in Account_Record__c with accountid, PID_Number__c with incremented number
            //update PID custom setting with incremented value  
            //update account.PID_GROUP__c , CID__c, pid__c, OFFC__c=0
            //return output, .... oStatus="Success." else oStatus="Failed." & oErrorMsg
            
        //Scenario 5: PID, CID, OFFC, accID
            //get PIDgroup
            //get max OFFC from PIDgroup
            //update acc with new PID, PIDgroup,, maxOFFC +1 
             //return output, .... oStatus="Success." else oStatus="Failed." & oErrorMsg