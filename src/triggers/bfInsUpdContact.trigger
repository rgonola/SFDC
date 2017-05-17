/**********************************************************************
Name: bfInsUpdContact
Copyright © 2012 WK
======================================================
======================================================
Purpose: This Trigger is to copy Standard phone field value to custom phone field.
======================================================
======================================================
History
-----------------------------------------------------------------------
VERSION   AUTHOR            DATE           DETAIL 
1.0       Natesh            23/08/2012     INITIAL DEVELOPMENT 
2.0       Rajesh S Meti     29/08/2012     Added logic to copy Standard Fax field value to custom Fax field.
3.0       Rajesh S Meti     18/09/2012     Review changes and code refinement
***********************************************************************/
trigger bfInsUpdContact on Contact (before insert, before update) {
    Id AMNSFSRecordTypeId=[select Id from RecordType where Name='AM/FS/NS Contact'].Id;
    
    String phoneStandard = '';
    String phoneCustom = '';
    //2.0
    String faxStandard = '';
    String faxCustom = '';
        
    for(Contact ContactItem : Trigger.new){
        if(ContactItem.RecordTypeId == AMNSFSRecordTypeId){
            if(ContactItem.Phone <> null && ContactItem.Phone <> ''){
                phoneStandard = ContactItem.Phone;
                phoneStandard = phoneStandard.replace('(','');
                phoneStandard = phoneStandard.replace(')','');
                phoneStandard = phoneStandard.replace('-','');
                phoneStandard = phoneStandard.replace(' ','');                
                phoneCustom = phoneStandard; 
                if(phoneCustom.length() == 10){
                    ContactItem.Phone__c = phoneCustom;
                }
            }
            
            //2.0
            if(ContactItem.Fax <> null && ContactItem.Fax <> ''){
                faxStandard = ContactItem.Fax;
                faxStandard = faxStandard.replace('(','');
                faxStandard = faxStandard.replace(')','');
                faxStandard = faxStandard.replace('-','');
                faxStandard = faxStandard.replace(' ','');                
                faxCustom= faxStandard;
                if(faxCustom.length() == 10){
                    ContactItem.Custom_Fax__c =faxCustom;
                }
            }
        }
    }
}